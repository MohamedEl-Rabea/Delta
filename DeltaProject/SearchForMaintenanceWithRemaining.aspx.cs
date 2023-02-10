using Business_Logic;
using System;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class SearchForMaintenanceWithRemaining : System.Web.UI.Page
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
            GridViewMaintenance.DataSource = maintenance.GetMaintenanceWithStatus("DeliveredWithRemaining");
            GridViewMaintenance.DataBind();
        }

        protected void GridViewMaintenance_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {

            if (e.CommandName == "Pay")
            {
                var gridRow = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer);
                int rowIndex = gridRow.RowIndex;

                MaintenancePayment maintenancePayment = new MaintenancePayment();
                maintenancePayment.Id = Convert.ToInt32(gridRow.Cells[0].Text);
                var title = gridRow.Cells[1].Text;
                maintenancePayment.PaymentDate = DateTime.ParseExact(((TextBox)GridViewMaintenance.Rows[rowIndex].FindControl("txtPaymentDate")).Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                maintenancePayment.PaidAmount = Convert.ToDecimal(((TextBox)GridViewMaintenance.Rows[rowIndex].FindControl("txtPaidAmount")).Text);

                string m = "";

                if (!maintenancePayment.PayMaintenance(out m))
                {
                    lblSaveMsg.Text = m;
                    lblSaveMsg.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    ImageButtonSearch_Click(sender, null);
                    lblSaveMsg.Visible = true;
                    lblSaveMsg.Text = $"تم دفع مبلغ ({maintenancePayment.PaidAmount}) على صيانة ({title}) بنجاح";
                    lblSaveMsg.ForeColor = System.Drawing.Color.Green;
                }
            }
        }
    }
}