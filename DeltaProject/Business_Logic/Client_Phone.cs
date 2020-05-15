using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace Business_Logic
{
    public class Client_Phone
    {
        public string C_name { get; set; }
        public string Phone { get; set; }


        public bool Add_Client_Phones(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Add_Client_Phones", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@C_Name", SqlDbType.NVarChar).Value = this.C_name;
                cmd.Parameters.Add("@Phone", SqlDbType.NVarChar).Value = this.Phone;
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }
            catch (Exception ex)
            {
                con.Close();
                m = ex.Message;
                b = false;
            }
            return b;
        }

        public bool Update_Client_Phone(out string m, string Old_Phone)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Update_Client_Phone", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@C_Name", SqlDbType.NVarChar).Value = this.C_name;
                cmd.Parameters.Add("@Old_Phone", SqlDbType.NVarChar).Value = Old_Phone;
                cmd.Parameters.Add("@New_Phone", SqlDbType.NVarChar).Value = this.Phone;
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }
            catch (Exception ex)
            {
                con.Close();
                m = ex.Message;
                b = false;
            }
            return b;
        }

        public bool Delete_Client_Phone(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Delete_Client_Phone", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@C_Name", SqlDbType.NVarChar).Value = this.C_name;
                cmd.Parameters.Add("@Phone", SqlDbType.NVarChar).Value = this.Phone;
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }
            catch (Exception ex)
            {
                con.Close();
                m = ex.Message;
                b = false;
            }
            return b;
        }

        public static List<Client_Phone> Get_Client_Phones(string C_name)
        {
            List<Client_Phone> client_Phones = new List<Client_Phone>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Client_Phones", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@C_Name", SqlDbType.NVarChar).Value = C_name;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Client_Phone client_phone = new Client_Phone();
                client_phone.Phone = rdr["Phone"].ToString();
                client_Phones.Add(client_phone);
            }
            rdr.Close();
            con.Close();
            return client_Phones;
        }
    }
}