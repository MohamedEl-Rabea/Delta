using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;

namespace DeltaProject
{
    public partial class New_Supplier_Interaction : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void BtnFinish_Click(object sender, EventArgs e)
        {
            if (rblPaymentType.SelectedIndex > -1)
            {
                Supplier_Payment_Record record = new Supplier_Payment_Record();
                record.Paid_amount = rblPaymentType.SelectedValue == "ToSupplier" ? Convert.ToDouble(txtPaid_amount.Text) : -Convert.ToDouble(txtPaid_amount.Text);
                record.Pay_Date = new DateTime(Convert.ToInt32(txtYear.Text), Convert.ToInt32(txtMonth.Text), Convert.ToInt32(txtDay.Text), DateTime.Now.Hour,
                    DateTime.Now.Minute, DateTime.Now.Second);
                record.Notes = TxtNotes.Text;
                string supplier = txtSupplier_Name.Text;
                string m = "";
                if (!record.Add_Supplier_Payment(out m, supplier))
                {
                    lblFinishMsg.Text = m;
                    lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                    PanelLink.Visible = false;
                }
                else
                {
                    lblFinishMsg.Text = "تم بنجاح";
                    lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                    PanelLink.Visible = true;
                }
            }
            else
            {
                lblFinishMsg.Text = "يجب تحديد نوع العمليه اعلى الصفحه";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                PanelLink.Visible = false;
            }
        }

        protected void ButtonAdd_Image_Click(object sender, EventArgs e)
        {
            string Extention = System.IO.Path.GetExtension(FileUploadImages.FileName);
            if (Extention.ToLower() != ".jpg")
            {
                lblErrMsgImages.Text = " المسموح بها فقط ." + "-.jpg-" + " الملفات ذات الامتداد";
                lblErrMsgImages.ForeColor = System.Drawing.Color.Red;
                lblErrMsgImages.Visible = true;
            }
            else
            {
                Supplier_Payments_Documents doc = new Supplier_Payments_Documents();
                doc.Image = FileUploadImages.FileBytes;
                doc.Image_Date = new DateTime(Convert.ToInt32(txtYear.Text), Convert.ToInt32(txtMonth.Text), Convert.ToInt32(txtDay.Text));
                string Supplier_Name = txtSupplier_Name.Text;
                string m;
                if (!doc.Add_Supplier_Payment_Images(out m, Supplier_Name))
                {
                    lblErrMsgImages.Text = m;
                    lblErrMsgImages.ForeColor = System.Drawing.Color.Red;
                    lblErrMsgImages.Visible = true;
                }
                else
                {
                    lblErrMsgImages.Text = "تم اضافة الصورة";
                    lblErrMsgImages.ForeColor = System.Drawing.Color.Green;
                    lblErrMsgImages.Visible = true;
                }
            }
        }

        protected void lnkBtnContacts_Click(object sender, EventArgs e)
        {
            PanelAdd_Images.Visible = true;
            PanelPaymentInfo.Visible = false;
        }
    }
}