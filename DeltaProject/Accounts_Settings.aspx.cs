using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace DeltaProject
{
    public partial class Accounts_Settings : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
                SqlConnection con = new SqlConnection(CS);
                SqlCommand cmd = new SqlCommand("GetUser", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@User_Name", SqlDbType.NVarChar).Value = HttpContext.Current.User.Identity.Name;
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                if (rdr.Read())
                {
                    txtUser_Name.Text = rdr[0].ToString();
                    ViewState["CurrentPassword"] = rdr[1];
                }
                rdr.Close();
                con.Close();
            }
        }

        protected void BtnUpdate_Click(object sender, EventArgs e)
        {
            if (txtCurrentPassword.Text != ViewState["CurrentPassword"].ToString())
            {
                lblFinishMsg.Text = "الرقم الحالى خطأ لا يمكن التعديل";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else if (HttpContext.Current.User.Identity.Name != txtUser_Name.Text && IsExists(txtUser_Name.Text))
            {
                lblFinishMsg.Text = "هذا المستخدم مسجل لحساب اخر لا يمكن التعديل";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {

                string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
                SqlConnection con = new SqlConnection(CS);
                SqlCommand cmd = new SqlCommand("EditUser", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@OldUser_Name", SqlDbType.NVarChar).Value = HttpContext.Current.User.Identity.Name;
                cmd.Parameters.Add("@NewUser_Name", SqlDbType.NVarChar).Value = txtUser_Name.Text;
                cmd.Parameters.Add("@Password", SqlDbType.NVarChar).Value = txtPassword.Text;
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
                lblFinishMsg.Text = "تم بنجاح";
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
            }
        }

        private bool IsExists(string user_name)
        {
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("CheckUser", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@User_Name", SqlDbType.NVarChar).Value = user_name;
            con.Open();
            int result = (int)cmd.ExecuteScalar();
            con.Close();
            return result == 0;
        }
    }
}