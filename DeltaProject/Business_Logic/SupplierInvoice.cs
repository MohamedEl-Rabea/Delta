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
        public IEnumerable<NewProduct> Products { get; set; }
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