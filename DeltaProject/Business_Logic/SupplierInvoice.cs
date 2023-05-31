using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace DeltaProject.Business_Logic
{
    [Serializable]
    public class SupplierInvoice
    {
        public int Id { get; set; }
        public int SupplierId { get; set; }
        public string SupplierName { get; set; }
        public DateTime Date { get; set; }
        public decimal? PaidAmount { get; set; }
        public List<NewProduct> Products { get; set; } = new List<NewProduct>();
        public List<ReturnedProduct> Returns { get; set; } = new List<ReturnedProduct>();

        public bool AddInvoice(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("AddSupplierInvoice", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@supplierId", SqlDbType.Int).Value = SupplierId;
                cmd.Parameters.Add("@purchaseDate", SqlDbType.DateTime).Value = Date;
                if (PaidAmount.HasValue)
                    cmd.Parameters.Add("@paidAmount", SqlDbType.Decimal).Value = PaidAmount;
                cmd.Parameters.Add("@products", SqlDbType.Structured).Value = ToDataTable();
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

        public SupplierInvoice GetInvoiceDetails()
        {
            SupplierInvoice supplierInvoice = new SupplierInvoice();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("GetSupplierInvoiceDetails", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@invoiceId", SqlDbType.Int).Value = Id;
            con.Open();

            var rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                NewProduct product = new NewProduct
                {
                    Name = rdr["ProductName"].ToString(),
                    ClassificationName = rdr["ClassificationName"].ToString(),
                    Mark = rdr["Mark"].ToString(),
                    Inch = string.IsNullOrEmpty(rdr["Inch"].ToString())
                        ? (double?)null
                        : Convert.ToDouble(rdr["Inch"]),
                    Style = rdr["Style"].ToString(),
                    PurchasePrice = Convert.ToDecimal(rdr["PurchasePrice"]),
                    Quantity = Convert.ToDecimal(rdr["Quantity"]),
                    UnitName = rdr["UnitName"].ToString()
                };
                supplierInvoice.Products.Add(product);
            }

            rdr.NextResult();
            while (rdr.Read())
            {
                ReturnedProduct product = new ReturnedProduct
                {
                    Name = rdr["ProductName"].ToString(),
                    Quantity = Convert.ToDecimal(rdr["Quantity"]),
                    UnitName = rdr["UnitName"].ToString(),
                    Date = Convert.ToDateTime(rdr["Date"])
                };
                supplierInvoice.Returns.Add(product);
            }

            rdr.Close();
            con.Close();

            return supplierInvoice;
        }

        public static List<SupplierInvoice> GetInvoicesToReturn(int supplierId, int productId)
        {
            List<SupplierInvoice> supplierInvoices = new List<SupplierInvoice>();
            int invoiceId;

            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("GetInvoicesToReturn", con);
            cmd.CommandType = CommandType.StoredProcedure;
            if (supplierId != 0)
                cmd.Parameters.Add("@supplierId", SqlDbType.Int).Value = supplierId;
            if (productId != 0)
                cmd.Parameters.Add("@productId", SqlDbType.Int).Value = productId;
            con.Open();

            var rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                invoiceId = Convert.ToInt32(rdr["InvoiceId"]);
                if (supplierInvoices.Any(p => p.Id == invoiceId))
                {
                    supplierInvoices.FirstOrDefault(p => p.Id == invoiceId)
                        ?.Products.Add(new NewProduct
                        {
                            Id = Convert.ToInt32(rdr["ProductId"]),
                            Name = rdr["ProductName"].ToString(),
                            PurchasePrice = Convert.ToDecimal(rdr["PurchasePrice"]),
                            Quantity = Convert.ToDecimal(rdr["Quantity"]),
                            UnitName = rdr["UnitName"].ToString()
                        });
                }
                else
                {
                    SupplierInvoice supplierInvoice = new SupplierInvoice
                    {
                        Id = invoiceId,
                        Date = Convert.ToDateTime(rdr["InvoiceDate"]),
                        SupplierId = Convert.ToInt32(rdr["SupplierId"]),
                        SupplierName = rdr["SupplierName"].ToString(),
                        Products = new List<NewProduct>
                        {
                            new NewProduct
                            {
                                Id = Convert.ToInt32(rdr["ProductId"]),
                                Name = rdr["ProductName"].ToString(),
                                PurchasePrice = Convert.ToDecimal(rdr["PurchasePrice"]),
                                Quantity = Convert.ToDecimal(rdr["Quantity"]),
                                UnitName = rdr["UnitName"].ToString()
                            }
                        }
                    };
                    supplierInvoices.Add(supplierInvoice);
                }
            }
            rdr.Close();
            con.Close();
            return supplierInvoices;
        }

        public bool ReturnProduct(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("ReturnInvoiceProduct", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@invoiceId", SqlDbType.Int).Value = Id;
                cmd.Parameters.Add("@date", SqlDbType.DateTime).Value = Date;
                cmd.Parameters.Add("@productId", SqlDbType.Int).Value = Products.FirstOrDefault()?.Id;
                cmd.Parameters.Add("@productName", SqlDbType.NVarChar).Value = Products.FirstOrDefault()?.Name;
                cmd.Parameters.Add("@returnedQuantity", SqlDbType.Decimal).Value = Products.FirstOrDefault()?.Quantity;
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

        private DataTable ToDataTable()
        {
            var table = new DataTable();
            table.Columns.Add("Id", typeof(int));
            table.Columns.Add("Name", typeof(string));
            table.Columns.Add("ClassificationId", typeof(int));
            table.Columns.Add("Mark", typeof(string));
            table.Columns.Add("Inch", typeof(decimal));
            table.Columns.Add("Style", typeof(string));
            table.Columns.Add("Quantity", typeof(decimal));
            table.Columns.Add("Factor", typeof(decimal));
            table.Columns.Add("UnitId", typeof(int));
            table.Columns.Add("PurchasePrice", typeof(decimal));
            table.Columns.Add("SellPrice", typeof(decimal));
            table.Columns.Add("Description", typeof(string));

            if (Products != null)
            {
                foreach (var item in Products)
                    table.Rows.Add(item.Id, item.Name, item.ClassificationId, item.Mark, item.Inch, item.Style,
                        item.Quantity, item.Factor, item.UnitId, item.PurchasePrice, item.SellPrice, item.Description);
            }

            return table;
        }
    }
}