using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;

namespace DeltaProject
{
    public partial class Pay_Bill : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        protected void RadioButtonListCategories_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (RadioButtonListCategories.SelectedIndex == 0)
            {
                TextBoxSearch.Visible = true;
                txtBill_ID.Visible = false;
            }
            else
            {
                TextBoxSearch.Visible = false;
                txtBill_ID.Visible = true;
            }
        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            PanelPayBill.Visible = false;
            PanelBills.Visible = false;
            PanelErrorMessage.Visible = false;

            Bill bill = new Bill();
            if (TextBoxSearch.Visible)
            {
                bill.Client_Name = TextBoxSearch.Text;
                if (string.IsNullOrEmpty(TextBoxSearch.Text) || !bill.IsExistsBill())
                    PanelErrorMessage.Visible = true;
                else
                    PanelBills.Visible = true;
            }
            else
            {
                bill.Bill_ID = Convert.ToInt64(txtBill_ID.Text);
                if (string.IsNullOrEmpty(txtBill_ID.Text) || !bill.IsExistsBillWithID())
                    PanelErrorMessage.Visible = true;
                else
                {
                    SetBillInfo(bill.Bill_ID);
                    PanelPayBill.Visible = true;
                }
            }
        }

        protected void GridViewPaidBills_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Select_Bill")
            {
                long Bill_ID = Convert.ToInt64(((LinkButton)e.CommandSource).Text);
                // select bill info
                SetBillInfo(Bill_ID);
                PanelPayBill.Visible = true;
                PanelBills.Visible = false;
            }
        }

        private void SetBillInfo(long billId)
        {
            Bill bill = new Bill();
            bill.Bill_ID = billId;
            double Cost, Paid_amount;
            bill = bill.Get_Bill_Info(out Cost, out Paid_amount);
            lblBill_ID.Text = billId.ToString();
            lblBillDate.Text = bill.Bill_Date.ToShortDateString();
            lblClientName.Text = bill.Client_Name;
            lblBillCost.Text = Cost.ToString();
            if (bill.Discount == 0)
            {
                lblDiscountValue.Visible = false;
                lblDiscount.Visible = false;
            }
            else
            {
                lblDiscountValue.Text = bill.Discount.ToString();
            }

            lblPaid_Value.Text = Paid_amount.ToString();
            lblAdditionalCostValue.Text = bill.AdditionalCost.ToString();
            lblAdditionalcostNotes.Text = bill.AdditionalCostNotes;
            lblRest.Text = (Cost + bill.AdditionalCost - Paid_amount - bill.Discount) >= 0
                ? (Cost + bill.AdditionalCost - Paid_amount - bill.Discount).ToString()
                : (-(Cost + bill.AdditionalCost - Paid_amount - bill.Discount)).ToString() + " " + "فرق تكلفه للعميل";
            // select bill items
            ViewState["Bill_ID"] = billId;
        }

        protected void BtnFinish_Click(object sender, EventArgs e)
        {
            Bill_Payments payment = new Bill_Payments();
            payment.Pay_Date = new DateTime(Convert.ToInt32(txtYear.Text), Convert.ToInt32(txtMonth.Text), Convert.ToInt32(txtDay.Text), DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);
            payment.Paid_amount = Convert.ToDouble(txtPaid_amount.Text);
            payment.Notes = TxtNotes.Text;
            if (txtDiscount.Text == "")
            {
                payment.Add_Bill_Payment(Convert.ToInt64(lblBill_ID.Text));
            }
            else
            {
                payment.Add_Bill_Payment(Convert.ToInt64(lblBill_ID.Text), Convert.ToDouble(txtDiscount.Text));
            }
            lblFinishMsg.Text = "تم بنجاح";
        }
    }
}