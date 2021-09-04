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
    [Serializable] // to store element in ViewState
    public class Product : IEquatable<Product>
    {
        public string P_name { get; set; }
        public double Purchase_Price { get; set; }
        public double Regulare_Price { get; set; }
        public double Special_Price { get; set; }
        private decimal _amount;
        public decimal Amount
        {
            get { return Helpers.GetFormatedDecimal(_amount); }
            set { _amount = value; }
        }
        public string Description { get; set; }
        public string Mark { get; set; }
        public string Style { get; set; }
        public double Inch { get; set; }
        public double Specified_Price { get; set; }
        public bool IsFreeItem { get; set; }

        public List<Suppliers_Products> Suppliers
        {
            get
            {
                return Suppliers_Products.GetProductsSuppliers(this.P_name, this.Mark, this.Style, this.Inch);
            }
        }
        public bool IsCollected { get; set; }


        public Product()
        {
            Mark = "Not found";
            Style = "Not found";
        }

        public bool Equals(Product product)
        {
            return this.P_name == product.P_name && this.Mark == product.Mark && this.Inch == product.Inch && this.Style == product.Style;
        }

        public bool Add_Product(out string m, string Supplier_name, DateTime Purchase_Date)
        {
            m = "";
            bool b = true;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Add_Product", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@S_Name", SqlDbType.NVarChar).Value = Supplier_name;
                cmd.Parameters.Add("@P_Name", SqlDbType.NVarChar).Value = this.P_name;
                cmd.Parameters.Add("@Purchase_Price", SqlDbType.Money).Value = this.Purchase_Price;
                cmd.Parameters.Add("@Regular_Sell_Price", SqlDbType.Money).Value = this.Regulare_Price;
                cmd.Parameters.Add("@Special_Sell_Price", SqlDbType.Money).Value = this.Special_Price;
                cmd.Parameters.Add("@Amount", SqlDbType.Decimal).Value = this.Amount;
                cmd.Parameters.Add("@P_Description", SqlDbType.NVarChar).Value = this.Description;
                cmd.Parameters.Add("@Purchase_Date", SqlDbType.Date).Value = Purchase_Date;
                cmd.Parameters.Add("@Mark", SqlDbType.NVarChar).Value = this.Mark;
                cmd.Parameters.Add("@Style", SqlDbType.NVarChar).Value = this.Style;
                cmd.Parameters.Add("@Inch", SqlDbType.Decimal).Value = this.Inch;
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

        public bool IsValidAmount()
        {
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("IsExists", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@P_Name", SqlDbType.NVarChar).Value = this.P_name;
            cmd.Parameters.Add("@Purchase_Price", SqlDbType.Money).Value = this.Purchase_Price;
            cmd.Parameters.Add("@Wanted_amount", SqlDbType.Decimal).Value = this.Amount;
            con.Open();
            bool result = Convert.ToBoolean(cmd.ExecuteScalar());
            con.Close();
            return result;
        }

        public static bool Add_Supplier_Treatment(out string m, string Supplier_name, DateTime Purchase_Date, double Cost, double Paid_Amount, string Notes)
        {
            m = "";
            bool b = true;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Add_Supplier_Treatment", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@S_Name", SqlDbType.NVarChar).Value = Supplier_name;
                cmd.Parameters.Add("@Products_Cost", SqlDbType.Money).Value = Cost;
                cmd.Parameters.Add("@Paid_Amount", SqlDbType.Money).Value = Paid_Amount;
                cmd.Parameters.Add("@Purchase_Date", SqlDbType.SmallDateTime).Value = Purchase_Date;
                cmd.Parameters.Add("@Notes", SqlDbType.NVarChar).Value = Notes;
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

        public static List<Product> GetProducts(string P_name)
        {
            List<Product> Products = new List<Product>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("GetProductsForUpdateAmount", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@P_name", SqlDbType.NVarChar).Value = P_name;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Product product = new Product();
                product.P_name = rdr["P_Name"].ToString();
                product.Mark = rdr["Mark"].ToString();
                product.Style = rdr["Style"].ToString();
                product.Inch = Convert.ToDouble(rdr["Inch"]);
                product.Special_Price = Convert.ToDouble(rdr["Special_Sell_Orice"]);
                product.Regulare_Price = Convert.ToDouble(rdr["Regular_Sell_Price"]);
                product.Purchase_Price = Convert.ToDouble(rdr["Purchase_Price"]);
                product.Amount = Convert.ToDecimal(rdr["amount"]);
                product.IsCollected = Convert.ToBoolean(rdr["IsCollected"]);
                Products.Add(product);
            }
            rdr.Close();
            con.Close();
            return Products;
        }

        public static List<Product> GetContents(string P_name, double price)
        {
            List<Product> Products = new List<Product>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Contents", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@P_name", SqlDbType.NVarChar).Value = P_name;
            cmd.Parameters.Add("@Purchase_Price", SqlDbType.Money).Value = price;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Product product = new Product();
                product.P_name = rdr["Content_Product"].ToString();
                product.Purchase_Price = Convert.ToDouble(rdr["Content_Price"].ToString());
                product.Amount = Convert.ToDecimal(rdr["Content_amount"]);
                Products.Add(product);
            }
            rdr.Close();
            con.Close();
            return Products;
        }

        public Product Get_Product_For_Update_Amount()
        {
            Product product = new Product();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Product_For_Update_Amount", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@P_name", SqlDbType.NVarChar).Value = this.P_name;
            cmd.Parameters.Add("@Mark", SqlDbType.NVarChar).Value = this.Mark;
            cmd.Parameters.Add("@Style", SqlDbType.NVarChar).Value = this.Style;
            cmd.Parameters.Add("@Inch", SqlDbType.Decimal).Value = this.Inch;
            cmd.Parameters.Add("@Purchase_Price", SqlDbType.Money).Value = this.Purchase_Price;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            if (rdr.Read())
            {
                product.P_name = rdr["P_Name"].ToString();
                product.Mark = rdr["Mark"].ToString();
                product.Style = rdr["Style"].ToString();
                product.Inch = Convert.ToDouble(rdr["Inch"]);
                product.Purchase_Price = Convert.ToDouble(rdr["Purchase_Price"]);
                product.Regulare_Price = Convert.ToDouble(rdr["Regular_Sell_Price"]);
                product.Special_Price = Convert.ToDouble(rdr["Special_Sell_Orice"]);
                product.Amount = Convert.ToDecimal(rdr["amount"]);
            }
            rdr.Close();
            con.Close();
            return product;
        }

        public bool Update_Products_amount(out string m, string Supplier_name, DateTime Purchase_Date)
        {
            m = "";
            bool b = true;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Update_Products_amount", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@S_Name", SqlDbType.NVarChar).Value = Supplier_name;
                cmd.Parameters.Add("@P_Name", SqlDbType.NVarChar).Value = this.P_name;
                cmd.Parameters.Add("@Mark", SqlDbType.NVarChar).Value = this.Mark;
                cmd.Parameters.Add("@Style", SqlDbType.NVarChar).Value = this.Style;
                cmd.Parameters.Add("@Inch", SqlDbType.Decimal).Value = this.Inch;
                cmd.Parameters.Add("@Purchase_Price", SqlDbType.Money).Value = this.Purchase_Price;
                cmd.Parameters.Add("@Amount", SqlDbType.Decimal).Value = this.Amount;
                cmd.Parameters.Add("@Purchase_Date", SqlDbType.Date).Value = Purchase_Date;
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

        public Product Get_Product_For_Update_Info()
        {
            Product product = new Product();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Product_For_Update_Info", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@P_name", SqlDbType.NVarChar).Value = this.P_name;
            cmd.Parameters.Add("@Mark", SqlDbType.NVarChar).Value = this.Mark;
            cmd.Parameters.Add("@Inch", SqlDbType.Decimal).Value = this.Inch;
            cmd.Parameters.Add("@Style", SqlDbType.NVarChar).Value = this.Style;
            cmd.Parameters.Add("@Purchase_Price", SqlDbType.Money).Value = this.Purchase_Price;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            if (rdr.Read())
            {
                product.P_name = rdr["P_Name"].ToString();
                product.Mark = rdr["Mark"].ToString();
                product.Style = rdr["Style"].ToString();
                product.Inch = Convert.ToDouble(rdr["Inch"]);
                product.Purchase_Price = Convert.ToDouble(rdr["Purchase_Price"]);
                product.Regulare_Price = Convert.ToDouble(rdr["Regular_Sell_Price"]);
                product.Special_Price = Convert.ToDouble(rdr["Special_Sell_Orice"]);
                product.Amount = Convert.ToDecimal(rdr["amount"]);
                product.Description = rdr["P_Description"].ToString();
            }
            rdr.Close();
            con.Close();
            return product;
        }

        public bool Update_Products_Info(out string m, string NewP_name, double NewPurchase_Price, string NewMark, string NewStyle, double NewInch)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Update_Products_Info", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@NewP_Name", SqlDbType.NVarChar).Value = NewP_name;
                cmd.Parameters.Add("@NewMark", SqlDbType.NVarChar).Value = NewMark;
                cmd.Parameters.Add("@NewStyle", SqlDbType.NVarChar).Value = NewStyle;
                cmd.Parameters.Add("@NewInch", SqlDbType.Decimal).Value = NewInch;
                cmd.Parameters.Add("@NewPurchase_Price", SqlDbType.Money).Value = NewPurchase_Price;
                cmd.Parameters.Add("@P_Name", SqlDbType.NVarChar).Value = this.P_name;
                cmd.Parameters.Add("@Mark", SqlDbType.NVarChar).Value = this.Mark;
                cmd.Parameters.Add("@Style", SqlDbType.NVarChar).Value = this.Style;
                cmd.Parameters.Add("@Inch", SqlDbType.Decimal).Value = this.Inch;
                cmd.Parameters.Add("@Purchase_Price", SqlDbType.Money).Value = this.Purchase_Price;
                cmd.Parameters.Add("@Regular_Sell_Price", SqlDbType.Money).Value = this.Regulare_Price;
                cmd.Parameters.Add("@Special_Sell_Price", SqlDbType.Money).Value = this.Special_Price;
                cmd.Parameters.Add("@P_Description", SqlDbType.NVarChar).Value = this.Description;
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

        public bool Delete_Product(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Delete_Product", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@P_Name", SqlDbType.NVarChar).Value = this.P_name;
                cmd.Parameters.Add("@Mark", SqlDbType.NVarChar).Value = this.Mark;
                cmd.Parameters.Add("@Style", SqlDbType.NVarChar).Value = this.Style;
                cmd.Parameters.Add("@Inch", SqlDbType.Decimal).Value = this.Inch;
                cmd.Parameters.Add("@Price", SqlDbType.Money).Value = this.Purchase_Price;
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

        public Product Get_Product_info()
        {
            Product product = new Product();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Product_info", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@P_name", SqlDbType.NVarChar).Value = this.P_name;
            cmd.Parameters.Add("@Purchase_Price", SqlDbType.Money).Value = this.Purchase_Price;
            cmd.Parameters.Add("@Mark", SqlDbType.NVarChar).Value = this.Mark;
            cmd.Parameters.Add("@Inch", SqlDbType.Decimal).Value = this.Inch;
            cmd.Parameters.Add("@Style", SqlDbType.NVarChar).Value = this.Style;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            if (rdr.Read())
            {
                product.P_name = rdr["P_Name"].ToString();
                product.Mark = rdr["Mark"].ToString();
                product.Style = rdr["Style"].ToString();
                product.Inch = Convert.ToDouble(rdr["Inch"]);
                product.Purchase_Price = Convert.ToDouble(rdr["Purchase_Price"]);
                product.Regulare_Price = Convert.ToDouble(rdr["Regular_Sell_Price"]);
                product.Special_Price = Convert.ToDouble(rdr["Special_Sell_Orice"]);
                product.Amount = Convert.ToDecimal(rdr["amount"]);
                product.Description = rdr["P_Description"].ToString();
            }
            rdr.Close();
            con.Close();
            return product;
        }

        public static List<Product> Get_Product_Inventory()
        {
            List<Product> Products = new List<Product>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Product_Inventory", con);
            cmd.CommandType = CommandType.StoredProcedure;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Product product = new Product();
                product.P_name = rdr["P_Name"].ToString();
                product.Purchase_Price = Convert.ToDouble(rdr["Purchase_Price"]);
                product.Amount = Convert.ToDecimal(rdr["amount"]);
                Products.Add(product);
            }
            rdr.Close();
            con.Close();
            return Products;
        }

        public static List<Product> Get_Product_InventoryMotors()
        {
            List<Product> Products = new List<Product>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Product_InventoryMotors", con);
            cmd.CommandType = CommandType.StoredProcedure;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Product product = new Product();
                product.P_name = rdr["P_Name"].ToString();
                product.Mark = rdr["Mark"].ToString();
                product.Inch = Convert.ToDouble(rdr["Inch"]);
                product.Purchase_Price = Convert.ToDouble(rdr["Purchase_Price"]);
                product.Amount = Convert.ToDecimal(rdr["amount"]);
                Products.Add(product);
            }
            rdr.Close();
            con.Close();
            return Products;
        }

        public static List<Product> Get_Product_InventoryTol()
        {
            List<Product> Products = new List<Product>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Product_InventoryTol", con);
            cmd.CommandType = CommandType.StoredProcedure;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Product product = new Product();
                product.P_name = rdr["P_Name"].ToString();
                product.Mark = rdr["Mark"].ToString();
                product.Style = rdr["Style"].ToString();
                product.Inch = Convert.ToDouble(rdr["Inch"]);
                product.Purchase_Price = Convert.ToDouble(rdr["Purchase_Price"]);
                product.Amount = Convert.ToDecimal(rdr["amount"]);
                Products.Add(product);
            }
            rdr.Close();
            con.Close();
            return Products;
        }

        public static List<Product> Get_Special_Offer()
        {
            List<Product> Products = new List<Product>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Special_Offer", con);
            cmd.CommandType = CommandType.StoredProcedure;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Product product = new Product();
                product.P_name = rdr["P_Name"].ToString();
                product.Purchase_Price = Convert.ToDouble(rdr["Special_Sell_Orice"]);
                Products.Add(product);
            }
            rdr.Close();
            con.Close();
            return Products;
        }

        public static List<Product> Get_Public_Offer()
        {
            List<Product> Products = new List<Product>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Public_Offer", con);
            cmd.CommandType = CommandType.StoredProcedure;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Product product = new Product();
                product.P_name = rdr["P_Name"].ToString();
                product.Purchase_Price = Convert.ToDouble(rdr["Regular_Sell_Price"]);
                Products.Add(product);
            }
            rdr.Close();
            con.Close();
            return Products;
        }

        public bool Check_amounts(out int Current_amount)
        {
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Check_amounts", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@P_Name", SqlDbType.NVarChar).Value = this.P_name;
            cmd.Parameters.Add("@Purchase_Price", SqlDbType.Money).Value = this.Purchase_Price;
            cmd.Parameters.Add("@Amount", SqlDbType.Decimal).Value = this.Amount;
            cmd.Parameters.Add("@Mark", SqlDbType.NVarChar).Value = this.Mark;
            cmd.Parameters.Add("@Style", SqlDbType.NVarChar).Value = this.Style;
            cmd.Parameters.Add("@Inch", SqlDbType.Decimal).Value = this.Inch;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            Current_amount = 0;
            byte signal = 1;
            if (rdr.Read())
            {
                signal = Convert.ToByte(rdr["Signal"]);
                Current_amount = rdr["amount"] is DBNull ? 0 : Convert.ToInt32(rdr["amount"]);
            }
            rdr.Close();
            con.Close();
            return signal == 1;
        }

        public void Products_Adjustment()
        {
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Products_Adjustment", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@P_Name", SqlDbType.NVarChar).Value = this.P_name;
            cmd.Parameters.Add("@Purchase_Price", SqlDbType.Money).Value = this.Purchase_Price;
            cmd.Parameters.Add("@Mark", SqlDbType.NVarChar).Value = this.Mark;
            cmd.Parameters.Add("@Style", SqlDbType.NVarChar).Value = this.Style;
            cmd.Parameters.Add("@Inch", SqlDbType.Decimal).Value = this.Inch;
            cmd.Parameters.Add("@Amount", SqlDbType.Decimal).Value = this.Amount;
            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
        }

        public static List<Product> Get_Store_Needs()
        {
            List<Product> Products = new List<Product>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Store_Needs", con);
            cmd.CommandType = CommandType.StoredProcedure;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Product product = new Product();
                product.P_name = rdr["P_Name"].ToString();
                product.Mark = rdr["Mark"].ToString();
                product.Style = rdr["Style"].ToString();
                product.Inch = Convert.ToDouble(rdr["Inch"]);
                product.Purchase_Price = Convert.ToDouble(rdr["Purchase_Price"]);
                product.Amount = Convert.ToDecimal(rdr["amount"]);
                if (product.Mark != "Not found" && product.Style == "Not found")
                {
                    product.P_name = product.P_name + "- ماركة " + product.Mark + "- " + product.Inch + " بوصه";
                }
                else if (product.Style != "Not found")
                {
                    product.P_name = product.P_name + "- ماركة " + product.Mark + "- " + product.Inch + " بوصه " + "- طراز" + product.Style;
                }
                Products.Add(product);
            }
            rdr.Close();
            con.Close();
            return Products;
        }

        public static bool AmountEnough()
        {
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Check_Amount", con);
            cmd.CommandType = CommandType.StoredProcedure;
            con.Open();
            byte result = Convert.ToByte(cmd.ExecuteScalar());
            con.Close();
            return result == 1;
        }

        public bool AddContent(out string m, string product_name, double price)
        {
            m = "";
            bool b = true;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("AddContent", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@Collected_Product", SqlDbType.NVarChar).Value = product_name;
                cmd.Parameters.Add("@Collected_Product_Price", SqlDbType.Money).Value = price;
                cmd.Parameters.Add("@P_Name", SqlDbType.NVarChar).Value = this.P_name;
                cmd.Parameters.Add("@Purchase_Price", SqlDbType.Money).Value = this.Purchase_Price;
                cmd.Parameters.Add("@Amount", SqlDbType.Decimal).Value = this.Amount;
                cmd.Parameters.Add("@Mark", SqlDbType.NVarChar).Value = this.Mark;
                cmd.Parameters.Add("@Style", SqlDbType.NVarChar).Value = this.Style;
                cmd.Parameters.Add("@Inch", SqlDbType.Decimal).Value = this.Inch;
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

        public bool AddContent(out string m)
        {
            m = "";
            bool b = true;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("AddContentInUpdate", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@P_Name", SqlDbType.NVarChar).Value = this.P_name;
                cmd.Parameters.Add("@Purchase_Price", SqlDbType.Money).Value = this.Purchase_Price;
                cmd.Parameters.Add("@Amount", SqlDbType.Decimal).Value = this.Amount;
                cmd.Parameters.Add("@Mark", SqlDbType.NVarChar).Value = this.Mark;
                cmd.Parameters.Add("@Style", SqlDbType.NVarChar).Value = this.Style;
                cmd.Parameters.Add("@Inch", SqlDbType.Decimal).Value = this.Inch;
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
