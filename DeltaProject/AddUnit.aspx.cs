using DeltaProject.Business_Logic;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Unit = DeltaProject.Business_Logic.Unit;

namespace DeltaProject
{
    public partial class AddUnit : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                FillDropDownList();
            }
        }

        protected void btnAddUnitFactors_OnClick(object sender, ImageClickEventArgs e)
        {
            PanelAddUnitFactor.Visible = true;
            PanelUnitFactors.Visible = true;
            lblFinishMsg.Text = "";
            lblFinishMsg.Visible = false;
        }

        protected void btnAddSubUnitFactor_OnClick(object sender, EventArgs e)
        {
            UnitFactor unitFactor = new UnitFactor
            {
                SubUnitId = Convert.ToInt32(ddlUnits.SelectedValue),
                SubUnitName = ddlUnits.SelectedItem.Text
            };

            unitFactor.Factor = Convert.ToDecimal(txtFactor.Text);

            List<UnitFactor> unitFactors = new List<UnitFactor> { unitFactor };
            ViewState["UnitFactorsList"] = unitFactors;

            BindList();

            btnAddSubUnitFactor.Enabled = false;
            btnAddSubUnitFactor.BackColor = System.Drawing.Color.FromName("#aaa");
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            btnSave.Enabled = false;

            Unit unit = new Unit
            {
                Name = txtMainUnitName.Text,
                UnitFactors = ((List<UnitFactor>)ViewState["UnitFactorsList"])?.Select(p => new UnitFactor
                {
                    SubUnitId = p.SubUnitId,
                    Factor = p.Factor
                })
            };

            string msg = "";
            if (!unit.AddUnit(out msg))
            {
                lblFinishMsg.Text = msg ?? "هناك مشكلة في الحفظ برجاء اعادة المحاولة";
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                lblFinishMsg.Visible = true;
                btnSave.BackColor = System.Drawing.Color.FromName("#1abc9c");
                btnSave.Enabled = true;
            }
            else
            {
                lblFinishMsg.Text = $"تم حفظ وحدة القياس ({txtMainUnitName.Text}) بنجاح";
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                lblFinishMsg.Visible = true;
                btnSave.BackColor = System.Drawing.Color.FromName("#aaa");
                ResetPage();
            }
        }

        private void BindList()
        {
            if (ViewState["UnitFactorsList"] != null && ((List<UnitFactor>)ViewState["UnitFactorsList"]).Count > 0)
                PanelUnitFactors.Visible = true;
            else
                PanelUnitFactors.Visible = false;

            ddlUnits.SelectedIndex = 0;
            txtFactor.Text = "";
            GridViewPreviewUnitFactorList.DataSource = (List<UnitFactor>)ViewState["UnitFactorsList"];
            GridViewPreviewUnitFactorList.DataBind();
        }

        private void ResetPage()
        {
            txtMainUnitName.Text = "";
            btnSave.BackColor = System.Drawing.Color.FromName("#1abc9c");
            btnSave.Enabled = true;

            PanelAddUnitFactor.Visible = false;
            PanelUnitFactors.Visible = false;

            FillDropDownList();
            txtFactor.Text = "";
            ViewState["UnitFactorsList"] = null;
            BindList();
        }

        private void FillDropDownList()
        {
            ddlUnits.DataSource = Unit.GetUnits();
            ddlUnits.DataBind();
            ddlUnits.Items.Insert(0, new ListItem("إختر وحدة قياس", ""));
            ddlUnits.SelectedIndex = 0;
        }

        protected void GridViewPreviewUnitFactorList_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Delete_Row")
            {
                int row_index = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer).RowIndex;
                string subUnitName = GridViewPreviewUnitFactorList.Rows[row_index].Cells[0].Text;
                if (subUnitName.Contains("-"))
                {
                    subUnitName = subUnitName.Substring(0, subUnitName.IndexOf('-'));
                }
                int index = ((List<UnitFactor>)ViewState["UnitFactorsList"]).FindIndex(p => p.SubUnitName == subUnitName);
                ((List<UnitFactor>)ViewState["UnitFactorsList"]).RemoveAt(index);
                BindList();

                btnAddSubUnitFactor.Enabled = true;
                btnAddSubUnitFactor.BackColor = System.Drawing.Color.FromName("#1abc9c");
            }
        }
    }
}