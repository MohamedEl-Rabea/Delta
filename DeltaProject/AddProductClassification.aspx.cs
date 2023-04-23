using DeltaProject.Business_Logic;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class AddProductClassification : System.Web.UI.Page
    {
        private List<ClassificationAttribute> ClassificationAttributes
        {
            get => ViewState["ClassificationAttributeList"] == null
                ? new List<ClassificationAttribute>()
                : (List<ClassificationAttribute>)ViewState["ClassificationAttributeList"];
            set => ViewState["ClassificationAttributeList"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                BindClassificationDetailsGridView();
        }

        protected void gridViewClassificationDetails_OnRowCommand(object sender, GridViewCommandEventArgs e)
        {
            var selectedRow = ((GridViewRow)((ImageButton)e.CommandSource).NamingContainer);
            if (e.CommandName.Equals("Add_Row"))
            {
                ClassificationAttribute attribute = new ClassificationAttribute
                {
                    AttrName = ((TextBox)gridViewClassificationDetails.FooterRow.FindControl("txtAttrName")).Text,
                    Type = ((TextBox)gridViewClassificationDetails.FooterRow.FindControl("txtType")).Text,
                    Optional = ((CheckBox)gridViewClassificationDetails.FooterRow.FindControl("chkOptional")).Checked
                };

                if (ClassificationAttributes.Select(p => p.AttrName).Contains(attribute.AttrName))
                {
                    lblFinishMsg.Visible = true;
                    lblFinishMsg.Text = "! هذا العنصر مسجل فى القائمة";
                    lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    lblFinishMsg.Visible = false;
                    lblFinishMsg.Text = "";
                    lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                    AddNewAttribute(attribute);
                    BindClassificationDetailsGridView();
                }
            }
            else if (e.CommandName == "Delete_Row")
            {
                var indexToDelete = selectedRow.RowIndex;
                ClassificationAttributes.RemoveAt(indexToDelete);
                Success("تم المسح بنجاح");
                BindClassificationDetailsGridView();
            }
        }

        protected void gridViewClassificationDetails_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            var isDataRow = e.Row.RowType == DataControlRowType.DataRow;
            if (isDataRow && gridViewClassificationDetails.DataKeys[e.Row.RowIndex]?.Value is DBNull)
                return;

            if (isDataRow)
                ((ImageButton)e.Row.FindControl("btnDelete")).Visible = true;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            btnSave.Enabled = false;
            btnSave.BackColor = System.Drawing.Color.FromName("#aaa");

            ProductClassification classification = new ProductClassification
            {
                Name = txtClassificationName.Text,
                Attributes = ClassificationAttributes
            };

            string msg = "";
            if (!classification.AddClassification(out msg))
            {
                Error(msg ?? "هناك مشكلة في الحفظ برجاء اعادة المحاولة");
            }
            else
            {
                Success("تم الحفظ بنجاح");
                ResetPage();
            }
        }

        private void AddNewAttribute(ClassificationAttribute attribute)
        {
            ViewState["ClassificationAttributeList"] =
                ViewState["ClassificationAttributeList"] ?? new List<ClassificationAttribute>();
            var attributes = (List<ClassificationAttribute>)ViewState["ClassificationAttributeList"];
            attributes.Add(attribute);
        }

        private void BindClassificationDetailsGridView()
        {
            gridViewClassificationDetails.DataSource = ToDataTable(ClassificationAttributes);
            gridViewClassificationDetails.DataBind();
        }

        private DataTable ToDataTable(IEnumerable<ClassificationAttribute> attributes)
        {
            var table = new DataTable();
            table.Columns.Add("AttrName", typeof(string));
            table.Columns.Add("Type", typeof(string));
            table.Columns.Add("Optional", typeof(bool));

            foreach (var item in attributes)
                table.Rows.Add(item.AttrName, item.Type, item.Optional);

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

        private new void Error(string msg)
        {
            lblFinishMsg.Text = msg;
            lblFinishMsg.Visible = true;
            lblFinishMsg.ForeColor = Color.Red;
            btnSave.BackColor = System.Drawing.Color.FromName("#1abc9c");
            btnSave.Enabled = true;
        }

        private void ResetPage()
        {
            btnSave.BackColor = System.Drawing.Color.FromName("#1abc9c");
            btnSave.Enabled = true;

            txtClassificationName.Text = "";

            ViewState["ClassificationAttributeList"] = null;
            BindClassificationDetailsGridView();
        }
    }
}