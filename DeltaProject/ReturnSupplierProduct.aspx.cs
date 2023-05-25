using Business_Logic;
using DeltaProject.Business_Logic;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class ReturnSupplierProduct : System.Web.UI.Page
    {
        private List<SupplierInvoice> Invoices
        {
            get => ViewState["Invoices"] == null
                ? new List<SupplierInvoice>()
                : (List<SupplierInvoice>)ViewState["Invoices"];
            set => ViewState["Invoices"] = value;
        }
        private int? InvoiceId
        {
            get => (int?)ViewState["InvoiceId"];
            set => ViewState["InvoiceId"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ddlSuppliers.DataSource = Supplier.GetSuppliers();
                ddlSuppliers.DataBind();
                ddlSuppliers.Items.Insert(0, new ListItem("إختر مورد", "0"));
                ddlSuppliers.SelectedIndex = 0;
            }
        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            lblMsg.Text = "";
            lblMsg.ForeColor = System.Drawing.Color.Green;
            PanelProducts.Visible = false;

            var supplierId = Convert.ToInt32(ddlSuppliers.SelectedValue);
            var productId = Convert.ToInt32(txtProductId.Text);
            if (supplierId == 0 && productId == 0)
            {
                lblMsg.Text = "اختر مورد او منتج";
                lblMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                PanelInvoices.Visible = true;
                ViewState["Invoices"] = SupplierInvoice.GetInvoicesToReturn(supplierId, productId);
                GridViewInvoices.DataSource = Invoices;
                GridViewInvoices.DataBind();
            }
        }

        protected void GridViewInvoices_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Select")
            {
                lblMsg.Text = "";
                PanelInvoices.Visible = false;
                PanelProducts.Visible = true;
                var gridRow = (GridViewRow)((LinkButton)e.CommandSource).NamingContainer;
                ViewState["InvoiceId"] = Convert.ToInt32(gridRow.Cells[0].Text);
                GridViewProducts.DataSource = Invoices.FirstOrDefault(p => p.Id == InvoiceId)?.Products;
                GridViewProducts.DataBind();
            }
        }

        protected void btnReturn_OnClick(object sender, EventArgs e)
        {
            var gridRow = (GridViewRow)((Button)sender).NamingContainer;
            int rowIndex = gridRow.RowIndex;

            if (InvoiceId != null)
            {
                var returnDate = Convert.ToDateTime(((TextBox)GridViewProducts.Rows[rowIndex].FindControl("txtReturnDate")).Text);
                var returnedQuantity = Convert.ToDecimal(((TextBox)GridViewProducts.Rows[rowIndex].FindControl("txtReturnedQuantity")).Text);
                SupplierInvoice supplierInvoice = new SupplierInvoice
                {
                    Id = InvoiceId.Value,
                    Date = new DateTime(returnDate.Year, returnDate.Month, returnDate.Day,
                        DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second)
                };

                supplierInvoice.Products.Add(new NewProduct
                {
                    Id = Convert.ToInt32(gridRow.Cells[0].Text),
                    Name = gridRow.Cells[1].Text,
                    Quantity = returnedQuantity
                });

                if (!supplierInvoice.ReturnProduct(out var m))
                {
                    lblMsg.Text = m;
                    lblMsg.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    ImageButtonSearch_Click(sender, null);
                    lblMsg.Visible = true;
                    lblMsg.Text = $"تم ارجاع ({returnedQuantity}) ({gridRow.Cells[1].Text}) من الفاتوره رقم ({InvoiceId}) بنجاح";
                    lblMsg.ForeColor = System.Drawing.Color.Green;
                }
            }
        }

        protected void ddlSuppliers_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            lblMsg.Text = "";
            lblMsg.ForeColor = System.Drawing.Color.Green;
            PanelInvoices.Visible = false;
            PanelProducts.Visible = false;
        }
    }
}
