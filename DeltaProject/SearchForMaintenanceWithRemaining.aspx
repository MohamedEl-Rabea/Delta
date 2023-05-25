<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="SearchForMaintenanceWithRemaining.aspx.cs" Inherits="DeltaProject.SearchForMaintenanceWithRemaining" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
        <p>دفع مؤجلات صيانه</p>
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
    <asp:Panel runat="server" ID="PanelAllMaintenance" CssClass="PanelProductList" Visible="false">
        <asp:GridView ID="GridViewMaintenance" runat="server" AutoGenerateColumns="False" CssClass="Gridview_Style2"
            EmptyDataText="لا توجد صيانات متبقى لها تكلفة لهذا العميل"
            HeaderText="اسم الصيانة"
            SortExpression="Title"
            DataKeyNames="Id"
            AllowPaging="True"
            OnPageIndexChanging="GridViewMaintenance_OnPageIndexChanging">
            <Columns>
                <asp:BoundField DataField="Id" SortExpression="Id" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                <asp:BoundField DataField="Title" HeaderText="اسم الصيانة" SortExpression="Title" />
                <asp:BoundField DataField="WorkshopName" HeaderText="اسم الورشة" SortExpression="WorkshopName" />
                <asp:BoundField DataField="Price" HeaderText="السعر" SortExpression="Price" DataFormatString="{0:0.##}" />
                <asp:BoundField DataField="RemainingAmount" HeaderText="المبلغ المتبقى" SortExpression="RemainingAmount" DataFormatString="{0:0.##}" />
                <asp:TemplateField HeaderText="المبلغ المدفوع">
                    <ItemTemplate>
                        <asp:TextBox ID="txtPaidAmount" CssClass="EditTxt" runat="server" AutoCompleteType="Disabled" Style="height: 22px;" placeholder="المبلغ المدفوع"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                            ControlToValidate="txtPaidAmount" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="المبلغ المدفوع متطلب اساسى" ValidationGroup="<%# Container.DataItemIndex %>">
                                <img src="Images/Error.png" width="15" height="15"/>
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator5" runat="server"
                            ValidationGroup="<%# Container.DataItemIndex %>"
                            ToolTip="يجب كتابة المبلغ المدفوع بشكل صحيح"
                            ControlToValidate="txtPaidAmount"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ClientValidationFunction="IsValidDecimal">
                                <img src="Images/Error.png" width="15" height="15"/>
                        </asp:CustomValidator>
                        <asp:CustomValidator ID="CustomValidator6" runat="server" SetFocusOnError="true" Display="Dynamic"
                            ControlToValidate="txtPaidAmount" ClientValidationFunction="IsValidNumber" ToolTip="يجب الا تقل القيمة عن 1" ValidationGroup="<%# Container.DataItemIndex %>">
                            <img src="Images/Error.png" width="15" height="15"/>
                        </asp:CustomValidator>
                        <asp:CustomValidator ID="CustomValidator1" runat="server"
                            ToolTip="يجب الا تزيد القيمه المدفوعه عن المتبقيه"
                            ControlToValidate="txtPaidAmount"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ClientValidationFunction="IsValidPaidAmount" ValidationGroup="<%# Container.DataItemIndex %>">
                                <img src="Images/Error.png" width="15" height="15"/>
                        </asp:CustomValidator>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="تاريخ الدفع">
                    <ItemTemplate>
                        <asp:TextBox runat="server" ID="txtPaymentDate" ClientIDMode="AutoID" CssClass="EditTxt dateInput" PlaceHolder="تاريخ الدفع" Style="height: 22px;" AutoCompleteType="Disabled"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                            ControlToValidate="txtPaymentDate" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="تاريخ الدفع متطلب اساسى" ValidationGroup="<%# Container.DataItemIndex %>">
                                <img src="Images/Error.png" width="15" height="15"/>
                        </asp:RequiredFieldValidator>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField SortExpression="Id">
                    <ItemTemplate>
                        <asp:Button ID="btnPay" runat="server" Text="دفع" CssClass="BtnaddInGrid" OnClick="btnPay_OnClick" ValidationGroup="<%# Container.DataItemIndex %>" />
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

