using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;

namespace DeltaProject
{
    public partial class AddProducts : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ButtonNext_Click(object sender, EventArgs e)
        {
            PanelAddSupplier.Visible = false;
            PanelAddProducts.Visible = true;
        }

        protected void BtnAddProductToList_Click(object sender, EventArgs e)
        {
            Product product = new Product();
            product.P_name = txtboxP_name.Text;
            product.Purchase_Price = Convert.ToDouble(txtboxPurchasePrice.Text);
            product.Regulare_Price = Convert.ToDouble(txtboxRegularSellPrice.Text);
            product.Special_Price = Convert.ToDouble(txtboxSpecialSellPrice.Text);
            product.Amount = Convert.ToDecimal(txtboxAmount.Text);
            product.Description = TxtDesc.Text;
            if (ProductType.SelectedValue == "Motors")
            {
                product.Mark = txtMark.Text;
                product.Inch = Convert.ToDouble(txtInch.Text);
            }
            if (ProductType.SelectedValue == "Tol")
            {
                product.Mark = txtMark.Text;
                product.Inch = Convert.ToDouble(txtInch.Text);
                product.Style = txtStyle.Text;
            }
            if (ViewState["ProductsList"] == null)
            {
                List<Product> Products = new List<Product>();
                Products.Add(product);
                ViewState["ProductsList"] = Products;
                lblMsg.Text = "تم اضافة - " + txtboxP_name.Text + " - الى القائمة";
                lblMsg.ForeColor = System.Drawing.Color.Green;
            }
            else if (((List<Product>)ViewState["ProductsList"]).Contains(product))
            {
                lblMsg.Text = "هذ المنتج مسجل بالفعل فى القائمة";
                lblMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                ((List<Product>)ViewState["ProductsList"]).Add(product);
                lblMsg.Text = "تم اضافة - " + txtboxP_name.Text + " - الى القائمة";
                lblMsg.ForeColor = System.Drawing.Color.Green;
            }

            SetFocus(BtnAddProductToList);
        }

        protected void BtnNextToProductsList_Click(object sender, EventArgs e)
        {
            PanelAddProducts.Visible = false;
            PanelProductsList.Visible = true;
            GridViewProductsList.EditIndex = -1;
            ProductsListBind();
            double Cost = GetTotalCost();
            if (txtSupplier_Name.Text != "")
            {
                lblSupplier.Text = txtSupplier_Name.Text;
                CustomValidatorPaidAmount.Enabled = true;
                txtPaid_Amount.Enabled = true;
            }
            else
            {
                txtPaid_Amount.Enabled = false;
                CustomValidatorPaidAmount.Enabled = false;
            }
            DateTime Purchase_Date = new DateTime(Convert.ToInt32(txtYear.Text), Convert.ToInt32(txtMonth.Text), Convert.ToInt32(txtDay.Text));
            lblPurchaseDate.Text = Purchase_Date.ToShortDateString();
            lblTotalCost.Text = Cost.ToString();
        }

        private double GetTotalCost()
        {
            double Cost = 0.00;
            foreach (GridViewRow row in GridViewProductsList.Rows)
            {
                Cost += Convert.ToDouble(((Label)row.FindControl("lblPurchase_Price")).Text) * Convert.ToDouble(((Label)row.FindControl("lblAmount")).Text);
            }
            return Cost;
        }

