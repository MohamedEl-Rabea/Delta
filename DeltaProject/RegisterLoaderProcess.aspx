<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="RegisterLoaderProcess.aspx.cs" Inherits="DeltaProject.RegisterLoaderProcess"  Culture = "ar-EG" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
    <link href="CSS/jquery.datetimepicker.min.css" rel="stylesheet" /> 
    <script type="text/javascript" src="Script/ValidationScript.js"></script>
    <script src="Script/jquery.datetimepicker.full.js"></script>
    <script src="Script/jquery.datetimepicker.js"></script>
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
    </script>
    <script type="text/javascript">
        $(function () {
            $('#<%= date.ClientID%>').datetimepicker({
                value: new Date(),
                isRTL: false,
                format: 'd/m/Y h:i A',
                formatTime: 'h:i A',
                formatDate: 'd/m/Y',
                step: 30
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
        <header class="Header">
        <p>تسجيل عملية ونش</p>
    </header>
    <asp:Panel runat="server" ID="PanelRegisterLoaderProcess">
        <section>
            <table class="AddProductsTable">
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">اسم الونش :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:DropDownList ID="ddlLoaders" runat="server" CssClass="txts3"
                            Style="width: 100%; height: auto"
                            DataTextField="Name" 
                            DataValueField="Id">
                        </asp:DropDownList>
                    </td>
                    <td class="RHSTD">
                        <p class="RHSP">رقم الإذن :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtPermissionNumber" CssClass="txts3" PlaceHolder="رقم الإذن" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                            ControlToValidate="ddlLoaders" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="اسم الونش متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                                                    ControlToValidate="txtPermissionNumber" Display="Dynamic" SetFocusOnError="true"
                                                    ToolTip="رقم الاذن متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>
                </tr>

                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">اسم العميل :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtClientName" CssClass="txts3" PlaceHolder="اسم العميل" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                    <td class="RHSTD">
                        <p class="RHSP">رقم التليفون :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtPhoneNumber" CssClass="txts3" PlaceHolder="رقم التليفون" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                            ControlToValidate="txtClientName" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="اسم العميل متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td>
                        <asp:Label ID="lblPhoneMsg" runat="server" CssClass="MessageLabel"></asp:Label>
                        <asp:CustomValidator ID="CustomValidator1" runat="server"
                            ToolTip="يجب كتابة الرقم بشكل صحيح"
                            ControlToValidate="txtPhoneNumber"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ClientValidationFunction="IsValidNumber">
                        <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                    </td>
                </tr>

                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">التكلفة :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtCost" CssClass="txts3" PlaceHolder="التكلفة" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                    <td class="RHSTD">
                        <p class="RHSP">المدفوع :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtPaid" CssClass="txts3" PlaceHolder="المدفوع" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                                                    ControlToValidate="txtCost" Display="Dynamic" SetFocusOnError="true"
                                                    ToolTip="التكلفة متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator5" runat="server"
                                             ToolTip="يجب كتابة التكلفة بشكل صحيح"
                                             ControlToValidate="txtCost"
                                             Display="Dynamic"
                                             SetFocusOnError="true"
                                             ClientValidationFunction="IsValidDecimal">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                    </td>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                                                    ControlToValidate="txtPaid" Display="Dynamic" SetFocusOnError="true"
                                                    ToolTip="المبلغ المدفوع متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator2" runat="server"
                                             ToolTip="يجب كتابة المبلغ المدفوع بشكل صحيح"
                                             ControlToValidate="txtPaid"
                                             Display="Dynamic"
                                             SetFocusOnError="true"
                                             ClientValidationFunction="IsValidDecimal">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                    </td>
                </tr>
                
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">ت. الخروج :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="date" CssClass="txts3" PlaceHolder="تاريخ ووقت الخروج"></asp:TextBox>
                    </td>
                </tr>
            
            <tr>
            <td class="RHSTD">
                <br />
                <br />
            </td>
            <td class="ValodationTD">
                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server"
                                            ControlToValidate="Date" Display="Dynamic" SetFocusOnError="true"
                                            ToolTip="تاريخ ووقت الخروج متطلب اساسى">
                    <img src="Images/Error.png" width="24" height="24"/>
                </asp:RequiredFieldValidator>
            </td>
            </tr>
            </table>
        </section>
        <footer class="AddMaintenanceFooter">
            <div class="MsgDiv" style="text-align: center">
                <asp:Button ID="BtnSave" runat="server" Text="حفظ" CssClass="BtnNext" OnClick="BtnRegister_Click" />
            </div>
            <div class="MsgDiv">
                <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
            </div>
        </footer>
    </asp:Panel>
</asp:Content>
