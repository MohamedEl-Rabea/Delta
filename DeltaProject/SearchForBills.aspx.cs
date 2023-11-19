using DeltaProject.Business_Logic;
using System;
using System.Drawing;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class SearchForBills : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void RadioButtonListCategories_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtClientName.Text = "";
            txtPhoneNumber.Text = "";
            txtBillId.Text = "";
            PanelBills.Visible = false;
            if (RadioButtonListCategories.SelectedValue == "ClientName")
            {
                txtClientName.Visible = true;
                txtPhoneNumber.Visible = false;
                txtBillId.Visible = false;
            }
            else if (RadioButtonListCategories.SelectedValue == "PhoneNumber")
            {
                txtClientName.Visible = false;
                txtPhoneNumber.Visible = true;
                txtBillId.Visible = false;
            }
            else
            {
                txtClientName.Visible = false;
                txtPhoneNumber.Visible = false;
                txtBillId.Visible = true;
            }
        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            PanelBills.Visible = false;
            PanelBillDetails.Visible = false;
            if (txtClientName.Visible)
            {
                if (string.IsNullOrEmpty(txtClientName.Text))
                {
                    PanelErrorMessage.Visible = true;
                }
            }
            else if (txtPhoneNumber.Visible)
            {
                txtClientName.Text = "";
                if (string.IsNullOrEmpty(txtPhoneNumber.Text))
                {
                    PanelErrorMessage.Visible = true;
                }
            }
            else // search with Bill ID
            {
                txtClientName.Text = "";
                if (string.IsNullOrEmpty(txtBillId.Text))
                {
                    PanelErrorMessage.Visible = true;
                }
            }

            PanelErrorMessage.Visible = false;
            PanelBills.Visible = true;
            lnkPaidBills_Click(sender, null);
        }

        protected void lnkPaidBills_Click(object sender, EventArgs e)
        {
            PanelPaidBills.Visible = true;
            PanelPaidUnBills.Visible = false;
            lnkPaidBills.ForeColor = Color.White;
            lnkUnpaidBills.ForeColor = Color.Black;
            GridViewPaidBills.DataBind();
            GridViewPaidBills.PageIndex = 0;
        }

        protected void lnkUnpaidBills_Click(object sender, EventArgs e)
        {
            PanelPaidBills.Visible = false;
            PanelPaidUnBills.Visible = true;
            lnkPaidBills.ForeColor = Color.Black;
            lnkUnpaidBills.ForeColor = Color.White;
            GridViewUnPaidBills.DataBind();
            GridViewUnPaidBills.PageIndex = 0;
        }

        protected void GridViewPaidBills_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "SelectBill")
            {
                int billId = Convert.ToInt32(((LinkButton)e.CommandSource).Text);
                SelectBill(billId);
            }
        }

        protected void GridViewUnPaidBills_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "SelectBill")
            {
                int billId = Convert.ToInt32(((LinkButton)e.CommandSource).Text);
                SelectBill(billId);
            }
        }

        double _totalCost = 0;
        protected void GridViewBillItems_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                double cost = (Convert.ToDouble(e.Row.Cells[2].Text) - Convert.ToDouble(e.Row.Cells[3].Text))
                    * Convert.ToDouble(e.Row.Cells[4].Text) - Convert.ToDouble(e.Row.Cells[5].Text);
                ((Label)e.Row.FindControl("lblCost")).Text = cost.ToString("0.##");
                _totalCost += cost;
            }
            else if (e.Row.RowType == DataControlRowType.Footer)
            {
                e.Row.Cells.Clear();
                TableCell cell = new TableCell();
                cell.ColumnSpan = 6;
                cell.Text = "اجمـــــالى  : .............................................................................................................. ";
                e.Row.Cells.Add(cell);
                TableCell cell2 = new TableCell();
                cell2.ColumnSpan = 1;
                cell2.Text = _totalCost.ToString("0.##");
                e.Row.Cells.Add(cell2);
            }
        }

        private void SelectBill(int billId)
        {
            SaleBill bill = new SaleBill { Id = billId };
            bill.GetBillData();
            lblBillId.Text = billId.ToString();
            lblBillDate.Text = bill.Date.ToString("dd/MM/yyyy");
            lblClientName.Text = bill.ClientName;
            lblAddress.Text = bill.Address;
            lblPhoneNumber.Text = bill.PhoneNumber;
            var totalCost = bill.Items.Sum(i => i.TotalCost);
            lblBillCost.Text = totalCost.ToString("0.##");
            lblPaidValue.Text = bill.PaidAmount?.ToString("0.##");
            lblGeneralDiscount.Text = bill.GeneralDiscount?.ToString("0.##");
            lblAdditionalCostValue.Text = bill.AdditionalCost?.ToString("0.##");
            lblAdditionalcostNotes.Text = bill.AdditionalCostNotes;
            var rest = bill.RemainingCost.Value;
            lblRest.Text = rest >= 0
                ? rest.ToString("0.##")
                : (-rest).ToString("0.##") + " " + "فرق تكلفه للعميل";
            lblRest.ForeColor = rest >= 0 ? Color.FromName("#2c3e50") : Color.Red;
            GridViewBillItems.DataSource = bill.Items;
            GridViewBillItems.DataBind();

            bill.GetHistory();
            GridViewHistory.DataSource = bill.History;
            GridViewHistory.DataBind();
            PanelBillDetails.Visible = true;
            PanelBills.Visible = false;
        }
    }
}