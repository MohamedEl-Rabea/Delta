using Business_Logic;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class IncomesAndExpensesReport1 : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            BindGridView();
        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            BindGridView();
        }

        protected void GridViewData_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                var result = Convert.ToDouble(HttpUtility.HtmlDecode(HttpUtility.HtmlDecode(e.Row.Cells[1].Text)));
                if (result < 0)
                    e.Row.BackColor = Color.Yellow;
            }
        }

        private void BindGridView()
        {
            PanelStatement.Visible = true;
            PanelErrorMessage.Visible = false;

            DateTime startDate = string.IsNullOrEmpty(txtStartDate.Text)
                            ? DateTime.Now
                            : DateTime.ParseExact(txtStartDate.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
            DateTime endDate = string.IsNullOrEmpty(txtEndDate.Text)
                ? DateTime.Now
                : DateTime.ParseExact(txtEndDate.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);

            List<IncomeAndExpense> incomesAndExpenses = IncomeAndExpense.GetReportData(startDate, endDate);

            var incomes = incomesAndExpenses.Where(p => p.Amount > 0).Sum(p => p.Amount);
            var expenses = incomesAndExpenses.Where(p => p.Amount < 0).Sum(p => p.Amount);
            lblIncomes.Text = Math.Abs(incomes).ToString("0.##");
            lblExpenses.Text = Math.Abs(expenses).ToString("0.##");
            lblٌRemaining.Text = (incomes + expenses).ToString("0.##");

            GridViewData.DataSource = incomesAndExpenses;
            GridViewData.DataBind();
        }

        protected void ImageButton2_Click(object sender, ImageClickEventArgs e)
        {
            GeneratePdf(pdfHiddenContentField.Value, $"تقرير الايرادات و المصروفات");
        }

        private void GeneratePdf(string html, string fileName)
        {
            var renderer = new IronPdf.ChromePdfRenderer();
            renderer.RenderingOptions.MarginTop = 5;
            renderer.RenderingOptions.MarginBottom = 5;
            renderer.RenderingOptions.MarginLeft = 5;
            renderer.RenderingOptions.MarginRight = 5;

            Response.ClearContent();
            Response.ClearHeaders();

            Response.ContentType = "application/pdf";

            var binaryData = renderer.RenderHtmlAsPdf(html).BinaryData;

            Response.BinaryWrite(binaryData);

            Response.Flush();
            Response.Close();
        }
    }
}