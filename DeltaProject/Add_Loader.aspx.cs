using DeltaProject.Business_Logic;
using System;

namespace DeltaProject
{
    public partial class Add_Loader : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            ViewState["L_Name"] = txtLoaderName.Text;
            Loader loader = new Loader();
            loader.Name = txtLoaderName.Text;
            string m = "";
            if (!loader.Add_Loader(out m))
            {
                lblSaveMsg.Text = m;
                lblSaveMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblSaveMsg.Text = "تم بنجاح";
                lblSaveMsg.ForeColor = System.Drawing.Color.Green;
            }
        }
    }
}