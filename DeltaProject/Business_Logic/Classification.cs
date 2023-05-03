using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;

namespace DeltaProject.Business_Logic
{
    [Serializable]
    public class Classification
    {
        public int Id { get; set; }
        public string Name { get; set; }

        public static List<Classification> GetClassifications()
        {
            List<Classification> classifications = new List<Classification>();

            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(CS))
            {
                SqlCommand cmd = new SqlCommand("SELECT Id, Name FROM Classifications", con);
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    classifications.Add(new Classification { Id = (int)rdr["Id"], Name = rdr["Name"].ToString() });
                }
            }
            return classifications;
        }

        public static ClassificationDetails GetProductClassificationDetails(string productName)
        {
            ClassificationDetails classificationDetails = new ClassificationDetails();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(CS))
            {
                SqlCommand cmd = new SqlCommand($"SELECT TOP(1)ClassificationId, Mark, Inch, Style From Products Where Name = N'{productName}'", con);
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    if (string.IsNullOrEmpty(rdr["ClassificationId"].ToString()))
                        return null;

                    classificationDetails.Id = (int)rdr["ClassificationId"];
                    classificationDetails.Mark = rdr["Mark"].ToString();
                    classificationDetails.Inch = string.IsNullOrEmpty(rdr["Inch"].ToString()) ? (double?)null : Convert.ToDouble(rdr["Inch"]);
                    classificationDetails.Style = rdr["Style"].ToString();
                }
            }
            return classificationDetails;
        }
    }
}