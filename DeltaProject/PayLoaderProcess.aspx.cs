using DeltaProject.Business_Logic;
using System;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class PayLoaderProcess : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            lblSaveMsg.Text = "";

            LoaderProcess loaderProcess = new LoaderProcess
            { ClientName = string.IsNullOrEmpty(txtClientName.Text) ? null : txtClientName.Text };
            DateTime? startDate = string.IsNullOrEmpty(txtStartDate.Text)
                ? null
                : (DateTime?)DateTime.ParseExact(txtStartDate.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
            DateTime? endDate = string.IsNullOrEmpty(txtEndDate.Text)
                ? null
                : (DateTime?)DateTime.ParseExact(txtEndDate.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);

            if (string.IsNullOrEmpty(txtClientName.Text) && string.IsNullOrEmpty(txtStartDate.Text) &&
                string.IsNullOrEmpty(txtEndDate.Text))
            {
                PanelErrorMessage.Visible = true;
                PanelAllProcessess.Visible = false;
            }
            else
            {
                ViewState["Processess"] = loaderProcess.GetLoaderProcessWithFilter(startDate, endDate, true);
                BindLoaderProcessGrid();
                PanelAllProcessess.Visible = true;
                PanelErrorMessage.Visible = false;
            }
        }

        protected void GridViewMaintenance_OnPageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridViewProcessess.PageIndex = e.NewPageIndex;
            BindLoaderProcessGrid();
        }

        private void BindLoaderProcessGrid()
        {
            GridViewProcessess.DataSource = ViewState["Processess"];
            GridViewProcessess.DataBind();
        }

        protected void btnPay_OnClick(object sender, EventArgs e)
        {
            var gridRow = (GridViewRow)((Button)sender).NamingContainer;
            int rowIndex = gridRow.RowIndex;

            LoaderProcess loaderProcess = new LoaderProcess();
            loaderProcess.Id = Convert.ToInt32(gridRow.Cells[0].Text);
            var date = Convert.ToDateTime(((TextBox)GridViewProcessess.Rows[rowIndex].FindControl("txtPaymentDate")).Text);
            loaderProcess.Date = new DateTime(date.Year, date.Month, date.Day,
                DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);
            loaderProcess.PaidAmount = Convert.ToDecimal(((TextBox)GridViewProcessess.Rows[rowIndex].FindControl("txtPaidAmount")).Text);

            var loaderName = gridRow.Cells[1].Text;
            var clientName = gridRow.Cells[3].Text;
            string m = "";

            if (!loaderProcess.PayLoaderProcess(out m))
            {
                lblSaveMsg.Text = m;
                lblSaveMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                ImageButtonSearch_Click(sender, null);
                lblSaveMsg.Visible = true;
                lblSaveMsg.Text = $"تم دفع مبلغ ({loaderProcess.PaidAmount}) على عمليه الونش ({loaderName}) للعميل ({clientName}) بنجاح";
                lblSaveMsg.ForeColor = System.Drawing.Color.Green;
            }
        }
    }
}