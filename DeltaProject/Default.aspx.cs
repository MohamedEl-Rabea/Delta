using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;

namespace DeltaProject
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!Product.AmountEnough())
                {
                    // or you can make use of MasterType directive in the content page "Default.aspx" to retrieve strongly typed refernece rather suing typecasting
                    //<<%@ MasterType VirtualPath="~/Master.Master" %> in the .aspx page
                    (((Master)Master).AlertImage).Visible = true;
                }

            }
        }
    }
}