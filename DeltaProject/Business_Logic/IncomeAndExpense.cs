using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;

namespace Business_Logic
{
    public class IncomeAndExpense
    {
        public DateTime? Date { get; set; }
        public double Amount { get; set; }
        public string Name { get; set; }

        public static List<IncomeAndExpense> GetReportData(DateTime startDate, DateTime endDate)
        {
            List<IncomeAndExpense> data = new List<IncomeAndExpense>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("GetIncomesAndExpensesReport", con);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@startDate", startDate.Date);
            cmd.Parameters.AddWithValue("@endDate", endDate.Date);

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                var item = new IncomeAndExpense
                {
                    Date = rdr["Date"] is DBNull
                        ? (DateTime?)null
                        : Convert.ToDateTime(rdr["Date"]),
                    Amount = Convert.ToDouble(rdr["Amount"]),
                    Name = rdr["Name"].ToString()
                };
                data.Add(item);
            }
            rdr.Close();
            con.Close();
            return data;
        }
    }
}