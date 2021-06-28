<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Unpaid_ClientCheque.aspx.cs" Inherits="DeltaProject.Unpaid_ClientCheque" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
    <link href="CSS/jquery-ui-1.10.4.custom.min.css" rel="stylesheet" />
    <script src="Script/jquery-1.10.2.js"></script>
    <script src="Script/jquery-ui-1.10.4.custom.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#<%= TextBoxSearch.ClientID%>').autocomplete({
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
        function PrintDivContent(divId) {
            var printContent = document.getElementById(divId);
            var WinPrint = window.open('', '', 'height=auto,width=auto,resizable=1,scrollbars=1,toolbar=1,sta­tus=0');
            WinPrint.document.write('<html><head><title></title>');
            WinPrint.document.write('<link rel="stylesheet" href="CSS/Pages_Style_Sheet.css" type="text/css" />');
            WinPrint.document.write('</head><body >');
            WinPrint.document.write(printContent.innerHTML);
            WinPrint.document.write('</body></html>');
            WinPrint.document.close();
            WinPrint.focus();
            WinPrint.print();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>استعلام عن شيكات غير مدفوعة</p>
    </header>
    <asp:RadioButtonList ID="RadioButtonListCategories" runat="server" RepeatDirection="Horizontal" CssClass="RBLCategories2"
        OnSelectedIndexChanged="RadioButtonListCategories_SelectedIndexChanged" AutoPostBack="true">
        <asp:ListItem Value="Normal" Selected="True">اسم العميل</asp:ListItem>
        <asp:ListItem Value="Motors">رقم الشيك</asp:ListItem>
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
                        placeholder="اسم العميل للبحث . . . . ."></asp:TextBox>
                    <asp:TextBox ID="txtClientCheques_ID" runat="server" AutoCompleteType="Disabled" Visible="false" CssClass="Search_TextBox"
                        placeholder="رقم الشيك للبحث . . . . ."></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td></td>
                <td style="text-align: center">
                    <asp:CompareValidator ID="CompareValidator1" runat="server"
                        ControlToValidate="txtClientCheques_ID"
                        Display="Dynamic"
                        Operator="DataTypeCheck"
                        Type="Integer"
                        SetFocusOnError="true"
                        ToolTip="يجب كتابة رقم الشيك بشكل صحيح">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:CompareValidator>
                </td>
            </tr>
        </table>
    </section>
    
    
    

    <section style="width: 100%; text-align: right; direction: rtl">
            <header class="PreSection">
                <div>
                    <p>شيكات غير مدفوعة</p>
                </div>
            </header>
        </section>
        <section class="PreReport_Section">
            <asp:GridView ID="GridViewUnPaidClientCheque" runat="server" AutoGenerateColumns="false" CssClass="Gridview_StyleReport" EmptyDataText="لا توجد شيكات">
                <Columns>
                    <asp:BoundField DataField="ClientName" HeaderText="اسم عميل" />
                    <asp:BoundField DataField="ChequeNumber" HeaderText="رقم الشيك" />
                    <asp:BoundField DataField="Value" HeaderText="القيمة" />
                    <asp:BoundField DataField="DueDate" DataFormatString = "{0:d}" HeaderText="تاريخ الاستحقاق" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Checkbox ID="txtAmount" AutoCompleteType="Disabled" CssClass="EditTxt" runat="server"></asp:Checkbox>
                            <%--<asp:CustomValidator ID="CustomValidator8" runat="server"
                                ToolTip="يجب كتابة الكميه بشكل صحيح"
                                ControlToValidate="txtAmount"
                                Display="Dynamic"
                                SetFocusOnError="true"
                                ForeColor="Red"
                                ClientValidationFunction="IsValidNumber"
                                Text="*">
                            </asp:CustomValidator>--%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <%--<asp:TemplateField ControlStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ItemStyle-CssClass="NoDispaly">
                        <ItemTemplate>
                            <asp:ImageButton ID="ImageButtonConfirmEdit" runat="server" ImageUrl="~/Images/Ok.png" Width="16" Height="16"
                                ToolTip="تاكيد التعديل" OnClick="ImageButtonConfirmEdit_Click" />
                        </ItemTemplate>
                    </asp:TemplateField>--%>
                </Columns>
                <HeaderStyle CssClass="InventoryGridHeader" />
                <RowStyle CssClass="Row_Style" />
                <AlternatingRowStyle CssClass="AlternatRowStyle" />
                <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
            </asp:GridView>
        </section>
</asp:Content>

