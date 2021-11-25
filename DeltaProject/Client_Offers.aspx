<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Client_Offers.aspx.cs" Inherits="DeltaProject.ClientOffers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
    <link href="CSS/jquery-ui-1.10.4.custom.min.css" rel="stylesheet" />
    <script src="Script/jquery-1.10.2.js"></script>
    <script src="Script/jquery-ui-1.10.4.custom.min.js"></script>
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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>عروض اسعار العملاء</p>
    </header>
    <section class="Search_Section">
        <table class="Search_table">
            <tr>
                <td class="Image_td">
                    <asp:ImageButton ID="ImageButtonSearch" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                        Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearch_Click" />
                </td>
                <td class="Search_td">
                    <asp:TextBox ID="txtClientName" runat="server" AutoCompleteType="Disabled" CssClass="Search_TextBox"
                        placeholder="اسم العميل للبحث . . . . ."></asp:TextBox>
                </td>
            </tr>

        </table>
    </section>

    <asp:Panel ID="PanelErrorMessage" runat="server" CssClass="ErrorMessagePanal" Visible="false">
        <article class="Errorarticle">
            <asp:Label ID="lblErrorMsg" runat="server" CssClass="LblErrorMsg2" Text="لا توجد عروض اسعار لهذا العميل"></asp:Label>
        </article>
    </asp:Panel>

    <asp:Panel runat="server" ID="PanelClientOffers">
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkBtnAllClientsOffers" runat="server" CssClass="TabLnks"
                    ToolTip="عرض كل عروض الاسعار الخاصه بهذا العميل">الكـــــل</asp:LinkButton>
            </div>
        </header>
        <asp:Panel runat="server" ID="PanelAllClientsOffers" CssClass="PreReport_SectionTab" Visible="true">
            <asp:GridView ID="GridViewAllClientsOffers" runat="server" AutoGenerateColumns="False"
                CssClass="Gridview_Style2"
                EmptyDataText="لا توجد عروض أسعار لهذا العميل"
                DataKeyNames="Id"
                OnRowCommand="GridViewAllClientsOffers_RowCommand">
                <Columns>
                    <asp:BoundField DataField="Id" Visible="false" SortExpression="Id" />
                    <asp:BoundField DataField="ClientName" HeaderText="اسم العميل" />
                    <asp:BoundField DataField="Name" HeaderText="اسم العرض" />
                    <asp:BoundField DataField="Date" HeaderText="تاريخ العرض" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="Notes" HeaderText="ملاحظات" SortExpression="Notes" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Label ID="lblFileName" runat="server" Text='<%# Bind("FileName") %>' Visible="False"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:ImageButton ID="ImageButtonDownload" runat="server" ImageUrl="~/Images/Download.png"
                                Width="16"
                                Height="16"
                                CausesValidation="false"
                                CommandName="Download_File" 
                                ToolTip="تنزيل الملف"/>
                            &nbsp;&nbsp;
                            <asp:ImageButton ID="ImageButtonDelete" runat="server" ImageUrl="~/Images/Delete.png"
                                Width="16"
                                Height="16"
                                CausesValidation="false"
                                CommandName="Delete_Row"
                                ToolTip="مسح الملف"
                                OnClientClick="return confirm('سيتم مسح هذا العرض نهائيا. . . هل تريد المتابعه ؟');" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <RowStyle CssClass="Row_Style" />
                <EmptyDataRowStyle CssClass="Empty_Style" />
            </asp:GridView>
        </asp:Panel>
        <div class="MsgDiv">
            <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
        </div>
    </asp:Panel>
</asp:Content>
