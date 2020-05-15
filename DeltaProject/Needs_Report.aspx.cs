using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;

namespace DeltaProject
{
    public partial class Needs_Report : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GridViewProducts.DataSource = Product.Get_Store_Needs();
                GridViewProducts.DataBind();
            }
        }

        protected void GridViewProducts_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (Convert.ToInt32(e.Row.Cells[2].Text) < 5 && Convert.ToInt32(e.Row.Cells[2].Text) > 0)
                {
                    e.Row.Cells[2].BackColor = System.Drawing.Color.Yellow;
                }
                else if (Convert.ToInt32(e.Row.Cells[2].Text) == 0)
                {
                    e.Row.Cells[2].BackColor = System.Drawing.Color.Red;
                }
            }
        }
    }
}