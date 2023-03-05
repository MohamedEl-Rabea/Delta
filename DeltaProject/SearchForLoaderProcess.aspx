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
            <asp:GridView ID="GridViewProcessess" runat="server" AutoGenerateColumns="False" CssClass="Gridview_Style2"
                EmptyDataText="لا توجد عمليات مسجله لهذا العميل / الفترة"
                HeaderText="اسم الونش"
                SortExpression="LoaderName"
                DataKeyNames="Id"
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
                </Columns>
                <RowStyle CssClass="Row_Style nowrap" />
                <PagerStyle CssClass="PagerStyle" HorizontalAlign="Center" />
                <EmptyDataRowStyle CssClass="EmptyDataRowStyle" />
            </asp:GridView>
        </asp:Panel>
    </asp:Panel>
</asp:Content>
