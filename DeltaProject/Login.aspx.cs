﻿using System;
using System.Web.Security;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Net.NetworkInformation;

namespace DeltaProject
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
           
        }

        private static string CheckMac()
        {
            NetworkInterface[] nics = NetworkInterface.GetAllNetworkInterfaces();
            //for each j you can get the MAC
            int j = 0;
            PhysicalAddress address = nics[j].GetPhysicalAddress();
            byte[] bytes = address.GetAddressBytes();
            string mac = "";
            for (int i = 0; i < bytes.Length; i++)
            {
                mac += bytes[i].ToString("X1");
            }
            return mac;
        }

        private static bool DateExpired()
        {
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("DateExpired", con);
            cmd.CommandType = CommandType.StoredProcedure;
            con.Open();
            byte result = Convert.ToByte(cmd.ExecuteScalar());
            return result == 1;
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (AuthenticateUser(txtUserName.Text, txtPassword.Text))
            {
                FormsAuthentication.RedirectFromLoginPage(txtUserName.Text, false);
            }
            else
            {
                lblErrMsg.Text = "اسم المستخدم او الرقم السرى غير صحيح";
            }
        }

        private bool AuthenticateUser(string user_name, string password)
        {
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("AuthenticateUser", con);
            cmd.Parameters.Add("@User_Name", SqlDbType.NVarChar).Value = user_name;
            cmd.Parameters.Add("@Password", SqlDbType.NVarChar).Value = password;
            cmd.CommandType = CommandType.StoredProcedure;
            con.Open();
            byte result = Convert.ToByte(cmd.ExecuteScalar());
            Session["isAuthenticated"] = result == 1;
            Session["ClientChequesCount"] = null;
            Session["SupplierChequesCount"] = null;
            return result == 1;
        }
    }
}