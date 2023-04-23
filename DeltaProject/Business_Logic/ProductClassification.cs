using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace DeltaProject.Business_Logic
{
    [Serializable]
    public class ProductClassification
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string ExtraInformation => JsonConvert.SerializeObject(Attributes, Formatting.Indented);
        public IEnumerable<ClassificationAttribute> Attributes { get; set; }
        public IEnumerable<ClassificationAttribute> GetAttributesFromJson => JsonConvert.DeserializeObject<IEnumerable<ClassificationAttribute>>(ExtraInformation);

        public bool AddClassification(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("AddClassification", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@name", SqlDbType.NVarChar).Value = Name;
                cmd.Parameters.Add("@extraInformation", SqlDbType.NVarChar).Value = ExtraInformation;
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

        public List<ProductClassification> GetClassifications()
        {
            List<ProductClassification> classifications = new List<ProductClassification>();

            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(CS))
            {
                SqlCommand cmd = new SqlCommand("SELECT Id, Name, ExtraInformation FROM ProductClassifications", con);
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    classifications.Add(new ProductClassification
                    {
                        Id = (int)rdr["Id"],
                        Name = rdr["Name"].ToString(),
                        Attributes =
                            JsonConvert.DeserializeObject<List<ClassificationAttribute>>(rdr["ExtraInformation"]
                                .ToString())
                    });
                }
            }
            return classifications;
        }
    }
}