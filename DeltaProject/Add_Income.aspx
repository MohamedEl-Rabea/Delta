<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="~/Add_Income.aspx.cs" Inherits="DeltaProject.Add_Income" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="Script/ServiseHandler.js"></script>
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
    <link href="CSS/jquery-ui-1.10.4.custom.min.css" rel="stylesheet" />
    <script src="Script/jquery-1.10.2.js"></script>
    <script src="Script/jquery-ui-1.10.4.custom.min.js"></script>
    <script type="text/javascript" src="Script/ValidationScript.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>عملية اضافة دخل</p>
    </header>
    <section>
        <section class="ChoicesSection">
        </section>
        <table class="AddProductsTable">
            <tr>
                <td class="RHSTD">
                    <p class="RHSP">القيمــــــــــــة :</p>
                </td>
                <td style="text-align: right">
                    <asp:TextBox runat="server" ID="txtPaid_amount" CssClass="txts2" PlaceHolder="القيمه المضافه" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
                <td style="text-align: center">
                    <asp:CustomValidator ID="CustomValidator3" runat="server"
                        ToolTip="يجب كتابة القيمة المضافه و بشكل صحيح"
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
                    <p class="RHSP">التاريــــــــــخ :</p>
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
                        ErrorMessage="يجب اضافة يوم الدخل" ToolTip="يجب اضافة يوم الدخل">
                    <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                    <asp:RangeValidator ID="RangeValidatorDay" runat="server" ErrorMessage="RangeValidator" Display="Dynamic"
                        ControlToValidate="txtDay" Type="Integer" MinimumValue="1" MaximumValue="31" ToolTip="يجب اضافة اليوم بشكل صحيح مابين 1-31">
                    <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RangeValidator>
                </td>
                <td style="text-align: center">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidatorMonth" runat="server" ControlToValidate="txtMonth" Display="Dynamic" SetFocusOnError="true"
                        ErrorMessage="يجب اضافة شهر الدخل" ToolTip="يجب اضافة شهر الدخل">
                    <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                    <asp:RangeValidator ID="RangeValidatorMonth" runat="server" ErrorMessage="RangeValidator" Display="Dynamic"
                        ControlToValidate="txtMonth" Type="Integer" MinimumValue="1" MaximumValue="12" ToolTip="يجب اضافة اليوم بشكل صحيح مابين 1-12">
                    <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RangeValidator>
                </td>
                <td style="text-align: center">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidatorYear" runat="server" ControlToValidate="txtYear" Display="Dynamic" SetFocusOnError="true"
                        ErrorMessage="يجب اضافة سنة الدخل" ToolTip="يجب اضافة سنة الدخل">
                    <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                    <asp:CustomValidator ID="CustomValidator1" runat="server"
                        ToolTip="يجب اضافة سنة الدخل بشكل صحيح"
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
                        TextMode="MultiLine" placeholder="اضف ملاحظات نصيه لعملية الدخل . . . ."></asp:TextBox>
                </td>
            </tr>
        </table>
    </section>
    <br />
    <footer class="AddSupplierFooter">
        <asp:Button ID="BtnFinish" runat="server" Text="انهاء" CssClass="BtnNext" OnClick="BtnFinish_Click"
            UseSubmitBehavior="false"
            OnClientClick="this.disabled='true';this.value='Please wait....';" ValidationGroup="FinishGroup" />
        <div class="MsgDiv">
            <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
        </div>
    </footer>
</asp:Content>
