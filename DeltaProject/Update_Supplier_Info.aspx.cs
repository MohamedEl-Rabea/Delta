using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;

namespace DeltaProject
{
    public partial class Update_Supplier_Info : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            lblContactsMsg.Text = "";
            lblFinishMsg.Text = "";
            Supplier supplier = new Supplier();
            double Debts;
            supplier.S_name = TextBoxSearch.Text;
            supplier = supplier.Get_Supplier_info(out Debts);
            if (string.IsNullOrEmpty(supplier.S_name))
            {
                // display error panel
                PanelErrorMessage.Visible = true;
                // hide result panel
                PaenlSupplierInfo.Visible = false;
            }
            else
            {
                ViewState["S_Name"] = supplier.S_name;
                PaenlSupplierInfo.Visible = true;
                PanelErrorMessage.Visible = false;
                txtSupplier_Name.Text = supplier.S_name;
                txtAddress.Text = supplier.Address;
                txtAccount_Number.Text = supplier.Account_Number;

                BindPhones(supplier.S_name);
                BindFaxs(supplier.S_name);
            }
        }

        private void BindFaxs(string supplier)
        {
            GridViewFaxs.DataSource = Supplier_Fax.Get_Supplier_Faxs(supplier);
            GridViewFaxs.DataBind();
        }

        private void BindPhones(string supplier)
        {
            GridViewPhones.DataSource = Supplier_Phone.Get_Supplier_Phones(supplier);
            GridViewPhones.DataBind();
        }

        protected void BtnFinish_Click(object sender, EventArgs e)
        {
            Supplier supplier = new Supplier();
            supplier.S_name = txtSupplier_Name.Text;
            supplier.Address = txtAddress.Text;
            supplier.Account_Number = txtAccount_Number.Text;
            string Old_Name = ViewState["S_Name"].ToString(), m = "";
            if (!supplier.Update_Supplier_Info(out m, Old_Name))
            {
                lblFinishMsg.Text = m;
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblFinishMsg.Text = "تم بنجاح";
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                ViewState["S_Name"] = supplier.S_name;
            }
        }

        protected void GridViewPhones_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            lblContactsMsg.Text = "";
            if (e.CommandName == "Edit_Row")
            {
                int row_index = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer).RowIndex;
                ViewState["old_phone"] = ((Label)GridViewPhones.Rows[row_index].FindControl("lblPhone")).Text;
                GridViewPhones.EditIndex = row_index;
                BindPhones(ViewState["S_Name"].ToString());
            }
            else if (e.CommandName == "Cancel_Update")
            {
                GridViewPhones.EditIndex = -1;
                BindPhones(ViewState["S_Name"].ToString());
            }
            else if (e.CommandName == "Confirm_Update")
            {
                int row_index = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer).RowIndex;
                Supplier_Phone phone = new Supplier_Phone();
                phone.Phone = ((TextBox)GridViewPhones.Rows[row_index].FindControl("txtPhone")).Text;
                phone.S_name = ViewState["S_Name"].ToString();
                string old_phone = ViewState["old_phone"].ToString(), m = "";
                if (!phone.Update_Supplier_Phone(out m, old_phone))
                {
                    lblContactsMsg.Text = m;
                    lblContactsMsg.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    lblContactsMsg.Text = "تم تحديث الهاتف بنجاح";
                    lblContactsMsg.ForeColor = System.Drawing.Color.Green;
                }
                GridViewPhones.EditIndex = -1;
                BindPhones(ViewState["S_Name"].ToString());
            }
            else if (e.CommandName == "Delete_Row")
            {
                int row_index = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer).RowIndex;
                Supplier_Phone phone = new Supplier_Phone();
                phone.Phone = ((Label)GridViewPhones.Rows[row_index].FindControl("lblPhone")).Text;
                phone.S_name = ViewState["S_Name"].ToString();
                string m = "";
                if (!phone.Delete_Supplier_Phone(out m))
                {
                    lblContactsMsg.Text = m;
                    lblContactsMsg.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    lblContactsMsg.Text = "تم مسح الهاتف ";
                    lblContactsMsg.ForeColor = System.Drawing.Color.Green;
                }
                BindPhones(ViewState["S_Name"].ToString());
            }
        }

        protected void GridViewFaxs_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            lblContactsMsg.Text = "";
            if (e.CommandName == "Edit_Row")
            {
                int row_index = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer).RowIndex;
                ViewState["old_fax"] = ((Label)GridViewFaxs.Rows[row_index].FindControl("lblFax")).Text;
                GridViewFaxs.EditIndex = row_index;
                BindFaxs(ViewState["S_Name"].ToString());
            }
            else if (e.CommandName == "Cancel_Update")
            {
                GridViewFaxs.EditIndex = -1;
                BindFaxs(ViewState["S_Name"].ToString());
            }
            else if (e.CommandName == "Confirm_Update")
            {
                int row_index = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer).RowIndex;
                Supplier_Fax fax = new Supplier_Fax();
                fax.Fax = ((TextBox)GridViewFaxs.Rows[row_index].FindControl("txtFax")).Text;
                fax.S_name = ViewState["S_Name"].ToString();
                string old_Fax = ViewState["old_fax"].ToString(), m = "";
                if (!fax.Update_Supplier_Fax(out m, old_Fax))
                {
                    lblContactsMsg.Text = m;
                    lblContactsMsg.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    lblContactsMsg.Text = "تم تحديث الفاكس بنجاح";
                    lblContactsMsg.ForeColor = System.Drawing.Color.Green;
                }
                GridViewFaxs.EditIndex = -1;
                BindFaxs(ViewState["S_Name"].ToString());
            }
            else if (e.CommandName == "Delete_Row")
            {
                int row_index = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer).RowIndex;
                Supplier_Fax fax = new Supplier_Fax();
                fax.Fax = ((Label)GridViewFaxs.Rows[row_index].FindControl("lblFax")).Text;
                fax.S_name = ViewState["S_Name"].ToString();
                string m = "";
                if (!fax.Delete_Supplier_Fax(out m))
                {
                    lblContactsMsg.Text = m;
                    lblContactsMsg.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    lblContactsMsg.Text = "تم مسح الفاكس ";
                    lblContactsMsg.ForeColor = System.Drawing.Color.Green;
                }
                BindFaxs(ViewState["S_Name"].ToString());
            }
        }

        protected void lnkBtnContacts_Click(object sender, EventArgs e)
        {
            Server.Transfer("~/Add_Supplier.aspx", false);
        }

        public string Supplier_Name
        {
            get 
            {
                return txtSupplier_Name.Text;
            }
        }
    }
}