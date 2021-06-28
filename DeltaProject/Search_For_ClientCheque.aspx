<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Search_For_ClientCheque.aspx.cs" Inherits="DeltaProject.Search_For_ClientCheque" %>
 
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
        <p>استعلام عن شيكات العملاء</p>
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
    <asp:Panel ID="PanelErrorMessage" runat="server" CssClass="ErrorMessagePanal" Visible="false">
        <article class="Errorarticle">
            <asp:Label ID="LabelErrMsg" runat="server" CssClass="LblErrorMsg2" Text="لا توجد شيكات مسجله لهذا العميل / الرقم"></asp:Label>
        </article>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelCientCheques" Visible="false">
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkBtnPaidCientCheques" runat="server" CssClass="TabLnks"
                    ToolTip="عرض كافة الشيكات التى تم دفعها الخاصه بهذا العميل" OnClick="lnkBtnPaidCientCheques_Click">الشيكات المدفوعه</asp:LinkButton>
            </div>
        </header>
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkBtnUnpaidCientCheques" runat="server" CssClass="TabLnks"
                    ToolTip="عرض كافة الشيكات التى لم يتم دفعها الخاصه بهذا العميل" OnClick="lnkBtnUnpaidCientCheques_Click">الشيكات الغير مدفوعه</asp:LinkButton>
            </div>
        </header>
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkBtnUpcomingPayableCientCheques" runat="server" CssClass="TabLnks"
                    ToolTip="عرض كافة الشيكات المستحقة الدفع الخاصه بهذا العميل" OnClick="lnkBtnUpcomingPayableCientCheques_Click">الشيكات المستحقة الدفع</asp:LinkButton>
            </div>
        </header>
        <asp:Panel runat="server" ID="PanelPaidCientCheques" CssClass="PreReport_SectionTab" Visible="false">
            <asp:GridView ID="GridViewPaidCientCheques" runat="server" AutoGenerateColumns="False"
                CssClass="Gridview_Style2" EmptyDataText="لا توجد شيكات مدفوعه لهذا العميل"
                DataSourceID="ObjectDataSourcePaidClientCientCheques" AllowPaging="True">
                <Columns>
                    <asp:BoundField DataField="ClientName" HeaderText="اسم العميل" SortExpression="ClientName" DataFormatString="{0:d}" />
                    <asp:BoundField DataField="ChequeNumber" HeaderText="رقم الشيك" SortExpression="ChequeNumber" />
                    <asp:BoundField DataField="Value" HeaderText="القيمة" SortExpression="Value" />
                    <asp:BoundField DataField="DueDate" HeaderText="تاريخ الاستحقاق" DataFormatString = "{0:d}" SortExpression="DueDate" />
                    
                    <%--<asp:TemplateField HeaderText="القيمة" SortExpression="Value">
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButtonBill_ID" runat="server" Text='<%# Bind("Bill_ID") %>' ToolTip="الانتقال الى كامل بيانات الفاتورة" CommandName="Select_Bill"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>--%>
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
                    <asp:BoundField DataField="Id" visible="false" SortExpression="Id" />
                    <asp:BoundField DataField="ClientName" HeaderText="اسم العميل" SortExpression="ClientName" DataFormatString="{0:d}" />
                    <asp:BoundField DataField="ChequeNumber" HeaderText="رقم الشيك" SortExpression="ChequeNumber" />
                    <asp:BoundField DataField="Value" HeaderText="القيمة" SortExpression="Value" />
                    <asp:BoundField DataField="DueDate" HeaderText="تاريخ الاستحقاق" DataFormatString = "{0:d}" SortExpression="DueDate" />
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
        <asp:Panel runat="server" ID="PanelUpcomingPayableClientCheques" CssClass="PreReport_SectionTab" Visible="false">
            <asp:GridView ID="GridViewUpcomingPayableClientCheques" runat="server" AutoGenerateColumns="False" 
                CssClass="Gridview_Style2" EmptyDataText="لا توجد شيكات مستحقة الدفع لهذا العميل"
                DataSourceID="ObjectDataSourceUpcomingPayableCientCheques" AllowPaging="True">
                <Columns>
                    <asp:BoundField DataField="ClientName" HeaderText="اسم العميل" SortExpression="ClientName" DataFormatString="{0:d}" />
                    <asp:BoundField DataField="ChequeNumber" HeaderText="رقم الشيك" SortExpression="ChequeNumber" />
                    <asp:BoundField DataField="Value" HeaderText="القيمة" SortExpression="Value" />
                    <asp:BoundField DataField="DueDate" HeaderText="تاريخ الاستحقاق" DataFormatString = "{0:d}" SortExpression="DueDate" />
                    
                    <%--<asp:TemplateField HeaderText="القيمة" SortExpression="Value">
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButtonBill_ID" runat="server" Text='<%# Bind("Bill_ID") %>' ToolTip="الانتقال الى كامل بيانات الفاتورة" CommandName="Select_Bill"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>--%>
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

