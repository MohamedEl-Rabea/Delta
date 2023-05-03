<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AddMaintenanceExpense.aspx.cs" Inherits="DeltaProject.AddMaintenanceExpenses" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .RHSTD {
            width: auto !important;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            var options = $.extend(
                {},
                $.datepicker.regional["ar"],
                {
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'dd/mm/yy',
                }
            );
            $('#<%= txtDate.ClientID%>').datepicker(options);
            $('#<%= txtDate.ClientID%>').datepicker("setDate", new Date());
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>اضافة مصروف صيانة</p>
    </header>
    <asp:Panel runat="server" ID="PanelAddMaintenanceExpense">
        <section>
            <table class="AddProductsTable">
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">اسم الورشة :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:DropDownList ID="ddlWorkshops" runat="server" CssClass="txts3"
                            Style="width: 100%; height: auto"
                            DataTextField="Name" 
                            DataValueField="Id">
                        </asp:DropDownList>
                    </td>
                    <td class="RHSTD">
                        <p class="RHSP">ت. المصروف :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtDate" CssClass="txts3" PlaceHolder="تاريخ المصروف"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                            ControlToValidate="ddlWorkshops" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="اسم الورشة متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td> 
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                                    ControlToValidate="txtDate" Display="Dynamic" SetFocusOnError="true"
                                                    ToolTip="تاريخ المصروف متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>
                </tr>

                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">القيمة :</p>
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="txtAmount" CssClass="txts3" PlaceHolder="القيمة"></asp:TextBox>
                    </td>
                    <td class="RHSTD">
                        <p class="RHSP"> السبب :</p>
                    </td>
                    <td>
                        <asp:TextBox ID="txtReason" runat="server" CssClass="TxtMultiline" 
                                     AutoCompleteType="Disabled" Width="96%" TextMode="MultiLine" 
                                     placeholder="سبب المصروف" Style="min-height: auto;resize: vertical;"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                                                    ControlToValidate="txtAmount" Display="Dynamic" SetFocusOnError="true"
                                                    ToolTip="القيمة متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator1" runat="server"
                                             ToolTip="يجب كتابة القيمة بشكل صحيح"
                                             ControlToValidate="txtAmount"
                                             Display="Dynamic"
                                             SetFocusOnError="true"
                                             ClientValidationFunction="IsValidDecimal">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                        <asp:CustomValidator ID="CustomValidator2" runat="server" SetFocusOnError="true" Display="Dynamic"
                                             ControlToValidate="txtAmount" ClientValidationFunction="IsValidNumber" ToolTip="يجب الا تقل القيمة عن 1">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                    </td>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD" colspan="3">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                            ControlToValidate="txtReason" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="السبب متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>
                </tr>
            </table>
        </section>
        <footer class="AddMaintenanceFooter">
            <div class="MsgDiv" style="text-align: center">
                <asp:Button ID="BtnSave" runat="server" Text="حفظ" CssClass="BtnNext" OnClick="BtnSave_Click" />
            </div>
            <div class="MsgDiv">
                <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
            </div>
        </footer>
    </asp:Panel>
</asp:Content>
