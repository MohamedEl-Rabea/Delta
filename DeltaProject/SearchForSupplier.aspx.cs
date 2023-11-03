using Business_Logic;
using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class SearchForSupplier : System.Web.UI.Page
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

            Supplier supplier = new Supplier();
            int id = Convert.ToInt32(ddlSuppliers.SelectedValue);
            string phoneNumber = txtPhoneNumber.Text;

            if ((ddlSuppliers.Visible && id == 0) || (txtPhoneNumber.Visible && string.IsNullOrEmpty(phoneNumber)))
            {
                PanelErrorMessage.Visible = true;
                return;
            }

            supplier = supplier.GetSupplierData(id, phoneNumber);
            lblSupplierName.Text = supplier.Name;

            if (supplier.Id == 0)
            {
                PanelErrorMessage.Visible = true;
                return;
            }

            PanelSupplierData.Visible = true;
            lblAddress.Text = supplier.Address;
            lblAccountNumber.Text = supplier.Account_Number;
            GridViewPhones.DataSource = supplier.Phones;
            GridViewPhones.DataBind();
            GridViewFaxs.DataSource = supplier.Faxes;
            GridViewFaxs.DataBind();
        }
    }
}