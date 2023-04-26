using DeltaProject.Business_Logic;
using System;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class AddMaintenanceWithdraw : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ddlWorkshops.DataSource = Workshop.GetWorkshops();
                ddlWorkshops.DataBind();
                ddlWorkshops.Items.Insert(0, new ListItem("إختر ورشة", ""));
                ddlWorkshops.SelectedIndex = 0;
            }
        }

        protected void ddlWorkshops_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            int workshopId = string.IsNullOrEmpty(ddlWorkshops.SelectedValue)
                ? 0
                : Convert.ToInt32(ddlWorkshops.SelectedValue);
            ddlPartners.DataSource = Partner.GetPartners(workshopId);
            ddlPartners.DataBind();
            ddlPartners.Items.Insert(0, new ListItem("إختر شريك", ""));
            ddlPartners.SelectedIndex = 0;
            ddlPartners.Enabled = workshopId != 0;

        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            MaintenanceWithdraw maintenanceWithdraw = new MaintenanceWithdraw();
            maintenanceWithdraw.WorkshopId = Convert.ToInt32(ddlWorkshops.SelectedValue);
            maintenanceWithdraw.PartnerId = Convert.ToInt32(ddlPartners.SelectedValue);
            var withdrawDate = Convert.ToDateTime(txtDate.Text);
            maintenanceWithdraw.Date = new DateTime(withdrawDate.Year, withdrawDate.Month, withdrawDate.Day,
                DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);
            maintenanceWithdraw.Amount = Convert.ToDecimal(txtAmount.Text);
            maintenanceWithdraw.Notes = txtNotes.Text;

            string m = "";
            if (!maintenanceWithdraw.AddWithdraw(out m))
            {
                lblFinishMsg.Text = "هناك مشكلة في الحفظ برجاء اعادة المحاولة";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblFinishMsg.Text = $"تم حفظ سحب بقيمة ({maintenanceWithdraw.Amount}) للورشة ({ddlWorkshops.SelectedItem.Text}) بنجاح";
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                ddlWorkshops.SelectedIndex = 0;
                ddlPartners.SelectedIndex = 0;
                ddlPartners.Enabled = false;
                txtDate.Text = string.Empty;
                txtAmount.Text = string.Empty;
                txtNotes.Text = string.Empty;
            }
        }
    }
}