using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;

namespace DeltaProject
{
    public partial class Supplier_Returned_Products : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            BindProductsGrid();
            PanelProducts.Visible = true;
            PanelSupplier.Visible = false;
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

        protected void BtnExecute_Click(object sender, EventArgs e)
        {
            int row_index = ((GridViewRow)((Button)sender).NamingContainer).RowIndex;
            string strDay = ((TextBox)GridViewProductSuppliers.Rows[row_index].FindControl("txtReturnDay")).Text;
            string strMonth = ((TextBox)GridViewProductSuppliers.Rows[row_index].FindControl("txtReturnMonth")).Text;
            string strYear = ((TextBox)GridViewProductSuppliers.Rows[row_index].FindControl("txtReturnYear")).Text;
            string amount = ((TextBox)GridViewProductSuppliers.Rows[row_index].FindControl("txtReturnedAmount")).Text;
            if (string.IsNullOrEmpty(amount))
            {
                lblMsg.Text = "يجب تحديد الكميه المرتجعه";
                lblMsg.ForeColor = System.Drawing.Color.Red;
            }
            else if (string.IsNullOrEmpty(strDay) || string.IsNullOrEmpty(strMonth) || string.IsNullOrEmpty(strYear))
            {
                lblMsg.Text = "يجب تحديد تاريخ المرتجع";
                lblMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                Suppliers_Products SP = new Suppliers_Products();
                SP.Supplier_Name = GridViewProductSuppliers.Rows[row_index].Cells[0].Text;
                SP.Purchase_Date = Convert.ToDateTime(GridViewProductSuppliers.Rows[row_index].Cells[1].Text);
                SP.Price = Convert.ToInt32(GridViewProductSuppliers.Rows[row_index].Cells[2].Text);
                SP.Returned_Products = Convert.ToInt32(amount);
                int Day = Convert.ToInt32(strDay);
                int Month = Convert.ToInt32(strMonth);
                int Year = Convert.ToInt32(strYear);
                SP.Return_Date = new DateTime(Year, Month, Day, DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);
                string m = "";
                Product product = new Product();
                product.P_name = GridViewProducts.Rows[row_index].Cells[0].Text;
                product.Mark = GridViewProducts.Rows[row_index].Cells[1].Text;
                product.Inch = Convert.ToDouble(GridViewProducts.Rows[row_index].Cells[2].Text);
                product.Style = GridViewProducts.Rows[row_index].Cells[3].Text;
                if (!SP.Return_Products_To_Suuplier(out m, product.P_name, product.Mark, product.Style, product.Inch))
                {
                    lblMsg.Text = m;
                    lblMsg.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    lblMsg.Text = "تم بنجاح";
                    lblMsg.ForeColor = System.Drawing.Color.Green;
                }
            }
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

        protected void GridViewProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int row_index = ((GridViewRow)((LinkButton)e.CommandSource).NamingContainer).RowIndex;
            Product product = new Product();
            product.P_name = GridViewProducts.Rows[row_index].Cells[0].Text;
            product.Mark = GridViewProducts.Rows[row_index].Cells[1].Text;
            product.Inch = Convert.ToDouble(GridViewProducts.Rows[row_index].Cells[2].Text);
            product.Style = GridViewProducts.Rows[row_index].Cells[3].Text;
            GridViewProductSuppliers.DataSource = product.Suppliers;
            GridViewProductSuppliers.DataBind();
            lblMsg.Text = "";
            PanelProducts.Visible = false;
            PanelSupplier.Visible = true;
        }
    }
}