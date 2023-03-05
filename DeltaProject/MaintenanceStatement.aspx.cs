using Business_Logic;
using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class MaintenanceStatement : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            if (string.IsNullOrEmpty(txtClientName.Text))
            {
                PanelStatement.Visible = false;
                PanelErrorMessage.Visible = true;
            }
            else
            {
                PanelStatement.Visible = true;
                PanelErrorMessage.Visible = false;
                Maintenance maintenance = new Maintenance { ClientName = txtClientName.Text };
                var statmentList = maintenance.GetClientStatement();
                lblClientName.Text = maintenance.ClientName;
                lblBalance.Text = statmentList.LastOrDefault() != null ? statmentList.Last().Balance.ToString() : "0";
                GridViewStatement.DataSource = statmentList;
                GridViewStatement.DataBind();
            }
        }

        protected void GridViewStatement_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                var result = HttpUtility.HtmlDecode(HttpUtility.HtmlDecode(e.Row.Cells[0].Text));
                e.Row.Cells[0].Text = string.IsNullOrWhiteSpace(result) ? "--------" : result;
            }
        }

        protected void ImageButton2_Click(object sender, ImageClickEventArgs e)
        {
            GeneratePdf(pdfHiddenContentField.Value, $"كشف حساب صيانات [{lblClientName.Text}]");
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