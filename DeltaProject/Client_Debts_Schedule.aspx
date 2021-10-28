<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Client_Debts_Schedule.aspx.cs" Inherits="DeltaProject.Client_Debts_Schedule" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="Script/ServiseHandler.js"></script>
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
    <link href="CSS/jquery-ui-1.10.4.custom.min.css" rel="stylesheet" />
    <script src="Script/jquery-1.10.2.js"></script>
    <script src="Script/jquery-ui-1.10.4.custom.min.js"></script>
    <script type="text/javascript" src="Script/ValidationScript.js"></script>
    <script type="text/javascript">
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
            debugger;
            $(".dateInput").datepicker(options);
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>جدولة ديون العميل</p>
    </header>
    <section>
        <section>
            <table style="width: 100%;direction: rtl;">
                <tr>
                    <td style="width: 8%">
                        <asp:Label ID="Label1" runat="server" Text="اسم العميل : " CssClass="lblInfo"></asp:Label>
                    </td>
                    <td style="width: 35%">
                        <asp:Label ID="lblClientName" runat="server" CssClass="lblInfo2"></asp:Label>
                    </td>
                    <td style="width: 8%">
                        <asp:Label ID="Label2" runat="server" Text="اجمالى الدين : " CssClass="lblInfo"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="lblTotalDebts" runat="server" CssClass="lblInfo2"></asp:Label>
                    </td>
                    <td style="width: 8%">
                        <asp:Label ID="Label3" runat="server" Text="غير مجدول : " CssClass="lblInfo"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="lblUnScheduled" runat="server" CssClass="lblInfo2"></asp:Label>
                    </td>
                </tr>
            </table>
        </section>
        <section>
            <asp:GridView runat="server" ID="gridViewDebts" CssClass="GridViewBill" DataKeyNames="Id" ShowHeaderWhenEmpty="True"
                          AutoGenerateColumns="False" EmptyDataText="لا توجد معاملات مادية" ShowFooter="true" OnRowCommand="gridViewDebts_OnRowCommand">
                
                <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:ImageButton ID="ImageButtonEdit" runat="server" ImageUrl="~/Images/Edit.png" Width="16" Height="16"
                                    CommandName="Edit_Row" CausesValidation="false" />
                                <asp:ImageButton ID="ImageButtonDelete" runat="server" ImageUrl="~/Images/Delete.png" Width="16" Height="16"
                                    CausesValidation="false" CommandName="Delete_Row"
                                    OnClientClick="return confirm('سيتم مسح هذا البند من جدول المشتريات . . . هل تريد المتابعه ؟');" />
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:ImageButton ID="ImageButtonCancelEdit" runat="server" ImageUrl="~/Images/Cancel.png" Width="16" Height="16"
                                    ToolTip="الغاء التعديل" CausesValidation="false" CommandName="Cancel_Update" />
                                <asp:ImageButton ID="ImageButtonConfirmEdit" runat="server" ImageUrl="~/Images/Ok.png" Width="16" Height="16"
                                    ToolTip="تاكيد التعديل" CommandName="Confirm_Update" />
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="القيمة">
                            <EditItemTemplate>
                            <asp:TextBox ID="txtValue" runat="server" CssClass="EditTxtName" Text='<%# Bind("DebtValue") %>'></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                                    ControlToValidate="txtValue" Display="Dynamic" SetFocusOnError="true"
                                    ToolTip="قيمة الدين مطلوبه"
                                    ForeColor="Red"
                                    Text="*" ValidateEmptyText="true">
                                </asp:RequiredFieldValidator>
                            </EditItemTemplate>
                            <ItemTemplate>
                            <asp:label ID="lblValue" runat="server" Text='<%# Bind("DebtValue") %>'></asp:label>
                            </ItemTemplate>
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="التاريخ">
                            <EditItemTemplate>
                                <asp:TextBox ID="txtDate" CssClass="EditTxt" AutoCompleteType="Disabled" runat="server" Text='<%# Bind("ScheduledDate") %>'></asp:TextBox>
                                <asp:RequiredFieldValidator ID="Required3" runat="server"
                                    ControlToValidate="txtDate" Display="Dynamic" SetFocusOnError="true"
                                    ToolTip="ماركة المنتج متطلب اساسى"
                                    ForeColor="Red"
                                    Text="*" ValidateEmptyText="true">
                                </asp:RequiredFieldValidator>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:label ID="lblDate" runat="server" Text='<%# Bind("ScheduledDate") %>'></asp:label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="الوصف">
                            <EditItemTemplate>
                                <asp:TextBox ID="txtDescription" CssClass="EditTxt" AutoCompleteType="Disabled" runat="server" Text='<%# Bind("Description") %>'></asp:TextBox>
                                <asp:RequiredFieldValidator ID="Required2" runat="server"
                                    ControlToValidate="txtDescription" Display="Dynamic" SetFocusOnError="true"
                                    ToolTip="بوصه المنتج متطلب اساسى"
                                    ForeColor="Red"
                                    Text="*" ValidateEmptyText="true">
                                </asp:RequiredFieldValidator>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="lblDescription" runat="server" Text='<%# Bind("Description") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                <HeaderStyle CssClass="HeaderStyleBill" />
                <RowStyle CssClass="RowStyleList" />
                <AlternatingRowStyle CssClass="AlternateRowStyleList" />
                <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                <FooterStyle CssClass="FooterStyleBill" />
            </asp:GridView>
            <br/>
            <asp:Label runat="server" ID="lblSuccessMessage" ForeColor="Green" Text=""></asp:Label>
            <br/>
            <asp:Label runat="server" ID="lblErrorMessage" ForeColor="Red" Text=""></asp:Label>
        </section>
    </section>
    <footer class="AddSupplierChequeFooter">
        <div class="MsgDiv" style="text-align: center">
            <asp:Button ID="BtnFinish" runat="server" Text="انهاء" CssClass="BtnNext" OnClick="BtnFinish_Click" />
        </div>
        <div class="MsgDiv">
            <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
        </div>
    </footer>
</asp:Content>
