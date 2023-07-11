using Business_Logic;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace DeltaProject.Business_Logic
{
    [Serializable]
    public class SaleBill
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string ClientName { get; set; }
        public string PhoneNumber { get; set; }
        public string Address { get; set; }
        public DateTime Date { get; set; }
        public decimal? Discount { get; set; }
        public decimal? AdditionalCost { get; set; }
        public decimal? PaidAmount { get; set; }
        public decimal? TotalCost { get; set; }
        public string AdditionalCostNotes { get; set; }
        public string Notes { get; set; }
        public Client Client { get; set; }
        public List<BillItem> Items { get; set; } = new List<BillItem>();

        public bool AddBill(out string m)
        {
            bool b = true;
            m = "";
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            try
            {
                SqlCommand cmd = new SqlCommand("AddSaleBill", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@userId", SqlDbType.Int).Value = UserId;
                cmd.Parameters.Add("@date", SqlDbType.DateTime).Value = Date;
                cmd.Parameters.Add("@clientName", SqlDbType.NVarChar).Value = ClientName;
                if (!string.IsNullOrEmpty(Client.Address))
                    cmd.Parameters.Add("@address", SqlDbType.NVarChar).Value = Client.Address;
                if (AdditionalCost.HasValue)
                    cmd.Parameters.Add("@additionalCost", SqlDbType.Decimal).Value = AdditionalCost;
                if (PaidAmount.HasValue)
                    cmd.Parameters.Add("@paidAmount", SqlDbType.Decimal).Value = PaidAmount;

                cmd.Parameters.Add("@costNotes", SqlDbType.NVarChar).Value = AdditionalCostNotes;
                cmd.Parameters.Add("@notes", SqlDbType.NVarChar).Value = Notes;

                cmd.Parameters.Add("@items", SqlDbType.Structured).Value = ProductsToDataTable();
                cmd.Parameters.Add("@services", SqlDbType.Structured).Value = ServicesToDataTable();

                cmd.Parameters.Add("@billId", SqlDbType.Int);
                cmd.Parameters["@billId"].Direction = ParameterDirection.Output;

                con.Open();
                cmd.ExecuteNonQuery();
                Id = Convert.ToInt32(cmd.Parameters["@billId"].Value);
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

        public static List<SaleBill> GetAllBills(int startIndex, int maxRows, string clientName, string phoneNumber, int? billId)
        {
            List<SaleBill> bills = new List<SaleBill>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            SqlCommand cmd = new SqlCommand("GetAllBills", con) { CommandType = CommandType.StoredProcedure };
            cmd.Parameters.Add("@startIndex", SqlDbType.Int).Value = startIndex;
            cmd.Parameters.Add("@maxRows", SqlDbType.Int).Value = maxRows;
            cmd.Parameters.Add("@clientName", SqlDbType.NVarChar).Value = clientName;
            cmd.Parameters.Add("@phoneNumber", SqlDbType.NVarChar).Value = phoneNumber;
            if (billId.HasValue)
                cmd.Parameters.Add("@billId", SqlDbType.Int).Value = billId;

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                SaleBill bill = new SaleBill
                {
                    Id = Convert.ToInt32(rdr["Id"]),
                    ClientName = rdr["ClientName"].ToString(),
                    Date = Convert.ToDateTime(rdr["Date"])
                };
                bills.Add(bill);
            }
            rdr.Close();
            con.Close();
            return bills;
        }

        public static int GetBillsCount(string clientName, string phoneNumber, int? billId)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            SqlCommand cmd = new SqlCommand("GetBillsCount", con) { CommandType = CommandType.StoredProcedure };
            cmd.Parameters.Add("@clientName", SqlDbType.NVarChar).Value = clientName;
            cmd.Parameters.Add("@phoneNumber", SqlDbType.NVarChar).Value = phoneNumber;
            if (billId.HasValue)
                cmd.Parameters.Add("@billId", SqlDbType.Int).Value = billId; con.Open();
            var count = (int)cmd.ExecuteScalar();
            con.Close();
            return count;
        }

        public void GetBillData()
        {
            SaleBill bill = new SaleBill();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            SqlCommand cmd = new SqlCommand("GetBillData", con) { CommandType = CommandType.StoredProcedure };
            cmd.Parameters.Add("@billId", SqlDbType.Int).Value = Id;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Id = Convert.ToInt32(rdr["Id"]);
                ClientName = rdr["ClientName"].ToString();
                Date = Convert.ToDateTime(rdr["Date"]);
                Address = rdr["Address"].ToString();
                AdditionalCost = Convert.ToDecimal(rdr["AdditionalCost"]);
                PaidAmount = Convert.ToDecimal(rdr["PaidAmount"]);
                AdditionalCostNotes = rdr["AdditionalCostNotes"].ToString();
            }
            rdr.NextResult();

            while (rdr.Read())
            {
                BillItem billItem = new BillItem
                {
                    Id = Convert.ToInt32(rdr["Id"]),
                    ProductId = Convert.ToInt32(rdr["ProductId"]),
                    Name = rdr["Name"].ToString(),
                    UnitName = rdr["UnitName"].ToString(),
                    Quantity = Convert.ToDecimal(rdr["Quantity"]) - Convert.ToDecimal(rdr["ReturnedQuantity"]),
                    SpecifiedPrice = Convert.ToDecimal(rdr["Price"]),
                    Discount = Convert.ToDecimal(rdr["Discount"]),
                    IsService = Convert.ToBoolean(rdr["IsService"])
                };
                Items.Add(billItem);
            }
            rdr.Close();
            con.Close();
        }

        public bool ReturnItems(out string m)
        {
            bool b = true;
            m = "";
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            try
            {
                SqlCommand cmd = new SqlCommand("ReturnBillItems", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@id", SqlDbType.Int).Value = Id;
                cmd.Parameters.Add("@items", SqlDbType.Structured).Value = ReturnsToDataTable();

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

        private DataTable ProductsToDataTable()
        {
            var table = new DataTable();
            table.Columns.Add("Id", typeof(int));
            table.Columns.Add("Date", typeof(DateTime));
            table.Columns.Add("ProductId", typeof(int));
            table.Columns.Add("PurchasePrice", typeof(decimal));
            table.Columns.Add("SpecifiedPrice", typeof(decimal));
            table.Columns.Add("SellPrice", typeof(decimal));
            table.Columns.Add("Discount", typeof(decimal));
            table.Columns.Add("Quantity", typeof(decimal));

            var products = Items.Where(c => !c.IsService).ToList();
            if (products.Any())
            {
                foreach (var item in products)
                    table.Rows.Add(0, Date, item.ProductId, item.PurchasePrice, item.SpecifiedPrice, item.SellPrice, item.Discount, item.SoldQuantity);
            }

            return table;
        }

        private DataTable ServicesToDataTable()
        {
            var table = new DataTable();
            table.Columns.Add("Id", typeof(int));
            table.Columns.Add("Date", typeof(DateTime));
            table.Columns.Add("Name", typeof(string));
            table.Columns.Add("SellPrice", typeof(decimal));
            table.Columns.Add("Quantity", typeof(decimal));

            var services = Items.Where(c => c.IsService).ToList();
            if (services.Any())
            {
                foreach (var item in services)
                    table.Rows.Add(0, Date, item.Name, item.SpecifiedPrice, item.SoldQuantity);
            }

            return table;
        }

        private DataTable ReturnsToDataTable()
        {
            var table = new DataTable();
            table.Columns.Add("Id", typeof(int));
            table.Columns.Add("Date", typeof(DateTime));
            table.Columns.Add("ProductId", typeof(int));
            table.Columns.Add("PurchasePrice", typeof(decimal));
            table.Columns.Add("SpecifiedPrice", typeof(decimal));
            table.Columns.Add("SellPrice", typeof(decimal));
            table.Columns.Add("Discount", typeof(decimal));
            table.Columns.Add("Quantity", typeof(decimal));

            var products = Items.Where(c => !c.IsService).ToList();
            if (products.Any())
            {
                foreach (var item in products)
                    table.Rows.Add(item.Id, item.Date, item.ProductId, 0, 0, 0, 0, item.ReturnedQuantity);
            }

            return table;
        }
    }
}