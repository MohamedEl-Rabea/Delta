using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace DeltaProject.Business_Logic
{
    public class SupplierCheque
    {
        public int Id { get; set; }
        public string SupplierName { get; set; }
        public DateTime DueDate { get; set; }
        public decimal Value { get; set; }
        public bool PaidOff { get; set; }
        public string ChequeNumber { get; set; }
        public int AlertBefore { get; set; }
        public string Notes { get; set; }

        public void Create(string supplierName, decimal amount, DateTime dueDate, string number, int alertBefore, string notes)
        {
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("AddSupplierCheque", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@SupplierName", SqlDbType.NVarChar).Value = supplierName;
            cmd.Parameters.Add("@ChequeValue", SqlDbType.NVarChar).Value = amount;
            cmd.Parameters.Add("@DueDate", SqlDbType.SmallDateTime).Value = dueDate;
            cmd.Parameters.Add("@ChequeNumber", SqlDbType.Money).Value = number;
            cmd.Parameters.Add("@AlertBefore", SqlDbType.Money).Value = alertBefore;
            cmd.Parameters.Add("@Notes", SqlDbType.NVarChar).Value = notes;
            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
        }

        /*TODO: 1- Create complete UI for creating supplier cheque
          TODO: 2- Create method for getting upcoming payable cheques count
          TODO: 3- Implement UI for displaying notifications 
          TODO: 4- Create method for getting upcoming payable cheques info
          TODO: 5- Implement UI for displaying payable cheques info 
        */
    }
}