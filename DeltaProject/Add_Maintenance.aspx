<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Add_Maintenance.aspx.cs" Inherits="DeltaProject.Add_Maintenance" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
    <script type="text/javascript" src="Script/ValidationScript.js"></script>
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
        $(function () {
            $('#<%= txtWorkshop_Name.ClientID%>').autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: "Services/GetNamesService.asmx/Get_Workshops_Names",
                        data: "{ 'workshop_Name': '" + request.term + "' }",
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
            var options = $.extend(
                {},
                $.datepicker.regional["ar"],
                {
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'dd/mm/yy'
                }
            );
            $('#<%= OrderDate.ClientID%>').datepicker(options);
            $('#<%= OrderDate.ClientID%>').datepicker("setDate", new Date());

            $('#<%= ExpectedDeliveryDate.ClientID%>').datepicker(options);
            $('#<%= ExpectedDeliveryDate.ClientID%>').datepicker("setDate", new Date());
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
        <header class="Header">
        <p>اضافــــة صيانه</p>
    </header>
    <asp:Panel runat="server" ID="PanelAddClientCheque">
        <section>
            <table class="AddProductsTable">
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">اسم الصيانه :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtTitle" CssClass="txts3" PlaceHolder="اسم الصيانه" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>

                   <td class="RHSTD">
                        <p class="RHSP">المبلغ :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtAgreedCost" CssClass="txts3" PlaceHolder="المبلغ" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                            ControlToValidate="txtTitle" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="اسم الصيانه متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>

                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                                                    ControlToValidate="txtAgreedCost" Display="Dynamic" SetFocusOnError="true"
                                                    ToolTip="المبلغ متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator5" runat="server"
                                             ToolTip="يجب كتابة المبلغ بشكل صحيح"
                                             ControlToValidate="txtAgreedCost"
                                             Display="Dynamic"
                                             SetFocusOnError="true"
                                             ClientValidationFunction="IsValidDecimal">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
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
                        <p class="RHSP">اسم الورشة :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtWorkshop_Name" CssClass="txts3" PlaceHolder="اسم الورشة" AutoCompleteType="Disabled"></asp:TextBox>
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
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                                                    ControlToValidate="txtWorkshop_Name" Display="Dynamic" SetFocusOnError="true"
                                                    ToolTip="اسم الورشة متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>
                </tr>
                
                <tr>
                    <td class="RHSTD">
                        <p class="RHSPSmall">ت. الصيانة :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="OrderDate" CssClass="txts3" PlaceHolder="تاريخ الصيانة"></asp:TextBox>
                    </td>
                    <td class="RHSTD">
                        <p class="RHSPSmall">ت. التسليم :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="ExpectedDeliveryDate" CssClass="txts3" PlaceHolder="تاريخ التسليم المتوقع"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                            <br />
                            <br />
                        </td>
                    <td class="ValodationTD">
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                                                        ControlToValidate="OrderDate" Display="Dynamic" SetFocusOnError="true"
                                                        ToolTip="تاريخ الصيانة متطلب اساسى">
                                <img src="Images/Error.png" width="24" height="24"/>
                            </asp:RequiredFieldValidator>
                        </td>
                    <td class="RHSTD">
                            <br />
                            <br />
                        </td>
                    <td class="ValodationTD">
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server"
                                                        ControlToValidate="ExpectedDeliveryDate" Display="Dynamic" SetFocusOnError="true"
                                                        ToolTip="تاريخ التسليم المتوقع متطلب اساسى">
                                <img src="Images/Error.png" width="24" height="24"/>
                            </asp:RequiredFieldValidator>
                        </td>
                </tr>
                
                <tr>
                    <td style="vertical-align: top">
                        <p class="RHSP">الوصـــــــف :</p>
                    </td>
                    <td colspan="3">
                        <asp:TextBox ID="txtDescription" runat="server" CssClass="TxtMultiline" AutoCompleteType="Disabled"
                                     TextMode="MultiLine" placeholder="اضف وصفا للصيانه ....."></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD" colspan="3">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server"
                                                    ControlToValidate="txtDescription" Display="Dynamic" SetFocusOnError="true"
                                                    ToolTip="الوصف متطلب اساسى">
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
