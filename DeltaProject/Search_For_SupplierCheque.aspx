﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Search_For_SupplierCheque.aspx.cs" Inherits="DeltaProject.Search_For_SupplierCheque" %>

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
                        url: "Services/GetNamesService.asmx/Get_Cheques_Suppliers_Names",
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
        <p>استعلام عن شيكات الموردين</p>
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
    <asp:Panel ID="PanelErrorMessage" runat="server" CssClass="ErrorMessagePanal" Visible="false">
        <article class="Errorarticle">
            <asp:Label ID="LabelErrMsg" runat="server" CssClass="LblErrorMsg2" Text="لا توجد شيكات مسجله لهذا المورد / الرقم"></asp:Label>
        </article>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelSupplierCheques">
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkBtnAllSupplierCheques" runat="server" CssClass="TabLnks"
                    ToolTip="عرض كافة الشيكات الخاصه بهذا المورد" OnClick="lnkBtnAllSupplierCheques_Click">الكــــل</asp:LinkButton>
            </div>
        </header>
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkBtnPaidSupplierCheques" runat="server" CssClass="TabLnks"
                    ToolTip="عرض كافة الشيكات التى تم دفعها الخاصه بهذا المورد" OnClick="lnkBtnPaidSupplierCheques_Click">الشيكات المدفوعه</asp:LinkButton>
            </div>
        </header>
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkBtnUnpaidSupplierCheques" runat="server" CssClass="TabLnks"
                    ToolTip="عرض كافة الشيكات التى لم يتم دفعها الخاصه بهذا المورد" OnClick="lnkBtnUnpaidSupplierCheques_Click">الشيكات الغير مدفوعه</asp:LinkButton>
            </div>
        </header>
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkBtnUpcomingPayableSupplierCheques" runat="server" CssClass="TabLnks"
                    ToolTip="عرض كافة الشيكات المستحقة الدفع الخاصه بهذا المورد" OnClick="lnkBtnUpcomingPayableSupplierCheques_Click">شيكات مستحقة الدفع</asp:LinkButton>
            </div>
        </header>
        <asp:Panel runat="server" ID="PanelAllSupplierCheques" CssClass="PreReport_SectionTab" Visible="false">
            <asp:GridView ID="GridViewAllSupplierCheques" runat="server" AutoGenerateColumns="False"
                CssClass="Gridview_Style2" EmptyDataText="لا توجد شيكات لهذا المورد" DataKeyNames="Id"
                DataSourceID="ObjectDataSourceAllSupplierCheques" AllowPaging="True" OnRowCommand="GridViewAllSupplierCheques_RowCommand">
                <Columns>
                    <asp:BoundField DataField="Id" Visible="false" SortExpression="Id" />
                    <asp:BoundField DataField="SupplierName" HeaderText="اسم المورد" SortExpression="SupplierName" DataFormatString="{0:d}" />
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
            <asp:ObjectDataSource ID="ObjectDataSourceAllSupplierCheques" runat="server"
                SelectMethod="Get_All_SupplierCheques"
                TypeName="Business_Logic.SupplierCheque"
                StartRowIndexParameterName="Start_Index"
                MaximumRowsParameterName="Max_Rows"
                SelectCountMethod="Get_AllSupplierCheques_Count_By_C_Name"
                EnablePaging="True">
                <SelectParameters>
                    <asp:ControlParameter ControlID="TextBoxSearch" Name="Supplier_Name" PropertyName="Text" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </asp:Panel>
        <asp:Panel runat="server" ID="PanelPaidSupplierCheques" CssClass="PreReport_SectionTab" Visible="false">
            <asp:GridView ID="GridViewPaidSupplierCheques" runat="server" AutoGenerateColumns="False"
                CssClass="Gridview_Style2" EmptyDataText="لا توجد شيكات مدفوعه لهذا المورد"
                DataSourceID="ObjectDataSourcePaidSupplierSupplierCheques" AllowPaging="True">
                <Columns>
                    <asp:BoundField DataField="SupplierName" HeaderText="اسم المورد" SortExpression="SupplierName" DataFormatString="{0:d}" />
                    <asp:BoundField DataField="ChequeNumber" HeaderText="رقم الشيك" SortExpression="ChequeNumber" />
                    <asp:BoundField DataField="Value" HeaderText="القيمة" DataFormatString="{0:#.##}" SortExpression="Value" />
                    <asp:BoundField DataField="DueDate" HeaderText="تاريخ الاستحقاق" DataFormatString="{0:dd/MM/yyyy}" SortExpression="DueDate" />
                </Columns>
                <RowStyle CssClass="Row_Style" />
                <PagerStyle CssClass="PagerStyle" HorizontalAlign="Center" />
                <EmptyDataRowStyle CssClass="Empty_Style" />
            </asp:GridView>
            <asp:ObjectDataSource ID="ObjectDataSourcePaidSupplierSupplierCheques" runat="server"
                SelectMethod="Get_All_SupplierCheques_Paid"
                TypeName="Business_Logic.SupplierCheque"
                StartRowIndexParameterName="Start_Index"
                MaximumRowsParameterName="Max_Rows"
                SelectCountMethod="Get_PaidSupplierCheques_Count_By_C_Name"
                EnablePaging="True">
                <SelectParameters>
                    <asp:ControlParameter ControlID="TextBoxSearch" Name="Supplier_Name" PropertyName="Text" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </asp:Panel>
        <asp:Panel runat="server" ID="PanelUnPaidSupplierCheques" CssClass="PreReport_SectionTab" Visible="false">
            <asp:GridView ID="GridViewUnPaidSupplierCheques" runat="server" AutoGenerateColumns="False"
                CssClass="Gridview_Style2" EmptyDataText="لا توجد شيكات غير مدفوعه لهذا المورد"
                DataSourceID="ObjectDataSourceUnPaidSupplierSupplierCheques" AllowPaging="True" DataKeyNames="Id">
                <Columns>
                    <asp:BoundField DataField="Id" Visible="false" SortExpression="Id" />
                    <asp:BoundField DataField="SupplierName" HeaderText="اسم المورد" SortExpression="SupplierName" DataFormatString="{0:d}" />
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
            <asp:ObjectDataSource ID="ObjectDataSourceUnPaidSupplierSupplierCheques" runat="server"
                SelectMethod="Get_All_SupplierCheques_Unpaid"
                TypeName="Business_Logic.SupplierCheque"
                StartRowIndexParameterName="Start_Index"
                MaximumRowsParameterName="Max_Rows"
                SelectCountMethod="Get_UnPaidSupplierCheques_Count_By_C_Name"
                EnablePaging="True">
                <SelectParameters>
                    <asp:ControlParameter ControlID="TextBoxSearch" Name="Supplier_Name" PropertyName="Text" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </asp:Panel>
        <asp:Panel runat="server" ID="PanelUpcomingPayableSupplierCheques" CssClass="PreReport_SectionTab">
            <asp:GridView ID="GridViewUpcomingPayableSupplierCheques" runat="server" AutoGenerateColumns="False"
                CssClass="Gridview_Style2" EmptyDataText="لا توجد شيكات مستحقة الدفع لهذا المورد"
                DataSourceID="ObjectDataSourceUpcomingPayableSupplierCheques" AllowPaging="True">
                <Columns>
                    <asp:BoundField DataField="SupplierName" HeaderText="اسم المورد" SortExpression="SupplierName" DataFormatString="{0:d}" />
                    <asp:BoundField DataField="ChequeNumber" HeaderText="رقم الشيك" SortExpression="ChequeNumber" />
                    <asp:BoundField DataField="Value" HeaderText="القيمة" DataFormatString="{0:#.##}" SortExpression="Value" />
                    <asp:BoundField DataField="DueDate" HeaderText="تاريخ الاستحقاق" DataFormatString="{0:dd/MM/yyyy}" SortExpression="DueDate" />
                </Columns>
                <RowStyle CssClass="Row_Style" />
                <PagerStyle CssClass="PagerStyle" HorizontalAlign="Center" />
                <EmptyDataRowStyle CssClass="Empty_Style" />
            </asp:GridView>
            <asp:ObjectDataSource ID="ObjectDataSourceUpcomingPayableSupplierCheques" runat="server"
                SelectMethod="Get_All_SupplierCheques_UpcomingPayable"
                TypeName="Business_Logic.SupplierCheque"
                StartRowIndexParameterName="Start_Index"
                MaximumRowsParameterName="Max_Rows"
                SelectCountMethod="Get_UpcomingPayableSupplierCheques_Count_By_C_Name"
                EnablePaging="True">
                <SelectParameters>
                    <asp:ControlParameter ControlID="TextBoxSearch" Name="Supplier_Name" PropertyName="Text" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </asp:Panel>
        <div class="MsgDiv">
            <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
        </div>
    </asp:Panel>
</asp:Content>

