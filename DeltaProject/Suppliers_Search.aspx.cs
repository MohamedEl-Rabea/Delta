using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace DeltaProject
{
    public partial class Suppliers_Search : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            Supplier supplier = new Supplier();
            supplier.S_name = TextBoxSearch.Text;
            double Debts;
            supplier = supplier.Get_Supplier_info(out Debts);
            if (string.IsNullOrEmpty(supplier.S_name))
            {
                // display error panel
                PanelErrorMessage.Visible = true;
                // hide result panel
                PaenlSupplierInfo.Visible = false;
            }
            else
            {
                ViewState["S_Name"] = supplier.S_name;
                PaenlSupplierInfo.Visible = true;
                lblName.Text = supplier.S_name;
                lblAddress.Text = string.IsNullOrEmpty(supplier.Address) ? "لا يوجد" : supplier.Address;
                lblAccountNumber.Text = string.IsNullOrEmpty(supplier.Account_Number) ? "لا يوجد" : supplier.Account_Number;

                GridViewPhones.DataSource = Supplier_Phone.Get_Supplier_Phones(supplier.S_name);
                GridViewPhones.DataBind();

                GridViewFaxs.DataSource = Supplier_Fax.Get_Supplier_Faxs(supplier.S_name);
                GridViewFaxs.DataBind();

                Get_Records(supplier.S_name);//Bind supplier records grid
                PanelNotes.Visible = false;
            }
        }

        private void Get_Records(string supplier)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            SqlCommand cmd = new SqlCommand("Get_Supplier_Record", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@S_Name", SqlDbType.NVarChar).Value = supplier;
            con.Open();
            GridViewSupplierRecord.DataSource = cmd.ExecuteReader();
            GridViewSupplierRecord.DataBind();
            con.Close();
            if (GridViewSupplierRecord.Rows.Count > 0)
            {
                PanelNotice.Visible = true;
            }
            else
            {
                PanelNotice.Visible = false;
            }
        }

        protected void GridViewSupplierRecord_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (Convert.ToDouble(e.Row.Cells[3].Text) < 0)
                {
                    e.Row.BackColor = System.Drawing.Color.LightGray;
                    e.Row.Cells[3].Text = (-Convert.ToDouble(e.Row.Cells[3].Text)).ToString() + "مدفوعه من المورد";
                    e.Row.Cells[2].Text = (Convert.ToDouble(e.Row.Cells[2].Text)).ToString();
                    e.Row.Cells[1].Text = (Convert.ToDouble(e.Row.Cells[1].Text)).ToString();
                }
                else
                {
                    e.Row.BackColor = System.Drawing.Color.White;
                    e.Row.Cells[3].Text = (Convert.ToDouble(e.Row.Cells[3].Text)).ToString() + "مدفوعه من الشركه";
                    e.Row.Cells[2].Text = (Convert.ToDouble(e.Row.Cells[2].Text)).ToString();
                    e.Row.Cells[1].Text = (Convert.ToDouble(e.Row.Cells[1].Text)).ToString();
                }
            }
            else if (e.Row.RowType == DataControlRowType.Footer)
            {
                e.Row.Cells.Clear();
                TableCell footer = new TableCell();
                double Current_debts = Convert.ToDouble(GridViewSupplierRecord.Rows[GridViewSupplierRecord.Rows.Count - 1].Cells[2].Text);
                footer.Text = Current_debts < 0 ? "قيمة الدين الحالى على الشركه للمورد = " + (-Current_debts) + " جنيها" : "قيمة الدين الحالى على المورد للشركه = " + Current_debts + " جنيها";
                e.Row.Cells.Add(footer);
            }
        }

        protected void lnkDetails_Click(object sender, EventArgs e)
        {
            PanelNotes.Visible = true;
            GridViewRow SelectedRow = (GridViewRow)((LinkButton)sender).NamingContainer;
            // get textual notes
            Supplier_Payment_Record record = new Supplier_Payment_Record();
            // for valid format in convertion to double
            int Startindex = SelectedRow.Cells[3].Text.IndexOf("مدفوعه");
            string value = SelectedRow.Cells[3].Text.Remove(Startindex, 16);

            record.Paid_amount = SelectedRow.BackColor == System.Drawing.Color.LightGray ? -Convert.ToDouble(value) : Convert.ToDouble(value);
            record.Pay_Date = Convert.ToDateTime(SelectedRow.Cells[0].Text);
            string s_name = ViewState["S_Name"].ToString();
            TxtNotes.Text = record.Get_Supplier_Notes(s_name);
            // get attachments
            GridViewImages.DataSource = Supplier_Payments_Documents.Get_Images(s_name, record.Pay_Date);
            GridViewImages.DataBind();
            // to successfully compute the debts in the footer row
            Get_Records(s_name);//Bind supplier records grid ;
            SetFocus(GridViewImages);
        }
    }
}