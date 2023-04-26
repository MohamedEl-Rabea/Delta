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
            get => ViewState["PartnerList"] == null
                ? new List<Partner>()
                : (List<Partner>)ViewState["PartnerList"];
            set => ViewState["PartnerList"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                BindPartnersGridView();
        }

        protected void gridViewPartners_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {

            var isDataRow = e.Row.RowType == DataControlRowType.DataRow;
            if (isDataRow && gridViewPartners.DataKeys[e.Row.RowIndex]?.Value is DBNull)
                return;
            if (isDataRow)
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
                    lblSaveMsg.Text = "! هذا الشريك مسجل فى القائمة";
                    lblSaveMsg.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
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
            Workshop workshop = new Workshop
            {
                Name = txtWorkshop_Name.Text,
                Partners = Partners
            };

            string m = "";
            if (!workshop.Add_Workshop(out m))
            {
                lblSaveMsg.Text = m;
                lblSaveMsg.ForeColor = Color.Red;
            }
            else
            {
                txtWorkshop_Name.Text = "";
                ViewState["PartnerList"] = null;
                BindPartnersGridView();
                Success("تم بنجاح");
            }
        }

        private void AddNewPartner(Partner partner)
        {
            ViewState["PartnerList"] = ViewState["PartnerList"] ?? new List<Partner>();
            var partners = (List<Partner>)ViewState["PartnerList"];
            partners.Add(partner);
        }

        private void BindPartnersGridView()
        {
            BtnSave.Enabled = Partners.Any();
            BtnSave.BackColor = Color.FromName(Partners.Any() ? "#1abc9c" : "#aaa");

            gridViewPartners.DataSource = ToDataTable(Partners);
            gridViewPartners.DataBind();
        }

        private DataTable ToDataTable(IEnumerable<Partner> partners)
        {
            var table = new DataTable();
            table.Columns.Add("Id", typeof(int));
            table.Columns.Add("Name", typeof(string));

            foreach (var item in partners)
                table.Rows.Add(item.Id, item.Name);

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
            lblSaveMsg.ForeColor = Color.Green;
        }
    }
}