using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace Business_Logic
{
    public class Supplier_Payments_Documents
    {
        public byte[] Image { get; set; }
        public DateTime Image_Date { get; set; }

        public bool Add_Supplier_Payment_Images(out string m, string Supplier_Name)
        {
            m = "";
            bool b = true;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            try
            {
                SqlCommand cmd = new SqlCommand("Add_Supplier_Payment_Images", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@S_Name", SqlDbType.NVarChar).Value = Supplier_Name;
                cmd.Parameters.Add("@Image", SqlDbType.Image).Value = this.Image;
                cmd.Parameters.Add("@Image_Date", SqlDbType.Date).Value = this.Image_Date;
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
                return b;
            }
            catch (Exception ex)
            {
                m = ex.Message;
                con.Close();
                b = false;
                return b;
            }
        }

        public static List<Supplier_Payments_Documents> Get_Images (string S_Name, DateTime Image_Date)
        {
            List<Supplier_Payments_Documents> DOCs = new List<Supplier_Payments_Documents>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Supplier_Images", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@S_Name", SqlDbType.NVarChar).Value = S_Name;
            cmd.Parameters.Add("@Date", SqlDbType.Date).Value = Image_Date;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                Supplier_Payments_Documents doc = new Supplier_Payments_Documents();
                doc.Image = (byte[])rdr["Image_Data"];
                DOCs.Add(doc);
            }
            rdr.Close();
            con.Close();
            return DOCs;
        }
    }
}