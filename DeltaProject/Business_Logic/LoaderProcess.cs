using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace DeltaProject.Business_Logic
{
    [Serializable]
    public class LoaderProcess
    {
        public int Id { get; set; }
        public int LoaderId { get; set; }
        public string LoaderName { get; set; }
        public string PermissionNumber { get; set; }
        public string ClientName { get; set; }
        public string PhoneNumber { get; set; }
        public decimal Cost { get; set; }
        public decimal PaidAmount { get; set; }
        public decimal RemainingAmount { get; set; }
        public DateTime Date { get; set; }
        public string Description { get; set; }

        public bool RegisterLoaderProcess(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("RegisterLoaderProcess", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@loaderId", SqlDbType.Int).Value = LoaderId;
                cmd.Parameters.Add("@permissionNumber", SqlDbType.NVarChar).Value = PermissionNumber;
                cmd.Parameters.Add("@clientName", SqlDbType.NVarChar).Value = ClientName;
                cmd.Parameters.Add("@phoneNumber", SqlDbType.NVarChar).Value = PhoneNumber;
                cmd.Parameters.Add("@cost", SqlDbType.Money).Value = Cost;
                cmd.Parameters.Add("@paidAmount", SqlDbType.Money).Value = PaidAmount;
                cmd.Parameters.Add("@date", SqlDbType.DateTime).Value = Date;
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

        public List<LoaderProcess> GetLoaderProcessWithFilter(DateTime? startDate, DateTime? endDate, bool isToPay = false)
        {
            List<LoaderProcess> loaderProcesses = new List<LoaderProcess>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("SearchForLoaderProcessess", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@clientName", SqlDbType.NVarChar).Value = ClientName;
            cmd.Parameters.Add("@startDate", SqlDbType.DateTime).Value = startDate;
            cmd.Parameters.Add("@endDate", SqlDbType.DateTime).Value = endDate;
            cmd.Parameters.Add("@isToPay", SqlDbType.Bit).Value = isToPay;

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                LoaderProcess loaderProcess = new LoaderProcess();
                loaderProcess.Id = Convert.ToInt32(rdr["Id"]);
                loaderProcess.LoaderName = rdr["LoaderName"].ToString();
                loaderProcess.PermissionNumber = rdr["PermissionNumber"].ToString();
                loaderProcess.ClientName = rdr["ClientName"].ToString();
                loaderProcess.Cost = Convert.ToDecimal(rdr["Cost"]);
                loaderProcess.RemainingAmount = Convert.ToDecimal(rdr["RemainingAmount"]);
                loaderProcess.Date = Convert.ToDateTime(rdr["Date"]);
                loaderProcess.Description = rdr["Description"].ToString();
                loaderProcesses.Add(loaderProcess);
            }
            rdr.Close();
            con.Close();
            return loaderProcesses;
        }

        public bool PayLoaderProcess(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("PayLoaderProcess", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@loaderProcessId", SqlDbType.Int).Value = Id;
                cmd.Parameters.Add("@paymentDate", SqlDbType.SmallDateTime).Value = Date;
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

        public static List<LoaderProcess> GetLoaderProcessesReport(int workshopId, DateTime? startDate, DateTime? endDate)
        {
            List<LoaderProcess> loaderProcesses = new List<LoaderProcess>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("GetLoaderProcessesReport", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@loaderId", SqlDbType.Int).Value = workshopId;
            if (startDate.HasValue)
                cmd.Parameters.AddWithValue("@startDate", startDate);
            if (endDate.HasValue)
                cmd.Parameters.AddWithValue("@endDate", endDate);

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                LoaderProcess loaderProcess = new LoaderProcess();
                loaderProcess.Id = Convert.ToInt32(rdr["Id"]);
                loaderProcess.Date = Convert.ToDateTime(rdr["Date"]);
                loaderProcess.ClientName = rdr["ClientName"].ToString();
                loaderProcess.Cost = string.IsNullOrEmpty(rdr["Cost"].ToString()) ? 0 : Convert.ToDecimal(rdr["Cost"]);
                loaderProcess.PaidAmount = string.IsNullOrEmpty(rdr["Paid"].ToString()) ? 0 : Convert.ToDecimal(rdr["Paid"]);
                loaderProcess.RemainingAmount = string.IsNullOrEmpty(rdr["RemainingAmount"].ToString()) ? 0 : Convert.ToDecimal(rdr["RemainingAmount"]);
                loaderProcesses.Add(loaderProcess);
            }
            rdr.Close();
            con.Close();
            return loaderProcesses;
        }
    }
}