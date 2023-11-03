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
        public decimal? TotalCost => Items.Sum(i => i.TotalCost);
        public decimal? RemainingCost => Items.Sum(i => i.TotalCost) + AdditionalCost - PaidAmount;
        public string AdditionalCostNotes { get; set; }
        public string Notes { get; set; }
        public Client Client { get; set; }
        public List<BillItem> Items { get; set; } = new List<BillItem>();
        public List<BillItemHistory> History { get; set; } = new List<BillItemHistory>();

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

        public static List<SaleBill> GetUnpaidBills(string clientName, string phoneNumber, int? billId)
        {
            var bills = GetAllBillsWithData(clientName, phoneNumber, billId);
            return bills.Where(p => p.RemainingCost != 0).ToList();
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

        public static List<SaleBill> GetAllPaidBills(int startIndex, int maxRows, string clientName, string phoneNumber, int? billId)
        {
            List<SaleBill> bills = new List<SaleBill>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            SqlCommand cmd = new SqlCommand("GetAllPaidBillsWithData", con) { CommandType = CommandType.StoredProcedure };
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

        public static int GetAllPaidBillsCount(string clientName, string phoneNumber, int? billId)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            SqlCommand cmd = new SqlCommand("GetAllPaidBillsWithDataCount", con) { CommandType = CommandType.StoredProcedure };
            cmd.Parameters.Add("@clientName", SqlDbType.NVarChar).Value = clientName;
            cmd.Parameters.Add("@phoneNumber", SqlDbType.NVarChar).Value = phoneNumber;
            if (billId.HasValue)
                cmd.Parameters.Add("@billId", SqlDbType.Int).Value = billId; con.Open();
            var count = (int)cmd.ExecuteScalar();
            con.Close();
            return count;
        }

        public static List<SaleBill> GetAllUnPaidBills(int startIndex, int maxRows, string clientName, string phoneNumber, int? billId)
        {
            List<SaleBill> bills = new List<SaleBill>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            SqlCommand cmd = new SqlCommand("GetAllUnPaidBillsWithData", con) { CommandType = CommandType.StoredProcedure };
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

        public static int GetAllUnPaidBillsCount(string clientName, string phoneNumber, int? billId)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            SqlCommand cmd = new SqlCommand("GetAllUnPaidBillsWithDataCount", con) { CommandType = CommandType.StoredProcedure };
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
                    SoldQuantity = Convert.ToDecimal(rdr["Quantity"]),
                    ReturnedQuantity = Convert.ToDecimal(rdr["ReturnedQuantity"]),
                    SpecifiedPrice = Convert.ToDecimal(rdr["Price"]),
                    Discount = Convert.ToDecimal(rdr["Discount"]),
                    IsService = Convert.ToBoolean(rdr["IsService"])
                };
                billItem.Quantity = billItem.SoldQuantity - billItem.ReturnedQuantity;
                if (billItem.Quantity > 0)
                    Items.Add(billItem);
            }
            rdr.Close();
            con.Close();
        }

        public void GetHistory()
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            SqlCommand cmd = new SqlCommand("GetBillHistory", con) { CommandType = CommandType.StoredProcedure };
            cmd.Parameters.Add("@billId", SqlDbType.Int).Value = Id;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                BillItemHistory record = new BillItemHistory
                {
                    Order = Convert.ToInt32(rdr["Order"]),
                    OperationType = rdr["OperationType"].ToString(),
                    Date = Convert.ToDateTime(rdr["Date"]),
                    Description = rdr["Description"].ToString(),
                    UserName = rdr["UserName"].ToString()
                };
                History.Add(record);
            }
            rdr.Close();
            con.Close();
            History = History.GroupBy(h => new { h.OperationType, h.Date, h.UserName, h.Order }).Select(h => new BillItemHistory
            {
                Order = h.Key.Order,
                OperationType = h.Key.OperationType,
                Date = h.Key.Date,
                Description = string.Join(" - ", h.Select(t => t.Description)),
                UserName = h.Key.UserName
            }).OrderByDescending(h => h.Date).ThenByDescending(h => h.Order).ToList();
        }

        public bool AddBill(out string m)
        {
            bool b = true;
            m = "";
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            try
            {
                SqlCommand cmd = new SqlCommand("AddSaleBill", con) { CommandType = CommandType.StoredProcedure };
                cmd.Parameters.Add("@userId", SqlDbType.Int).Value = UserId;
                cmd.Parameters.Add("@date", SqlDbType.DateTime).Value = Date;
                cmd.Parameters.Add("@clientName", SqlDbType.NVarChar).Value = ClientName;
                if (!string.IsNullOrEmpty(Client.Address))
                    cmd.Parameters.Add("@address", SqlDbType.NVarChar).Value = Client.Address;
                if (!string.IsNullOrEmpty(PhoneNumber))
                    cmd.Parameters.Add("@phoneNumber", SqlDbType.NVarChar).Value = PhoneNumber;
                if (AdditionalCost.HasValue)
                    cmd.Parameters.Add("@additionalCost", SqlDbType.Decimal).Value = AdditionalCost;
                if (PaidAmount.HasValue && PaidAmount > 0)
                    cmd.Parameters.Add("@paidAmount", SqlDbType.Decimal).Value = PaidAmount;

                cmd.Parameters.Add("@costNotes", SqlDbType.NVarChar).Value = AdditionalCostNotes;
                cmd.Parameters.Add("@notes", SqlDbType.NVarChar).Value = Notes;

                cmd.Parameters.Add("@items", SqlDbType.Structured).Value = ItemsToDataTable();

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

        public bool AddBillItems(out string m)
        {
            bool b = true;
            m = "";
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            try
            {
                SqlCommand cmd = new SqlCommand("AddBillItems", con) { CommandType = CommandType.StoredProcedure };
                cmd.Parameters.Add("@billId", SqlDbType.Int).Value = Id;
                cmd.Parameters.Add("@userId", SqlDbType.Int).Value = UserId;
                cmd.Parameters.Add("@date", SqlDbType.DateTime).Value = Date;
                cmd.Parameters.Add("@items", SqlDbType.Structured).Value = ItemsToDataTable();

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

        public bool ReturnItems(out string m)
        {
            bool b = true;
            m = "";
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            try
            {
                SqlCommand cmd = new SqlCommand("ReturnBillItems", con) { CommandType = CommandType.StoredProcedure };
                cmd.Parameters.Add("@id", SqlDbType.Int).Value = Id;
                cmd.Parameters.Add("@userId", SqlDbType.Int).Value = UserId;
                cmd.Parameters.Add("@date", SqlDbType.DateTime).Value = Date;
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

        public bool EditItems(out string m)
        {
            bool b = true;
            m = "";
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            try
            {
                SqlCommand cmd = new SqlCommand("EditBillItems", con) { CommandType = CommandType.StoredProcedure };
                cmd.Parameters.Add("@id", SqlDbType.Int).Value = Id;
                cmd.Parameters.Add("@userId", SqlDbType.Int).Value = UserId;
                cmd.Parameters.Add("@date", SqlDbType.DateTime).Value = Date;
                cmd.Parameters.Add("@items", SqlDbType.Structured).Value = EditToDataTable();

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

        public bool AddDiscounts(out string m)
        {
            bool b = true;
            m = "";
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            try
            {
                SqlCommand cmd = new SqlCommand("AddBillDiscounts", con) { CommandType = CommandType.StoredProcedure };
                cmd.Parameters.Add("@id", SqlDbType.Int).Value = Id;
                cmd.Parameters.Add("@userId", SqlDbType.Int).Value = UserId;
                cmd.Parameters.Add("@date", SqlDbType.DateTime).Value = Date;
                cmd.Parameters.Add("@items", SqlDbType.Structured).Value = DiscountsToDataTable();

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

        public bool Pay(out string m)
        {
            bool b = true;
            m = "";
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            try
            {
                SqlCommand cmd = new SqlCommand("AddBillPayment", con) { CommandType = CommandType.StoredProcedure };
                cmd.Parameters.Add("@id", SqlDbType.Int).Value = Id;
                cmd.Parameters.Add("@userId", SqlDbType.Int).Value = UserId;
                cmd.Parameters.Add("@date", SqlDbType.DateTime).Value = Date;
                cmd.Parameters.Add("@paidAmount", SqlDbType.Money).Value = PaidAmount;
                cmd.Parameters.Add("@notes", SqlDbType.NVarChar).Value = Notes;

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

        public bool DeleteBill(out string m)
        {
            bool b = true;
            m = "";
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            try
            {
                SqlCommand cmd = new SqlCommand("DeleteBill", con) { CommandType = CommandType.StoredProcedure };
                cmd.Parameters.Add("@id", SqlDbType.Int).Value = Id;

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

        public bool DeleteBillItem(out string m, int id, int userId, bool isService, decimal quantity)
        {
            bool b = true;
            m = "";
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            try
            {
                SqlCommand cmd = new SqlCommand("DeleteBillItem", con) { CommandType = CommandType.StoredProcedure };
                cmd.Parameters.Add("@id", SqlDbType.Int).Value = id;
                cmd.Parameters.Add("@userId", SqlDbType.Int).Value = userId;
                cmd.Parameters.Add("@date", SqlDbType.DateTime).Value = DateTime.Now;
                cmd.Parameters.Add("@isService", SqlDbType.Bit).Value = isService;
                cmd.Parameters.Add("@quantity", SqlDbType.Decimal).Value = quantity;

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

        private static List<SaleBill> GetAllBillsWithData(string clientName, string phoneNumber, int? billId)
        {
            List<SaleBill> bills = new List<SaleBill>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            SqlCommand cmd = new SqlCommand("GetAllBillsWithData", con) { CommandType = CommandType.StoredProcedure };
            if (!string.IsNullOrEmpty(clientName))
                cmd.Parameters.Add("@clientName", SqlDbType.NVarChar).Value = clientName;
            if (!string.IsNullOrEmpty(phoneNumber))
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
                    Date = Convert.ToDateTime(rdr["Date"]),
                    Address = rdr["Address"].ToString(),
                    AdditionalCost = Convert.ToDecimal(rdr["AdditionalCost"]),
                    PaidAmount = Convert.ToDecimal(rdr["PaidAmount"]),
                    AdditionalCostNotes = rdr["AdditionalCostNotes"].ToString()
                };
                bills.Add(bill);
            }

            rdr.NextResult();

            while (rdr.Read())
            {
                BillItem billItem = new BillItem
                {
                    Id = Convert.ToInt32(rdr["Id"]),
                    BillId = Convert.ToInt32(rdr["BillId"]),
                    ProductId = Convert.ToInt32(rdr["ProductId"]),
                    Name = rdr["Name"].ToString(),
                    UnitName = rdr["UnitName"].ToString(),
                    SoldQuantity = Convert.ToDecimal(rdr["Quantity"]),
                    ReturnedQuantity = Convert.ToDecimal(rdr["ReturnedQuantity"]),
                    SpecifiedPrice = Convert.ToDecimal(rdr["Price"]),
                    Discount = Convert.ToDecimal(rdr["Discount"]),
                    IsService = Convert.ToBoolean(rdr["IsService"])
                };
                billItem.Quantity = billItem.SoldQuantity - billItem.ReturnedQuantity;
                SaleBill bill = bills.FirstOrDefault(c => c.Id == billItem.BillId);
                if (billItem.Quantity > 0)
                    bill?.Items.Add(billItem);
            }

            rdr.Close();
            con.Close();
            return bills;
        }

        private DataTable ItemsToDataTable()
        {
            var table = BuildBillItemType();

            if (Items.Any())
            {
                foreach (var item in Items)
                    table.Rows.Add(item.Id, item.ProductId, item.Name, item.PurchasePrice, item.SpecifiedPrice,
                        item.SellPrice, item.Discount, item.Quantity, item.SoldQuantity, item.IsService, null);
            }

            return table;
        }

        private DataTable ReturnsToDataTable()
        {
            var table = BuildBillItemType();

            var products = Items.Where(c => !c.IsService).ToList();
            if (products.Any())
            {
                foreach (var item in products)
                    table.Rows.Add(item.Id, item.ProductId, item.Name, 0, 0, 0, 0, item.Quantity, item.ReturnedQuantity, false, null);
            }

            return table;
        }

        private DataTable EditToDataTable()
        {
            var table = BuildBillItemType();

            if (Items.Any())
            {
                foreach (var item in Items)
                    table.Rows.Add(item.Id, item.ProductId, item.Name, 0, item.SpecifiedPrice, 0, 0, item.Quantity + item.ReturnedQuantity, item.ReturnedQuantity, item.IsService, item.Notes);
            }

            return table;
        }

        private DataTable DiscountsToDataTable()
        {
            var table = BuildBillItemType();

            var products = Items.Where(c => !c.IsService).ToList();
            if (products.Any())
            {
                foreach (var item in products)
                    table.Rows.Add(item.Id, item.ProductId, item.Name, 0, 0, 0, item.Discount, item.Quantity, 0, false, null);
            }

            return table;
        }

        private DataTable BuildBillItemType()
        {
            var table = new DataTable();
            table.Columns.Add("Id", typeof(int));
            table.Columns.Add("ProductId", typeof(int));
            table.Columns.Add("Name", typeof(string));
            table.Columns.Add("PurchasePrice", typeof(decimal));
            table.Columns.Add("SpecifiedPrice", typeof(decimal));
            table.Columns.Add("SellPrice", typeof(decimal));
            table.Columns.Add("Discount", typeof(decimal));
            table.Columns.Add("OriginalQuantity", typeof(decimal));
            table.Columns.Add("Quantity", typeof(decimal));
            table.Columns.Add("IsService", typeof(bool));
            table.Columns.Add("Notes", typeof(string));
            return table;
        }
    }
}