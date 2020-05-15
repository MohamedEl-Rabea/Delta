<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Pay_Bill.aspx.cs" Inherits="DeltaProject.Pay_Bill" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
    <script type="text/javascript" src="Script/ValidationScript.js"></script>
    <script type="text/javascript" src="Script/ServiseHandler.js"></script>
    <style type="text/css">
        .auto-style1 {
            text-align: right;
            width: 99px;
        }
        .auto-style2 {
            text-align: right;
            width: 123px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>دفع فواتير</p>
    </header>
    <section class="Search_Section">
        <table class="Search_table">
            <tr>
                <td class="Image_td">
                    <asp:ImageButton ID="ImageButtonSearch" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                        Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearch_Click" />
                </td>
                <td class="Search_td">
                    <asp:TextBox ID="txtBill_ID" runat="server" AutoCompleteType="Disabled" CssClass="Search_TextBox"
                        placeholder="رقم الفاتورة للبحث . . . . ."></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td></td>
                <td style="text-align: center">
                    <asp:CompareValidator ID="CompareValidator1" runat="server"
                        ControlToValidate="txtBill_ID"
                        Display="Dynamic"
                        Operator="DataTypeCheck"
                        Type="Integer"
                        SetFocusOnError="true"
                        ToolTip="يجب كتابة رقم الفاتورة بشكل صحيح">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:CompareValidator>
                </td>
            </tr>
        </table>
    </section>
    <asp:Panel ID="PanelErrorMessage" runat="server" CssClass="ErrorMessagePanal" Visible="false">
        <article class="Errorarticle">
            <asp:Label ID="LabelErrMsg" runat="server" CssClass="LblErrorMsg2" Text="اما هناك خطأ فى الرقم او لو يدرج اى فاتورة بهذا الرقم"></asp:Label>
        </article>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelPayBill" Visible="false">
        <section class="ContactsSection" style="border-radius: 8px; width: 99%; text-align: right; direction: rtl; padding: 10px;">
            <header class="Prices_Offer_SubHeaderBill" style="margin-bottom: 10px;">
                <div style="border: 1px solid black">
                    <p style="font: bold 13px arial; margin: 0; padding: 0">بيانات الفاتورة</p>
                </div>
            </header>
            <table class="AddProductsTable">
                <tr>
                    <td>
                        <asp:Label ID="Label1" runat="server" Text="تاريخ الفاتورة : " CssClass="lblInfo"></asp:Label>
                    </td>
                    <td style="width: 125px">
                        <asp:Label ID="lblBillDate" runat="server" CssClass="lblInfo2"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="Label2" runat="server" Text="رقم الفاتورة : " CssClass="lblInfo"></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblBill_ID" runat="server" CssClass="lblInfo2"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="Label3" runat="server" Text="العميل : " CssClass="lblInfo"></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblClientName" runat="server" CssClass="lblInfo2"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="Label4" runat="server" Text="العنوان : " CssClass="lblInfo"></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblAddress" runat="server" CssClass="lblInfo2"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <br />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label5" runat="server" CssClass="lblInfo" Text="تكلفة الفاتورة : "></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblBillCost" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="lblDiscount" runat="server" CssClass="lblInfo" Text="الخصم : "></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblDiscountValue" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="Label6" runat="server" CssClass="lblInfo" Text="المدفوع : "></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblPaid_Value" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="Label7" runat="server" CssClass="lblInfo" Text="المتبقى : "></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblRest" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <br />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblAddtionalCost" runat="server" CssClass="lblInfo" Text="تكلفة اضافيه : "></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblAdditionalCostValue" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                    </td>
                    <td colspan="6">
                        <asp:Label ID="lblAdditionalcostNotes" runat="server" CssClass="lblInfo2"></asp:Label>
                    </td>
                </tr>
            </table>
        </section>
        <br />
        <br />
        <table class="AddProductsTable">
            <tr>
                <td class="auto-style2">
                    <p class="RHSP">الخصم (ان وجد) :</p>
                </td>
                <td style="text-align: right">
                    <asp:TextBox runat="server" ID="txtDiscount" CssClass="txts2" PlaceHolder="القيمه المخصومه من تكلفة الفاتورة ان وجد" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="auto-style2">
                    <br />
                    <br />
                </td>
                <td style="text-align: center">
                    <asp:CustomValidator ID="CustomValidator2" runat="server"
                        ToolTip="يجب كتابة القيمة المخصومه بشكل صحيح"
                        ControlToValidate="txtDiscount"
                        Display="Dynamic"
                        SetFocusOnError="true"
                        ClientValidationFunction="IsValidNumber">
                    <img src="Images/Error.png" width="24" height="24"/>
                    </asp:CustomValidator>
                </td>
            </tr>
            <tr>
                <td class="auto-style2">
                    <p class="RHSP">القيمــــــــــــة :</p>
                </td>
                <td style="text-align: right">
                    <asp:TextBox runat="server" ID="txtPaid_amount" CssClass="txts2" PlaceHolder="القيمه المدفوعه" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="auto-style2">
                    <br />
                    <br />
                </td>
                <td style="text-align: center">
                    <asp:CustomValidator ID="CustomValidator3" runat="server"
                        ToolTip="يجب كتابة القيمة المدفوعه و بشكل صحيح"
                        ControlToValidate="txtPaid_amount"
                        Display="Dynamic"
                        SetFocusOnError="true"
                        ValidateEmptyText="true"
                        ClientValidationFunction="IsValidNumber">
                    <img src="Images/Error.png" width="24" height="24"/>
                    </asp:CustomValidator>
                </td>
            </tr>
        </table>
        <table class="AddProductsTable">
            <tr>
                <td class="RHSTD">
                    <p class="RHSP">تاريخ الدفــــع :</p>
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtDay" ClientIDMode="Static" CssClass="DateTxts" PlaceHolder="يوم" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtMonth" ClientIDMode="Static" CssClass="DateTxts_MID" PlaceHolder="شهر" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtYear" ClientIDMode="Static" CssClass="DateTxts" PlaceHolder="سنه" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
                <td>
                    <asp:Button ID="BtnGetDate" runat="server" Text=":" CausesValidation="false" CssClass="GetDateStyle"
                        OnClientClick="return GetDate()" />
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
                <td style="text-align: center">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidatorDay" runat="server" ControlToValidate="txtDay" Display="Dynamic" SetFocusOnError="true"
                        ErrorMessage="يجب اضافة يوم الدفع" ToolTip="يجب اضافة يوم الدفع">
                    <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                    <asp:RangeValidator ID="RangeValidatorDay" runat="server" ErrorMessage="RangeValidator" Display="Dynamic"
                        ControlToValidate="txtDay" Type="Integer" MinimumValue="1" MaximumValue="31" ToolTip="يجب اضافة اليوم بشكل صحيح مابين 1-31">
                    <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RangeValidator>
                </td>
                <td style="text-align: center">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidatorMonth" runat="server" ControlToValidate="txtMonth" Display="Dynamic" SetFocusOnError="true"
                        ErrorMessage="يجب اضافة شهر الدفع" ToolTip="يجب اضافة شهر الدفع">
                    <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                    <asp:RangeValidator ID="RangeValidatorMonth" runat="server" ErrorMessage="RangeValidator" Display="Dynamic"
                        ControlToValidate="txtMonth" Type="Integer" MinimumValue="1" MaximumValue="12" ToolTip="يجب اضافة اليوم بشكل صحيح مابين 1-12">
                    <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RangeValidator>
                </td>
                <td style="text-align: center">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidatorYear" runat="server" ControlToValidate="txtYear" Display="Dynamic" SetFocusOnError="true"
                        ErrorMessage="يجب اضافة سنة الدفع" ToolTip="يجب اضافة سنة الدفع">
                    <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                    <asp:CustomValidator ID="CustomValidator1" runat="server"
                        ToolTip="يجب اضافة سنة الدفع بشكل صحيح"
                        ControlToValidate="txtYear"
                        Display="Dynamic"
                        SetFocusOnError="true"
                        ClientValidationFunction="IsValidYear">
                    <img src="Images/Error.png" width="24" height="24"/>
                    </asp:CustomValidator>
                </td>

            </tr>
        </table>
        <table class="AddProductsTable">
            <tr>
                <td class="td_lbls" style="vertical-align: top">
                    <p class="RHSP">ملاحظـــــــات :</p>
                </td>
                <td class="td_txts">
                    <asp:TextBox ID="TxtNotes" runat="server" CssClass="TxtMultiline" AutoCompleteType="Disabled"
                        TextMode="MultiLine" placeholder="اضف ملاحظات نصيه لعملية الدفع . . . ."></asp:TextBox>
                </td>
            </tr>
        </table>
        <br />
        <footer class="AddSupplierFooter">
            <asp:Button ID="BtnFinish" runat="server" Text="انهاء" CssClass="BtnNext" OnClick="BtnFinish_Click"
                UseSubmitBehavior="false"
                OnClientClick="this.disabled='true';this.value='Please wait....';" ValidationGroup="FinishGroup" />
            <div class="MsgDiv">
                <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel" ForeColor="Green"></asp:Label>
            </div>
        </footer>
    </asp:Panel>
</asp:Content>
