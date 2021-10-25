using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace DeltaProject.Business_Logic
{
    public class DeltaUser
    {
        public DeltaUser()
        {
            Permissions = new List<string>();
        }

        public int UserId { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public List<string> Permissions { get; set; }
        public bool IsAdmin => Permissions.Any() && Permissions.TrueForAll(p => p == "All");

        public static List<DeltaUser> GetAll()
        {
            var result = new List<DeltaUser>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("GetAllUsers", con);
            cmd.CommandType = CommandType.StoredProcedure;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                var user = new DeltaUser();
                user.UserId = Convert.ToInt32(rdr["ID"]);
                user.UserName = Convert.ToString(rdr["_User_Name"]);
                result.Add(user);
            }
            rdr.Close();
            con.Close();
            return result;
        }

        public bool SetPermissions(out string msg)
        {
            bool b = true;
            msg = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("SaveUserPermissions", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@UserId", SqlDbType.NVarChar).Value = UserId;
                cmd.Parameters.Add("@Permissions", SqlDbType.NVarChar).Value = string.Join(",", Permissions);
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }
            catch (Exception ex)
            {
                con.Close();
                msg = ex.Message;
                b = false;
            }
            return b;
        }

        public void Get_User_Permissions()
        {
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("GetUserPermissions", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@UserId", SqlDbType.NVarChar).Value = UserId;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Permissions.Add(rdr["Name"].ToString());
            }
            rdr.Close();
            con.Close();
        }
    }
}