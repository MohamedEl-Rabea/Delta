using DeltaProject.Business_Logic;
using System;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class SearchForLoaderProcess : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            PanelAllProcesses.Visible = false;
            PanelLoaderDetails.Visible = false;
            PanelErrorMessage.Visible = false;

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
            }
            else
            {
                ViewState["Processes"] = loaderProcess.GetLoaderProcessWithFilter(startDate, endDate);
                BindLoaderProcessGrid();
                PanelAllProcesses.Visible = true;
            }
        }

        protected void GridViewProcess_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Details")
            {
                var gridRow = (GridViewRow)((LinkButton)e.CommandSource).NamingContainer;
                lblLoaderName.Text = gridRow.Cells[1].Text;
                lblPermissionNumber.Text = gridRow.Cells[2].Text;
                lblClientName.Text = gridRow.Cells[3].Text;
                lblDate.Text = gridRow.Cells[4].Text;
                lblCost.Text = gridRow.Cells[5].Text;
                lblRemainingAmount.Text = gridRow.Cells[6].Text;
                lblDescription.Text = gridRow.Cells[7].Text;
                PanelAllProcesses.Visible = false;
                PanelLoaderDetails.Visible = true;
            }
        }

        protected void GridViewProcess_OnPageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridViewProcess.PageIndex = e.NewPageIndex;
            BindLoaderProcessGrid();
        }

        private void BindLoaderProcessGrid()
        {
            GridViewProcess.DataSource = ViewState["Processes"];
            GridViewProcess.DataBind();
        }

        protected void btnBack_OnClick(object sender, ImageClickEventArgs e)
        {
            ImageButtonSearch_Click(sender, null);
        }
    }
}