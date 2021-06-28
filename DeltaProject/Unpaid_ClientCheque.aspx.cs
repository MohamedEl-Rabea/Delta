using Business_Logic;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DeltaProject
{
    public partial class Unpaid_ClientCheque : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GridViewUnPaidClientCheque.DataSource = ClientCheque.GetUnPaidClientCheques();
                GridViewUnPaidClientCheque.DataBind();
                
            }
        }

        protected void RadioButtonListCategories_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (RadioButtonListCategories.SelectedIndex == 0)
            {
                TextBoxSearch.Visible = true;
                txtClientCheques_ID.Visible = false;
            }
            else
            {
                TextBoxSearch.Visible = false;
                txtClientCheques_ID.Visible = true;
            }
        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            ClientCheque clientCheque = new ClientCheque();
            clientCheque.ChequeNumber = txtClientCheques_ID.Text != "" ? txtClientCheques_ID.Text : "";

            if (string.IsNullOrEmpty(TextBoxSearch.Text) && clientCheque.ChequeNumber == "")
            {
                
                GridViewUnPaidClientCheque.DataSource = ClientCheque.GetUnPaidClientCheques();
                GridViewUnPaidClientCheque.DataBind();

            }

            else if (TextBoxSearch.Visible)
            {
                clientCheque.ClientName = TextBoxSearch.Text;
                
                GridViewUnPaidClientCheque.DataSource = ClientCheque.GetUnPaidClientCheques().Where(s => s.ClientName == clientCheque.ClientName);
                GridViewUnPaidClientCheque.DataBind();

            }
            else
            {
                GridViewUnPaidClientCheque.DataSource = ClientCheque.GetUnPaidClientCheques().Where(s => s.ChequeNumber == clientCheque.ChequeNumber);
                GridViewUnPaidClientCheque.DataBind();
            }
        }

        protected void GridViewPaidClientCheques_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            //if (e.CommandName == "Select_ChequeNumber")
            //{
            //    long Bill_ID = Convert.ToInt64(((LinkButton)e.CommandSource).Text);
            //    // select bill info
            //    ClientCheque clientCheque = new ClientCheque();
            //    bill.Bill_ID = Bill_ID;
            //    double Cost, Paid_amount;
            //    bill = bill.Get_Bill_Info(out Cost, out Paid_amount);
            //    lblBill_ID.Text = Bill_ID.ToString();
            //    lblBillDate.Text = bill.Bill_Date.ToShortDateString();
            //    lblClientName.Text = bill.Client_Name;
            //    lblBillCost.Text = Cost.ToString();
                
            //    lblPaid_Value.Text = Paid_amount.ToString();
            //    lblAdditionalCostValue.Text = bill.AdditionalCost.ToString();
            //    lblAdditionalcostNotes.Text = bill.AdditionalCostNotes;
            //    lblRest.Text = (Cost + bill.AdditionalCost - Paid_amount - bill.Discount) >= 0 ? (Cost + bill.AdditionalCost - Paid_amount - bill.Discount).ToString() :
            //        (-(Cost + bill.AdditionalCost - Paid_amount - bill.Discount)).ToString() + " " + "فرق تكلفه للعميل";
            //    // select bill items
            //    ViewState["Bill_ID"] = Bill_ID;
            //    BindBill(Bill_ID);
            //    GridViewPayments.DataSource = Bill_Payments.Get_Bill_Payments(Bill_ID);
            //    GridViewPayments.DataBind();
            //    PanelBill.Visible = true;
            //    PanelBills.Visible = false;
            //}
        }


    }
}