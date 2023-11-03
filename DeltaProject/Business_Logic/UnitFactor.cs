using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace DeltaProject.Business_Logic
{
    [Serializable]
    public class UnitFactor
    {
        public int Id { get; set; }
        public int MainUnitId { get; set; }
        public string MainUnitName { get; set; }
        public int SubUnitId { get; set; }
        public string SubUnitName { get; set; }
        public decimal? Factor { get; set; }

        public IEnumerable<UnitFactor> GetUnitFactors()
        {
            List<UnitFactor> unitFactors = new List<UnitFactor>();

            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(CS))
            {
                SqlCommand cmd = new SqlCommand("GetUnitFactorsByMainUnitId", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@mainUnitId", SqlDbType.Int).Value = MainUnitId;
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    unitFactors.Add(new UnitFactor
                    {
                        Id = (int)rdr["Id"],
                        SubUnitId = (int)rdr["SubUnitId"],
                        SubUnitName = rdr["SubUnitName"].ToString(),
                        Factor = (decimal?)rdr["Factor"]
                    });
                }
            }

            return unitFactors;
        }
    }
}