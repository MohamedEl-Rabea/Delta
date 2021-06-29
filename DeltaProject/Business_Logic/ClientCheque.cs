using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
//DeltaProject.

namespace Business_Logic
{
    public class ClientCheque
    {
        public int Id { get; set; }
        public string ClientName { get; set; }
        public DateTime DueDate { get; set; }
        public decimal Value { get; set; }
        public bool Collected { get; set; }
        public string ChequeNumber { get; set; }
        public int AlertBefore { get; set; }
        public string Notes { get; set; }

        public bool Save()
        {
            bool isInserted = true;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("AddClientCheque", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@ClientName", SqlDbType.NVarChar).Value = ClientName;
                cmd.Parameters.Add("@ChequeValue", SqlDbType.Money).Value = Value;
                cmd.Parameters.Add("@DueDate", SqlDbType.SmallDateTime).Value = DueDate;
                cmd.Parameters.Add("@ChequeNumber", SqlDbType.NVarChar).Value = ChequeNumber;
                cmd.Parameters.Add("@AlertBefore", SqlDbType.Int).Value = AlertBefore;
                cmd.Parameters.Add("@Notes", SqlDbType.NVarChar).Value = Notes;
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }
            catch (Exception ex)
            {
                con.Close();
                isInserted = false;
            }
            return isInserted;
        }

        public static List<ClientCheque> GetPaidClientCheques()
        {
            List<ClientCheque> ClientCheques = new List<ClientCheque>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("GetPaidClientCheques", con);
            cmd.CommandType = CommandType.StoredProcedure;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                ClientCheque clientCheque = new ClientCheque();
                clientCheque.ClientName = rdr["ClientName"].ToString();
                clientCheque.Value = Convert.ToDecimal(rdr["ChequeValue"]);
                clientCheque.ChequeNumber = Convert.ToString(rdr["ChequeNumber"]);
                clientCheque.DueDate = Convert.ToDateTime(rdr["DueDate"]);
                ClientCheques.Add(clientCheque);
            }
            rdr.Close();
            con.Close();
            return ClientCheques;
        }

