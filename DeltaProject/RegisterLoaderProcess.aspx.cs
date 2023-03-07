using DeltaProject.Business_Logic;
using System;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class RegisterLoaderProcess : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Loader loader = new Loader();
                ddlLoaders.DataSource = loader.GetLoaders();
                ddlLoaders.DataBind();
                ddlLoaders.Items.Insert(0, new ListItem("إختر ونش", ""));
                ddlLoaders.SelectedIndex = 0;
            }
        }

        protected void BtnRegister_Click(object sender, EventArgs e)
        {
            ViewState["C_Name"] = txtClientName.Text;
            LoaderProcess loaderProcess = new LoaderProcess();
            loaderProcess.LoaderId = Convert.ToInt32(ddlLoaders.SelectedValue);
            loaderProcess.PermissionNumber = txtPermissionNumber.Text;
            loaderProcess.ClientName = txtClientName.Text;
            loaderProcess.PhoneNumber = txtPhoneNumber.Text;
            loaderProcess.Cost = Convert.ToDecimal(txtCost.Text);
            loaderProcess.PaidAmount = Convert.ToDecimal(txtPaid.Text);
            loaderProcess.Date = Convert.ToDateTime(date.Text);

            string m = "";
            if (!loaderProcess.RegisterLoaderProcess(out m))
            {
                lblFinishMsg.Text = "هناك مشكلة في الحفظ برجاء اعادة المحاولة";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblFinishMsg.Text = $"تم حفظ العملية ({loaderProcess.PermissionNumber}) بالونش ({ddlLoaders.SelectedItem.Text}) للعميل ({loaderProcess.ClientName}) بنجاح";
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                ddlLoaders.SelectedIndex = 0;
                txtPermissionNumber.Text = string.Empty;
                txtClientName.Text = string.Empty;
                txtPhoneNumber.Text = string.Empty;
                txtCost.Text = string.Empty;
                txtPaid.Text = string.Empty;
                date.Text = string.Empty;
            }
        }
    }
}