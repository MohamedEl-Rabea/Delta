<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="SearchForMaintenance.aspx.cs" Inherits="DeltaProject.SearchForMaintenances" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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

        $(document).ready(function () {
            $('.textWithDots').on('click', function () {
                var classList = this.classList;
                if (classList.contains('textWithDotsCollapse')) {
                    this.classList.remove('textWithDotsCollapse');
                }
                else {
                    this.classList.add('textWithDotsCollapse');
                }
            });
        });

        function PrintDivContent(divId) {
            debugger;
            var printContent = document.getElementById(divId).cloneNode(true);
            $(printContent).find('.skipPrinting').remove();
            var winPrint = window.open('', '', 'height=auto,width=auto,resizable=1,scrollbars=1,toolbar=1,sta­tus=0');
            winPrint.document.write('<html><head><title></title>');
            winPrint.document.write('<link rel="stylesheet" href="CSS/Pages_Style_Sheet.css" type="text/css" />');
            winPrint.document.write('</head><body >');
            winPrint.document.write(printContent.innerHTML);
            winPrint.document.write('</body></html>');
            winPrint.document.close();
            winPrint.focus();
            winPrint.print();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>استعلام عن الصيانات</p>
    </header>
    <asp:RadioButtonList ID="RadioButtonListCategories" runat="server" RepeatDirection="Horizontal" CssClass="RBLCategories2"
        OnSelectedIndexChanged="RadioButtonListCategories_SelectedIndexChanged" AutoPostBack="true">
        <asp:ListItem Value="ClientName" Selected="True">اسم العميل</asp:ListItem>
        <asp:ListItem Value="PhoneNumber">رقم التليفون</asp:ListItem>
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
                </td>
            </tr>
            <tr>
                <td></td>
                <td style="text-align: center">
                    <asp:CustomValidator ID="CustomValidator1" runat="server"
                        ToolTip="يجب كتابة الرقم بشكل صحيح"
                        ControlToValidate="txtPhoneNumber"
                        Display="Dynamic"
                        SetFocusOnError="true"
                        ClientValidationFunction="IsValidNumber">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:CustomValidator>
                </td>
            </tr>
        </table>
    </section>
    <asp:Panel ID="PanelErrorMessage" runat="server" CssClass="ErrorMessagePanal" Visible="false">
        <article class="Errorarticle">
            <asp:Label ID="LabelErrMsg" runat="server" CssClass="LblErrorMsg2" Text="لا توجد صيانات مسجله لهذا العميل / الرقم"></asp:Label>
        </article>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelAllMaintenance" Visible="false">
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkBtnAllMaintenance" runat="server" CssClass="TabLnks"
                    ToolTip="عرض كل الصيانات الخاصه بهذا العميل" OnClick="lnkBtnAllMaintenance_OnClick">الكـــــل</asp:LinkButton>
            </div>
        </header>
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkBtnDeliveredMaintenance" runat="server" CssClass="TabLnks"
                    ToolTip="عرض الصيانات المستلمة الخاصه بهذا العميل" OnClick="lnkBtnDeliveredMaintenance_OnClick">المستلمة</asp:LinkButton>
            </div>
        </header>
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkBtnMaintenanceWithRemaining" runat="server" CssClass="TabLnks"
                    ToolTip="عرض الصيانات الغير مكتملة الدفع الخاصه بهذا العميل" OnClick="lnkBtnMaintenanceWithRemaining_OnClick">الغير مكتملة الدفع</asp:LinkButton>
            </div>
        </header>

        <asp:Panel runat="server" ID="PanelMaintenance" CssClass="PreReport_SectionTab">
            <asp:GridView ID="GridViewMaintenance" runat="server" AutoGenerateColumns="False" CssClass="Gridview_Style2"
                EmptyDataText="لا توجد صيانات لهذا العميل"
                HeaderText="اسم الصيانة"
                SortExpression="Title"
                OnRowCommand="GridViewMaintenance_OnRowCommand"
                AllowPaging="True"
                OnPageIndexChanging="GridViewMaintenance_OnPageIndexChanging">
                <Columns>
                    <asp:BoundField DataField="Id" SortExpression="Id" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                    <asp:BoundField DataField="Title" HeaderText="اسم الصيانة" SortExpression="Title" />
                    <asp:BoundField DataField="WorkshopName" HeaderText="الورشة" SortExpression="WorkshopName" />
                    <asp:BoundField DataField="OrderDate" HeaderText="تاريخ الصيانة" SortExpression="OrderDate" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="StatusName" HeaderText="الحالة" SortExpression="StatusName" />
                    <asp:BoundField DataField="ExpiryWarrantyDateText" HeaderText="انتهاء الضمان" SortExpression="ExpiryWarrantyDateText" />
                    <asp:BoundField DataField="Cost" SortExpression="Cost" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" DataFormatString="{0:0.##}" />
                    <asp:BoundField DataField="Price" SortExpression="Price" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" DataFormatString="{0:0.##}" />
                    <asp:BoundField DataField="RemainingAmount" SortExpression="RemainingAmount" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" DataFormatString="{0:0.##}" />
                    <asp:BoundField DataField="Description" SortExpression="Description" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                    <asp:TemplateField SortExpression="Id">
                        <ItemTemplate>
                            <asp:LinkButton ID="LnkSelect" runat="server" CssClass="lnkbtnSelect" CausesValidation="false" CommandName="Select">اختر</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <RowStyle CssClass="Row_Style nowrap" />
                <PagerStyle CssClass="PagerStyle" HorizontalAlign="Center" />
                <EmptyDataRowStyle CssClass="EmptyDataRowStyle" />
            </asp:GridView>
        </asp:Panel>
    </asp:Panel>
    <div id="divToPrint">
        <asp:Panel runat="server" ID="PanelMaintenanceDetails" Visible="false">
            <section class="ContactsSection" style="border-radius: 8px; width: 99%; text-align: right; direction: rtl; padding: 10px;">
                <header style="text-align: left" class="skipPrinting">
                    <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/Images/printer.png" Width="24" Height="24" OnClientClick="PrintDivContent('divToPrint');" ToolTip="اطبع التقرير" />
                    <asp:ImageButton ID="ImageButtonBackMaintenance" runat="server" ImageUrl="~/Images/back.png" Width="24" Height="24"
                        ToolTip="رجوع" OnClick="btnBack_OnClick" CausesValidation="false" />
                </header>
                <header class="Prices_Offer_SubHeaderBill" style="margin-bottom: 20px;">
                    <div style="border: 1px solid black">
                        <p style="font: bold 14px arial; margin: 0; padding: 0">تفاصيل الصيانه</p>
                    </div>
                </header>
                <table class="AddProductsTable maintenanceDetails" style="width: 98%">
                    <tr>
                        <td class="RHSTD" style="width: 15%">
                            <p class="RHSP">اسم الصيانة :</p>
                        </td>
                        <td class="RHSTD" style="width: 35%">
                            <asp:Label runat="server" ID="lblTitle" Text='' /></td>
                        <td class="RHSTD" style="width: 15%">
                            <p class="RHSP">الورشة :</p>
                        </td>
                        <td class="RHSTD" style="width: 35%">
                            <asp:Label runat="server" ID="lblWorkshop" Text='' /></td>
                    </tr>
                    <tr>
                        <td class="RHSTD" style="width: 15%">
                            <p class="RHSP">تاريخ الصيانة :</p>
                        </td>
                        <td class="RHSTD" style="width: 35%">
                            <asp:Label runat="server" ID="lblOrderDate" Text='' /></td>
                        <td class="RHSTD" style="width: 15%">
                            <p class="RHSP">انتهاء الضمان :</p>
                        </td>
                        <td class="RHSTD" style="width: 35%">
                            <asp:Label runat="server" ID="lblExpiryWarrantyDate" Text='' /></td>
                    </tr>
                    <tr>
                        <td class="RHSTD" style="width: 15%">
                            <p class="RHSP">الحالة :</p>
                        </td>
                        <td class="RHSTD" style="width: 35%">
                            <asp:Label runat="server" ID="lblStatus" Text='' /></td>
                        <td class="RHSTD" style="width: 15%">
                            <p class="RHSP">السعر :</p>
                        </td>
                        <td class="RHSTD" style="width: 35%">
                            <asp:Label runat="server" ID="lblPrice" Text='' /></td>
                    </tr>
                    <tr>
                        <td class="RHSTD" style="width: 15%">
                            <p class="RHSP">المتبقى :</p>
                        </td>
                        <td class="RHSTD" style="width: 35%">
                            <asp:Label runat="server" ID="lblRemainingAmount" Text='' /></td>
                        <td class="RHSTD" style="width: 15%">
                            <p class="RHSP">الوصف :</p>
                        </td>
                        <td class="RHSTD" style="width: 35%">
                            <asp:Label runat="server" CssClass="textWithDotsCollapse textWithDots" ID="lblDescription" Text='' /></td>
                    </tr>
                </table>
            </section>
        </asp:Panel>
    </div>
</asp:Content>
