using Business_Logic;
using DeltaProject.Business_Logic;
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
            txtClientName.Text = string.Empty;
            txtPhoneNumber.Text = string.Empty;
            lblFinishMsg.Text = string.Empty;
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
            PanelEditMaintenance.Visible = false;
            lblFinishMsg.Text = string.Empty;

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
                var id = gridRow.Cells[0].Text;
                lblId.Text = id;
                lblTitle.Text = gridRow.Cells[1].Text;
                lblWorkshop.Text = gridRow.Cells[2].Text;
                lblOrderDate.Text = gridRow.Cells[3].Text;
                lblStatus.Text = gridRow.Cells[4].Text;
                lblExpiryWarrantyDate.Text = gridRow.Cells[5].Text;
                //lblCost.Text = gridRow.Cells[6].Text;
                lblPrice.Text = gridRow.Cells[7].Text;
                lblRemainingAmount.Text = gridRow.Cells[8].Text;
                lblDescription.Text = gridRow.Cells[9].Text;

                Maintenance maintenance = new Maintenance { Id = Convert.ToInt32(id)};
                maintenance.GetEditHistory();
                GridViewHistory.DataSource = maintenance.History;
                GridViewHistory.DataBind();

                PanelAllMaintenance.Visible = false;
                PanelMaintenanceDetails.Visible = true;
                PanelEditMaintenance.Visible = false;
            }
            else if(e.CommandName == "EditMaintenance")
            {
                var gridRow = (GridViewRow)((LinkButton)e.CommandSource).NamingContainer;
                var paymentCount = Convert.ToInt32(gridRow.Cells[11].Text);
                txtId.Text = gridRow.Cells[0].Text;
                txtTitle.Text = gridRow.Cells[1].Text;
                txtEditClientName.Text = string.IsNullOrEmpty(txtClientName.Text) ? gridRow.Cells[12].Text : txtClientName.Text;
                txtEditPhoneNumber.Text = string.IsNullOrEmpty(txtPhoneNumber.Text) ? gridRow.Cells[13].Text : txtPhoneNumber.Text;
                OrderDate.Text = gridRow.Cells[3].Text;
                txtCost.Text = gridRow.Cells[6].Text;
                txtPrice.Text = gridRow.Cells[7].Text;
                txtPaidAmount.Text = (Convert.ToDecimal(gridRow.Cells[7].Text) - Convert.ToDecimal(gridRow.Cells[8].Text)).ToString();
                txtDescription.Text = gridRow.Cells[9].Text;
                ExpectedDeliveryDate.Text = gridRow.Cells[10].Text;
                if(paymentCount > 1)
                {
                    txtPaidAmount.Enabled = false;
                }

                var workshops = Workshop.GetWorkshops();
                ddlWorkshops.DataSource = workshops;
                ddlWorkshops.DataBind();
                ddlWorkshops.Items.Insert(0, new ListItem("إختر ورشة", ""));
                ddlWorkshops.SelectedValue = gridRow.Cells[14].Text;

                PanelAllMaintenance.Visible = false;
                PanelMaintenanceDetails.Visible = false;
                PanelEditMaintenance.Visible = true;
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

            ViewState["Maintenance"] = maintenance.GetAllMaintenance(null);
            BindMaintenanceGrid();

            lnkBtnAllMaintenance.ForeColor = System.Drawing.Color.White;
            lnkBtnDeliveredMaintenance.ForeColor = System.Drawing.Color.Black;
            lnkBtnMaintenanceWithRemaining.ForeColor = System.Drawing.Color.Black;
        }

        protected void lnkBtnDeliveredMaintenance_OnClick(object sender, EventArgs e)
        {
            Maintenance maintenance = new Maintenance();
            maintenance.ClientName = txtClientName.Text;
            maintenance.PhoneNumber = txtPhoneNumber.Text;

            ViewState["Maintenance"] = maintenance.GetAllMaintenance("Delivered");
            BindMaintenanceGrid();

            lnkBtnAllMaintenance.ForeColor = System.Drawing.Color.Black;
            lnkBtnDeliveredMaintenance.ForeColor = System.Drawing.Color.White;
            lnkBtnMaintenanceWithRemaining.ForeColor = System.Drawing.Color.Black;
        }

        protected void lnkBtnMaintenanceWithRemaining_OnClick(object sender, EventArgs e)
        {
            Maintenance maintenance = new Maintenance();
            maintenance.ClientName = txtClientName.Text;
            maintenance.PhoneNumber = txtPhoneNumber.Text;

            ViewState["Maintenance"] = maintenance.GetAllMaintenance("DeliveredWithRemaining");
            BindMaintenanceGrid();

            lnkBtnAllMaintenance.ForeColor = System.Drawing.Color.Black;
            lnkBtnDeliveredMaintenance.ForeColor = System.Drawing.Color.Black;
            lnkBtnMaintenanceWithRemaining.ForeColor = System.Drawing.Color.White;
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

        protected void btnSave_Click(object sender, EventArgs e)
        {
            var maintenance = new Maintenance
            {
                Id = Convert.ToInt32(txtId.Text),
                Title = txtTitle.Text,
                ClientName = txtEditClientName.Text,
                PhoneNumber = txtEditPhoneNumber.Text,
                OrderDate = Convert.ToDateTime(OrderDate.Text),
                Cost = Convert.ToDecimal(txtCost.Text),
                Price = Convert.ToDecimal(txtPrice.Text),
                PaidAmount = txtPaidAmount.Enabled == false ? (decimal?)null : Convert.ToDecimal(txtPaidAmount.Text),
                Description = txtDescription.Text,
                ExpectedDeliveryDate = Convert.ToDateTime(ExpectedDeliveryDate.Text),
                WorkshopId = Convert.ToInt32(ddlWorkshops.SelectedValue),
                UserId = Convert.ToInt32(Session["userId"])
            };

            if (!maintenance.EditMaintenance(out string m))
            {
                lblFinishMsg.Text = "هناك مشكلة في الحفظ برجاء اعادة المحاولة";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblFinishMsg.Text = $"تم حفظ التعديل على صيانة ({maintenance.Title}) للعميل ({maintenance.ClientName}) بنجاح";
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                txtTitle.Text = string.Empty;
                txtEditClientName.Text = string.Empty;
                txtEditPhoneNumber.Text = string.Empty;
                OrderDate.Text = string.Empty;
                txtCost.Text = string.Empty;
                txtPrice.Text = string.Empty;
                txtPaidAmount.Text = string.Empty;
                txtDescription.Text = string.Empty;
                ExpectedDeliveryDate.Text = string.Empty;
                ddlWorkshops.SelectedIndex = 0;
                PanelAllMaintenance.Visible = false;
                PanelMaintenanceDetails.Visible = false;
                PanelEditMaintenance.Visible = false;
            }
        }
    }
}