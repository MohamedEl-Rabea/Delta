using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;

namespace DeltaProject
{
    public partial class Search_For_Product : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            BindProductsGrid();
            PanelInitailResult.Visible = true;
            PanelDetailedResult.Visible = false;
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

        protected void GridViewProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            PanelDetailedResult.Visible = true;
            PanelSuppliers.Visible = false;
            PanelProductDetails.Visible = false;
            PanelInitailResult.Visible = false;
            // Get the Selected product info
            int row_index = ((GridViewRow)((LinkButton)e.CommandSource).NamingContainer).RowIndex;
            Product product = new Product();
            product.P_name = GridViewProducts.Rows[row_index].Cells[0].Text;
            product.Mark = GridViewProducts.Rows[row_index].Cells[1].Text;
            product.Inch = Convert.ToDouble(GridViewProducts.Rows[row_index].Cells[2].Text);
            product.Style = GridViewProducts.Rows[row_index].Cells[3].Text;
            product.Purchase_Price = Convert.ToDouble(GridViewProducts.Rows[row_index].Cells[4].Text);
            product = product.Get_Product_info();
            lblP_name.Text = product.P_name;
            lblMark.Text = product.Mark;
            lblStyle.Text = product.Style;
            lblInch.Text = product.Inch.ToString();
            lblPurchase_Price.Text = product.Purchase_Price.ToString();
            lblRegSellPrice.Text = product.Regulare_Price.ToString();
            lblSpecialSellPrice.Text = product.Special_Price.ToString();
            lblAmount.Text = product.Amount.ToString();
            TxtDesc.Text = product.Description;
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
            //get the product suppliers with the product key (name- price- mark- style- inch)
            GridViewSuppliers.DataSource = Suppliers_Products.Get_Specific_Product_Suppliers(product.P_name, product.Purchase_Price);
            GridViewSuppliers.DataBind();
        }

        protected void ImageButtonExtendProduct_Click(object sender, ImageClickEventArgs e)
        {
            PanelProductDetails.Visible = true;
            ImageButtonCollapseProduct.Visible = true;
            ImageButtonExtendProduct.Visible = false;
        }

        protected void ImageButtonCollapseProduct_Click(object sender, ImageClickEventArgs e)
        {
            PanelProductDetails.Visible = false;
            ImageButtonCollapseProduct.Visible = false;
            ImageButtonExtendProduct.Visible = true;
        }

        protected void LinkButtonPro_Info_Click(object sender, EventArgs e)
        {
            if (PanelProductDetails.Visible)
            {
                PanelProductDetails.Visible = false;
                ImageButtonCollapseProduct.Visible = false;
                ImageButtonExtendProduct.Visible = true;
            }
            else
            {
                PanelProductDetails.Visible = true;
                ImageButtonCollapseProduct.Visible = true;
                ImageButtonExtendProduct.Visible = false;
            }
        }

        protected void ImageButtonExtendSuppliers_Click(object sender, ImageClickEventArgs e)
        {
            PanelSuppliers.Visible = true;
            ImageButtonExtendSuppliers.Visible = false;
            ImageButtonCollapseSuppliers.Visible = true;
            GridViewSuppliers.SelectedIndex = -1;
            PanelSupplierInfo.Visible = false;
            SetFocus(GridViewSuppliers);

        }

        protected void ImageButtonCollapseSuppliers_Click(object sender, ImageClickEventArgs e)
        {
            PanelSuppliers.Visible = false;
            ImageButtonExtendSuppliers.Visible = true;
            ImageButtonCollapseSuppliers.Visible = false;
            GridViewSuppliers.SelectedIndex = -1;
            PanelSupplierInfo.Visible = false;

        }

        protected void LinkButtonSuppliers_Click(object sender, EventArgs e)
        {
            if (PanelSuppliers.Visible)
            {
                PanelSuppliers.Visible = false;
                ImageButtonCollapseSuppliers.Visible = false;
                ImageButtonExtendSuppliers.Visible = true;
                GridViewSuppliers.SelectedIndex = -1;
                PanelSupplierInfo.Visible = false;
            }
            else
            {
                PanelSuppliers.Visible = true;
                ImageButtonCollapseSuppliers.Visible = true;
                ImageButtonExtendSuppliers.Visible = false;
                GridViewSuppliers.SelectedIndex = -1;
                PanelSupplierInfo.Visible = false;
                SetFocus(GridViewSuppliers);
            }
        }

        protected void GridViewSuppliers_RowCommand(object sender, GridViewCommandEventArgs e)
        {   // Select Supplier info
            int row_index = ((GridViewRow)((LinkButton)e.CommandSource).NamingContainer).RowIndex;
            string supplier_name = GridViewSuppliers.Rows[row_index].Cells[0].Text;
            Supplier supplier = new Supplier();
            supplier.S_name = supplier_name;
            double debts;
            supplier = supplier.Get_Supplier_info(out debts);
            lblSupplier.Text = supplier.S_name;
            lblAddress.Text = supplier.Address;
            lblAccountNumber.Text = supplier.Account_Number;
            GridViewPhones.DataSource = Supplier_Phone.Get_Supplier_Phones(supplier_name);
            GridViewPhones.DataBind();
            GridViewFaxs.DataSource = Supplier_Fax.Get_Supplier_Faxs(supplier_name);
            GridViewFaxs.DataBind();
            GridViewSuppliers.SelectedIndex = row_index;
            PanelSupplierInfo.Visible = true;
            SetFocus(GridViewFaxs);
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