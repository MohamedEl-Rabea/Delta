using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace DeltaProject.Business_Logic
{
    public class ClientDebtsSchedule
    {
        public int Id { get; set; }
        public string ClientName { get; set; }
        public double DebtValue { get; set; }
        public DateTime ScheduledDate { get; set; }
        public string Description { get; set; }
        public bool Paid { get; set; }

        public bool AddClientSchedule(IEnumerable<ClientDebtsSchedule> debtsSchedules, out string msg)
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

        public static IEnumerable<ClientDebtsSchedule> GetAllOverdueDebts()
        {
            var result = new List<ClientDebtsSchedule>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("GetAllOverdueDebts", con);
            cmd.CommandType = CommandType.StoredProcedure;
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
                result.Add(clientSchedule);
            }
            rdr.Close();
            con.Close();
            return result;
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