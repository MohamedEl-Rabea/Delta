using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace DeltaProject.Business_Logic
{
    public class SupplierInvoice
    {
        public int Id { get; set; }
        public int SupplierId { get; set; }
        public DateTime Date { get; set; }
        public decimal? PaidAmount { get; set; }
        public List<NewProduct> Products { get; set; }
        public List<InvoicePayment> Payments { get; set; }

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
            SupplierInvoice supplierInvoice = new SupplierInvoice
            {
                Products = new List<NewProduct>(),
                Payments = new List<InvoicePayment>()
            };
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
                InvoicePayment payment = new InvoicePayment
                {
                    PaymentDate = Convert.ToDateTime(rdr["PaymentDate"]),
                    PaidAmount = Convert.ToDecimal(rdr["PaidAmount"]),
                    Notes = rdr["Notes"].ToString()
                };
                supplierInvoice.Payments.Add(payment);
            }

            con.Close();

            return supplierInvoice;
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