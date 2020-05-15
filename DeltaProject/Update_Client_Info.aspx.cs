using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;

namespace DeltaProject
{
    public partial class Update_Client_Info : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            lblContactsMsg.Text = "";
            lblFinishMsg.Text = "";
            lblPhoneMsg.Text = "";
            PanelContacts.Visible = false;
            Client client = new Client();
            client.C_name = TextBoxSearch.Text;
            client = client.Get_Client_info();
            if (string.IsNullOrEmpty(client.C_name))
            {
                // display error panel
                PanelErrorMessage.Visible = true;
                // hide result panel
                PanelClientInfo.Visible = false;
            }
            else
            {
                ViewState["C_Name"] = client.C_name;
                PanelClientInfo.Visible = true;
                PanelErrorMessage.Visible = false;
                txtClient_Name.Text = client.C_name;
                txtAddress.Text = client.Address;
                txtAccount_Number.Text = client.Account_Number;
                BindPhones(client.C_name);
            }
        }
        private void BindPhones(string client)
        {
            GridViewPhones.DataSource = Client_Phone.Get_Client_Phones(client);
            GridViewPhones.DataBind();
        }

        protected void BtnFinish_Click(object sender, EventArgs e)
        {
            Client client = new Client();
            client.C_name = txtClient_Name.Text;
            client.Address = txtAddress.Text;
            client.Account_Number = txtAccount_Number.Text;
            string Old_Name = ViewState["C_Name"].ToString(), m = "";
            if (!client.Update_Client_Info(out m, Old_Name))
            {
                lblFinishMsg.Text = m;
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblFinishMsg.Text = "تم بنجاح";
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                ViewState["C_Name"] = client.C_name;
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
                BindPhones(ViewState["C_Name"].ToString());
            }
            else if (e.CommandName == "Cancel_Update")
            {
                GridViewPhones.EditIndex = -1;
                BindPhones(ViewState["C_Name"].ToString());
            }
            else if (e.CommandName == "Confirm_Update")
            {
                int row_index = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer).RowIndex;
                Client_Phone phone = new Client_Phone();
                phone.Phone = ((TextBox)GridViewPhones.Rows[row_index].FindControl("txtPhone")).Text;
                phone.C_name = ViewState["C_Name"].ToString();
                string old_phone = ViewState["old_phone"].ToString(), m = "";
                if (!phone.Update_Client_Phone(out m, old_phone))
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
                BindPhones(ViewState["C_Name"].ToString());
            }
            else if (e.CommandName == "Delete_Row")
            {
                int row_index = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer).RowIndex;
                Client_Phone phone = new Client_Phone();
                phone.Phone = ((Label)GridViewPhones.Rows[row_index].FindControl("lblPhone")).Text;
                phone.C_name = ViewState["C_Name"].ToString();
                string m = "";
                if (!phone.Delete_Client_Phone(out m))
                {
                    lblContactsMsg.Text = m;
                    lblContactsMsg.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    lblContactsMsg.Text = "تم مسح الهاتف ";
                    lblContactsMsg.ForeColor = System.Drawing.Color.Green;
                }
                BindPhones(ViewState["C_Name"].ToString());
            }
        }

        protected void lnkBtnContacts_Click(object sender, EventArgs e)
        {
            PanelContacts.Visible = true;
            PanelErrorMessage.Visible = false;
            PanelClientInfo.Visible = false;
        }

        protected void BtnAdd_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(txtPhone.Text))
            {
                Client_Phone cph = new Client_Phone();
                cph.Phone = txtPhone.Text;
                cph.C_name = ViewState["C_Name"].ToString();
                string m = "";
                if (!cph.Add_Client_Phones(out m))
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
        }
    }
}