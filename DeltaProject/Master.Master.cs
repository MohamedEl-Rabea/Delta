using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;

namespace DeltaProject
{
    public partial class Master : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            {
                if (!IsPostBack)
                {
                    if (Convert.ToBoolean(Session["isAuthenticated"]))
                    {
                        if (TrialExpired())
                            Response.Redirect("~/TrialExpired.aspx");
                    }
                    else
                        Response.Redirect("~/Login.aspx");
                }
            }
        }

        private static bool TrialExpired()
        {
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("DateExpired", con);
            cmd.CommandType = CommandType.StoredProcedure;
            con.Open();
            byte result = Convert.ToByte(cmd.ExecuteScalar());
            return result == 1;
        }

        private bool IsExceeded()
        {
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Select top(1) Bill_ID from Bill order by Bill_ID desc", con);
            con.Open();
            int result = Convert.ToInt32(cmd.ExecuteScalar());
            con.Close();
            return result > 200;
        }

        protected void MainDivisionsLNKBTN_Click(object sender, EventArgs e)
        {
            if (ViewState["IsExpanded"] == null)
            {
                TreeViewMainDivisions.CollapseAll();
                ViewState["IsExpanded"] = 1;
            }
            else
            {
                TreeViewMainDivisions.ExpandAll();
                ViewState["IsExpanded"] = null;
            }
        }

        public ImageButton AlertImage
        {
            get
            {
                return this.ImageAlert;
            }
        }

        protected void ImageAlert_Click(object sender, ImageClickEventArgs e)
        {
            Response.Redirect("~/Needs_Report.aspx");
        }

        protected void lnkLogOut_Click(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            FormsAuthentication.RedirectToLoginPage();
        }

        protected void lnkAccountSettings_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Accounts_Settings.aspx");
        }
    }
}