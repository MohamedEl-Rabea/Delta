using Business_Logic;
using DeltaProject.Business_Logic;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Unit = DeltaProject.Business_Logic.Unit;

namespace DeltaProject
{
    public partial class AddProduct : System.Web.UI.Page
    {
        private List<Unit> Units
        {
            get => ViewState["Units"] == null
                ? new List<Unit>()
                : (List<Unit>)ViewState["Units"];
            set => ViewState["Units"] = value;
        }
        private List<Unit> ProductUnits
        {
            get => ViewState["ProductUnits"] == null
                ? new List<Unit>()
                : (List<Unit>)ViewState["ProductUnits"];
            set => ViewState["ProductUnits"] = value;
        }
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
                FillDropDownList();
            }
        }

        protected void txtProductName_OnTextChanged(object sender, EventArgs e)
        {
            FillUnitsDropDownList();
            SelectClassification();
        }

        protected void ddlClassifications_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            txtMark.Text = "";
            txtInch.Text = "";
            txtStyle.Text = "";
            SetAttributePanelsVisibility();
        }

        protected void btnAddProduct_Click(object sender, EventArgs e)
        {
            NewProduct product = new NewProduct();
            product.Id = !string.IsNullOrEmpty(txtProductId.Text) ? Convert.ToInt32(txtProductId.Text) : 0;
            product.Name = txtProductName.Text;
            product.ClassificationId = Convert.ToInt32(ddlClassifications.SelectedValue);
            product.ClassificationName = ddlClassifications.SelectedItem.Text;
            product.Quantity = Convert.ToDecimal(txtQuantity.Text);
            product.UnitId = Convert.ToInt32(ddlUnits.SelectedValue);
            product.UnitName = ddlUnits.SelectedItem.Text;
            product.PurchasePrice = Convert.ToDecimal(txtPurchasePrice.Text);
            product.SellPrice = Convert.ToDecimal(txtSellPrice.Text);
            product.Description = txtDescription.Text;
            product.Factor = ProductUnits.FirstOrDefault(u => u.Id == product.UnitId)?.Factor;

            if (ddlClassifications.SelectedItem.Text == "مواتير")
            {
                product.Mark = txtMark.Text;
                product.Inch = Convert.ToDouble(txtInch.Text);
            }
            else if (ddlClassifications.SelectedItem.Text == "طلمبيات")
            {
                product.Mark = txtMark.Text;
                product.Inch = Convert.ToDouble(txtInch.Text);
                product.Style = txtStyle.Text;
            }

            if (!Products.Any())
            {
                List<NewProduct> products = new List<NewProduct>();
                products.Add(product);
                ViewState["Products"] = products;
                lblMsg.Text = "تم اضافة - " + product.Name + " - الى القائمة";
                lblMsg.ForeColor = System.Drawing.Color.Green;
            }
            else if (Products.Any(p => p.Name == product.Name))
            {
                lblMsg.Text = "هذ المنتج مسجل بالفعل فى القائمة";
                lblMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                Products.Add(product);
                lblMsg.Text = "تم اضافة - " + product.Name + " - الى القائمة";
                lblMsg.ForeColor = System.Drawing.Color.Green;
            }

            ResetProductPanel();
        }

        protected void GridViewProductsList_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int rowIndex = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer).RowIndex;

            if (e.CommandName == "Delete_Row")
            {
                Products.RemoveAt(rowIndex);
                lblMsg.Text = "تم مسح المنتج من القائمة ";
                lblMsg.ForeColor = System.Drawing.Color.Green;
                ProductsListBind();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            var date = Convert.ToDateTime(txtPurchaseDate.Text);
            var datetime = new DateTime(date.Year, date.Month, date.Day,
                DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);

            SupplierInvoice invoice = new SupplierInvoice
            {
                SupplierId = Convert.ToInt32(ddlSuppliers.SelectedValue),
                Date = datetime,
                Products = Products,
                PaidAmount = !string.IsNullOrEmpty(txtPaidAmount.Text) ? Convert.ToDecimal(txtPaidAmount.Text) : (decimal?)null
            };

            if (!Products.Any())
            {
                lblFinishMsg.Text = "لا توجد منتجات !";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblFinishMsg.Text = "";
                if (!invoice.AddInvoice(out var m))
                {
                    lblFinishMsg.Text = m;
                    lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    lblFinishMsg.Visible = true;
                    lblFinishMsg.Text = "تم الحفظ بنجاح";
                    lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                    btnSave.Enabled = false;
                    btnSave.BackColor = System.Drawing.Color.FromName("#aaa");
                    ImageButtonBackToAddProducts.Enabled = false;
                }
            }
        }


        protected void btnNext_Click(object sender, EventArgs e)
        {
            PanelAddSupplier.Visible = false;
            PanelAddProducts.Visible = true;
            PanelProductsList.Visible = false;
        }

        protected void btnBackToAddSupplier_Click(object sender, ImageClickEventArgs e)
        {
            PanelAddSupplier.Visible = true;
            PanelAddProducts.Visible = false;
            PanelProductsList.Visible = false;
        }

        protected void btnNextToProductsList_Click(object sender, EventArgs e)
        {
            PanelAddSupplier.Visible = false;
            PanelAddProducts.Visible = false;
            PanelProductsList.Visible = true;
            lblSupplierName.Text = ddlSuppliers.SelectedItem.Text;
            var purchase_Date = DateTime.ParseExact(lblPurchaseDate.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
            lblPurchaseDate.Text = purchase_Date.ToShortDateString();
            ProductsListBind();
        }

        protected void ImageButtonBackToAddProducts_Click(object sender, ImageClickEventArgs e)
        {
            PanelAddSupplier.Visible = false;
            PanelAddProducts.Visible = true;
            PanelProductsList.Visible = false;
        }


        private void FillDropDownList()
        {
            ViewState["Units"] = Unit.GetUnits();
            FillUnitsDropDownList();
            FillClassificationsDropDownList();
            FillSuppliersDropDownList();
        }

        private void FillSuppliersDropDownList()
        {
            ddlSuppliers.DataSource = Supplier.GetSuppliers();
            ddlSuppliers.DataBind();
            ddlSuppliers.Items.Insert(0, new ListItem("إختر مورد", ""));
            ddlSuppliers.SelectedIndex = 0;
        }

        private void FillClassificationsDropDownList()
        {
            ddlClassifications.DataSource = Classification.GetClassifications();
            ddlClassifications.DataBind();
            ddlClassifications.SelectedIndex = 0;
        }

        private void FillUnitsDropDownList()
        {
            var units = !string.IsNullOrEmpty(txtProductId.Text) ? Unit.GetProductUnits(Convert.ToInt32(txtProductId.Text)) : new List<Unit>();
            ViewState["ProductUnits"] = units.Any() ? units : null;
            ddlUnits.DataSource = units.Any() ? units : Units;
            ddlUnits.DataBind();
            ddlUnits.Items.Insert(0, new ListItem("إختر وحدة قياس", ""));
            ddlUnits.SelectedIndex = 0;
        }

        private void SetAttributePanelsVisibility()
        {
            if (ddlClassifications.SelectedItem.Text == "مواتير")
            {
                PanelClassificationMotors.Visible = true;
                PanelClassificationPumps.Visible = false;
            }
            else if (ddlClassifications.SelectedItem.Text == "طلمبيات")
            {
                PanelClassificationMotors.Visible = true;
                PanelClassificationPumps.Visible = true;
            }
            else
            {
                PanelClassificationMotors.Visible = false;
                PanelClassificationPumps.Visible = false;
            }
        }

        private void SelectClassification()
        {
            ClassificationDetails classificationDetails = Classification.GetProductClassificationDetails(txtProductName.Text);
            if (classificationDetails.Id != 0)
            {
                ddlClassifications.SelectedValue = classificationDetails.Id.ToString();
                txtMark.Text = classificationDetails.Mark;
                txtInch.Text = classificationDetails.Inch.ToString();
                txtStyle.Text = classificationDetails.Style;
            }
            else
                ddlClassifications.SelectedIndex = 0;

            SetAttributePanelsVisibility();
            ddlClassifications.Enabled = classificationDetails.Id == 0;
            txtMark.Enabled = classificationDetails.Id == 0;
            txtInch.Enabled = classificationDetails.Id == 0;
            txtStyle.Enabled = classificationDetails.Id == 0;
        }

        private void ResetProductPanel()
        {
            txtProductId.Text = "";
            txtProductName.Text = "";
            ddlClassifications.SelectedIndex = 0;
            ddlClassifications.Enabled = true;
            txtMark.Enabled = true;
            txtInch.Enabled = true;
            txtStyle.Enabled = true;
            PanelClassificationMotors.Visible = false;
            PanelClassificationPumps.Visible = false;
            txtPurchasePrice.Text = "";
            txtSellPrice.Text = "";
            txtQuantity.Text = "";
            FillUnitsDropDownList();
            txtDescription.Text = "";
            txtMark.Text = "";
            txtInch.Text = "";
            txtStyle.Text = "";
        }

        private void ProductsListBind()
        {
            GridViewProductsList.DataSource = Products;
            GridViewProductsList.DataBind();
            lblTotalCost.Text = Convert.ToDecimal(Products.Sum(c => (c.Quantity * c.PurchasePrice))).ToString("0.##");
        }
    }
}