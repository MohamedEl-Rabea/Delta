<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="ReturnSupplierProduct.aspx.cs" Inherits="DeltaProject.ReturnSupplierProduct" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(function () {
            $('#<%= ddlSuppliers.ClientID%>').select2();
        });

        $(function () {
            $('#<%= txtProductName.ClientID%>').autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: "Services/GetProductsNames.asmx/GetProductNames",
                        data: "{ 'name': '" + request.term + "' }",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json;charset=utf-8",
                        success: function (result) {
                            response(result.d.map(r => ({ label: r.Item2, value: r.Item2, productId: r.Item1 })));
                        },
                        error: function () {
                            alert('Problem');
                        }
                    });
                },
                select: function (event, ui) {
                    $('#<%= txtProductId.ClientID%>').val(ui.item.productId.toString());
                    $('#<%= txtProductId.ClientID%>').change();
                }
            });
        });

        $(function dtTimePicker() {
            var options = $.extend(
                {},
                $.datepicker.regional["ar"],
                {
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'dd/mm/yy'
                }
            );
            var dateInputs = $(".dateInput");
            if (dateInputs != undefined)
                dateInputs.datepicker(options);
        });
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>مرتجع منتجات موردين</p>
    </header>
    <section class="Search_Section">
        <table class="Search_table">
            <tr>
                <td class="Image_td">
                    <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                        Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearch_Click" />
                </td>
                <td class="Search_td select2NoBorder" colspan="2">
                    <asp:DropDownList ID="ddlSuppliers" runat="server" CssClass="Search_TextBox_md"
                        Style="height: auto"
                        DataTextField="Name"
                        DataValueField="Id"
                        AutoPostBack="True"
                        OnSelectedIndexChanged="ddlSuppliers_OnSelectedIndexChanged">
                    </asp:DropDownList>
                </td>
                <td class="Search_td">
                    <asp:TextBox runat="server" ID="txtProductId" CssClass="txts3 NoDispaly" Text="0"></asp:TextBox>
                    <asp:TextBox ID="txtProductName" runat="server" AutoCompleteType="Disabled" CssClass="Search_TextBox_md left_border"
                        placeholder="اسم المنتج للبحث . . . . ."></asp:TextBox>
                </td>
            </tr>
        </table>
    </section>
    <asp:Panel runat="server" ID="PanelInvoices" CssClass="PanelProductList" Visible="false">
        <asp:GridView ID="GridViewInvoices" runat="server" AutoGenerateColumns="false"
            CssClass="GridViewList"
            DataKeyNames="Id"
            EmptyDataText="لا توجد فواتير"
            OnRowCommand="GridViewInvoices_OnRowCommand">
            <Columns>
                <asp:BoundField DataField="Id" HeaderText="رقم الفاتوره" />
                <asp:BoundField DataField="SupplierName" HeaderText="اسم المورد" />
                <asp:BoundField DataField="Date" HeaderText="تاريخ الفاتوره"  DataFormatString="{0:dd/MM/yyyy}" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton ID="LinkButtonSelect" runat="server" CommandName="Select" Font-Underline="false">اختر . . .</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <HeaderStyle CssClass="HeaderStyleList" />
            <RowStyle CssClass="RowStyleListHigher" />
            <AlternatingRowStyle CssClass="AlternateRowStyleListHigher" />
            <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
        </asp:GridView>
    </asp:Panel>
    <asp:Panel ID="PanelProducts" runat="server" CssClass="PanelSuppliersList" Visible="true">
        <asp:GridView ID="GridViewProducts" runat="server" AutoGenerateColumns="false"
            CssClass="Gridview_Style2"
            DataKeyNames="Id"
            EmptyDataText="لا يوجد منتجات !">
            <Columns>
                <asp:BoundField DataField="Id" SortExpression="Id" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                <asp:BoundField DataField="Name" HeaderText="اسم المنتج" />
                <asp:BoundField DataField="PurchasePrice" HeaderText="سعر الشراء" DataFormatString="{0:0.##}" />
                <asp:BoundField DataField="Quantity" HeaderText="الكميه" DataFormatString="{0:0.##}" />
                <asp:BoundField DataField="UnitName" HeaderText="الوحده" />
                <asp:TemplateField HeaderText="المرتجع">
                    <ItemTemplate>
                        <asp:TextBox ID="txtReturnedQuantity" CssClass="EditTxt" runat="server" AutoCompleteType="Disabled" Style="height: 22px;" placeholder="الكميه"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                            ControlToValidate="txtReturnedQuantity" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="الكميه متطلب اساسى" ValidationGroup="<%# Container.DataItemIndex %>">
                                <img src="Images/Error.png" width="15" height="15"/>
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator5" runat="server"
                            ValidationGroup="<%# Container.DataItemIndex %>"
                            ToolTip="يجب كتابة الكميه بشكل صحيح"
                            ControlToValidate="txtReturnedQuantity"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ClientValidationFunction="IsValidDecimal">
                                <img src="Images/Error.png" width="15" height="15"/>
                        </asp:CustomValidator>
                        <asp:CustomValidator ID="CustomValidator6" runat="server" SetFocusOnError="true" Display="Dynamic"
                            ControlToValidate="txtReturnedQuantity" ClientValidationFunction="IsValidNumber" ToolTip="يجب الا تقل الكميه عن 1" ValidationGroup="<%# Container.DataItemIndex %>">
                            <img src="Images/Error.png" width="15" height="15"/>
                        </asp:CustomValidator>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="تاريخ المرتجع">
                    <ItemTemplate>
                        <asp:TextBox runat="server" ID="txtReturnDate" ClientIDMode="AutoID" CssClass="EditTxt dateInput" PlaceHolder="تاريخ المرتجع" Style="height: 22px;" AutoCompleteType="Disabled"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                            ControlToValidate="txtReturnDate" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="تاريخ المرتجع متطلب اساسى" ValidationGroup="<%# Container.DataItemIndex %>">
                                <img src="Images/Error.png" width="15" height="15"/>
                        </asp:RequiredFieldValidator>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField SortExpression="Id">
                    <ItemTemplate>
                        <asp:Button ID="btnReturn" runat="server" Text="ارجاع" CssClass="BtnaddInGrid" OnClick="btnReturn_OnClick" ValidationGroup="<%# Container.DataItemIndex %>" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <HeaderStyle CssClass="HeaderStyleList" />
            <RowStyle CssClass="RowStyleList" />
            <AlternatingRowStyle CssClass="AlternateRowStyleList" />
            <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
        </asp:GridView>
    </asp:Panel>
    <footer class="AddSupplierFooter">
        <div class="MsgDiv">
            <asp:Label ID="lblMsg" runat="server" CssClass="MessageLabel"></asp:Label>
        </div>
    </footer>
</asp:Content>
