using Business_Logic;
using DeltaProject.Business_Logic;
using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class AddSupplierPayment : Page
    {
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

        protected void RadioButtonListCategories_SelectedIndexChanged(object sender, EventArgs e)
        {
            PanelSupplierData.Visible = false;
            PanelPayment.Visible = false;
            PanelErrorMessage.Visible = false;
            ddlSuppliers.SelectedIndex = 0;
            txtPhoneNumber.Text = "";
            if (RadioButtonListCategories.SelectedIndex == 0)
            {
                ddlSuppliers.Visible = true;
                txtPhoneNumber.Visible = false;
            }
            else
            {
                ddlSuppliers.Visible = false;
                txtPhoneNumber.Visible = true;
            }
        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            PanelSupplierData.Visible = false;
            PanelErrorMessage.Visible = false;

            int id = Convert.ToInt32(ddlSuppliers.SelectedValue);
            string phoneNumber = txtPhoneNumber.Text;

            if ((ddlSuppliers.Visible && id == 0) || (txtPhoneNumber.Visible && string.IsNullOrEmpty(phoneNumber)))
            {
                PanelErrorMessage.Visible = true;
                return;
            }

            var result = Supplier.GetRemainingBalance(id, phoneNumber);

            if (!result.Item1.HasValue)
            {
                PanelErrorMessage.Visible = true;
                return;
            }

            lblSupplierId.Value = result.Item2.ToString();
            lblSupplierName.Text = result.Item3;
            lnkStatement.Text = result.Item1.Value.ToString("0.##");
            PanelSupplierData.Visible = true;
            PanelPayment.Visible = result.Item1 > 0;
        }

        protected void btnPay_Click(object sender, EventArgs e)
        {
            var date = Convert.ToDateTime(txtPaymentDate.Text);
            var datetime = new DateTime(date.Year, date.Month, date.Day,
                DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);
            SupplierPayment supplierPayment = new SupplierPayment
            {
                SupplierId = Convert.ToInt32(ddlSuppliers.SelectedValue),
                PaidAmount = Convert.ToDecimal(txtPaidAmount.Text),
                Notes = txtNotes.Text,
                PaymentDate = datetime
            };

            var remainingBalance = supplierPayment.Pay(out string m);
            if (!remainingBalance.HasValue)
            {
                lblSaveMsg.Text = m;
                lblSaveMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                txtPaidAmount.Text = "";
                txtNotes.Text = "";
                lnkStatement.Text = remainingBalance.Value.ToString("0.##");
                PanelPayment.Visible = remainingBalance > 0;
                lblSaveMsg.Text = $"تم دفع مبلغ ({supplierPayment.PaidAmount}) للمورد ({lblSupplierName.Text}) بنجاح";
                lblSaveMsg.ForeColor = System.Drawing.Color.Green;
            }
        }

        protected void lnkStatement_OnClick(object sender, EventArgs e)
        {
            Response.Redirect(string.Format("~/Supplier_Statement.aspx?supplierId={0}", lblSupplierId.Value));
        }
    }
}