using DeltaProject.Business_Logic;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class AddBillItems : Page
    {
        private SaleBill Bill
        {
            get => ViewState["Bill"] == null
                ? new SaleBill() : (SaleBill)ViewState["Bill"];
            set => ViewState["Bill"] = value;
        }

        private List<BillItem> BillItems
        {
            get => ViewState["ItemsList"] == null
                ? new List<BillItem>()
                : (List<BillItem>)ViewState["ItemsList"];
            set => ViewState["ItemsList"] = value;
        }

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
            PanelAddItems.Visible = false;
            lblFinishMsg.Text = "";
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
                SaleBill bill = new SaleBill { Id = Convert.ToInt32(((LinkButton)e.CommandSource).Text) };
                bill.GetBillData();
                ViewState["Bill"] = bill;
                PanelSearchClient.Visible = false;
                PanelErrorMessage.Visible = false;
                PanelBills.Visible = false;
                PanelAddItems.Visible = true;
            }
        }

        protected void RadioButtonListItems_SelectedIndexChanged(object sender, EventArgs e)
        {
            PanelInitailResult.Visible = true;
            lblFinishMsg.Text = "";
            if (RadioButtonListItems.SelectedValue == "Products")
            {
                txtProductName.Visible = true;
                txtProductName.Enabled = true;
                ImageButtonSearch.Enabled = true;
                GridViewProducts.Visible = true;
                PanelAddFreeItem.Visible = false;
            }
            else
            {
                txtProductName.Visible = true;
                txtProductName.Enabled = false;
                ImageButtonSearch.Enabled = false;
                GridViewProducts.Visible = false;
                PanelAddFreeItem.Visible = true;
            }
        }

        protected void ImageButtonSearchItems_Click(object sender, ImageClickEventArgs e)
        {
            BindProductsGrid();
            PanelInitailResult.Visible = true;
        }

        protected void GridViewProducts_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                var label = (Label)e.Row.FindControl("lblPrice");
                var text = (TextBox)e.Row.FindControl("txtPrice");
                var item = Bill.Items.FirstOrDefault(i => i.ProductId == Convert.ToInt32(e.Row.Cells[0].Text));
                label.Text = item != null ? item.SpecifiedPrice.ToString("0.##") : "0";
                text.Text = item?.SpecifiedPrice.ToString("0.##");
                label.Visible = item != null;
                text.Visible = item == null;
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            int rowIndex = ((GridViewRow)((Button)sender).NamingContainer).RowIndex;
            var priceElement = (TextBox)GridViewProducts.Rows[rowIndex].FindControl("txtPrice");
            var quantityElement = (TextBox)GridViewProducts.Rows[rowIndex].FindControl("txtAmount");
            var discountElement = (TextBox)GridViewProducts.Rows[rowIndex].FindControl("txtDiscount");
            string price = priceElement.Text;
            string quantity = quantityElement.Text;
            string discount = discountElement.Text;
            var productId = Convert.ToInt32(GridViewProducts.Rows[rowIndex].Cells[0].Text);
            var existItem = Bill.Items.FirstOrDefault(i => i.ProductId == productId);
            btnFinish.Enabled = true;
            BillItem item = new BillItem
            {
                Id = existItem?.Id ?? default,
                ProductId = productId,
                Name = GridViewProducts.Rows[rowIndex].Cells[1].Text,
                PurchasePrice = Convert.ToDecimal(GridViewProducts.Rows[rowIndex].Cells[2].Text),
                SellPrice = Convert.ToDecimal(GridViewProducts.Rows[rowIndex].Cells[3].Text),
                ProductQuantity = Convert.ToDecimal(GridViewProducts.Rows[rowIndex].Cells[4].Text),
                Quantity = existItem?.Quantity ?? 0,
                UnitName = GridViewProducts.Rows[rowIndex].Cells[5].Text,
                IsService = false
            };


            if (ViewState["ItemsList"] != null && BillItems.Any(p => p.Id == item.ProductId))
            {
                lblFinishMsg.Text = "! هذا المنتج مسجل فى القائمة";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                item.SpecifiedPrice = string.IsNullOrEmpty(price) ? 0 : Convert.ToDecimal(price);
                item.SoldQuantity = Convert.ToDecimal(quantity);
                item.Discount = string.IsNullOrEmpty(discount) ? 0 : Convert.ToDecimal(discount);
                if (ViewState["ItemsList"] == null)
                {
                    List<BillItem> items = new List<BillItem>();
                    items.Add(item);
                    ViewState["ItemsList"] = items;
                }
                else
                {
                    BillItems.Add(item);
                }
                PanelFinish.Visible = true;
                lblFinishMsg.Text = "تم اضافة - " + item.Name + " - الى القائمة";
                lblFinishMsg.ForeColor = Color.Green;
            }
        }

        protected void btnAddFreeItem_Click(object sender, EventArgs e)
        {
            btnFinish.Enabled = true;
            BillItem item = new BillItem { Name = txtFreeItemName.Text, IsService = true };
            if (ViewState["ItemsList"] != null && BillItems.Any(s => s.Name == item.Name && s.IsService))
            {
                PanelFinish.Visible = true;
                lblFinishMsg.Text = "! هذه الخدمه مسجله فى القائمة";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                item.SoldQuantity = Convert.ToDecimal(txtFreeItemAmount.Text);
                item.SpecifiedPrice = Convert.ToDecimal(txtFreeItemPrice.Text);

                if (ViewState["ItemsList"] == null)
                {
                    List<BillItem> items = new List<BillItem>();
                    items.Add(item);
                    ViewState["ItemsList"] = items;
                }
                else
                {
                    BillItems.Add(item);
                }

                txtFreeItemName.Text = "";
                txtFreeItemAmount.Text = "";
                txtFreeItemPrice.Text = "";
                PanelFinish.Visible = true;
                lblFinishMsg.Text = "تم اضافة - " + item.Name + " - الى القائمة";
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
            }
        }

        protected void btnFinish_Click(object sender, EventArgs e)
        {
            PanelAddItems.Visible = false;
            PanelProductList.Visible = true;
            BindList();
        }

        protected void GridViewItemsList_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && GridViewItemsList.EditIndex == e.Row.RowIndex)
            {
                var labelDiscount = (Label)e.Row.FindControl("lblEditDiscount");
                var textDiscount = (TextBox)e.Row.FindControl("txtDiscount");
                bool isService = Convert.ToBoolean(((Label)e.Row.FindControl("lblIsService")).Text);
                labelDiscount.Visible = isService;
                textDiscount.Visible = !isService;

                int productId = Convert.ToInt32(((Label)e.Row.FindControl("lblProductId")).Text);
                var labelPrice = (Label)e.Row.FindControl("lblPrice");
                var textPrice = (TextBox)e.Row.FindControl("txtPrice");
                var item = Bill.Items.FirstOrDefault(i => i.ProductId == productId);
                labelPrice.Visible = item != null;
                textPrice.Visible = item == null;
            }
        }

        protected void GridViewItemsList_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int rowIndex = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer).RowIndex;
            if (e.CommandName == "Edit_Row")
            {
                GridViewItemsList.EditIndex = rowIndex;
                BindList();
            }
            else if (e.CommandName == "Delete_Row")
            {
                BillItems.RemoveAt(rowIndex);
                BindList();
            }
            else if (e.CommandName == "Cancel_Update")
            {
                GridViewItemsList.EditIndex = -1;
                BindList();
            }
        }

        protected void btnConfirmEdit_OnClick(object sender, ImageClickEventArgs e)
        {
            int rowIndex = ((GridViewRow)((ImageButton)sender).NamingContainer).RowIndex;
            BillItems[rowIndex].SoldQuantity = Convert.ToDecimal(((TextBox)GridViewItemsList.Rows[rowIndex].FindControl("txtQuantity")).Text);
            var price = ((TextBox)GridViewItemsList.Rows[rowIndex].FindControl("txtPrice")).Text;
            BillItems[rowIndex].SpecifiedPrice = !string.IsNullOrEmpty(price) ? Convert.ToDecimal(price) : 0;
            var discount = ((TextBox)GridViewItemsList.Rows[rowIndex].FindControl("txtDiscount")).Text;
            BillItems[rowIndex].Discount = !string.IsNullOrEmpty(discount) ? Convert.ToDecimal(discount) : 0;
            GridViewItemsList.EditIndex = -1;
            BindList();
        }

        protected void btnConfirm_Click(object sender, EventArgs e)
        {
            btnConfirm.Enabled = false;
            btnConfirm.BackColor = Color.FromName("#aaa");

            SaleBill bill = new SaleBill
            {
                Id = Bill.Id,
                UserId = Convert.ToInt32(Session["userId"]),
                Date = DateTime.Now,
                Items = BillItems
            };


            if (!BillItems.Any())
            {
                lblConfirmMsg.Text = "لا توجد منتجات او خدمات !";
                lblConfirmMsg.ForeColor = Color.Red;
            }
            else
            {
                lblConfirmMsg.Text = "";
                lblConfirmMsg.Visible = true;
                if (!bill.AddBillItems(out var m))
                {
                    btnConfirm.Enabled = false;
                    btnConfirm.BackColor = Color.FromName("#1abc9c");
                    lblConfirmMsg.Text = m;
                    lblConfirmMsg.ForeColor = Color.Red;
                }
                else
                {
                    lblConfirmMsg.Text = "تم الحفظ بنجاح";
                    lblConfirmMsg.ForeColor = Color.Green;
                }
            }
        }



        private void BindProductsGrid()
        {
            int? productId = string.IsNullOrEmpty(txtProductId.Text) ? (int?)null : Convert.ToInt32(txtProductId.Text);
            GridViewProducts.DataSource = NewProduct.GetProducts(productId);
            GridViewProducts.DataBind();
        }

        private void BindList()
        {
            GridViewItemsList.DataSource = BillItems;
            GridViewItemsList.DataBind();

            lblTotalCost.Text =
                BillItems.Sum(p => p.SoldQuantity * p.SpecifiedPrice - p.Discount)
                    .ToString("0.##");

            lblBillDate.Text = Bill.Date.ToString("dd/MM/yyy");
            lblBillId.Text = Bill.Id.ToString();
            lblClientName.Text = Bill.ClientName;
            lblAddress.Text = Bill.Address;
        }
    }
}