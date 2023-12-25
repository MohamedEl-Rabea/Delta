using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace DeltaProject.Business_Logic
{
    [Serializable]
    public class SupplierPayment
    {
        public int Id { get; set; }
        public int SupplierId { get; set; }
        public decimal PaidAmount { get; set; }
        public DateTime PaymentDate { get; set; }
        public string Notes { get; set; }


        public double? Pay(out string m)
        {
            m = "";
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            try
            {
                SqlCommand cmd = new SqlCommand("AddSupplierPayment", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@supplierId", SqlDbType.Int).Value = SupplierId;
                cmd.Parameters.Add("@paidAmount", SqlDbType.Decimal).Value = PaidAmount;
                cmd.Parameters.Add("@paymentDate", SqlDbType.DateTime).Value = PaymentDate;
                cmd.Parameters.Add("@notes", SqlDbType.NVarChar).Value = Notes;
                con.Open();


                var result = cmd.ExecuteScalar();
                var remainingBalance = string.IsNullOrEmpty(result.ToString()) ? (double?)null : Convert.ToDouble(result);
                con.Close();
                return remainingBalance;
            }
            catch (Exception ex)
            {
                con.Close();
                m = ex.Message;
                return null;
            }
        }
    }
}