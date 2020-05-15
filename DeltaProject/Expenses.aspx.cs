using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;

namespace DeltaProject
{
    public partial class Expenses : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void BtnFinish_Click(object sender, EventArgs e)
        {
            if (ddlCategory.SelectedValue == "دفع مرتجع" && PanelBill_ID.Visible == false)
            {
                PanelBill_ID.Visible = true;
                SetFocus(txtBillID);
            }
            else
            {
                long Bill_ID = 0;
                if (PanelBill_ID.Visible)
                {
                    Bill_ID = Convert.ToInt64(txtBillID.Text);
                }
                #region Add expenses
                Expenses_Class exp = new Expenses_Class();
                exp.Pay_Date = new DateTime(Convert.ToInt32(txtYear.Text), Convert.ToInt32(txtMonth.Text), Convert.ToInt32(txtDay.Text)
                    , DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);
                exp.Category = ddlCategory.SelectedValue;
                exp.Paid_Value = Convert.ToDouble(txtPaid_amount.Text);
                exp.Notes = TxtNotes.Text;
                string m;
                if (!exp.Add_Expenses(out m, Bill_ID))
                {
                    lblFinishMsg.Text = m;
                    lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    lblFinishMsg.Text = "تم بنجاح";
                    lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                }
                SetFocus(BtnFinish);
                #endregion
            }
        }
    }
}