using DeltaProject.Business_Logic;
using System;
using System.Drawing;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class Pay_Customer_Debt : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (lnkBtnAllClientsDebts.ForeColor != Color.White && lnkBtnUnpaidCientDebts.ForeColor != Color.White)
                lnkBtnTodayCientDebts.ForeColor = System.Drawing.Color.White;
            Session["ClientDebtsCount"] = null;
        }

        protected void lnkBtnAllClientsDebts_Click(object sender, EventArgs e)
        {
            PanelAllClientsDebts.Visible = true;
            PanelUnpaidCientDebts.Visible = false;
            PanelTodayCientDebts.Visible = false;
            lnkBtnAllClientsDebts.ForeColor = System.Drawing.Color.White;
            lnkBtnUnpaidCientDebts.ForeColor = System.Drawing.Color.Black;
            lnkBtnTodayCientDebts.ForeColor = System.Drawing.Color.Black;
            lblFinishMsg.Text = "";
            GridViewAllClientsDebts.DataBind();
            GridViewAllClientsDebts.PageIndex = 0;
        }

        protected void lnkBtnUnpaidCientDebts_Click(object sender, EventArgs e)
        {
            PanelAllClientsDebts.Visible = false;
            PanelUnpaidCientDebts.Visible = true;
            PanelTodayCientDebts.Visible = false;
            lnkBtnAllClientsDebts.ForeColor = System.Drawing.Color.Black;
            lnkBtnUnpaidCientDebts.ForeColor = System.Drawing.Color.White;
            lnkBtnTodayCientDebts.ForeColor = System.Drawing.Color.Black;
            lblFinishMsg.Text = "";
            GridViewUnpaidCientDebts.DataBind();
            GridViewUnpaidCientDebts.PageIndex = 0;
        }

        protected void lnkBtnTodayCientDebts_Click(object sender, EventArgs e)
        {
            PanelAllClientsDebts.Visible = false;
            PanelUnpaidCientDebts.Visible = false;
            PanelTodayCientDebts.Visible = true;
            lnkBtnAllClientsDebts.ForeColor = System.Drawing.Color.Black;
            lnkBtnUnpaidCientDebts.ForeColor = System.Drawing.Color.Black;
            lnkBtnTodayCientDebts.ForeColor = System.Drawing.Color.White;
            lblFinishMsg.Text = "";
            GridViewTodayCientDebts.DataBind();
            GridViewTodayCientDebts.PageIndex = 0;
        }

        protected void GridViewUnpaidCientDebts_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            var selectedRow = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer);
            var id = selectedRow.RowType == DataControlRowType.DataRow
                ? Convert.ToInt32(GridViewUnpaidCientDebts.DataKeys[selectedRow.RowIndex]?.Value)
                : 0;
            var clientDebtSchedule = new ClientDebtsSchedule { Id = id };

            if (e.CommandName == "Pay_Debt")
            {
                if (clientDebtSchedule.PayDebt(out var msg))
                {
                    Succcess("تم التسديد بنجاح");
                    ReBoundGrids();
                }
                else
                    Error(msg);
            }
            else if (e.CommandName == "Delete_Debt")
            {
                if (clientDebtSchedule.Delete(out var msg))
                {
                    Succcess("تم المسح بنجاح");
                    ReBoundGrids();
                }
                else
                    Error(msg);
            }
        }

        protected void GridViewTodayCientDebts_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            var selectedRow = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer);
            var id = selectedRow.RowType == DataControlRowType.DataRow
                ? Convert.ToInt32(GridViewUnpaidCientDebts.DataKeys[selectedRow.RowIndex]?.Value)
                : 0;
            var clientDebtSchedule = new ClientDebtsSchedule { Id = id };

            if (e.CommandName == "Pay_Debt")
            {
                if (clientDebtSchedule.PayDebt(out var msg))
                {
                    Succcess("تم التسديد بنجاح");
                    ReBoundGrids();
                }
                else
                    Error(msg);
            }
        }

        private void ReBoundGrids()
        {
            RefreshDebtsNotifications();
            GridViewAllClientsDebts.DataBind();
            GridViewUnpaidCientDebts.DataBind();
            GridViewTodayCientDebts.DataBind();
        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            if (TextBoxSearch.Visible)
            {
                ClientDebtsSchedule clientDebtsSchedule = new ClientDebtsSchedule();
                ;
                clientDebtsSchedule.ClientName = TextBoxSearch.Text;

                if (string.IsNullOrEmpty(TextBoxSearch.Text))
                {
                    PanelClientCheques.Visible = false;
                    PanelErrorMessage.Visible = true;
                }
                else
                {
                    PanelClientCheques.Visible = true;
                    PanelErrorMessage.Visible = false;
                    PanelAllClientsDebts.Visible = false;
                    PanelUnpaidCientDebts.Visible = false;
                    PanelTodayCientDebts.Visible = true;
                    lnkBtnAllClientsDebts.ForeColor = System.Drawing.Color.Black;
                    lnkBtnUnpaidCientDebts.ForeColor = System.Drawing.Color.Black;
                    lnkBtnTodayCientDebts.ForeColor = System.Drawing.Color.White;
                    GridViewTodayCientDebts.PageIndex = 0;
                }
            }

        }

        private void Succcess(string msg)
        {
            lblFinishMsg.Text = msg;
            lblFinishMsg.Visible = true;
            lblFinishMsg.ForeColor = Color.Green;
        }

        private void Error(string msg)
        {
            lblFinishMsg.Text = msg;
            lblFinishMsg.Visible = true;
            lblFinishMsg.ForeColor = Color.Red;
        }

        private void RefreshDebtsNotifications()
        {
            Session["ClientDebtsCount"] = ClientDebtsSchedule.Get_All_Have_To_Pay_Debts_Schedule_Count(null);
            ((Master)Master).UpdateDebtsMenuItemsNotifications();
        }
    }
}