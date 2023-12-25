using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Business_Logic
{
    public class Supplier_Phone
    {
        public int Id { get; set; }
        public string S_name { get; set; }
        public string Phone { get; set; }

        public bool Add_Supplier_Phones(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Add_Supplier_Phones", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@S_Name", SqlDbType.NVarChar).Value = this.S_name;
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

        public bool Update_Supplier_Phone(out string m, string Old_Phone)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Update_Supplier_Phone", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@S_Name", SqlDbType.NVarChar).Value = this.S_name;
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

        public bool Delete_Supplier_Phone(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Delete_Supplier_Phone", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@S_Name", SqlDbType.NVarChar).Value = this.S_name;
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

        public static List<Supplier_Phone> Get_Supplier_Phones(string S_name)
        {
            List<Supplier_Phone> Supplier_Phones = new List<Supplier_Phone>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_supplier_Phones", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@S_Name", SqlDbType.NVarChar).Value = S_name;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Supplier_Phone supplier_phone = new Supplier_Phone();
                supplier_phone.Phone = rdr["Phone"].ToString();
                Supplier_Phones.Add(supplier_phone);
            }
            rdr.Close();
            con.Close();
            return Supplier_Phones;
        }
    }
}