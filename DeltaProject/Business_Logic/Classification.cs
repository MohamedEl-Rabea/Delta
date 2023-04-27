using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace DeltaProject.Business_Logic
{
    [Serializable]
    public class Classification
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public List<Attribute> Attributes { get; set; }

        public static List<Classification> GetClassifications()
        {
            List<Classification> classifications = new List<Classification>();

            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(CS))
            {
                SqlCommand cmd = new SqlCommand("GetClassifications", con);
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    classifications.Add(new Classification
                    {
                        Id = (int)rdr["Id"],
                        Name = rdr["Name"].ToString(),
                        Attributes = new List<Attribute> { new Attribute { Id = (int)rdr["AttributeId"], Name = rdr["AttributeName"].ToString() } }
                    });
                }
            }

            var groupedClassifications = classifications.GroupBy(c => c.Id).Select(c => new Classification
            {
                Id = c.Key,
                Name = c.Max(p => p.Name),
                Attributes = c.SelectMany(p => p.Attributes).ToList()
            }).ToList();

            return groupedClassifications;
        }
    }
}