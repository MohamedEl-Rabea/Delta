﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace DeltaProject.Business_Logic
{
    [Serializable]
    public class ClientDebtsSchedule
    {
        public int Id { get; set; }
        public string ClientName { get; set; }
        public double DebtValue { get; set; }
        public DateTime ScheduledDate { get; set; }
        public string Description { get; set; }
        public bool Paid { get; set; }

        public static bool AddClientSchedule(IEnumerable<ClientDebtsSchedule> debtsSchedules, out string msg)
        {
            msg = string.Empty;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("AddClientPaymentSchedule", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@DebtsSchedule", SqlDbType.Structured).Value = ToDataTable(debtsSchedules);
            con.Open();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                msg = ex.Message;
            }
            finally
            {
                con.Close();
            }
            return string.IsNullOrEmpty(msg);
        }

        public bool PayDebt(out string msg)
        {
            msg = string.Empty;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("PayClientDebt", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@DebtId", SqlDbType.Int).Value = Id;
            con.Open();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                msg = ex.Message;
            }
            finally
            {
                con.Close();
            }
            return string.IsNullOrEmpty(msg);
        }

        public bool Delete(out string msg)
        {
            msg = string.Empty;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Delete_Client_Debts_Schedule", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Id;
            con.Open();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                msg = ex.Message;
            }
            finally
            {
                con.Close();
            }
            return string.IsNullOrEmpty(msg);
        }

        public bool Update(out string msg)
        {
            msg = string.Empty;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Update_Client_Debts_Schedule", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Id;
            cmd.Parameters.Add("@DebtValue", SqlDbType.Money).Value = DebtValue;
            cmd.Parameters.Add("@Description", SqlDbType.NVarChar).Value = Description;
            cmd.Parameters.Add("@ScheduledDate", SqlDbType.Date).Value = ScheduledDate;
            con.Open();
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                msg = ex.Message;
            }
            finally
            {
                con.Close();
            }
            return string.IsNullOrEmpty(msg);
        }

        public IEnumerable<ClientDebtsSchedule> GetClientSchedule()
        {
            var result = new List<ClientDebtsSchedule>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("GetClientsDebtsSchedule", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@ClientName", SqlDbType.NVarChar).Value = ClientName;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                var clientSchedule = new ClientDebtsSchedule();
                clientSchedule.Id = Convert.ToInt32(rdr["Id"]);
                clientSchedule.ClientName = Convert.ToString(rdr["ClientName"]);
                clientSchedule.DebtValue = Convert.ToDouble(rdr["DebtValue"]);
                clientSchedule.ScheduledDate = Convert.ToDateTime(rdr["ScheduledDate"]);
                clientSchedule.Description = Convert.ToString(rdr["Description"]);
                clientSchedule.Paid = Convert.ToBoolean(rdr["Paid"]);
                result.Add(clientSchedule);
            }
            rdr.Close();
            con.Close();
            return result;
        }

        public static int Get_All_Debts_Schedule_Count(string Client_Name)
        {
            int Count;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_All_Debts_Schedule_Count", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Client_Name", SqlDbType.NVarChar).Value = Client_Name;
            con.Open();
            Count = (int)cmd.ExecuteScalar();
            con.Close();
            return Count;
        }

        public static List<ClientDebtsSchedule> Get_All_Debts_Schedule(int Start_Index, int Max_Rows, string Client_Name)
        {
            List<ClientDebtsSchedule> scheduleList = new List<ClientDebtsSchedule>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_All_Debts_Schedule", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Client_Name", SqlDbType.NVarChar).Value = Client_Name;
            cmd.Parameters.Add("@StartIndex", SqlDbType.Int).Value = Start_Index;
            cmd.Parameters.Add("@MaxRows", SqlDbType.Int).Value = Max_Rows;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                ClientDebtsSchedule schedule = new ClientDebtsSchedule();
                schedule.Id = Convert.ToInt32(rdr["Id"]);
                schedule.ClientName = rdr["ClientName"].ToString();
                schedule.DebtValue = Convert.ToDouble(rdr["DebtValue"]);
                schedule.ScheduledDate = Convert.ToDateTime(rdr["ScheduledDate"]);
                schedule.Description = Convert.ToString(rdr["Description"]);
                schedule.Paid = Convert.ToBoolean(rdr["Paid"]);
                scheduleList.Add(schedule);
            }
            rdr.Close();
            con.Close();
            return scheduleList;
        }

        public static int Get_All_Not_Paid_Debts_Schedule_Count(string Client_Name)
        {
            int Count;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_All_Not_Paid_Debts_Schedule_Count", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Client_Name", SqlDbType.NVarChar).Value = Client_Name;
            con.Open();
            Count = (int)cmd.ExecuteScalar();
            con.Close();
            return Count;
        }

        public static List<ClientDebtsSchedule> Get_All_Not_Paid_Debts_Schedule(int Start_Index, int Max_Rows, string Client_Name)
        {
            List<ClientDebtsSchedule> scheduleList = new List<ClientDebtsSchedule>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_All_Not_Paid_Debts_Schedule", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Client_Name", SqlDbType.NVarChar).Value = Client_Name;
            cmd.Parameters.Add("@StartIndex", SqlDbType.Int).Value = Start_Index;
            cmd.Parameters.Add("@MaxRows", SqlDbType.Int).Value = Max_Rows;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                ClientDebtsSchedule schedule = new ClientDebtsSchedule();
                schedule.Id = Convert.ToInt32(rdr["Id"]);
                schedule.ClientName = rdr["ClientName"].ToString();
                schedule.DebtValue = Convert.ToDouble(rdr["DebtValue"]);
                schedule.ScheduledDate = Convert.ToDateTime(rdr["ScheduledDate"]);
                schedule.Description = Convert.ToString(rdr["Description"]);
                schedule.Paid = Convert.ToBoolean(rdr["Paid"]);
                scheduleList.Add(schedule);
            }
            rdr.Close();
            con.Close();
            return scheduleList;
        }

        public static int Get_All_Have_To_Pay_Debts_Schedule_Count(string Client_Name)
        {
            int Count;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_All_Have_To_Pay_Debts_Schedule_Count", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Client_Name", SqlDbType.NVarChar).Value = Client_Name;
            con.Open();
            Count = (int)cmd.ExecuteScalar();
            con.Close();
            return Count;
        }

        public static List<ClientDebtsSchedule> Get_All_Have_To_Pay_Debts_Schedule(int Start_Index, int Max_Rows, string Client_Name)
        {
            List<ClientDebtsSchedule> scheduleList = new List<ClientDebtsSchedule>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_All_Have_To_Pay_Debts_Schedule", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Client_Name", SqlDbType.NVarChar).Value = Client_Name;
            cmd.Parameters.Add("@StartIndex", SqlDbType.Int).Value = Start_Index;
            cmd.Parameters.Add("@MaxRows", SqlDbType.Int).Value = Max_Rows;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                ClientDebtsSchedule schedule = new ClientDebtsSchedule();
                schedule.Id = Convert.ToInt32(rdr["Id"]);
                schedule.ClientName = rdr["ClientName"].ToString();
                schedule.DebtValue = Convert.ToDouble(rdr["DebtValue"]);
                schedule.ScheduledDate = Convert.ToDateTime(rdr["ScheduledDate"]);
                schedule.Description = Convert.ToString(rdr["Description"]);
                schedule.Paid = Convert.ToBoolean(rdr["Paid"]);
                scheduleList.Add(schedule);
            }
            rdr.Close();
            con.Close();
            return scheduleList;
        }

        private static DataTable ToDataTable(IEnumerable<ClientDebtsSchedule> debtsSchedules)
        {
            var table = new DataTable();
            table.Columns.Add("ClientName", typeof(string));
            table.Columns.Add("DebtValue", typeof(double));
            table.Columns.Add("ScheduledDate", typeof(DateTime));
            table.Columns.Add("Description", typeof(string));

            foreach (var item in debtsSchedules)
                table.Rows.Add(item.ClientName, item.DebtValue, item.ScheduledDate, item.Description);

            return table;
        }
    }
}