        public static List<ClientCheque> GetUnPaidClientCheques()
        {
            List<ClientCheque> ClientCheques = new List<ClientCheque>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("GetUnPaidClientCheques", con);
            cmd.CommandType = CommandType.StoredProcedure;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                ClientCheque clientCheque = new ClientCheque();
                clientCheque.ClientName = rdr["ClientName"].ToString();
                clientCheque.Value = Convert.ToDecimal(rdr["ChequeValue"]);
                clientCheque.ChequeNumber = Convert.ToString(rdr["ChequeNumber"]);
                clientCheque.DueDate = Convert.ToDateTime(rdr["DueDate"]);
                ClientCheques.Add(clientCheque);
            }
            rdr.Close();
            con.Close();
            return ClientCheques;
        }

        public bool IsExistsChequeNumber(string ChequeNumber)
        {
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("IsExistsClientChequeNumber", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@ChequeNumber", SqlDbType.NVarChar).Value = ChequeNumber;
            con.Open();
            int result = Convert.ToInt32(cmd.ExecuteScalar());
            con.Close();
            return result >= 1;
        }

        public static int Get_PaidClientCheques_Count_By_C_Name(string Client_Name)
        {
            int Count;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_PaidClientCheques_Count_By_C_Name", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Client_Name", SqlDbType.NVarChar).Value = Client_Name;
            con.Open();
            Count = (int)cmd.ExecuteScalar();
            con.Close();
            return Count;
        }

        public static int Get_UnPaidClientCheques_Count_By_C_Name(string Client_Name)
        {
            int Count;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_UnPaidClientCheques_Count_By_C_Name", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Client_Name", SqlDbType.NVarChar).Value = Client_Name;
            con.Open();
            Count = (int)cmd.ExecuteScalar();
            con.Close();
            return Count;
        }

        public static int Get_UpcomingPayableClientCheques_Count_By_C_Name(string Client_Name)
        {
            int Count;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_UpcomingPayableClientCheques_Count_By_C_Name", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Client_Name", SqlDbType.NVarChar).Value = Client_Name;
            con.Open();
            Count = (int)cmd.ExecuteScalar();
            con.Close();
            return Count;
        }

        public bool Update_UnPaidClientCheques_By_Id(int Id)
        {
            bool isUpdated = true;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Update_UnPaidClientCheques_By_Id", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Id;
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }
            catch (Exception ex)
            {
                con.Close();
                isUpdated = false;
            }
            return isUpdated;
        }

        public static List<ClientCheque> Get_All_ClientCheques_Paid(int Start_Index, int Max_Rows, string Client_Name)
        {
            List<ClientCheque> ClientCheques = new List<ClientCheque>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_All_ClientCheques_Paid", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Client_Name", SqlDbType.NVarChar).Value = Client_Name;
            cmd.Parameters.Add("@StartIndex", SqlDbType.Int).Value = Start_Index;
            cmd.Parameters.Add("@MaxRows", SqlDbType.Int).Value = Max_Rows;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                ClientCheque clientCheque = new ClientCheque();
                clientCheque.ClientName = rdr["ClientName"].ToString();
                clientCheque.Value = Convert.ToDecimal(rdr["ChequeValue"]);
                clientCheque.ChequeNumber = Convert.ToString(rdr["ChequeNumber"]);
                clientCheque.DueDate = Convert.ToDateTime(rdr["DueDate"]);
                ClientCheques.Add(clientCheque);

            }
            rdr.Close();
            con.Close();
            return ClientCheques;
        }

        public static List<ClientCheque> Get_All_ClientCheques_Unpaid(int Start_Index, int Max_Rows, string Client_Name)
        {
            List<ClientCheque> ClientCheques = new List<ClientCheque>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_All_ClientCheques_Unpaid", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Client_Name", SqlDbType.NVarChar).Value = Client_Name;
            cmd.Parameters.Add("@StartIndex", SqlDbType.Int).Value = Start_Index;
            cmd.Parameters.Add("@MaxRows", SqlDbType.Int).Value = Max_Rows;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                ClientCheque clientCheque = new ClientCheque();
                clientCheque.Id =Convert.ToInt32(rdr["Id"]);
                clientCheque.ClientName = rdr["ClientName"].ToString();
                clientCheque.Value = Convert.ToDecimal(rdr["ChequeValue"]);
                clientCheque.ChequeNumber = Convert.ToString(rdr["ChequeNumber"]);
                clientCheque.DueDate = Convert.ToDateTime(rdr["DueDate"]);
                ClientCheques.Add(clientCheque);
            }
            rdr.Close();
            con.Close();
            return ClientCheques;
        }

        public static List<ClientCheque> Get_All_ClientCheques_UpcomingPayable(int Start_Index, int Max_Rows, string Client_Name)
        {
            List<ClientCheque> ClientCheques = new List<ClientCheque>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_All_ClientCheques_UpcomingPayable", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Client_Name", SqlDbType.NVarChar).Value = Client_Name;
            cmd.Parameters.Add("@StartIndex", SqlDbType.Int).Value = Start_Index;
            cmd.Parameters.Add("@MaxRows", SqlDbType.Int).Value = Max_Rows;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                ClientCheque clientCheque = new ClientCheque();
                clientCheque.ClientName = rdr["ClientName"].ToString();
                clientCheque.Value = Convert.ToDecimal(rdr["ChequeValue"]);
                clientCheque.ChequeNumber = Convert.ToString(rdr["ChequeNumber"]);
                clientCheque.DueDate = Convert.ToDateTime(rdr["DueDate"]);
                ClientCheques.Add(clientCheque);
            }
            rdr.Close();
            con.Close();
            return ClientCheques;
        }

    }
}