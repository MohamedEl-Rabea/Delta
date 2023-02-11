using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Business_Logic
{
    public class Maintenance
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string ClientName { get; set; }
        public string PhoneNumber { get; set; }
        public int WorkshopId { get; set; }
        public string WorkshopName { get; set; }
        public DateTime OrderDate { get; set; }
        public string StatusName { get; set; }
        public decimal AgreedCost { get; set; }
        public decimal RemainingAmount { get; set; }
        public string Description { get; set; }
        public DateTime ExpectedDeliveryDate { get; set; }
        public DateTime DeliveryDate { get; set; }
        public DateTime ExpiryWarrantyDate { get; set; }
        public string ExpiryWarrantyDateText { get; set; }
        public decimal PaidAmount { get; set; }

        public bool AddMaintenance(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("AddMaintenance", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@Title", SqlDbType.NVarChar).Value = Title;
                cmd.Parameters.Add("@WorkshopId", SqlDbType.Int).Value = WorkshopId;
                cmd.Parameters.Add("@clientName", SqlDbType.NVarChar).Value = ClientName;
                cmd.Parameters.Add("@PhoneNumber", SqlDbType.NVarChar).Value = PhoneNumber;
                cmd.Parameters.Add("@AgreedCost", SqlDbType.Money).Value = AgreedCost;
                cmd.Parameters.Add("@OrderDate", SqlDbType.DateTime).Value = OrderDate;
                cmd.Parameters.Add("@ExpectedDeliveryDate", SqlDbType.DateTime).Value = ExpectedDeliveryDate;
                cmd.Parameters.Add("@Description", SqlDbType.NVarChar).Value = Description;
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

        public List<Maintenance> GetAllMaintenance()
        {
            List<Maintenance> maintenanceList = new List<Maintenance>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("SearchForMaintenance", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@clientName", SqlDbType.NVarChar).Value = ClientName;
            cmd.Parameters.Add("@phoneNumber", SqlDbType.NVarChar).Value = PhoneNumber;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Maintenance maintenance = new Maintenance();
                maintenance.Title = rdr["Title"].ToString();
                maintenance.OrderDate = Convert.ToDateTime(rdr["OrderDate"]);
                maintenance.ExpiryWarrantyDate = string.IsNullOrEmpty(rdr["ExpiryWarrantyDate"].ToString()) ? default : Convert.ToDateTime(rdr["ExpiryWarrantyDate"]);
                maintenance.ExpiryWarrantyDateText = maintenance.ExpiryWarrantyDate == default ? "" : maintenance.ExpiryWarrantyDate.ToString("dd/MM/yyyy");
                maintenance.AgreedCost = Convert.ToDecimal(rdr["AgreedCost"]);
                maintenance.RemainingAmount = string.IsNullOrEmpty(rdr["RemainingAmount"].ToString()) ? Convert.ToDecimal(rdr["AgreedCost"]) : Convert.ToDecimal(rdr["RemainingAmount"]);
                maintenance.WorkshopName = rdr["WorkshopName"].ToString();
                maintenance.StatusName = rdr["StatusName"].ToString();
                maintenance.Description = rdr["Description"].ToString();
                maintenanceList.Add(maintenance);
            }
            rdr.Close();
            con.Close();
            return maintenanceList;
        }

        public List<Maintenance> GetMaintenanceWithStatus(string statusName)
        {
            List<Maintenance> maintenanceList = new List<Maintenance>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("SearchForMaintenance", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@clientName", SqlDbType.NVarChar).Value = ClientName;
            cmd.Parameters.Add("@phoneNumber", SqlDbType.NVarChar).Value = PhoneNumber;
            cmd.Parameters.Add("@statusName", SqlDbType.NVarChar).Value = statusName;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Maintenance maintenance = new Maintenance();
                maintenance.Id = Convert.ToInt32(rdr["Id"]);
                maintenance.Title = rdr["Title"].ToString();
                maintenance.WorkshopName = rdr["WorkshopName"].ToString();
                maintenance.AgreedCost = Convert.ToDecimal(rdr["AgreedCost"]);
                maintenance.RemainingAmount = string.IsNullOrEmpty(rdr["RemainingAmount"].ToString()) ? Convert.ToDecimal(rdr["AgreedCost"]) : Convert.ToDecimal(rdr["RemainingAmount"]);
                maintenanceList.Add(maintenance);
            }
            rdr.Close();
            con.Close();
            return maintenanceList;
        }

        public bool DeliverMaintenance(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("DeliverMaintenance", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@maintenanceId", SqlDbType.Int).Value = Id;
                cmd.Parameters.Add("@deliveryDate", SqlDbType.SmallDateTime).Value = DeliveryDate;
                cmd.Parameters.Add("@expiryWarrantyDate", SqlDbType.SmallDateTime).Value = ExpiryWarrantyDate;
                cmd.Parameters.Add("@paidAmount", SqlDbType.Money).Value = PaidAmount;
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

        public List<ClientMaintenanceStatement> GetClientStatement()
        {
            List<ClientMaintenanceStatement> clientMaintenanceStatements = new List<ClientMaintenanceStatement>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("GetClientMaintenanceStatement", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@clientName", SqlDbType.NVarChar).Value = ClientName;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                var clientMaintenanceStatement = new ClientMaintenanceStatement();
                clientMaintenanceStatement.TransactionDate = rdr["TransactionDate"] is DBNull ? (DateTime?)null : Convert.ToDateTime(rdr["TransactionDate"]);
                clientMaintenanceStatement.Debit = Convert.ToDouble(rdr["Debit"]);
                clientMaintenanceStatement.Credit = Convert.ToDouble(rdr["Credit"]);
                clientMaintenanceStatement.Balance = Convert.ToDouble(rdr["Balance"]);
                clientMaintenanceStatement.Statement = rdr["Statement"].ToString();
                clientMaintenanceStatements.Add(clientMaintenanceStatement);
            }
            rdr.Close();
            con.Close();
            return clientMaintenanceStatements;
        }
    }
}