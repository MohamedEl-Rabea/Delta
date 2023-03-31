using Business_Logic;
using DeltaProject.Business_Logic;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class CreateOrder : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void BtnNext_Click(object sender, EventArgs e)
        {
            PanelOrderBasicInfo.Visible = false;
            PanelOrderDetails.Visible = true;
            PanelProductList.Visible = false;
        }

        protected void RadioButtonListCategories_SelectedIndexChanged(object sender, EventArgs e)
        {
            lblFinishMsg.Visible = false;
            if (RadioButtonListCategories.SelectedValue == "Products")
            {
                PanelProductSearchEmpty();
                PanelProductSearch.Visible = true;
                PanelServiceSearch.Visible = false;
            }
            else if (RadioButtonListCategories.SelectedValue == "Services")
            {
                PanelServiceSearchEmpty();
                PanelProductSearch.Visible = false;
                PanelServiceSearch.Visible = true;
            }
        }

        protected void lnkBackToBasicDetails_OnClick(object sender, EventArgs eventArgs)
        {
            PanelOrderBasicInfo.Visible = true;
            PanelOrderDetails.Visible = false;
            PanelProductList.Visible = false;
        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            lblFinishMsg.Visible = false;
            GridViewProducts.Visible = true;
            GridViewProducts.DataSource = Product.GetProducts(txtProductName.Text);
            GridViewProducts.DataBind();
        }

        protected void btnAddProduct_OnClick(object sender, EventArgs e)
        {
            lblFinishMsg.Visible = false;

            int row_index = ((GridViewRow)((Button)sender).NamingContainer).RowIndex;
            string amount = ((TextBox)GridViewProducts.Rows[row_index].FindControl("txtAmount")).Text;

            Product product = new Product();

            product.P_name = GridViewProducts.Rows[row_index].Cells[0].Text;

            if (ViewState["ProductsList"] != null && ((List<Product>)ViewState["ProductsList"]).Contains(product))
            {
                lblFinishMsg.Visible = true;
                lblFinishMsg.Text = "! هذا المنتج مسجل فى القائمة";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {

                product.Amount = Convert.ToDecimal(amount);
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
                PanelProductSearchEmpty();
                BindList();
            }
        }

        protected void btnAddService_OnClick(object sender, EventArgs e)
        {
            lblFinishMsg.Visible = false;

            Product product = new Product();

            product.P_name = txtServiceName.Text;
            product.IsFreeItem = true;

            if (ViewState["ProductsList"] != null && ((List<Product>)ViewState["ProductsList"]).Contains(product))
            {
                lblFinishMsg.Visible = true;
                lblFinishMsg.Text = "! هذا المنتج مسجل فى القائمة";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                product.Amount = Convert.ToDecimal(txtServiceAmount.Text);

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
                PanelServiceSearchEmpty();
                BindList();
            }
        }

        protected void GridViewProductsList_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Delete_Row")
            {
                int row_index = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer).RowIndex;
                string P_name = GridViewProductsList.Rows[row_index].Cells[0].Text;
                if (P_name.Contains("-"))
                {
                    P_name = P_name.Substring(0, P_name.IndexOf('-'));
                }
                int index = ((List<Product>)ViewState["ProductsList"]).FindIndex(product => product.P_name == P_name);
                ((List<Product>)ViewState["ProductsList"]).RemoveAt(index);
                BindList();
            }
        }

        protected void btnFinish_OnClick(object sender, EventArgs e)
        {
            PanelAddOrder.Visible = false;
            PanelPreview.Visible = true;
            lblClientName.Text = txtClientName.Text;
            lblPhoneNumber.Text = txtPhoneNumber.Text;
            lblDeliveryDate.Text = DeliveryDate.Text;

            GridViewPreviewProductList.DataSource = (List<Product>)ViewState["ProductsList"];
            GridViewPreviewProductList.DataBind();
        }

        protected void btnSave_OnClick(object sender, EventArgs e)
        {
            btnSave.Enabled = false;

            var deliveryDate = Convert.ToDateTime(lblDeliveryDate.Text);
            Order order = new Order
            {
                ClientName = lblClientName.Text,
                PhoneNumber = lblPhoneNumber.Text,
                DeliveryDate = new DateTime(deliveryDate.Year, deliveryDate.Month, deliveryDate.Day,
                    DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second),
                OrderDetails = ((List<Product>)ViewState["ProductsList"]).Select(p => new OrderDetails
                {
                    ProductName = p.P_name,
                    Amount = p.Amount
                })
            };

            string msg = "";
            if (!order.AddOrder(out msg))
            {
                lblFinishMsg.Text = "هناك مشكلة في الحفظ برجاء اعادة المحاولة";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                lblFinishMsg.Visible = true;
                btnSave.Enabled = true;
            }
            else
            {
                lblFinishMsg.Text = $"تم حفظ الطلبيه  للعميل ({order.ClientName}) بنجاح";
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                lblFinishMsg.Visible = true;
                btnSave.BackColor = System.Drawing.Color.FromName("#aaa");
            }
        }


        private void PanelServiceSearchEmpty()
        {
            txtServiceName.Text = "";
            txtServiceAmount.Text = "";
        }

        private void PanelProductSearchEmpty()
        {
            txtProductName.Text = "";
            GridViewProducts.Visible = false;
        }

        private void BindList()
        {
            if (ViewState["ProductsList"] != null && ((List<Product>)ViewState["ProductsList"]).Count > 0)
                PanelProductList.Visible = true;
            else
                PanelProductList.Visible = false;

            GridViewProductsList.DataSource = (List<Product>)ViewState["ProductsList"];
            GridViewProductsList.DataBind();
        }
    }
}