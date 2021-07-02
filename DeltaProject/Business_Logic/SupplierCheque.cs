using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Business_Logic
{
    public class SupplierCheque
    {
        public int Id { get; set; }
        public string SupplierName { get; set; }
        public DateTime DueDate { get; set; }
        public decimal Value { get; set; }
        public bool PaidOff { get; set; }
        public string ChequeNumber { get; set; }
        public int AlertBefore { get; set; }
        public string Notes { get; set; }

        public bool Create()
        {
            bool isInserted = true;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("AddSupplierCheque", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@SupplierName", SqlDbType.NVarChar).Value = SupplierName;
                cmd.Parameters.Add("@ChequeValue", SqlDbType.Money).Value = Value;
                cmd.Parameters.Add("@DueDate", SqlDbType.SmallDateTime).Value = DueDate;
                cmd.Parameters.Add("@ChequeNumber", SqlDbType.NVarChar).Value = ChequeNumber;
                cmd.Parameters.Add("@AlertBefore", SqlDbType.Int).Value = AlertBefore;
                cmd.Parameters.Add("@Notes", SqlDbType.NVarChar).Value = Notes;
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }
            catch (Exception ex)
            {
                con.Close();
                isInserted = false;
            }
            return isInserted;
        }

        public bool IsExistsChequeNumber(string ChequeNumber)
        {
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("IsExistsSupplierChequeNumber", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@ChequeNumber", SqlDbType.NVarChar).Value = ChequeNumber;
            con.Open();
            int result = Convert.ToInt32(cmd.ExecuteScalar());
            con.Close();
            return result >= 1;
        }

        public static int Get_PaidSupplierCheques_Count_By_C_Name(string Supplier_Name)
        {
            int Count;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_PaidSupplierCheques_Count_By_C_Name", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Supplier_Name", SqlDbType.NVarChar).Value = Supplier_Name;
            con.Open();
            Count = (int)cmd.ExecuteScalar();
            con.Close();
            return Count;
        }

        public static int Get_UnPaidSupplierCheques_Count_By_C_Name(string Supplier_Name)
        {
            int Count;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_UnPaidSupplierCheques_Count_By_C_Name", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Supplier_Name", SqlDbType.NVarChar).Value = Supplier_Name;
            con.Open();
            Count = (int)cmd.ExecuteScalar();
            con.Close();
            return Count;
        }

        public static int Get_UpcomingPayableSupplierCheques_Count_By_C_Name(string Supplier_Name)
        {
            int Count;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_UpcomingPayableSupplierCheques_Count_By_C_Name", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Supplier_Name", SqlDbType.NVarChar).Value = Supplier_Name;
            con.Open();
            Count = (int)cmd.ExecuteScalar();
            con.Close();
            return Count;
        }

        public bool Update_UnPaidSupplierCheques_By_Id(int Id)
        {
            bool isUpdated = true;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Update_UnPaidSupplierCheques_By_Id", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Id;
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }
            catch (Exception ex)
            {
                con.Close();
                isUpdated = false;
            }
            return isUpdated;
        }

        public static List<SupplierCheque> Get_All_SupplierCheques_Paid(int Start_Index, int Max_Rows, string Supplier_Name)
        {
            List<SupplierCheque> SupplierCheques = new List<SupplierCheque>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_All_SupplierCheques_Paid", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Supplier_Name", SqlDbType.NVarChar).Value = Supplier_Name;
            cmd.Parameters.Add("@StartIndex", SqlDbType.Int).Value = Start_Index;
            cmd.Parameters.Add("@MaxRows", SqlDbType.Int).Value = Max_Rows;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                SupplierCheque SupplierCheque = new SupplierCheque();
                SupplierCheque.SupplierName = rdr["SupplierName"].ToString();
                SupplierCheque.Value = Convert.ToDecimal(rdr["ChequeValue"]);
                SupplierCheque.ChequeNumber = Convert.ToString(rdr["ChequeNumber"]);
                SupplierCheque.DueDate = Convert.ToDateTime(rdr["DueDate"]);
                SupplierCheques.Add(SupplierCheque);

            }
            rdr.Close();
            con.Close();
            return SupplierCheques;
        }

        public static List<SupplierCheque> Get_All_SupplierCheques_Unpaid(int Start_Index, int Max_Rows, string Supplier_Name)
        {
            List<SupplierCheque> SupplierCheques = new List<SupplierCheque>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_All_SupplierCheques_Unpaid", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Supplier_Name", SqlDbType.NVarChar).Value = Supplier_Name;
            cmd.Parameters.Add("@StartIndex", SqlDbType.Int).Value = Start_Index;
            cmd.Parameters.Add("@MaxRows", SqlDbType.Int).Value = Max_Rows;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                SupplierCheque SupplierCheque = new SupplierCheque();
                SupplierCheque.Id = Convert.ToInt32(rdr["Id"]);
                SupplierCheque.SupplierName = rdr["SupplierName"].ToString();
                SupplierCheque.Value = Convert.ToDecimal(rdr["ChequeValue"]);
                SupplierCheque.ChequeNumber = Convert.ToString(rdr["ChequeNumber"]);
                SupplierCheque.DueDate = Convert.ToDateTime(rdr["DueDate"]);
                SupplierCheques.Add(SupplierCheque);
            }
            rdr.Close();
            con.Close();
            return SupplierCheques;
        }

        public static List<SupplierCheque> Get_All_SupplierCheques_UpcomingPayable(int Start_Index, int Max_Rows, string Supplier_Name)
        {
            List<SupplierCheque> SupplierCheques = new List<SupplierCheque>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_All_SupplierCheques_UpcomingPayable", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Supplier_Name", SqlDbType.NVarChar).Value = Supplier_Name;
            cmd.Parameters.Add("@StartIndex", SqlDbType.Int).Value = Start_Index;
            cmd.Parameters.Add("@MaxRows", SqlDbType.Int).Value = Max_Rows;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                SupplierCheque SupplierCheque = new SupplierCheque();
                SupplierCheque.SupplierName = rdr["SupplierName"].ToString();
                SupplierCheque.Value = Convert.ToDecimal(rdr["ChequeValue"]);
                SupplierCheque.ChequeNumber = Convert.ToString(rdr["ChequeNumber"]);
                SupplierCheque.DueDate = Convert.ToDateTime(rdr["DueDate"]);
                SupplierCheques.Add(SupplierCheque);
            }
            rdr.Close();
            con.Close();
            return SupplierCheques;
        }

        public static int GetUpcomingPayableSupplierChequesCount()
        {
            int Count;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("GetUpcomingPayableSupplierChequesCount", con);
            cmd.CommandType = CommandType.StoredProcedure;
            con.Open();
            Count = (int)cmd.ExecuteScalar();
            con.Close();
            return Count;
        }
        //ToDO Somthing
        /*TODO: 1- Create complete UI for creating supplier cheque
          TODO: 2- Create method for getting upcoming payable cheques count
          TODO: 3- Implement UI for displaying notifications 
          TODO: 4- Create method for getting upcoming payable cheques info
          TODO: 5- Implement UI for displaying payable cheques info 
        */
    }
}