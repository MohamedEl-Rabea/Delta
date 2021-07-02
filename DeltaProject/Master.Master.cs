using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using Business_Logic;

namespace DeltaProject
{
    public partial class Master : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            {
                if (!IsPostBack)
                {
                    if (TrialExpired())
                        Response.Redirect("~/TrialExpired.aspx");

                    if (!Convert.ToBoolean(Session["isAuthenticated"]))
                        Response.Redirect("~/Login.aspx");

                    UpdateChequeMenuItemsNotifications();
                }
            }
        }

        public void UpdateChequeMenuItemsNotifications()
        {
            var supplierChequesCount = Session["SupplierChequesCount"] != null
                                        ? Convert.ToInt32(Session["SupplierChequesCount"])
                                        : SupplierCheque.GetUpcomingPayableSupplierChequesCount();

            var clientChequesCount = Session["ClientChequesCount"] != null
            ? Convert.ToInt32(Session["ClientChequesCount"])
            : ClientCheque.GetUpcomingPayableClientChequesCount();

            var total = supplierChequesCount + clientChequesCount;

            if (total > 0)
            {
                var chequesMenuItem = BarMenu.FindItem("Cheques");
                chequesMenuItem.Text = chequesMenuItem.Text.Substring(0, chequesMenuItem.Text.IndexOf("<span") > 0
                    ? chequesMenuItem.Text.IndexOf("<span")
                    : chequesMenuItem.Text.Length) + "<span class='dot'>" + total + "</span>";
            }

            if (clientChequesCount > 0)
            {
                var clientChequesMenuItem = BarMenu.FindItem("Cheques/ClientCheques");
                clientChequesMenuItem.Text = clientChequesMenuItem.Text.Substring(0, clientChequesMenuItem.Text.IndexOf("<span") > 0
                ? clientChequesMenuItem.Text.IndexOf("<span")
                : clientChequesMenuItem.Text.Length) + "<span class='dot'>" + clientChequesCount + "</span>";
            }

            if (supplierChequesCount > 0)
            {
                var supplierChequesMenuItem = BarMenu.FindItem("Cheques/SupplierCheques");
                supplierChequesMenuItem.Text = supplierChequesMenuItem.Text.Substring(0, supplierChequesMenuItem.Text.IndexOf("<span") > 0
                    ? supplierChequesMenuItem.Text.IndexOf("<span")
                    : supplierChequesMenuItem.Text.Length) + "<span class='dot'>" + supplierChequesCount + "</span>";
            }
        }

        protected void __doPostBack(object sender, EventArgs e)
        {

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