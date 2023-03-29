using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace DeltaProject.Business_Logic
{
    [Serializable]
    public class Unit
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public IEnumerable<UnitFactor> UnitFactors { get; set; }

        public List<Unit> GetUnits()
        {
            List<Unit> units = new List<Unit>();

            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(CS))
            {
                SqlCommand cmd = new SqlCommand("SELECT Id, Name FROM Unit", con);
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    units.Add(new Unit { Id = (int)rdr["Id"], Name = rdr["Name"].ToString() });
                }
            }
            return units;
        }

        public bool AddUnit(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("AddUnit", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@mainUnitName", SqlDbType.NVarChar).Value = Name;
                cmd.Parameters.Add("@unitFactors", SqlDbType.Structured).Value = ToDataTable();
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

        public List<Unit> GetUnitsWithFactors()
        {
            List<UnitFactor> unitFactors = new List<UnitFactor>();

            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(CS))
            {
                SqlCommand cmd = new SqlCommand("GetUnitWithFactors", con);
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    unitFactors.Add(new UnitFactor
                    {
                        Id = (int)rdr["Id"],
                        MainUnitName = rdr["MainUnitName"].ToString(),
                        SubUnitName = rdr["SubUnitName"].ToString(),
                        Factor = string.IsNullOrEmpty(rdr["Factor"].ToString()) ? default : (decimal?)rdr["Factor"]
                    });
                }
            }

            var units = unitFactors.GroupBy(g => g.Id)
                .Select(y => new Unit
                {
                    Id = y.Key,
                    Name = y.Max(x => x.MainUnitName),
                    UnitFactors = y.SkipWhile(c => c.Factor == null).Select(c => new UnitFactor
                    {
                        SubUnitName = c.SubUnitName,
                        Factor = c.Factor
                    }).ToList()
                }).ToList();

            return units;
        }

        public bool DeleteUnit(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("DeleteUnit", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@id", SqlDbType.Int).Value = Id;
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

        public bool AddUnitFactors(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("AddUnitFactors", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@mainUnitId", SqlDbType.Int).Value = Id;
                cmd.Parameters.Add("@unitFactors", SqlDbType.Structured).Value = ToDataTable();
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

        private DataTable ToDataTable()
        {
            var table = new DataTable();
            table.Columns.Add("SubUnitId", typeof(int));
            table.Columns.Add("Factor", typeof(decimal));

            if (UnitFactors != null)
            {
                foreach (var item in UnitFactors)
                    table.Rows.Add(item.SubUnitId, item.Factor);
            }

            return table;
        }
    }
}