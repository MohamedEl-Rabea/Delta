using DeltaProject.Business_Logic;
using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class InvoiceDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var invoiceId = Request.QueryString["invoiceId"];
                var invoiceDate = Request.QueryString["invoiceDate"];
                var supplierName = Request.QueryString["supplierName"];

                lblInvoiceId.Text = invoiceId;
                lblInvoiceDate.Text = invoiceDate;
                lblInvoiceSupplierName.Text = supplierName;

                var supplierInvoice = new SupplierInvoice { Id = Convert.ToInt32(invoiceId) };
                var invoiceDetails = supplierInvoice.GetInvoiceDetails();
                var cost = invoiceDetails.Products.Sum(c => c.PurchasePrice * c.Quantity);
                var paid = invoiceDetails.Payments.Sum(c => c.PaidAmount);

                lblInvoiceCost.Text = cost.ToString("0.##");
                lblInvoicePaid.Text = paid.ToString("0.##");
                lblInvoiceRemaining.Text = (cost - paid).ToString("0.##");

                GridViewProducts.DataSource = invoiceDetails.Products;
                GridViewProducts.DataBind();

                GridViewPayments.DataSource = invoiceDetails.Payments;
                GridViewPayments.DataBind();
            }
        }


        protected void GridViewProducts_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                var result = HttpUtility.HtmlDecode(HttpUtility.HtmlDecode(e.Row.Cells[2].Text));
                e.Row.Cells[2].Text = string.IsNullOrWhiteSpace(result) ? "--------" : result;
                result = HttpUtility.HtmlDecode(HttpUtility.HtmlDecode(e.Row.Cells[3].Text));
                e.Row.Cells[3].Text = string.IsNullOrWhiteSpace(result) ? "--------" : result;
                result = HttpUtility.HtmlDecode(HttpUtility.HtmlDecode(e.Row.Cells[4].Text));
                e.Row.Cells[4].Text = string.IsNullOrWhiteSpace(result) ? "--------" : result;
            }
        }

        protected void ImageButton2_Click(object sender, ImageClickEventArgs e)
        {
            GeneratePdf(pdfHiddenContentField.Value, $"تفاصيل فاتوره رقم :  [{(Page.Master.FindControl("invoiceId") as HiddenField)?.Value}]");
        }

        private void GeneratePdf(string html, string fileName)
        {
            var renderer = new IronPdf.ChromePdfRenderer();
            renderer.RenderingOptions.MarginTop = 5;
            renderer.RenderingOptions.MarginBottom = 5;
            renderer.RenderingOptions.MarginLeft = 5;
            renderer.RenderingOptions.MarginRight = 5;

            Response.ClearContent();
            Response.ClearHeaders();

            Response.ContentType = "application/pdf";//pdf type

            var binaryData = renderer.RenderHtmlAsPdf(html).BinaryData;

            Response.BinaryWrite(binaryData);

            Response.Flush();
            Response.Close();
        }
    }
}