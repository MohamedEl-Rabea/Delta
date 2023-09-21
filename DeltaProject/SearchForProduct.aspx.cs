using Business_Logic;
using DeltaProject.Business_Logic;
using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class SearchForProduct : Page
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
            int? productId = string.IsNullOrEmpty(txtProductId.Text) ? (int?)null : Convert.ToInt32(txtProductId.Text);
            GridViewProducts.DataSource = NewProduct.GetProducts(productId);
            GridViewProducts.DataBind();
        }

        protected void GridViewProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            PanelDetailedResult.Visible = true;
            PanelSuppliers.Visible = false;
            PanelProductDetails.Visible = false;
            PanelInitailResult.Visible = false;
            // Get the Selected product info
            int rowIndex = ((GridViewRow)((LinkButton)e.CommandSource).NamingContainer).RowIndex;
            NewProduct product = new NewProduct();
            product.Id = Convert.ToInt32(GridViewProducts.Rows[rowIndex].Cells[0].Text);
            product.Name = GridViewProducts.Rows[rowIndex].Cells[1].Text;
            product.Mark = GridViewProducts.Rows[rowIndex].Cells[2].Text;
            if (string.IsNullOrEmpty(GridViewProducts.Rows[rowIndex].Cells[3].Text))
                product.Inch = Convert.ToDouble(GridViewProducts.Rows[rowIndex].Cells[3].Text);
            product.Style = GridViewProducts.Rows[rowIndex].Cells[4].Text;
            product.Quantity = Convert.ToDecimal(GridViewProducts.Rows[rowIndex].Cells[5].Text);
            product.PurchasePrice = Convert.ToDecimal(GridViewProducts.Rows[rowIndex].Cells[7].Text);
            product.SellPrice = Convert.ToDecimal(GridViewProducts.Rows[rowIndex].Cells[8].Text);
            product.Description = GridViewProducts.Rows[rowIndex].Cells[9].Text;
            lblP_name.Text = product.Name;
            lblMark.Text = product.Mark;
            lblStyle.Text = product.Style;
            lblInch.Text = product.Inch.ToString();
            lblPurchase_Price.Text = product.PurchasePrice.ToString();
            lblSellPrice.Text = product.SellPrice.ToString();
            lblAmount.Text = product.Quantity.ToString();
            TxtDesc.Text = product.Description;
            //get the product suppliers with the product key (name- price- mark- style- inch)
            GridViewSuppliers.DataSource = Suppliers_Products.Get_Specific_Product_Suppliers(product.Id, product.PurchasePrice);
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
            int rowIndex = ((GridViewRow)((LinkButton)e.CommandSource).NamingContainer).RowIndex;
            string supplier_name = GridViewSuppliers.Rows[rowIndex].Cells[0].Text;
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
            GridViewSuppliers.SelectedIndex = rowIndex;
            PanelSupplierInfo.Visible = true;
            SetFocus(GridViewFaxs);
        }
    }
}