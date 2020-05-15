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
    public partial class Income_Report : System.Web.UI.Page
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
            SqlCommand cmd = new SqlCommand("Get_Income", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Start_Date", SqlDbType.Date).Value = StartDate;
            cmd.Parameters.Add("@End_Date", SqlDbType.Date).Value = EndDate;
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            // Bind incomes
            DataTable table = new DataTable();
            table.Columns.Add("Pay_Date");
            table.Columns.Add("All_Sales");


            while (rdr.Read()) // all sales
            {
                DataRow row = table.NewRow();
                row["Pay_Date"] = Convert.ToDateTime(rdr["Bill_Date"]).ToShortDateString();
                row["All_Sales"] = Convert.ToDouble(rdr["All_Sales"]);

                table.Rows.Add(row);
            }
            GridViewSales.DataSource = table;
            GridViewSales.DataBind();

            #region Paid sales
            if (rdr.NextResult()) // Paid sales
            {
                DataTable Paid_Sales_tbl = new DataTable();
                Paid_Sales_tbl.Columns.Add("Pay_Date");
                Paid_Sales_tbl.Columns.Add("Paid_Sales");
                while (rdr.Read())
                {
                    DataRow row = Paid_Sales_tbl.NewRow();
                    row["Pay_Date"] = Convert.ToDateTime(rdr["Bill_Date"]).ToShortDateString();
                    row["Paid_Sales"] = Convert.ToDouble(rdr["Paid_Sales"]);

                    Paid_Sales_tbl.Rows.Add(row);
                }
                GridViewPaid_Sales.DataSource = Paid_Sales_tbl;
                GridViewPaid_Sales.DataBind();
            }
            #endregion

            #region Paid debts
            if (rdr.NextResult()) // Paid debts
            {
                DataTable Debts_table = new DataTable();
                Debts_table.Columns.Add("Pay_Date");
                Debts_table.Columns.Add("Paid_Debts");
                while (rdr.Read())
                {
                    DataRow row = Debts_table.NewRow();
                    row["Pay_Date"] = Convert.ToDateTime(rdr["Pay_Date"]).ToShortDateString();
                    row["Paid_Debts"] = Convert.ToDouble(rdr["Paid_Debts"]);

                    Debts_table.Rows.Add(row);
                }
                GridViewDebts.DataSource = Debts_table;
                GridViewDebts.DataBind();
            }
            #endregion

            #region simple expeneses
            if (rdr.NextResult()) // simple expeneses (except pay debts to suppliers and purchase products)
            {
                DataTable Expenses_table = new DataTable();
                Expenses_table.Columns.Add("Pay_Date");
                Expenses_table.Columns.Add("Category");
                Expenses_table.Columns.Add("Paid_Value");
                Expenses_table.Columns.Add("Notes");

                while (rdr.Read())
                {
                    DataRow row = Expenses_table.NewRow();
                    row["Pay_Date"] = Convert.ToDateTime(rdr["Pay_Date"]).ToShortDateString();
                    row["Category"] = rdr["Category"];
                    row["Paid_Value"] = Convert.ToDouble(rdr["Paid_Value"]);
                    row["Notes"] = rdr["Notes"];

                    Expenses_table.Rows.Add(row);
                }
                GridViewExpenses.DataSource = Expenses_table;
                GridViewExpenses.DataBind();
            }
            #endregion

            #region huge expeneses
            if (rdr.NextResult()) // huge expeneses (include pay debts to suppliers and purchase products)
            {
                DataTable Expenses_table2 = new DataTable();
                Expenses_table2.Columns.Add("Pay_Date");
                Expenses_table2.Columns.Add("Category");
                Expenses_table2.Columns.Add("Paid_Value");
                Expenses_table2.Columns.Add("Notes");

                while (rdr.Read())
                {
                    DataRow row = Expenses_table2.NewRow();
                    row["Pay_Date"] = Convert.ToDateTime(rdr["Pay_Date"]).ToShortDateString();
                    row["Category"] = rdr["Category"];
                    row["Paid_Value"] = Convert.ToDouble(rdr["Paid_Value"]);
                    row["Notes"] = rdr["Notes"];

                    Expenses_table2.Rows.Add(row);
                }
                GridViewHugeExpenses.DataSource = Expenses_table2;
                GridViewHugeExpenses.DataBind();
            }
            #endregion

            #region Other income
            if (rdr.NextResult()) // Other income
            {
                DataTable Other_Income_Table = new DataTable();
                Other_Income_Table.Columns.Add("Pay_Date");
                Other_Income_Table.Columns.Add("All_Sales");
                Other_Income_Table.Columns.Add("Notes");

                while (rdr.Read())
                {
                    DataRow row = Other_Income_Table.NewRow();
                    row["Pay_Date"] = Convert.ToDateTime(rdr["Bill_Date"]).ToShortDateString();
                    row["All_Sales"] = Convert.ToDouble(rdr["All_Sales"]);
                    row["Notes"] = rdr["Notes"].ToString();

                    Other_Income_Table.Rows.Add(row);
                }
                GridViewOtherIncome.DataSource = Other_Income_Table;
                GridViewOtherIncome.DataBind();
            }
            #endregion

            rdr.Close();
            con.Close();

            lblTotalIncome.Text = (Paid_Debts + Paid_Sales + OtherIncome).ToString() + "جنبه";
            lblExpenses.Text = (TotalExpenses + TotalHugeExpenses).ToString() + "جنيه";
            double Netvalue = ((Paid_Debts + Paid_Sales + OtherIncome) - (TotalExpenses + TotalHugeExpenses));
            lblNetValue.Text = Netvalue >= 0 ? Netvalue.ToString() + " ج.م" : "لا يوجد دخل صافى وفرق المصروفات عن الايراد  = " + (-Netvalue).ToString() + " ج.م" + " مدفوعه من خارج ايراد الشركه";
            PanelReport.Visible = true;
        }

        double Sales = 0;
        protected void GridViewSales_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Sales += Convert.ToDouble(e.Row.Cells[1].Text);
            }
            else if (e.Row.RowType == DataControlRowType.Footer)
            {
                e.Row.Cells[1].Text = Sales.ToString();
            }
        }

        double Paid_Sales = 0;
        protected void GridViewPaid_Sales_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                double Sales_Amount = Convert.ToDouble(GridViewSales.Rows[e.Row.RowIndex].Cells[1].Text);
                double Paid_Amount = Convert.ToDouble(e.Row.Cells[0].Text);
                Paid_Sales += Paid_Amount;
            }
            else if (e.Row.RowType == DataControlRowType.Footer)
            {
                e.Row.Cells[0].Text = Paid_Sales.ToString();
            }
        }

        double Paid_Debts = 0;
        protected void GridViewDebts_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Paid_Debts += Convert.ToDouble(e.Row.Cells[1].Text);
            }
            else if (e.Row.RowType == DataControlRowType.Footer)
            {
                e.Row.Cells[1].Text = Paid_Debts.ToString();
            }
        }

        double TotalExpenses = 0;
        protected void GridViewExpenses_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                TotalExpenses += Convert.ToDouble(e.Row.Cells[2].Text);
            }
            else if (e.Row.RowType == DataControlRowType.Footer)
            {
                e.Row.Cells.RemoveAt(1);
                e.Row.Cells.RemoveAt(2);
                e.Row.Cells[0].ColumnSpan = 2;
                e.Row.Cells[1].ColumnSpan = 2;
                e.Row.Cells[1].Text = TotalExpenses.ToString();
            }
        }

        double TotalHugeExpenses = 0;
        protected void GridViewHugeExpenses_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                TotalHugeExpenses += Convert.ToDouble(e.Row.Cells[2].Text);
            }
            else if (e.Row.RowType == DataControlRowType.Footer)
            {
                e.Row.Cells.RemoveAt(1);
                e.Row.Cells.RemoveAt(2);
                e.Row.Cells[0].ColumnSpan = 2;
                e.Row.Cells[1].ColumnSpan = 2;
                e.Row.Cells[1].Text = TotalHugeExpenses.ToString();
            }
        }

        double OtherIncome = 0;
        protected void GridViewOtherIncome_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                OtherIncome += Convert.ToDouble(e.Row.Cells[1].Text);
            }
            else if (e.Row.RowType == DataControlRowType.Footer)
            {
                e.Row.Cells.RemoveAt(2);
                e.Row.Cells[1].ColumnSpan = 2;
                e.Row.Cells[1].Text = OtherIncome.ToString();
            }
        }
    }
}