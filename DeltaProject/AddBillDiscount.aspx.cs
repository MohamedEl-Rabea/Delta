using DeltaProject.Business_Logic;
using System;
using System.Drawing;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class AddBillDiscount : Page
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
            lblFinishMsg.Text = "";
            txtYear.Text = "";
            txtMonth.Text = "";
            txtDay.Text = "";
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
            }

            PanelErrorMessage.Visible = false;
            PanelBills.Visible = true;
        }

        protected void GridViewBills_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "SelectBill")
            {
                int billId = Convert.ToInt32(((LinkButton)e.CommandSource).Text);

                SaleBill bill = new SaleBill { Id = billId };
                bill.GetBillData();
                lblBillId.Text = billId.ToString();
                lblBillDate.Text = bill.Date.ToString("dd/MM/yyyy");
                lblClientName.Text = bill.ClientName;
                lblPhoneNumber.Text = bill.PhoneNumber;
                lblAddress.Text = bill.Address;
                var totalCost = bill.Items.Sum(i => i.TotalCost);
                lblBillCost.Text = totalCost.ToString("0.##");
                lblPaidValue.Text = bill.PaidAmount?.ToString("0.##");
                lblAdditionalCostValue.Text = bill.AdditionalCost?.ToString("0.##");
                lblAdditionalcostNotes.Text = bill.AdditionalCostNotes;
                var rest = bill.RemainingCost.Value;
                lblRemainingCost.Text = rest.ToString("0.##");
                lblRest.Text = rest >= 0
                    ? rest.ToString("0.##")
                    : (-rest).ToString("0.##") + " " + "فرق تكلفه للعميل";
                lblRest.ForeColor = rest >= 0 ? Color.FromName("#2c3e50") : Color.Red;
                GridViewBillItems.DataSource = bill.Items;
                GridViewBillItems.DataBind();
                PanelBillDetails.Visible = true;
                PanelBills.Visible = false;
            }
        }

        protected void GridViewBillItems_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                var isService = Convert.ToBoolean(e.Row.Cells[9].Text);
                var totalCost = Convert.ToDecimal(((TextBox)e.Row.FindControl("txtTotalCost")).Text);
                var label = (Label)e.Row.FindControl("lblDiscount");
                var text = (TextBox)e.Row.FindControl("txtDiscount");
                label.Visible = isService || totalCost <= 0;
                text.Visible = !isService && totalCost > 0;
            }
        }

        protected void btnFinish_Click(object sender, EventArgs e)
        {
            DateTime date = new DateTime(Convert.ToInt32(txtYear.Text), Convert.ToInt32(txtMonth.Text), Convert.ToInt32(txtDay.Text),
                 DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);

            SaleBill bill = new SaleBill
            {
                Id = Convert.ToInt32(lblBillId.Text),
                UserId = Convert.ToInt32(Session["userId"]),
                Date = date
            };
            btnFinish.Enabled = false;
            btnFinish.BackColor = Color.FromName("#aaa");

            foreach (GridViewRow row in GridViewBillItems.Rows)
            {
                var discount = ((TextBox)row.FindControl("txtDiscount")).Text;
                if (!string.IsNullOrEmpty(discount))
                {
                    BillItem item = new BillItem
                    {
                        Id = Convert.ToInt32(row.Cells[0].Text),
                        ProductId = Convert.ToInt32(row.Cells[1].Text),
                        Name = row.Cells[2].Text,
                        SpecifiedPrice = Convert.ToDecimal(row.Cells[6].Text),
                        Quantity = Convert.ToDecimal(row.Cells[4].Text) - Convert.ToDecimal(row.Cells[5].Text),
                        Discount = Convert.ToDecimal(discount)
                    };
                    bill.Items.Add(item);
                }
            }

            bill.GeneralDiscount = Convert.ToDecimal(txtGeneralDiscount.Text);
            bill.Notes = txtGeneralDiscountNotes.Text;

            if (bill.Items.Any() || !string.IsNullOrEmpty(txtGeneralDiscount.Text))
            {
                if (!bill.AddDiscounts(out string m))
                {
                    lblFinishMsg.Text = m;
                    lblFinishMsg.ForeColor = Color.Red;
                    btnFinish.Enabled = true;
                    btnFinish.BackColor = Color.FromName("#1abc9c");
                }
                else
                {
                    var restOfMoney = Convert.ToDecimal(lblRemainingCost.Text) -
                                      bill.Items.Sum(p => p.Discount);

                    if (restOfMoney < 0) // RestOfMoney greater than bill cost
                    {
                        PanelRest.Visible = true;
                        lblRestOfMoney.Text = (-restOfMoney).ToString("0.##") + " جنيها";
                    }
                    else
                    {
                        lblFinishMsg.Text = "تم بنجاح";
                        lblFinishMsg.ForeColor = Color.Green;
                    }
                }
            }
            else
            {
                lblFinishMsg.Text = "لا يوجد خصومات !";
                lblFinishMsg.ForeColor = Color.Red;
                btnFinish.Enabled = true;
                btnFinish.BackColor = Color.FromName("#1abc9c");
            }
        }

        protected void lnkPay_Click(object sender, EventArgs e)
        {
            Response.Redirect($"~/PaySaleBill.aspx?billId={lblBillId.Text}");
        }
    }
}