using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;

namespace DeltaProject.Services
{
    /// <summary>
    /// Summary description for GetNamesService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class GetNamesService : System.Web.Services.WebService
    {
        [WebMethod]
        public List<string> Get_Suppliers_Names(string supplier_name)
        {
            List<string> Suppliers_Names = new List<string>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(CS))
            {
                SqlCommand cmd = new SqlCommand("Get_Suppliers_Names", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@S_Name", SqlDbType.NVarChar).Value = supplier_name;
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    Suppliers_Names.Add(rdr["S_Name"].ToString());
                }
            }
            return Suppliers_Names;
        }

        [WebMethod]
        public List<string> Get_Clients_Names(string Client_Name)
        {
            List<string> Clients_Names = new List<string>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(CS))
            {
                SqlCommand cmd = new SqlCommand("Get_Clients_Names", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@C_Name", SqlDbType.NVarChar).Value = Client_Name;
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    Clients_Names.Add(rdr["Client_Name"].ToString());
                }
            }
            return Clients_Names;
        }

        [WebMethod]
        public List<string> Get_Cheques_Clients_Names(string Client_Name)
        {
            List<string> Clients_Names = new List<string>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(CS))
            {
                SqlCommand cmd = new SqlCommand("Get_Cheques_Clients_Names", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@C_Name", SqlDbType.NVarChar).Value = Client_Name;
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    Clients_Names.Add(rdr["ClientName"].ToString());
                }
            }
            return Clients_Names;
        }

        [WebMethod]
        public List<string> Get_Cheques_Suppliers_Names(string supplier_name)
        {
            List<string> Clients_Names = new List<string>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(CS))
            {
                SqlCommand cmd = new SqlCommand("Get_Cheques_Suppliers_Names", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@S_Name", SqlDbType.NVarChar).Value = supplier_name;
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    Clients_Names.Add(rdr["SupplierName"].ToString());
                }
            }
            return Clients_Names;
        }


        [WebMethod]
        public List<string> Get_Workshops_Names(string workshop_Name)
        {
            List<string> workshops_Names = new List<string>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(CS))
            {
                SqlCommand cmd = new SqlCommand("Get_Workshops_Names", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@name", SqlDbType.NVarChar).Value = workshop_Name;
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    workshops_Names.Add(rdr["Name"].ToString());
                }
            }
            return workshops_Names;
        }
    }
}
