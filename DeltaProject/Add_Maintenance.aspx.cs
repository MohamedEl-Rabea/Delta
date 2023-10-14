using Business_Logic;
using DeltaProject.Business_Logic;
using System;
using System.Globalization;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class Add_Maintenance : System.Web.UI.Page
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

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            ViewState["C_Name"] = txtClientName.Text;
            Maintenance maintenance = new Maintenance();
            maintenance.PhoneNumber = txtPhoneNumber.Text;
            maintenance.Title = txtTitle.Text;
            maintenance.ClientName = txtClientName.Text;
            maintenance.WorkshopId = Convert.ToInt32(ddlWorkshops.SelectedValue);
            var orderDate = DateTime.ParseExact(OrderDate.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
            maintenance.OrderDate = new DateTime(orderDate.Year, orderDate.Month, orderDate.Day,
                DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);
            var expectedDeliveryDate = DateTime.ParseExact(ExpectedDeliveryDate.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
            maintenance.ExpectedDeliveryDate = new DateTime(expectedDeliveryDate.Year, expectedDeliveryDate.Month, expectedDeliveryDate.Day,
                DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);
            maintenance.Description = txtDescription.Text;
            maintenance.Cost = txtCost.Text == "" ? (decimal?)null : Convert.ToDecimal(txtCost.Text);
            maintenance.Price = txtPrice.Text == "" ? (decimal?)null : Convert.ToDecimal(txtPrice.Text);

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
                txtClientName.Text = string.Empty;
                txtPhoneNumber.Text = string.Empty;
                ddlWorkshops.SelectedIndex = 0;
                OrderDate.Text = string.Empty;
                ExpectedDeliveryDate.Text = string.Empty;
                txtDescription.Text = string.Empty;
                txtCost.Text = string.Empty;
                txtPrice.Text = string.Empty;
            }
        }
    }
}