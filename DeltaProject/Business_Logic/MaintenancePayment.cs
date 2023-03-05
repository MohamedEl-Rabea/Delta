using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Business_Logic
{
    public class MaintenancePayment
    {
        public int Id { get; set; }
        public DateTime PaymentDate { get; set; }
        public decimal PaidAmount { get; set; }

        public bool PayMaintenance(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("PayMaintenance", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@maintenanceId", SqlDbType.Int).Value = Id;
                cmd.Parameters.Add("@paymentDate", SqlDbType.SmallDateTime).Value = PaymentDate;
                cmd.Parameters.Add("@paidAmount", SqlDbType.Money).Value = PaidAmount;
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