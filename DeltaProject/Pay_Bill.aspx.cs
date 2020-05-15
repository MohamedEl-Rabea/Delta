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

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            Bill bill = new Bill();
            bill.Bill_ID = txtBill_ID.Text != "" ? Convert.ToInt64(txtBill_ID.Text) : 0;
            if (string.IsNullOrEmpty(txtBill_ID.Text) || !bill.IsExistsBillWithID())
            {
                PanelPayBill.Visible = false;
                PanelErrorMessage.Visible = true;
            }
            else
            {
                PanelErrorMessage.Visible = false;
                PanelPayBill.Visible = true;
                double Cost, Paid_amount;
                bill = bill.Get_Bill_Info(out Cost, out Paid_amount);
                lblBill_ID.Text = txtBill_ID.Text;
                lblBillDate.Text = bill.Bill_Date.ToShortDateString();
                lblClientName.Text = bill.Client_Name;
                lblBillCost.Text = Cost.ToString();
                lblDiscountValue.Text = bill.Discount.ToString();
                lblPaid_Value.Text = Paid_amount.ToString();
                lblAdditionalCostValue.Text = bill.AdditionalCost.ToString();
                lblAdditionalcostNotes.Text = bill.AdditionalCostNotes;
                lblRest.Text = (Cost + bill.AdditionalCost - Paid_amount - bill.Discount) >= 0 ? (Cost + bill.AdditionalCost - Paid_amount - bill.Discount).ToString()
                    : (-(Cost + bill.AdditionalCost - Paid_amount - bill.Discount)).ToString() + " " + "فرق تكلفه للعميل";
            }
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