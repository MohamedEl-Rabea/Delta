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
    public partial class Sales_Report : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void BtnReport_Click(object sender, EventArgs e)
        {
            DateTime StartDate = new DateTime(Convert.ToInt32(txtStartYear.Text), Convert.ToInt32(txtStartMonth.Text), Convert.ToInt32(txtStartDay.Text));
            DateTime EndDate = new DateTime(Convert.ToInt32(txtEndYear.Text), Convert.ToInt32(txtEndMonth.Text), Convert.ToInt32(txtEndDay.Text));
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Sales_Report", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Start_Date", SqlDbType.Date).Value = StartDate;
            cmd.Parameters.Add("@End_Date", SqlDbType.Date).Value = EndDate;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            // Bind incomes
            DataTable table = new DataTable();
            table.Columns.Add("Bill_Date");
            table.Columns.Add("P_Name");
            table.Columns.Add("Amount");
            table.Columns.Add("Purchase_Price");
            table.Columns.Add("Specified_Price");
            table.Columns.Add("Sell_Price");

            while (rdr.Read())
            {
                DataRow row = table.NewRow();
                row["Bill_Date"] = Convert.ToDateTime(rdr["Bill_Date"]).ToShortDateString();
                row["P_Name"] = rdr["P_Name"];
                row["Amount"] = Convert.ToInt32(rdr["Amount"]);
                row["Purchase_Price"] = Convert.ToDouble(rdr["Purchase_Price"]);
                row["Specified_Price"] = Convert.ToDouble(rdr["Specified_Price"]);
                row["Sell_Price"] = Convert.ToDouble(rdr["Sell_Price"]);

                table.Rows.Add(row);
            }
            rdr.Close();
            con.Close();

            GridViewSales.DataSource = table;
            GridViewSales.DataBind();

            lblTotalSales.Text = totalSales.ToString();
            lblearns.Text = (totalSales - totalCost).ToString();
            lblDiff.Text = (totalSales - totalSpecified).ToString();
            PanelReport.Visible = true;
        }

        double totalSales, totalCost, totalSpecified = 0;
        protected void GridViewSales_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                totalSales += Convert.ToDouble(e.Row.Cells[5].Text) * Convert.ToInt32(e.Row.Cells[2].Text);
                totalSpecified += Convert.ToDouble(e.Row.Cells[4].Text) * Convert.ToInt32(e.Row.Cells[2].Text);
                totalCost +=  Convert.ToDouble(e.Row.Cells[3].Text) *Convert.ToInt32(e.Row.Cells[2].Text);
            }
        }
    }
}