        protected void GridViewProductsList_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Edit_Row")
            {
                int row_index = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer).RowIndex;
                string P_name = ((Label)GridViewProductsList.Rows[row_index].FindControl("lblP_name")).Text;
                string Mark = ((Label)GridViewProductsList.Rows[row_index].FindControl("lblP_Mark")).Text == "-" ? "Not found"
                    : ((Label)GridViewProductsList.Rows[row_index].FindControl("lblP_Mark")).Text;
                string Style = ((Label)GridViewProductsList.Rows[row_index].FindControl("lblP_Style")).Text == "-" ? "Not found"
                    : ((Label)GridViewProductsList.Rows[row_index].FindControl("lblP_Style")).Text;
                string Inch = ((Label)GridViewProductsList.Rows[row_index].FindControl("lblP_Inch")).Text == "-" ? "0"
                    : ((Label)GridViewProductsList.Rows[row_index].FindControl("lblP_Inch")).Text;
                double Purchase_Price = Convert.ToDouble(((Label)GridViewProductsList.Rows[row_index].FindControl("lblPurchase_Price")).Text);
                ViewState["OldP_name"] = P_name;
                ViewState["OldMark"] = Mark;
                ViewState["OldStyle"] = Style;
                ViewState["OldInch"] = Inch;
                ViewState["OldPurchase_Price"] = Purchase_Price;
                GridViewProductsList.EditIndex = row_index;
                ProductsListBind();
            }
            else if (e.CommandName == "Delete_Row")
            {
                int row_index = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer).RowIndex;

                string P_name = ((Label)GridViewProductsList.Rows[row_index].FindControl("lblP_name")).Text;

                string Mark = ((Label)GridViewProductsList.Rows[row_index].FindControl("lblP_Mark")).Text == "-" ? "Not found"
                    : ((Label)GridViewProductsList.Rows[row_index].FindControl("lblP_Mark")).Text;

                string Style = ((Label)GridViewProductsList.Rows[row_index].FindControl("lblP_Style")).Text == "-" ? "Not found"
                    : ((Label)GridViewProductsList.Rows[row_index].FindControl("lblP_Style")).Text;

                double Inch = ((Label)GridViewProductsList.Rows[row_index].FindControl("lblP_Inch")).Text == "-" ? 0
                    : Convert.ToDouble(((Label)GridViewProductsList.Rows[row_index].FindControl("lblP_Inch")).Text);

                double Purchase_Price = Convert.ToDouble(((Label)GridViewProductsList.Rows[row_index].FindControl("lblPurchase_Price")).Text);

                ((List<Product>)ViewState["ProductsList"]).RemoveAll(product => (product.P_name == P_name) && (product.Purchase_Price == Purchase_Price)
                    && product.Mark == Mark && product.Style == Style && product.Inch == Inch);
                ProductsListBind();
                lblTotalCost.Text = GetTotalCost().ToString();
            }
            else if (e.CommandName == "Confirm_Update")
            {
                int row_index = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer).RowIndex;
                string OldP_name = ViewState["OldP_name"].ToString();
                string OldMark = ViewState["OldMark"].ToString();
                string OldStyle = ViewState["OldStyle"].ToString();
                double OldInch = Convert.ToDouble(ViewState["OldInch"].ToString());
                double OldPurchase_Price = Convert.ToDouble(ViewState["OldPurchase_Price"]);
                Product p = new Product();
                p.P_name = ((TextBox)GridViewProductsList.Rows[row_index].FindControl("txtP_name")).Text;
                p.Mark = ((TextBox)GridViewProductsList.Rows[row_index].FindControl("txtP_Mark")).Text == "-" ? "Not found"
                    : ((TextBox)GridViewProductsList.Rows[row_index].FindControl("txtP_Mark")).Text;
                p.Style = ((TextBox)GridViewProductsList.Rows[row_index].FindControl("txtP_Style")).Text == "-" ? "Not found"
                    : ((TextBox)GridViewProductsList.Rows[row_index].FindControl("txtP_Style")).Text;
                p.Inch = ((TextBox)GridViewProductsList.Rows[row_index].FindControl("txtP_Inch")).Text == "-" ? 0
                    : Convert.ToDouble(((TextBox)GridViewProductsList.Rows[row_index].FindControl("txtP_Inch")).Text);
                p.Purchase_Price = Convert.ToDouble(((TextBox)GridViewProductsList.Rows[row_index].FindControl("txtPurchase_Price")).Text);
                p.Regulare_Price = Convert.ToDouble(((TextBox)GridViewProductsList.Rows[row_index].FindControl("txtRegulare_Price")).Text);
                p.Special_Price = Convert.ToDouble(((TextBox)GridViewProductsList.Rows[row_index].FindControl("txtSpecial_Price")).Text);
                p.Amount = Convert.ToDecimal(((TextBox)GridViewProductsList.Rows[row_index].FindControl("txtAmount")).Text);
                ((List<Product>)ViewState["ProductsList"]).RemoveAll(product => (product.P_name == OldP_name) && (product.Purchase_Price == OldPurchase_Price
                    && product.Mark == OldMark && product.Style == OldStyle && product.Inch == OldInch));
                if (!((List<Product>)ViewState["ProductsList"]).Contains(p))
                {
                    ((List<Product>)ViewState["ProductsList"]).Add(p);
                }
                GridViewProductsList.EditIndex = -1;
                ProductsListBind();
                lblTotalCost.Text = GetTotalCost().ToString();
            }
            else if (e.CommandName == "Cancel_Update")
            {
                GridViewProductsList.EditIndex = -1;
                ProductsListBind();
            }
        }

        private void ProductsListBind()
        {
            GridViewProductsList.DataSource = (List<Product>)ViewState["ProductsList"];
            GridViewProductsList.DataBind();
        }

        protected void ImageButtonBackToAddSupplier_Click(object sender, ImageClickEventArgs e)
        {
            PanelAddSupplier.Visible = true;
            PanelAddProducts.Visible = false;
        }

        protected void ImageButtonBackToAddProducts_Click(object sender, ImageClickEventArgs e)
        {
            PanelProductsList.Visible = false;
            PanelAddProducts.Visible = true;
        }

        protected void ProductType_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ProductType.SelectedValue == "Motors")
            {
                PanelMotors.Visible = true;
                PanelTol.Visible = false;
            }
            else if (ProductType.SelectedValue == "Tol")
            {
                PanelMotors.Visible = true;
                PanelTol.Visible = true;
            }
            else
            {
                PanelMotors.Visible = false;
                PanelTol.Visible = false;
            }
        }

        protected void GridViewProductsList_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (GridViewProductsList.EditIndex != e.Row.RowIndex)
                {
                    string Mark = ((Label)e.Row.FindControl("lblP_Mark")).Text;
                    string Inch = ((Label)e.Row.FindControl("lblP_Inch")).Text;
                    string Style = ((Label)e.Row.FindControl("lblP_Style")).Text;
                    if (Mark == "Not found")
                    {
                        ((Label)e.Row.FindControl("lblP_Mark")).Text = "-";
                    }
                    if (Inch == "0")
                    {
                        ((Label)e.Row.FindControl("lblP_Inch")).Text = "-";
                    }
                    if (Style == "Not found")
                    {
                        ((Label)e.Row.FindControl("lblP_Style")).Text = "-";
                    }
                }
                else
                {
                    string Mark = ((TextBox)e.Row.FindControl("txtP_Mark")).Text;
                    string Inch = ((TextBox)e.Row.FindControl("txtP_Inch")).Text;
                    string Style = ((TextBox)e.Row.FindControl("txtP_Style")).Text;
                    if (Mark == "Not found")
                    {
                        ((TextBox)e.Row.FindControl("txtP_Mark")).Text = "-";
                    }
                    if (Inch == "0")
                    {
                        ((TextBox)e.Row.FindControl("txtP_Inch")).Text = "-";
                    }
                    if (Style == "Not found")
                    {
                        ((TextBox)e.Row.FindControl("txtP_Style")).Text = "-";
                    }
                }
            }
        }

        protected void BtnFinish_Click(object sender, EventArgs e)
        {
            if (GridViewProductsList.Rows.Count == 0)
            {
                lblFinishMsg.Text = "لا توجد منتجات !";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblFinishMsg.Text = "";
                GridViewProductsList.EditIndex = -1;
                ProductsListBind();
                string m = "";
                bool AllDone = true;
                foreach (GridViewRow row in GridViewProductsList.Rows)
                {
                    Product product = new Product();
                    product.P_name = ((Label)row.FindControl("lblP_name")).Text;
                    string Mark = ((Label)row.FindControl("lblP_Mark")).Text;
                    string Inch = ((Label)row.FindControl("lblP_Inch")).Text;
                    string Style = ((Label)row.FindControl("lblP_Style")).Text;
                    if (Mark != "-")
                    {
                        product.Mark = Mark;
                    }
                    if (Style != "-")
                    {
                        product.Style = Style;
                    }
                    if (Inch != "-")
                    {
                        product.Inch = Convert.ToDouble(Inch);
                    }
                    product.Purchase_Price = Convert.ToDouble(((Label)row.FindControl("lblPurchase_Price")).Text);
                    product.Regulare_Price = Convert.ToDouble(((Label)row.FindControl("lblRegulare_Price")).Text);
                    product.Special_Price = Convert.ToDouble(((Label)row.FindControl("lblSpecial_Price")).Text);
                    product.Amount = Convert.ToDecimal(((Label)row.FindControl("lblAmount")).Text);
                    product.Description = ((Label)row.FindControl("lblDecription")).Text;
                    if (!product.Add_Product(out m, lblSupplier.Text, Convert.ToDateTime(lblPurchaseDate.Text)))
                    {
                        lblFinishMsg.Text += m + "هذا الخطأ عند المنتج " + product.P_name + "<br />";
                        lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                        AllDone = false;
                    }
                }
                if (AllDone && Convert.ToDouble(lblTotalCost.Text) != 0)
                {
                    double Expenses;
                    if (txtSupplier_Name.Text != "")
                        Expenses = Convert.ToDouble(txtPaid_Amount.Text);
                    else
                        Expenses = Convert.ToDouble(lblTotalCost.Text);
                    DateTime Purchase_Date = Convert.ToDateTime(lblPurchaseDate.Text);
                    Purchase_Date = new DateTime(Purchase_Date.Year, Purchase_Date.Month, Purchase_Date.Day, DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);

                    string Notes;
                    System.Text.StringBuilder ConcatenatedNotes = new System.Text.StringBuilder("ثمن شراء المنتجات التاليه : ");
                    foreach (Product product in (List<Product>)ViewState["ProductsList"])
                    {
                        ConcatenatedNotes.AppendLine();
                        ConcatenatedNotes.Append(product.Amount.ToString() + " " + product.P_name + " " + (product.Mark != "Not found" ? ("ماركة  " + product.Mark + " " +
                            product.Inch.ToString() + " بوصه " + (product.Style != "Not found" ? "طراز " + product.Style + " " : "")) : "")
                            + " سعر الواحده يساوى" + product.Purchase_Price.ToString());
                    }
                    Notes = ConcatenatedNotes.ToString();
                    if (!Product.Add_Supplier_Treatment(out m, lblSupplier.Text, Purchase_Date, Convert.ToDouble(lblTotalCost.Text), Expenses, Notes))
                    {
                        lblFinishMsg.Text = m;
                        lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                    }
                    else
                    {
                        lblFinishMsg.Text = "تم بنجاح";
                        lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                    }
                }
                else if (AllDone)
                {
                    lblFinishMsg.Text = "تم بنجاح";
                    lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                }
            }
        }
    }
}