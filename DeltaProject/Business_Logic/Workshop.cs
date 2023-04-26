using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace DeltaProject.Business_Logic
{
    public class Workshop
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public IEnumerable<Partner> Partners { get; set; }

        public static List<Workshop> GetWorkshops()
        {
            List<Workshop> workshops = new List<Workshop>();

            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(CS))
            {
                SqlCommand cmd = new SqlCommand("SELECT Id, Name FROM Workshops", con);
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    workshops.Add(new Workshop { Id = (int)rdr["Id"], Name = rdr["Name"].ToString() });
                }
            }
            return workshops;
        }

        public bool Add_Workshop(out string m)
        {
            bool b = true;
            m = "";
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("AddWorkshop", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@name", SqlDbType.NVarChar).Value = this.Name;
                cmd.Parameters.Add("@partners", SqlDbType.Structured).Value = ToDataTable();
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
            table.Columns.Add("WorkshopId", typeof(int));
            table.Columns.Add("Name", typeof(string));

            foreach (var item in Partners)
                table.Rows.Add(item.WorkshopId, item.Name);

            return table;
        }
    }
}