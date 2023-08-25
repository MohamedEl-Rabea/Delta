using DeltaProject.Business_Logic;
using System;
using System.Drawing;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class EditSaleBill : Page
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
            lblMsg.Text = "";
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
            GridViewBills.DataBind();
        }

        protected void GridViewBills_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int billId;
            if (e.CommandName == "SelectBill")
            {
                billId = Convert.ToInt32(((LinkButton)e.CommandSource).Text);
                SelectBill(billId);
            }
            else if (e.CommandName == "DeleteBill")
            {
                billId = Convert.ToInt32(((ImageButton)e.CommandSource).AlternateText);
                SaleBill bill = new SaleBill { Id = billId };
                if (!bill.DeleteBill(out string m))
                {
                    lblMsg.Text = m;
                    lblMsg.ForeColor = Color.Red;
                }
                else
                {
                    lblMsg.Text = "تم بنجاح";
                    lblMsg.ForeColor = Color.Green;
                    GridViewBills.DataBind();
                }
            }
        }

        protected void GridViewBillItems_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteItem")
            {
                int rowIndex = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer).RowIndex;
                int id = Convert.ToInt32(((ImageButton)e.CommandSource).AlternateText);
                bool isService = Convert.ToBoolean(GridViewBillItems.Rows[rowIndex].Cells[7].Text);
                decimal quantity = Convert.ToDecimal(((TextBox)GridViewBillItems.Rows[rowIndex].FindControl("txtQuantity")).Text);
                SaleBill bill = new SaleBill { UserId = Convert.ToInt32(Session["userId"]), Date = DateTime.Now };
                if (!bill.DeleteBillItem(out string m, id, Convert.ToInt32(Session["userId"]), isService, quantity))
                {
                    lblFinishMsg.Text = m;
                    lblMsg.ForeColor = Color.Red;
                }
                else
                {
                    lblFinishMsg.Text = "تم بنجاح";
                    lblFinishMsg.ForeColor = Color.Green;
                    SelectBill(Convert.ToInt32(lblBillId.Text));
                }
            }
        }

        protected void btnFinish_Click(object sender, EventArgs e)
        {
            DateTime editDate = new DateTime(Convert.ToInt32(txtYear.Text), Convert.ToInt32(txtMonth.Text), Convert.ToInt32(txtDay.Text),
                 DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);

            SaleBill bill = new SaleBill
            {
                Id = Convert.ToInt32(lblBillId.Text),
                UserId = Convert.ToInt32(Session["userId"]),
                Date = editDate
            };
            btnFinish.Enabled = false;
            btnFinish.BackColor = Color.FromName("#aaa");

            foreach (GridViewRow row in GridViewBillItems.Rows)
            {
                var name = row.Cells[2].Text;
                var isService = Convert.ToBoolean(row.Cells[7].Text);
                var quantity = Convert.ToDecimal(((TextBox)row.FindControl("txtQuantity")).Text);
                var newQuantity = Convert.ToDecimal(((TextBox)row.FindControl("txtNewQuantity")).Text);
                var price = Convert.ToDecimal(((TextBox)row.FindControl("txtPrice")).Text);
                var newPrice = Convert.ToDecimal(((TextBox)row.FindControl("txtNewPrice")).Text);
                string notes = string.IsNullOrEmpty(txtNotes.Text) ? "" : txtNotes.Text + " - ";
                if (quantity != newQuantity)
                    notes += $" تم تعديل كمية العنصر '{name}' من {quantity:0.##} الى {newQuantity:0.##} ، ";

                if (price != newPrice)
                    notes += $" تم تعديل سعر العنصر '{name}' من {price:0.##} الى {newPrice:0.##}";

                if (price != newPrice || quantity != newQuantity)
                {
                    BillItem item = new BillItem
                    {
                        Id = Convert.ToInt32(row.Cells[0].Text),
                        ProductId = Convert.ToInt32(row.Cells[1].Text),
                        Name = name,
                        SpecifiedPrice = newPrice,
                        SoldQuantity = Convert.ToDecimal(row.Cells[8].Text) - quantity + newQuantity,
                        Quantity = newQuantity,
                        ReturnedQuantity = quantity - newQuantity,
                        IsService = isService,
                        Notes = notes
                    };
                    bill.Items.Add(item);
                }
            }

            if (bill.Items.Any())
            {
                if (!bill.EditItems(out string m))
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
            else
            {
                lblFinishMsg.Text = "يجب اضافه مرتجع على الاقل";
                lblFinishMsg.ForeColor = Color.Red;
                btnFinish.Enabled = true;
                btnFinish.BackColor = Color.FromName("#1abc9c");
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
            var totalCost = bill.Items.Sum(i => i.TotalCost);
            lblBillCost.Text = totalCost.ToString("0.##");
            lblPaidValue.Text = bill.PaidAmount?.ToString("0.##");
            lblAddtionalCostValue.Text = bill.AdditionalCost?.ToString("0.##");
            lblAdditionalcostNotes.Text = bill.AdditionalCostNotes;
            var rest = Convert.ToDecimal(totalCost + bill.AdditionalCost - bill.PaidAmount);
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
}