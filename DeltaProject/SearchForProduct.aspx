<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="SearchForProduct.aspx.cs" Inherits="DeltaProject.SearchForProduct" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
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
                        error: function (error) {
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>استعلام عن منتج</p>
    </header>
    <section class="Search_Section">
        <table class="Search_table">
            <tr>
                <td class="Image_td">
                    <asp:ImageButton ID="ImageButtonSearch" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                        Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearch_Click" />
                </td>
                <td class="Search_td">
                    <asp:TextBox runat="server" ID="txtProductId" CssClass="NoDispaly"></asp:TextBox>
                    <asp:TextBox ID="txtProductName" runat="server" AutoCompleteType="Disabled" CssClass="Search_TextBox"
                        placeholder="اسم المنتج للبحث . . . . ."></asp:TextBox>
                </td>
            </tr>
        </table>
    </section>
    <asp:Panel runat="server" ID="PanelInitailResult" CssClass="PanelProductList">
        <asp:GridView ID="GridViewProducts" runat="server" AutoGenerateColumns="false"
            OnRowCommand="GridViewProducts_RowCommand" CssClass="GridViewList" EmptyDataText="لا توجد منتجات">
            <Columns>
                <asp:BoundField DataField="Id" SortExpression="Id" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                <asp:BoundField DataField="Name" HeaderText="اسم المنتج" SortExpression="Name" />
                <asp:BoundField DataField="Mark" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                <asp:BoundField DataField="Inch" HeaderText="البوصه" ReadOnly="true" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                <asp:BoundField DataField="Style" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                <asp:BoundField DataField="Quantity" HeaderText="الكمية المتاحة" SortExpression="Quantity" DataFormatString="{0:0.##}" ItemStyle-CssClass="remainingQuantity" />
                <asp:BoundField DataField="UnitName" HeaderText="الوحدة" SortExpression="UnitName" />
                <asp:BoundField DataField="PurchasePrice" HeaderText="سعر الشراء" SortExpression="PurchasePrice" DataFormatString="{0:0.##}" />
                <asp:BoundField DataField="SellPrice" HeaderText="سعر البيع" SortExpression="SellPrice" DataFormatString="{0:0.##}" />
                <asp:BoundField DataField="Description" HeaderText="الوصف" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton ID="LnkSelect" runat="server" CssClass="lnkbtnSelect" CausesValidation="false">اختر</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <HeaderStyle CssClass="HeaderStyleList" />
            <RowStyle CssClass="RowStyleListHigher" />
            <AlternatingRowStyle CssClass="AlternateRowStyleListHigher" />
            <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
            <SelectedRowStyle CssClass="SelectedRowStyle" />
        </asp:GridView>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelDetailedResult" CssClass="ResultPanel" Visible="false">
        <%-- Product section --%>
        <header class="Product_Search_Header">
            <table class="ProductInfo_Header_Table">
                <tr>
                    <td>
                        <asp:ImageButton ID="ImageButtonExtendProduct" runat="server" ImageUrl="~/Images/Extend.png" Width="16" Height="16"
                            CausesValidation="false" ToolTip="EXtend" OnClick="ImageButtonExtendProduct_Click" />
                    </td>
                    <td>
                        <asp:ImageButton ID="ImageButtonCollapseProduct" runat="server" ImageUrl="~/Images/Collapse.png" Width="16" Height="16"
                            CausesValidation="false" ToolTip="Collapse" Visible="false" OnClick="ImageButtonCollapseProduct_Click" />
                    </td>
                    <td class="left_td">
                        <asp:LinkButton ID="LinkButtonPro_Info" runat="server" CssClass="Links" OnClick="LinkButtonPro_Info_Click">بيانات المنتــج</asp:LinkButton>
                    </td>
                </tr>
            </table>
        </header>
        <asp:Panel runat="server" ID="PanelProductDetails" CssClass="ResultPanel" Visible="false">
            <table class="AddProductsTable">
                <tr>
                    <td class="RHSTD2">
                        <p class="RHSP">اسم المنتج :</p>
                    </td>
                    <td>
                        <asp:Label ID="lblP_name" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                </tr>
            </table>
            <asp:Panel runat="server" ID="PanelMotors" Visible="false">
                <table class="AddProductsTable">
                    <tr>
                        <td class="RHSTD2">
                            <p class="RHSP">الماركة :</p>
                        </td>
                        <td>
                            <asp:Label ID="lblMark" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="RHSTD">
                            <br />
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td class="RHSTD2">
                            <p class="RHSP">البوصة :</p>
                        </td>
                        <td>
                            <asp:Label ID="lblInch" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="RHSTD">
                            <br />
                            <br />
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <asp:Panel runat="server" ID="PanelTol" Visible="false">
                <table class="AddProductsTable">
                    <tr>
                        <td class="RHSTD2">
                            <p class="RHSP">الطراز :</p>
                        </td>
                        <td>
                            <asp:Label ID="lblStyle" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="RHSTD">
                            <br />
                            <br />
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <table class="AddProductsTable">
                <tr>
                    <td class="RHSTD2">
                        <p class="RHSP">سعر الشراء :</p>
                    </td>
                    <td>
                        <asp:Label ID="lblPurchase_Price" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD2">
                        <p class="RHSP">سعر البيع :</p>
                    </td>
                    <td>
                        <asp:Label ID="lblSellPrice" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD2">
                        <br />
                        <br />
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD2">
                        <p class="RHSP">الكمية :</p>
                    </td>
                    <td>
                        <asp:Label ID="lblAmount" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD2">
                        <br />
                        <br />
                    </td>
                </tr>
                <tr>
                    <td style="vertical-align: top">
                        <p class="RHSP">الوصف :</p>
                    </td>
                    <td>
                        <asp:TextBox ID="TxtDesc" runat="server" Enabled="false" CssClass="TxtMultiline"
                            TextMode="MultiLine" placeholder="لا يوجد وصف !"></asp:TextBox>
                    </td>
                </tr>
            </table>
            <br />
            <br />
        </asp:Panel>
        <%-- Suppliers section --%>
        <header class="Product_Search_Header">
            <table class="ProductInfo_Header_Table">
                <tr>
                    <td>
                        <asp:ImageButton ID="ImageButtonExtendSuppliers" runat="server" ImageUrl="~/Images/Extend.png" Width="16" Height="16"
                            CausesValidation="false" ToolTip="EXtend" OnClick="ImageButtonExtendSuppliers_Click" />
                    </td>
                    <td>
                        <asp:ImageButton ID="ImageButtonCollapseSuppliers" runat="server" ImageUrl="~/Images/Collapse.png" Width="16" Height="16"
                            CausesValidation="false" ToolTip="Collapse" Visible="false" OnClick="ImageButtonCollapseSuppliers_Click" />
                    </td>
                    <td class="left_td">
                        <asp:LinkButton ID="LinkButtonSuppliers" runat="server" CssClass="Links" OnClick="LinkButtonSuppliers_Click">موردين المنتج</asp:LinkButton>
                    </td>
                </tr>
            </table>
        </header>
        <asp:Panel runat="server" ID="PanelSuppliers" CssClass="ResultPanel" Visible="false">
            <asp:GridView ID="GridViewSuppliers" runat="server" AutoGenerateColumns="false" OnRowCommand="GridViewSuppliers_RowCommand" CssClass="GridViewList" EmptyDataText="لا يوجد موردين">
                <Columns>
                    <asp:BoundField DataField="Supplier_Name" HeaderText="المورد" />
                    <asp:BoundField DataField="Purchase_Date" HeaderText="تاريخ الشراء" DataFormatString="{0:d}" />
                    <asp:BoundField DataField="Price" HeaderText="السعر" />
                    <asp:BoundField DataField="Amount" HeaderText="الكميه" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButtonSelect" runat="server" Font-Underline="false">تفاصيل . . .</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <HeaderStyle CssClass="HeaderStyleList" />
                <RowStyle CssClass="RowStyleListHigher" />
                <AlternatingRowStyle CssClass="AlternateRowStyleListHigher" />
                <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                <SelectedRowStyle CssClass="SelectedRowStyle" />
            </asp:GridView>
        </asp:Panel>
        <asp:Panel runat="server" ID="PanelSupplierInfo" Visible="false">
            <table class="AddProductsTable">
                <tr>
                    <td class="RHSTD2">
                        <p class="RHSP">اسم المورد :</p>
                    </td>
                    <td>
                        <asp:Label ID="lblSupplier" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD2">
                        <p class="RHSP">العنوان :</p>
                    </td>
                    <td>
                        <asp:Label ID="lblAddress" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD2">
                        <p class="RHSP">رقم الحساب :</p>
                    </td>
                    <td>
                        <asp:Label ID="lblAccountNumber" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD2">
                        <br />
                        <br />
                    </td>
                </tr>
            </table>
            <table style="width: 400px; margin: 20px auto">
                <tr>
                    <td>
                        <asp:GridView ID="GridViewPhones" runat="server" AutoGenerateColumns="false" CssClass="GridViewList" EmptyDataText="لا توجد ارقام هاتف">
                            <Columns>
                                <asp:BoundField DataField="Phone" HeaderText="ارقام الهواتف" />
                            </Columns>
                            <HeaderStyle CssClass="HeaderStylePhones" />
                            <RowStyle CssClass="RowStyleListHigher" />
                            <AlternatingRowStyle CssClass="AlternateRowStyleListHigher" />
                            <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                        </asp:GridView>
                    </td>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </td>
                    <td>
                        <asp:GridView ID="GridViewFaxs" runat="server" AutoGenerateColumns="false" CssClass="GridViewList" EmptyDataText="لا توجد ارقام فاكس">
                            <Columns>
                                <asp:BoundField DataField="Fax" HeaderText="ارقام الفاكس" />
                            </Columns>
                            <HeaderStyle CssClass="HeaderStylePhones" />
                            <RowStyle CssClass="RowStyleListHigher" />
                            <AlternatingRowStyle CssClass="AlternateRowStyleListHigher" />
                            <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </asp:Panel>
</asp:Content>
