using DeltaProject.Business_Logic;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class PaySaleBill : Page
    {
        private List<SaleBill> Bills
        {
            get => ViewState["Bills"] == null
                ? new List<SaleBill>()
                : (List<SaleBill>)ViewState["Bills"];
            set => ViewState["Bills"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var billId = Request.QueryString["billId"];
                if (!string.IsNullOrEmpty(billId))
                {
                    RadioButtonListCategories.SelectedIndex = 2;
                    txtClientName.Visible = false;
                    txtPhoneNumber.Visible = false;
                    txtBillId.Visible = true;
                    txtBillId.Text = billId;
                    ViewState["Bills"] = SaleBill.GetUnpaidBills(null, null, Convert.ToInt32(billId));
                    SelectBill(Convert.ToInt32(billId));
                }
            }
        }

        protected void RadioButtonListCategories_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtClientName.Text = "";
            txtPhoneNumber.Text = "";
            txtBillId.Text = "";
            lblErrorMsg.Text = "";
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
            int? billId = null;
            PanelBills.Visible = false;
            PanelBillDetails.Visible = false;
            lblFinishMsg.Text = "";
            txtYear.Text = "";
            txtMonth.Text = "";
            txtDay.Text = "";
            txtPaidAmount.Text = "";
            txtNotes.Text = "";
            lblErrorMsg.Text = "";
            btnFinish.Enabled = true;
            btnFinish.BackColor = Color.FromName("#1abc9c");
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
                else
                {
                    billId = Convert.ToInt32(txtBillId.Text);
                }
            }

            ViewState["Bills"] = SaleBill.GetUnpaidBills(txtClientName.Text, txtPhoneNumber.Text, billId);
            BindBillsGrid();

            PanelErrorMessage.Visible = false;
            PanelBills.Visible = true;
        }

        protected void GridViewBills_OnPageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridViewBills.PageIndex = e.NewPageIndex;
            BindBillsGrid();
        }

        protected void GridViewBills_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "SelectBill")
            {
                int billId = Convert.ToInt32(((LinkButton)e.CommandSource).Text);
                SelectBill(billId);
            }
        }

        protected void btnFinish_Click(object sender, EventArgs e)
        {
            DateTime date = new DateTime(Convert.ToInt32(txtYear.Text), Convert.ToInt32(txtMonth.Text), Convert.ToInt32(txtDay.Text),
                 DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);

            var id = Convert.ToInt32(lblBillId.Text);
            var paidAmount = Convert.ToDecimal(txtPaidAmount.Text);
            var remainingCost = Bills.FirstOrDefault(p => p.Id == id)?.RemainingCost;

            SaleBill bill = new SaleBill
            {
                Id = id,
                UserId = Convert.ToInt32(Session["userId"]),
                Date = date,
                PaidAmount = remainingCost < 0 ? -paidAmount : paidAmount,
                Notes = txtNotes.Text
            };
            btnFinish.Enabled = false;
            btnFinish.BackColor = Color.FromName("#aaa");

            if (!bill.Pay(out string m))
            {
                lblFinishMsg.Text = m;
                lblFinishMsg.ForeColor = Color.Red;
                btnFinish.Enabled = true;
                btnFinish.BackColor = Color.FromName("#1abc9c");
            }
            else
            {
                lblFinishMsg.Text = "تم بنجاح";
                lblFinishMsg.ForeColor = Color.Green;
            }
        }

        private void BindBillsGrid()
        {
            GridViewBills.DataSource = Bills;
            GridViewBills.DataBind();
        }

        private void SelectBill(int billId)
        {
            SaleBill bill = Bills.FirstOrDefault(p => p.Id == billId);
            var remainingCost = bill?.RemainingCost != null
                ? Math.Abs((decimal)bill.RemainingCost).ToString("0.##")
                : null;
            lblBillId.Text = billId.ToString();
            lblBillDate.Text = bill?.Date.ToString("dd/MM/yyyy");
            lblClientName.Text = bill?.ClientName;
            lblAddress.Text = bill?.Address;
            lblBillCost.Text = bill?.TotalCost?.ToString("0.##");
            lblPaidValue.Text = bill?.PaidAmount?.ToString("0.##");
            lblAddtionalCostValue.Text = bill?.AdditionalCost?.ToString("0.##");
            lblAdditionalcostNotes.Text = bill?.AdditionalCostNotes;
            lblRest.Text = bill?.RemainingCost >= 0
                ? bill.RemainingCost?.ToString("0.##")
                : (-bill?.RemainingCost)?.ToString("0.##") + " " + "فرق تكلفه للعميل";
            lblRest.ForeColor = bill?.RemainingCost >= 0 ? Color.FromName("#2c3e50") : Color.Red;
            txtRemainingCost.Text = remainingCost;
            GridViewBillItems.DataSource = bill?.Items;
            GridViewBillItems.Columns[7].FooterText = bill?.Items.Sum(b => b.TotalCost).ToString("0.##");
            GridViewBillItems.DataBind();
            PanelBillDetails.Visible = !string.IsNullOrEmpty(remainingCost);
            PanelBills.Visible = false;
            if (string.IsNullOrEmpty(remainingCost))
                lblErrorMsg.Text = "هذه الفاتورة مدفوعة بالكامل";
            else
                lblErrorMsg.Text = "";
        }
    }
}