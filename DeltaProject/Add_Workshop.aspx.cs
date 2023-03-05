using DeltaProject.Business_Logic;
using System;

namespace DeltaProject
{
    public partial class Add_Workshop : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            ViewState["W_Name"] = txtWorkshop_Name.Text;
            Workshop workshop = new Workshop();
            workshop.Name = txtWorkshop_Name.Text;
            string m = "";
            if (!workshop.Add_Workshop(out m))
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