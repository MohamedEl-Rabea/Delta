﻿using Business_Logic;
using System;

namespace DeltaProject
{
    public partial class Add_SupplierCheque : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DueDate.Text =  DateTime.Today.ToString("dd/MM/yyyy");
        }

        protected void BtnFinish_Click(object sender, EventArgs e)
        {
            ViewState["S_Name"] = txtSupplier_Name.Text;
            SupplierCheque supplierCheque = new SupplierCheque();
            supplierCheque.SupplierName = txtSupplier_Name.Text;
            supplierCheque.Notes = txtNotes.Text;
            var dueDate = Convert.ToDateTime(DueDate.Text);
            var sqlFormattedDate = dueDate.Date.ToString("yyyy-dd-MM HH:mm:ss");
            supplierCheque.DueDate = Convert.ToDateTime(sqlFormattedDate);
            supplierCheque.Value = Convert.ToDecimal(txtboxChequeValue.Text);
            supplierCheque.PaidOff = false;
            supplierCheque.ChequeNumber = txtChequeNumber.Text;
            supplierCheque.AlertBefore =Convert.ToInt32(txtboxAlertBefore.Text);
            if (!supplierCheque.Create())
            {
                lblFinishMsg.Text = "هناك مشكلة في الحفظ برجاء اعادة المحاولة";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblFinishMsg.Text = "تم بنجاح";
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                Session["SupplierChequesCount"] = SupplierCheque.GetUpcomingPayableSupplierChequesCount();
                Response.Redirect(Request.RawUrl);
                txtSupplier_Name.Text = string.Empty;
                txtNotes.Text = string.Empty;
                txtboxChequeValue.Text = string.Empty;
                txtChequeNumber.Text = string.Empty;
                DueDate.Text = string.Empty;
            }
        }
    }
}