using Business_Logic;
using DeltaProject.Business_Logic;
using System;
using System.Drawing;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class MaintenanceExpensesReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Workshop workshop = new Workshop();
                ddlWorkshops.DataSource = workshop.GetWorkshops();
                ddlWorkshops.DataBind();
                ddlWorkshops.Items.Insert(0, new ListItem("إختر ورشة", ""));
                ddlWorkshops.SelectedIndex = 0;
            }
        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            if (ddlWorkshops.SelectedIndex == 0)
            {
                PanelReport.Visible = false;
                PanelErrorMessage.Visible = true;
            }
            else
            {
                PanelReport.Visible = true;
                PanelErrorMessage.Visible = false;
                int workshopId = Convert.ToInt32(ddlWorkshops.SelectedValue);
                string workshopName = ddlWorkshops.SelectedItem.Text;
                DateTime? startDate = string.IsNullOrEmpty(txtStartDate.Text) ? null : (DateTime?)Convert.ToDateTime(txtStartDate.Text);
                DateTime? endDate = string.IsNullOrEmpty(txtEndDate.Text) ? null : (DateTime?)Convert.ToDateTime(txtEndDate.Text);
                lblWorkshopName.Text = workshopName;
                lblStartDate.Text = startDate.HasValue ? startDate.Value.ToShortDateString() : "شامل";
                lblEndDate.Text = endDate.HasValue ? endDate.Value.ToShortDateString() : "شامل";

                var maintenanceList = Maintenance.GetMaintenanceReport(workshopId, startDate, endDate);
                GridViewMaintenance.DataSource = maintenanceList;
                GridViewMaintenance.Columns[3].FooterText = maintenanceList.Sum(p => p.Cost).ToString("0.##");
                GridViewMaintenance.Columns[4].FooterText = maintenanceList.Sum(p => p.PaidAmount).ToString("0.##");
                GridViewMaintenance.Columns[5].FooterText = maintenanceList.Sum(p => p.RemainingAmount).ToString("0.##");
                GridViewMaintenance.DataBind();

                var expensesList = MaintenanceExpense.GetExpensesReport(workshopId, startDate, endDate);
                GridViewExpenses.DataSource = expensesList;
                GridViewExpenses.Columns[1].FooterText = expensesList.Sum(p => p.Amount).ToString("0.##");
                GridViewExpenses.DataBind();

                var profit = maintenanceList.Sum(p => p.PaidAmount) -
                             maintenanceList.Sum(p => p.Cost) -
                             expensesList.Sum(p => p.Amount);
                lblProfit.Text = profit.ToString("0.##");

                if (profit < 0)
                    lblProfit.ForeColor = Color.Red;
                else
                    lblProfit.ForeColor = Color.Green;
            }
        }

        protected void ImageButton2_Click(object sender, ImageClickEventArgs e)
        {
            GeneratePdf(pdfHiddenContentField.Value, $"تقرير صيانات ورشة [{lblWorkshopName.Text}]");
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