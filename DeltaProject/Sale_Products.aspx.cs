using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;

namespace DeltaProject
{
    public partial class Sale_Products : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            BindProductsGrid();
            PanelInitailResult.Visible = true;
        }

        private void BindProductsGrid()
        {
            var P_name = TextBoxSearch.Text;
            GridViewProducts.Columns[1].ItemStyle.CssClass = "NoDispaly";
            GridViewProducts.Columns[1].HeaderStyle.CssClass = "NoDispaly";
            GridViewProducts.Columns[2].ItemStyle.CssClass = "NoDispaly";
            GridViewProducts.Columns[2].HeaderStyle.CssClass = "NoDispaly";
            GridViewProducts.Columns[3].ItemStyle.CssClass = "NoDispaly";
            GridViewProducts.Columns[3].HeaderStyle.CssClass = "NoDispaly";
            GridViewProducts.DataSource = Product.GetProducts(P_name);
            GridViewProducts.DataBind();
        }

        protected void Btnadd_Click(object sender, EventArgs e)
        {
            int row_index = ((GridViewRow)((Button)sender).NamingContainer).RowIndex;
            string price = (((TextBox)GridViewProducts.Rows[row_index].FindControl("txtPrice")).Text);
            string amount = ((TextBox)GridViewProducts.Rows[row_index].FindControl("txtAmount")).Text;
            if (string.IsNullOrEmpty(price) || string.IsNullOrEmpty(amount))
            {
                PanelFinish.Visible = true;
                lblFinishMsg.Text = "لا يمكن اضافة منتج بدون السعر او الكميه !";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                BtnFinish.Enabled = false;
            }
            else
            {
                BtnFinish.Enabled = true;
                Product product = new Product();
                product.P_name = GridViewProducts.Rows[row_index].Cells[0].Text;
                product.Purchase_Price = Convert.ToDouble(GridViewProducts.Rows[row_index].Cells[6].Text);
                if (Custmer.SelectedIndex == 0) // special
                {
                    product.Specified_Price = Convert.ToDouble(GridViewProducts.Rows[row_index].Cells[4].Text);
                }
                else
                {
                    product.Specified_Price = Convert.ToDouble(GridViewProducts.Rows[row_index].Cells[5].Text);
                }
                if (ViewState["ProductsList"] != null && ((List<Product>)ViewState["ProductsList"]).Contains(product))
                {
                    lblFinishMsg.Text = "! هذا المنتج مسجل فى القائمة";
                    lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    if (ViewState["ProductsList"] == null)
                    {
                        List<Product> Products = new List<Product>();
                        Products.Add(product);
                        ViewState["ProductsList"] = Products;
                    }
                    else
                    {
                        ((List<Product>)ViewState["ProductsList"]).Add(product);
                    }
                    product.Regulare_Price = Convert.ToDouble(price);
                    product.Amount = Convert.ToDecimal(amount);
                    PanelFinish.Visible = true;
                    lblFinishMsg.Text = "تم اضافة - " + product.P_name + " - الى القائمة";
                    lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                }
            }
        }
        protected void Custmer_SelectedIndexChanged(object sender, EventArgs e)
        {
            PanelCustomerType.Visible = false;
            PanelSearch.Visible = true;
            if (Custmer.SelectedIndex == 0)
            {
                GridViewProducts.Columns[5].ItemStyle.CssClass = "NoDispaly";
                GridViewProducts.Columns[5].HeaderStyle.CssClass = "NoDispaly";
            }
            else
            {
                GridViewProducts.Columns[4].ItemStyle.CssClass = "NoDispaly";
                GridViewProducts.Columns[4].HeaderStyle.CssClass = "NoDispaly";
            }
        }
        protected void BtnFinish_Click(object sender, EventArgs e)
        {
            PanelSearch.Visible = false;
            PanelProductList.Visible = true;
            BindList();
        }
        private void BindList()
        {
            GridViewProductsList.DataSource = (List<Product>)ViewState["ProductsList"];
            GridViewProductsList.DataBind();
        }
        double cost = 0;
        protected void GridViewProductsList_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if ((Label)e.Row.FindControl("lblAmount") != null)
            {
                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    e.Row.Cells[1].Text += e.Row.Cells[2].Text != "Not found" && e.Row.Cells[4].Text == "Not found" ? "- " + e.Row.Cells[2].Text +
                                " - " + e.Row.Cells[3].Text + " بوصه" : "";
                    e.Row.Cells[1].Text += e.Row.Cells[4].Text != "Not found" ? "- " + e.Row.Cells[2].Text +
                        " - " + e.Row.Cells[3].Text + " بوصه" + " طراز " + e.Row.Cells[4].Text : "";
                    double amount = Convert.ToDouble(((Label)e.Row.FindControl("lblAmount")).Text);
                    double price = Convert.ToDouble(((Label)e.Row.FindControl("lblPrice")).Text);
                    cost += price * amount;
                    lblTotalCost.Text = cost.ToString();
                }
            }
        }
        protected void GridViewProductsList_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Edit_Row")
            {
                int row_index = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer).RowIndex;
                GridViewProductsList.EditIndex = row_index;
                BindList();
            }
            else if (e.CommandName == "Delete_Row")
            {
                int row_index = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer).RowIndex;
                string P_name = GridViewProductsList.Rows[row_index].Cells[1].Text;
                if (P_name.Contains('-'))
                {
                    P_name = P_name.Substring(0, P_name.IndexOf('-'));
                }
                string mark = GridViewProductsList.Rows[row_index].Cells[2].Text;
                double inch = Convert.ToDouble(GridViewProductsList.Rows[row_index].Cells[3].Text);
                string style = GridViewProductsList.Rows[row_index].Cells[4].Text;
                double purchase_price = Convert.ToDouble(GridViewProductsList.Rows[row_index].Cells[5].Text);
                int index = ((List<Product>)ViewState["ProductsList"]).FindIndex(product => product.P_name == P_name && product.Mark == mark && product.Style == style && product.Purchase_Price == purchase_price);
                ((List<Product>)ViewState["ProductsList"]).RemoveAt(index);
                BindList();
            }
            else if (e.CommandName == "Confirm_Update")
            {
                int row_index = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer).RowIndex;
                string P_name = GridViewProductsList.Rows[row_index].Cells[1].Text;
                if (P_name.Contains('-'))
                {
                    P_name = P_name.Substring(0, P_name.IndexOf('-'));
                }
                string mark = GridViewProductsList.Rows[row_index].Cells[2].Text;
                double inch = Convert.ToDouble(GridViewProductsList.Rows[row_index].Cells[3].Text);
                string style = GridViewProductsList.Rows[row_index].Cells[4].Text;
                double purchase_price = Convert.ToDouble(GridViewProductsList.Rows[row_index].Cells[5].Text);
                int index = ((List<Product>)ViewState["ProductsList"]).FindIndex(product => product.P_name == P_name && product.Mark == mark && product.Style == style && product.Purchase_Price == purchase_price);
                ((List<Product>)ViewState["ProductsList"])[index].Amount = Convert.ToDecimal(((TextBox)GridViewProductsList.Rows[row_index].FindControl("txtAmount")).Text);
                ((List<Product>)ViewState["ProductsList"])[index].Regulare_Price = Convert.ToDouble(((TextBox)GridViewProductsList.Rows[row_index].FindControl("txtPrice")).Text);
                GridViewProductsList.EditIndex = -1;
                BindList();
            }
            else if (e.CommandName == "Cancel_Update")
            {
                GridViewProductsList.EditIndex = -1;
                BindList();
            }
        }
        protected void BtnConfirm_Click(object sender, EventArgs e)
        {
            lblConfirmMsg.Text = "";
            bool allExists = true;
            foreach (Product p in (List<Product>)ViewState["ProductsList"])
            {
                int Current;
                if (!p.Check_amounts(out Current)) // amount not enough for the order
                {
                    lblConfirmMsg.Text += "الكميه الموجوده من " + p.P_name + " = " + Current + "<br />";
                    allExists = false;
                }
            }
            if (allExists)
            {
                PanelProductList.Visible = false;
                PanelClientInfo.Visible = true;
            }
        }
        protected void BtnBill_Click(object sender, EventArgs e)
        {
            Bill bill = new Bill();
            bill.Discount = txtDiscount.Text == "" ? 0 : Convert.ToDouble(txtDiscount.Text);
            bill.Bill_Date = new DateTime(Convert.ToInt32(txtYear.Text), Convert.ToInt32(txtMonth.Text), Convert.ToInt32(txtDay.Text), DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);
            bill.AdditionalCost = txtAdditionalCost.Text == "" ? 0 : Convert.ToDouble(txtAdditionalCost.Text);
            bill.AdditionalCostNotes = txtAdditionalcostNotes.Text;
            Client client = new Client();
            client.C_name = txtClient_Name.Text;
            client.Address = txtAddress.Text;

            long Bill_ID = bill.Generate_Bill(client, Convert.ToDouble(lblTotalCost.Text) + bill.AdditionalCost, Convert.ToDouble(txtPaid_Amount.Text), TxtDesc.Text);
            Bill_Content content = new Bill_Content();
            string m = "";
            bool AllDone = true;
            foreach (Product p in (List<Product>)ViewState["ProductsList"])
            {
                if (!content.Add_Bill_Contents(out m, Bill_ID, p))
                {
                    Response.Write("<script>alert('" + m + "')</script>");
                    AllDone = false;
                    break;
                }
            }
            if (AllDone)
            {
                lblBillDate.Text = bill.Bill_Date.ToShortDateString();
                lblBill_ID.Text = Bill_ID.ToString();
                lblClientName.Text = txtClient_Name.Text;
                lblAddress.Text = txtAddress.Text;
                lblBillCost.Text = lblTotalCost.Text;
                lblPaid_Value.Text = txtPaid_Amount.Text;
                if (!string.IsNullOrEmpty(txtDiscount.Text))
                {
                    lblDiscountValue.Text = txtDiscount.Text;
                }
                else
                {
                    lblDiscount.Visible = false;
                    lblDiscountValue.Visible = false;
                }
                if (txtAdditionalCost.Text == "")
                {
                    lblAddtionalCost.Visible = false;
                    lblAdditionalCostValue.Visible = false;
                    lblAdditionalcostNotes.Visible = false;
                }
                else
                {
                    lblAdditionalCostValue.Text = txtAdditionalCost.Text;
                    lblAdditionalcostNotes.Text = txtAdditionalcostNotes.Text;
                }
                lblRest.Text = ((Convert.ToDouble(lblBillCost.Text) + bill.AdditionalCost) - Convert.ToDouble(lblDiscountValue.Text) - Convert.ToDouble(lblPaid_Value.Text)).ToString();
                PanelClientInfo.Visible = false;
                PanelBill.Visible = true;
                GridViewBillList.DataSource = (List<Product>)ViewState["ProductsList"];
                GridViewBillList.DataBind();
            }
        }

        double TotalCost = 0;
        protected void GridViewBillList_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Cells[0].Text += e.Row.Cells[1].Text != "Not found" && e.Row.Cells[3].Text == "Not found" ? "- " + e.Row.Cells[1].Text +
                                    " - " + e.Row.Cells[2].Text + " بوصه" : "";
                e.Row.Cells[0].Text += e.Row.Cells[3].Text != "Not found" ? "- " + e.Row.Cells[1].Text +
                    " - " + e.Row.Cells[2].Text + " بوصه" + " طراز " + e.Row.Cells[3].Text : "";
                double cost = Convert.ToDouble(e.Row.Cells[4].Text) * Convert.ToDouble(e.Row.Cells[5].Text);
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
                GridViewBillList.DataSource = (List<Product>)ViewState["ProductsList"];
                GridViewBillList.DataBind();
            }
        }
    }
}