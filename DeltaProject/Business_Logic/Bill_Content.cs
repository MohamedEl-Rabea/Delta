using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using DeltaProject.Shared;

namespace Business_Logic
{
    public class Bill_Content
    {
        public string P_name { get; set; }
        public double Purchase_Price { get; set; }
        public double Specified_Price { get; set; }
        public double Sell_Price { get; set; }
        private decimal _amount;
        public decimal amount
        {
            get { return Helpers.GetFormatedDecimal(_amount); }
            set { _amount = value; }
        }
        public bool Add_Bill_Contents(out string m, long Bill_ID, Product product)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Add_Bill_Contents", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@Bill_ID", SqlDbType.BigInt).Value = Bill_ID;
                cmd.Parameters.Add("@P_Name", SqlDbType.NVarChar).Value = product.P_name;
                cmd.Parameters.Add("@Mark", SqlDbType.NVarChar).Value = product.Mark;
                cmd.Parameters.Add("@Style", SqlDbType.NVarChar).Value = product.Style;
                cmd.Parameters.Add("@Inch", SqlDbType.Decimal).Value = product.Inch;
                cmd.Parameters.Add("@Purchase_Price", SqlDbType.Money).Value = product.Purchase_Price;
                cmd.Parameters.Add("@Specified_Price", SqlDbType.Money).Value = product.Specified_Price;
                cmd.Parameters.Add("@Sell_Price", SqlDbType.Money).Value = product.Regulare_Price;
                cmd.Parameters.Add("@Amount", SqlDbType.Decimal).Value = product.Amount;
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

        public static List<Bill_Content> Get_Bill_Items(long Bill_ID)
        {
            List<Bill_Content> items = new List<Bill_Content>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Bill_Items", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Bill_ID", SqlDbType.BigInt).Value = Bill_ID;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Bill_Content item = new Bill_Content();
                item.P_name = rdr["P_Name"].ToString();
                item.Sell_Price = Convert.ToDouble(rdr["Sell_Price"]);
                item.amount = Convert.ToDecimal(rdr["Amount"]);
                items.Add(item);
            }
            rdr.Close();
            con.Close();
            return items;
        }

        public bool Return_Products(out string m, long Bill_ID, string Style, string Inch,  string Mark, string Pro_name, DateTime Return_Date, out double Rest_Of_Money)
        {
            m = "";
            bool b = true;
            Rest_Of_Money = 0;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Return_Products", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@FullProduct_Name", SqlDbType.NVarChar).Value = this.P_name;
                cmd.Parameters.Add("@P_Name", SqlDbType.NVarChar).Value = Pro_name;
                cmd.Parameters.Add("@Mark", SqlDbType.NVarChar).Value = Mark;
                cmd.Parameters.Add("@Style", SqlDbType.NVarChar).Value = Style;
                cmd.Parameters.Add("@Inch", SqlDbType.Decimal).Value = Convert.ToDouble(Inch);
                cmd.Parameters.Add("@Returned_amount", SqlDbType.Decimal).Value = this.amount;
                cmd.Parameters.Add("@Bill_ID", SqlDbType.BigInt).Value = Bill_ID;
                cmd.Parameters.Add("@Return_Date", SqlDbType.SmallDateTime).Value = Return_Date;
                cmd.Parameters.Add("@Rest_Of_Money", SqlDbType.Money);
                cmd.Parameters["@Rest_Of_Money"].Direction = ParameterDirection.Output;
                con.Open();
                cmd.ExecuteNonQuery();
                Rest_Of_Money = Convert.ToDouble(cmd.Parameters["@Rest_Of_Money"].Value);
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