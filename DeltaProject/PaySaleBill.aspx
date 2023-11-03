<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="PaySaleBill.aspx.cs" Inherits="DeltaProject.PaySaleBill" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .GridViewBillItems .HeaderStyleBill, .GridViewBillItems .RowStyleList, .GridViewBillItems .AlternateRowStyleList {
            font-size: 16px;
        }
    </style>
    <script type="text/javascript" src="Script/ServiseHandler.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#<%= txtClientName.ClientID%>').autocomplete({
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
    <asp:Panel runat="server" ID="PanelSearchClient">
        <header class="Header">
            <p>دفع فواتير</p>
        </header>
        <asp:RadioButtonList ID="RadioButtonListCategories" runat="server" RepeatDirection="Horizontal" CssClass="RBLCategories"
            OnSelectedIndexChanged="RadioButtonListCategories_SelectedIndexChanged" AutoPostBack="true">
            <asp:ListItem Value="ClientName" Selected="True">اسم العميل</asp:ListItem>
            <asp:ListItem Value="PhoneNumber">رقم التليفون</asp:ListItem>
            <asp:ListItem Value="BillNumber">رقم الفاتورة</asp:ListItem>
        </asp:RadioButtonList>
        <section class="Search_Section">
            <table class="Search_table">
                <tr>
                    <td class="Image_td">
                        <asp:ImageButton ID="ImageButtonSearch" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                            Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearch_Click" />
                    </td>
                    <td class="Search_td">
                        <asp:TextBox ID="txtClientName" runat="server" AutoCompleteType="Disabled" CssClass="Search_TextBox"
                            placeholder="اسم العميل للبحث . . . . ."></asp:TextBox>
                        <asp:TextBox ID="txtPhoneNumber" runat="server" AutoCompleteType="Disabled" Visible="false" CssClass="Search_TextBox"
                            placeholder="رقم التليفون للبحث . . . . ."></asp:TextBox>
                        <asp:TextBox ID="txtBillId" runat="server" AutoCompleteType="Disabled" Visible="false" CssClass="Search_TextBox"
                            placeholder="رقم الفاتورة للبحث . . . . ."></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td style="text-align: center">
                        <asp:CustomValidator ID="CustomValidator2" runat="server"
                            ToolTip="يجب كتابة الرقم بشكل صحيح"
                            ControlToValidate="txtPhoneNumber"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ClientValidationFunction="IsValidNumber">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                        <asp:CompareValidator ID="CompareValidator1" runat="server"
                            ControlToValidate="txtBillId"
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
    </asp:Panel>
    <asp:Panel ID="PanelErrorMessage" runat="server" CssClass="ErrorMessagePanal" Visible="false">
        <article class="Errorarticle">
            <asp:Label ID="LabelErrMsg" runat="server" CssClass="LblErrorMsg2" Text="هذا العميل/الرقم غير مسجل لدينا ... اما هناك خطأ فى الاسم/الرقم او لو يدرج اى اسم/رقم"></asp:Label>
        </article>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelBills" CssClass="PreReport_SectionTab" Visible="false">
        <asp:GridView ID="GridViewBills" runat="server" AutoGenerateColumns="False" OnRowCommand="GridViewBills_RowCommand"
            CssClass="Gridview_Style2" EmptyDataText="لا توجد فواتير لهذا العميل / الرقم"
            AllowPaging="True"
            OnPageIndexChanging="GridViewBills_OnPageIndexChanging">
            <Columns>
                <asp:BoundField DataField="Date" HeaderText="تاريخ الفاتورة" SortExpression="Date" DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="ClientName" HeaderText="اسم العميل" SortExpression="ClientName" />
                <asp:TemplateField HeaderText="رقم الفاتورة" SortExpression="Id">
                    <ItemTemplate>
                        <asp:LinkButton ID="linkBillId" runat="server" Text='<%# Bind("Id") %>' ToolTip="الانتقال الى كامل بيانات الفاتورة" CommandName="SelectBill"></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <RowStyle CssClass="Row_Style" />
            <PagerStyle CssClass="PagerStyle" HorizontalAlign="Center" />
            <EmptyDataRowStyle CssClass="Empty_Style" />
        </asp:GridView>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelBillDetails" Visible="false">
        <section class="ContactsSection" style="border-radius: 8px; width: 99%; text-align: right; direction: rtl; padding: 10px;">
            <header class="Prices_Offer_SubHeaderBill" style="margin-bottom: 10px;">
                <div style="border: 1px solid black">
                    <p style="font: bold 13px arial; margin: 0; padding: 0">بيانات العرض</p>
                </div>
            </header>
            <table class="AddProductsTable">
                <tr>
                    <td>
                        <asp:Label ID="Label1" runat="server" Text="تاريخ العرض : " CssClass="lblInfo"></asp:Label>
                    </td>
                    <td style="width: 125px">
                        <asp:Label ID="lblBillDate" runat="server" CssClass="lblInfo2"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="Label2" runat="server" Text="رقم العرض : " CssClass="lblInfo"></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblBillId" runat="server" CssClass="lblInfo2"></asp:Label>
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
                        <asp:Label ID="Label5" runat="server" CssClass="lblInfo" Text="الاجمالى : "></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblBillCost" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="lblAddtionalCost" runat="server" CssClass="lblInfo" Text="تكلفة اضافيه : "></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblAddtionalCostValue" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="Label8" runat="server" CssClass="lblInfo" Text="المدفوع : "></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblPaidValue" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="Label9" runat="server" CssClass="lblInfo" Text="المتبقى : "></asp:Label>
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
                        <asp:Label ID="lblPreAdditionalcostNotes" runat="server" CssClass="lblInfo" Text="ملاحظات التكلفه الاضافيه : "></asp:Label>
                    </td>
                    <td colspan="5">
                        <asp:Label ID="lblAdditionalcostNotes" runat="server" CssClass="lblInfo2" Text=" ملاحظات التكلفه الاضافيه"></asp:Label>
                    </td>
                </tr>
            </table>
        </section>
        <br />
        <br />
        <section class="ContactsSection" style="border: 0; width: 99%; text-align: right; direction: rtl; padding: 10px;">
            <header class="Prices_Offer_SubHeaderBill" style="margin-bottom: 10px;">
                <div style="border: 1px solid black">
                    <p style="font: bold 13px arial; margin: 0; padding: 0">محتويات الفاتورة</p>
                </div>
            </header>
            <asp:GridView runat="server" ID="GridViewBillItems" CssClass="GridViewBill GridViewBillItems" AutoGenerateColumns="False" EmptyDataText="لا توجد منتجات">
                <Columns>
                    <asp:BoundField DataField="Id" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                    <asp:BoundField DataField="Name" HeaderText="اسم المنتج" />
                    <asp:BoundField DataField="UnitName" HeaderText="الوحدة" />
                    <asp:BoundField DataField="SoldQuantity" HeaderText="الكميه" DataFormatString="{0:0.##}" />
                    <asp:BoundField DataField="ReturnedQuantity" HeaderText="المرتجع" DataFormatString="{0:0.##}" />
                    <asp:BoundField DataField="SpecifiedPrice" HeaderText="سعر الوحده" DataFormatString="{0:0.##}" />
                    <asp:BoundField DataField="Discount" HeaderText="الخصم" DataFormatString="{0:0.##}" />
                    <asp:BoundField DataField="TotalCost" HeaderText="الاجمالى" DataFormatString="{0:0.##}" />
                </Columns>
                <HeaderStyle CssClass="HeaderStyleBill" />
                <RowStyle CssClass="RowStyleList" />
                <AlternatingRowStyle CssClass="AlternateRowStyleList" />
                <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                <FooterStyle CssClass="FooterStyleBill" />
            </asp:GridView>
        </section>
        <br />
        <br />
        <section>
            <table class="AddProductsTable">
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">القيمة :</p>
                    </td>
                    <td style="text-align: right" colspan="4">
                        <asp:TextBox runat="server" ID="txtRemainingCost" CssClass="NoDispaly" Text='0'></asp:TextBox>
                        <asp:TextBox runat="server" ID="txtPaidAmount" CssClass="txts2" PlaceHolder="القيمه المدفوعه" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td style="text-align: center" colspan="4">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                            ControlToValidate="txtPaidAmount" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="القيمة المدفوعه متطلب اساسى" ValidationGroup="finishGroup">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator3" runat="server"
                            ToolTip="يجب كتابة القيمة المدفوعه و بشكل صحيح"
                            ControlToValidate="txtPaidAmount"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ValidateEmptyText="true"
                            ValidationGroup="finishGroup"
                            ClientValidationFunction="IsValidNumber">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                        <asp:CompareValidator ID="CompareValidator2" runat="server" ControlToValidate="txtPaidAmount"
                            Operator="LessThanEqual" ControlToCompare="txtRemainingCost"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ErrorMessage="CompareValidator"
                            Type="Double"
                            ToolTip="يجب الا تزيد القيمة المدفوعة عن المبلغ المتبقى"
                            ValidationGroup="finishGroup">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CompareValidator>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">تاريخ الدفع :</p>
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
                            ErrorMessage="يجب اضافة يوم الدفع" ToolTip="يجب اضافة يوم الدفع" ValidationGroup="finishGroup">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:RangeValidator ID="RangeValidatorDay" runat="server" ErrorMessage="RangeValidator" Display="Dynamic"
                            ControlToValidate="txtDay" Type="Integer" MinimumValue="1" MaximumValue="31" ToolTip="يجب اضافة اليوم بشكل صحيح مابين 1-31" ValidationGroup="finishGroup">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RangeValidator>
                    </td>
                    <td style="text-align: center">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorMonth" runat="server" ControlToValidate="txtMonth" Display="Dynamic" SetFocusOnError="true"
                            ErrorMessage="يجب اضافة شهر الدفع" ToolTip="يجب اضافة شهر الدفع" ValidationGroup="finishGroup">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:RangeValidator ID="RangeValidatorMonth" runat="server" ErrorMessage="RangeValidator" Display="Dynamic"
                            ControlToValidate="txtMonth" Type="Integer" MinimumValue="1" MaximumValue="12" ToolTip="يجب اضافة اليوم بشكل صحيح مابين 1-12" ValidationGroup="finishGroup">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RangeValidator>
                    </td>
                    <td style="text-align: center">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorYear" runat="server" ControlToValidate="txtYear" Display="Dynamic" SetFocusOnError="true"
                            ErrorMessage="يجب اضافة سنة الدفع" ToolTip="يجب اضافة سنة الدفع" ValidationGroup="finishGroup">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator1" runat="server"
                            ToolTip="يجب اضافة سنة الدفع بشكل صحيح"
                            ControlToValidate="txtYear"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ClientValidationFunction="IsValidYear" ValidationGroup="finishGroup">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td class="RHSTD" style="vertical-align: top">
                        <p class="RHSP">ملاحظـات :</p>
                    </td>
                    <td class="td_txts" colspan="4">
                        <asp:TextBox ID="txtNotes" runat="server" CssClass="TxtMultiline" AutoCompleteType="Disabled"
                            TextMode="MultiLine" placeholder="اضف ملاحظات نصيه لعملية الدفع . . . ."></asp:TextBox>
                    </td>
                </tr>
            </table>
            <footer class="AddSupplierFooter">
                <asp:Button ID="btnFinish" runat="server" Text="انهاء" CssClass="BtnNext"
                    UseSubmitBehavior="false" ValidationGroup="finishGroup"
                    OnClick="btnFinish_Click" />
                <div class="MsgDiv">
                    <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
                </div>
            </footer>
        </section>
    </asp:Panel>
    <div class="MsgDiv">
        <asp:Label ID="lblErrorMsg" runat="server" CssClass="MessageLabel"></asp:Label>
    </div>
</asp:Content>
