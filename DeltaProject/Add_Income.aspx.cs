using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace DeltaProject
{
    public partial class Add_Income : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void BtnFinish_Click(object sender, EventArgs e)
        {
            DateTime Income_Date = new DateTime(Convert.ToInt32(txtYear.Text), Convert.ToInt32(txtMonth.Text), Convert.ToInt32(txtDay.Text),
                DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);
            double Income_Value = Convert.ToDouble(txtPaid_amount.Text);
            string Notes = TxtNotes.Text;
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            con.Open();
            try
            {
                SqlCommand cmd = new SqlCommand("Add_Income", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@Income_Date", SqlDbType.SmallDateTime).Value = Income_Date;
                cmd.Parameters.Add("@Income_Value", SqlDbType.Money).Value = Income_Value;
                cmd.Parameters.Add("@Notes", SqlDbType.NVarChar).Value = Notes;
                cmd.ExecuteNonQuery();
                lblFinishMsg.Text = "تم بنجاح";
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
            }
            catch (Exception ex)
            {
                lblFinishMsg.Text = ex.Message;
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            con.Close();
        }
    }
}