<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="SearchForMaintenances.aspx.cs" Inherits="DeltaProject.SearchForMaintenances" %>

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

        $(document).ready(function () {
            $('.textWithDots').on('click', function () {
                var classList = this.classList;
                if (classList.contains('textWithDotsCollapse')) {
                    this.classList.remove('textWithDotsCollapse');
                }
                else {
                    this.classList.add('textWithDotsCollapse');
                }
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>استعلام عن الصيانات</p>
    </header>
    <asp:RadioButtonList ID="RadioButtonListCategories" runat="server" RepeatDirection="Horizontal" CssClass="RBLCategories2"
        OnSelectedIndexChanged="RadioButtonListCategories_SelectedIndexChanged" AutoPostBack="true">
        <asp:ListItem Value="Normal" Selected="True">اسم العميل</asp:ListItem>
        <asp:ListItem Value="Motors">رقم التليفون</asp:ListItem>
    </asp:RadioButtonList>
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
                    <asp:TextBox ID="txtPhoneNumber" runat="server" AutoCompleteType="Disabled" Visible="false" CssClass="Search_TextBox"
                        placeholder="رقم التليفون للبحث . . . . ."></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td></td>
                <td style="text-align: center">
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
        </table>
    </section>
    <asp:Panel ID="PanelErrorMessage" runat="server" CssClass="ErrorMessagePanal" Visible="false">
        <article class="Errorarticle">
            <asp:Label ID="LabelErrMsg" runat="server" CssClass="LblErrorMsg2" Text="لا توجد صيانات مسجله لهذا العميل / الرقم"></asp:Label>
        </article>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelAllMaintenance" Visible="false">
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkBtnMaintenance" runat="server" CssClass="TabLnks"
                    ToolTip="عرض كافة الصيانات الخاصه بهذا العميل">الصيانات</asp:LinkButton>
            </div>
        </header>
        <asp:Panel runat="server" ID="PanelMaintenance" CssClass="PreReport_SectionTab">
            <asp:GridView ID="GridViewMaintenance" runat="server" AutoGenerateColumns="False" CssClass="Gridview_Style2"
                          EmptyDataText="لا توجد صيانات لهذا العميل"
                          HeaderText="اسم الصيانة"
                          SortExpression="Title">
            <columns>
                <asp:BoundField DataField="Title" HeaderText="اسم الصيانة" SortExpression="Title" />
                <asp:BoundField DataField="WorkshopName" HeaderText="اسم الورشة" SortExpression="WorkshopName" />
                <asp:BoundField DataField="OrderDate" HeaderText="تاريخ الصيانة" SortExpression="OrderDate"  DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="StatusName" HeaderText="الحالة" SortExpression="StatusName" />
                <asp:BoundField DataField="AgreedCost" HeaderText="التكلفة" SortExpression="AgreedCost" DataFormatString="{0:0.##}" />
                <asp:BoundField DataField="RemainingAmount" HeaderText="المتبقى" SortExpression="RemainingAmount" DataFormatString="{0:0.##}"  />
                <asp:BoundField DataField="Description" HeaderText="الوصف" SortExpression="Description" >
                    <HeaderStyle Width="50%"></HeaderStyle>
                    <ItemStyle CssClass="textWithDotsCollapse textWithDots"></ItemStyle>
                </asp:BoundField>
            </columns>
            <rowstyle cssclass="Row_Style nowrap" />
            <pagerstyle cssclass="PagerStyle" horizontalalign="Center" />
            <emptydatarowstyle cssclass="EmptyDataRowStyle" />
            </asp:GridView>
        </asp:Panel>
    </asp:Panel>
</asp:Content>
