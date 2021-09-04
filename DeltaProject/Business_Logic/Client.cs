using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace Business_Logic
{

    public class Client
    {
        public string C_name { get; set; }
        public string Address { get; set; }
        public string Account_Number { get; set; }

        public Client Get_Client_info()
        {
            Client supplier = new Client();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Client_info", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@C_name", SqlDbType.NVarChar).Value = this.C_name;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            if (rdr.Read())
            {
                supplier.C_name = rdr["Client_Name"].ToString();
                supplier.Address = rdr["C_Address"].ToString();
                supplier.Account_Number = Convert.ToString(rdr["Account_Number"]);
            }
            rdr.Close();
            con.Close();
            return supplier;
        }

        public IEnumerable<ClientStatement> GetClientStatement(DateTime? startDate)
        {
            var clientStatementList = new List<ClientStatement>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Client_Statement", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Client_Name", SqlDbType.NVarChar).Value = C_name;
            if(startDate.HasValue)
                cmd.Parameters.AddWithValue("@Start_Date", startDate);
            
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                var clientStatement = new ClientStatement();
                clientStatement.TransactionDate = rdr["TransactionDate"] is DBNull ? (DateTime?)null : Convert.ToDateTime(rdr["TransactionDate"]);
                clientStatement.Debit = Convert.ToDouble(rdr["Debit"]);
                clientStatement.Credit = Convert.ToDouble(rdr["Credit"]);
                clientStatement.Balance = Convert.ToDouble(rdr["Balance"]);
                clientStatement.Statement = rdr["Statement"].ToString();
                clientStatementList.Add(clientStatement);
            }
            rdr.Close();
            con.Close();
            return clientStatementList;
        }

        public bool Update_Client_Info(out string m, string Old_name)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Update_Client_Info", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@OldC_Name", SqlDbType.NVarChar).Value = Old_name;
                cmd.Parameters.Add("@NewC_Name", SqlDbType.NVarChar).Value = this.C_name;
                cmd.Parameters.Add("@Address", SqlDbType.NVarChar).Value = this.Address;
                cmd.Parameters.Add("@Account_Number", SqlDbType.NVarChar).Value = this.Account_Number;
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

        public bool Delete_Client(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Delete_Client", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@C_Name", SqlDbType.NVarChar).Value = this.C_name;
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

    }
}