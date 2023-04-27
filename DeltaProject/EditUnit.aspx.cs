using DeltaProject.Business_Logic;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web.UI.WebControls;
using Unit = DeltaProject.Business_Logic.Unit;

namespace DeltaProject
{
    public partial class EditUnit : System.Web.UI.Page
    {
        private IEnumerable<UnitFactor> UnitFactors
        {
            get => (IEnumerable<UnitFactor>)ViewState["UnitFactorsList"];
            set => ViewState["UnitFactorsList"] = value;
        }

        private List<UnitFactor> NewUnitFactors
        {
            get => ViewState["NewUnitFactorsList"] == null
                    ? new List<UnitFactor>()
                    : (List<UnitFactor>)ViewState["NewUnitFactorsList"];
            set => ViewState["NewClientDebtsSchedule"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                FillDropDownList();
            }
        }

        protected void ddlUnits_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            PanelUnitFactors.Visible = true;
            ViewState["NewUnitFactorsList"] = null;
            lblFinishMsg.Text = "";
            lblFinishMsg.Visible = false;
            BindUnitFactorsGridView();
        }

        protected void gridViewUnitFactors_OnDataBound(object sender, EventArgs e)
        {
            DropDownList ddlSubUnits = gridViewUnitFactors.FooterRow.FindControl("ddlSubUnits") as DropDownList;
            ddlSubUnits.DataSource = (List<Unit>)ViewState["Units"];
            ddlSubUnits.DataBind();
            ddlSubUnits.Items.Insert(0, new ListItem("إختر وحدة قياس", ""));
            ddlSubUnits.SelectedIndex = 0;

        }

        protected void gridViewUnitFactors_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            var isDataRow = e.Row.RowType == DataControlRowType.DataRow;
            if (isDataRow && gridViewUnitFactors.DataKeys[e.Row.RowIndex]?.Value is DBNull)
                return;
            var isNew = isDataRow && Convert.ToInt32(gridViewUnitFactors.DataKeys[e.Row.RowIndex]?.Value) == 0;
            if (isNew)
                ((ImageButton)e.Row.FindControl("btnDelete")).Visible = true;
        }

        protected void gridViewUnitFactors_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            var selectedRow = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer);

            if (e.CommandName.Equals("Add_Row"))
            {
                UnitFactor unitFactor = new UnitFactor
                {
                    MainUnitId = Convert.ToInt32(ddlUnits.SelectedValue),
                    SubUnitId = Convert.ToInt32(((DropDownList)gridViewUnitFactors.FooterRow.FindControl("ddlSubUnits")).SelectedValue),
                    SubUnitName = ((DropDownList)gridViewUnitFactors.FooterRow.FindControl("ddlSubUnits")).SelectedItem.Text,
                    Factor = Convert.ToDecimal(((TextBox)gridViewUnitFactors.FooterRow.FindControl("txtFactor")).Text)
                };

                if (UnitFactors.Union(NewUnitFactors).Select(p => p.SubUnitId).Contains(unitFactor.SubUnitId))
                {
                    lblFinishMsg.Visible = true;
                    lblFinishMsg.Text = "! هذا التحويل مسجل فى القائمة";
                    lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    lblFinishMsg.Visible = false;
                    lblFinishMsg.Text = "";
                    lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                    AddNewUnitFactor(unitFactor);
                    BindUnitFactorsGridView();
                }
            }
            else if (e.CommandName == "Delete_Row")
            {
                var indexToDelete = selectedRow.RowIndex - UnitFactors.Count();
                NewUnitFactors.RemoveAt(indexToDelete);
                Success("تم المسح بنجاح");
                BindUnitFactorsGridView();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            btnSave.Enabled = false;
            btnSave.BackColor = System.Drawing.Color.FromName("#aaa");

            Unit unit = new Unit
            {
                Id = Convert.ToInt32(ddlUnits.SelectedValue),
                UnitFactors = ((List<UnitFactor>)ViewState["NewUnitFactorsList"])?.Select(p => new UnitFactor
                {
                    SubUnitId = p.SubUnitId,
                    Factor = p.Factor
                })
            };

            string msg = "";
            if (!unit.AddUnitFactors(out msg))
            {
                Error(msg ?? "هناك مشكلة في الحفظ برجاء اعادة المحاولة");
            }
            else
            {
                Success("تم الحفظ بنجاح");
                ResetPage();
            }
        }


        private void FillDropDownList()
        {
            ViewState["Units"] = Unit.GetUnits();
            ddlUnits.DataSource = (List<Unit>)ViewState["Units"];
            ddlUnits.DataBind();
            ddlUnits.Items.Insert(0, new ListItem("إختر وحدة قياس", ""));
            ddlUnits.SelectedIndex = 0;
        }

        private void AddNewUnitFactor(UnitFactor unitFactor)
        {
            ViewState["NewUnitFactorsList"] = ViewState["NewUnitFactorsList"] ?? new List<UnitFactor>();
            var unitFactors = (List<UnitFactor>)ViewState["NewUnitFactorsList"];
            unitFactors.Add(unitFactor);
        }

        private void BindUnitFactorsGridView()
        {
            UnitFactor unitFactor = new UnitFactor { MainUnitId = Convert.ToInt32(ddlUnits.SelectedValue) };
            UnitFactors = unitFactor.GetUnitFactors();

            var gridDataSource = UnitFactors.Union(NewUnitFactors);
            gridViewUnitFactors.DataSource = ToDataTable(gridDataSource);
            gridViewUnitFactors.DataBind();
        }

        private DataTable ToDataTable(IEnumerable<UnitFactor> unitFactors)
        {
            var table = new DataTable();
            table.Columns.Add("Id", typeof(int));
            table.Columns.Add("SubUnitName", typeof(string));
            table.Columns.Add("Factor", typeof(decimal));

            foreach (var item in unitFactors)
                table.Rows.Add(item.Id, item.SubUnitName, item.Factor);

            if (table.Rows.Count == 0)
            {
                DataRow dr = table.NewRow();
                table.Rows.Add(dr);
            }
            return table;
        }

        private void Success(string msg)
        {
            lblFinishMsg.Text = msg;
            lblFinishMsg.Visible = true;
            lblFinishMsg.ForeColor = Color.Green;
            btnSave.BackColor = System.Drawing.Color.FromName("#1abc9c");
            btnSave.Enabled = true;
        }

        private void Error(string msg)
        {
            lblFinishMsg.Text = msg;
            lblFinishMsg.Visible = true;
            lblFinishMsg.ForeColor = Color.Red;
            btnSave.BackColor = System.Drawing.Color.FromName("#1abc9c");
            btnSave.Enabled = true;
        }

        private void ResetPage()
        {
            ddlUnits.SelectedIndex = 0;
            btnSave.BackColor = System.Drawing.Color.FromName("#1abc9c");
            btnSave.Enabled = true;

            PanelUnitFactors.Visible = false;

            ViewState["NewUnitFactorsList"] = null;
        }
    }
}