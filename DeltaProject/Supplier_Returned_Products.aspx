<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Supplier_Returned_Products.aspx.cs" Inherits="DeltaProject.Supplier_Returned_Products" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
    <link href="CSS/jquery-ui-1.10.4.custom.min.css" rel="stylesheet" />
    <script src="Script/jquery-1.10.2.js"></script>
    <script src="Script/jquery-ui-1.10.4.custom.min.js"></script>
    <script type="text/javascript" src="Script/ValidationScript.js"></script>
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
        <p>مرتجع منتجـــــــات موردين</p>
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
    <asp:Panel runat="server" ID="PanelProducts" CssClass="PanelProductList" Visible="false">
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
                        <asp:LinkButton ID="LinkButtonSelect" runat="server" Font-Underline="false">اختر . . .</asp:LinkButton>
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
    <asp:Panel ID="PanelSupplier" runat="server" CssClass="PanelSuppliersList" Visible="false">
        <asp:GridView ID="GridViewProductSuppliers" runat="server" AutoGenerateColumns="false" CssClass="GridViewList" EmptyDataText="لا يوجد موردين !">
            <Columns>
                <asp:BoundField DataField="Supplier_Name" HeaderText="المورد" />
                <asp:BoundField DataField="Purchase_Date" HeaderText="تاريخ الشراء" DataFormatString="{0:d}" />
                <asp:BoundField DataField="Price" HeaderText="السعر" />
                <asp:BoundField DataField="Amount" HeaderText="الكميه" />
                <asp:TemplateField HeaderText="المرتجع">
                    <ItemTemplate>
                        <asp:TextBox ID="txtReturnedAmount" runat="server" placeholder="الكميه" AutoCompleteType="Disabled" CssClass="GridTxtAmount"></asp:TextBox>
                        <asp:CustomValidator ID="CustomValidator2" runat="server"
                            ToolTip="يجب اضافة الكميه المرتجعه بشكل صحيح"
                            ControlToValidate="txtReturnedAmount"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ClientValidationFunction="IsValidNumber"
                            Text="*"
                            ForeColor="Red">
                        </asp:CustomValidator>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="تاريخ المرتجع">
                    <ItemTemplate>
                        <asp:TextBox ID="txtReturnDay" runat="server" CssClass="GridTxtDay" MaxLength="2" placeholder="يوم" AutoCompleteType="Disabled"></asp:TextBox>
                        <asp:RangeValidator ID="RangeValidatorDay" runat="server" Display="Dynamic"
                            ControlToValidate="txtReturnDay" Type="Integer" MinimumValue="1" MaximumValue="31" ToolTip="يجب اضافة اليوم بشكل صحيح مابين 1-31" Text="*" ForeColor="Red">
                        </asp:RangeValidator>
                        <asp:TextBox ID="txtReturnMonth" runat="server" CssClass="GridTxtMonth" MaxLength="2" placeholder="شهر" AutoCompleteType="Disabled"></asp:TextBox>
                        <asp:RangeValidator ID="RangeValidator1" runat="server" Display="Dynamic"
                            ControlToValidate="txtReturnMonth" Type="Integer" MinimumValue="1" MaximumValue="12" ToolTip="يجب اضافة الشهر بشكل صحيح مابين 1-12" Text="*" ForeColor="Red">
                        </asp:RangeValidator>
                        <asp:TextBox ID="txtReturnYear" runat="server" CssClass="GridTxtYear" MaxLength="4" placeholder="سنه" AutoCompleteType="Disabled"></asp:TextBox>
                        <asp:CustomValidator ID="CustomValidator1" runat="server"
                            ToolTip="يجب اضافة سنة الشراء بشكل صحيح"
                            ControlToValidate="txtReturnYear"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ClientValidationFunction="IsValidYear"
                            Text="*"
                            ForeColor="Red">
                        </asp:CustomValidator>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="BtnExecute" runat="server" Text="تنفيذ" CssClass="BtnExecute"
                            UseSubmitBehavior="false"
                            OnClientClick="this.disabled='true';this.value='Please wait....';"
                            OnClick="BtnExecute_Click" />
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
