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
        public DateTime Date { get; set; }
        public decimal? Discount { get; set; }
        public decimal? AdditionalCost { get; set; }
        public decimal? PaidAmount { get; set; }
        public string CostNotes { get; set; }
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

                cmd.Parameters.Add("@costNotes", SqlDbType.NVarChar).Value = CostNotes;
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
    }
}