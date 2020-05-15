<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Search_For_Product.aspx.cs" Inherits="DeltaProject.Search_For_Product" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
    <link href="CSS/jquery-ui-1.10.4.custom.min.css" rel="stylesheet" />
    <script type="text/javascript" src="Script/jquery-2.1.4.js"></script>
    <script src="Script/jquery-1.10.2.js"></script>
    <script src="Script/jquery-ui-1.10.4.custom.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#<%= TextBoxSearch.ClientID%>').autocomplete({
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
            $('#<%= TextBoxMotors.ClientID%>').autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: "Services/GetProductsNames.asmx/Get_MotorsProducts_Names",
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
            $('#<%= TextBoxTol.ClientID%>').autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: "Services/GetProductsNames.asmx/Get_TolProducts_Names",
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>استعلام عن منتج</p>
    </header>
    <asp:RadioButtonList ID="RadioButtonListCategories" runat="server" RepeatDirection="Horizontal" CssClass="RBLCategories" OnSelectedIndexChanged="RadioButtonListCategories_SelectedIndexChanged" AutoPostBack="true">
        <asp:ListItem Value="Normal" Selected="True">منتجات عاديه</asp:ListItem>
        <asp:ListItem Value="Tol">طلمبات</asp:ListItem>
        <asp:ListItem Value="Motors">مواتير</asp:ListItem>
    </asp:RadioButtonList>
    <section class="Search_Section">
        <table class="Search_table">
            <tr>
                <td class="Image_td">
                    <asp:ImageButton ID="ImageButtonSearch" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                        Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearch_Click" />
                </td>
                <td class="Search_td">
                    <asp:TextBox ID="TextBoxSearch" runat="server" AutoCompleteType="Disabled" CssClass="Search_TextBox"
                        placeholder="اسم المنتج للبحث . . . . ."></asp:TextBox>
                    <asp:TextBox ID="TextBoxTol" runat="server" AutoCompleteType="Disabled" CssClass="Search_TextBox"
                        placeholder="اسم المنتج للبحث . . . . ." Visible="false"></asp:TextBox>
                    <asp:TextBox ID="TextBoxMotors" runat="server" AutoCompleteType="Disabled" CssClass="Search_TextBox"
                        placeholder="اسم المنتج للبحث . . . . ." Visible="false"></asp:TextBox>
                </td>
            </tr>
        </table>
    </section>
    <asp:Panel runat="server" ID="PanelInitailResult" CssClass="PanelProductList">
        <asp:GridView ID="GridViewProducts" runat="server" AutoGenerateColumns="false"
            OnRowCommand="GridViewProducts_RowCommand" CssClass="GridViewList" EmptyDataText="لا توجد منتجات">
            <Columns>
                <asp:BoundField DataField="P_Name" HeaderText="الاسم" />
                <asp:BoundField DataField="Mark" HeaderText="الماركه" />
                <asp:BoundField DataField="Inch" HeaderText="البوصه" />
                <asp:BoundField DataField="Style" HeaderText="الطراز" />
                <asp:BoundField DataField="Purchase_Price" HeaderText="سعر الشراء" />
                <asp:BoundField DataField="Amount" HeaderText="الكميه" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton ID="LnkSelect" runat="server" CssClass="lnkbtnSelect"  CausesValidation="false">اختر</asp:LinkButton>
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
                        <p class="RHSP">اسم المنتـــــــــج :</p>
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
                            <p class="RHSP">الماركـــــــــــــــه :</p>
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
                            <p class="RHSP">البوصـــــــــــــــه :</p>
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
                            <p class="RHSP">الطـــــــــــــــراز :</p>
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
                        <p class="RHSP">سعر الشـــــــراء :</p>
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
                        <p class="RHSP">سعر البيع العادى :</p>
                    </td>
                    <td>
                        <asp:Label ID="lblRegSellPrice" runat="server"></asp:Label>
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
                        <p class="RHSP">سعر البيع الخاص :</p>
                    </td>
                    <td>
                        <asp:Label ID="lblSpecialSellPrice" runat="server"></asp:Label>
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
                        <p class="RHSP">الكميــــــــــــــــــة :</p>
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
                        <p class="RHSP">الوصــــــــــــــــف :</p>
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
                        <p class="RHSP">العنـــــوان :</p>
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
