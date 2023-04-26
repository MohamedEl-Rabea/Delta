using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;

namespace DeltaProject.Business_Logic
{
    [Serializable]
    public class Partner
    {
        public int Id { get; set; }
        public int WorkshopId { get; set; }
        public string Name { get; set; }

        public static List<Partner> GetPartners(int workshopId)
        {
            List<Partner> partners = new List<Partner>();

            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(CS))
            {
                SqlCommand cmd = new SqlCommand($"SELECT Id, Name FROM Partner Where WorkshopId = {workshopId}", con);
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    partners.Add(new Partner { Id = (int)rdr["Id"], Name = rdr["Name"].ToString() });
                }
            }
            return partners;
        }
    }
}