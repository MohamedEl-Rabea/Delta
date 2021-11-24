using Business_Logic;
using System;
using System.Globalization;

namespace DeltaProject
{
    public partial class Add_Client_Offer : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void BtnAdd_OnClickAdd_Click(object sender, EventArgs e)
        {
            var indexOfDot = fileUpload.FileName.IndexOf('.');
            var extension = fileUpload.FileName.Substring(indexOfDot, fileUpload.FileName.Length - indexOfDot);
            var fileName = $"{fileUpload.FileName.Replace(extension, "")}-{Guid.NewGuid()}{extension}";
            var filePath = $"{Server.MapPath("~/Files/")}{fileName}";
            fileUpload.SaveAs(filePath);

            ClientOffer clientOffer = new ClientOffer();
            clientOffer.ClientName = txtClientName.Text;
            clientOffer.Name = txtName.Text;
            clientOffer.Date = DateTime.ParseExact(txtDate.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
            clientOffer.Notes = txtNotes.Text;
            clientOffer.FileName = fileName;

            if (!clientOffer.Add())
            {
                lblAddedMsg.Text = "هناك مشكلة في الحفظ برجاء اعادة المحاولة";
                lblAddedMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblAddedMsg.Text = "تم بنجاح";
                lblAddedMsg.ForeColor = System.Drawing.Color.Green;
                txtClientName.Text = string.Empty;
                txtName.Text = string.Empty;
                txtDate.Text = string.Empty;
                txtNotes.Text = string.Empty;
                fileUpload.Dispose();
            }
        }
    }
}