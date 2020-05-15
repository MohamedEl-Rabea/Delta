<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Delete_Client.aspx.cs" Inherits="DeltaProject.Delete_Client" %>

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
        <p>مسح عميل</p>
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
    <asp:Panel runat="server" ID="PanelClientInfo" Visible="false">
        <section style="width: 100%; text-align: right; direction: rtl">
            <header class="PreSection">
                <div>
                    <p>بيانات شخصيه</p>
                </div>
            </header>
        </section>
        <section class="PreReport_Section">
            <table class="AddProductsTable">
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">اسم العمـــيل :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:Label ID="lblClientName" runat="server" CssClass="lblInfo"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <br />
                        <br />
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">العنــــــوان :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:Label ID="lblAddress" runat="server" CssClass="lblInfo"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <br />
                        <br />
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">رقم الحساب :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:Label ID="lblAccountNumber" runat="server" CssClass="lblInfo"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                </tr>
            </table>
        </section>
        <br />
        <br />
        <footer class="AddSupplierFooter">
            <asp:Button ID="BtnDelete" runat="server" Text="مسح" CssClass="BtnNext" OnClick="BtnDelete_Click" />
            <div class="MsgDiv">
                <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
            </div>
        </footer>
    </asp:Panel>
    <asp:Panel ID="PanelErrorMessage" runat="server" CssClass="ErrorMessagePanal" Visible="false">
        <article class="Errorarticle">
            <asp:Label ID="LabelErrMsg" runat="server" CssClass="LblErrorMsg2" Text="هذا العميل غير مسجل لدينا ... اما هناك خطأ فى الاسم او لو يدرج اى اسم"></asp:Label>
        </article>
    </asp:Panel>
</asp:Content>
