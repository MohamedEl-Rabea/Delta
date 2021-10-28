<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Client_Debts_Schedule.aspx.cs" Inherits="DeltaProject.Client_Debts_Schedule" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
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
            var dateInputs = $(".dateInput");
            if (dateInputs != undefined)
                dateInputs.datepicker(options);
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>جدولة ديون العميل</p>
    </header>
    <section>
        <section>
            <table style="width: 100%; direction: rtl;">
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
        <br />
        <section>
            <asp:GridView runat="server" ID="gridViewDebts" CssClass="GridViewBill"
                DataKeyNames="Id"
                ShowHeaderWhenEmpty="true"
                AutoGenerateColumns="False"
                EmptyDataText="لا توجد دفعات مسجلة"
                ShowFooter="true"
                OnRowCommand="gridViewDebts_OnRowCommand"
                OnRowDataBound="gridViewDebts_RowDataBound">
                <Columns>
                    <asp:BoundField DataField="Id" Visible="false" SortExpression="Id" />
                    <asp:TemplateField HeaderText="القيمة">
                        <EditItemTemplate>
                            <asp:TextBox ID="txtDebtValue" runat="server" CssClass="EditTxt-md" Text='<%# Bind("DebtValue") %>'></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                                ControlToValidate="txtDebtValue" Display="Dynamic" SetFocusOnError="true"
                                ToolTip="قيمة الدين مطلوبه"
                                ForeColor="Red"
                                Text="*" ValidateEmptyText="true">
                            </asp:RequiredFieldValidator>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="lblValue" runat="server" Text='<%# Bind("DebtValue") %>'></asp:Label>
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:TextBox ID="txtNewDebtValue" placeholder="القيمة" runat="server" CssClass="EditTxt-md"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server"
                                ControlToValidate="txtNewDebtValue"
                                ValidationGroup="AddNewDebtValidationGroup"
                                Display="Dynamic"
                                SetFocusOnError="true"
                                ToolTip="قيمة الدين مطلوبه"
                                ForeColor="Red"
                                Text="*" ValidateEmptyText="true">
                            </asp:RequiredFieldValidator>
                        </FooterTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="التاريخ">
                        <EditItemTemplate>
                            <asp:TextBox ID="txtDebtDate" CssClass="EditTxt-md dateInput" AutoCompleteType="Disabled"
                                runat="server"
                                Text='<%# Eval("ScheduledDate", "{0:dd/MM/yyyy}") %>'>
                            </asp:TextBox>
                            <asp:RequiredFieldValidator ID="Required3" runat="server"
                                ControlToValidate="txtDebtDate" Display="Dynamic" SetFocusOnError="true"
                                ToolTip="التاريخ مطلوب"
                                ForeColor="Red"
                                Text="*" ValidateEmptyText="true">
                            </asp:RequiredFieldValidator>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="lblDate" runat="server" Text='<%# Eval("ScheduledDate", "{0:dd/MM/yyyy}") %>'></asp:Label>
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:TextBox ID="txtNewDebtDate" CssClass="EditTxt-md dateInput" placeholder="التاريخ" AutoCompleteType="Disabled"
                                runat="server">
                            </asp:TextBox>
                            <asp:RequiredFieldValidator ID="Required14" runat="server"
                                ControlToValidate="txtNewDebtDate" Display="Dynamic" SetFocusOnError="true"
                                ValidationGroup="AddNewDebtValidationGroup"
                                ToolTip="التاريخ مطلوب"
                                ForeColor="Red"
                                Text="*" ValidateEmptyText="true">
                            </asp:RequiredFieldValidator>
                        </FooterTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="الوصف">
                        <EditItemTemplate>
                            <asp:TextBox ID="txtDescription" CssClass="EditTxt-x-lg" AutoCompleteType="Disabled" runat="server" Text='<%# Bind("Description") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="lblDescription" runat="server" Text='<%# Bind("Description") %>'></asp:Label>
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:TextBox ID="txtNewDescription" CssClass="EditTxt-x-lg" placeholder="الوصف" AutoCompleteType="Disabled" runat="server"></asp:TextBox>
                        </FooterTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:ImageButton ID="ImageButtonEdit" runat="server" ImageUrl="~/Images/Edit.png" Width="16" Height="16"
                                CommandName="Edit_Row" CausesValidation="false" />
                            <asp:ImageButton ID="ImageButtonDelete" runat="server" ImageUrl="~/Images/Delete.png" Width="16" Height="16"
                                CausesValidation="false" CommandName="Delete_Row"
                                OnClientClick="return confirm('سيتم مسح هذه الدفعه . . . هل تريد المتابعه ؟');" />
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:ImageButton ID="ImageButtonCancelEdit" runat="server" ImageUrl="~/Images/Cancel.png" Width="16" Height="16"
                                ToolTip="الغاء التعديل" CausesValidation="false" CommandName="Cancel_Update" />
                            <asp:ImageButton ID="ImageButtonConfirmEdit" runat="server" ImageUrl="~/Images/Ok.png" Width="16" Height="16"
                                ToolTip="تاكيد التعديل" CommandName="Confirm_Update" />
                        </EditItemTemplate>
                        <FooterTemplate>
                            <asp:ImageButton ID="ImageButtonAdd" runat="server" ValidationGroup="AddNewDebtValidationGroup"
                                ImageUrl="~/Images/AddNew.png"
                                Width="20"
                                Height="20"
                                CommandName="Add_Row"
                                CausesValidation="true" />
                        </FooterTemplate>
                    </asp:TemplateField>
                </Columns>
                <HeaderStyle CssClass="HeaderStyleBill" />
                <RowStyle CssClass="RowStyleList" />
                <AlternatingRowStyle CssClass="AlternateRowStyleList" />
                <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                <FooterStyle CssClass="FooterStyleBill" />
            </asp:GridView>
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
