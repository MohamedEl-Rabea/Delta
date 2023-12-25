using DeltaProject.Business_Logic;
using System;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class LoaderExpensesReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ddlLoaders.DataSource = Loader.GetLoaders();
                ddlLoaders.DataBind();
                ddlLoaders.Items.Insert(0, new ListItem("إختر ونش", ""));
                ddlLoaders.SelectedIndex = 0;
            }
        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            if (ddlLoaders.SelectedIndex == 0)
            {
                PanelReport.Visible = false;
                PanelErrorMessage.Visible = true;
            }
            else
            {
                PanelReport.Visible = true;
                PanelErrorMessage.Visible = false;
                int loaderId = Convert.ToInt32(ddlLoaders.SelectedValue);
                string loaderName = ddlLoaders.SelectedItem.Text;
                DateTime? startDate = string.IsNullOrEmpty(txtStartDate.Text)
                    ? null
                    : (DateTime?)DateTime.ParseExact(txtStartDate.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                DateTime? endDate = string.IsNullOrEmpty(txtEndDate.Text) 
                    ? null 
                    : (DateTime?)DateTime.ParseExact(txtEndDate.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                lblLoaderName.Text = loaderName;
                lblStartDate.Text = startDate.HasValue ? startDate.Value.ToShortDateString() : "شامل";
                lblEndDate.Text = endDate.HasValue ? endDate.Value.ToShortDateString() : "شامل";

                var maintenanceList = LoaderProcess.GetLoaderProcessesReport(loaderId, startDate, endDate);
                GridViewLoaderProcesses.DataSource = maintenanceList;
                GridViewLoaderProcesses.Columns[2].FooterText = maintenanceList.Sum(p => p.Cost).ToString("0.##");
                GridViewLoaderProcesses.Columns[3].FooterText = maintenanceList.Sum(p => p.PaidAmount.Value).ToString("0.##");
                GridViewLoaderProcesses.Columns[4].FooterText = maintenanceList.Sum(p => p.RemainingAmount).ToString("0.##");
                GridViewLoaderProcesses.DataBind();

                var expensesList = LoaderExpense.GetExpensesReport(loaderId, startDate, endDate);
                GridViewExpenses.DataSource = expensesList;
                GridViewExpenses.Columns[1].FooterText = expensesList.Sum(p => p.Amount).ToString("0.##");
                GridViewExpenses.DataBind();

                var profit = maintenanceList.Sum(p => p.PaidAmount.Value) - expensesList.Sum(p => p.Amount);
                lblProfit.Text = profit.ToString("0.##");

                if (profit < 0)
                    lblProfit.ForeColor = Color.Red;
                else
                    lblProfit.ForeColor = Color.Green;

            }
        }

        protected void ImageButton2_Click(object sender, ImageClickEventArgs e)
        {
            GeneratePdf(pdfHiddenContentField.Value, $"تقرير عمليات ونش [{lblLoaderName.Text}]");
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

            Response.ContentType = "application/pdf";//pdf type

            var binaryData = renderer.RenderHtmlAsPdf(html).BinaryData;

            Response.BinaryWrite(binaryData);

            Response.Flush();
            Response.Close();
        }
    }
}