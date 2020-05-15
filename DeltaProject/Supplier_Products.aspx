<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Supplier_Products.aspx.cs" Inherits="DeltaProject.Supplier_Products" %>

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
                        url: "Services/GetNamesService.asmx/Get_Suppliers_Names",
                        data: "{ 'supplier_name': '" + request.term + "' }",
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
        <p>استعلام عن واردات</p>
    </header>
    <section class="Search_Section">
        <table class="Search_table">
            <tr>
                <td class="Image_td">
                    <asp:ImageButton ID="ImageButtonSearch" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                        Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearch_Click" />
                </td>
                <td class="Search_td">
                    <asp:TextBox ID="TextBoxSearch" runat="server" AutoCompleteType="Disabled" CssClass="Search_TextBox"
                        placeholder="اسم المورد للبحث . . . . ."></asp:TextBox>
                </td>
            </tr>
        </table>
    </section>
    <asp:Panel runat="server" ID="PanelSupplierProducts" Visible="false">
        <section style="width: 100%; text-align: right; direction: rtl">
            <header class="PreSection">
                <div>
                    <p>سجل الواردات</p>
                </div>
            </header>
        </section>
        <section class="PreReport_Section">
            <asp:Panel runat="server" ID="PanelProducts" CssClass="PanelImages">
                <asp:GridView ID="GridViewSupplierProducts" runat="server" AutoGenerateColumns="False"
                    EmptyDataText="لا يوجد واردات سابقه" CssClass="GridViewReport" OnRowDataBound="GridViewSupplierProducts_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="Purchase_Date" HeaderText="تاريخ الشراء" DataFormatString="{0:d}" />
                        <asp:BoundField DataField="Product_Name" HeaderText="اسم المنتج" />
                        <asp:BoundField DataField="Price" HeaderText="سعر الشراء" />
                        <asp:BoundField DataField="Amount" HeaderText="الكميـــــــه" />
                        <asp:BoundField DataField="Returned_Products" HeaderText="المرتجع" />
                        <asp:BoundField DataField="Return_Date" HeaderText="تاريخ المرتجع" DataFormatString="{0:d}" />
                    </Columns>
                    <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                    <HeaderStyle CssClass="ConatactsHeader" />
                    <RowStyle CssClass="Row_Style" />
                    <AlternatingRowStyle CssClass="AlternatRowStyle" />
                    <FooterStyle CssClass="Footer_Row" />
                </asp:GridView>
            </asp:Panel>
        </section>
    </asp:Panel>
</asp:Content>
