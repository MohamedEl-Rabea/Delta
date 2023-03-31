<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AddOrder.aspx.cs" Inherits="DeltaProject.CreateOrder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
    <style>
        .AddService {
            direction: rtl;
            width: 80%;
            margin: auto;
        }

        .RBLCategories {
            margin: 25px 0 20px 460px;
            width: 200px !important;
        }

        .addProduct {
            width: 90%;
            margin: auto;
        }
    </style>
    <script type="text/javascript" src="Script/ValidationScript.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#<%= txtClientName.ClientID%>').autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: "Services/GetNamesService.asmx/Get_Clients_Basic_Data",
                        data: "{ 'Client_Name': '" + request.term + "' }",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json;charset=utf-8",
                        success: function (result) {
                            response(result.d.map(r => ({ label: r.Item1, value: r.Item1, phone: r.Item2 })));
                        },
                        error: function (result) {
                            alert('Problem');
                        }
                    });
                },
                select: function (event, ui) {
                    $('#<%= txtPhoneNumber.ClientID%>').val(ui.item.phone.toString());
                    $('#<%= txtPhoneNumber.ClientID%>').change();
                }
            });
        });

        $(function () {
            $('#<%= txtProductName.ClientID%>').autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: "Services/GetProductsNames.asmx/Get_Products_Names",
                        data: "{ 'p_name': '" + request.term + "' }",
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
            $('#<%= DeliveryDate.ClientID%>').datepicker(options);
            $('#<%= DeliveryDate.ClientID%>').datepicker("setDate", new Date());
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">

    <asp:Panel runat="server" ID="PanelAddOrder">
        <header class="Header">
            <p>اضافــــة طلبية</p>
        </header>

        <asp:Panel runat="server" ID="PanelOrderBasicInfo" Visible="True">
            <table class="AddProductsTable">
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">اسم العميل :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtClientName" CssClass="txts3" PlaceHolder="اسم العميل" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                    <td class="RHSTD">
                        <p class="RHSP" style="white-space: nowrap">رقم التليفون :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtPhoneNumber" CssClass="txts3" PlaceHolder="رقم التليفون" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                            ControlToValidate="txtClientName" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="اسم العميل متطلب اساسى" ValidationGroup="NextGroup">
                        <img src="Images/Error.png" width="15" height="15"/>
                        </asp:RequiredFieldValidator>
                    </td>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                            ControlToValidate="txtPhoneNumber" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="رقم التليفون متطلب اساسى" ValidationGroup="NextGroup">
                        <img src="Images/Error.png" width="15" height="15"/>
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator1" runat="server"
                            ToolTip="يجب كتابة الرقم بشكل صحيح"
                            ControlToValidate="txtPhoneNumber"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ClientValidationFunction="IsValidNumber"
                            ValidationGroup="NextGroup">
                        <img src="Images/Error.png" width="15" height="15"/>
                        </asp:CustomValidator>
                    </td>
                </tr>

                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">ت. التسليم :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="DeliveryDate" CssClass="txts3" PlaceHolder="تاريخ التسليم المتوقع" DataFormatString="{0:dd/MM/yyyy}"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                            ControlToValidate="DeliveryDate" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="تاريخ التسليم متطلب اساسى"
                            ValidationGroup="NextGroup">
                        <img src="Images/Error.png" width="15" height="15"/>
                        </asp:RequiredFieldValidator>
                    </td>
                </tr>
            </table>
            <footer class="AddSupplierFooter">
                <asp:Button ID="BtnNext" runat="server" Text="التالى" CssClass="BtnNext" OnClick="BtnNext_Click" ValidationGroup="NextGroup" />
            </footer>
        </asp:Panel>

        <asp:Panel runat="server" ID="PanelOrderDetails" Visible="False">

            <header style="text-align: left">
                <asp:LinkButton ID="lnkBackToBasicDetails" runat="server" CssClass="lnk" CausesValidation="false" OnClick="lnkBackToBasicDetails_OnClick">رجوع</asp:LinkButton>
            </header>

            <asp:RadioButtonList ID="RadioButtonListCategories" runat="server" RepeatDirection="Horizontal"
                CssClass="RBLCategories"
                OnSelectedIndexChanged="RadioButtonListCategories_SelectedIndexChanged"
                AutoPostBack="true">
                <asp:ListItem Value="Products" Selected="True">منتجات</asp:ListItem>
                <asp:ListItem Value="Services">خدمات</asp:ListItem>
            </asp:RadioButtonList>

            <asp:Panel runat="server" ID="PanelProductSearch" Visible="True">
                <section class="Search_Section">
                    <table class="Search_table">
                        <tr>
                            <td class="Image_td">
                                <asp:ImageButton ID="ImageButtonSearch" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                                    Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearch_Click" />
                            </td>
                            <td class="Search_td">
                                <asp:TextBox ID="txtProductName" runat="server" AutoCompleteType="Disabled" CssClass="Search_TextBox"
                                    placeholder="اسم المنتج للبحث . . . . ."></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                </section>

                <asp:GridView ID="GridViewProducts" runat="server" AutoGenerateColumns="false"
                    CssClass="GridViewList addProduct" EmptyDataText="لا توجد منتجات" Visible="True">
                    <Columns>
                        <asp:BoundField DataField="P_Name" HeaderText="الاسم" />
                        <asp:TemplateField HeaderText="الكميه المطلوبة">
                            <ItemTemplate>
                                <asp:TextBox ID="txtAmount" CssClass="EditTxt" runat="server" AutoCompleteType="Disabled" placeholder="الكميه"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                                    ControlToValidate="txtAmount" Display="Dynamic" SetFocusOnError="true"
                                    ToolTip="الكميه متطلب اساسى" ValidationGroup="<%# Container.DataItemIndex %>">
                                <img src="Images/Error.png" width="15" height="15"/>
                                </asp:RequiredFieldValidator>
                                <asp:CustomValidator ID="CustomValidator2" runat="server" ToolTip="يجب كتابة الكميه بشكل صحيح"
                                    ControlToValidate="txtAmount"
                                    Display="Dynamic"
                                    SetFocusOnError="true"
                                    ForeColor="Red"
                                    ValidationGroup="<%# Container.DataItemIndex %>"
                                    ClientValidationFunction="IsValidDecimal">
                                <img src="Images/Error.png" width="15" height="15"/>
                                </asp:CustomValidator>
                                <asp:CustomValidator ID="CustomValidator3" runat="server" SetFocusOnError="true" Display="Dynamic"
                                    ControlToValidate="txtAmount" ClientValidationFunction="IsValidNumber" ToolTip="يجب الا تقل الكميه عن 1"
                                    ValidationGroup="<%# Container.DataItemIndex %>">
                                <img src="Images/Error.png" width="15" height="15"/>
                                </asp:CustomValidator>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:Button ID="btnAddProduct" runat="server" Text="اضافه" CssClass="BtnaddInGrid" OnClick="btnAddProduct_OnClick" ValidationGroup="<%# Container.DataItemIndex %>" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle CssClass="HeaderStyleList" />
                    <RowStyle CssClass="RowStyleListHigher" />
                    <AlternatingRowStyle CssClass="AlternateRowStyleListHigher" />
                    <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                    <SelectedRowStyle CssClass="SelectedRowStyle" />
                </asp:GridView>
                <br />
            </asp:Panel>

            <asp:Panel runat="server" ID="PanelServiceSearch" Visible="False">
                <table class="AddService">
                    <tr>
                        <td>
                            <p class="RHSP">اسم الخدمة :</p>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtServiceName" CssClass="EditTxtFreeItemPrice" PlaceHolder="اسم الخدمة"
                                AutoCompleteType="Disabled" Width="90%"></asp:TextBox>
                        </td>

                        <td class="RHSTD">
                            <p class="RHSP">الكميه :</p>
                        </td>
                        <td style="text-align: right">
                            <asp:TextBox runat="server" ID="txtServiceAmount" CssClass="EditTxtFreeItemPrice" PlaceHolder="الكميه" AutoCompleteType="Disabled"></asp:TextBox>
                        </td>

                        <td class="RHSTD">
                            <asp:Button ID="btnAddService" runat="server" Text="اضافه" CssClass="BtnaddInGrid" ValidationGroup="AddServiceGroup" OnClick="btnAddService_OnClick" />
                        </td>
                    </tr>
                    <tr>
                        <td class="RHSTD">
                            <br />
                            <br />
                        </td>
                        <td class="ValodationTD">
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server"
                                ControlToValidate="txtServiceName" Display="Dynamic" SetFocusOnError="true"
                                ToolTip="اسم الخدمة متطلب اساسى" ValidationGroup="AddServiceGroup">
                                <img src="Images/Error.png" width="15" height="15"/>
                            </asp:RequiredFieldValidator>
                        </td>

                        <td class="RHSTD">
                            <br />
                            <br />
                        </td>
                        <td class="ValodationTD">
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server"
                                ControlToValidate="txtServiceAmount" Display="Dynamic" SetFocusOnError="true"
                                ToolTip="الكميه متطلب اساسى" ValidationGroup="AddServiceGroup">
                            <img src="Images/Error.png" width="15" height="15"/>
                            </asp:RequiredFieldValidator>
                            <asp:CustomValidator ID="CustomValidator8" runat="server" ToolTip="يجب كتابة الكميه بشكل صحيح"
                                ControlToValidate="txtServiceAmount"
                                Display="Dynamic"
                                SetFocusOnError="true"
                                ForeColor="Red"
                                ValidationGroup="AddServiceGroup"
                                ClientValidationFunction="IsValidDecimal">
                                <img src="Images/Error.png" width="15" height="15"/>
                            </asp:CustomValidator>
                            <asp:CustomValidator ID="CustomValidator9" runat="server" SetFocusOnError="true" Display="Dynamic"
                                ControlToValidate="txtServiceAmount" ClientValidationFunction="IsValidNumber" ToolTip="يجب الا تقل الكميه عن 1"
                                ValidationGroup="AddServiceGroup">
                                <img src="Images/Error.png" width="15" height="15"/>
                            </asp:CustomValidator>
                        </td>

                        <td class="RHSTD">
                            <br />
                            <br />
                        </td>
                    </tr>
                </table>
            </asp:Panel>

        </asp:Panel>

        <br />
        <br />
        <asp:Panel runat="server" ID="PanelProductList" Visible="false">
            <section>
                <header class="ListHeader">
                    <p>قائمة المنتجـــــات</p>
                </header>
                <br />
                <asp:GridView runat="server" ID="GridViewProductsList" CssClass="GridViewList" AutoGenerateColumns="False" EmptyDataText="لا توجد منتجات"
                    OnRowCommand="GridViewProductsList_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="P_Name" HeaderText="الاسم" ReadOnly="true" />
                        <asp:BoundField DataField="Amount" HeaderText="الكميه المطلوبة" ReadOnly="true" />
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:ImageButton ID="ImageButtonDelete" runat="server" ImageUrl="~/Images/Delete.png" Width="16" Height="16"
                                    CausesValidation="false" CommandName="Delete_Row"
                                    OnClientClick="return confirm('سيتم مسح هذا البند من جدول الطلبيات . . . هل تريد المتابعه ؟');" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle CssClass="HeaderStyleList" />
                    <RowStyle CssClass="RowStyleList" />
                    <AlternatingRowStyle CssClass="AlternateRowStyleList" />
                    <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                </asp:GridView>
            </section>
            <br />
            <footer class="AddSupplierFooter">
                <asp:Button ID="btnFinish" runat="server" Text="انهاء" CssClass="BtnNext" OnClick="btnFinish_OnClick" />
            </footer>
        </asp:Panel>
    </asp:Panel>

    <asp:Panel runat="server" ID="PanelPreview" Visible="False">
        <header class="Header">
            <p>تفاصيل الطلبية</p>
        </header>
        <section>
            <table class="AddProductsTable" style="width: 98%">
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">اسم العميل :</p>
                    </td>
                    <td class="RHSTD">
                        <asp:Label runat="server" ID="lblClientName" Text='' />
                    </td>
                    <td class="RHSTD">
                        <p class="RHSP">رقم التليفون :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:Label runat="server" ID="lblPhoneNumber" Text='' />
                    </td>

                    <td class="RHSTD">
                        <p class="RHSP">ت. التسليم :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:Label runat="server" ID="lblDeliveryDate" Text='' />
                    </td>
                </tr>
            </table>

            <section>
                <br />
                <header class="ListHeader">
                    <p>قائمة المنتجـــــات</p>
                </header>
                <br />
                <asp:GridView runat="server" ID="GridViewPreviewProductList" CssClass="GridViewList" AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="P_Name" HeaderText="الاسم" ReadOnly="true" />
                        <asp:BoundField DataField="Amount" HeaderText="الكميه" ReadOnly="true" />
                    </Columns>
                    <HeaderStyle CssClass="HeaderStyleList" />
                    <RowStyle CssClass="RowStyleList" />
                    <AlternatingRowStyle CssClass="AlternateRowStyleList" />
                    <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                </asp:GridView>
            </section>
            <br />
            <footer class="AddSupplierFooter">
                <asp:Button ID="btnSave" runat="server" Text="حفظ" CssClass="BtnNext" OnClick="btnSave_OnClick" />
            </footer>
        </section>
    </asp:Panel>

    <footer class="AddSupplierFooter" style="text-align: center">
        <div class="MsgDiv">
            <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
        </div>
    </footer>

</asp:Content>
