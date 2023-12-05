<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AddMaintenanceWithdraw.aspx.cs" Inherits="DeltaProject.AddMaintenanceWithdraw" %>
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
        <p>اضافة سحب صيانة</p>
    </header>
    <asp:Panel runat="server" ID="PanelAddMaintenanceWithdraw">
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
                            DataValueField="Id"
                            OnSelectedIndexChanged="ddlWorkshops_OnSelectedIndexChanged"
                            AutoPostBack="True">
                        </asp:DropDownList>
                    </td>
                    <td class="RHSTD">
                        <p class="RHSP">اسم الشريك :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:DropDownList ID="ddlPartners" runat="server" CssClass="txts3"
                                          Style="width: 100%; height: auto" Enabled="False"
                                          DataTextField="Name" 
                                          DataValueField="Id">
                        </asp:DropDownList>
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
                                                    ControlToValidate="ddlPartners" Display="Dynamic" SetFocusOnError="true"
                                                    ToolTip="اسم الشريك متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td> 
                </tr>

                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">ت. السحب :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtDate" CssClass="txts3" PlaceHolder="تاريخ السحب"></asp:TextBox>
                    </td>
                    <td class="RHSTD">
                        <p class="RHSP">القيمة :</p>
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="txtAmount" CssClass="txts3" PlaceHolder="القيمة"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                                                    ControlToValidate="txtDate" Display="Dynamic" SetFocusOnError="true"
                                                    ToolTip="تاريخ السحب متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
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
                </tr>
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP"> ملاحظات :</p>
                    </td>
                    <td colspan="3">
                        <asp:TextBox ID="txtNotes" runat="server" CssClass="TxtMultiline" 
                                     AutoCompleteType="Disabled" Width="98%" TextMode="MultiLine" 
                                     placeholder="ملاحظات" Style="min-height: auto;resize: vertical;"></asp:TextBox>
                    </td>
                </tr>
            </table>
            <br/>
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
