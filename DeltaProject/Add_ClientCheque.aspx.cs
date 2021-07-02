using Business_Logic;
using System;

namespace DeltaProject
{
    public partial class Add_ClientCheque : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DueDate.Text = DateTime.Today.ToString("dd/MM/yyyy");
        }

        protected void BtnFinish_Click(object sender, EventArgs e)
        {
            ViewState["S_Name"] = txtClient_Name.Text;
            ClientCheque clientCheque = new ClientCheque();
            clientCheque.ClientName = txtClient_Name.Text;
            clientCheque.Notes = txtNotes.Text;
            var dueDate = Convert.ToDateTime(DueDate.Text);
            var sqlFormattedDate = dueDate.Date.ToString("yyyy-dd-MM HH:mm:ss");
            clientCheque.DueDate = Convert.ToDateTime(sqlFormattedDate);
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
                Session["ClientChequesCount"] = ClientCheque.GetUpcomingPayableClientChequesCount();
                Response.Redirect(Request.RawUrl);
                txtClient_Name.Text = string.Empty;
                txtNotes.Text = string.Empty;
                txtboxChequeValue.Text = string.Empty;
                txtChequeNumber.Text = string.Empty;
                DueDate.Text = string.Empty;
            }
        }
    }
}