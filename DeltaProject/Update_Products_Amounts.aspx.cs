using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business_Logic;

namespace DeltaProject
{
    public partial class Update_Products_Amounts : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ImageButtonSearch_Click(object sender, ImageClickEventArgs e)
        {
            lblFinishMsg.Text = "";
            PanelProducts.Visible = true;
            AmountPanel.Visible = false;
            PanelCost.Visible = false;
            string P_name;
            if (TextBoxSearch.Visible)
            {
                P_name = TextBoxSearch.Text;
                GridViewProducts.Columns[1].ItemStyle.CssClass = "NoDispaly";
                GridViewProducts.Columns[1].HeaderStyle.CssClass = "NoDispaly";
                GridViewProducts.Columns[2].ItemStyle.CssClass = "NoDispaly";
                GridViewProducts.Columns[2].HeaderStyle.CssClass = "NoDispaly";
                GridViewProducts.Columns[3].ItemStyle.CssClass = "NoDispaly";
                GridViewProducts.Columns[3].HeaderStyle.CssClass = "NoDispaly";

            }
            else if (TextBoxTol.Visible)
            {
                P_name = TextBoxTol.Text;
                GridViewProducts.Columns[1].ItemStyle.CssClass = "";
                GridViewProducts.Columns[1].HeaderStyle.CssClass = "";
                GridViewProducts.Columns[2].ItemStyle.CssClass = "";
                GridViewProducts.Columns[2].HeaderStyle.CssClass = "";
                GridViewProducts.Columns[3].ItemStyle.CssClass = "";
                GridViewProducts.Columns[3].HeaderStyle.CssClass = "";
            }
            else
            {
                P_name = TextBoxMotors.Text;
                GridViewProducts.Columns[1].ItemStyle.CssClass = "";
                GridViewProducts.Columns[1].HeaderStyle.CssClass = "";
                GridViewProducts.Columns[2].ItemStyle.CssClass = "";
                GridViewProducts.Columns[2].HeaderStyle.CssClass = "";
                GridViewProducts.Columns[3].HeaderStyle.CssClass = "NoDispaly";
                GridViewProducts.Columns[3].ItemStyle.CssClass = "NoDispaly";
            }
            GridViewProducts.DataSource = Product.GetProducts(P_name);
            GridViewProducts.DataBind();
        }

        protected void LnkSelect_Click(object sender, EventArgs e)
        {
            AmountPanel.Visible = true;
            PanelProducts.Visible = false;
            txtPaid_Amount.Text = "";
            txtDay.Text = "";
            txtMonth.Text = "";
            txtYear.Text = "";
            txtboxAddedAmount.Text = "";
            txtSupplier_Name.Text = "";
            int row_index = ((GridViewRow)(((LinkButton)sender).NamingContainer)).RowIndex;
            Product product = new Product();
            product.P_name = GridViewProducts.Rows[row_index].Cells[0].Text;
            product.Mark = GridViewProducts.Rows[row_index].Cells[1].Text;
            product.Inch = Convert.ToDouble(GridViewProducts.Rows[row_index].Cells[2].Text);
            product.Style = GridViewProducts.Rows[row_index].Cells[3].Text;
            product.Purchase_Price = Convert.ToDouble(GridViewProducts.Rows[row_index].Cells[4].Text);
            product = product.Get_Product_For_Update_Amount();
            ViewState["IsCollected"] = GridViewProducts.Rows[row_index].Cells[6].Text;
            txtboxP_name.Text = product.P_name;
            txtMark.Text = product.Mark;
            txtStyle.Text = product.Style;
            txtInch.Text = product.Inch.ToString();
            txtboxPurchasePrice.Text = product.Purchase_Price.ToString();
            txtboxRegularSellPrice.Text = product.Regulare_Price.ToString();
            txtboxSpecialSellPrice.Text = product.Special_Price.ToString();
            TxtCurrentAmount.Text = product.Amount.ToString();
            if (RadioButtonListCategories.SelectedValue == "Tol")
            {
                PanelTol.Visible = true;
                PanelMotors.Visible = true;
            }
            else if (RadioButtonListCategories.SelectedValue == "Motors")
            {
                PanelTol.Visible = false;
                PanelMotors.Visible = true;
            }
            else
            {
                PanelTol.Visible = false;
                PanelMotors.Visible = false;
            }
        }

