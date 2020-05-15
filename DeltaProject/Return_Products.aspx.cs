using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;

namespace DeltaProject
{
    public partial class Return_Products : System.Web.UI.Page
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
            PanelBill.Visible = false;
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
                    Session["Bill_ID"] = txtBill_ID.Text;
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
                    // select bill items
                    BindBill(Convert.ToInt64(txtBill_ID.Text));
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
                Bill bill = new Bill();
                bill.Bill_ID = Bill_ID;
                double Cost, Paid_amount;
                bill = bill.Get_Bill_Info(out Cost, out Paid_amount);
                lblBill_ID.Text = Bill_ID.ToString();
                lblBillDate.Text = bill.Bill_Date.ToShortDateString();
                lblClientName.Text = bill.Client_Name;
                lblBillCost.Text = Cost.ToString();
                lblDiscountValue.Text = bill.Discount.ToString();
                lblPaid_Value.Text = Paid_amount.ToString();
                lblAdditionalCostValue.Text = bill.AdditionalCost.ToString();
                lblAdditionalcostNotes.Text = bill.AdditionalCostNotes;
                lblRest.Text = (Cost + bill.AdditionalCost - Paid_amount - bill.Discount) >= 0 ? (Cost + bill.AdditionalCost - Paid_amount - bill.Discount).ToString() :
                    (-(Cost + bill.AdditionalCost - Paid_amount - bill.Discount)).ToString() + " " + "فرق تكلفه للعميل";
                BindBill(Bill_ID);
                PanelBill.Visible = true;
                PanelBills.Visible = false;
            }
        }

        private void BindBill(long Bill_ID)
        {
            GridViewBillList.DataSource = Bill_Content.Get_Bill_Items(Bill_ID);
            GridViewBillList.DataBind();
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

        protected void BtnFinish_Click(object sender, EventArgs e)
        {
            Bill_Content content = new Bill_Content();
            content.P_name = txtP_Name.Text;
            content.amount = Convert.ToInt32(txtReturnedAmount.Text);
            string name, mark, inch, style, m;
            GetName(txtP_Name.Text, out name, out mark, out inch, out style);
            DateTime Return_Date = new DateTime(Convert.ToInt32(txtYear.Text), Convert.ToInt32(txtMonth.Text), Convert.ToInt32(txtDay.Text),
                DateTime.Now.Hour, DateTime.Now.Minute + 1, DateTime.Now.Second);
            long Bill_ID = Convert.ToInt64(lblBill_ID.Text);
            double Rest_Of_Money;
            if (!content.Return_Products(out m, Bill_ID, style, inch, mark, name, Return_Date, out Rest_Of_Money))
            {
                lblFinishMsg.Text = m;
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                // check for rest
                if (Rest_Of_Money < 0) // Paid_amount greater than bill cost
                {
                    ViewState["Paid_amount"] = Rest_Of_Money;
                    PanelRest.Visible = true;
                    BtnFinish.BackColor = System.Drawing.Color.Red;
                    BtnFinish.Enabled = false;
                    lblRestOfMoney.Text = (-Rest_Of_Money).ToString() + " جنيها";
                }
                else
                {
                    lblFinishMsg.Text = "تم بنجاح";
                    lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                }

            }
        }

        protected void BtnConfirm_Click(object sender, EventArgs e)
        {
            if (RBLYesOrNo.SelectedIndex == 0)// so the rest is paid
            {
                DateTime Return_Date = new DateTime(Convert.ToInt32(txtYear.Text), Convert.ToInt32(txtMonth.Text), Convert.ToInt32(txtDay.Text)
                    , DateTime.Now.Hour, DateTime.Now.Minute + 2, DateTime.Now.Second);
                string category = "دفع مرتجع";
                double Paid_amount = Convert.ToDouble(ViewState["Paid_amount"]);
                string Notes = "دفع مرتجع للعميل : " + lblClientName.Text, m;
                Expenses_Class exp = new Expenses_Class();
                exp.Pay_Date = Return_Date;
                exp.Category = category;
                exp.Paid_Value = -Paid_amount;
                exp.Notes = Notes;
                if (!exp.Add_Expenses(out m, Convert.ToInt64(lblBill_ID.Text)))
                {
                    lblConfirm.Text = m;
                    lblConfirm.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    lblConfirm.Text = "تم بنجاح";
                    lblConfirm.ForeColor = System.Drawing.Color.Green;
                }
            }
            else if (RBLYesOrNo.SelectedIndex == 1)
            {
                lblConfirm.Text = "تم بنجاح";
                lblConfirm.ForeColor = System.Drawing.Color.Green;
            }
            else
            {
                lblConfirm.Text = "يجب اختيار نعم او لا";
                lblConfirm.ForeColor = System.Drawing.Color.Red;
            }
        }

        protected void ImageButtonSearchProducts_Click(object sender, ImageClickEventArgs e)
        {
            BindProductsGrid();
            PanelInitailResult.Visible = true;
        }

        private void BindProductsGrid()
        {
            string P_name;
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
            else
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
                    product.Amount = Convert.ToInt32(amount);
                    PanelFinish.Visible = true;
                    lblAddedMsg.Text = "تم اضافة - " + product.P_name + " - الى القائمة";
                    lblAddedMsg.ForeColor = System.Drawing.Color.Green;
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
                ((List<Product>)ViewState["ProductsList"])[index].Amount = Convert.ToInt32(((TextBox)GridViewProductsList.Rows[row_index].FindControl("txtAmount")).Text);
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

        protected void lnkBtnAddProducts_Click(object sender, EventArgs e)
        {
            PanelBill.Visible = false;
            PanelSale.Visible = true;
            PanelSearchClient.Visible = false;
        }

        protected void RBLProductType_SelectedIndexChanged(object sender, EventArgs e)
        {
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
            else
            {
                TextBoxMotors.Visible = true;
                TextBoxSearch.Visible = false;
                TextBoxTol.Visible = false;
            }
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
                System.Text.StringBuilder ConcatenatedNotes = new System.Text.StringBuilder("قام العميل باضافة منتجات جديدة للفاتورة : ");
                foreach (Product p in (List<Product>)ViewState["ProductsList"])
                {
                    if (!content.Add_Bill_Contents(out m, Convert.ToInt64(lblBill_ID.Text), p))
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
                    payment.Pay_Date = new DateTime(Convert.ToInt32(txtYear.Text), Convert.ToInt32(txtMonth.Text), Convert.ToInt32(txtDay.Text),
                        DateTime.Now.Hour, DateTime.Now.Minute + 1, DateTime.Now.Second);
                    payment.Paid_amount = 0;
                    payment.Notes = ConcatenatedNotes.ToString();
                    payment.Add_Bill_Payment(Convert.ToInt64(lblBill_ID.Text));
                    lblConfirmMsg.Text = "تم بنجاح";
                }
            }
        }
    }
}