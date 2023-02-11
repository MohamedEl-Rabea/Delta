<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="SearchForNotDeliveredMaintenance.aspx.cs" Inherits="DeltaProject.SearchForNotDeliveredMaintenance" %>

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
            $('#<%= DeliveryDate.ClientID%>').datepicker(options);
            $('#<%= DeliveryDate.ClientID%>').datepicker("setDate", new Date());
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>تسليم</p>
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
        <asp:Panel runat="server" ID="PanelMaintenance" CssClass="PreReport_SectionTab">
            <asp:GridView ID="GridViewMaintenance" runat="server" AutoGenerateColumns="False" CssClass="Gridview_Style2"
                EmptyDataText="لا توجد صيانات غير مستلمة لهذا العميل"
                HeaderText="اسم الصيانة"
                SortExpression="Title"
                DataKeyNames="Id"
                OnRowCommand="GridViewMaintenance_OnRowCommand">
                <Columns>
                    <asp:BoundField DataField="Id" SortExpression="Id" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                    <asp:BoundField DataField="Title" HeaderText="اسم الصيانة" SortExpression="Title" />
                    <asp:BoundField DataField="WorkshopName" HeaderText="اسم الورشة" SortExpression="WorkshopName" />
                    <asp:BoundField DataField="AgreedCost" HeaderText="التكلفة" SortExpression="AgreedCost" DataFormatString="{0:0.##}" />
                    <asp:TemplateField HeaderText="تسليم" SortExpression="Id">
                        <ItemTemplate>
                            <asp:ImageButton ID="LinkButtonDeliver" runat="server" ImageUrl="~/Images/LeftArrow.png" Width="20" Height="20"
                                ToolTip="الانتقال الى تفاصيل التسليم" CommandName="Deliver"></asp:ImageButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <RowStyle CssClass="Row_Style nowrap" />
                <PagerStyle CssClass="PagerStyle" HorizontalAlign="Center" />
                <EmptyDataRowStyle CssClass="EmptyDataRowStyle" />
            </asp:GridView>
        </asp:Panel>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelDeliverMaintenance" Visible="false">
        <section class="ContactsSection" style="border-radius: 8px; width: 99%; text-align: right; direction: rtl; padding: 10px;">
            <header style="text-align: left">
                <asp:ImageButton ID="ImageButtonBackMaintenance" runat="server" ImageUrl="~/Images/back.png" Width="24" Height="24"
                                 ToolTip="رجوع" OnClick="btnBack_OnClick" CausesValidation="false" />
            </header>
            <header class="Prices_Offer_SubHeaderBill" style="margin-bottom: 20px;">
                <div style="border: 1px solid black">
                    <p style="font: bold 14px arial; margin: 0; padding: 0">تفاصيل التسليم</p>
                </div>
            </header>
            <table class="AddProductsTable" style="width:98%">
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">اسم الصيانة :</p>
                    </td>
                    <td class="RHSTD">
                        <asp:Label runat="server" ID="lblTitle" Text=''/>
                    </td>
                    <td class="RHSTD">
                        <p class="RHSP">التكلفة :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:Label runat="server" ID="lblAgreedCost" Text=''/>
                    </td>
                </tr>
                <tr style="height: 37px">
                    <td colspan="4">
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">المبلغ المدفوع :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtPaidAmount" CssClass="txtAuto" PlaceHolder="المبلغ المدفوع" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>

                    <td class="RHSTD">
                        <p class="RHSP">ت. التسليم :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="DeliveryDate" CssClass="txtAuto" PlaceHolder="تاريخ التسليم"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                     <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                            ControlToValidate="txtPaidAmount" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="المبلغ المدفوع متطلب اساسى" ValidationGroup="SaveGroup">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator5" runat="server"
                                             ValidationGroup="SaveGroup"
                            ToolTip="يجب كتابة المبلغ بشكل صحيح"
                            ControlToValidate="txtPaidAmount"
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
                                                    ControlToValidate="DeliveryDate" Display="Dynamic" SetFocusOnError="true"
                                                    ToolTip="تاريخ التسليم متطلب اساسى" ValidationGroup="SaveGroup">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>
                </tr>
            </table>
         
            <table class="AddProductsTable" style="width:98%">
                
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">مدة التأمين :</p>
                    </td>
                    <td class="tdDateAuto">
                        <asp:TextBox runat="server" ID="txtDay" ClientIDMode="Static" CssClass="txtAuto " PlaceHolder="يوم" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                    <td class="tdDateAuto">
                        <asp:TextBox runat="server" ID="txtMonth" ClientIDMode="Static" CssClass="txtAuto" PlaceHolder="شهر" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                    <td class="tdDateAuto">
                        <asp:TextBox runat="server" ID="txtYear" ClientIDMode="Static" CssClass="txtAuto" PlaceHolder="سنه" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td style="text-align: center">
                        <asp:CustomValidator ID="CustomValidator3" runat="server"
                                             ValidationGroup="SaveGroup"
                                             ToolTip="يجب اضافة عدد الايام بشكل صحيح"
                                             ControlToValidate="txtDay"
                                             Display="Dynamic"
                                             SetFocusOnError="true"
                                             ClientValidationFunction="IsValidNumber">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                    </td>
                    <td style="text-align: center">
                        <asp:CustomValidator ID="CustomValidator4" runat="server"
                                             ValidationGroup="SaveGroup"
                                             ToolTip="يجب اضافة عدد الشهور بشكل صحيح"
                                             ControlToValidate="txtMonth"
                                             Display="Dynamic"
                                             SetFocusOnError="true"
                                             ClientValidationFunction="IsValidNumber">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                    </td>
                    <td style="text-align: center">
                        <asp:CustomValidator ID="CustomValidator2" runat="server"
                                             ValidationGroup="SaveGroup"
                                             ToolTip="يجب اضافة عدد السنين بشكل صحيح"
                                             ControlToValidate="txtYear"
                                             Display="Dynamic"
                                             SetFocusOnError="true"
                                             ClientValidationFunction="IsValidNumber">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                    </td>
                </tr>
         </table>
         <br />
         <footer class="DeliverMaintenaceFooter">
             <div class="MsgDiv" style="text-align: center">
                 <asp:Button ID="btnSave" runat="server" Text="حفظ" CssClass="BtnNext" OnClick="btnSave_OnClick" 
                             UseSubmitBehavior="false"
                             ValidationGroup="SaveGroup" 
                             maintenanceId =""/>
             </div>
             <div class="MsgDiv">
                 <asp:Label ID="lblSaveMsg" runat="server" CssClass="MessageLabel" ForeColor="Green"></asp:Label>
             </div>
         </footer>
        </section>
    </asp:Panel>
</asp:Content>
