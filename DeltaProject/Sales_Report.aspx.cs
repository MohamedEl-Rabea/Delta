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
            DataTable salesTable = new DataTable();
            salesTable.Columns.Add("Bill_Date");
            salesTable.Columns.Add("P_Name");
            salesTable.Columns.Add("Amount");
            salesTable.Columns.Add("Purchase_Price");
            salesTable.Columns.Add("Specified_Price");
            salesTable.Columns.Add("Sell_Price");

            while (rdr.Read())
            {
                DataRow row = salesTable.NewRow();
                row["Bill_Date"] = Convert.ToDateTime(rdr["Date"]).ToShortDateString();
                row["P_Name"] = rdr["Name"];
                row["Amount"] = Convert.ToInt32(rdr["Quantity"]);
                row["Purchase_Price"] = Convert.ToDouble(rdr["PurchasePrice"]);
                row["Specified_Price"] = Convert.ToDouble(rdr["SpecifiedPrice"]);
                row["Sell_Price"] = Convert.ToDouble(rdr["SellPrice"]);

                salesTable.Rows.Add(row);
            }

            GridViewSales.DataSource = salesTable;
            GridViewSales.DataBind();

            DataTable maintenanceTable = new DataTable();
            maintenanceTable.Columns.Add("Date");
            maintenanceTable.Columns.Add("Description");
            maintenanceTable.Columns.Add("Cost");
            maintenanceTable.Columns.Add("Price");

            rdr.NextResult();

            while (rdr.Read())
            {
                DataRow row = maintenanceTable.NewRow();
                row["Date"] = Convert.ToDateTime(rdr["Date"]).ToShortDateString();
                row["Description"] = rdr["Description"];
                row["Cost"] = Convert.ToDouble(rdr["Cost"]);
                row["Price"] = Convert.ToDouble(rdr["Price"]);

                maintenanceTable.Rows.Add(row);
            }

            GridViewMaintenance.DataSource = maintenanceTable;
            GridViewMaintenance.DataBind();


            DataTable loaderTable = new DataTable();
            loaderTable.Columns.Add("Date");
            loaderTable.Columns.Add("Description");
            loaderTable.Columns.Add("Cost");

            rdr.NextResult();

            while (rdr.Read())
            {
                DataRow row = loaderTable.NewRow();
                row["Date"] = Convert.ToDateTime(rdr["Date"]).ToShortDateString();
                row["Description"] = rdr["Description"];
                row["Cost"] = Convert.ToDouble(rdr["Cost"]);

                loaderTable.Rows.Add(row);
            }

            GridViewLoader.DataSource = loaderTable;
            GridViewLoader.DataBind();

            rdr.Close();
            con.Close();


            lblTotalSales.Text = totalSales.ToString();
            lblearns.Text = (totalSales - totalCost).ToString();
            lblDiff.Text = (totalSales - totalSpecified).ToString();
            PanelReport.Visible = true;
        }

        double totalSales, totalCost, totalSpecified = 0;

        protected void GridViewLoader_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                totalSales += Convert.ToDouble(e.Row.Cells[2].Text);
            }
        }

        protected void GridViewMaintenance_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                totalSales += Convert.ToDouble(e.Row.Cells[3].Text);
                totalCost += Convert.ToDouble(e.Row.Cells[2].Text);
            }
        }

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