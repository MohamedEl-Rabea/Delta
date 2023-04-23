using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;

namespace DeltaProject.Services
{
    /// <summary>
    /// Summary description for GetProductsNames
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class GetProductsNames : System.Web.Services.WebService
    {

        [WebMethod]
        public List<string> Get_Products_Names(string p_name)
        {
            List<string> Products_Names = new List<string>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(CS))
            {
                SqlCommand cmd = new SqlCommand("Get_Products_Names", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@P_Name", SqlDbType.NVarChar).Value = p_name;
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    Products_Names.Add(rdr["P_Name"].ToString());
                }
            }
            return Products_Names;
        }

        [WebMethod]
        public List<string> GetProductNames(string name)
        {
            List<string> ProductsNames = new List<string>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(CS))
            {
                SqlCommand cmd = new SqlCommand("GetProductsNames", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@name", SqlDbType.NVarChar).Value = name;
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    ProductsNames.Add(rdr["Name"].ToString());
                }
            }
            return ProductsNames;
        }


        [WebMethod]
        public List<string> Get_MotorsProducts_Names(string p_name)
        {
            List<string> Products_Names = new List<string>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(CS))
            {
                SqlCommand cmd = new SqlCommand("Get_MotorsProducts_Names", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@P_Name", SqlDbType.NVarChar).Value = p_name;
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    Products_Names.Add(rdr["P_Name"].ToString());
                }
            }
            return Products_Names;
        }

        [WebMethod]
        public List<string> Get_TolProducts_Names(string p_name)
        {
            List<string> Products_Names = new List<string>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(CS))
            {
                SqlCommand cmd = new SqlCommand("Get_TolProducts_Names", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@P_Name", SqlDbType.NVarChar).Value = p_name;
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    Products_Names.Add(rdr["P_Name"].ToString());
                }
            }
            return Products_Names;
        }

        [WebMethod(EnableSession = true)]
        public List<string> Get_Products_Names_Form_Bills(string p_name)
        {
            List<string> Products_Names = new List<string>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(CS))
            {
                SqlCommand cmd = new SqlCommand("Get_Products_Names_Form_Bills", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@P_Name", SqlDbType.NVarChar).Value = p_name;
                cmd.Parameters.Add("@Bill_ID", SqlDbType.BigInt).Value = Convert.ToInt64(Session["Bill_ID"]);
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    Products_Names.Add(rdr["P_Name"].ToString());
                }
            }
            return Products_Names;
        }
    }
}
