<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="SearchForLoaderProcess.aspx.cs" Inherits="DeltaProject.SearchForLoaderProcess" Culture = "ar-EG" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
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
            $('#<%= txtStartDate.ClientID%>').datepicker(options);
            $('#<%= txtEndDate.ClientID%>').datepicker(options);
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>إستعلام عن عمليات الونش</p>
    </header>
    <section class="Search_Section">
        <table class="Search_table">
            <tr>
                <td class="Image_td">
                    <asp:ImageButton ID="ImageButtonSearch" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                                     Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearch_Click" />
                </td>
                <td class="Search_td" colspan="2">
                    <asp:TextBox ID="txtClientName" runat="server" AutoCompleteType="Disabled" CssClass="Search_TextBox_md"
                                 placeholder="اسم العميل للبحث . . . . ."></asp:TextBox>
                </td>
                <td class="Search_td">
                    <asp:TextBox runat="server" ID="txtStartDate" CssClass="Search_TextBox_md left_border" PlaceHolder="تاريخ بداية الاستعلام . . . . ." AutoCompleteType="Disabled"></asp:TextBox>
                </td>
                <td class="Search_td">
                    <asp:TextBox runat="server" ID="txtEndDate" CssClass="Search_TextBox_md left_border" PlaceHolder="تاريخ نهاية الاستعلام . . . . ." AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
        </table>
    </section>
   <asp:Panel ID="PanelErrorMessage" runat="server" CssClass="ErrorMessagePanal" Visible="false">
        <article class="Errorarticle">
            <asp:Label ID="LabelErrMsg" runat="server" CssClass="LblErrorMsg2" Text="لا توجد عمليات مسجله لهذا العميل / الفترة"></asp:Label>
        </article>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelAllProcessess" Visible="false">
        <asp:Panel runat="server" ID="PanelProcessess" CssClass="PreReport_SectionTab">
            <asp:GridView ID="GridViewProcess" runat="server" AutoGenerateColumns="False" CssClass="Gridview_Style2"
                EmptyDataText="لا توجد عمليات مسجله لهذا العميل / الفترة"
                HeaderText="اسم الونش"
                SortExpression="LoaderName"
                DataKeyNames="Id"
                OnRowCommand="GridViewProcess_OnRowCommand"
                AllowPaging="True"
                OnPageIndexChanging="GridViewMaintenance_OnPageIndexChanging">
                <Columns>
                    <asp:BoundField DataField="Id" SortExpression="Id" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                    <asp:BoundField DataField="LoaderName" HeaderText="اسم الونش" SortExpression="LoaderName" />
                    <asp:BoundField DataField="PermissionNumber" HeaderText="رقم الاذن" SortExpression="PermissionNumber" />
                    <asp:BoundField DataField="ClientName" HeaderText="اسم العميل" SortExpression="ClientName" />
                    <asp:BoundField DataField="Date" HeaderText="التاريخ" SortExpression="Date" DataFormatString="{0:dd/MM/yyyy hh:mm tt}"/>
                    <asp:BoundField DataField="Cost" HeaderText="التكلفة" SortExpression="Cost" DataFormatString="{0:0.##}" />
                    <asp:BoundField DataField="RemainingAmount" HeaderText="المتبقى" SortExpression="RemainingAmount" DataFormatString="{0:0.##}" />
                    <asp:BoundField DataField="Description" SortExpression="Description" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                    <asp:TemplateField SortExpression="Id">
                        <ItemTemplate>
                            <asp:LinkButton ID="LnkDetails" runat="server" CssClass="lnkbtnSelect"  CausesValidation="false"  CommandName="Details">التفاصيل</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <RowStyle CssClass="Row_Style nowrap" />
                <PagerStyle CssClass="PagerStyle" HorizontalAlign="Center" />
                <EmptyDataRowStyle CssClass="EmptyDataRowStyle" />
            </asp:GridView>
        </asp:Panel>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelLoaderDetails" Visible="false">
        <section class="ContactsSection" style="border-radius: 8px; width: 99%; text-align: right; direction: rtl; padding: 10px;">
            <header style="text-align: left">
                <asp:ImageButton ID="ImageButtonBackLoader" runat="server" ImageUrl="~/Images/back.png" Width="24" Height="24"
                                 ToolTip="رجوع" OnClick="btnBack_OnClick" CausesValidation="false" />
            </header>
            <header class="Prices_Offer_SubHeaderBill" style="margin-bottom: 20px;">
                <div style="border: 1px solid black">
                    <p style="font: bold 14px arial; margin: 0; padding: 0">تفاصيل عملية الونش</p>
                </div>
            </header>
            <table class="AddProductsTable maintenanceDetails" style="width:98%">
                <tr>
                    <td class="RHSTD" style="width: 15%"><p class="RHSP">اسم الونش :</p></td>
                    <td class="RHSTD" style="width: 35%"><asp:Label runat="server" ID="lblLoaderName" Text=''/></td>
                    <td class="RHSTD" style="width: 15%"><p class="RHSP">رقم الاذن :</p></td>
                    <td class="RHSTD" style="width: 35%"><asp:Label runat="server" ID="lblPermissionNumber" Text=''/></td>
                </tr>
                <tr>
                    <td class="RHSTD" style="width: 15%"><p class="RHSP">اسم العميل :</p></td>
                    <td class="RHSTD" style="width: 35%"><asp:Label runat="server" ID="lblClientName" Text=''/></td>
                    <td class="RHSTD" style="width: 15%"><p class="RHSP">التاريخ :</p></td>
                    <td class="RHSTD" style="width: 35%"><asp:Label runat="server" ID="lblDate" Text=''/></td>
                </tr>
                <tr>
                    <td class="RHSTD" style="width: 15%"><p class="RHSP">التكلفة :</p></td>
                    <td class="RHSTD" style="width: 35%"><asp:Label runat="server" ID="lblCost" Text=''/></td>
                    <td class="RHSTD" style="width: 15%"><p class="RHSP">المتبقى :</p></td>
                    <td class="RHSTD" style="width: 35%"><asp:Label runat="server" ID="lblRemainingAmount" Text=''/></td>
                </tr>
                <tr>
                    <td class="RHSTD" style="width: 15%"><p class="RHSP">الوصف :</p></td>
                    <td colspan="3" class="RHSTD" style="width: 35%"><asp:Label runat="server" CssClass="textWithDotsCollapse textWithDots" ID="lblDescription" Text=''/></td>
                </tr>
            </table>
        </section>
    </asp:Panel>
</asp:Content>
