using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;

namespace DeltaProject
{
    public partial class Delete_Supplier : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            lblFinishMsg.Text = "";
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
                PanelErrorMessage.Visible = false;
                PaenlSupplierInfo.Visible = true;
                lblName.Text = supplier.S_name;
                lblAddress.Text = string.IsNullOrEmpty(supplier.Address) ? "لا يوجد" : supplier.Address;
                lblAccountNumber.Text = string.IsNullOrEmpty(supplier.Account_Number) ? "لا يوجد" : supplier.Account_Number;
                lblTotalDebts.Text = Debts < 0 ? (-Debts).ToString() + " على الشركه للمورد" : (-Debts).ToString() + " على المورد للشركه";
            }
        }

        protected void BtnDelete_Click(object sender, EventArgs e)
        {
            Supplier supplier = new Supplier();
            supplier.S_name = lblName.Text;
            string m;
            if (!supplier.Delete_Supplier(out m))
            {
                lblFinishMsg.Text = m;
                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                lblFinishMsg.Text = "تم بنجاح";
                lblFinishMsg.ForeColor = System.Drawing.Color.Green;
            }
        }
    }
}