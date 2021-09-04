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
                if (string.IsNullOrWhiteSpace(TextBoxSearch.Text))
                {
                    PanelSupplierCheques.Visible = false;
                    PanelErrorMessage.Visible = true;
                }
                else
                {
                    PanelSupplierCheques.Visible = true;
                    PanelErrorMessage.Visible = false;
                    PanelAllSupplierCheques.Visible = false;
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


        protected void lnkBtnAllSupplierCheques_Click(object sender, EventArgs e)
        {
            PanelAllSupplierCheques.Visible = true;
            PanelUnPaidSupplierCheques.Visible = false;
            PanelPaidSupplierCheques.Visible = false;
            PanelUpcomingPayableSupplierCheques.Visible = false;
            lnkBtnAllSupplierCheques.ForeColor = System.Drawing.Color.White;
            lnkBtnPaidSupplierCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnUpcomingPayableSupplierCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnUnpaidSupplierCheques.ForeColor = System.Drawing.Color.Black;
            GridViewAllSupplierCheques.DataBind();
            GridViewAllSupplierCheques.PageIndex = 0;
        }

        protected void lnkBtnPaidSupplierCheques_Click(object sender, EventArgs e)
        {
            PanelPaidSupplierCheques.Visible = true;
            PanelUnPaidSupplierCheques.Visible = false;
            PanelAllSupplierCheques.Visible = false;
            PanelUpcomingPayableSupplierCheques.Visible = false;
            lnkBtnUpcomingPayableSupplierCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnPaidSupplierCheques.ForeColor = System.Drawing.Color.White;
            lnkBtnUnpaidSupplierCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnAllSupplierCheques.ForeColor = System.Drawing.Color.Black;
            GridViewPaidSupplierCheques.DataBind();
            GridViewPaidSupplierCheques.PageIndex = 0;

        }

        protected void lnkBtnUnpaidSupplierCheques_Click(object sender, EventArgs e)
        {
            PanelUnPaidSupplierCheques.Visible = true;
            PanelPaidSupplierCheques.Visible = false;
            PanelAllSupplierCheques.Visible = false;
            PanelUpcomingPayableSupplierCheques.Visible = false;
            lnkBtnUpcomingPayableSupplierCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnPaidSupplierCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnUnpaidSupplierCheques.ForeColor = System.Drawing.Color.White;
            lnkBtnAllSupplierCheques.ForeColor = System.Drawing.Color.Black;
            GridViewUnPaidSupplierCheques.DataBind();
            GridViewUnPaidSupplierCheques.PageIndex = 0;
        }

        protected void lnkBtnUpcomingPayableSupplierCheques_Click(object sender, EventArgs e)
        {
            PanelAllSupplierCheques.Visible = false;
            PanelPaidSupplierCheques.Visible = false;
            PanelUnPaidSupplierCheques.Visible = false;
            PanelUpcomingPayableSupplierCheques.Visible = true;
            lnkBtnPaidSupplierCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnUnpaidSupplierCheques.ForeColor = System.Drawing.Color.Black;
            lnkBtnUpcomingPayableSupplierCheques.ForeColor = System.Drawing.Color.White;
            lnkBtnAllSupplierCheques.ForeColor = System.Drawing.Color.Black;
            GridViewUpcomingPayableSupplierCheques.DataBind();
            GridViewUpcomingPayableSupplierCheques.PageIndex = 0;
        }

        protected void ImageButtonConfirmEdit_Click(object sender, ImageClickEventArgs e)
        {
            var gridRow = ((GridViewRow)((ImageButton)sender).NamingContainer);
            int row_index = gridRow.RowIndex;
            var supplierName = gridRow.Cells[1].Text;
            var chequeNumber = gridRow.Cells[2].Text;
            int chequeId = (int)GridViewUnPaidSupplierCheques.DataKeys[row_index].Value;
            SupplierCheque SupplierCheque = new SupplierCheque { Id = chequeId };
            string msg;
            if (!SupplierCheque.Update_UnPaidSupplierCheques_By_Id(out msg))
            {
                lblFinishMsg.Text = msg;
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblFinishMsg.Text = $"تم دفع شيك رقم {chequeNumber} للمورد {supplierName}";
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                ReBoundGrids();

            }
        }

        protected void GridViewAllSupplierCheques_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Delete_Row")
            {
                var gridRow = (GridViewRow)((ImageButton)e.CommandSource).NamingContainer;
                int row_index = gridRow.RowIndex;
                int chequeId = (int)GridViewAllSupplierCheques.DataKeys[row_index].Value;
                var supplierName = gridRow.Cells[1].Text;
                var chequeNumber = gridRow.Cells[2].Text;
                SupplierCheque supplierCheque = new SupplierCheque { Id = chequeId };
                string msg = string.Empty;
                if (!supplierCheque.Delete(out msg))
                {
                    lblFinishMsg.Text = msg;
                    lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    lblFinishMsg.Text = $"تم مسح شيك رقم {chequeNumber} للمورد {supplierName} بنجاح";
                    lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                    ReBoundGrids();
                    RefreshChequeNotifications();
                }
            }
        }

        private void ReBoundGrids()
        {
            GridViewAllSupplierCheques.DataBind();
            GridViewPaidSupplierCheques.DataBind();
            GridViewUnPaidSupplierCheques.DataBind();
            GridViewUpcomingPayableSupplierCheques.DataBind();
            PanelUpcomingPayableSupplierCheques.Visible = false;
        }

        private void RefreshChequeNotifications()
        {
            Session["SupplierChequesCount"] = SupplierCheque.GetUpcomingPayableSupplierChequesCount();
            ((Master)Master).UpdateChequeMenuItemsNotifications();
        }
    }
}