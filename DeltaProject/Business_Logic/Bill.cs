using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace Business_Logic
{
    public class Bill
    {
        public long Bill_ID { get; set; }
        public DateTime Bill_Date { get; set; }
        public double Discount { get; set; }
        public byte statue { get; set; }
        public string Client_Name { get; set; }
        public double AdditionalCost { get; set; }
        public string AdditionalCostNotes { get; set; }

        public long Generate_Bill(Client client, double TotalCost, double Paid_Value, string Notes)
        {
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Generate_Bill", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Client_Name", SqlDbType.NVarChar).Value = client.C_name;
            cmd.Parameters.Add("@Address", SqlDbType.NVarChar).Value = client.Address;
            cmd.Parameters.Add("@Bill_Date", SqlDbType.SmallDateTime).Value = this.Bill_Date;
            cmd.Parameters.Add("@TotalCost", SqlDbType.Money).Value = TotalCost;
            cmd.Parameters.Add("@Paid_Value", SqlDbType.Money).Value = Paid_Value;
            cmd.Parameters.Add("@Discount", SqlDbType.SmallMoney).Value = this.Discount;
            cmd.Parameters.Add("@Notes", SqlDbType.NVarChar).Value = Notes;
            cmd.Parameters.Add("@Bill_ID", SqlDbType.BigInt);
            cmd.Parameters.Add("@AdditionalCost", SqlDbType.SmallMoney).Value = this.AdditionalCost;
            cmd.Parameters.Add("@AdditionalCostNotes", SqlDbType.NVarChar).Value = this.AdditionalCostNotes;
            cmd.Parameters["@Bill_ID"].Direction = ParameterDirection.Output;
            con.Open();
            cmd.ExecuteNonQuery();
            long ID = Convert.ToInt64(cmd.Parameters["@Bill_ID"].Value);
            con.Close();
            return ID;
        }

        public bool IsExistsBill()
        {
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("IsExistsBill", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Client_Name", SqlDbType.NVarChar).Value = this.Client_Name;
            con.Open();
            byte result = Convert.ToByte(cmd.ExecuteScalar());
            con.Close();
            return result >= 1;
        }

        public bool IsExistsBillWithID()
        {
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("IsExistsBillWithID", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Bill_ID", SqlDbType.NVarChar).Value = this.Bill_ID;
            con.Open();
            byte result = Convert.ToByte(cmd.ExecuteScalar());
            con.Close();
            return result == 1;
        }

        public static int Get_Paid_Count_By_C_Name(string Client_Name)
        {
            int Count;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Paid_Count_By_C_Name", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Client_Name", SqlDbType.NVarChar).Value = Client_Name;
            con.Open();
            Count = (int)cmd.ExecuteScalar();
            con.Close();
            return Count;
        }

        public static int Get_UnPaid_Count_By_C_Name(string Client_Name)
        {
            int Count;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_UnPaid_Count_By_C_Name", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Client_Name", SqlDbType.NVarChar).Value = Client_Name;
            con.Open();
            Count = (int)cmd.ExecuteScalar();
            con.Close();
            return Count;
        }

        public static List<Bill> Get_All_client_Paid_Bills(int Start_Index, int Max_Rows, string Client_Name)
        {
            List<Bill> Bill_List = new List<Bill>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_All_client_Paid_Bills", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Client_Name", SqlDbType.NVarChar).Value = Client_Name;
            cmd.Parameters.Add("@StartIndex", SqlDbType.Int).Value = Start_Index;
            cmd.Parameters.Add("@MaxRows", SqlDbType.Int).Value = Max_Rows;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Bill bill = new Bill();
                bill.Bill_Date = Convert.ToDateTime(rdr["Bill_Date"]);
                bill.Client_Name = rdr["Client_Name"].ToString();
                bill.Bill_ID = Convert.ToUInt32(rdr["Bill_ID"]);
                Bill_List.Add(bill);
            }
            rdr.Close();
            con.Close();
            return Bill_List;
        }

        public static List<Bill> Get_All_Client_Unpaid_Bills(int Start_Index, int Max_Rows, string Client_Name)
        {
            List<Bill> Bill_List = new List<Bill>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_All_Client_Unpaid_Bills", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Client_Name", SqlDbType.NVarChar).Value = Client_Name;
            cmd.Parameters.Add("@StartIndex", SqlDbType.Int).Value = Start_Index;
            cmd.Parameters.Add("@MaxRows", SqlDbType.Int).Value = Max_Rows;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Bill bill = new Bill();
                bill.Bill_Date = Convert.ToDateTime(rdr["Bill_Date"]);
                bill.Client_Name = rdr["Client_Name"].ToString();
                bill.Bill_ID = Convert.ToUInt32(rdr["Bill_ID"]);
                Bill_List.Add(bill);
            }
            rdr.Close();
            con.Close();
            return Bill_List;
        }

        public Bill Get_Bill_Info(out double Cost, out double Paid_amount)
        {
            Cost = 0;
            Paid_amount = 0;
            Bill bill = new Bill();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Bill_Info", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Bill_ID", SqlDbType.BigInt).Value = this.Bill_ID;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            if (rdr.Read())
            {
                bill.Client_Name = rdr["Client_Name"].ToString();
                bill.Bill_Date = Convert.ToDateTime(rdr["Bill_Date"]);
                bill.Discount = Convert.ToInt32(rdr["Discount"]);
                bill.AdditionalCost = Convert.ToDouble(rdr["Additional_Cost"]);
                bill.AdditionalCostNotes = Convert.ToString(rdr["Notes"]);
                Cost = Convert.ToDouble(rdr["Cost"]);
                Paid_amount = Convert.ToDouble(rdr["Paid_amount"]);
            }
            rdr.Close();
            con.Close();
            return bill;
        }
    }
}