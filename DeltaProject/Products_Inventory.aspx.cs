using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;

namespace DeltaProject
{
    public partial class Products_Inventory : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GridViewProducts.DataSource = Product.Get_Product_Inventory();
                GridViewProducts.DataBind();

                GridViewMotors.DataSource = Product.Get_Product_InventoryMotors();
                GridViewMotors.DataBind();

                GridViewTol.DataSource = Product.Get_Product_InventoryTol();
                GridViewTol.DataBind();
            }
        }

        protected void BtnAdjustment_Click(object sender, EventArgs e)
        {
            ShowConfirm();
        }

        private void ShowConfirm()
        {
            GridViewProducts.Columns[4].ControlStyle.CssClass = "";
            GridViewProducts.Columns[4].ItemStyle.CssClass = "";
            GridViewProducts.Columns[4].HeaderStyle.CssClass = "";

            GridViewMotors.Columns[6].ControlStyle.CssClass = "";
            GridViewMotors.Columns[6].ItemStyle.CssClass = "";
            GridViewMotors.Columns[6].HeaderStyle.CssClass = "";

            GridViewTol.Columns[7].ControlStyle.CssClass = "";
            GridViewTol.Columns[7].ItemStyle.CssClass = "";
            GridViewTol.Columns[7].HeaderStyle.CssClass = "";
        }

        protected void ImageButtonConfirmEdit_Click(object sender, ImageClickEventArgs e)
        {
            int row_index = ((GridViewRow)((ImageButton)sender).NamingContainer).RowIndex;
            GridView Products = (GridView)((GridViewRow)((ImageButton)sender).NamingContainer).NamingContainer;
            Product product = new Product();
            product.P_name = Products.Rows[row_index].Cells[0].Text;
            TextBox txtAmount = (TextBox)Products.Rows[row_index].FindControl("txtAmount");
            product.Amount = txtAmount.Text != "" ? Convert.ToDecimal(txtAmount.Text) : -1;
            if (Products.ID == GridViewProducts.ID)
            {
                product.Purchase_Price = Convert.ToDouble(Products.Rows[row_index].Cells[1].Text);
                ((GridViewRow)((ImageButton)sender).NamingContainer).Visible = false;
                if (product.Amount != -1) // this product need to adjusted
                {
                    product.Products_Adjustment();
                }
            }
            else if (Products.ID == GridViewMotors.ID)
            {
                product.Mark = Products.Rows[row_index].Cells[1].Text;
                product.Inch = Convert.ToDouble(Products.Rows[row_index].Cells[2].Text);
                product.Purchase_Price = Convert.ToDouble(Products.Rows[row_index].Cells[3].Text);
                ((GridViewRow)((ImageButton)sender).NamingContainer).Visible = false;
                if (product.Amount != -1) // this product need to adjusted
                {
                    product.Products_Adjustment();
                }
            }
            else
            {
                product.Mark = Products.Rows[row_index].Cells[1].Text;
                product.Inch = Convert.ToDouble(Products.Rows[row_index].Cells[2].Text);
                product.Style = Products.Rows[row_index].Cells[3].Text;
                product.Purchase_Price = Convert.ToDouble(Products.Rows[row_index].Cells[4].Text);
                ((GridViewRow)((ImageButton)sender).NamingContainer).Visible = false;
                if (product.Amount != -1) // this product need to adjusted
                {
                    product.Products_Adjustment();
                }
            }
            ShowConfirm();
        }
    }
}