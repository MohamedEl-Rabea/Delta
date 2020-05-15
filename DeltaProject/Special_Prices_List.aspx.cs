using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;
namespace DeltaProject
{
    public partial class Special_Prices_List : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GridViewProducts.DataSource = Product.Get_Special_Offer();
                GridViewProducts.DataBind();
            }
        }
    }
}