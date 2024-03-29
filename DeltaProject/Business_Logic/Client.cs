﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Business_Logic
{

    [Serializable]
    public class Client
    {
        public string C_name { get; set; }
        public string Address { get; set; }
        public string Account_Number { get; set; }
        public double DebtValue { get; set; }
        public bool ShouldSchedule { get; set; }
        public double ScheduledDebtValue { get; set; }

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

        public static int Get_All_Indebted_Clients_Count(string Client_Name)
        {
            int Count;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_All_Indebted_Clients_Count_By_C_Name", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Client_Name", SqlDbType.NVarChar).Value = Client_Name;
            con.Open();
            Count = (int)cmd.ExecuteScalar();
            con.Close();
            return Count;
        }

        public static List<Client> Get_All_Indebted_Clients(int Start_Index, int Max_Rows, string Client_Name)
        {
            List<Client> clientList = new List<Client>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_All_Indebted_Clients", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Client_Name", SqlDbType.NVarChar).Value = Client_Name;
            cmd.Parameters.Add("@StartIndex", SqlDbType.Int).Value = Start_Index;
            cmd.Parameters.Add("@MaxRows", SqlDbType.Int).Value = Max_Rows;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Client client = new Client();
                client.C_name = Convert.ToString(rdr["Client_Name"]);
                client.Address = rdr["C_Address"].ToString();
                client.DebtValue = Convert.ToDouble(rdr["DebtValue"]);
                client.ShouldSchedule = Convert.ToBoolean(rdr["ShouldSchedule"]);
                clientList.Add(client);
            }
            rdr.Close();
            con.Close();
            return clientList;
        }

        public void Get_Client_Debts_Info()
        {
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Client_Debts_Info", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Client_Name", SqlDbType.NVarChar).Value = C_name;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();

            if (rdr.Read())
            {
                DebtValue = Convert.ToDouble(rdr["TotalDebtValue"]);
                ScheduledDebtValue = Convert.ToDouble(rdr["ScheduledDebtValue"]);
            }

            con.Close();
        }
    }
}