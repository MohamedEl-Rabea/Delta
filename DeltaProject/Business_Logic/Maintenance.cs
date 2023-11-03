using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Business_Logic
{
    [Serializable]
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
        public decimal? Cost { get; set; }
        public decimal? Price { get; set; }
        public decimal RemainingAmount { get; set; }
        public string Description { get; set; }
        public DateTime ExpectedDeliveryDate { get; set; }
        public DateTime DeliveryDate { get; set; }
        public DateTime ExpiryWarrantyDate { get; set; }
        public string ExpiryWarrantyDateText { get; set; }
        public decimal? PaidAmount { get; set; }

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
                cmd.Parameters.Add("@OrderDate", SqlDbType.DateTime).Value = OrderDate;
                cmd.Parameters.Add("@ExpectedDeliveryDate", SqlDbType.DateTime).Value = ExpectedDeliveryDate;
                cmd.Parameters.Add("@Description", SqlDbType.NVarChar).Value = Description;
                if (Price.HasValue)
                    cmd.Parameters.Add("@price", SqlDbType.Money).Value = Price;
                if (Cost.HasValue)
                    cmd.Parameters.Add("@cost", SqlDbType.Money).Value = Cost;
                if (PaidAmount.HasValue)
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

        public bool PriceMaintenance(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("PriceMaintenance", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@maintenanceId", SqlDbType.Int).Value = Id;
                cmd.Parameters.Add("@cost", SqlDbType.Money).Value = Cost;
                cmd.Parameters.Add("@price", SqlDbType.Money).Value = Price;
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

        public List<Maintenance> GetAllMaintenance(string statusName)
        {
            List<Maintenance> maintenanceList = new List<Maintenance>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            SqlCommand cmd = new SqlCommand("SearchForMaintenance", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@title", SqlDbType.NVarChar).Value = Title;
            cmd.Parameters.Add("@clientName", SqlDbType.NVarChar).Value = ClientName;
            cmd.Parameters.Add("@phoneNumber", SqlDbType.NVarChar).Value = PhoneNumber;
            cmd.Parameters.Add("@statusName", SqlDbType.NVarChar).Value = statusName;

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Maintenance maintenance = new Maintenance();
                maintenance.Id = Convert.ToInt32(rdr["Id"]);
                maintenance.ClientName = rdr["ClientName"].ToString();
                maintenance.Title = rdr["Title"].ToString();
                maintenance.OrderDate = Convert.ToDateTime(rdr["OrderDate"]);
                maintenance.ExpiryWarrantyDate = string.IsNullOrEmpty(rdr["ExpiryWarrantyDate"].ToString()) ? default : Convert.ToDateTime(rdr["ExpiryWarrantyDate"]);
                maintenance.ExpiryWarrantyDateText = maintenance.ExpiryWarrantyDate == default ? "" : maintenance.ExpiryWarrantyDate.ToString("dd/MM/yyyy");
                maintenance.Cost = string.IsNullOrEmpty(rdr["Cost"].ToString()) ? 0 : Convert.ToDecimal(rdr["Cost"]);
                maintenance.Price = string.IsNullOrEmpty(rdr["Price"].ToString()) ? 0 : Convert.ToDecimal(rdr["Price"]);
                maintenance.RemainingAmount = string.IsNullOrEmpty(rdr["RemainingAmount"].ToString()) ?
                    maintenance.Price.Value : Convert.ToDecimal(rdr["RemainingAmount"]);
                maintenance.WorkshopName = rdr["WorkshopName"].ToString();
                maintenance.StatusName = rdr["StatusName"].ToString();
                maintenance.Description = rdr["Description"].ToString();
                maintenanceList.Add(maintenance);
            }
            rdr.Close();
            con.Close();
            return maintenanceList;
        }

        public static List<Maintenance> GetMaintenanceReport(int workshopId, DateTime? startDate, DateTime? endDate)
        {
            List<Maintenance> maintenanceList = new List<Maintenance>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("GetMaintenanceReport", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@workshopId", SqlDbType.Int).Value = workshopId;
            if (startDate.HasValue)
                cmd.Parameters.AddWithValue("@startDate", startDate);
            if (endDate.HasValue)
                cmd.Parameters.AddWithValue("@endDate", endDate);

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Maintenance maintenance = new Maintenance();
                maintenance.Id = Convert.ToInt32(rdr["Id"]);
                maintenance.OrderDate = Convert.ToDateTime(rdr["OrderDate"]);
                maintenance.Title = rdr["Title"].ToString();
                maintenance.ClientName = rdr["ClientName"].ToString();
                maintenance.Cost = string.IsNullOrEmpty(rdr["Cost"].ToString()) ? 0 : Convert.ToDecimal(rdr["Cost"]);
                maintenance.Price = string.IsNullOrEmpty(rdr["Price"].ToString()) ? 0 : Convert.ToDecimal(rdr["Price"]);
                maintenance.PaidAmount = string.IsNullOrEmpty(rdr["Paid"].ToString()) ? 0 : Convert.ToDecimal(rdr["Paid"]);
                maintenance.RemainingAmount = string.IsNullOrEmpty(rdr["RemainingAmount"].ToString()) ? 0 : Convert.ToDecimal(rdr["RemainingAmount"]);
                maintenanceList.Add(maintenance);
            }
            rdr.Close();
            con.Close();
            return maintenanceList;
        }

        public static List<Maintenance> GetPastMaintenanceReport(int workshopId, DateTime? startDate, DateTime? endDate)
        {
            List<Maintenance> maintenanceList = new List<Maintenance>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("GetPastMaintenanceReport", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@workshopId", SqlDbType.Int).Value = workshopId;
            if (startDate.HasValue)
                cmd.Parameters.AddWithValue("@startDate", startDate);
            if (endDate.HasValue)
                cmd.Parameters.AddWithValue("@endDate", endDate);

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Maintenance maintenance = new Maintenance();
                maintenance.Id = Convert.ToInt32(rdr["Id"]);
                maintenance.OrderDate = Convert.ToDateTime(rdr["OrderDate"]);
                maintenance.Title = rdr["Title"].ToString();
                maintenance.ClientName = rdr["ClientName"].ToString();
                maintenance.Cost = string.IsNullOrEmpty(rdr["Cost"].ToString()) ? 0 : Convert.ToDecimal(rdr["Cost"]);
                maintenance.Price = string.IsNullOrEmpty(rdr["Price"].ToString()) ? 0 : Convert.ToDecimal(rdr["Price"]);
                maintenance.PaidAmount = string.IsNullOrEmpty(rdr["Paid"].ToString()) ? 0 : Convert.ToDecimal(rdr["Paid"]);
                maintenance.RemainingAmount = string.IsNullOrEmpty(rdr["RemainingAmount"].ToString()) ? 0 : Convert.ToDecimal(rdr["RemainingAmount"]);
                maintenanceList.Add(maintenance);
            }
            rdr.Close();
            con.Close();
            return maintenanceList;
        }
    }
}