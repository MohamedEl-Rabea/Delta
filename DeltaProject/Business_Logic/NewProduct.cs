using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace DeltaProject.Business_Logic
{
    [Serializable]
    public class NewProduct
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int ClassificationId { get; set; }
        public string ClassificationName { get; set; }
        public decimal Quantity { get; set; }
        public int UnitId { get; set; }
        public string UnitName { get; set; }
        public decimal? Factor { get; set; }
        public decimal PurchasePrice { get; set; }
        public decimal SellPrice { get; set; }
        public string Description { get; set; }
        public string Mark { get; set; }
        public double? Inch { get; set; }
        public string Style { get; set; }

        public static List<NewProduct> GetProducts()
        {
            List<NewProduct> products = new List<NewProduct>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("GetProducts", con);
            cmd.CommandType = CommandType.StoredProcedure;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                NewProduct product = new NewProduct
                {
                    Id = Convert.ToInt32(rdr["Id"]),
                    Name = rdr["Name"].ToString(),
                    Mark = rdr["Mark"].ToString(),
                    ClassificationId = Convert.ToInt32(rdr["ClassificationId"]),
                    ClassificationName = rdr["ClassificationName"].ToString(),
                    Inch = string.IsNullOrEmpty(rdr["Inch"].ToString())
                        ? (double?)null
                        : Convert.ToDouble(rdr["Inch"]),
                    Style = rdr["Style"].ToString(),
                    PurchasePrice = Convert.ToDecimal(rdr["PurchasePrice"]),
                    Quantity = Convert.ToDecimal(rdr["Quantity"]),
                    UnitId = Convert.ToInt32(rdr["UnitId"]),
                    UnitName = rdr["UnitName"].ToString()
                };
                products.Add(product);
            }
            rdr.Close();
            con.Close();
            return products;
        }
    }
}