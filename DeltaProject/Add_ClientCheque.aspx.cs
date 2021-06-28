using Business_Logic;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

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
            DateTime dueDate = Convert.ToDateTime(DueDate.Text);
            dueDate = new DateTime(dueDate.Year, dueDate.Month, dueDate.Day, DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);
            clientCheque.DueDate = dueDate;
            clientCheque.Value = Convert.ToDecimal(txtboxChequeValue.Text);
            clientCheque.ChequeNumber = txtChequeNumber.Text;
            clientCheque.AlertBefore = Convert.ToInt32(txtboxAlertBefore.Text);
            if (!clientCheque.Create(clientCheque))
            {
                lblFinishMsg.Text = "هناك مشكلة في الحفظ برجاء اعادة المحاولة";
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