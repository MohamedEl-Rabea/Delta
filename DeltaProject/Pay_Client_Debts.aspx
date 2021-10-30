<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Pay_Client_Debts.aspx.cs" Inherits="DeltaProject.Pay_Customer_Debt" %>
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
     <header class="Header">
        <p>ديون العميل</p>
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
                        placeholder="اسم العميل للبحث . . . . ."></asp:TextBox>
                </td>
            </tr>

        </table>
    </section>
    <asp:Panel ID="PanelErrorMessage" runat="server" CssClass="ErrorMessagePanal" Visible="false">
        <article class="Errorarticle">
            <asp:Label ID="LabelErrMsg" runat="server" CssClass="LblErrorMsg2" Text="لا توجد ديون مسجله لهذا العميل"></asp:Label>
        </article>
    </asp:Panel>
    
    <asp:Panel runat="server" ID="PanelClientCheques">
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkBtnAllClientsDebts" runat="server" CssClass="TabLnks"
                    ToolTip="عرض كل الديون الخاصه بهذا العميل" OnClick="lnkBtnAllClientsDebts_Click">الكـــــل</asp:LinkButton>
            </div>
        </header>
       <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkBtnUnpaidCientDebts" runat="server" CssClass="TabLnks"
                    ToolTip="عرض كافة الديون التى لم يتم تحصيلها الخاصه بهذا العميل" OnClick="lnkBtnUnpaidCientDebts_Click">الغير محصلة</asp:LinkButton>
            </div>
        </header>
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkBtnTodayCientDebts" runat="server" CssClass="TabLnks"
                                ToolTip="عرض كافة الديون المطلوب تحصيلها اليوم الخاصه بهذا العميل" OnClick="lnkBtnTodayCientDebts_Click">واجبة التحصيل</asp:LinkButton>
            </div>
        </header>

        <asp:Panel runat="server" ID="PanelAllClientsDebts" CssClass="PreReport_SectionTab" Visible="false">
            <asp:GridView ID="GridViewAllClientsDebts" runat="server" AutoGenerateColumns="False"
                CssClass="Gridview_Style2" EmptyDataText="لا توجد ديون" DataKeyNames="Id"
                DataSourceID="ObjectDataSourceAllClientDebts" AllowPaging="True">
                <Columns>
                    <asp:BoundField DataField="Id" Visible="false" SortExpression="Id" />
                    <asp:BoundField DataField="ClientName" HeaderText="إسم العميل" SortExpression="ClientName" />
                    <asp:BoundField DataField="DebtValue" HeaderText="القيمة" DataFormatString="{0:#.##}" SortExpression="DebtValue" />
                    <asp:BoundField DataField="ScheduledDate" HeaderText="تاريخ الاستحقاق" DataFormatString="{0:dd/MM/yyyy}" SortExpression="ScheduledDate" />
                    <asp:BoundField DataField="Description" HeaderText="الوصف" SortExpression="Description" />
                </Columns>
                <RowStyle CssClass="Row_Style" />
                <PagerStyle CssClass="PagerStyle" HorizontalAlign="Center" />
                <EmptyDataRowStyle CssClass="Empty_Style" />
            </asp:GridView>
            <asp:ObjectDataSource ID="ObjectDataSourceAllClientDebts" runat="server"
                SelectMethod="Get_All_Debts_Schedule"
                TypeName="DeltaProject.Business_Logic.ClientDebtsSchedule"
                StartRowIndexParameterName="Start_Index"
                MaximumRowsParameterName="Max_Rows"
                SelectCountMethod="Get_All_Debts_Schedule_Count"
                EnablePaging="True">
                <SelectParameters>
                    <asp:ControlParameter ControlID="TextBoxSearch" Name="Client_Name" PropertyName="Text" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </asp:Panel>
        <asp:Panel runat="server" ID="PanelUnpaidCientDebts" CssClass="PreReport_SectionTab" Visible="false">
            <asp:GridView ID="GridViewUnpaidCientDebts" runat="server" AutoGenerateColumns="False"
                CssClass="Gridview_Style2" EmptyDataText="لا توجد ديون غير مدفوعه" DataKeyNames="Id"
                DataSourceID="ObjectDataSourceUnpaidCientDebts" AllowPaging="True" OnRowCommand="GridViewUnpaidCientDebts_OnRowCommand">
                <Columns>
                    <asp:BoundField DataField="Id" Visible="false" SortExpression="Id" />
                    <asp:BoundField DataField="ClientName" HeaderText="إسم العميل" SortExpression="ClientName" />
                    <asp:BoundField DataField="DebtValue" HeaderText="القيمة" DataFormatString="{0:#.##}" SortExpression="DebtValue" />
                    <asp:BoundField DataField="ScheduledDate" HeaderText="تاريخ الاستحقاق" DataFormatString="{0:dd/MM/yyyy}" SortExpression="ScheduledDate" />
                    <asp:BoundField DataField="Description" HeaderText="الوصف" SortExpression="Description" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:ImageButton ID="ImageButtonPay" runat="server" ImageUrl="~/Images/ok.png" Width="16" Height="16"
                                             CausesValidation="false" CommandName="Pay_Debt"/>
                            <asp:ImageButton ID="ImageButtonDelete" runat="server" ImageUrl="~/Images/Delete.png" Width="16" Height="16"
                                             CausesValidation="false" CommandName="Delete_Debt"/>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <RowStyle CssClass="Row_Style" />
                <PagerStyle CssClass="PagerStyle" HorizontalAlign="Center" />
                <EmptyDataRowStyle CssClass="Empty_Style" />
            </asp:GridView>
            <asp:ObjectDataSource ID="ObjectDataSourceUnpaidCientDebts" runat="server"
                SelectMethod="Get_All_Not_Paid_Debts_Schedule"
                TypeName="DeltaProject.Business_Logic.ClientDebtsSchedule"
                StartRowIndexParameterName="Start_Index"
                MaximumRowsParameterName="Max_Rows"
                SelectCountMethod="Get_All_Not_Paid_Debts_Schedule_Count"
                EnablePaging="True">
                <SelectParameters>
                    <asp:ControlParameter ControlID="TextBoxSearch" Name="Client_Name" PropertyName="Text" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </asp:Panel>
        <asp:Panel runat="server" ID="PanelTodayCientDebts" CssClass="PreReport_SectionTab" Visible="True">
            <asp:GridView ID="GridViewTodayCientDebts" runat="server" AutoGenerateColumns="False"
                CssClass="Gridview_Style2" EmptyDataText="لا توجد ديون واجب تحصيلها" DataKeyNames="Id"
                DataSourceID="ObjectDataSourceTodayCientDebts" AllowPaging="True" OnRowCommand="GridViewTodayCientDebts_OnRowCommand">
                <Columns>
                    <asp:BoundField DataField="Id" Visible="false" SortExpression="Id" />
                    <asp:BoundField DataField="ClientName" HeaderText="إسم العميل" SortExpression="ClientName" />
                    <asp:BoundField DataField="DebtValue" HeaderText="القيمة" DataFormatString="{0:#.##}" SortExpression="DebtValue" />
                    <asp:BoundField DataField="ScheduledDate" HeaderText="تاريخ الاستحقاق" DataFormatString="{0:dd/MM/yyyy}" SortExpression="ScheduledDate" />
                    <asp:BoundField DataField="Description" HeaderText="الوصف" SortExpression="Description"/>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:ImageButton ID="ImageButtonPay" runat="server" ImageUrl="~/Images/ok.png" Width="16" Height="16"
                                             CausesValidation="false" CommandName="Pay_Debt"/>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <RowStyle CssClass="Row_Style" />
                <PagerStyle CssClass="PagerStyle" HorizontalAlign="Center" />
                <EmptyDataRowStyle CssClass="Empty_Style" />
            </asp:GridView>
            <asp:ObjectDataSource ID="ObjectDataSourceTodayCientDebts" runat="server"
                SelectMethod="Get_All_Have_To_Pay_Debts_Schedule"
                TypeName="DeltaProject.Business_Logic.ClientDebtsSchedule"
                StartRowIndexParameterName="Start_Index"
                MaximumRowsParameterName="Max_Rows"
                SelectCountMethod="Get_All_Have_To_Pay_Debts_Schedule_Count"
                EnablePaging="True">
                <SelectParameters>
                    <asp:ControlParameter ControlID="TextBoxSearch" Name="Client_Name" PropertyName="Text" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </asp:Panel>
        <div class="MsgDiv">
            <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
        </div>
    </asp:Panel>
</asp:Content>
