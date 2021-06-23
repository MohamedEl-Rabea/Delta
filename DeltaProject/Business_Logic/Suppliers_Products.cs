using DeltaProject.Shared;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Business_Logic
{
    public class Suppliers_Products
    {
        public string Supplier_Name { get; set; }
        public string Product_Name { get; set; }
        public DateTime Purchase_Date { get; set; }
        public double Price { get; set; }

        private decimal _amount;
        public decimal Amount
        {
            get { return Helpers.GetFormatedDecimal(_amount); }
            set { _amount = value; }
        }
        private decimal _returnedProducts;
        public decimal Returned_Products
        {
            get { return Helpers.GetFormatedDecimal(_returnedProducts); }
            set { _returnedProducts = value; }
        }
        public DateTime Return_Date { get; set; }

        public static List<Suppliers_Products> GetProductsSuppliers(string P_name, string mark, string style, double inch)
        {
            List<Suppliers_Products> Suppliers = new List<Suppliers_Products>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Product_Suppliers", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@P_name", SqlDbType.NVarChar).Value = P_name;
            cmd.Parameters.Add("@Mark", SqlDbType.NVarChar).Value = mark;
            cmd.Parameters.Add("@Style", SqlDbType.NVarChar).Value = style;
            cmd.Parameters.Add("@Inch", SqlDbType.Decimal).Value = inch;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Suppliers_Products supplier = new Suppliers_Products();
                supplier.Supplier_Name = rdr["Supplier_Name"].ToString();
                supplier.Purchase_Date = Convert.ToDateTime(rdr["Purchase_Date"]);
                supplier.Price = Convert.ToDouble(rdr["Price"]);
                supplier.Amount = Convert.ToDecimal(rdr["amount"]);
                Suppliers.Add(supplier);
            }
            rdr.Close();
            con.Close();
            return Suppliers;
        }

        public bool Return_Products_To_Suuplier(out string m, string P_name, string mark, string style, double inch)
        {
            m = "";
            bool b = true;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("SupplierReturnProducts", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@S_Name", SqlDbType.NVarChar).Value = this.Supplier_Name;
                cmd.Parameters.Add("@Product_Name", SqlDbType.NVarChar).Value = P_name;
                cmd.Parameters.Add("@Mark", SqlDbType.NVarChar).Value = mark;
                cmd.Parameters.Add("@Style", SqlDbType.NVarChar).Value = style;
                cmd.Parameters.Add("@Inch", SqlDbType.Decimal).Value = inch;
                cmd.Parameters.Add("@Purchase_Date", SqlDbType.Date).Value = this.Purchase_Date;
                cmd.Parameters.Add("@Return_Date", SqlDbType.SmallDateTime).Value = this.Return_Date;
                cmd.Parameters.Add("@Purchase_Price", SqlDbType.Money).Value = this.Price;
                cmd.Parameters.Add("@Returned_Amount", SqlDbType.Int).Value = this.Returned_Products;
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

        public static List<Suppliers_Products> Get_Product_Suppliers_For_Update_Info(string P_name, double Purchase_Price, string Mark, string Style, double Inch)
        {
            List<Suppliers_Products> Suppliers = new List<Suppliers_Products>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Product_Suppliers_For_Update_Info", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@P_name", SqlDbType.NVarChar).Value = P_name;
            cmd.Parameters.Add("@Mark", SqlDbType.NVarChar).Value = Mark;
            cmd.Parameters.Add("@Inch", SqlDbType.Decimal).Value = Inch;
            cmd.Parameters.Add("@Style", SqlDbType.NVarChar).Value = Style;
            cmd.Parameters.Add("@Purchase_Price", SqlDbType.Money).Value = Purchase_Price;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Suppliers_Products supplier = new Suppliers_Products();
                supplier.Supplier_Name = rdr["Supplier_Name"].ToString();
                supplier.Purchase_Date = Convert.ToDateTime(rdr["Purchase_Date"]);
                supplier.Price = Convert.ToDouble(rdr["Price"]);
                supplier.Amount = Convert.ToInt32(rdr["amount"]);
                supplier.Returned_Products = Convert.ToInt32(rdr["Returned_Products"]);
                supplier.Return_Date = Convert.ToDateTime(rdr["Return_Date"]);
                Suppliers.Add(supplier);
            }
            rdr.Close();
            con.Close();
            return Suppliers;
        }

        public bool Update_Supplier_Products(out string m, string P_name, string Mark, string Style, double Inch, double Purchase_Price, string NewSupplier_Name, DateTime NewPurchase_Date)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Update_Supplier_Products", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@P_Name", SqlDbType.NVarChar).Value = P_name;
                cmd.Parameters.Add("@Mark", SqlDbType.NVarChar).Value = Mark;
                cmd.Parameters.Add("@Style", SqlDbType.NVarChar).Value = Style;
                cmd.Parameters.Add("@Inch", SqlDbType.Decimal).Value = Inch;
                cmd.Parameters.Add("@Price", SqlDbType.Money).Value = Purchase_Price;
                cmd.Parameters.Add("@S_Name", SqlDbType.NVarChar).Value = this.Supplier_Name;
                cmd.Parameters.Add("@Purchase_Date", SqlDbType.Date).Value = this.Purchase_Date;
                cmd.Parameters.Add("@NewS_Name", SqlDbType.NVarChar).Value = NewSupplier_Name;
                cmd.Parameters.Add("@NewPurchase_Date", SqlDbType.Date).Value = NewPurchase_Date;
                cmd.Parameters.Add("@Amount", SqlDbType.Int).Value = this.Amount;
                cmd.Parameters.Add("@Returned_Amount", SqlDbType.Int).Value = this.Returned_Products;
                cmd.Parameters.Add("@Return_Date", SqlDbType.Date).Value = this.Return_Date;
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

        public bool Delete_Supplier_Products_Item(out string m, string P_name, string Mark, string Style, double Inch, double Purchase_Price)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Delete_Supplier_Products_Item", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@P_Name", SqlDbType.NVarChar).Value = P_name;
                cmd.Parameters.Add("@Mark", SqlDbType.NVarChar).Value = Mark;
                cmd.Parameters.Add("@Style", SqlDbType.NVarChar).Value = Style;
                cmd.Parameters.Add("@Inch", SqlDbType.Decimal).Value = Inch;
                cmd.Parameters.Add("@Price", SqlDbType.Money).Value = Purchase_Price;
                cmd.Parameters.Add("@S_Name", SqlDbType.NVarChar).Value = this.Supplier_Name;
                cmd.Parameters.Add("@Purchase_Date", SqlDbType.Date).Value = this.Purchase_Date;
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

        public static List<Suppliers_Products> Get_Specific_Product_Suppliers(string P_name, double Purchase_Price)
        {
            List<Suppliers_Products> Suppliers = new List<Suppliers_Products>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Specific_Product_Suppliers", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@P_name", SqlDbType.NVarChar).Value = P_name;
            cmd.Parameters.Add("@Purchase_Price", SqlDbType.Money).Value = Purchase_Price;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Suppliers_Products supplier = new Suppliers_Products();
                supplier.Supplier_Name = rdr["Supplier_Name"].ToString();
                supplier.Purchase_Date = Convert.ToDateTime(rdr["Purchase_Date"]);
                supplier.Price = Convert.ToDouble(rdr["Price"]);
                supplier.Amount = Convert.ToInt32(rdr["amount"]);
                Suppliers.Add(supplier);
            }
            rdr.Close();
            con.Close();
            return Suppliers;
        }

        public static List<Suppliers_Products> Get_Supplier_Products(string supplier_name)
        {
            List<Suppliers_Products> Supplier_ProductsList = new List<Suppliers_Products>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Supplier_Products", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@S_name", SqlDbType.NVarChar).Value = supplier_name;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Suppliers_Products product = new Suppliers_Products();
                product.Purchase_Date = Convert.ToDateTime(rdr["Purchase_Date"]);
                if (rdr["Mark"].ToString() != "Not found" && rdr["Style"].ToString() == "Not found")
                {
                    product.Product_Name = rdr["P_Name"].ToString() + "- ماركة " + rdr["Mark"].ToString() + "- " + Convert.ToDouble(rdr["Inch"].ToString()) + " بوصه";
                }
                else if (rdr["Style"].ToString() != "Not found")
                {
                    product.Product_Name = rdr["P_Name"].ToString() + "- ماركة " + rdr["Mark"].ToString() + "- " + Convert.ToDouble(rdr["Inch"].ToString()) + " بوصه"
                        + "- طراز" + rdr["Style"].ToString();
                }
                else
                {
                    product.Product_Name = rdr["P_Name"].ToString();
                }
                product.Price = Convert.ToDouble(rdr["Price"]);
                product.Amount = Convert.ToInt32(rdr["Amount"]);
                product.Returned_Products = Convert.ToInt32(rdr["Returned_Products"]);
                product.Return_Date = rdr["Return_Date"] is DBNull ? new DateTime(0001, 01, 01) : Convert.ToDateTime(rdr["Return_Date"]);
                Supplier_ProductsList.Add(product);
            }
            rdr.Close();
            con.Close();
            return Supplier_ProductsList;
        }
    }
}