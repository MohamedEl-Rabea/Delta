using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;

namespace DeltaProject
{
    public partial class Delete_Products : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            BindProductsGrid();
            lblDeleteMsg.Text = "";
        }

        private void BindProductsGrid()
        {
            string P_name;
            if (TextBoxSearch.Visible)
            {
                P_name = TextBoxSearch.Text;
                GridViewProducts.Columns[2].ItemStyle.CssClass = "NoDispaly";
                GridViewProducts.Columns[2].HeaderStyle.CssClass = "NoDispaly";
                GridViewProducts.Columns[3].ItemStyle.CssClass = "NoDispaly";
                GridViewProducts.Columns[3].HeaderStyle.CssClass = "NoDispaly";
                GridViewProducts.Columns[4].ItemStyle.CssClass = "NoDispaly";
                GridViewProducts.Columns[4].HeaderStyle.CssClass = "NoDispaly";

            }
            else if (TextBoxTol.Visible)
            {
                P_name = TextBoxTol.Text;
                GridViewProducts.Columns[2].ItemStyle.CssClass = "";
                GridViewProducts.Columns[2].HeaderStyle.CssClass = "";
                GridViewProducts.Columns[3].ItemStyle.CssClass = "";
                GridViewProducts.Columns[3].HeaderStyle.CssClass = "";
                GridViewProducts.Columns[4].ItemStyle.CssClass = "";
                GridViewProducts.Columns[4].HeaderStyle.CssClass = "";
            }
            else
            {
                P_name = TextBoxMotors.Text;
                GridViewProducts.Columns[2].ItemStyle.CssClass = "";
                GridViewProducts.Columns[2].HeaderStyle.CssClass = "";
                GridViewProducts.Columns[3].ItemStyle.CssClass = "";
                GridViewProducts.Columns[3].HeaderStyle.CssClass = "";
                GridViewProducts.Columns[4].HeaderStyle.CssClass = "NoDispaly";
                GridViewProducts.Columns[4].ItemStyle.CssClass = "NoDispaly";
            }
            GridViewProducts.DataSource = Product.GetProducts(P_name);
            GridViewProducts.DataBind();
        }

        protected void GridViewProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int row_index = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer).RowIndex;
            Product product = new Product();
            product.P_name = GridViewProducts.Rows[row_index].Cells[1].Text;
            product.Mark = GridViewProducts.Rows[row_index].Cells[2].Text;
            product.Inch = Convert.ToDouble(GridViewProducts.Rows[row_index].Cells[3].Text);
            product.Style = GridViewProducts.Rows[row_index].Cells[4].Text;
            product.Purchase_Price = Convert.ToDouble(GridViewProducts.Rows[row_index].Cells[5].Text);
            string m;
            if (!product.Delete_Product(out m))
            {
                lblDeleteMsg.Text = m;
                lblDeleteMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblDeleteMsg.Text = "تم المسح";
                lblDeleteMsg.ForeColor = System.Drawing.Color.Green;
            }
            BindProductsGrid();
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