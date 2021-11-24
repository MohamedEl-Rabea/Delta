using Business_Logic;
using System;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class ClientOffers : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ReboundGridView();
            }
        }

        private void ReboundGridView()
        {
            var clientName = txtClientName.Text;
            GridViewAllClientsOffers.DataSource = ClientOffer.GetClientOffersByClientName(clientName);
            GridViewAllClientsOffers.DataBind();
        }

        protected void GridViewAllClientsOffers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            var clientName = txtClientName.Text;
            var selectedRow = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer);

            var fileName = ((Label)selectedRow.FindControl("lblFileName")).Text;
            var filePath = $"{Server.MapPath("~/Files/")}{fileName}";

            if (e.CommandName == "Delete_Row")
            {
                var id = selectedRow.RowType == DataControlRowType.DataRow
                    ? Convert.ToInt32(GridViewAllClientsOffers.DataKeys[selectedRow.RowIndex].Value)
                    : 0;

                ClientOffer clientOffer = new ClientOffer { Id = id };
                if (!clientOffer.Delete(out string msg))
                {
                    lblFinishMsg.Text = msg;
                    lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    if (File.Exists(filePath))
                        File.Delete(filePath);
                    lblFinishMsg.Text = $"تم مسح عرض : '{selectedRow.Cells[1].Text}' للعميل {clientName} بنجاح";
                    lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                    ReboundGridView();
                }
                ;
            }
            else if (e.CommandName == "Download_File")
            {
                if (File.Exists(filePath))
                {
                    FileInfo file = new FileInfo(filePath);

                    Response.AddHeader("content-disposition", "attachment; filename=" + file.Name);
                    Response.AddHeader("Content-Length", filePath.Length.ToString());
                    Response.ContentType = "application/octet-stream";
                    Response.WriteFile(file.FullName);
                    Response.End();
                }
                else
                {
                    lblFinishMsg.Text = "هذا الملف غير موجود";
                }
            }
        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            if (txtClientName.Visible)
            {
                ReboundGridView();
            }

        }
    }
}