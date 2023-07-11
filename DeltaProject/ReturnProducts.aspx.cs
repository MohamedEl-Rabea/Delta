using DeltaProject.Business_Logic;
using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class ReturnProducts : System.Web.UI.Page
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
            PanelRest.Visible = false;
            lblFinishMsg.Text = "";
            txtYear.Text = "";
            txtMonth.Text = "";
            txtDay.Text = "";
            if (txtClientName.Visible)
            {
                if (string.IsNullOrEmpty(txtClientName.Text))
                {
                    PanelErrorMessage.Visible = true;
                }
            }
            else if (txtPhoneNumber.Visible)
            {
                if (string.IsNullOrEmpty(txtPhoneNumber.Text))
                {
                    PanelErrorMessage.Visible = true;
                }
            }
            else // search with Bill ID
            {
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
                lblBillDate.Text = bill.Date.ToShortDateString();
                lblClientName.Text = bill.ClientName;
                var totalCost = bill.Items.Sum(i => i.TotalCost);
                lblBillCost.Text = totalCost.ToString("0.##");
                lblPaidValue.Text = bill.PaidAmount?.ToString("0.##");
                lblAddtionalCostValue.Text = bill.AdditionalCost?.ToString("0.##");
                lblAdditionalcostNotes.Text = bill.AdditionalCostNotes;
                lblBillCost.Text = totalCost >= 0
                    ? totalCost.ToString("0.##")
                    : (-totalCost).ToString("0.##") + " " + "فرق تكلفه للعميل";
                lblRest.Text = Convert.ToDecimal(totalCost + bill.AdditionalCost - bill.PaidAmount).ToString("0.##");
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
                var isService = Convert.ToBoolean(e.Row.Cells[7].Text);
                var quantity = Convert.ToDecimal(e.Row.Cells[4].Text);
                var label = (Label)e.Row.FindControl("lblReturnedQuantity");
                var text = (TextBox)e.Row.FindControl("txtReturnedQuantity");
                label.Visible = isService || quantity <= 0;
                text.Visible = !isService && quantity > 0;
            }
        }

        protected void btnFinish_Click(object sender, EventArgs e)
        {
            DateTime returnDate = new DateTime(Convert.ToInt32(txtYear.Text), Convert.ToInt32(txtMonth.Text), Convert.ToInt32(txtDay.Text),
                 DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);

            SaleBill bill = new SaleBill { Id = Convert.ToInt32(lblBillId.Text) };
            btnFinish.Enabled = false;
            btnFinish.BackColor = System.Drawing.Color.FromName("#aaa");

            foreach (GridViewRow row in GridViewBillItems.Rows)
            {
                var returnedQuantity = ((TextBox)row.FindControl("txtReturnedQuantity")).Text;
                if (!string.IsNullOrEmpty(returnedQuantity))
                {
                    BillItem item = new BillItem
                    {
                        Id = Convert.ToInt32(row.Cells[0].Text),
                        Date = returnDate,
                        ProductId = Convert.ToInt32(row.Cells[1].Text),
                        SpecifiedPrice = Convert.ToDecimal(row.Cells[5].Text),
                        ReturnedQuantity = Convert.ToDecimal(returnedQuantity)
                    };
                    bill.Items.Add(item);
                }
            }

            if (bill.Items.Any())
            {
                if (!bill.ReturnItems(out string m))
                {
                    lblFinishMsg.Text = m;
                    lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                    btnFinish.Enabled = true;
                    btnFinish.BackColor = System.Drawing.Color.FromName("#1abc9c");
                }
                else
                {
                    var restOfMoney = Convert.ToDecimal(lblRest.Text) -
                                      bill.Items.Sum(p => p.ReturnedQuantity * p.SpecifiedPrice);

                    if (restOfMoney < 0) // RestOfMoney greater than bill cost
                    {
                        ViewState["RestOfMoney"] = restOfMoney;
                        PanelRest.Visible = true;
                        btnFinish.Enabled = true;
                        btnFinish.BackColor = System.Drawing.Color.FromName("#1abc9c");
                        lblRestOfMoney.Text = (-restOfMoney).ToString("0.##") + " جنيها";
                    }
                    else
                    {
                        lblFinishMsg.Text = "تم بنجاح";
                        lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                    }
                }
            }
            else
            {
                lblFinishMsg.Text = "يجب اضافه مرتجع على الاقل";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                btnFinish.Enabled = true;
                btnFinish.BackColor = System.Drawing.Color.FromName("#1abc9c");
            }
        }

        protected void btnPay_Click(object sender, EventArgs e)
        {
            Response.Redirect($"~/PaySaleBill.aspx?billId={lblBillId.Text}");
        }

        protected void lnkAddItems_Click(object sender, EventArgs e)
        {
            Response.Redirect($"~/AddBillItems.aspx?billId={lblBillId.Text}");
        }
    }
}
