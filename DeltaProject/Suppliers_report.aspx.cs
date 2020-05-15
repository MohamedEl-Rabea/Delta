using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace DeltaProject
{
    public partial class Suppliers_report : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
                SqlConnection con = new SqlConnection(CS);
                SqlCommand cmd = new SqlCommand("Get_Suppliers_Report", con);
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                GridViewSuppliers.DataSource = rdr;
                GridViewSuppliers.DataBind();
                rdr.Close();
                con.Close();
            }
        }

        double totalSupplierDebts, totalCompanyDebts = 0;
        protected void GridViewSuppliers_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (Convert.ToDouble(e.Row.Cells[3].Text) < 0)
                {
                    e.Row.BackColor = System.Drawing.Color.LightGray;
                    e.Row.Cells[3].Text = (-Convert.ToDouble(e.Row.Cells[3].Text)).ToString();
                    totalCompanyDebts += Convert.ToDouble(e.Row.Cells[3].Text);
                }
                else
                {
                    e.Row.BackColor = System.Drawing.Color.White;
                    e.Row.Cells[3].Text = (Convert.ToDouble(e.Row.Cells[3].Text)).ToString();
                    totalSupplierDebts += Convert.ToDouble(e.Row.Cells[3].Text);
                }
            }
            else if (e.Row.RowType == DataControlRowType.Footer)
            {
                e.Row.Cells[0].ColumnSpan = 3;
                e.Row.Cells.RemoveAt(1);
                e.Row.Cells.RemoveAt(2);
                e.Row.Cells[1].Text = "ديون  الشركة : " + totalCompanyDebts.ToString() + " - ديون الموردين : " + totalSupplierDebts;
            }
        }
    }
}