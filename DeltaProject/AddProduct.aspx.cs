using DeltaProject.Business_Logic;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Unit = DeltaProject.Business_Logic.Unit;

namespace DeltaProject
{
    public partial class AddProduct : System.Web.UI.Page
    {
        private List<ProductClassification> Classifications
        {
            get => ViewState["Classifications"] == null
                ? new List<ProductClassification>()
                : (List<ProductClassification>)ViewState["Classifications"];
            set => ViewState["Classifications"] = value;
        }

        private List<Unit> Units
        {
            get => ViewState["Units"] == null
                ? new List<Unit>()
                : (List<Unit>)ViewState["Units"];
            set => ViewState["Units"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                FillDropDownList();
            }
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            PanelAddSupplier.Visible = false;
            PanelAddProducts.Visible = true;
        }

        protected void txtProductName_OnTextChanged(object sender, EventArgs e)
        {
            FillUnitsDropDownList();
        }

        protected void btnBackToAddSupplier_Click(object sender, ImageClickEventArgs e)
        {
            PanelAddSupplier.Visible = true;
            PanelAddProducts.Visible = false;
        }

        protected void btnNextToProductsList_Click(object sender, EventArgs e)
        {
            PanelAddProducts.Visible = false;
        }

        protected void btnAddProduct_Click(object sender, EventArgs e)
        {
            throw new NotImplementedException();
        }

        private void FillDropDownList()
        {
            Unit unit = new Unit();
            ViewState["Units"] = unit.GetUnits();
            FillUnitsDropDownList();
            ProductClassification classification = new ProductClassification();
            ViewState["Classifications"] = classification.GetClassifications();
            ddlClassifications.DataSource = Classifications;
            ddlClassifications.DataBind();
            ddlClassifications.Items.Insert(0, new ListItem("إختر تصنيف", ""));
            ddlClassifications.SelectedIndex = 0;
        }

        private void FillUnitsDropDownList()
        {
            Unit unit = new Unit();
            var units = !string.IsNullOrEmpty(txtProductName.Text) ? unit.GetProductUnits(txtProductName.Text) : new List<Unit>();
            ddlUnits.DataSource = units.Any() ? units : Units;
            ddlUnits.DataBind();
            ddlUnits.Items.Insert(0, new ListItem("إختر وحدة قياس", ""));
            ddlUnits.SelectedIndex = 0;
        }

        protected void ddlClassifications_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            var classificationId =string.IsNullOrEmpty(ddlClassifications.SelectedValue) ? 0 : Convert.ToInt32(ddlClassifications.SelectedValue);
            var classification = ((List<ProductClassification>)ViewState["Classifications"])
                .FirstOrDefault(c => c.Id == classificationId);
            var attributes = classification?.GetAttributesFromJson;
            Page.ClientScript.RegisterStartupScript(GetType(), "text", $"AddClassificationElements({JsonConvert.SerializeObject(attributes)})", true);
        }
    }
}