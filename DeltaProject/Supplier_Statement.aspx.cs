using Business_Logic;
using System;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class Supplier_Statement : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ddlSuppliers.DataSource = Supplier.GetSuppliers();
                ddlSuppliers.DataBind();
                ddlSuppliers.Items.Insert(0, new ListItem("إختر مورد", ""));
                var supplierId = Request.QueryString["supplierId"];

                if (string.IsNullOrEmpty(supplierId))
                    ddlSuppliers.SelectedIndex = 0;
                else
                {
                    ddlSuppliers.SelectedValue = supplierId;
                    ImageButtonSearch_Click(sender, null);
                }
            }
        }

        protected void RadioButtonListCategories_SelectedIndexChanged(object sender, EventArgs e)
        {
            PanelStatementList.Visible = false;
            PanelErrorMessage.Visible = false;
            ddlSuppliers.SelectedIndex = 0;
            txtPhoneNumber.Text = "";
            if (RadioButtonListCategories.SelectedIndex == 0)
            {
                ddlSuppliers.Visible = true;
                txtPhoneNumber.Visible = false;
            }
            else
            {
                ddlSuppliers.Visible = false;
                txtPhoneNumber.Visible = true;
            }
        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            PanelStatementList.Visible = true;
            PanelStatement.Visible = true;
            PanelErrorMessage.Visible = false;
            int? supplierId = string.IsNullOrEmpty(ddlSuppliers.SelectedValue) ? (int?)null : Convert.ToInt32(ddlSuppliers.SelectedValue);
            string phoneNumber = txtPhoneNumber.Text;

            if ((ddlSuppliers.Visible && !supplierId.HasValue) || (txtPhoneNumber.Visible && string.IsNullOrEmpty(phoneNumber)))
            {
                PanelStatementList.Visible = false;
                PanelStatement.Visible = false;
                PanelErrorMessage.Visible = true;
                return;
            }

            string supplierName = ddlSuppliers.SelectedItem.Text;
            DateTime? startDate = string.IsNullOrEmpty(txtStartDate.Text) ? (DateTime?)null : DateTime.ParseExact(txtStartDate.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
            var statementList = SupplierStatement.GetStatement(supplierId, phoneNumber, startDate);
            var balance = statementList.LastOrDefault() != null ? statementList.Last().Balance : 0;

            lblSupplierName.Text = supplierName;
            lblStartDate.Text = startDate.HasValue ? startDate.Value.ToShortDateString() : "شامل";
            lblBalance.Text = balance.ToString("0.##");
            lblBalance.ForeColor = balance < 0 ? Color.Red : Color.Green;
            GridViewStatement.DataSource = statementList;
            GridViewStatement.DataBind();
        }

        protected void GridViewStatement_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && GridViewStatement.DataKeys[e.Row.RowIndex]?.Value is null)
            {
                var result = HttpUtility.HtmlDecode(HttpUtility.HtmlDecode(e.Row.Cells[1].Text));
                e.Row.Cells[1].Text = string.IsNullOrWhiteSpace(result) ? "--------" : result;
                ((LinkButton)e.Row.FindControl("lnkDetails")).Visible = false;
            }
        }

        protected void GridViewStatement_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Details")
            {
                var gridRow = (GridViewRow)((LinkButton)e.CommandSource).NamingContainer;

                Response.Redirect(string.Format("~/InvoiceDetails.aspx?invoiceId={0}&invoiceDate={1}&supplierName={1}",
                    gridRow.Cells[0].Text, gridRow.Cells[1].Text, lblSupplierName.Text));
            }
        }

        protected void ImageButton2_Click(object sender, ImageClickEventArgs e)
        {
            GeneratePdf(pdfHiddenContentField.Value, $"كشف حساب [{ddlSuppliers.SelectedItem.Text}]");
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