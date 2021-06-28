using Business_Logic;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class Add_SupplierCheque : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void BtnFinish_Click(object sender, EventArgs e)
        {
            ViewState["S_Name"] = txtSupplier_Name.Text;
            SupplierCheque supplierCheque = new SupplierCheque();
            supplierCheque.SupplierName = txtSupplier_Name.Text;
            supplierCheque.Notes = txtNotes.Text;
            DateTime dueDate = Convert.ToDateTime(DueDate.Text);
            dueDate = new DateTime(dueDate.Year, dueDate.Month, dueDate.Day, DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);
            supplierCheque.DueDate = dueDate;
            supplierCheque.Value = Convert.ToDecimal(txtboxChequeValue.Text);
            supplierCheque.PaidOff = false;
            supplierCheque.ChequeNumber = txtChequeNumber.Text;
            supplierCheque.AlertBefore =Convert.ToInt32(txtboxAlertBefore.Text);
            if (!supplierCheque.Create(supplierCheque))
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