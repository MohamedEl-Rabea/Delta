using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class Clients_Report : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        double totalClientsDebts, totalCompanyDebts = 0;
        protected void GridViewClients_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                double debts = Convert.ToDouble(e.Row.Cells[2].Text);
                Label lblDebts = ((Label)e.Row.FindControl("lblTotalDebts"));
                lblDebts.Text = debts.ToString();
                if (debts < 0)
                {
                    e.Row.BackColor = System.Drawing.Color.LightGray;
                    lblDebts.Text = (-Convert.ToDouble(lblDebts.Text)).ToString();
                    totalCompanyDebts += -debts;
                }
                else if (debts > 0)
                {
                    e.Row.BackColor = System.Drawing.Color.White;
                    totalClientsDebts += debts;
                }
                else
                {
                    e.Row.Visible = false;
                }
            }
            else if (e.Row.RowType == DataControlRowType.Footer)
            {
                e.Row.Cells[0].ColumnSpan = 2;
                e.Row.Cells.RemoveAt(1);
                e.Row.Cells[1].Text = "ديون  الشركة : " + totalCompanyDebts.ToString() + " جنيها " +  " - ديون العملاء : " + totalClientsDebts  + " جنيها";
            }
        }
    }
}