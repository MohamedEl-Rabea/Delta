using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;

namespace DeltaProject
{
    public partial class Update_Product_Info : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            PanelProductInfo.Visible = false;
            PanelSuppliers.Visible = false;
            PanelProducts.Visible = true;
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
            GridViewProducts.SelectedIndex = -1;
        }

        protected void LnkSelect_Click(object sender, EventArgs e)
        {
            int row_index = ((GridViewRow)(((LinkButton)sender).NamingContainer)).RowIndex;
            GridViewProducts.SelectedIndex = row_index;
            // Select all suppliers for selected product
            string P_name = GridViewProducts.SelectedRow.Cells[0].Text;
            string Mark = GridViewProducts.Rows[row_index].Cells[1].Text;
            double Inch = Convert.ToDouble(GridViewProducts.Rows[row_index].Cells[2].Text);
            string Style = GridViewProducts.Rows[row_index].Cells[3].Text;
            double Price = Convert.ToDouble(GridViewProducts.SelectedRow.Cells[4].Text);
            ViewState["P_name"] = P_name;
            ViewState["Mark"] = Mark;
            ViewState["Style"] = Style;
            ViewState["Inch"] = Inch;
            ViewState["Price"] = Price;
            BindSuppliersGrid();
            Product product = new Product();
            product.P_name = P_name;
            product.Mark = Mark;
            product.Style = Style;
            product.Inch = Inch;
            product.Purchase_Price = Price;
            product = product.Get_Product_For_Update_Info();
            txtboxP_name.Text = product.P_name;
            txtMark.Text = product.Mark;
            txtStyle.Text = product.Style;
            txtInch.Text = product.Inch.ToString();
            txtboxPurchasePrice.Text = product.Purchase_Price.ToString();
            txtboxRegularSellPrice.Text = product.Regulare_Price.ToString();
            txtboxSpecialSellPrice.Text = product.Special_Price.ToString();
            txtboxAmount.Text = product.Amount.ToString();
            TxtDesc.Text = product.Description.ToString();
            PanelSuppliers.Visible = true;
            PanelProductInfo.Visible = false;
            if (RadioButtonListCategories.SelectedValue == "Tol")
            {
                PanelTol.Visible = true;
                PanelMotors.Visible = true;
            }
            else if (RadioButtonListCategories.SelectedValue == "Motors")
            {
                PanelTol.Visible = false;
                PanelMotors.Visible = true;
            }
            else
            {
                PanelTol.Visible = false;
                PanelMotors.Visible = false;
            }
            // for use in update process
            ViewState["OldP_name"] = product.P_name;
            ViewState["OldMark"] = product.Mark;
            ViewState["OldStyle"] = product.Style;
            ViewState["OldInch"] = product.Inch;
            ViewState["OldPurchase_Price"] = product.Purchase_Price;
        }

        private void BindSuppliersGrid()
        {
            string P_name = ViewState["P_name"].ToString();
            double Price = Convert.ToDouble(ViewState["Price"]);
            string Mark = ViewState["Mark"].ToString();
            double Inch = Convert.ToDouble(ViewState["Inch"]);
            string Style = ViewState["Style"].ToString();
            GridViewProductSuppliers.DataSource = Suppliers_Products.Get_Product_Suppliers_For_Update_Info(P_name, Price, Mark, Style, Inch);
            GridViewProductSuppliers.DataBind();
        }

        protected void ImageButtonBackToAddProducts_Click(object sender, ImageClickEventArgs e)
        {
            PanelSuppliers.Visible = false;
            PanelProductInfo.Visible = true;
            SetFocus(BtnUpdateProductInfo);
        }

        protected void ImageButtonBack_Click(object sender, ImageClickEventArgs e)
        {
            PanelSuppliers.Visible = true;
            PanelProductInfo.Visible = false;
        }

        protected void GridViewProductSuppliers_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (((Label)e.Row.FindControl("lblReturnDate")) != null)
                {
                    if (((Label)e.Row.FindControl("lblReturnDate")).Text == "01/01/0001")
                    {
                        ((Label)e.Row.FindControl("lblReturnDate")).Text = "لا يوجد";
                    }
                }
                else
                {
                    if ((((TextBox)e.Row.FindControl("txtReturnYear")).Text) == "1")
                    {
                        ((TextBox)e.Row.FindControl("txtReturnYear")).Text = "";
                        ((TextBox)e.Row.FindControl("txtReturnMonth")).Text = "";
                        ((TextBox)e.Row.FindControl("txtReturnDay")).Text = "";
                    }
                }
            }
        }

        protected void BtnUpdateProductInfo_Click(object sender, EventArgs e)
        {
            string NewP_name = txtboxP_name.Text;
            string NewMark = txtMark.Text;
            string NewStyle = txtStyle.Text;
            double NewInch = Convert.ToDouble(txtInch.Text);
            double NewPurchase_Price = Convert.ToDouble(txtboxPurchasePrice.Text);
            Product product = new Product();
            product.P_name = ViewState["OldP_name"].ToString();
            product.Mark = ViewState["OldMark"].ToString();
            product.Style = ViewState["OldStyle"].ToString();
            product.Inch = Convert.ToDouble(ViewState["OldInch"]);
            product.Purchase_Price = Convert.ToDouble(ViewState["OldPurchase_Price"]);
            product.Regulare_Price = Convert.ToDouble(txtboxRegularSellPrice.Text);
            product.Special_Price = Convert.ToDouble(txtboxSpecialSellPrice.Text);
            product.Description = TxtDesc.Text;
            string m = "";
            if (!product.Update_Products_Info(out m, NewP_name, NewPurchase_Price, NewMark, NewStyle, NewInch))
            {
                lblProductInfoMsg.Text = m;
                lblProductInfoMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblProductInfoMsg.Text = "تم بنجاح";
                lblProductInfoMsg.ForeColor = System.Drawing.Color.Green;
                SetFocus(ImageButtonBack);
            }
        }

        public string GetDay(DateTime Date)
        {
            return Date.Day.ToString();
        }

        public string GetMonth(DateTime Date)
        {

            return Date.Month.ToString();
        }

        public string GetYear(DateTime Date)
        {
            return Date.Year.ToString();
        }

        protected void GridViewProductSuppliers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            #region Edit_Row_Mode
            if (e.CommandName == "Edit_Row")
            {
                int row_index = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer).RowIndex;
                string S_name = ((Label)GridViewProductSuppliers.Rows[row_index].FindControl("lblsupplier")).Text;
                DateTime Purchase_Date = Convert.ToDateTime(((Label)GridViewProductSuppliers.Rows[row_index].FindControl("lblPurchase_Date")).Text);
                ViewState["OldS_name"] = S_name;
                ViewState["OldPurchase_Date"] = Purchase_Date;
                GridViewProductSuppliers.EditIndex = row_index;
                BindSuppliersGrid();
                SetFocus(ImageButtonBackToAddProducts);
            }
            #endregion
            #region Cancel_Edit_Mode
            else if (e.CommandName == "Cancel_Update")
            {
                GridViewProductSuppliers.EditIndex = -1;
                BindSuppliersGrid();
            }
            #endregion
            #region Confirm_Update
            else if (e.CommandName == "Confirm_Update")
            {
                int row_index = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer).RowIndex;
                string P_name = ViewState["P_name"].ToString();
                double Purchase_Price = Convert.ToDouble(ViewState["Price"]);
                string Mark = ViewState["Mark"].ToString();
                double Inch = Convert.ToDouble(ViewState["Inch"]);
                string Style = ViewState["Style"].ToString();

                string S_name = ((TextBox)GridViewProductSuppliers.Rows[row_index].FindControl("txtsupplier")).Text;

                int PucrhaseDay = Convert.ToInt32(((TextBox)GridViewProductSuppliers.Rows[row_index].FindControl("txtPurchaseDay")).Text);
                int PucrhaseMonth = Convert.ToInt32(((TextBox)GridViewProductSuppliers.Rows[row_index].FindControl("txtPurchaseMonth")).Text);
                int PucrhaseYear = Convert.ToInt32(((TextBox)GridViewProductSuppliers.Rows[row_index].FindControl("txtPurchaseYear")).Text);
                DateTime Purchase_Date = new DateTime(PucrhaseYear, PucrhaseMonth, PucrhaseDay);

                Suppliers_Products sp = new Suppliers_Products();
                sp.Supplier_Name = ViewState["OldS_name"].ToString();
                sp.Purchase_Date = Convert.ToDateTime(ViewState["OldPurchase_Date"]);
                sp.Amount = Convert.ToInt32(((TextBox)GridViewProductSuppliers.Rows[row_index].FindControl("txtSupplierAmount")).Text);
                sp.Returned_Products = Convert.ToInt32(((TextBox)GridViewProductSuppliers.Rows[row_index].FindControl("txtReturnedAmount")).Text);

                int ReturnYear;
                if (int.TryParse(((TextBox)GridViewProductSuppliers.Rows[row_index].FindControl("txtReturnYear")).Text, out ReturnYear))
                {
                    int ReturnDay = Convert.ToInt32(((TextBox)GridViewProductSuppliers.Rows[row_index].FindControl("txtReturnDay")).Text);
                    int ReturnMonth = Convert.ToInt32(((TextBox)GridViewProductSuppliers.Rows[row_index].FindControl("txtReturnMonth")).Text);

                    sp.Return_Date = new DateTime(ReturnYear, ReturnMonth, ReturnDay);
                }
                else
                {
                    sp.Return_Date = new DateTime(0001, 01, 01);
                }

                string m = "";
                if (!sp.Update_Supplier_Products(out m, P_name, Mark, Style, Inch, Purchase_Price, S_name, Purchase_Date))
                {
                    lblFinishMsg.Text = m;
                    lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    lblFinishMsg.Text = "تم بنجاح";
                    lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                    GridViewProductSuppliers.EditIndex = -1;
                    BindSuppliersGrid();
                }
            }
            #endregion
            #region Delete_item
            else if (e.CommandName == "Delete_Row")
            {
                int row_index = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer).RowIndex;
                string S_name = ((Label)GridViewProductSuppliers.Rows[row_index].FindControl("lblsupplier")).Text;
                DateTime Purchase_Date = Convert.ToDateTime(((Label)GridViewProductSuppliers.Rows[row_index].FindControl("lblPurchase_Date")).Text);
                string P_name = ViewState["P_name"].ToString();
                double Purchase_Price = Convert.ToDouble(ViewState["Price"]);
                string Mark = ViewState["Mark"].ToString();
                double Inch = Convert.ToDouble(ViewState["Inch"]);
                string Style = ViewState["Style"].ToString();

                Suppliers_Products sp = new Suppliers_Products();
                sp.Supplier_Name = S_name;
                sp.Purchase_Date = Purchase_Date;
                string m = "";
                if (!sp.Delete_Supplier_Products_Item(out m, P_name, Mark, Style, Inch, Purchase_Price))
                {
                    lblFinishMsg.Text = m;
                    lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    lblFinishMsg.Text = "تم بنجاح";
                    lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                    BindSuppliersGrid();
                }
            }
            #endregion
        }

        protected void RadioButtonListCategories_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (RadioButtonListCategories.SelectedValue == "Normal")
            {
                TextBoxSearch.Visible = true;
                TextBoxMotors.Visible = false;
                TextBoxTol.Visible = false;
            }
            else if (RadioButtonListCategories.SelectedValue == "Tol")
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
    }
}