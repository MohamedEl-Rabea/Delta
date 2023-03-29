using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using Unit = DeltaProject.Business_Logic.Unit;

namespace DeltaProject
{
    public partial class Units : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindUnitsGrid();
            }
        }

        protected void gridViewUnits_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                int id = (int)gridViewUnits.DataKeys[e.Row.RowIndex].Value;
                var list = ((List<Unit>)ViewState["UnitsWithFactors"])
                    .Where(p => p.Id == id)
                    .SelectMany(x => x.UnitFactors).ToList();
                GridView gridViewUnitFactors = e.Row.FindControl("gridViewUnitFactors") as GridView;
                gridViewUnitFactors.DataSource = list;
                gridViewUnitFactors.DataBind();
            }
        }

        protected void gridViewUnits_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            Unit unit = new Unit();
            int rowIndex = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer).RowIndex;
            unit.Id = Convert.ToInt32(gridViewUnits.Rows[rowIndex].Cells[0].Text);
            string m = "";

            if (e.CommandName == "Delete_Row")
            {
                if (!unit.DeleteUnit(out m))
                {
                    lblSaveMsg.Text = m;
                    lblSaveMsg.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    lblSaveMsg.Text = "تم بنجاح";
                    lblSaveMsg.ForeColor = System.Drawing.Color.Green;
                    BindUnitsGrid();
                }
            }
        }

        private void BindUnitsGrid()
        {
            Unit unit = new Unit();
            ViewState["UnitsWithFactors"] = unit.GetUnitsWithFactors();
            gridViewUnits.DataSource = ((List<Unit>)ViewState["UnitsWithFactors"]).Select(x => new
            {
                Id = x.Id,
                MainUnitName = x.Name
            }).Distinct();
            gridViewUnits.DataBind();
        }
    }
}