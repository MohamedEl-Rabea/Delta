using Business_Logic;
using DeltaProject.Business_Logic;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class SaleProducts : Page
    {
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
            PanelInitailResult.Visible = false;
            GridViewProducts.Visible = true;
            PanelAddFreeItem.Visible = false;
            lblFinishMsg.Text = "";
            if (RadioButtonListCategories.SelectedValue == "Products")
            {
                txtProductName.Enabled = true;
                txtProductName.Visible = true;
                ImageButtonSearch.Enabled = true;
            }
            else
            {
                txtProductName.Visible = true;
                txtProductName.Enabled = false;
                ImageButtonSearch.Enabled = false;
                PanelInitailResult.Visible = true;
                GridViewProducts.Visible = false;
                PanelAddFreeItem.Visible = true;
            }
        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            BindProductsGrid();
            PanelInitailResult.Visible = true;
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            int rowIndex = ((GridViewRow)((Button)sender).NamingContainer).RowIndex;
            string price = (((TextBox)GridViewProducts.Rows[rowIndex].FindControl("txtPrice")).Text);
            string quantity = ((TextBox)GridViewProducts.Rows[rowIndex].FindControl("txtAmount")).Text;
            string discount = ((TextBox)GridViewProducts.Rows[rowIndex].FindControl("txtDiscount")).Text;

            btnFinish.Enabled = true;
            BillItem item = new BillItem
            {
                ProductId = Convert.ToInt32(GridViewProducts.Rows[rowIndex].Cells[0].Text),
                Name = GridViewProducts.Rows[rowIndex].Cells[1].Text,
                PurchasePrice = Convert.ToDecimal(GridViewProducts.Rows[rowIndex].Cells[2].Text),
                SellPrice = Convert.ToDecimal(GridViewProducts.Rows[rowIndex].Cells[3].Text),
                Quantity = Convert.ToDecimal(GridViewProducts.Rows[rowIndex].Cells[4].Text),
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
                item.SpecifiedPrice = Convert.ToDecimal(price);
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
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
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

                PanelFinish.Visible = true;
                lblFinishMsg.Text = "تم اضافة - " + item.Name + " - الى القائمة";
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
            }
        }

        protected void btnFinish_Click(object sender, EventArgs e)
        {
            PanelSearch.Visible = false;
            PanelProductList.Visible = true;
            BindList();
        }

        protected void GridViewItemsList_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && GridViewItemsList.EditIndex == e.Row.RowIndex)
            {
                var label = (Label)e.Row.FindControl("lblEditDiscount");
                var text = (TextBox)e.Row.FindControl("txtDiscount");
                bool isService = Convert.ToBoolean(((Label)e.Row.FindControl("lblIsService")).Text);
                label.Visible = isService;
                text.Visible = !isService;
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
            BillItems[rowIndex].SpecifiedPrice = Convert.ToDecimal(((TextBox)GridViewItemsList.Rows[rowIndex].FindControl("txtPrice")).Text);
            var discount = ((TextBox)GridViewItemsList.Rows[rowIndex].FindControl("txtDiscount")).Text;
            BillItems[rowIndex].Discount = !string.IsNullOrEmpty(discount) ? Convert.ToDecimal(discount) : 0;
            GridViewItemsList.EditIndex = -1;
            BindList();
        }

        protected void btnConfirm_Click(object sender, EventArgs e)
        {
            lblConfirmMsg.Text = "";

            if (!BillItems.Any())
            {
                lblConfirmMsg.Text = "يجب اضافه منتج او خدمه واحده على الاقل";
            }
            else
            {
                PanelProductList.Visible = false;
                PanelClientInfo.Visible = true;
            }
        }

        protected void btnBill_Click(object sender, EventArgs e)
        {
            var billDate = new DateTime(Convert.ToInt32(txtYear.Text), Convert.ToInt32(txtMonth.Text),
                Convert.ToInt32(txtDay.Text), DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);

            SaleBill bill = new SaleBill
            {
                UserId = Convert.ToInt32(Session["userId"]),
                ClientName = txtClient_Name.Text,
                Date = billDate,
                AdditionalCost = txtAdditionalCost.Text == "" ? 0 : Convert.ToDecimal(txtAdditionalCost.Text),
                AdditionalCostNotes = txtAdditionalcostNotes.Text,
                Notes = TxtDesc.Text,
                Client = new Client
                {
                    C_name = txtClient_Name.Text,
                    Address = txtAddress.Text
                },
                Items = BillItems,
                PaidAmount = Convert.ToDecimal(txtPaid_Amount.Text)
            };


            if (!BillItems.Any())
            {
                lblFinishMsg.Text = "لا توجد منتجات او خدمات !";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblFinishMsg.Text = "";
                lblFinishMsg.Visible = true;
                if (!bill.AddBill(out var m))
                {
                    lblFinishMsg.Text = m;
                    lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    lblFinishMsg.Text = "تم الحفظ بنجاح";
                    lblFinishMsg.ForeColor = System.Drawing.Color.Green;

                    lblBillDate.Text = bill.Date.ToString("dd/MM/yyyy");
                    lblBill_ID.Text = bill.Id.ToString();
                    lblClientName.Text = txtClient_Name.Text;
                    lblAddress.Text = string.IsNullOrEmpty(txtAddress.Text) ? "---" : txtAddress.Text;
                    lblBillCost.Text = lblTotalCost.Text;
                    lblPaid_Value.Text = txtPaid_Amount.Text;
                    lblAdditionalCostValue.Text = string.IsNullOrEmpty(txtAdditionalCost.Text) ? "0" : txtAdditionalCost.Text;
                    lblAdditionalcostNotes.Text = txtAdditionalcostNotes.Text;
                    lblPreAdditionalcostNotes.Visible = !string.IsNullOrEmpty(lblAdditionalcostNotes.Text);
                    lblRest.Text = (Convert.ToDecimal(lblBillCost.Text) +
                                    (bill.AdditionalCost ?? 0) -
                                    Convert.ToDecimal(lblPaid_Value.Text))
                    .ToString("0.##");

                    PanelClientInfo.Visible = false;
                    PanelBill.Visible = true;
                    BindBillGridView();
                }
            }
        }

        double _totalCost = 0;
        protected void GridViewBillList_RowDataBound(object sender, GridViewRowEventArgs e)
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

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (GridViewBillList.Rows.Count > 0)
            {
                _totalCost = 0;
                BindBillGridView();
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
        }

        private void BindBillGridView()
        {
            GridViewBillList.DataSource = BillItems;
            GridViewBillList.DataBind();
        }

    }
}