using Business_Logic;
using System;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class SearchForNotDeliveredMaintenance : System.Web.UI.Page
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
            HideDeliverPanel();
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

            HideDeliverPanel();
            ViewState["Maintenance"] = maintenance.GetAllMaintenance("New");
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

        protected void GridViewMaintenance_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Deliver")
            {
                var gridRow = (GridViewRow)((ImageButton)e.CommandSource).NamingContainer;
                lblTitle.Text = gridRow.Cells[1].Text;
                lblAgreedCost.Text = gridRow.Cells[3].Text;
                txtPaidAmount.Text = gridRow.Cells[3].Text;
                btnSave.Attributes["maintenanceId"] = gridRow.Cells[0].Text;
                PanelAllMaintenance.Visible = false;
                PanelDeliverMaintenance.Visible = true;
            }
        }

        protected void btnSave_OnClick(object sender, EventArgs e)
        {
            ViewState["C_Name"] = txtClientName.Text;
            Maintenance maintenance = new Maintenance();
            var deliveryDate = DateTime.ParseExact(DeliveryDate.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
            maintenance.Id = Convert.ToInt32(btnSave.Attributes["maintenanceId"]);
            maintenance.PaidAmount = Convert.ToDecimal(txtPaidAmount.Text);
            maintenance.DeliveryDate = new DateTime(deliveryDate.Year, deliveryDate.Month, deliveryDate.Day,
                DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);
            var expiryWarrantyDate = CalculateExpiryWarrantyDate(deliveryDate);
            maintenance.ExpiryWarrantyDate = new DateTime(expiryWarrantyDate.Year, expiryWarrantyDate.Month, expiryWarrantyDate.Day,
                DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);

            string m = "";

            if (!maintenance.DeliverMaintenance(out m))
            {
                lblSaveMsg.Text = m;
                lblSaveMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblSaveMsg.Text = "تم بنجاح";
                lblSaveMsg.ForeColor = System.Drawing.Color.Green;
                btnSave.Enabled = false;
                btnSave.BackColor = System.Drawing.Color.FromName("#aaa");
            }
        }

        private void HideDeliverPanel()
        {
            txtPaidAmount.Text = "";
            DeliveryDate.Text = "";
            txtDay.Text = "";
            txtMonth.Text = "";
            txtYear.Text = "";
            lblSaveMsg.Text = "";
            btnSave.Enabled = true;
            btnSave.BackColor = System.Drawing.Color.FromName("#1abc9c");
            PanelDeliverMaintenance.Visible = false;
        }

        private DateTime CalculateExpiryWarrantyDate(DateTime deliveryDate)
        {
            var days = string.IsNullOrEmpty(txtDay.Text) ? 0 : Convert.ToDouble(txtDay.Text);
            var months = string.IsNullOrEmpty(txtMonth.Text) ? 0 : Convert.ToInt32(txtMonth.Text);
            var years = string.IsNullOrEmpty(txtYear.Text) ? 0 : Convert.ToInt32(txtYear.Text);
            var expiryDate = deliveryDate.AddDays(days).AddMonths(months).AddYears(years);

            return expiryDate;
        }

        protected void btnBack_OnClick(object sender, EventArgs e)
        {
            ImageButtonSearch_Click(sender, null);
        }

    }
}