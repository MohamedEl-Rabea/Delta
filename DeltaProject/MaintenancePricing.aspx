<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="MaintenancePricing.aspx.cs" Inherits="DeltaProject.MaintenancePricing" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .RBLCategories2 {
            width: 290px;
            margin: 0px 0px 10px 380px;
        }
    </style>
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
        <p>تسعير صيانة</p>
    </header>
    <asp:RadioButtonList ID="RadioButtonListCategories" runat="server" RepeatDirection="Horizontal" CssClass="RBLCategories2"
                         OnSelectedIndexChanged="RadioButtonListCategories_SelectedIndexChanged" AutoPostBack="true">
        <asp:ListItem Value="MaintenanceTitle" Selected="True">اسم الصيانة</asp:ListItem>
        <asp:ListItem Value="ClientName">اسم العميل</asp:ListItem>
        <asp:ListItem Value="PhoneNumber">رقم التليفون</asp:ListItem>
    </asp:RadioButtonList>
    <section class="Search_Section">
        <table class="Search_table">
            <tr>
                <td class="Image_td">
                    <asp:ImageButton ID="ImageButtonSearch" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                                     Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearch_Click" />
                </td>
                <td class="Search_td">
                    <asp:TextBox ID="txtMaintenanceTitle" runat="server" AutoCompleteType="Disabled"  CssClass="Search_TextBox"
                                 placeholder="اسم الصيانة للبحث . . . . ."></asp:TextBox> 
                    <asp:TextBox ID="txtClientName" runat="server" AutoCompleteType="Disabled" Visible="false" CssClass="Search_TextBox"
                                 placeholder="اسم العميل للبحث . . . . ."></asp:TextBox>
                    <asp:TextBox ID="txtPhoneNumber" runat="server" AutoCompleteType="Disabled" Visible="false" CssClass="Search_TextBox"
                                 placeholder="رقم التليفون للبحث . . . . ."></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td></td>
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
            <asp:Label ID="LabelErrMsg" runat="server" CssClass="LblErrorMsg2" Text="لا توجد صيانات مسجله"></asp:Label>
        </article>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelAllMaintenance" CssClass="PanelProductList" Visible="false">
        <asp:GridView ID="GridViewMaintenance" runat="server" AutoGenerateColumns="False" CssClass="Gridview_Style2"
            EmptyDataText="لا توجد صيانات غير مسعره"
            HeaderText="اسم الصيانة"
            SortExpression="Title"
            DataKeyNames="Id"
            AllowPaging="True"
            OnPageIndexChanging="GridViewMaintenance_OnPageIndexChanging">
            <Columns>
                <asp:BoundField DataField="Id" SortExpression="Id" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                <asp:BoundField DataField="Title" HeaderText="اسم الصيانة" SortExpression="Title" />
                <asp:BoundField DataField="WorkshopName" HeaderText="اسم الورشة" SortExpression="WorkshopName" />
                <asp:BoundField DataField="OrderDate" HeaderText="تاريخ الصيانة" SortExpression="OrderDate"  DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="ClientName" HeaderText="اسم العميل" SortExpression="ClientName" />
                <asp:TemplateField HeaderText="التكلفة">
                    <ItemTemplate>
                        <asp:TextBox ID="txtCost" CssClass="EditTxt" runat="server" AutoCompleteType="Disabled" Style="height: 22px;" placeholder="التكلفة"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                            ControlToValidate="txtCost" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="التكلفة متطلب اساسى" ValidationGroup="<%# Container.DataItemIndex %>">
                                <img src="Images/Error.png" width="15" height="15"/>
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator1" runat="server"
                            ValidationGroup="<%# Container.DataItemIndex %>"
                            ToolTip="يجب كتابة التكلفة بشكل صحيح"
                            ControlToValidate="txtCost"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ClientValidationFunction="IsValidDecimal">
                                <img src="Images/Error.png" width="15" height="15"/>
                        </asp:CustomValidator>
                        <asp:CustomValidator ID="CustomValidator2" runat="server" SetFocusOnError="true" Display="Dynamic"
                            ControlToValidate="txtCost" ClientValidationFunction="IsValidNumber" ToolTip="يجب الا تقل التكلفة عن 1" ValidationGroup="<%# Container.DataItemIndex %>">
                            <img src="Images/Error.png" width="15" height="15"/>
                        </asp:CustomValidator>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="السعر">
                    <ItemTemplate>
                        <asp:TextBox ID="txtPrice" CssClass="EditTxt" runat="server" AutoCompleteType="Disabled" Style="height: 22px;" placeholder="السعر"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                                    ControlToValidate="txtPrice" Display="Dynamic" SetFocusOnError="true"
                                                    ToolTip="السعر متطلب اساسى" ValidationGroup="<%# Container.DataItemIndex %>">
                            <img src="Images/Error.png" width="15" height="15"/>
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator3" runat="server"
                                             ValidationGroup="<%# Container.DataItemIndex %>"
                                             ToolTip="يجب كتابة السعر بشكل صحيح"
                                             ControlToValidate="txtPrice"
                                             Display="Dynamic"
                                             SetFocusOnError="true"
                                             ClientValidationFunction="IsValidDecimal">
                            <img src="Images/Error.png" width="15" height="15"/>
                        </asp:CustomValidator>
                        <asp:CustomValidator ID="CustomValidator4" runat="server" SetFocusOnError="true" Display="Dynamic"
                                             ControlToValidate="txtPrice" ClientValidationFunction="IsValidNumber" ToolTip="يجب الا يقل السعر عن 1" ValidationGroup="<%# Container.DataItemIndex %>">
                            <img src="Images/Error.png" width="15" height="15"/>
                        </asp:CustomValidator>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField SortExpression="Id">
                    <ItemTemplate>
                        <asp:Button ID="btnPricing" runat="server" Text="تسعير" CssClass="BtnaddInGrid" OnClick="btnPricing_OnClick" ValidationGroup="<%# Container.DataItemIndex %>" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>

            <PagerStyle CssClass="PagerStyle" HorizontalAlign="Center" />
            <HeaderStyle CssClass="HeaderStyleList" />
            <RowStyle CssClass="RowStyleListHigher" />
            <AlternatingRowStyle CssClass="AlternateRowStyleListHigher" />
            <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
            <SelectedRowStyle CssClass="SelectedRowStyle" />
        </asp:GridView>
        <footer class="PayMaintenaceFooter">
            <div class="MsgDiv">
                <asp:Label ID="lblSaveMsg" runat="server" CssClass="MessageLabel" ForeColor="Green"></asp:Label>
            </div>
        </footer>
    </asp:Panel>
</asp:Content>
