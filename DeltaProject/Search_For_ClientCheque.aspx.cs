using Business_Logic;
using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class Search_For_ClientCheque : System.Web.UI.Page
    {
       
        protected void Page_Load(object sender, EventArgs e)
        {
            lnkBtnUpcomingPayableCientCheques.ForeColor = System.Drawing.Color.White;
            Session["ClientChequesCount"] = 0;
        }

        
        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            if (TextBoxSearch.Visible)
            {
                ClientCheque clientCheque = new ClientCheque();
                clientCheque.ClientName = TextBoxSearch.Text;
                if (string.IsNullOrEmpty(TextBoxSearch.Text))
                {
                    PanelClientCheques.Visible = false;
                    PanelErrorMessage.Visible = true;
                }
                else
                {
                    PanelClientCheques.Visible = true;
                    PanelErrorMessage.Visible = false;
                    PanelAllClientsCheques.Visible = false;
                    PanelPaidCientCheques.Visible = false;
                    PanelUnPaidCientCheques.Visible = false;
                    PanelUpcomingPayableClientCheques.Visible = true;
                    lnkBtnPaidCientCheques.ForeColor = System.Drawing.Color.Black;
                    lnkBtnUnpaidCientCheques.ForeColor = System.Drawing.Color.Black;
                    lnkBtnUpcomingPayableCientCheques.ForeColor = System.Drawing.Color.White;
                    GridViewPaidCientCheques.PageIndex = 0;
                }
            }
            
        }

        protected void lnkBtnAllClientsCheceques_Click(object sender, EventArgs e)
        {
            PanelAllClientsCheques.Visible = true;
            PanelUnPaidCientCheques.Visible = false;
            PanelPaidCientCheques.Visible = false;
            PanelUpcomingPayableClientCheques.Visible = false;
            lnkBtnAllClientsCheceques.ForeColor = System.Drawing.Color.White;
            lnkBtnUnpaidCientCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnUpcomingPayableCientCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnPaidCientCheques.ForeColor = System.Drawing.Color.Black;
            GridViewAllClientsCheques.DataBind();
            GridViewAllClientsCheques.PageIndex = 0;
        }

        protected void lnkBtnPaidCientCheques_Click(object sender, EventArgs e)
        {
            PanelPaidCientCheques.Visible = true;
            PanelUnPaidCientCheques.Visible = false;
            PanelUpcomingPayableClientCheques.Visible = false;
            PanelAllClientsCheques.Visible = false;
            lnkBtnPaidCientCheques.ForeColor = System.Drawing.Color.White;
            lnkBtnUpcomingPayableCientCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnUnpaidCientCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnAllClientsCheceques.ForeColor = System.Drawing.Color.Black;
            GridViewPaidCientCheques.PageIndex = 0;

        }

        protected void lnkBtnUnpaidCientCheques_Click(object sender, EventArgs e)
        {
            PanelUnPaidCientCheques.Visible = true;
            PanelPaidCientCheques.Visible = false;
            PanelUpcomingPayableClientCheques.Visible = false;
            PanelAllClientsCheques.Visible = false;
            lnkBtnUnpaidCientCheques.ForeColor = System.Drawing.Color.White;
            lnkBtnUpcomingPayableCientCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnPaidCientCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnAllClientsCheceques.ForeColor = System.Drawing.Color.Black;
            GridViewUnPaidCientCheques.DataBind();
            GridViewUnPaidCientCheques.PageIndex = 0;
        }

        protected void lnkBtnUpcomingPayableCientCheques_Click(object sender, EventArgs e)
        {
            PanelUpcomingPayableClientCheques.Visible = true;
            PanelPaidCientCheques.Visible = false;
            PanelUnPaidCientCheques.Visible = false;
            PanelAllClientsCheques.Visible = false;
            lnkBtnUpcomingPayableCientCheques.ForeColor = System.Drawing.Color.White;
            lnkBtnPaidCientCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnUnpaidCientCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnAllClientsCheceques.ForeColor = System.Drawing.Color.Black;
            GridViewUpcomingPayableClientCheques.DataBind();
            GridViewUpcomingPayableClientCheques.PageIndex = 0;
        }

        protected void ImageButtonConfirmEdit_Click(object sender, ImageClickEventArgs e)
        {
            var gridRow = ((GridViewRow)((ImageButton)sender).NamingContainer);
            int row_index = gridRow.RowIndex;
            var clientName = gridRow.Cells[1].Text;
            var chequeNumber = gridRow.Cells[2].Text;
            int chequeId = (int)GridViewUnPaidCientCheques.DataKeys[row_index].Value;
            ClientCheque clientCheque = new ClientCheque { Id = chequeId };
            string msg = string.Empty;
            if (!clientCheque.Update_UnPaidClientCheques_By_Id(out msg))
            {
                lblFinishMsg.Text = msg;
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblFinishMsg.Text = $"تم تحصيل شيك رقم {chequeNumber} للعميل {clientName}";
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                ReBoundGrids();
            }
        }

        protected void GridViewAllClientsCheques_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Delete_Row")
            {
                var gridRow = (GridViewRow)((ImageButton)e.CommandSource).NamingContainer;
                int row_index = gridRow.RowIndex;
                int chequeId = (int)GridViewAllClientsCheques.DataKeys[row_index].Value;
                var clientName = gridRow.Cells[1].Text;
                var chequeNumber = gridRow.Cells[2].Text;
                ClientCheque clientCheque = new ClientCheque { Id = chequeId };
                string msg = string.Empty;
                if (!clientCheque.Delete(out msg))
                {
                    lblFinishMsg.Text = msg;
                    lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    lblFinishMsg.Text = $"تم مسح شيك رقم {chequeNumber} للعميل {clientName} بنجاح";
                    lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                    ReBoundGrids();
                    RefreshChequeNotifications();
                }
            }
        }

        private void ReBoundGrids()
        {
            GridViewPaidCientCheques.DataBind();
            GridViewUnPaidCientCheques.DataBind();
            GridViewUpcomingPayableClientCheques.DataBind();
            GridViewAllClientsCheques.DataBind();
            lnkBtnUpcomingPayableCientCheques.ForeColor = System.Drawing.Color.Black;
        }

        private void RefreshChequeNotifications()
        {
            Session["ClientChequesCount"] = ClientCheque.GetUpcomingPayableClientChequesCount();
            ((Master)Master).UpdateChequeMenuItemsNotifications();
        }
    }
}