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
                    PanelCientCheques.Visible = false;
                    PanelErrorMessage.Visible = true;
                }
                else
                {
                    PanelCientCheques.Visible = true;
                    PanelErrorMessage.Visible = false;
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

        protected void lnkBtnPaidCientCheques_Click(object sender, EventArgs e)
        {
            PanelPaidCientCheques.Visible = true;
            PanelUnPaidCientCheques.Visible = false;
            PanelUpcomingPayableClientCheques.Visible = false;
            lnkBtnUpcomingPayableCientCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnPaidCientCheques.ForeColor = System.Drawing.Color.White;
            lnkBtnUnpaidCientCheques.ForeColor = System.Drawing.Color.Black;
            GridViewPaidCientCheques.PageIndex = 0;

        }

        protected void lnkBtnUnpaidCientCheques_Click(object sender, EventArgs e)
        {
            PanelUnPaidCientCheques.Visible = true;
            PanelPaidCientCheques.Visible = false;
            PanelUpcomingPayableClientCheques.Visible = false;
            lnkBtnUpcomingPayableCientCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnPaidCientCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnUnpaidCientCheques.ForeColor = System.Drawing.Color.White;
            GridViewUnPaidCientCheques.DataBind();
            GridViewUnPaidCientCheques.PageIndex = 0;
        }

        protected void lnkBtnUpcomingPayableCientCheques_Click(object sender, EventArgs e)
        {
            PanelPaidCientCheques.Visible = false;
            PanelUnPaidCientCheques.Visible = false;
            PanelUpcomingPayableClientCheques.Visible = true;
            lnkBtnPaidCientCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnUnpaidCientCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnUpcomingPayableCientCheques.ForeColor = System.Drawing.Color.White;
            GridViewUpcomingPayableClientCheques.DataBind();
            GridViewUpcomingPayableClientCheques.PageIndex = 0;
        }

        protected void ImageButtonConfirmEdit_Click(object sender, ImageClickEventArgs e)
        {
            int row_index = ((GridViewRow)((ImageButton)sender).NamingContainer).RowIndex;
            GridView ClientCheques = (GridView)((GridViewRow)((ImageButton)sender).NamingContainer).NamingContainer;
            ClientCheque clientCheque = new ClientCheque();
            int Id = (int)GridViewUnPaidCientCheques.DataKeys[row_index].Value;
            if (!clientCheque.Update_UnPaidClientCheques_By_Id(Id))
            {
                lblFinishMsg.Text = "هناك مشكلة في التحديث برجاء اعادة المحاولة";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblFinishMsg.Text = "تم بنجاح";
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                GridViewPaidCientCheques.DataBind();
                GridViewUnPaidCientCheques.DataBind();
                GridViewUpcomingPayableClientCheques.DataBind();

            }
        }

    }
}