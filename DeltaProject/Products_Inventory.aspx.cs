using DeltaProject.Business_Logic;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class Products_Inventory : System.Web.UI.Page
    {
        private List<NewProduct> Products
        {
            get => ViewState["Products"] == null
                ? new List<NewProduct>()
                : (List<NewProduct>)ViewState["Products"];
            set => ViewState["Products"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ViewState["Products"] = NewProduct.GetProducts();
                BindGridViews();
            }
        }

        protected void BtnAdjustment_Click(object sender, EventArgs e)
        {
            decimal quantityBefore;
            string quantityAfter;
            List<ProductSettlement> productsSettlement = new List<ProductSettlement>();
            foreach (GridViewRow row in GridViewProducts.Rows)
            {
                quantityBefore = Convert.ToDecimal(row.Cells[3].Text);
                quantityAfter = ((TextBox)row.FindControl("txtQuantity")).Text;

                if (!string.IsNullOrEmpty(quantityAfter) && quantityBefore != Convert.ToDecimal(quantityAfter))
                {
                    ProductSettlement productSettlement = new ProductSettlement
                    {
                        ProductId = Convert.ToInt32(row.Cells[0].Text),
                        QuantityBefore = Convert.ToDecimal(quantityBefore),
                        QuantityAfter = Convert.ToDecimal(quantityAfter)
                    };
                    productsSettlement.Add(productSettlement);
                }
            }

            foreach (GridViewRow row in GridViewMotors.Rows)
            {
                quantityBefore = Convert.ToDecimal(row.Cells[5].Text);
                quantityAfter = ((TextBox)row.FindControl("txtQuantity")).Text;

                if (!string.IsNullOrEmpty(quantityAfter) && quantityBefore != Convert.ToDecimal(quantityAfter))
                {
                    ProductSettlement productSettlement = new ProductSettlement
                    {
                        ProductId = Convert.ToInt32(row.Cells[0].Text),
                        QuantityBefore = Convert.ToDecimal(quantityBefore),
                        QuantityAfter = Convert.ToDecimal(quantityAfter)
                    };
                    productsSettlement.Add(productSettlement);
                }
            }

            foreach (GridViewRow row in GridViewTol.Rows)
            {
                quantityBefore = Convert.ToDecimal(row.Cells[6].Text);
                quantityAfter = ((TextBox)row.FindControl("txtQuantity")).Text;

                if (!string.IsNullOrEmpty(quantityAfter) && quantityBefore != Convert.ToDecimal(quantityAfter))
                {
                    ProductSettlement productSettlement = new ProductSettlement
                    {
                        ProductId = Convert.ToInt32(row.Cells[0].Text),
                        QuantityBefore = Convert.ToDecimal(quantityBefore),
                        QuantityAfter = Convert.ToDecimal(quantityAfter)
                    };
                    productsSettlement.Add(productSettlement);
                }
            }

            if (productsSettlement.Any())
            {
                ProductSettlement productSettlement = new ProductSettlement();

                string msg = "";
                if (productSettlement.AddSettlement(out msg, productsSettlement))
                {
                    ViewState["Products"] = Products.Where(p => !productsSettlement.Select(c => c.ProductId).Contains(p.Id)).ToList();
                    BindGridViews();
                }
            }
        }

        private void BindGridViews()
        {
            GridViewProducts.DataSource = Products.Where(p => p.ClassificationName == "منتجات عادية");
            GridViewProducts.DataBind();

            GridViewMotors.DataSource = Products.Where(p => p.ClassificationName == "مواتير");
            GridViewMotors.DataBind();

            GridViewTol.DataSource = Products.Where(p => p.ClassificationName == "طلمبيات");
            GridViewTol.DataBind();
        }
    }
}