<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AddBillDiscount.aspx.cs" Inherits="DeltaProject.AddBillDiscount" %>

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
            <p>إضافة خصم على فاتورة</p>
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
            CssClass="Gridview_Style2" EmptyDataText="لا توجد فواتير لهذا العميل"
            DataSourceID="ObjectDataSourceBills" AllowPaging="True">
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
        <asp:ObjectDataSource ID="ObjectDataSourceBills" runat="server"
            SelectMethod="GetAllBills"
            TypeName="DeltaProject.Business_Logic.SaleBill"
            StartRowIndexParameterName="startIndex"
            MaximumRowsParameterName="maxRows"
            SelectCountMethod="GetBillsCount"
            EnablePaging="True">
            <SelectParameters>
                <asp:ControlParameter ControlID="txtClientName" Name="clientName" PropertyName="Text" Type="String" />
                <asp:ControlParameter ControlID="txtPhoneNumber" Name="phoneNumber" PropertyName="Text" Type="String" />
                <asp:ControlParameter ControlID="txtBillId" Name="billId" PropertyName="Text" Type="Int32" />
            </SelectParameters>
        </asp:ObjectDataSource>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelBillDetails" Visible="false">
        <section class="ContactsSection" style="border-radius: 8px; width: 99%; text-align: right; direction: rtl; padding: 10px;">
            <header class="Prices_Offer_SubHeaderBill" style="margin-bottom: 10px;">
                <div style="border: 1px solid black">
                    <p style="font: bold 13px arial; margin: 0; padding: 0">بيانات العرض</p>
                </div>
            </header>
            <asp:TextBox runat="server" ID="lblRemainingCost" CssClass="NoDispaly lblRemainingCost" Text='0'></asp:TextBox>
            <table class="AddProductsTable ReportHeader">
                <tr>
                    <td>
                        <asp:Label runat="server" Text="تاريخ العرض : " CssClass="lblInfo"></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblBillDate" runat="server" CssClass="lblInfo2" Text="01/01/0001"></asp:Label>
                    </td>
                    <td>
                        <asp:Label runat="server" Text="رقم العرض : " CssClass="lblInfo"></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblBillId" runat="server" CssClass="lblInfo2" Text="رقم العرض"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="Label1" runat="server" Text="العميل : " CssClass="lblInfo"></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblClientName" runat="server" CssClass="lblInfo2" Text="اسم العميل"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="Label2" runat="server" Text="العنوان : " CssClass="lblInfo"></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblAddress" runat="server" CssClass="lblInfo2" Text="عنوان العميل"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="Label6" runat="server" Text="رقم التليفون : " CssClass="lblInfo"></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblPhoneNumber" runat="server" CssClass="lblInfo2" Text="رقم التليفون"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <br />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label3" runat="server" CssClass="lblInfo" Text="الاجمالى : "></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblBillCost" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="lblAddtionalCost" runat="server" CssClass="lblInfo" Text="تكلفة اضافيه : "></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblAdditionalCostValue" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="Label4" runat="server" CssClass="lblInfo" Text="المدفوع : "></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblPaidValue" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="Label5" runat="server" CssClass="lblInfo" Text="اجمالى الخصم : "></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblGeneralDiscount" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
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
            <asp:GridView runat="server" ID="GridViewBillItems" CssClass="GridViewBill GridViewBillItems" AutoGenerateColumns="False" EmptyDataText="لا توجد منتجات"
                OnRowDataBound="GridViewBillItems_OnRowDataBound">
                <Columns>
                    <asp:BoundField DataField="Id" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                    <asp:BoundField DataField="ProductId" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                    <asp:BoundField DataField="Name" HeaderText="اسم المنتج" />
                    <asp:BoundField DataField="UnitName" HeaderText="الوحدة" />
                    <asp:BoundField DataField="SoldQuantity" HeaderText="الكميه" DataFormatString="{0:0.##}" />
                    <asp:BoundField DataField="ReturnedQuantity" HeaderText="المرتجع" DataFormatString="{0:0.##}" />
                    <asp:BoundField DataField="SpecifiedPrice" HeaderText="سعر الوحده" DataFormatString="{0:0.##}" />
                    <asp:BoundField DataField="Discount" HeaderText="الخصم الحالى" DataFormatString="{0:0.##}" />
                    <asp:BoundField DataField="TotalCost" HeaderText="الاجمالى" DataFormatString="{0:0.##}" />
                    <asp:BoundField DataField="IsService" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                    <asp:TemplateField HeaderText="الخصم">
                        <ItemTemplate>
                            <asp:TextBox runat="server" ID="txtTotalCost" CssClass="NoDispaly" Text='<%# Bind("TotalCost") %>'></asp:TextBox>
                            <asp:Label runat="server" ID="lblDiscount" CssClass="NoDispaly" Text='0'></asp:Label>
                            <asp:TextBox ID="txtDiscount" CssClass="EditTxt discount" runat="server" AutoCompleteType="Disabled" placeholder="الخصم"></asp:TextBox>
                            <asp:CustomValidator ID="CustomValidator9" runat="server"
                                ToolTip="يجب كتابة الخصم بشكل صحيح"
                                ControlToValidate="txtDiscount"
                                Display="Dynamic"
                                SetFocusOnError="true"
                                ClientValidationFunction="IsValidNumber"
                                ValidationGroup="finishGroup">
                                <img src="Images/Error.png" width="15" height="15"/>
                            </asp:CustomValidator>
                            <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToValidate="txtDiscount"
                                Operator="LessThanEqual" ControlToCompare="txtTotalCost"
                                Display="Dynamic"
                                SetFocusOnError="true"
                                ErrorMessage="CompareValidator"
                                Type="Double"
                                ToolTip="يجب الا يزيد الخصم عن اجمالى سعر المنتج"
                                ValidationGroup="finishGroup">
                                <img src="Images/Error.png" width="15" height="15"/>
                            </asp:CompareValidator>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <HeaderStyle CssClass="HeaderStyleBill" />
                <RowStyle CssClass="RowStyleList" />
                <AlternatingRowStyle CssClass="AlternateRowStyleList" />
                <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
            </asp:GridView>
        </section>
        <br />
        <br />
        <section>
            <table class="AddProductsTable">
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">تاريخ الخصم :</p>
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
                            ErrorMessage="يجب اضافة يوم الخصم" ToolTip="يجب اضافة يوم الخصم" ValidationGroup="finishGroup">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:RangeValidator ID="RangeValidatorDay" runat="server" ErrorMessage="RangeValidator" Display="Dynamic"
                            ControlToValidate="txtDay" Type="Integer" MinimumValue="1" MaximumValue="31" ToolTip="يجب اضافة اليوم بشكل صحيح مابين 1-31" ValidationGroup="finishGroup">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RangeValidator>
                    </td>
                    <td style="text-align: center">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorMonth" runat="server" ControlToValidate="txtMonth" Display="Dynamic" SetFocusOnError="true"
                            ErrorMessage="يجب اضافة شهر الخصم" ToolTip="يجب اضافة شهر الخصم" ValidationGroup="finishGroup">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:RangeValidator ID="RangeValidatorMonth" runat="server" ErrorMessage="RangeValidator" Display="Dynamic"
                            ControlToValidate="txtMonth" Type="Integer" MinimumValue="1" MaximumValue="12" ToolTip="يجب اضافة اليوم بشكل صحيح مابين 1-12" ValidationGroup="finishGroup">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RangeValidator>
                    </td>
                    <td style="text-align: center">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorYear" runat="server" ControlToValidate="txtYear" Display="Dynamic" SetFocusOnError="true"
                            ErrorMessage="يجب اضافة سنة الخصم" ToolTip="يجب اضافة سنة الخصم" ValidationGroup="finishGroup">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator1" runat="server"
                            ToolTip="يجب اضافة سنة الخصم بشكل صحيح"
                            ControlToValidate="txtYear"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ClientValidationFunction="IsValidYear" ValidationGroup="finishGroup">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                    </td>

                </tr>
                 <tr>
                    <td class="RHSTD">
                        <p class="RHSP">خصم عام :</p>
                    </td>
                    <td style="text-align: right; padding-left: 5px;" colspan="4">
                        <asp:TextBox runat="server" ID="txtGeneralDiscount" CssClass="txts2"
                            PlaceHolder="خصم عام على الفاتورة" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD"><br /><br /></td>
                    <td style="text-align: center" colspan="3">
                        <asp:CustomValidator ID="CustomValidator13" runat="server"
                            ToolTip="يجب كتابة الخصم بشكل صحيح"
                            ControlToValidate="txtGeneralDiscount"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ForeColor="Red"
                            ClientValidationFunction="IsValidNumber" ValidationGroup="finishGroup">
                                <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                         <asp:CustomValidator ID="CustomValidator3" runat="server"
                            ToolTip="يجب الا يزيد الخصم عن اجمالى الفاتوره"
                            ControlToValidate="txtGeneralDiscount"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ForeColor="Red"
                            ClientValidationFunction="IsValidGeneralDiscount" ValidationGroup="finishGroup">
                                <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD" style="vertical-align: top">
                        <p class="RHSP">ملاحظات الخصم العام :</p>
                    </td>
                    <td class="td_txts" colspan="4">
                        <asp:TextBox ID="txtGeneralDiscountNotes" runat="server" CssClass="TxtMultiline" AutoCompleteType="Disabled"
                            TextMode="MultiLine" placeholder="اضافة اى ملاحظات تتعلق بالخصم العام"></asp:TextBox>
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
            <asp:Panel runat="server" ID="PanelRest" Visible="false">
                <footer class="AddSupplierFooter">
                    <div class="MsgDiv" style="text-align: right">
                        <span>المتبقى من قيمة الفاتورة للعميل: 
                            <asp:Label ID="lblRestOfMoney" CssClass="bold" runat="server"></asp:Label>
                            للسداد اضغط
                        </span>
                        <asp:LinkButton ID="lnkPay" runat="server" CssClass="LinkL" OnClick="lnkPay_Click">
                            هنا</asp:LinkButton>
                    </div>
                </footer>
            </asp:Panel>
        </section>
    </asp:Panel>
</asp:Content>
