using Business_Logic;
using DeltaProject.Business_Logic;
using System;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class Add_Maintenance : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Workshop workshop = new Workshop();
                ddlWorkshops.DataSource = workshop.GetWorkshops();
                ddlWorkshops.DataBind();
                ddlWorkshops.Items.Insert(0, new ListItem("إختر ورشة", ""));
                ddlWorkshops.SelectedIndex = 0;
            }
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            ViewState["C_Name"] = txtClientName.Text;
            Maintenance maintenance = new Maintenance();
            maintenance.PhoneNumber = txtPhoneNumber.Text;
            maintenance.Title = txtTitle.Text;
            maintenance.AgreedCost = Convert.ToDecimal(txtAgreedCost.Text);
            maintenance.ClientName = txtClientName.Text;
            maintenance.WorkshopId = Convert.ToInt32(ddlWorkshops.SelectedValue);
            var orderDate = Convert.ToDateTime(OrderDate.Text);
            maintenance.OrderDate = new DateTime(orderDate.Year, orderDate.Month, orderDate.Day,
                DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);
            var expectedDeliveryDate = Convert.ToDateTime(ExpectedDeliveryDate.Text);
            maintenance.ExpectedDeliveryDate = new DateTime(expectedDeliveryDate.Year, expectedDeliveryDate.Month, expectedDeliveryDate.Day,
                DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);
            maintenance.Description = txtDescription.Text;

            string m = "";
            if (!maintenance.AddMaintenance(out m))
            {
                lblFinishMsg.Text = "هناك مشكلة في الحفظ برجاء اعادة المحاولة";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblFinishMsg.Text = $"تم حفظ صيانة ({maintenance.Title}) للعميل ({maintenance.ClientName}) بنجاح";
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                txtTitle.Text = string.Empty;
                txtAgreedCost.Text = string.Empty;
                txtClientName.Text = string.Empty;
                txtPhoneNumber.Text = string.Empty;
                ddlWorkshops.SelectedIndex = 0;
                OrderDate.Text = string.Empty;
                ExpectedDeliveryDate.Text = string.Empty;
                txtDescription.Text = string.Empty;
            }
        }
    }
}