using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;

namespace DeltaProject
{
    public partial class Collect_Product : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            GridViewProducts.DataSource = Product.GetProducts(TextBoxSearch.Text);
            GridViewProducts.DataBind();
        }

        protected void Btnadd_Click(object sender, EventArgs e)
        {
            int row_index = ((GridViewRow)((Button)sender).NamingContainer).RowIndex;
            string amount = ((TextBox)GridViewProducts.Rows[row_index].FindControl("txtAmount")).Text;
            if (string.IsNullOrEmpty(amount))
            {
                PanelFinish.Visible = true;
                lblFinishMsg.Text = "لا يمكن اضافة منتج بدون الكميه !";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                Product product = new Product();
                product.P_name = GridViewProducts.Rows[row_index].Cells[0].Text;
                product.Purchase_Price = Convert.ToDouble(GridViewProducts.Rows[row_index].Cells[1].Text);
                product.Amount = Convert.ToDecimal(amount);
                if (ViewState["Products_List"] == null)
                {
                    List<Product> Products = new List<Product>();
                    Products.Add(product);
                    ViewState["Products_List"] = Products;
                    PanelFinish.Visible = true;
                    lblFinishMsg.Text = "تم اضافة - " + product.P_name + " - الى القائمة";
                    lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                }
                else
                {
                    List<Product> list = ((List<Product>)ViewState["Products_List"]);
                    if (!list.Contains(product))
                    {
                        PanelFinish.Visible = true;
                        list.Add(product);
                        lblFinishMsg.Text = "تم اضافة - " + product.P_name + " - الى القائمة";
                        lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                    }
                    else
                    {
                        PanelFinish.Visible = true;
                        lblFinishMsg.Text = "! هذا المنتج مسجل فى القائمة";
                        lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                    }
                }
            }
        }

        protected void BtnFinish_Click(object sender, EventArgs e)
        {
            PnlCollectProducts.Visible = false;
            PnlGeneratedProductInfo.Visible = true;
            BindSelectedProducts();
            txtboxPurchasePrice.Text = TotalCost.ToString();
        }

        protected void GridViewSelectedProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int row_index = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer).RowIndex;
            List<Product> list = (List<Product>)ViewState["Products_List"];
            if (e.CommandName == "Edit_Row")
            {
                GridViewSelectedProducts.EditIndex = row_index;
                BindSelectedProducts();
            }
            else if (e.CommandName == "Delete_Row")
            {
                Product product = new Product();
                product.P_name = GridViewSelectedProducts.Rows[row_index].Cells[1].Text;
                product.Purchase_Price = Convert.ToDouble(GridViewSelectedProducts.Rows[row_index].Cells[2].Text);
                list.Remove(product);
                BindSelectedProducts();
            }
            else if (e.CommandName == "Cancel_Update")
            {
                Product product = new Product();
                product.P_name = GridViewSelectedProducts.Rows[row_index].Cells[1].Text;
                product.Purchase_Price = Convert.ToDouble(GridViewSelectedProducts.Rows[row_index].Cells[2].Text);
                GridViewSelectedProducts.EditIndex = -1;
                BindSelectedProducts();
            }
            else if (e.CommandName == "Confirm_Update")
            {
                Product product = new Product();
                product.P_name = GridViewSelectedProducts.Rows[row_index].Cells[1].Text;
                product.Purchase_Price = Convert.ToDouble(GridViewSelectedProducts.Rows[row_index].Cells[2].Text);
                product.Amount = Convert.ToDecimal(((TextBox)GridViewSelectedProducts.Rows[row_index].FindControl("txtAmount")).Text);
                list.Find(prod => prod.P_name == product.P_name && prod.Purchase_Price == product.Purchase_Price).Amount = product.Amount;
                GridViewSelectedProducts.EditIndex = -1;
                BindSelectedProducts();
            }
        }

        void BindSelectedProducts()
        {
            GridViewSelectedProducts.DataSource = ((List<Product>)ViewState["Products_List"]);
            GridViewSelectedProducts.DataBind();
        }

        protected void ImageButtonBackToAddProducts_Click(object sender, ImageClickEventArgs e)
        {
            PnlCollectProducts.Visible = true;
            PnlGeneratedProductInfo.Visible = false;
        }

        double TotalCost = 0.00;
        protected void GridViewSelectedProducts_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if ((Label)e.Row.FindControl("lblAmount") != null)
            {
                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    double Purchase_Price = Convert.ToDouble(e.Row.Cells[2].Text);
                    int Amount = Convert.ToInt32(((Label)e.Row.FindControl("lblAmount")).Text);

                    TotalCost += (Purchase_Price * Amount);
                }
            }
        }

        protected void BtnDone_Click(object sender, EventArgs e)
        {
            lblDoneMsg.Text = "";
            bool AllValid = true;
            foreach (GridViewRow row in GridViewSelectedProducts.Rows)
            {
                Product product = new Product();
                product.P_name = row.Cells[1].Text;
                product.Purchase_Price = Convert.ToDouble(row.Cells[2].Text);
                product.Amount = Convert.ToDecimal(((Label)row.FindControl("lblAmount")).Text) * Convert.ToInt32(txtboxAmount.Text);
                if (!product.IsValidAmount())
                {
                    lblDoneMsg.Text += "لا تتوفر كل الكميه المطلوبة من المنتج : " + product.P_name + "<br />";
                    lblDoneMsg.ForeColor = System.Drawing.Color.Red;
                    AllValid = false;
                }
            }
            #region add new collected product
            if (AllValid) // add new product with provided info and decrease the used products
            {
                if (GridViewSelectedProducts.Rows.Count == 0)
                {
                    lblDoneMsg.Text = "لا توجد منتجات !";
                    lblDoneMsg.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    lblDoneMsg.Text = "";
                    GridViewSelectedProducts.EditIndex = -1;
                    BindSelectedProducts();
                    string m = "";
                    Product product = new Product();
                    product.P_name = txtboxP_name.Text;
                    product.Purchase_Price = Convert.ToDouble(txtboxPurchasePrice.Text);
                    product.Special_Price = Convert.ToDouble(txtboxSpecialSellPrice.Text);
                    product.Regulare_Price = Convert.ToDouble(txtboxRegularSellPrice.Text);
                    product.Amount = Convert.ToDecimal(txtboxAmount.Text);
                    product.Description = TxtDesc.Text;
                    if (!product.Add_Product(out m, "Unknown", new DateTime()))
                    {
                        lblDoneMsg.Text = m;
                        lblDoneMsg.ForeColor = System.Drawing.Color.Red;
                    }
                    else
                    {
                        foreach (GridViewRow row in GridViewSelectedProducts.Rows)
                        {
                            product.P_name = row.Cells[1].Text;
                            product.Purchase_Price = Convert.ToDouble(row.Cells[2].Text);
                            product.Amount = Convert.ToDecimal(((Label)row.FindControl("lblAmount")).Text) * Convert.ToInt32(txtboxAmount.Text);
                            if (!product.AddContent(out m, txtboxP_name.Text, Convert.ToDouble(txtboxPurchasePrice.Text)))
                            {
                                lblDoneMsg.Text += m + "هذا الخطأ عند المنتج : " + product.P_name + "<br />";
                                lblDoneMsg.ForeColor = System.Drawing.Color.Red;
                                AllValid = false;
                            }
                        }
                        if (AllValid)
                        {
                            lblDoneMsg.Text = "تم بنجاح";
                            lblDoneMsg.ForeColor = System.Drawing.Color.Green;
                        }
                    }

                }
            }
            #endregion
        }
    }
}