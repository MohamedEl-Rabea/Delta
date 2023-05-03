using Business_Logic;
using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class MaintenancePricing : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void RadioButtonListCategories_SelectedIndexChanged(object sender, EventArgs e)
        {
            PanelAllMaintenance.Visible = false;
            PanelErrorMessage.Visible = false;
            txtMaintenanceTitle.Text = "";
            txtClientName.Text = "";
            txtPhoneNumber.Text = "";
            if (RadioButtonListCategories.SelectedIndex == 0)
            {
                txtMaintenanceTitle.Visible = true;
                txtClientName.Visible = false;
                txtPhoneNumber.Visible = false;
            }
            else if (RadioButtonListCategories.SelectedIndex == 1)
            {
                txtMaintenanceTitle.Visible = false;
                txtClientName.Visible = true;
                txtPhoneNumber.Visible = false;
            }
            else
            {
                txtMaintenanceTitle.Visible = false;
                txtClientName.Visible = false;
                txtPhoneNumber.Visible = true;
            }
        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            PanelAllMaintenance.Visible = false;
            PanelErrorMessage.Visible = false;
            lblSaveMsg.Text = "";


            Maintenance maintenance = new Maintenance();
            if (txtMaintenanceTitle.Visible)
            {
                maintenance.Title = txtMaintenanceTitle.Text;
                if (string.IsNullOrEmpty(txtMaintenanceTitle.Text))
                    PanelErrorMessage.Visible = true;
                else
                    PanelAllMaintenance.Visible = true;
            }
            else if (txtClientName.Visible)
            {
                maintenance.ClientName = txtClientName.Text;
                if (string.IsNullOrEmpty(txtClientName.Text))
                    PanelErrorMessage.Visible = true;
                else
                    PanelAllMaintenance.Visible = true;
            }
            else
            {
                maintenance.PhoneNumber = txtPhoneNumber.Text;
                if (string.IsNullOrEmpty(txtPhoneNumber.Text))
                    PanelErrorMessage.Visible = true;
                else
                {
                    PanelAllMaintenance.Visible = true;
                }
            }

            var data = maintenance.GetAllMaintenance("New");
            ViewState["Maintenance"] = data;

            if (e == null && data.Count == 0)
                GridViewMaintenance.EmptyDataText = "";
            else
                GridViewMaintenance.EmptyDataText = "لا توجد صيانات";

            BindMaintenanceGrid();
        }

        protected void GridViewMaintenance_OnPageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridViewMaintenance.PageIndex = e.NewPageIndex;
            BindMaintenanceGrid();
        }

        private void BindMaintenanceGrid()
        {
            GridViewMaintenance.DataSource = ViewState["Maintenance"];
            GridViewMaintenance.DataBind();
        }

        protected void btnPricing_OnClick(object sender, EventArgs e)
        {
            var gridRow = (GridViewRow)((Button)sender).NamingContainer;
            int rowIndex = gridRow.RowIndex;

            var title = gridRow.Cells[1].Text;
            Maintenance maintenance = new Maintenance();
            maintenance.Id = Convert.ToInt32(gridRow.Cells[0].Text);
            maintenance.Cost = Convert.ToDecimal(((TextBox)GridViewMaintenance.Rows[rowIndex].FindControl("txtCost")).Text);
            maintenance.Price = Convert.ToDecimal(((TextBox)GridViewMaintenance.Rows[rowIndex].FindControl("txtPrice")).Text);

            string m = "";

            if (!maintenance.PriceMaintenance(out m))
            {
                lblSaveMsg.Text = m;
                lblSaveMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                ImageButtonSearch_Click(sender, null);
                lblSaveMsg.Visible = true;
                lblSaveMsg.Text = $"تم تسعير الصيانة ({title}) بتكلفة ({maintenance.Cost}) وسعر بيع ({maintenance.Price}) بنجاح";
                lblSaveMsg.ForeColor = System.Drawing.Color.Green;
            }
        }
    }
}