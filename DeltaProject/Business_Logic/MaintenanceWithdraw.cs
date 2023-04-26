using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace DeltaProject.Business_Logic
{
    public class MaintenanceWithdraw
    {
        public int Id { get; set; }
        public int WorkshopId { get; set; }
        public int PartnerId { get; set; }
        public string PartnerName { get; set; }
        public DateTime Date { get; set; }
        public decimal Amount { get; set; }
        public string Notes { get; set; }

        public bool AddWithdraw(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("AddMaintenanceWithdraw", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@workshopId", SqlDbType.Int).Value = WorkshopId;
                cmd.Parameters.Add("@partnerId", SqlDbType.Int).Value = PartnerId;
                cmd.Parameters.Add("@date", SqlDbType.DateTime).Value = Date;
                cmd.Parameters.Add("@amount", SqlDbType.Decimal).Value = Amount;
                cmd.Parameters.Add("@notes", SqlDbType.NVarChar).Value = Notes;
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

        public static List<MaintenanceWithdraw> GetWithdrawsReport(int workshopId, DateTime? startDate, DateTime? endDate)
        {
            List<MaintenanceWithdraw> withdraws = new List<MaintenanceWithdraw>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("GetMaintenanceWithdrawsReport", con);
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
                MaintenanceWithdraw withdraw = new MaintenanceWithdraw();
                withdraw.Id = Convert.ToInt32(rdr["Id"]);
                withdraw.PartnerId = Convert.ToInt32(rdr["PartnerId"]);
                withdraw.PartnerName = rdr["PartnerName"].ToString();
                withdraw.Date = Convert.ToDateTime(rdr["Date"]);
                withdraw.Amount = string.IsNullOrEmpty(rdr["Amount"].ToString()) ? 0 : Convert.ToDecimal(rdr["Amount"]);
                withdraw.Notes = rdr["Notes"].ToString();
                withdraws.Add(withdraw);
            }
            rdr.Close();
            con.Close();
            return withdraws;
        }
    }
}