using Business_Logic;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class Add_Items_To_Invoice : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void RadioButtonListCategories_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (RadioButtonListCategories.SelectedIndex == 0)
            {
                txtClient.Visible = true;
                txtBill_ID.Visible = false;
            }
            else
            {
                txtClient.Visible = false;
                txtBill_ID.Visible = true;
            }
        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            PanelBills.Visible = false;
            PanelSale.Visible = false;
            if (txtClient.Visible)
            {
                Bill bill = new Bill();
                bill.Client_Name = txtClient.Text;
                if (string.IsNullOrEmpty(txtClient.Text) || !bill.IsExistsBill())
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
            else // search with Bill ID
            {
                PanelSearchClient.Visible = false;
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
                    PanelBills.Visible = false;
                    PanelSale.Visible = true;
                    Session["Bill_ID"] = txtBill_ID.Text;
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
                Session["Bill_ID"] = Bill_ID;
                PanelSale.Visible = true;
                PanelBills.Visible = false;
                PanelSearchClient.Visible = false;
            }
        }

        protected void ImageButtonSearchProducts_Click(object sender, ImageClickEventArgs e)
        {
            BindProductsGrid();
            PanelInitailResult.Visible = true;
        }

        private void BindProductsGrid()
        {
            string P_name = string.Empty;
            if (TextBoxSearch.Visible)
            {
                P_name = TextBoxSearch.Text;
                GridViewProducts.Columns[1].ItemStyle.CssClass = "NoDispaly";
                GridViewProducts.Columns[1].HeaderStyle.CssClass = "NoDispaly";
                GridViewProducts.Columns[2].ItemStyle.CssClass = "NoDispaly";
                GridViewProducts.Columns[2].HeaderStyle.CssClass = "NoDispaly";
                GridViewProducts.Columns[3].ItemStyle.CssClass = "NoDispaly";
                GridViewProducts.Columns[3].HeaderStyle.CssClass = "NoDispaly";

            }
            else if (TextBoxTol.Visible)
            {
                P_name = TextBoxTol.Text;
                GridViewProducts.Columns[1].ItemStyle.CssClass = "";
                GridViewProducts.Columns[1].HeaderStyle.CssClass = "";
                GridViewProducts.Columns[2].ItemStyle.CssClass = "";
                GridViewProducts.Columns[2].HeaderStyle.CssClass = "";
                GridViewProducts.Columns[3].ItemStyle.CssClass = "";
                GridViewProducts.Columns[3].HeaderStyle.CssClass = "";
            }
            else if (TextBoxMotors.Visible)
            {
                P_name = TextBoxMotors.Text;
                GridViewProducts.Columns[1].ItemStyle.CssClass = "";
                GridViewProducts.Columns[1].HeaderStyle.CssClass = "";
                GridViewProducts.Columns[2].ItemStyle.CssClass = "";
                GridViewProducts.Columns[2].HeaderStyle.CssClass = "";
                GridViewProducts.Columns[3].HeaderStyle.CssClass = "NoDispaly";
                GridViewProducts.Columns[3].ItemStyle.CssClass = "NoDispaly";
            }
            GridViewProducts.DataSource = Product.GetProducts(P_name);
            GridViewProducts.DataBind();
        }


        private void GetName(string full_name, out string name, out string mark, out string inch, out string style)
        {
            name = "";
            mark = style = "Not found";
            inch = "0.00";
            if (full_name.Contains('-'))
            {
                int startindex = full_name.IndexOf('-');
                name = full_name.Substring(0, startindex);
                startindex = full_name.IndexOf("- ماركة ") + 8;
                int endindex = full_name.IndexOf('-', startindex);
                mark = full_name.Substring(startindex, endindex - startindex);
                startindex = full_name.IndexOf("- بوصه ") + 7;
                if ((full_name.Substring(startindex, full_name.Length - (startindex + 1)).Contains('-'))) // Tol
                {
                    endindex = full_name.IndexOf('-', startindex);
                    inch = full_name.Substring(startindex, endindex - startindex);
                    startindex = full_name.IndexOf("- طراز ") + 7;
                    style = full_name.Substring(startindex, full_name.Length - startindex);
                }
                else
                {
                    inch = full_name.Substring(startindex, full_name.Length - (startindex + 1));
                }
            }
            else
            {
                name = full_name;
            }
        }

        protected void RBLProductType_SelectedIndexChanged(object sender, EventArgs e)
        {
            PanelInitailResult.Visible = false;
            GridViewProducts.Visible = true;
            PanelAddFreeItem.Visible = false;
            if (RBLProductType.SelectedValue == "Normal")
            {
                TextBoxSearch.Visible = true;
                TextBoxMotors.Visible = false;
                TextBoxTol.Visible = false;
            }
            else if (RBLProductType.SelectedValue == "Tol")
            {
                TextBoxTol.Visible = true;
                TextBoxSearch.Visible = false;
                TextBoxMotors.Visible = false;
            }
            else if (RBLProductType.SelectedValue == "Motors")
            {
                TextBoxMotors.Visible = true;
                TextBoxSearch.Visible = false;
                TextBoxTol.Visible = false;
            }
            else
            {
                TextBoxSearch.Visible = true;
                TextBoxSearch.Enabled = false;
                TextBoxMotors.Visible = false;
                TextBoxTol.Visible = false;
                PanelInitailResult.Visible = true;
                GridViewProducts.Visible = false;
                PanelAddFreeItem.Visible = true;
            }
        }

        protected void BtnaddFreeItem_Click(object sender, EventArgs e)
        {
            AddFreeItemToList();
        }

        protected void BtnDoneAdding_Click(object sender, EventArgs e)
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

        protected void BtnAddToBill_Click(object sender, EventArgs e)
        {
            bool allExists = true;
            foreach (Product p in (List<Product>)ViewState["ProductsList"])
            {
                int Current;
                if (!p.Check_amounts(out Current)) // amount not enough for the order
                {
                    lblConfirmMsg.Text += " لا توجد كل الكميه المطلوبه من المنتج" + " ( " + p.P_name + " ) " + " الكميه الموجوده = " + Current + "<br />";
                    allExists = false;
                }
            }
            if (allExists)//add ps to bill list
            {
                Bill_Content content = new Bill_Content();
                bool AllDone = true;
                string m;
                System.Text.StringBuilder ConcatenatedNotes = new System.Text.StringBuilder("قام العميل باضافة منتجات / خدمات جديدة للفاتورة : ");
                foreach (Product p in (List<Product>)ViewState["ProductsList"])
                {
                    if (!content.Add_Bill_Contents(out m, Convert.ToInt64(Session["Bill_ID"]), true, p))
                    {
                        Response.Write("<script>alert('" + m + "')</script>");
                        AllDone = false;
                        break;
                    }
                    else
                    {
                        ConcatenatedNotes.AppendLine();
                        ConcatenatedNotes.Append(p.Amount.ToString() + " " + p.P_name + " " + (p.Mark != "Not found" ? ("ماركة  " + p.Mark + " " +
                            p.Inch.ToString() + " بوصه " + (p.Style != "Not found" ? "طراز " + p.Style + " " : "")) : "")
                            + " سعر الواحده يساوى" + p.Regulare_Price.ToString());
                    }
                }
                if (AllDone)
                {
                    lblConfirmMsg.ForeColor = System.Drawing.Color.Green;
                    Bill_Payments payment = new Bill_Payments();
                    payment.Pay_Date = DateTime.Now;
                    payment.Paid_amount = 0;
                    payment.Notes = ConcatenatedNotes.ToString();
                    payment.Add_Bill_Payment(Convert.ToInt64(Session["Bill_ID"]));
                    lblConfirmMsg.Text = "تم بنجاح";
                }
            }
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
                    int amount = Convert.ToInt32(((Label)e.Row.FindControl("lblAmount")).Text);
                    double price = Convert.ToDouble(((Label)e.Row.FindControl("lblPrice")).Text);
                    cost += price * amount;
                    lblTotalCost.Text = cost.ToString();
                }
            }
        }

        protected void Btnadd_Click(object sender, EventArgs e)
        {
            int row_index = ((GridViewRow)((Button)sender).NamingContainer).RowIndex;
            string price = (((TextBox)GridViewProducts.Rows[row_index].FindControl("txtPrice")).Text);
            string amount = ((TextBox)GridViewProducts.Rows[row_index].FindControl("txtAmount")).Text;
            if (string.IsNullOrEmpty(price) || string.IsNullOrEmpty(amount))
            {
                lblAddedMsg.Text = "لا يمكن اضافة منتج بدون السعر او الكميه !";
                lblAddedMsg.ForeColor = System.Drawing.Color.Red;
                BtnDoneAdding.Enabled = false;
            }
            else
            {
                AddProductToList(row_index, price, amount);
            }
        }

        private void AddProductToList(int row_index, string price, string amount)
        {
            BtnDoneAdding.Enabled = true;
            Product product = new Product();

            product.P_name = GridViewProducts.Rows[row_index].Cells[0].Text;
            product.Purchase_Price = Convert.ToDouble(GridViewProducts.Rows[row_index].Cells[6].Text);
            if (RadioButtonListCategories.SelectedValue == "Motors")
            {
                product.Mark = GridViewProducts.Rows[row_index].Cells[1].Text;
                product.Inch = Convert.ToDouble(GridViewProducts.Rows[row_index].Cells[2].Text);
            }
            else if (RadioButtonListCategories.SelectedValue == "Tol")
            {
                product.Mark = GridViewProducts.Rows[row_index].Cells[1].Text;
                product.Inch = Convert.ToDouble(GridViewProducts.Rows[row_index].Cells[2].Text);
                product.Style = GridViewProducts.Rows[row_index].Cells[3].Text;
            }
            product.Specified_Price = Convert.ToDouble(GridViewProducts.Rows[row_index].Cells[5].Text);
            if (ViewState["ProductsList"] != null && ((List<Product>)ViewState["ProductsList"]).Contains(product))
            {
                PanelFinish.Visible = true;
                lblAddedMsg.Text = "! هذا المنتج مسجل فى القائمة";
                lblAddedMsg.ForeColor = System.Drawing.Color.Red;
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
                lblAddedMsg.Text = "تم اضافة - " + product.P_name + " - الى القائمة";
                lblAddedMsg.ForeColor = System.Drawing.Color.Green;
            }
        }

        private void AddFreeItemToList()
        {
            BtnDoneAdding.Enabled = true;
            Product product = new Product();
            product.IsFreeItem = true;
            product.P_name = txtFreeItemName.Text;
            if (ViewState["ProductsList"] != null && ((List<Product>)ViewState["ProductsList"]).Contains(product))
            {
                PanelFinish.Visible = true;
                lblAddedMsg.Text = "! هذا المنتج مسجل فى القائمة";
                lblAddedMsg.ForeColor = System.Drawing.Color.Red;
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
                product.Amount = Convert.ToDecimal(txtFreeItemAmount.Text);
                product.Regulare_Price = Convert.ToDouble(txtFreeItemPrice.Text);
                PanelFinish.Visible = true;
                lblAddedMsg.Text = "تم اضافة - " + product.P_name + " - الى القائمة";
                lblAddedMsg.ForeColor = System.Drawing.Color.Green;
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
    }
}