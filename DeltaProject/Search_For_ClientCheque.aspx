﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Search_For_ClientCheque.aspx.cs" Inherits="DeltaProject.Search_For_ClientCheque" %>

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
                        url: "Services/GetNamesService.asmx/Get_Cheques_Clients_Names",
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
        <p>استعلام عن شيكات العملاء</p>
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
            <asp:Label ID="LabelErrMsg" runat="server" CssClass="LblErrorMsg2" Text="لا توجد شيكات مسجله لهذا العميل / الرقم"></asp:Label>
        </article>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelClientCheques">
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkBtnAllClientsCheceques" runat="server" CssClass="TabLnks"
                    ToolTip="عرض كل الشيكات الخاصه بهذا العميل" OnClick="lnkBtnAllClientsCheceques_Click">الكـــــل</asp:LinkButton>
            </div>
        </header>
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkBtnPaidCientCheques" runat="server" CssClass="TabLnks"
                    ToolTip="عرض كافة الشيكات التى تم تحصيلها الخاصه بهذا العميل" OnClick="lnkBtnPaidCientCheques_Click">الشيكات المحصلة</asp:LinkButton>
            </div>
        </header>
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkBtnUnpaidCientCheques" runat="server" CssClass="TabLnks"
                    ToolTip="عرض كافة الشيكات التى لم يتم تحصيلها الخاصه بهذا العميل" OnClick="lnkBtnUnpaidCientCheques_Click">الشيكات الغير محصلة</asp:LinkButton>
            </div>
        </header>
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkBtnUpcomingPayableCientCheques" runat="server" CssClass="TabLnks"
                    ToolTip="عرض كافة الشيكات المستحقة التحصيل الخاصه بهذا العميل" OnClick="lnkBtnUpcomingPayableCientCheques_Click">شيكات مستحقة التحصيل</asp:LinkButton>
            </div>
        </header>
        <asp:Panel runat="server" ID="PanelAllClientsCheques" CssClass="PreReport_SectionTab" Visible="false">
            <asp:GridView ID="GridViewAllClientsCheques" runat="server" AutoGenerateColumns="False"
                CssClass="Gridview_Style2" EmptyDataText="لا توجد شيكات لهذا العميل" DataKeyNames="Id"
                DataSourceID="ObjectDataSourceAllClientCheques" AllowPaging="True" OnRowCommand="GridViewAllClientsCheques_RowCommand">
                <Columns>
                    <asp:BoundField DataField="Id" Visible="false" SortExpression="Id" />
                    <asp:BoundField DataField="ClientName" HeaderText="اسم العميل" SortExpression="ClientName" DataFormatString="{0:d}" />
                    <asp:BoundField DataField="ChequeNumber" HeaderText="رقم الشيك" SortExpression="ChequeNumber" />
                    <asp:BoundField DataField="Value" HeaderText="القيمة" DataFormatString="{0:#.##}" SortExpression="Value" />
                    <asp:BoundField DataField="DueDate" HeaderText="تاريخ الاستحقاق" DataFormatString="{0:dd/MM/yyyy}" SortExpression="DueDate" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:ImageButton ID="ImageButtonDelete" runat="server" ImageUrl="~/Images/Delete.png" Width="16" Height="16"
                                CausesValidation="false" CommandName="Delete_Row"
                                OnClientClick="return confirm('سيتم مسح هذا الشيك نهائيا. . . هل تريد المتابعه ؟');" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <RowStyle CssClass="Row_Style" />
                <PagerStyle CssClass="PagerStyle" HorizontalAlign="Center" />
                <EmptyDataRowStyle CssClass="Empty_Style" />
            </asp:GridView>
            <asp:ObjectDataSource ID="ObjectDataSourceAllClientCheques" runat="server"
                SelectMethod="Get_All_ClientCheques"
                TypeName="Business_Logic.ClientCheque"
                StartRowIndexParameterName="Start_Index"
                MaximumRowsParameterName="Max_Rows"
                SelectCountMethod="Get_ClientCheques_Count_By_C_Name"
                EnablePaging="True">
                <SelectParameters>
                    <asp:ControlParameter ControlID="TextBoxSearch" Name="Client_Name" PropertyName="Text" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </asp:Panel>
        <asp:Panel runat="server" ID="PanelPaidCientCheques" CssClass="PreReport_SectionTab" Visible="false">
            <asp:GridView ID="GridViewPaidCientCheques" runat="server" AutoGenerateColumns="False"
                CssClass="Gridview_Style2" EmptyDataText="لا توجد شيكات مدفوعه لهذا العميل" DataKeyNames="Id"
                DataSourceID="ObjectDataSourcePaidClientCientCheques" AllowPaging="True">
                <Columns>
                    <asp:BoundField DataField="ClientName" HeaderText="اسم العميل" SortExpression="ClientName" DataFormatString="{0:d}" />
                    <asp:BoundField DataField="ChequeNumber" HeaderText="رقم الشيك" SortExpression="ChequeNumber" />
                    <asp:BoundField DataField="Value" HeaderText="القيمة" DataFormatString="{0:#.##}" SortExpression="Value" />
                    <asp:BoundField DataField="DueDate" HeaderText="تاريخ الاستحقاق" DataFormatString="{0:dd/MM/yyyy}" SortExpression="DueDate" />
                </Columns>
                <RowStyle CssClass="Row_Style" />
                <PagerStyle CssClass="PagerStyle" HorizontalAlign="Center" />
                <EmptyDataRowStyle CssClass="Empty_Style" />
            </asp:GridView>
            <asp:ObjectDataSource ID="ObjectDataSourcePaidClientCientCheques" runat="server"
                SelectMethod="Get_All_ClientCheques_Paid"
                TypeName="Business_Logic.ClientCheque"
                StartRowIndexParameterName="Start_Index"
                MaximumRowsParameterName="Max_Rows"
                SelectCountMethod="Get_PaidClientCheques_Count_By_C_Name"
                EnablePaging="True">
                <SelectParameters>
                    <asp:ControlParameter ControlID="TextBoxSearch" Name="Client_Name" PropertyName="Text" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </asp:Panel>
        <asp:Panel runat="server" ID="PanelUnPaidCientCheques" CssClass="PreReport_SectionTab" Visible="false">
            <asp:GridView ID="GridViewUnPaidCientCheques" runat="server" AutoGenerateColumns="False"
                CssClass="Gridview_Style2" EmptyDataText="لا توجد شيكات غير مدفوعه لهذا العميل"
                DataSourceID="ObjectDataSourceUnPaidClientCientCheques" AllowPaging="True" DataKeyNames="Id">
                <Columns>
                    <asp:BoundField DataField="Id" Visible="false" SortExpression="Id" />
                    <asp:BoundField DataField="ClientName" HeaderText="اسم العميل" SortExpression="ClientName" DataFormatString="{0:d}" />
                    <asp:BoundField DataField="ChequeNumber" HeaderText="رقم الشيك" SortExpression="ChequeNumber" />
                    <asp:BoundField DataField="Value" HeaderText="القيمة" DataFormatString="{0:#.##}" SortExpression="Value" />
                    <asp:BoundField DataField="DueDate" HeaderText="تاريخ الاستحقاق" DataFormatString="{0:dd/MM/yyyy}" SortExpression="DueDate" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:ImageButton ID="ImageButtonConfirmEdit" runat="server" ImageUrl="~/Images/Ok.png" Width="16" Height="16"
                                ToolTip="تاكيد التعديل" OnClick="ImageButtonConfirmEdit_Click" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <RowStyle CssClass="Row_Style" />
                <PagerStyle CssClass="PagerStyle" HorizontalAlign="Center" />
                <EmptyDataRowStyle CssClass="Empty_Style" />
            </asp:GridView>
            <asp:ObjectDataSource ID="ObjectDataSourceUnPaidClientCientCheques" runat="server"
                SelectMethod="Get_All_ClientCheques_Unpaid"
                TypeName="Business_Logic.ClientCheque"
                StartRowIndexParameterName="Start_Index"
                MaximumRowsParameterName="Max_Rows"
                SelectCountMethod="Get_UnPaidClientCheques_Count_By_C_Name"
                EnablePaging="True">
                <SelectParameters>
                    <asp:ControlParameter ControlID="TextBoxSearch" Name="Client_Name" PropertyName="Text" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </asp:Panel>
        <asp:Panel runat="server" ID="PanelUpcomingPayableClientCheques" CssClass="PreReport_SectionTab">
            <asp:GridView ID="GridViewUpcomingPayableClientCheques" runat="server" AutoGenerateColumns="False"
                CssClass="Gridview_Style2" EmptyDataText="لا توجد شيكات مستحقة التحصيل على هذا العميل"
                DataSourceID="ObjectDataSourceUpcomingPayableCientCheques" AllowPaging="True">
                <Columns>
                    <asp:BoundField DataField="ClientName" HeaderText="اسم العميل" SortExpression="ClientName" DataFormatString="{0:d}" />
                    <asp:BoundField DataField="ChequeNumber" HeaderText="رقم الشيك" SortExpression="ChequeNumber" />
                    <asp:BoundField DataField="Value" HeaderText="القيمة" DataFormatString="{0:#.##}" SortExpression="Value" />
                    <asp:BoundField DataField="DueDate" HeaderText="تاريخ الاستحقاق" DataFormatString="{0:dd/MM/yyyy}" SortExpression="DueDate" />
                </Columns>
                <RowStyle CssClass="Row_Style" />
                <PagerStyle CssClass="PagerStyle" HorizontalAlign="Center" />
                <EmptyDataRowStyle CssClass="Empty_Style" />
            </asp:GridView>
            <asp:ObjectDataSource ID="ObjectDataSourceUpcomingPayableCientCheques" runat="server"
                SelectMethod="Get_All_ClientCheques_UpcomingPayable"
                TypeName="Business_Logic.ClientCheque"
                StartRowIndexParameterName="Start_Index"
                MaximumRowsParameterName="Max_Rows"
                SelectCountMethod="Get_UpcomingPayableClientCheques_Count_By_C_Name"
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

