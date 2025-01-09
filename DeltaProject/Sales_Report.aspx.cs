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
            salesTable.Columns.Add("Discount");
            salesTable.Columns.Add("Total");

            while (rdr.Read())
            {
                DataRow row = salesTable.NewRow();
                row["Bill_Date"] = Convert.ToDateTime(rdr["Date"]).ToShortDateString();
                row["P_Name"] = rdr["Name"];
                row["Amount"] = Convert.ToInt32(rdr["Quantity"]);
                row["Purchase_Price"] = Convert.ToDouble(rdr["PurchasePrice"]);
                row["Specified_Price"] = Convert.ToDouble(rdr["SpecifiedPrice"]);
                row["Discount"] = Convert.ToDouble(rdr["Discount"]);
                row["Total"] = (Convert.ToDouble(rdr["SpecifiedPrice"]) * Convert.ToInt32(rdr["Quantity"])) - Convert.ToDouble(rdr["Discount"]);

                salesTable.Rows.Add(row);
            }

            GridViewSales.DataSource = salesTable;
            GridViewSales.DataBind();

            DataTable maintenanceTable = new DataTable();
            maintenanceTable.Columns.Add("WorkshopName");
            maintenanceTable.Columns.Add("Cost");
            maintenanceTable.Columns.Add("Price");
            maintenanceTable.Columns.Add("Expenses");

            rdr.NextResult();

            while (rdr.Read())
            {
                DataRow row = maintenanceTable.NewRow();
                row["WorkshopName"] = rdr["WorkshopName"];
                row["Cost"] = Convert.ToDouble(rdr["Cost"]);
                row["Price"] = Convert.ToDouble(rdr["Price"]);
                row["Expenses"] = Convert.ToDouble(rdr["Expenses"]);

                maintenanceTable.Rows.Add(row);
            }

            GridViewMaintenance.DataSource = maintenanceTable;
            GridViewMaintenance.DataBind();


            DataTable loaderTable = new DataTable();
            loaderTable.Columns.Add("LoaderName");
            loaderTable.Columns.Add("Cost");
            loaderTable.Columns.Add("Expenses");

            rdr.NextResult();

            while (rdr.Read())
            {
                DataRow row = loaderTable.NewRow();
                row["LoaderName"] = rdr["LoaderName"];
                row["Cost"] = Convert.ToDouble(rdr["Cost"]);
                row["Expenses"] = Convert.ToDouble(rdr["Expenses"]);

                loaderTable.Rows.Add(row);
            }

            GridViewLoader.DataSource = loaderTable;
            GridViewLoader.DataBind();

            rdr.Close();
            con.Close();

            PanelReport.Visible = true;
        }

        double _total = 0;
        double _totalExpenses = 0;
        protected void GridViewSales_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                _total += Convert.ToDouble(e.Row.Cells[6].Text);
                _totalExpenses += (Convert.ToDouble(e.Row.Cells[2].Text) * Convert.ToDouble(e.Row.Cells[3].Text));
            }
            else if (e.Row.RowType == DataControlRowType.Footer)
            {
                e.Row.Cells.Clear();
                TableCell cell = new TableCell();
                cell.ColumnSpan = 1;
                cell.Text = "الاجمـــــالى:";
                e.Row.Cells.Add(cell);
                TableCell cell2 = new TableCell();
                cell2.ColumnSpan = 1;
                cell2.Text = _total.ToString("0.##");
                e.Row.Cells.Add(cell2);
                TableCell cell3 = new TableCell();
                cell3.ColumnSpan = 2;
                cell3.Text = "اجمالى الارباح:";
                e.Row.Cells.Add(cell3);
                TableCell cell4 = new TableCell();
                cell4.ColumnSpan = 3;
                cell4.Text = (_total - _totalExpenses).ToString("0.##");
                e.Row.Cells.Add(cell4);
            }
        }
    }
}