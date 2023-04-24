using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace DeltaProject.Business_Logic
{
    public class LoaderExpense
    {
        public int Id { get; set; }
        public int LoaderId { get; set; }
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
                SqlCommand cmd = new SqlCommand("AddLoaderExpense", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@loaderId", SqlDbType.Int).Value = LoaderId;
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

        public static List<LoaderExpense> GetExpensesReport(int workshopId, DateTime? startDate, DateTime? endDate)
        {
            List<LoaderExpense> expenses = new List<LoaderExpense>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("GetLoaderExpensesReport", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@loaderId", SqlDbType.Int).Value = workshopId;
            if (startDate.HasValue)
                cmd.Parameters.AddWithValue("@startDate", startDate);
            if (endDate.HasValue)
                cmd.Parameters.AddWithValue("@endDate", endDate);

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                LoaderExpense expense = new LoaderExpense();
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