using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace Business_Logic
{
    public class Expenses_Class
    {
        public DateTime Pay_Date { get; set; }
        public string Category { get; set; }
        public double Paid_Value { get; set; }
        public string Notes { get; set; }

        public bool Add_Expenses(out string m, long Bill_Id = 0)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Add_Expenses", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@Pay_Date", SqlDbType.SmallDateTime).Value = this.Pay_Date;
                cmd.Parameters.Add("@Category", SqlDbType.NVarChar).Value = this.Category;
                cmd.Parameters.Add("@Paid_Value", SqlDbType.SmallMoney).Value = this.Paid_Value;
                cmd.Parameters.Add("@Notes", SqlDbType.NVarChar).Value = this.Notes;
                cmd.Parameters.Add("@Bill_ID", SqlDbType.NVarChar).Value = Bill_Id;
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