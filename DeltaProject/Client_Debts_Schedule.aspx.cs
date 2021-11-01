using Business_Logic;
using DeltaProject.Business_Logic;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class Client_Debts_Schedule : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var clientName = Request.QueryString["ClientName"];
                Client client = new Client { C_name = clientName };

                if (!string.IsNullOrEmpty(clientName))
                {
                    client.Get_Client_Debts_Info();

                    lblClientName.Text = clientName;

                    lblTotalDebts.Text = client.DebtValue.ToString();

                    BindDebtsScheduleGridView();
                }
            }
        }

        private void BindDebtsScheduleGridView(bool refresh = false)
        {
            ClientDebtsSchedule clientDebtsSchedule = new ClientDebtsSchedule { ClientName = lblClientName.Text };
            ClientDebtsScheduleList = ClientDebtsScheduleList == null || refresh
                ? clientDebtsSchedule.GetClientSchedule()
                : ClientDebtsScheduleList;

            var gridDataSource = ClientDebtsScheduleList.Union(NewClientDebtsSchedule);
            lblUnScheduled.Text = (Convert.ToDouble(lblTotalDebts.Text) - gridDataSource.Sum(d => d.DebtValue)).ToString();
            gridViewDebts.DataSource = ToDataTable(gridDataSource);
            gridViewDebts.DataBind();
        }

        protected void BtnFinish_Click(object sender, EventArgs e)
        {
            if (NewClientDebtsSchedule.Count == 0)
                return;

            if (ClientDebtsSchedule.AddClientSchedule(NewClientDebtsSchedule, out var msg))
            {
                NewClientDebtsSchedule = new List<ClientDebtsSchedule>();
                BindDebtsScheduleGridView(refresh: true);
                Succcess("تم الاضافه بنجاح");
                RefreshDebtsNotifications();
            }
            else
                Error(msg);
        }

        protected void gridViewDebts_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            lblFinishMsg.Visible = false;
            var selectedRow = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer);
            var scheduleId = selectedRow.RowType == DataControlRowType.DataRow
                ? Convert.ToInt32(gridViewDebts.DataKeys[selectedRow.RowIndex].Value)
                : 0;

            if (e.CommandName.Equals("Add_Row"))
            {
                ClientDebtsSchedule clientDebtsSchedule = new ClientDebtsSchedule
                {
                    ClientName = lblClientName.Text,
                    DebtValue = Convert.ToDouble(((TextBox)gridViewDebts.FooterRow.FindControl("txtNewDebtValue")).Text),
                    ScheduledDate = DateTime.ParseExact(((TextBox)gridViewDebts.FooterRow.FindControl("txtNewDebtDate")).Text, "dd/MM/yyyy", CultureInfo.InvariantCulture),
                    Description = ((TextBox)gridViewDebts.FooterRow.FindControl("txtNewDescription")).Text
                };
                AddNewDebtSchedule(clientDebtsSchedule);
                BindDebtsScheduleGridView();
            }
            else if (e.CommandName == "Edit_Row")
            {
                gridViewDebts.EditIndex = selectedRow.RowIndex;
                BindDebtsScheduleGridView();
            }
            else if (e.CommandName == "Delete_Row")
            {
                var clientDebtSchedule = new ClientDebtsSchedule { Id = scheduleId };
                if (scheduleId == 0)
                {
                    var indexToDelete = selectedRow.RowIndex - ClientDebtsScheduleList.Count();
                    NewClientDebtsSchedule.RemoveAt(indexToDelete);
                    Succcess("تم المسح بنجاح");
                    BindDebtsScheduleGridView(refresh: true);
                }
                else if (clientDebtSchedule.Delete(out var msg))
                {
                    Succcess("تم المسح بنجاح");
                    BindDebtsScheduleGridView(refresh: true);
                    RefreshDebtsNotifications();
                }
                else
                    Error(msg);
            }
            else if (e.CommandName == "Confirm_Update")
            {
                var clientDebtsSchedule = new ClientDebtsSchedule
                {
                    Id = scheduleId,
                    DebtValue = Convert.ToDouble(((TextBox)selectedRow.FindControl("txtDebtValue")).Text),
                    Description = ((TextBox)selectedRow.FindControl("txtDescription")).Text,
                    ScheduledDate = DateTime.ParseExact(((TextBox)selectedRow.FindControl("txtDebtDate")).Text, "dd/MM/yyyy", CultureInfo.InvariantCulture)
                };
                if (clientDebtsSchedule.Update(out var msg))
                {
                    Succcess("تم التعديل بنجاح");
                    gridViewDebts.EditIndex = -1;
                    BindDebtsScheduleGridView(refresh: true);
                    RefreshDebtsNotifications();
                }
                else
                {
                    Error(msg);
                }
            }
            else if (e.CommandName == "Cancel_Update")
            {
                gridViewDebts.EditIndex = -1;
                BindDebtsScheduleGridView();
            }
        }

        private void AddNewDebtSchedule(ClientDebtsSchedule clientDebtsSchedule)
        {
            ViewState["NewClientDebtsSchedule"] = ViewState["NewClientDebtsSchedule"] == null ? new List<ClientDebtsSchedule>() : ViewState["NewClientDebtsSchedule"];
            var newClientDebtsSchedule = (List<ClientDebtsSchedule>)ViewState["NewClientDebtsSchedule"];
            newClientDebtsSchedule.Add(clientDebtsSchedule);
        }

        private IEnumerable<ClientDebtsSchedule> ClientDebtsScheduleList
        {
            get
            {
                return (IEnumerable<ClientDebtsSchedule>)ViewState["ClientDebtsScheduleList"];
            }
            set
            {
                ViewState["ClientDebtsScheduleList"] = value;
            }
        }

        private List<ClientDebtsSchedule> NewClientDebtsSchedule
        {
            get
            {
                return ViewState["NewClientDebtsSchedule"] == null
                    ? new List<ClientDebtsSchedule>()
                    : (List<ClientDebtsSchedule>)ViewState["NewClientDebtsSchedule"];
            }
            set
            {
                ViewState["NewClientDebtsSchedule"] = value;
            }
        }

        protected void gridViewDebts_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            var isDataRow = e.Row.RowType == DataControlRowType.DataRow;
            var hideAllActions = isDataRow && (gridViewDebts.DataKeys[e.Row.RowIndex].Value is DBNull
                || ((CheckBox)e.Row.FindControl("chkPaid")).Checked);
            if (hideAllActions)
            {
                ((ImageButton)e.Row.FindControl("ImageButtonEdit")).Visible = false;
                ((ImageButton)e.Row.FindControl("ImageButtonDelete")).Visible = false;
                return;
            }

            var isNew = isDataRow && Convert.ToInt32(gridViewDebts.DataKeys[e.Row.RowIndex].Value) == 0;
            if (isNew)
                ((ImageButton)e.Row.FindControl("ImageButtonEdit")).Visible = false;


            if (e.Row.RowType == DataControlRowType.Footer)
            {
                if (Convert.ToDouble(lblUnScheduled.Text) <= 0)
                {
                    ((TextBox)e.Row.FindControl("txtNewDebtValue")).Enabled = false;
                    ((TextBox)e.Row.FindControl("txtNewDebtDate")).Enabled = false;
                    ((TextBox)e.Row.FindControl("txtNewDescription")).Enabled = false;
                    ((ImageButton)e.Row.FindControl("ImageButtonAdd")).Enabled = false;
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

        private DataTable ToDataTable(IEnumerable<ClientDebtsSchedule> debtsSchedules)
        {
            var table = new DataTable();
            table.Columns.Add("Id", typeof(int));
            table.Columns.Add("DebtValue", typeof(double));
            table.Columns.Add("ScheduledDate", typeof(DateTime));
            table.Columns.Add("Description", typeof(string));
            table.Columns.Add("Paid", typeof(bool));

            foreach (var item in debtsSchedules)
                table.Rows.Add(item.Id, item.DebtValue, item.ScheduledDate, item.Description, item.Paid);

            if (table.Rows.Count == 0)
            {
                DataRow dr = table.NewRow();
                table.Rows.Add(dr);
            }
            return table;
        }

        private void RefreshDebtsNotifications()
        {
            Session["ClientDebtsCount"] = ClientDebtsSchedule.Get_All_Have_To_Pay_Debts_Schedule_Count(null);
            ((Master)Master).UpdateDebtsMenuItemsNotifications();
        }
    }
}