        protected void BtnConfirm_Click(object sender, EventArgs e)
        {
            lblFinishMsg.Text = "";
            double cost = Convert.ToInt32(txtboxAddedAmount.Text) * Convert.ToDouble(txtboxPurchasePrice.Text);
            int Day = Convert.ToInt32(txtDay.Text);
            int Month = Convert.ToInt32(txtMonth.Text);
            int Year = Convert.ToInt32(txtYear.Text);
            DateTime Purchase_Date = new DateTime(Year, Month, Day, DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);
            Product p = new Product();
            p.P_name = txtboxP_name.Text;
            p.Mark = txtMark.Text;
            p.Style = txtStyle.Text;
            p.Inch = Convert.ToDouble(txtInch.Text);
            p.Purchase_Price = Convert.ToDouble(txtboxPurchasePrice.Text);
            p.Amount = Convert.ToDecimal(txtboxAddedAmount.Text);
            string Notes;
            System.Text.StringBuilder ConcatenatedNotes = new System.Text.StringBuilder("ثمن شراء المنتجات التاليه : ");

            ConcatenatedNotes.AppendLine();
            ConcatenatedNotes.Append(p.Amount.ToString() + " " + p.P_name + " " + (p.Mark != "Not found" ? ("ماركة  " + p.Mark + " " +
                p.Inch.ToString() + "بوصه " + (p.Style != "Not found" ? "طراز " + p.Style + " " : "")) : "")
                + " سعر الواحده يساوى" + p.Purchase_Price.ToString());
            Notes = ConcatenatedNotes.ToString();
            if (!PanelCost.Visible) // PaidAmount && Cost no defined yet
            {
                if (txtSupplier_Name.Text != "") // There is supplier and will be a new treatment
                {
                    PanelCost.Visible = true;
                    lblTotalCost.Text = cost.ToString();
                }
                else // apply the same but without treatment
                {
                    if (Convert.ToBoolean(ViewState["IsCollected"]))
                    {
                        // select its content and check the existness for them in our store
                        bool AllValid = true;
                        List<Product> ContentList = Product.GetContents(p.P_name, p.Purchase_Price);
                        foreach (Product product in ContentList)
                        {
                            if (!product.IsValidAmount())
                            {
                                lblFinishMsg.Text += "لا تتوفر كل الكميه المطلوبة من المنتج : " + product.P_name + "<br />";
                                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                                AllValid = false;
                            }
                        }
                        if (AllValid)
                        {
                            string m1, supplier1 = "غير معروف";
                            if (!p.Update_Products_amount(out m1, supplier1, Purchase_Date))
                            {
                                lblFinishMsg.Text = m1;
                                lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                            }
                            else // reduce the used aount
                            {
                                foreach (Product product in ContentList)
                                {
                                    if (!product.AddContent(out m1))
                                    {
                                        lblFinishMsg.Text += m1 + "هذا الخطأ عند المنتج : " + product.P_name + "<br />";
                                        lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                                        AllValid = false;
                                    }
                                }
                                if (AllValid)
                                {
                                    lblFinishMsg.Text = "تم بنجاح";
                                    lblFinishMsg.ForeColor = System.Drawing.Color.Green;
                                }
                            }
                        }
                    }
                    else
                    {
                        string m, supplier = "غير معروف";
                        if (!p.Update_Products_amount(out m, supplier, Purchase_Date))
                        {
                            lblFinishMsg.Text = m;
                            lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                        }
                        else // add expenses
                        {

                            if (!Product.Add_Supplier_Treatment(out m, supplier, Purchase_Date, cost, cost, Notes))
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
            }
            else // if the panel is already visible so it is sure that i have the paid_amount and supplier_name
            {
                double Paid_Amount = Convert.ToDouble(txtPaid_Amount.Text);
                string m, supplier = txtSupplier_Name.Text;
                if (!p.Update_Products_amount(out m, supplier, Purchase_Date))
                {
                    lblFinishMsg.Text = m;
                    lblFinishMsg.ForeColor = System.Drawing.Color.Red;
                }
                else // add expenses and treatment
                {
                    if (!Product.Add_Supplier_Treatment(out m, supplier, Purchase_Date, cost, Paid_Amount, Notes))
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
            SetFocus(BtnConfirm);
        }

        protected void RadioButtonListCategories_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (RadioButtonListCategories.SelectedValue == "Normal")
            {
                TextBoxSearch.Visible = true;
                TextBoxMotors.Visible = false;
                TextBoxTol.Visible = false;
            }
            else if (RadioButtonListCategories.SelectedValue == "Tol")
            {
                TextBoxTol.Visible = true;
                TextBoxSearch.Visible = false;
                TextBoxMotors.Visible = false;
            }
            else
            {
                TextBoxMotors.Visible = true;
                TextBoxSearch.Visible = false;
                TextBoxTol.Visible = false;
            }
        }
    }
}