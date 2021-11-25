using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Business_Logic
{
    public class ClientOffer
    {
        public int Id { get; set; }
        public string ClientName { get; set; }
        public string Name { get; set; }
        public DateTime Date { get; set; }
        public string Notes { get; set; }
        public string FileName { get; set; }

        public bool Add()
        {
            bool isInserted = true;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("AddClientOfferProc", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@ClientName", SqlDbType.NVarChar).Value = ClientName;
                cmd.Parameters.Add("@Name", SqlDbType.NVarChar).Value = Name;
                cmd.Parameters.Add("@Date", SqlDbType.SmallDateTime).Value = Date;
                cmd.Parameters.Add("@Notes", SqlDbType.NVarChar).Value = Notes;
                cmd.Parameters.Add("@FileName", SqlDbType.NVarChar).Value = FileName;
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }
            catch (Exception ex)
            {
                con.Close();
                isInserted = false;
            }
            return isInserted;
        }

        public bool Delete(out string msg)
        {
            msg = "";
            bool isUpdated = true;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("DeleteClientOfferByIdProc", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@Id", SqlDbType.Int).Value = Id;
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }
            catch (Exception ex)
            {
                con.Close();
                isUpdated = false;
                msg = ex.Message;
            }
            return isUpdated;
        }

        public static List<ClientOffer> GetClientOffersByClientName(string clientName)
        {
            List<ClientOffer> clientOffers = new List<ClientOffer>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("GetClientOffersByClientNameProc", con);
            cmd.CommandType = CommandType.StoredProcedure;
            if (!string.IsNullOrEmpty(clientName))
                cmd.Parameters.Add("@ClientName", SqlDbType.NVarChar).Value = clientName;

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                ClientOffer clientOffer = new ClientOffer();
                clientOffer.Id = Convert.ToInt32(rdr["Id"]);
                clientOffer.ClientName = rdr["ClientName"].ToString();
                clientOffer.Name = rdr["Name"].ToString();
                clientOffer.Date = Convert.ToDateTime(rdr["Date"]);
                clientOffer.Notes = rdr["Notes"].ToString();
                clientOffer.FileName = rdr["FileName"].ToString();
                clientOffers.Add(clientOffer);
            }
            rdr.Close();
            con.Close();
            return clientOffers;
        }
    }
}