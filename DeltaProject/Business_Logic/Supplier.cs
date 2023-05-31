using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Business_Logic
{
    public class Supplier
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string S_name { get; set; }
        public string Address { get; set; }
        public string Account_Number { get; set; }
        public double RemainingBalance { get; set; }

        public List<Supplier_Phone> Phones { get; set; }
        public List<Supplier_Fax> Faxes { get; set; }

        public Supplier Get_Supplier_info(out double TotalDebts)
        {
            TotalDebts = 0;
            Supplier supplier = new Supplier();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Supplier_info", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@S_name", SqlDbType.NVarChar).Value = this.S_name;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            if (rdr.Read())
            {
                supplier.S_name = rdr["S_Name"].ToString();
                supplier.Address = rdr["S_Address"].ToString();
                supplier.Account_Number = Convert.ToString(rdr["Account_Number"]);
                TotalDebts = Convert.ToDouble(rdr["debts"] is DBNull ? "0" : rdr["debts"]);
            }
            rdr.Close();
            con.Close();
            return supplier;
        }

        public bool Add_Supplier(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Add_Supplier", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@S_Name", SqlDbType.NVarChar).Value = this.S_name;
                cmd.Parameters.Add("@Address", SqlDbType.NVarChar).Value = this.Address;
                cmd.Parameters.Add("@Account_Number", SqlDbType.NVarChar).Value = this.Account_Number;
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

        public bool Update_Supplier_Info(out string m, string Old_name)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Update_Supplier_Info", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@OldS_Name", SqlDbType.NVarChar).Value = Old_name;
                cmd.Parameters.Add("@NewS_Name", SqlDbType.NVarChar).Value = this.S_name;
                cmd.Parameters.Add("@Address", SqlDbType.NVarChar).Value = this.Address;
                cmd.Parameters.Add("@Account_Number", SqlDbType.NVarChar).Value = this.Account_Number;
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

        public bool Delete_Supplier(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Delete_Supplier", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@S_Name", SqlDbType.NVarChar).Value = this.S_name;
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

        #region New

        public static List<Supplier> GetSuppliers()
        {
            List<Supplier> suppliers = new List<Supplier>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("SELECT Id, Name FROM Supplier", con);
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    suppliers.Add(new Supplier { Id = (int)rdr["Id"], Name = rdr["Name"].ToString() });
                }
            }
            return suppliers;
        }

        public Supplier GetSupplierData(int? id, string phoneNumber)
        {
            Supplier supplier = new Supplier { Phones = new List<Supplier_Phone>(), Faxes = new List<Supplier_Fax>() };
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            SqlCommand cmd = new SqlCommand("GetSupplierData", con);
            cmd.CommandType = CommandType.StoredProcedure;

            if (id != 0)
                cmd.Parameters.Add("@id", SqlDbType.Int).Value = id;
            if (!string.IsNullOrEmpty(phoneNumber))
                cmd.Parameters.Add("@phoneNumber", SqlDbType.NVarChar).Value = phoneNumber;

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            if (rdr.Read())
            {
                supplier.Id = Convert.ToInt32(rdr["Id"]);
                supplier.Name = rdr["Name"].ToString();
                supplier.Address = rdr["Address"].ToString();
                supplier.Account_Number = rdr["AccountNumber"].ToString();
                if (!string.IsNullOrEmpty(rdr["Phone"].ToString()))
                    supplier.Phones.Add(new Supplier_Phone { Phone = rdr["Phone"].ToString() });
                if (!string.IsNullOrEmpty(rdr["Fax"].ToString()))
                    supplier.Faxes.Add(new Supplier_Fax { Fax = rdr["Fax"].ToString() });
            }

            while (rdr.Read())
            {
                if (supplier.Phones.All(p => p.Phone != rdr["Phone"].ToString()) && !string.IsNullOrEmpty(rdr["Phone"].ToString()))
                    supplier.Phones.Add(new Supplier_Phone { Phone = rdr["Phone"].ToString() });
                if (supplier.Faxes.All(p => p.Fax != rdr["Fax"].ToString()) && !string.IsNullOrEmpty(rdr["Fax"].ToString()))
                    supplier.Faxes.Add(new Supplier_Fax { Fax = rdr["Fax"].ToString() });
            }
            rdr.Close();
            con.Close();
            return supplier;
        }

        public static (double?, string) GetRemainingBalance(int id, string phoneNumber)
        {
            double? remainingBalance = null;
            string supplierName = "";
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            SqlCommand cmd = new SqlCommand("GetSupplierRemainingBalance", con);
            cmd.CommandType = CommandType.StoredProcedure;

            if (id != 0)
                cmd.Parameters.Add("@supplierId", SqlDbType.Int).Value = id;
            if (!string.IsNullOrEmpty(phoneNumber))
                cmd.Parameters.Add("@phoneNumber", SqlDbType.NVarChar).Value = phoneNumber;

            con.Open();
            var rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                remainingBalance = string.IsNullOrEmpty(rdr["RemainingBalance"].ToString()) ? (double?)null : Convert.ToDouble(rdr["RemainingBalance"]);
            }
            rdr.NextResult();
            while (rdr.Read())
            {
                supplierName = rdr["SupplierName"].ToString();
            }
            rdr.Close();
            con.Close();
            return (remainingBalance, supplierName);
        }


        #endregion

    }
}