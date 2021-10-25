using DeltaProject.Business_Logic;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class Manage_Permissions : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ddlUsers.DataSource = CreateUsersDDLDataSource();
                ddlUsers.DataTextField = "UserId";
                ddlUsers.DataValueField = "UserName";
                ddlUsers.DataBind();
                ddlUsers.SelectedIndex = 0;
            }
        }

        protected void BtnUpdate_Click(object sender, EventArgs e)
        {
            var userId = int.Parse(ddlUsers.SelectedItem.Value);
            if (userId > 0)
            {
                lblFinishMsg.Visible = false;
                var user = new DeltaUser { UserId = userId };
                user.Permissions = GetSelectedPermissions();
                string msg;
                if (user.SetPermissions(out msg))
                {
                    lblFinishMsg.Text = $"تم حفظ صلاحيات المستخدم -{ddlUsers.SelectedItem.Text}- بنجاح";
                    lblFinishMsg.ForeColor = Color.Green;
                    lblFinishMsg.Visible = true;
                }
                else
                {
                    lblFinishMsg.Text = msg;
                    lblFinishMsg.ForeColor = Color.Red;
                    lblFinishMsg.Visible = true;
                }
            }
        }

        protected void ddlUsers_SelectedIndexChanged(object sender, EventArgs e)
        {
            lblFinishMsg.Visible = false;
            var userId = int.Parse(ddlUsers.SelectedItem.Value);
            var user = new DeltaUser { UserId = userId };
            user.Get_User_Permissions();
            SetPermissionSelection(user);
        }

        private void SetPermissionSelection(DeltaUser user)
        {
            foreach (var ctrl in pnlAllPermissions.Controls)
            {
                if (ctrl is CheckBox)
                {
                    var chkCtrl = (CheckBox)ctrl;
                    var ctrlPermissionName = chkCtrl.ID.Replace("chk_", "");
                    chkCtrl.Checked = user.IsAdmin || user.Permissions.Contains(ctrlPermissionName);
                }
            }
        }

        private List<string> GetSelectedPermissions()
        {
            var result = new List<string>();
            var allChecked = true;
            foreach (var ctrl in pnlAllPermissions.Controls)
            {
                if (ctrl is CheckBox)
                {
                    var chkCtrl = (CheckBox)ctrl;
                    if (chkCtrl.Checked)
                    {
                        var ctrlPermissionName = chkCtrl.ID.Replace("chk_", "");
                        result.Add(ctrlPermissionName);
                    }
                    else
                    {
                        allChecked = false;
                    }
                }
            }
            result = allChecked ? new List<string>() { "All" } : result;
            return result;
        }

        private ICollection CreateUsersDDLDataSource()
        {

            // Create a table to store data for the DropDownList control.
            DataTable dt = new DataTable();

            // Define the columns of the table.
            dt.Columns.Add(new DataColumn("UserId", typeof(string)));
            dt.Columns.Add(new DataColumn("UserName", typeof(string)));

            // Populate the table
            dt.Rows.Add(CreateRow("إختر المستخدم", "0", dt));
            var users = DeltaUser.GetAll();
            foreach (var user in users)
                dt.Rows.Add(CreateRow(user.UserName, user.UserId.ToString(), dt));

            // Create a DataView from the DataTable to act as the data source
            // for the DropDownList control.
            DataView dv = new DataView(dt);
            return dv;
        }

        private DataRow CreateRow(string Text, string Value, DataTable dt)
        {
            DataRow dr = dt.NewRow();
            dr[0] = Text;
            dr[1] = Value;
            return dr;
        }
    }
}