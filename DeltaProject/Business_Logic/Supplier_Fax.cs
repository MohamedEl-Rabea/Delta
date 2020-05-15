using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace Business_Logic
{
    public class Supplier_Fax
    {
        public string S_name { get; set; }
        public string Fax { get; set; }

        public bool Add_Supplier_Faxs(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Add_Supplier_Faxs", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@S_Name", SqlDbType.NVarChar).Value = this.S_name;
                cmd.Parameters.Add("@Fax", SqlDbType.NVarChar).Value = this.Fax;
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

        public bool Update_Supplier_Fax(out string m, string Old_Fax)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Update_Supplier_Fax", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@S_Name", SqlDbType.NVarChar).Value = this.S_name;
                cmd.Parameters.Add("@Old_Fax", SqlDbType.NVarChar).Value = Old_Fax;
                cmd.Parameters.Add("@New_Fax", SqlDbType.NVarChar).Value = this.Fax;
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

        public bool Delete_Supplier_Fax(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Delete_Supplier_Fax", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@S_Name", SqlDbType.NVarChar).Value = this.S_name;
                cmd.Parameters.Add("@Fax", SqlDbType.NVarChar).Value = this.Fax;
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

        public static List<Supplier_Fax> Get_Supplier_Faxs(string S_name)
        {
            List<Supplier_Fax> Supplier_Faxs = new List<Supplier_Fax>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_supplier_Faxs", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@S_Name", SqlDbType.NVarChar).Value = S_name;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Supplier_Fax supplier_fax = new Supplier_Fax();
                supplier_fax.Fax = rdr["Fax"].ToString();
                Supplier_Faxs.Add(supplier_fax);
            }
            rdr.Close();
            con.Close();
            return Supplier_Faxs;
        }
    }
}