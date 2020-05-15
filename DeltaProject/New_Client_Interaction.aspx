<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="New_Client_Interaction.aspx.cs" Inherits="DeltaProject.New_Client_Interaction" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="Script/ServiseHandler.js"></script>
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
    <link href="CSS/jquery-ui-1.10.4.custom.min.css" rel="stylesheet" />
    <script src="Script/jquery-1.10.2.js"></script>
    <script src="Script/jquery-ui-1.10.4.custom.min.js"></script>
    <script type="text/javascript" src="Script/ValidationScript.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#<%= txtClient_Name.ClientID%>').autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: "Services/GetNamesService.asmx/Get_Clients_Names",
                        data: "{ 'Client_Name': '" + request.term + "' }",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json;charset=utf-8",
                        success: function (result) {
                            response(result.d);
                        },
                        error: function (result) {
                            alert('Problem');
                        }
                    });
                }
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <asp:Panel ID="PanelPaymentInfo" runat="server">
        <header class="Header">
            <p>تعامل مادى جديد موردين</p>
        </header>
        <section>
            <section class="ChoicesSection">
                <table class="AddProductsTable">
                    <tr>
                        <td class="RHSTD">
                            <p class="RHSP">نوع العمليــه :</p>
                        </td>
                        <td style="text-align: right">
                            <asp:RadioButtonList ID="rblPaymentType" ClientIDMode="Static" runat="server" CssClass="ChoiceRadioList" RepeatDirection="Horizontal">
                                <asp:ListItem Text="دفع" Value="ToClient" />
                                <asp:ListItem Text="استحقاق" Value="FromClient" />
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <br />
                        </td>
                    </tr>
                </table>
            </section>
            <table class="AddProductsTable">
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">اسم العميل :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtClient_Name" CssClass="txts2" PlaceHolder="اسم العميل" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td style="text-align: center">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                            ControlToValidate="txtClient_Name" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="اسم العميل متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">القيمــــــــــــة :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtPaid_amount" CssClass="txts2" PlaceHolder="القيمه المدفوعه" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
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
        </section>
        <br />
        <footer class="AddSupplierFooter">
            <asp:Button ID="BtnFinish" runat="server" Text="انهاء" CssClass="BtnNext" OnClick="BtnFinish_Click"
                UseSubmitBehavior="false"
                OnClientClick="this.disabled='true';this.value='Please wait....';" ValidationGroup="FinishGroup" />
            <div class="MsgDiv">
                <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
            </div>
            <div class="MsgDiv" style="text-align: right">
                <asp:Panel runat="server" ID="PanelLink" Visible="false">
                    <table style="float: right; direction: rtl">
                        <tr>
                            <td>
                                <p class="UnStyled">اذا كنت تريد اضافة مرفقات تصويريه خاصه بعملية الدفع اضغط</p>
                            </td>
                            <td>
                                <asp:LinkButton ID="lnkBtnContacts" runat="server" CssClass="Link" OnClick="lnkBtnContacts_Click">هنا</asp:LinkButton>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </div>
        </footer>
        <div>
            <header class="alarm_Header">
                <p>تنويه</p>
            </header>
            <footer class="alarm_Footer">
                <p>- اذا كان نوع العمليه دفع فهو يوضح ان القيمة مدفوعه من الشركه للعميل</p>
                <p>- اذا كان نوع العمليه استحقاق فهو يوضح ان القيمة مدفوعه من العميل للشركه</p>
            </footer>
        </div>
    </asp:Panel>
</asp:Content>
