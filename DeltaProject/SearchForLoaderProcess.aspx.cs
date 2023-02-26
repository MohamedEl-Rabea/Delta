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
                ViewState["Processess"] = loaderProcess.GetLoaderProcessWithFilter(startDate, endDate);
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
    }
}