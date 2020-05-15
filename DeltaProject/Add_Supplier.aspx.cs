using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;

namespace DeltaProject
{
    public partial class Add_Supplier : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Update_Supplier_Info previouspage = (Update_Supplier_Info)this.Page.PreviousPage;
                if (previouspage != null)
                {
                    ViewState["Supplier_Name"] = previouspage.Supplier_Name;
                    PanelAddSupplier.Visible = false;
                    PanelContacts.Visible = true;
                }
            }
        }

        protected void BtnFinish_Click(object sender, EventArgs e)
        {
            ViewState["S_Name"] = txtSupplier_Name.Text;
            Supplier supplier = new Supplier();
            supplier.S_name = txtSupplier_Name.Text;
            supplier.Address = txtAddress.Text;
            supplier.Account_Number = txtAccount_Number.Text;
            string m = "";
            if (!supplier.Add_Supplier(out m))
            {
                lblFinishMsg.Text = m;
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                lnkBtnContacts.Visible = false;
            }
            else
            {
                lblFinishMsg.Text = "تم بنجاح";
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                lnkBtnContacts.Visible = true;
            }
        }

        protected void lnkBtnContacts_Click(object sender, EventArgs e)
        {
            PanelAddSupplier.Visible = false;
            PanelContacts.Visible = true;
        }

        protected void BtnAdd_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(txtPhone.Text))
            {
                Supplier_Phone sph = new Supplier_Phone();
                sph.Phone = txtPhone.Text;
                sph.S_name = ViewState["Supplier_Name"] == null ? ViewState["S_Name"].ToString() : ViewState["Supplier_Name"].ToString();
                string m = "";
                if (!sph.Add_Supplier_Phones(out m))
                {
                    lblPhoneMsg.Text = m;
                    lblPhoneMsg.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    lblPhoneMsg.Text = "تم بنجاح";
                    lblPhoneMsg.ForeColor = System.Drawing.Color.Green;
                }
            }
            if (!string.IsNullOrEmpty(txtFax.Text))
            {
                Supplier_Fax sfx = new Supplier_Fax();
                sfx.Fax = txtFax.Text;
                sfx.S_name = ViewState["Supplier_Name"] == null ? ViewState["S_Name"].ToString() : ViewState["Supplier_Name"].ToString();
                string m = "";
                if (!sfx.Add_Supplier_Faxs(out m))
                {
                    lblFaxMsg.Text = m;
                    lblFaxMsg.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    lblFaxMsg.Text = "تم بنجاح";
                    lblFaxMsg.ForeColor = System.Drawing.Color.Green;
                }
            }
        }
    }
}