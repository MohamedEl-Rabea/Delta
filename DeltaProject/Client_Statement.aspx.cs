﻿using Business_Logic;
using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class Client_Statement : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            if (string.IsNullOrEmpty(txtClientName.Text))
            {
                PanelStatement.Visible = false;
                PanelErrorMessage.Visible = true;
            }
            else
            {
                PanelStatement.Visible = true;
                PanelErrorMessage.Visible = false;
                Client client = new Client { C_name = txtClientName.Text };
                DateTime? startDate = string.IsNullOrEmpty(txtStartDate.Text) ? null : (DateTime?)Convert.ToDateTime(txtStartDate.Text);
                var statmentList = client.GetClientStatement(startDate);
                lblClientName.Text = client.C_name;
                lblStartDate.Text = startDate.HasValue ? startDate.Value.ToShortDateString() : "شامل";
                lblBalance.Text = statmentList.LastOrDefault() != null ? statmentList.Last().Balance.ToString() : "0";
                GridViewStatement.DataSource = statmentList;
                GridViewStatement.DataBind();
            }
        }

        protected void GridViewStatement_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                var result = HttpUtility.HtmlDecode(HttpUtility.HtmlDecode(e.Row.Cells[0].Text));
                e.Row.Cells[0].Text = string.IsNullOrWhiteSpace(result) ? "--------" : result;
            }
        }
    }
}