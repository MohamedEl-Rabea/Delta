using Business_Logic;
using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class Search_For_SupplierCheque : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lnkBtnUpcomingPayableSupplierCheques.ForeColor = System.Drawing.Color.White;
            Session["SupplierChequesCount"] = 0;

        }

        
        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            if (TextBoxSearch.Visible)
            {
                SupplierCheque SupplierCheque = new SupplierCheque();
                SupplierCheque.SupplierName = TextBoxSearch.Text;
                if (string.IsNullOrEmpty(TextBoxSearch.Text))
                {
                    PanelSupplierCheques.Visible = false;
                    PanelErrorMessage.Visible = true;
                }
                else
                {
                    PanelSupplierCheques.Visible = true;
                    PanelErrorMessage.Visible = false;
                    PanelPaidSupplierCheques.Visible = false;
                    PanelUnPaidSupplierCheques.Visible = false;
                    PanelUpcomingPayableSupplierCheques.Visible = true;
                    lnkBtnPaidSupplierCheques.ForeColor = System.Drawing.Color.Black;
                    lnkBtnUnpaidSupplierCheques.ForeColor = System.Drawing.Color.Black;
                    lnkBtnUpcomingPayableSupplierCheques.ForeColor = System.Drawing.Color.White;
                    GridViewPaidSupplierCheques.PageIndex = 0;
                }
            }
            
        }

        protected void lnkBtnPaidSupplierCheques_Click(object sender, EventArgs e)
        {
            PanelPaidSupplierCheques.Visible = true;
            PanelUnPaidSupplierCheques.Visible = false;
            PanelUpcomingPayableSupplierCheques.Visible = false;
            lnkBtnUpcomingPayableSupplierCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnPaidSupplierCheques.ForeColor = System.Drawing.Color.White;
            lnkBtnUnpaidSupplierCheques.ForeColor = System.Drawing.Color.Black;
            GridViewPaidSupplierCheques.PageIndex = 0;

        }

        protected void lnkBtnUnpaidSupplierCheques_Click(object sender, EventArgs e)
        {
            PanelUnPaidSupplierCheques.Visible = true;
            PanelPaidSupplierCheques.Visible = false;
            PanelUpcomingPayableSupplierCheques.Visible = false;
            lnkBtnUpcomingPayableSupplierCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnPaidSupplierCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnUnpaidSupplierCheques.ForeColor = System.Drawing.Color.White;
            GridViewUnPaidSupplierCheques.DataBind();
            GridViewUnPaidSupplierCheques.PageIndex = 0;
        }

        protected void lnkBtnUpcomingPayableSupplierCheques_Click(object sender, EventArgs e)
        {
            PanelPaidSupplierCheques.Visible = false;
            PanelUnPaidSupplierCheques.Visible = false;
            PanelUpcomingPayableSupplierCheques.Visible = true;
            lnkBtnPaidSupplierCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnUnpaidSupplierCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnUpcomingPayableSupplierCheques.ForeColor = System.Drawing.Color.White;
            GridViewUpcomingPayableSupplierCheques.DataBind();
            GridViewUpcomingPayableSupplierCheques.PageIndex = 0;
        }

        protected void ImageButtonConfirmEdit_Click(object sender, ImageClickEventArgs e)
        {
            int row_index = ((GridViewRow)((ImageButton)sender).NamingContainer).RowIndex;
            GridView SupplierCheques = (GridView)((GridViewRow)((ImageButton)sender).NamingContainer).NamingContainer;
            SupplierCheque SupplierCheque = new SupplierCheque();
            int Id = (int)GridViewUnPaidSupplierCheques.DataKeys[row_index].Value;
            if (!SupplierCheque.Update_UnPaidSupplierCheques_By_Id(Id))
            {
                lblFinishMsg.Text = "هناك مشكلة في التحديث برجاء اعادة المحاولة";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblFinishMsg.Text = "تم بنجاح";
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                GridViewPaidSupplierCheques.DataBind();
                GridViewUnPaidSupplierCheques.DataBind();
                GridViewUpcomingPayableSupplierCheques.DataBind();

            }
        }

    }
}