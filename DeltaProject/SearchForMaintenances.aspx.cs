using Business_Logic;
using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class SearchForMaintenances : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void RadioButtonListCategories_SelectedIndexChanged(object sender, EventArgs e)
        {
            PanelAllMaintenance.Visible = false;
            PanelErrorMessage.Visible = false;
            txtClientName.Text = "";
            txtPhoneNumber.Text = "";
            if (RadioButtonListCategories.SelectedIndex == 0)
            {
                txtClientName.Visible = true;
                txtPhoneNumber.Visible = false;
            }
            else
            {
                txtClientName.Visible = false;
                txtPhoneNumber.Visible = true;
            }
        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            PanelAllMaintenance.Visible = false;
            PanelErrorMessage.Visible = false;
            PanelMaintenanceDetails.Visible = false;

            Maintenance maintenance = new Maintenance();
            if (txtClientName.Visible)
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

            lnkBtnAllMaintenance_OnClick(sender, null);
        }

        protected void GridViewMaintenance_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Select")
            {
                var gridRow = (GridViewRow)((LinkButton)e.CommandSource).NamingContainer;
                lblTitle.Text = gridRow.Cells[1].Text;
                lblWorkshop.Text = gridRow.Cells[2].Text;
                lblOrderDate.Text = gridRow.Cells[3].Text;
                lblStatus.Text = gridRow.Cells[4].Text;
                lblExpiryWarrantyDate.Text = gridRow.Cells[5].Text;
                lblAgreedCost.Text = gridRow.Cells[6].Text;
                lblRemainingAmount.Text = gridRow.Cells[7].Text;
                lblDescription.Text = gridRow.Cells[8].Text;
                PanelAllMaintenance.Visible = false;
                PanelMaintenanceDetails.Visible = true;
            }
        }

        protected void btnBack_OnClick(object sender, ImageClickEventArgs e)
        {
            ImageButtonSearch_Click(sender, null);
        }

        protected void lnkBtnAllMaintenance_OnClick(object sender, EventArgs e)
        {
            Maintenance maintenance = new Maintenance();
            maintenance.ClientName = txtClientName.Text;
            maintenance.PhoneNumber = txtPhoneNumber.Text;

            GridViewMaintenance.DataSource = maintenance.GetAllMaintenance();
            GridViewMaintenance.DataBind();

            lnkBtnAllMaintenance.ForeColor = System.Drawing.Color.White;
            lnkBtnDeliveredMaintenance.ForeColor = System.Drawing.Color.Black;
            lnkBtnMaintenanceWithRemaining.ForeColor = System.Drawing.Color.Black;
        }

        protected void lnkBtnDeliveredMaintenance_OnClick(object sender, EventArgs e)
        {
            Maintenance maintenance = new Maintenance();
            maintenance.ClientName = txtClientName.Text;
            maintenance.PhoneNumber = txtPhoneNumber.Text;

            GridViewMaintenance.DataSource = maintenance.GetAllMaintenance().Where(m => m.StatusName == "تم استلامه");
            GridViewMaintenance.DataBind();

            lnkBtnAllMaintenance.ForeColor = System.Drawing.Color.Black;
            lnkBtnDeliveredMaintenance.ForeColor = System.Drawing.Color.White;
            lnkBtnMaintenanceWithRemaining.ForeColor = System.Drawing.Color.Black;
        }

        protected void lnkBtnMaintenanceWithRemaining_OnClick(object sender, EventArgs e)
        {
            Maintenance maintenance = new Maintenance();
            maintenance.ClientName = txtClientName.Text;
            maintenance.PhoneNumber = txtPhoneNumber.Text;

            GridViewMaintenance.DataSource = maintenance.GetAllMaintenance().Where(m => m.StatusName == "تم استلامه ويوجد باقى");
            GridViewMaintenance.DataBind();

            lnkBtnAllMaintenance.ForeColor = System.Drawing.Color.Black;
            lnkBtnDeliveredMaintenance.ForeColor = System.Drawing.Color.Black;
            lnkBtnMaintenanceWithRemaining.ForeColor = System.Drawing.Color.White;
        }
    }
}