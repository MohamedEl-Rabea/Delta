using DeltaProject.Business_Logic;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class Add_Workshop : System.Web.UI.Page
    {
        private List<Partner> Partners
        {
            get => ViewState["Partners"] == null
                ? new List<Partner>()
                : (List<Partner>)ViewState["Partners"];
            set => ViewState["Partners"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            lblSaveMsg.Text = "";
            lblSaveMsg.Visible = false;
            ViewState["Partners"] = null;
            BindPartnersGridView();
        }

        protected void gridViewPartners_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            var isDataRow = e.Row.RowType == DataControlRowType.DataRow;
            if (isDataRow && gridViewPartners.DataKeys[e.Row.RowIndex]?.Value is DBNull)
                return;
            var isNew = isDataRow && Convert.ToInt32(gridViewPartners.DataKeys[e.Row.RowIndex]?.Value) == 0;
            if (isNew)
                ((ImageButton)e.Row.FindControl("btnDelete")).Visible = true;
        }

        protected void gridViewPartners_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            var selectedRow = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer);

            if (e.CommandName.Equals("Add_Row"))
            {
                Partner partner = new Partner
                {
                    Name = ((TextBox)gridViewPartners.FooterRow.FindControl("txtPartnerName")).Text
                };

                if (Partners.Select(p => p.Name).Contains(partner.Name))
                {
                    lblSaveMsg.Visible = true;
                    lblSaveMsg.Text = "! هذا الشريك مسجل فى القائمة";
                    lblSaveMsg.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    lblSaveMsg.Visible = false;
                    lblSaveMsg.Text = "";
                    lblSaveMsg.ForeColor = System.Drawing.Color.Green;
                    AddNewPartner(partner);
                    BindPartnersGridView();
                }
            }
            else if (e.CommandName == "Delete_Row")
            {
                var indexToDelete = selectedRow.RowIndex;
                Partners.RemoveAt(indexToDelete);
                Success("تم المسح بنجاح");
                BindPartnersGridView();
            }
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            ViewState["W_Name"] = txtWorkshop_Name.Text;
            Workshop workshop = new Workshop();
            workshop.Name = txtWorkshop_Name.Text;
            string m = "";
            if (!workshop.Add_Workshop(out m))
            {
                lblSaveMsg.Text = m;
                lblSaveMsg.ForeColor = Color.Red;
            }
            else
            {
                lblSaveMsg.Text = "تم بنجاح";
                lblSaveMsg.ForeColor = System.Drawing.Color.Green;
            }
        }

        private void AddNewPartner(Partner partner)
        {
            ViewState["Partners"] = ViewState["Partners"] ?? new List<Partner>();
            var unitFactors = (List<Partner>)ViewState["Partners"];
            unitFactors.Add(partner);
        }

        private void BindPartnersGridView()
        {
            var gridDataSource = (List<Partner>)ViewState["Partners"];
            gridViewPartners.DataSource = ToDataTable(gridDataSource);
            gridViewPartners.DataBind();
        }

        private DataTable ToDataTable(IEnumerable<Partner> partners)
        {
            var table = new DataTable();
            table.Columns.Add("Name", typeof(string));

            foreach (var item in partners)
                table.Rows.Add(item.Name);

            if (table.Rows.Count == 0)
            {
                DataRow dr = table.NewRow();
                table.Rows.Add(dr);
            }
            return table;
        }

        private void Success(string msg)
        {
            lblSaveMsg.Text = msg;
            lblSaveMsg.Visible = true;
            lblSaveMsg.ForeColor = Color.Green;
            BtnSave.BackColor = Color.FromName("#1abc9c");
            BtnSave.Enabled = true;
        }

    }
}