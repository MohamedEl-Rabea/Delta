using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace DeltaProject.Business_Logic
{
    public class ProductSettlement
    {
        public int Id { get; set; }
        public int ProductId { get; set; }
        public decimal QuantityBefore { get; set; }
        public decimal QuantityAfter { get; set; }
        public DateTime Date { get; set; }

        public bool AddSettlement(out string m, List<ProductSettlement> productsSettlement)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("AddProductsSettlement", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@productsSettlement", SqlDbType.Structured).Value = ToDataTable(productsSettlement);
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

        private DataTable ToDataTable(List<ProductSettlement> productsSettlement)
        {
            var table = new DataTable();
            table.Columns.Add("ProductId", typeof(int));
            table.Columns.Add("QuantityBefore", typeof(decimal));
            table.Columns.Add("QuantityAfter", typeof(decimal));

            if (productsSettlement != null && productsSettlement.Any())
            {
                foreach (var item in productsSettlement)
                    table.Rows.Add(item.ProductId, item.QuantityBefore, item.QuantityAfter);
            }

            return table;
        }
    }
}