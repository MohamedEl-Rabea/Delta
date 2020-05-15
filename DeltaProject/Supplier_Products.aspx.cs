using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class Supplier_Products : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            GridViewSupplierProducts.DataSource = Business_Logic.Suppliers_Products.Get_Supplier_Products(TextBoxSearch.Text);
            GridViewSupplierProducts.DataBind();

            PanelSupplierProducts.Visible = true;
        }

        protected void GridViewSupplierProducts_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (e.Row.Cells[4].Text == "0")
                {
                    e.Row.Cells[4].Text = "لا يوجد";
                    e.Row.Cells[5].Text = "لا يوجد";
                }
            }
        }

        private void Merge_Cells(GridView grid)
        {
            for (int row_index = grid.Rows.Count - 2; row_index >= 0; row_index--) // to eleminate Footer row and last row
            {
                GridViewRow Current_Row = grid.Rows[row_index];
                GridViewRow Previous_Row = grid.Rows[row_index + 1];
                if (Current_Row.Cells[0].Text == Previous_Row.Cells[0].Text)
                {
                    Current_Row.Cells[0].RowSpan = Previous_Row.Cells[0].RowSpan < 2 ? 2 : Previous_Row.Cells[0].RowSpan + 1; // RowSpan --> default value = 0
                    Previous_Row.Cells[0].Visible = false;
                    Current_Row.Cells[0].VerticalAlign = VerticalAlign.Middle;
                }
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (PanelSupplierProducts.Visible)
            {
                Merge_Cells(GridViewSupplierProducts);
            }
        }
    }
}