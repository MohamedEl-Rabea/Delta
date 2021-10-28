using Business_Logic;
using DeltaProject.Business_Logic;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class Client_Debts_Schedule : System.Web.UI.Page
    {
        List<ClientDebtsSchedule> ClientDebtsSchedules = new List<ClientDebtsSchedule>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var clientName = Request.QueryString["ClientName"];
                Client client = new Client { C_name = clientName };

                client.Get_Client_Debts_Info();

                lblClientName.Text = clientName;

                lblTotalDebts.Text = client.DebtValue.ToString();

                lblUnScheduled.Text = (client.DebtValue - client.ScheduledDebtValue).ToString();

                PopulateGridView(clientName);
            }
        }

        private void PopulateGridView(string clientName)
        {
            ClientDebtsSchedule clientDebtsSchedule = new ClientDebtsSchedule { ClientName = clientName };
            ClientDebtsSchedules = clientDebtsSchedule.GetClientSchedule().ToList();

            gridViewDebts.DataSource = clientDebtsSchedule;
            gridViewDebts.DataBind();
            //}
            //else
            //{
            //    debtsTable.Rows.Add(debtsTable.NewRow());
            //    gridViewDebts.DataSource = debtsTable;
            //    gridViewDebts.DataBind();
            //    gridViewDebts.Rows[0].Cells.Clear();
            //    gridViewDebts.Rows[0].Cells.Add(new TableCell());
            //    gridViewDebts.Rows[0].Cells[0].ColumnSpan = debtsTable.Columns.Count;
            //    gridViewDebts.Rows[0].Cells[0].Text = "لا توجد ديون مجدوله";
            //    gridViewDebts.Rows[0].Cells[0].HorizontalAlign = HorizontalAlign.Center;
            //}
        }

        protected void BtnFinish_Click(object sender, EventArgs e)
        {
            throw new NotImplementedException();
        }

        protected void gridViewDebts_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName.Equals("AddNew"))
            {
                string msg;

                ClientDebtsSchedule clientDebtsSchedule = new ClientDebtsSchedule
                {
                    ClientName = Request.QueryString["ClientName"],
                    DebtValue = Convert.ToDouble((gridViewDebts.FooterRow.FindControl("txtValueFooter") as TextBox)
                        ?.Text.Trim()),
                    Description = (gridViewDebts.FooterRow.FindControl("txtDescriptionFooter") as TextBox)?.Text.Trim()
                };

                List<ClientDebtsSchedule> list = new List<ClientDebtsSchedule>
                {
                    clientDebtsSchedule
                };

                clientDebtsSchedule.AddClientSchedule(list, out msg);
                lblSuccessMessage.Text = msg == string.Empty ? "تم الإضافة بنجاح" : "";
                lblErrorMessage.Text = msg;
                PopulateGridView(clientDebtsSchedule.ClientName);
            }
        }
    }
}