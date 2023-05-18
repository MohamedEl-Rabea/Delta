using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Business_Logic
{
    public class SupplierStatement : Statement
    {
        public int? InvoiceId { get; set; }
        public DateTime? InvoiceDate { get; set; }

        public static List<SupplierStatement> GetStatement(int? supplierId, string phoneNumber, DateTime? startDate)
        {
            var supplierStatementList = new List<SupplierStatement>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("GetSupplierStatement", con);
            cmd.CommandType = CommandType.StoredProcedure;

            if (supplierId.HasValue)
                cmd.Parameters.Add("@supplierId", SqlDbType.Int).Value = supplierId;

            if (!string.IsNullOrEmpty(phoneNumber))
                cmd.Parameters.Add("@phoneNumber", SqlDbType.NVarChar).Value = phoneNumber;

            if (startDate.HasValue)
                cmd.Parameters.AddWithValue("@startDate", startDate);

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                var supplierStatement = new SupplierStatement
                {
                    InvoiceId = rdr["InvoiceId"] is DBNull
                        ? (int?)null :
                        Convert.ToInt32(rdr["InvoiceId"]),
                    InvoiceDate = rdr["InvoiceDate"] is DBNull
                        ? (DateTime?)null
                        : Convert.ToDateTime(rdr["InvoiceDate"]),
                    TransactionDate = rdr["TransactionDate"] is DBNull
                        ? (DateTime?)null
                        : Convert.ToDateTime(rdr["TransactionDate"]),
                    Debit = Convert.ToDouble(rdr["Debit"]),
                    Credit = Convert.ToDouble(rdr["Credit"]),
                    Balance = Convert.ToDouble(rdr["Balance"]),
                    Description = rdr["Statement"].ToString()
                };
                supplierStatementList.Add(supplierStatement);
            }
            rdr.Close();
            con.Close();
            return supplierStatementList;
        }

    }
}