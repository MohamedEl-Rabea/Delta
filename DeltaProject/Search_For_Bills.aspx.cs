using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;

namespace DeltaProject
{
    public partial class Search_For_Bills : System.Web.UI.Page
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
            PanelBill.Visible = false;
            if (TextBoxSearch.Visible)
            {
                Bill bill = new Bill();
                bill.Client_Name = TextBoxSearch.Text;
                if (string.IsNullOrEmpty(TextBoxSearch.Text) || !bill.IsExistsBill())
                {
                    PanelBills.Visible = false;
                    PanelErrorMessage.Visible = true;
                }
                else
                {
                    PanelBills.Visible = true;
                    PanelErrorMessage.Visible = false;
                    PanelPaidBills.Visible = true;
                    PanelUnPaidBills.Visible = false;
                    lnkBtnPaidBills.ForeColor = System.Drawing.Color.White;
                    lnkBtnUnpaidBills.ForeColor = System.Drawing.Color.Black;
                    GridViewPaidBills.PageIndex = 0;
                }
            }
            else // search by Bill_ID
            {
                Bill bill = new Bill();
                bill.Bill_ID = txtBill_ID.Text != "" ? Convert.ToInt64(txtBill_ID.Text) : 0;
                if (string.IsNullOrEmpty(txtBill_ID.Text) || !bill.IsExistsBillWithID())
                {
                    PanelBills.Visible = false;
                    PanelErrorMessage.Visible = true;
                }
                else
                {
                    PanelErrorMessage.Visible = false;
                    PanelBill.Visible = true;
                    double Cost, Paid_amount;
                    bill = bill.Get_Bill_Info(out Cost, out Paid_amount);
                    lblBill_ID.Text = txtBill_ID.Text;
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
                    lblRest.Text = (Cost + bill.AdditionalCost - Paid_amount - bill.Discount) >= 0 ? (Cost + bill.AdditionalCost - Paid_amount - bill.Discount).ToString() :
                        (-(Cost + bill.AdditionalCost - Paid_amount - bill.Discount)).ToString() + " " + "فرق تكلفه للعميل";
                    // select bill items
                    ViewState["Bill_ID"] = txtBill_ID.Text;
                    BindBill(Convert.ToInt64(txtBill_ID.Text));
                    GridViewPayments.DataSource = Bill_Payments.Get_Bill_Payments(Convert.ToInt64(txtBill_ID.Text));
                    GridViewPayments.DataBind();
                }
            }
        }

        protected void lnkBtnPaidBills_Click(object sender, EventArgs e)
        {
            PanelPaidBills.Visible = true;
            PanelUnPaidBills.Visible = false;
            lnkBtnPaidBills.ForeColor = System.Drawing.Color.White;
            lnkBtnUnpaidBills.ForeColor = System.Drawing.Color.Black;
            GridViewPaidBills.PageIndex = 0;

        }

        protected void lnkBtnUnpaidBills_Click(object sender, EventArgs e)
        {
            PanelPaidBills.Visible = false;
            PanelUnPaidBills.Visible = true;
            lnkBtnPaidBills.ForeColor = System.Drawing.Color.Black;
            lnkBtnUnpaidBills.ForeColor = System.Drawing.Color.White;
            GridViewUnPaidBills.DataBind();
            GridViewUnPaidBills.PageIndex = 0;
        }

        protected void GridViewPaidBills_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Select_Bill")
            {
                long Bill_ID = Convert.ToInt64(((LinkButton)e.CommandSource).Text);
                // select bill info
                Bill bill = new Bill();
                bill.Bill_ID = Bill_ID;
                double Cost, Paid_amount;
                bill = bill.Get_Bill_Info(out Cost, out Paid_amount);
                lblBill_ID.Text = Bill_ID.ToString();
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
                lblRest.Text = (Cost + bill.AdditionalCost - Paid_amount - bill.Discount) >= 0 ? (Cost + bill.AdditionalCost - Paid_amount - bill.Discount).ToString() :
                    (-(Cost + bill.AdditionalCost - Paid_amount - bill.Discount)).ToString() + " " + "فرق تكلفه للعميل";
                // select bill items
                ViewState["Bill_ID"] = Bill_ID;
                BindBill(Bill_ID);
                GridViewPayments.DataSource = Bill_Payments.Get_Bill_Payments(Bill_ID);
                GridViewPayments.DataBind();
                PanelBill.Visible = true;
                PanelBills.Visible = false;
            }
        }

        private void BindBill(long Bill_ID)
        {
            GridViewBillList.DataSource = Bill_Content.Get_Bill_Items(Bill_ID);
            GridViewBillList.DataBind();
        }

        double TotalCost = 0;
        protected void GridViewBillList_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                double cost = Convert.ToDouble(e.Row.Cells[1].Text) * Convert.ToDouble(e.Row.Cells[2].Text);
                ((Label)e.Row.FindControl("lblCost")).Text = cost.ToString();
                TotalCost += cost;
            }
            else if (e.Row.RowType == DataControlRowType.Footer)
            {
                e.Row.Cells.Clear();
                TableCell cell = new TableCell();
                cell.ColumnSpan = 3;
                cell.Text = "اجمـــــالى  : ..............................................................................................................";
                e.Row.Cells.Add(cell);
                TableCell cell2 = new TableCell();
                cell2.ColumnSpan = 1;
                cell2.Text = TotalCost.ToString();
                e.Row.Cells.Add(cell2);
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (GridViewBillList.Rows.Count > 0)
            {
                TotalCost = 0;
                BindBill(Convert.ToInt64(ViewState["Bill_ID"]));
            }
        }

        protected void GridViewPayments_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (Convert.ToDouble(e.Row.Cells[1].Text) == 0 && e.Row.Cells[2].Text.Contains("باعادة"))
                {
                    e.Row.BackColor = System.Drawing.Color.SteelBlue;
                    e.Row.ForeColor = System.Drawing.Color.White;
                    e.Row.Cells[1].Text = "مرتجع منتجات";
                }
                else if (Convert.ToDouble(e.Row.Cells[1].Text) == 0 && e.Row.Cells[2].Text.Contains("باضافة"))
                {
                    e.Row.BackColor = System.Drawing.Color.SeaGreen;
                    e.Row.ForeColor = System.Drawing.Color.White;
                    e.Row.Cells[1].Text = "اضافة منتجات";
                }
                else if (Convert.ToDouble(e.Row.Cells[1].Text) < 0)
                {
                    e.Row.Cells[1].Text = (-Convert.ToDouble(e.Row.Cells[1].Text)) + "مدفوعه من الشركه ثمن مرتجع";
                }
            }
        }
    }
}