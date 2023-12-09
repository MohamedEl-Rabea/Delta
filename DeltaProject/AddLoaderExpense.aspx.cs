using DeltaProject.Business_Logic;
using System;
using System.Globalization;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class AddLoaderExpense : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ddlLoaders.DataSource = Loader.GetLoaders();
                ddlLoaders.DataBind();
                ddlLoaders.Items.Insert(0, new ListItem("إختر ونش", ""));
                ddlLoaders.SelectedIndex = 0;
            }
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            LoaderExpense loaderExpense = new LoaderExpense();
            loaderExpense.LoaderId = Convert.ToInt32(ddlLoaders.SelectedValue);
            var expenseDate = DateTime.ParseExact(txtDate.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
            loaderExpense.Date = new DateTime(expenseDate.Year, expenseDate.Month, expenseDate.Day,
                DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);
            loaderExpense.Amount = Convert.ToDecimal(txtAmount.Text);
            loaderExpense.Reason = txtReason.Text;

            string m = "";
            if (!loaderExpense.AddExpense(out m))
            {
                lblFinishMsg.Text = "هناك مشكلة في الحفظ برجاء اعادة المحاولة";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblFinishMsg.Text = $"تم حفظ مصروف بقيمة ({loaderExpense.Amount}) للونش ({ddlLoaders.SelectedItem.Text}) بنجاح";
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                ddlLoaders.SelectedIndex = 0;
                txtDate.Text = string.Empty;
                txtAmount.Text = string.Empty;
                txtReason.Text = string.Empty;
            }
        }
    }
}