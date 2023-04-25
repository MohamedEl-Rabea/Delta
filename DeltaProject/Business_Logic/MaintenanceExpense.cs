using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace DeltaProject.Business_Logic
{
    public class MaintenanceExpense
    {
        public int Id { get; set; }
        public int WorkshopId { get; set; }
        public DateTime Date { get; set; }
        public decimal Amount { get; set; }
        public string Reason { get; set; }

        public bool AddExpense(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("AddMaintenanceExpense", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@workshopId", SqlDbType.Int).Value = WorkshopId;
                cmd.Parameters.Add("@date", SqlDbType.DateTime).Value = Date;
                cmd.Parameters.Add("@amount", SqlDbType.Decimal).Value = Amount;
                cmd.Parameters.Add("@reason", SqlDbType.NVarChar).Value = Reason;
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

        public static List<MaintenanceExpense> GetExpensesReport(int workshopId, DateTime? startDate, DateTime? endDate)
        {
            List<MaintenanceExpense> expenses = new List<MaintenanceExpense>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("GetMaintenanceExpensesReport", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@workshopId", SqlDbType.Int).Value = workshopId;
            if (startDate.HasValue)
                cmd.Parameters.AddWithValue("@startDate", startDate);
            if (endDate.HasValue)
                cmd.Parameters.AddWithValue("@endDate", endDate);

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                MaintenanceExpense expense = new MaintenanceExpense();
                expense.Id = Convert.ToInt32(rdr["Id"]);
                expense.Date = Convert.ToDateTime(rdr["Date"]);
                expense.Amount = string.IsNullOrEmpty(rdr["Amount"].ToString()) ? 0 : Convert.ToDecimal(rdr["Amount"]);
                expense.Reason = rdr["Reason"].ToString();
                expenses.Add(expense);
            }
            rdr.Close();
            con.Close();
            return expenses;
        }
    }
}