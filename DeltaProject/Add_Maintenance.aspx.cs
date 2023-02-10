using Business_Logic;
using System;
using System.Globalization;

namespace DeltaProject
{
    public partial class Add_Maintenance : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            ViewState["C_Name"] = txtClientName.Text;
            Maintenance maintenance = new Maintenance();
            maintenance.Title = txtTitle.Text;
            maintenance.AgreedCost = Convert.ToDecimal(txtAgreedCost.Text);
            maintenance.ClientName = txtClientName.Text;
            maintenance.WorkshopName = txtWorkshop_Name.Text;
            maintenance.OrderDate = DateTime.ParseExact(OrderDate.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
            maintenance.ExpectedDeliveryDate = DateTime.ParseExact(ExpectedDeliveryDate.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
            maintenance.Description = txtDescription.Text;

            string m = "";
            if (!maintenance.AddMaintenance(out m))
            {
                lblFinishMsg.Text = "هناك مشكلة في الحفظ برجاء اعادة المحاولة";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblFinishMsg.Text = "تم بنجاح";
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                txtTitle.Text = string.Empty;
                txtAgreedCost.Text = string.Empty;
                txtClientName.Text = string.Empty;
                txtWorkshop_Name.Text = string.Empty;
                OrderDate.Text = string.Empty;
                ExpectedDeliveryDate.Text = string.Empty;
                txtDescription.Text = string.Empty;
            }
        }
    }
}