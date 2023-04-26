using DeltaProject.Business_Logic;
using System;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class AddMaintenanceExpenses : System.Web.UI.Page
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
            MaintenanceExpense maintenanceExpense = new MaintenanceExpense();
            maintenanceExpense.WorkshopId = Convert.ToInt32(ddlWorkshops.SelectedValue);
            var expenseDate = Convert.ToDateTime(txtDate.Text);
            maintenanceExpense.Date = new DateTime(expenseDate.Year, expenseDate.Month, expenseDate.Day,
                DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);
            maintenanceExpense.Amount = Convert.ToDecimal(txtAmount.Text);
            maintenanceExpense.Reason = txtReason.Text;

            string m = "";
            if (!maintenanceExpense.AddExpense(out m))
            {
                lblFinishMsg.Text = "هناك مشكلة في الحفظ برجاء اعادة المحاولة";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblFinishMsg.Text = $"تم حفظ مصروف بقيمة ({maintenanceExpense.Amount}) للورشة ({ddlWorkshops.SelectedItem.Text}) بنجاح";
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                ddlWorkshops.SelectedIndex = 0;
                txtDate.Text = string.Empty;
                txtAmount.Text = string.Empty;
                txtReason.Text = string.Empty;
            }
        }
    }
}