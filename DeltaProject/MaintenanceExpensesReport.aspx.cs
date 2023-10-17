using Business_Logic;
using DeltaProject.Business_Logic;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Globalization;
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
                ddlWorkshops.DataSource = Workshop.GetWorkshops();
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
                DateTime? startDate = string.IsNullOrEmpty(txtStartDate.Text)
                    ? null
                    : (DateTime?)DateTime.ParseExact(txtStartDate.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                DateTime? endDate = string.IsNullOrEmpty(txtEndDate.Text)
                    ? null
                    : (DateTime?)DateTime.ParseExact(txtEndDate.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                lblWorkshopName.Text = workshopName;
                lblStartDate.Text = startDate.HasValue ? startDate.Value.ToShortDateString() : "شامل";
                lblEndDate.Text = endDate.HasValue ? endDate.Value.ToShortDateString() : "شامل";

                var maintenanceList = Maintenance.GetMaintenanceReport(workshopId, startDate, endDate);
                BindMaintenanceGridView(maintenanceList);

                if (startDate != null)
                {
                    var pastMaintenanceList = Maintenance.GetPastMaintenanceReport(workshopId, startDate, endDate);
                    BindPastMaintenanceGridView(pastMaintenanceList);
                }

                var expensesList = MaintenanceExpense.GetExpensesReport(workshopId, startDate, endDate);
                BindExpensesGridView(expensesList);

                var withdrawList = MaintenanceWithdraw.GetWithdrawsReport(workshopId, startDate, endDate);
                BindWithdrawsGridView(withdrawList);

                SetSummary(maintenanceList, expensesList, withdrawList);
            }
        }

        private void BindMaintenanceGridView(List<Maintenance> maintenanceList)
        {
            GridViewMaintenance.DataSource = maintenanceList;
            GridViewMaintenance.Columns[3].FooterText = maintenanceList.Sum(p => p.Cost.Value).ToString("0.##");
            GridViewMaintenance.Columns[4].FooterText = maintenanceList.Sum(p => p.PaidAmount.Value).ToString("0.##");
            GridViewMaintenance.Columns[5].FooterText = maintenanceList.Sum(p => p.RemainingAmount).ToString("0.##");
            GridViewMaintenance.DataBind();
        }

        private void BindPastMaintenanceGridView(List<Maintenance> pastMaintenanceList)
        {
            PanelPastMaintenance.Visible = pastMaintenanceList.Any();
            GridPastViewMaintenance.DataSource = pastMaintenanceList;
            GridPastViewMaintenance.Columns[3].FooterText = pastMaintenanceList.Sum(p => p.Cost.Value).ToString("0.##");
            GridPastViewMaintenance.Columns[4].FooterText = pastMaintenanceList.Sum(p => p.PaidAmount.Value).ToString("0.##");
            GridPastViewMaintenance.Columns[5].FooterText = pastMaintenanceList.Sum(p => p.RemainingAmount).ToString("0.##");
            GridPastViewMaintenance.DataBind();
        }

        private void BindExpensesGridView(List<MaintenanceExpense> expensesList)
        {
            GridViewExpenses.DataSource = expensesList;
            GridViewExpenses.Columns[1].FooterText = expensesList.Sum(p => p.Amount).ToString("0.##");
            GridViewExpenses.DataBind();
        }

        private void BindWithdrawsGridView(List<MaintenanceWithdraw> withdrawsList)
        {
            Page.ClientScript.RegisterStartupScript(GetType(), "text", $"AddPartnersGridViews({JsonConvert.SerializeObject(withdrawsList)})", true);

            //withdrawsList = withdrawsList.OrderByDescending(p => p.PartnerId).ToList();
            //GridViewWithdraws.DataSource = withdrawsList;
            //GridViewWithdraws.Columns[2].FooterText = withdrawsList.Sum(p => p.Amount).ToString("0.##");
            //GridViewWithdraws.DataBind();
        }

        private void SetSummary(List<Maintenance> maintenanceList, List<MaintenanceExpense> expensesList, List<MaintenanceWithdraw> withdrawList)
        {
            var profit = maintenanceList.Sum(p => p.PaidAmount.Value) -
                         maintenanceList.Sum(p => p.Cost.Value) -
                         expensesList.Sum(p => p.Amount);
            var debit = maintenanceList.Sum(p => p.RemainingAmount);
            var withdraws = withdrawList.Sum(p => p.Amount);
            var netIncome = (profit - withdraws);
            lblProfit.Text = profit.ToString("0.##");
            lblDebit.Text = debit.ToString("0.##");
            lblWithdraw.Text = withdraws.ToString("0.##");
            lblNetIncome.Text = netIncome.ToString("0.##");

            lblProfit.ForeColor = profit < 0 ? Color.Red : Color.Green;
            lblDebit.ForeColor = debit < 0 ? Color.Red : Color.Green;
            lblWithdraw.ForeColor = withdraws < 0 ? Color.Red : Color.Green;
            lblNetIncome.ForeColor = netIncome < 0 ? Color.Red : Color.Green;
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