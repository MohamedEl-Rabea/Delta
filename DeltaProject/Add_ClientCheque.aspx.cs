using Business_Logic;
using System;

namespace DeltaProject
{
    public partial class Add_ClientCheque : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void BtnFinish_Click(object sender, EventArgs e)
        {
            ViewState["S_Name"] = txtClient_Name.Text;
            ClientCheque clientCheque = new ClientCheque();
            clientCheque.ClientName = txtClient_Name.Text;
            clientCheque.Notes = txtNotes.Text;
            clientCheque.DueDate = Convert.ToDateTime(DueDate.Text);
            clientCheque.Value = Convert.ToDecimal(txtboxChequeValue.Text);
            clientCheque.ChequeNumber = txtChequeNumber.Text;
            clientCheque.AlertBefore = Convert.ToInt32(txtboxAlertBefore.Text);
            if (!clientCheque.Save())
            {
                lblFinishMsg.Text = "هناك مشكلة في الحفظ برجاء اعادة المحاولة";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblFinishMsg.Text = "تم بنجاح";
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                txtClient_Name.Text = string.Empty;
                txtNotes.Text = string.Empty;
                txtboxChequeValue.Text = string.Empty;
                txtChequeNumber.Text = string.Empty;
                DueDate.Text = string.Empty;
            }
        }
    }
}