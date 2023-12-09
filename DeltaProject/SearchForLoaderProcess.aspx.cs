using Business_Logic;
using DeltaProject.Business_Logic;
using System;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class SearchForLoaderProcess : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            PanelAllProcesses.Visible = false;
            PanelLoaderDetails.Visible = false;
            PanelEditLoaderProcess.Visible = false;
            PanelErrorMessage.Visible = false;
            lblFinishMsg.Text = string.Empty;

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
                var id = gridRow.Cells[0].Text;
                lblId.Text = id;
                lblLoaderName.Text = gridRow.Cells[1].Text;
                lblPermissionNumber.Text = gridRow.Cells[2].Text;
                lblClientName.Text = gridRow.Cells[3].Text;
                lblDate.Text = gridRow.Cells[4].Text;
                lblCost.Text = gridRow.Cells[5].Text;
                lblRemainingAmount.Text = gridRow.Cells[6].Text;
                lblDescription.Text = gridRow.Cells[7].Text;
                PanelAllProcesses.Visible = false;
                PanelLoaderDetails.Visible = true;

                LoaderProcess loaderProcess = new LoaderProcess { Id = Convert.ToInt32(id) };
                loaderProcess.GetEditHistory();
                GridViewHistory.DataSource = loaderProcess.History;
                GridViewHistory.DataBind();

                PanelAllProcesses.Visible = false;
                PanelLoaderDetails.Visible = true;
                PanelEditLoaderProcess.Visible = false;
            }
            else if (e.CommandName == "EditLoader")
            {
                var gridRow = (GridViewRow)((LinkButton)e.CommandSource).NamingContainer;
                var paymentCount = Convert.ToInt32(gridRow.Cells[9].Text);
                txtId.Text = gridRow.Cells[0].Text;
                txtPermissionNumber.Text = gridRow.Cells[2].Text;
                txtEditClientName.Text = string.IsNullOrEmpty(txtClientName.Text) ? gridRow.Cells[3].Text : txtClientName.Text;
                txtEditPhoneNumber.Text = gridRow.Cells[8].Text;
                txtCost.Text = gridRow.Cells[5].Text;
                txtPaid.Text = (Convert.ToDecimal(gridRow.Cells[5].Text) - Convert.ToDecimal(gridRow.Cells[6].Text)).ToString();
                date.Text = gridRow.Cells[4].Text;
                txtDescription.Text = gridRow.Cells[7].Text;
                if (paymentCount > 1)
                {
                    txtPaid.Enabled = false;
                }

                var loaders = Loader.GetLoaders();
                ddlLoaders.DataSource = loaders;
                ddlLoaders.DataBind();
                ddlLoaders.Items.Insert(0, new ListItem("إختر ونش", ""));
                ddlLoaders.SelectedValue = gridRow.Cells[10].Text;

                PanelAllProcesses.Visible = false;
                PanelLoaderDetails.Visible = false;
                PanelEditLoaderProcess.Visible = true;
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

        protected void btnSave_Click(object sender, EventArgs e)
        {
            var loaderProcess = new LoaderProcess
            {
                Id = Convert.ToInt32(txtId.Text),
                LoaderId = Convert.ToInt32(ddlLoaders.SelectedValue),
                PermissionNumber = txtPermissionNumber.Text,
                ClientName = txtEditClientName.Text,
                PhoneNumber = txtEditPhoneNumber.Text,
                Cost = Convert.ToDecimal(txtCost.Text),
                Date = Convert.ToDateTime(date.Text),
                Description = txtDescription.Text,
                PaidAmount = txtPaid.Enabled == false ? (decimal?)null : Convert.ToDecimal(txtPaid.Text),
                UserId = Convert.ToInt32(Session["userId"])
            };

            if (!loaderProcess.EditLoaderProcess(out string m))
            {
                lblFinishMsg.Text = "هناك مشكلة في الحفظ برجاء اعادة المحاولة";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblFinishMsg.Text = $"تم حفظ العملية ({loaderProcess.PermissionNumber}) بالونش ({ddlLoaders.SelectedItem.Text}) للعميل ({loaderProcess.ClientName}) بنجاح";
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                ddlLoaders.SelectedIndex = 0;
                txtPermissionNumber.Text = string.Empty;
                txtEditClientName.Text = string.Empty;
                txtEditPhoneNumber.Text = string.Empty;
                txtCost.Text = string.Empty;
                txtPaid.Text = string.Empty;
                date.Text = string.Empty;
                txtDescription.Text = string.Empty;
                PanelAllProcesses.Visible = false;
                PanelLoaderDetails.Visible = false;
                PanelEditLoaderProcess.Visible = false;
            }
        }
    }
}