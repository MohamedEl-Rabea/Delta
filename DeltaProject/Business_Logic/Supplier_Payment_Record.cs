using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace Business_Logic
{
    public class Supplier_Payment_Record
    {
        public DateTime Pay_Date { get; set; }
        public double Paid_amount { get; set; }
        public string Notes { get; set; }

        public string Get_Supplier_Notes(string S_Name)
        {
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Supplier_Notes", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@S_Name", SqlDbType.NVarChar).Value = S_Name;
            cmd.Parameters.Add("@Date", SqlDbType.Date).Value = this.Pay_Date;
            cmd.Parameters.Add("@Paid_Value", SqlDbType.Money).Value = this.Paid_amount;
            con.Open();
            string Notes = Convert.ToString(cmd.ExecuteScalar());
            con.Close();
            return Notes;
        }

        public bool Add_Supplier_Payment(out string m, string S_name)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Add_Supplier_Payment", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@S_Name", SqlDbType.NVarChar).Value = S_name;
                cmd.Parameters.Add("@Paid_amount", SqlDbType.Money).Value = this.Paid_amount;
                cmd.Parameters.Add("@Pay_Date", SqlDbType.SmallDateTime).Value = this.Pay_Date;
                cmd.Parameters.Add("@Notes", SqlDbType.NVarChar).Value = this.Notes;
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