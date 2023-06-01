<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AddSupplierPayment.aspx.cs" Inherits="DeltaProject.AddSupplierPayment" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(function () {
            $('#<%= ddlSuppliers.ClientID%>').select2();
        });

        $(function () {
            var options = $.extend(
                {},
                $.datepicker.regional["ar"],
                {
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'dd/mm/yy',
                }
            );
            $('#<%= txtPaymentDate.ClientID%>').datepicker(options);
            $('#<%= txtPaymentDate.ClientID%>').datepicker("setDate", new Date());
        });

        function SetTarget() {
            document.forms[0].target = "_blank";
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>دفع لمورد</p>
    </header>
    <asp:RadioButtonList ID="RadioButtonListCategories" runat="server" RepeatDirection="Horizontal" CssClass="RBLCategories2"
        OnSelectedIndexChanged="RadioButtonListCategories_SelectedIndexChanged" AutoPostBack="true">
        <asp:ListItem Value="SupplierName" Selected="True">اسم المورد</asp:ListItem>
        <asp:ListItem Value="PhoneNumber">رقم التليفون</asp:ListItem>
    </asp:RadioButtonList>
    <section class="Search_Section">
        <table class="Search_table">
            <tr>
                <td class="Image_td">
                    <asp:ImageButton ID="ImageButtonSearch" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                        Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearch_Click"/>
                </td>
                <td class="Search_td select2NoBorder">
                    <asp:DropDownList ID="ddlSuppliers" runat="server" CssClass="Search_TextBox"
                                      Style="height: auto"
                                      DataTextField="Name"
                                      DataValueField="Id"
                                      AutoPostBack="True">
                    </asp:DropDownList>
                    <asp:TextBox ID="txtPhoneNumber" runat="server" AutoCompleteType="Disabled" Visible="false" CssClass="Search_TextBox"
                        placeholder="رقم التليفون للبحث . . . . ."></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td></td>
                <td style="text-align: center">
                    <asp:CustomValidator ID="CustomValidator1" runat="server"
                        ToolTip="يجب كتابة الرقم بشكل صحيح"
                        ControlToValidate="txtPhoneNumber"
                        Display="Dynamic"
                        SetFocusOnError="true"
                        ClientValidationFunction="IsValidNumber">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:CustomValidator>
                </td>
            </tr>
        </table>
    </section>
    <asp:Panel runat="server" ID="PanelSupplierData" Visible="False">
        <table class="AddProductsTable">
            <tr>
                <td class="RHSTD" style="width: 10%">
                    <p class="RHSP">اسم المـــورد :</p>
                </td>
                <td style="text-align: right;width: 40%">
                    <asp:HiddenField ID="lblSupplierId" runat="server" />
                    <asp:Label ID="lblSupplierName" runat="server" CssClass="lblInfo"></asp:Label>
                </td>
                <td class="RHSTD" style="width: 10%">
                    <p class="RHSP">صافى الحساب :</p>
                </td>
                <td style="text-align: right;width: 40%">
                    <asp:LinkButton ID="lnkStatement" runat="server" CssClass="lnkbtnSelect" OnClientClick="SetTarget();"
                                    CausesValidation="false" OnClick="lnkStatement_OnClick" Text=""></asp:LinkButton>
                </td>
            </tr>
        </table>
    </asp:Panel>
    <br/>
    <asp:Panel runat="server" ID="PanelPayment" Visible="False">
        <table class="AddProductsTable">
            <tr>
                <td class="RHSTD" style="width: 10%">
                    <p class="RHSP">القيمة :</p>
                </td>
                <td style="text-align: right;width: 40%">
                    <asp:TextBox runat="server" ID="txtPaidAmount" CssClass="txts3" PlaceHolder="القيمه المدفوعه" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
                <td class="RHSTD" style="width: 10%">
                    <p class="RHSP">تاريخ :</p>
                </td>
                <td style="text-align: right;width: 40%">
                    <asp:TextBox runat="server" ID="txtPaymentDate" CssClass="txts3" PlaceHolder="تاريخ الدفع"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
                <td class="ValodationTD">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                                                ControlToValidate="txtPaidAmount" Display="Dynamic" SetFocusOnError="true"
                                                ToolTip="القيمة المدفوعه متطلب اساسى"
                                                ValidationGroup="SupplierTabGroup">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                    <asp:CustomValidator ID="CustomValidatorPaidAmount" runat="server"
                                         ToolTip="يجب كتابة القيمة المدفوعه بشكل صحيح"
                                         ControlToValidate="txtPaidAmount"
                                         Display="Dynamic"
                                         SetFocusOnError="true"
                                         ForeColor="Red"
                                         ValidateEmptyText="true"
                                         ClientValidationFunction="IsValidNumber"
                                         ValidationGroup="SaveGroup">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:CustomValidator>
                </td>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
                <td class="ValodationTD">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                        ControlToValidate="txtPaymentDate" Display="Dynamic" SetFocusOnError="true"
                        ToolTip="تاريخ الدفع متطلب اساسى"
                        ValidationGroup="SupplierTabGroup">
                            <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class="RHSTD" style="vertical-align: top">
                    <p class="RHSP" style="width: 10%">ملاحظات :</p>
                </td>
                <td colspan="3" style="width: 90%">
                    <asp:TextBox ID="txtNotes" runat="server" CssClass="TxtMultiline" AutoCompleteType="Disabled"
                                 Width="98%" TextMode="MultiLine" placeholder="ملاحظات"></asp:TextBox>
                </td>
            </tr>
        </table>
        <footer>
            <div class="MsgDiv" style="text-align: center">
                <asp:Button ID="btnPay" runat="server" Text="دفع" CssClass="BtnNext" OnClick="btnPay_Click" />
            </div>
            <div class="MsgDiv">
                <asp:Label ID="lblSaveMsg" runat="server" CssClass="MessageLabel" ForeColor="Green"></asp:Label>
            </div>
        </footer>
    </asp:Panel>

    <asp:Panel ID="PanelErrorMessage" runat="server" CssClass="ErrorMessagePanal" Visible="false">
        <article class="Errorarticle">
            <asp:Label ID="LabelErrMsg" runat="server" CssClass="LblErrorMsg2" Text="هذا المورد غير مسجل لدينا ... اما هناك خطأ فى الاسم او رقم التليفون"></asp:Label>
        </article>
    </asp:Panel>
</asp:Content>
