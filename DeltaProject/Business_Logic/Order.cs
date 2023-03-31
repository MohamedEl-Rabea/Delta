using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace DeltaProject.Business_Logic
{
    public class Order
    {
        public int Id { get; set; }
        public string ClientName { get; set; }
        public string PhoneNumber { get; set; }
        public DateTime DeliveryDate { get; set; }
        public IEnumerable<OrderDetails> OrderDetails { get; set; }

        public bool AddOrder(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("AddOrder", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@clientName", SqlDbType.NVarChar).Value = ClientName;
                cmd.Parameters.Add("@phoneNumber", SqlDbType.NVarChar).Value = PhoneNumber;
                cmd.Parameters.Add("@deliveryDate", SqlDbType.DateTime).Value = DeliveryDate;
                cmd.Parameters.Add("@orderDetails", SqlDbType.Structured).Value = ToDataTable();
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
            table.Columns.Add("OrderId", typeof(int));
            table.Columns.Add("ProductName", typeof(string));
            table.Columns.Add("Amount", typeof(decimal));

            foreach (var item in OrderDetails)
                table.Rows.Add(item.OrderId, item.ProductName, item.Amount);

            return table;
        }
    }
}