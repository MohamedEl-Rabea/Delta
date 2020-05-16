using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace Business_Logic
{
    public class Bill_Payments
    {
        public DateTime Pay_Date { get; set; }
        public double Paid_amount { get; set; }
        public string Notes { get; set; }

        public void Add_Bill_Payment(long Bill_ID)
        {
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Add_Bill_Payment", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Bill_ID", SqlDbType.BigInt).Value = Bill_ID;
            cmd.Parameters.Add("@Pay_Date", SqlDbType.SmallDateTime).Value = this.Pay_Date;
            cmd.Parameters.Add("@Paid_Value", SqlDbType.Money).Value = this.Paid_amount;
            cmd.Parameters.Add("@Notes", SqlDbType.NVarChar).Value = this.Notes;
            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
        }

        public void Add_Bill_Payment(long Bill_ID, double Discount)
        {
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Add_Bill_Payment_With_Discount", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Bill_ID", SqlDbType.BigInt).Value = Bill_ID;
            cmd.Parameters.Add("@NewDiscount", SqlDbType.Money).Value = Discount;
            cmd.Parameters.Add("@Pay_Date", SqlDbType.SmallDateTime).Value = this.Pay_Date;
            cmd.Parameters.Add("@Paid_Value", SqlDbType.Money).Value = this.Paid_amount;
            cmd.Parameters.Add("@Notes", SqlDbType.NVarChar).Value = this.Notes;
            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
        }

        public static List<Bill_Payments> Get_Bill_Payments(long Bill_ID)
        {
            List<Bill_Payments> Payments = new List<Bill_Payments>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Bill_Payments", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Bill_ID", SqlDbType.BigInt).Value = Bill_ID;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Bill_Payments payment = new Bill_Payments();
                payment.Pay_Date = Convert.ToDateTime(rdr["Pay_Date"]);
                payment.Paid_amount = Convert.ToDouble(rdr["Paid_Amount"]);
                payment.Notes = rdr["Notes"].ToString();
                Payments.Add(payment);
            }
            rdr.Close();
            con.Close();
            return Payments;
        }
    }
}