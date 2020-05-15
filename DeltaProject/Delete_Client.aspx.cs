using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;

namespace DeltaProject
{
    public partial class Delete_Client : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            lblFinishMsg.Text = "";
            Client client = new Client();
            client.C_name = TextBoxSearch.Text;
            client = client.Get_Client_info();
            if (string.IsNullOrEmpty(client.C_name))
            {
                PanelErrorMessage.Visible = true;
                PanelClientInfo.Visible = false;
            }
            else
            {
                PanelClientInfo.Visible = true;
                PanelErrorMessage.Visible = false;
                lblClientName.Text = client.C_name;
                lblAddress.Text = client.Address;
                lblAccountNumber.Text = client.Account_Number;
            }
        }

        protected void BtnDelete_Click(object sender, EventArgs e)
        {
            Client client = new Client();
            client.C_name = lblClientName.Text;
            string m;
            if (!client.Delete_Client(out m))
            {
                lblFinishMsg.Text = m;
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblFinishMsg.Text = "تم بنجاح";
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
            }
        }
    }
}