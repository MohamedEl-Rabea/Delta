<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Add_Client_Offer.aspx.cs" Inherits="DeltaProject.Add_Client_Offer" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
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
            var options = $.extend(
                {},
                $.datepicker.regional["ar"],
                {
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'dd/mm/yy'
                }
            );
            $('#<%= txtDate.ClientID%>').datepicker(options);
            $('#<%= txtDate.ClientID%>').datepicker("setDate", new Date());
        });
    </script>
    </asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>اضافــــة عرض عميل</p>
    </header>
    <asp:Panel runat="server" ID="PanelAddClientOffer">
        <section>
            <table class="AddProductsTable">
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">اسم العميل :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtClientName" CssClass="txts3" PlaceHolder="اسم العميل" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>

                   <td class="RHSTD">
                        <p class="RHSP">الاسم :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtName" CssClass="txts3" PlaceHolder="اسم العرض" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                            ControlToValidate="txtClientName" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="اسم العميل متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>

                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td style="text-align: center">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                                    ControlToValidate="txtName" Display="Dynamic" SetFocusOnError="true"
                                                    ToolTip="اسم العرض متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>
                </tr>

                <tr>
                   <td class="RHSTD">
                      <p class="RHSP">التاريخ :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtDate" CssClass="txts3" PlaceHolder="التاريخ"></asp:TextBox>
                    </td> 
                    <td class="RHSTD">
                        <p class="RHSP">ملاحظات :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" TextMode="MultiLine" ID="txtNotes" CssClass="txts3" PlaceHolder="ملاحظات" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                                                    ControlToValidate="txtDate" Display="Dynamic" SetFocusOnError="true"
                                                    ToolTip="تاريخ الاستحقاق متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                </tr>
                
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">الملف :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:FileUpload runat="server" ID="fileUpload"  />
                    </td>

                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                            ControlToValidate="fileUpload" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="الملف متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>

                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="RHSTD">
                        <asp:Label runat="server" ID="fileUploadLabel"></asp:Label>
                    </td>
                </tr>
            </table>
        </section>
        <footer class="AddClientChequeFooter">
            <div class="MsgDiv" style="text-align: center">
                <asp:Button ID="BtnAdd" runat="server" Text="انشاء" CssClass="BtnNext" OnClick="BtnAdd_OnClickAdd_Click" />
            </div>
            <div class="MsgDiv">
                <asp:Label ID="lblAddedMsg" runat="server" CssClass="MessageLabel"></asp:Label>
            </div>
        </footer>
    </asp:Panel>
</asp:Content>
