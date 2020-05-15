using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;

namespace DeltaProject
{
    public partial class Search_For_Client : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
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
                lblName.Text = client.C_name;
                lblAddress.Text = string.IsNullOrEmpty(client.Address) ? "لا يوجد" : client.Address;
                lblAccountNumber.Text = string.IsNullOrEmpty(client.Account_Number) ? "لا يوجد" : client.Account_Number;

                GridViewPhones.DataSource = Client_Phone.Get_Client_Phones(client.C_name);
                GridViewPhones.DataBind();
            }
        }
    }
}