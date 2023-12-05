<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="SearchForMaintenance.aspx.cs" Inherits="DeltaProject.SearchForMaintenances" %>

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

        function PrintDivContent(divId) {
            debugger;
            var printContent = document.getElementById(divId).cloneNode(true);
            $(printContent).find('.skipPrinting').remove();
            var winPrint = window.open('', '', 'height=auto,width=auto,resizable=1,scrollbars=1,toolbar=1,sta­tus=0');
            winPrint.document.write('<html><head><title></title>');
            winPrint.document.write('<link rel="stylesheet" href="CSS/Pages_Style_Sheet.css" type="text/css" />');
            winPrint.document.write('</head><body >');
            winPrint.document.write(printContent.innerHTML);
            winPrint.document.write('</body></html>');
            winPrint.document.close();
            winPrint.focus();
            winPrint.print();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>استعلام عن الصيانات</p>
    </header>
    <asp:RadioButtonList ID="RadioButtonListCategories" runat="server" RepeatDirection="Horizontal" CssClass="RBLCategories2"
        OnSelectedIndexChanged="RadioButtonListCategories_SelectedIndexChanged" AutoPostBack="true">
        <asp:ListItem Value="ClientName" Selected="True">اسم العميل</asp:ListItem>
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
                <asp:LinkButton ID="lnkBtnAllMaintenance" runat="server" CssClass="TabLnks"
                    ToolTip="عرض كل الصيانات الخاصه بهذا العميل" OnClick="lnkBtnAllMaintenance_OnClick">الكـــــل</asp:LinkButton>
            </div>
        </header>
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkBtnDeliveredMaintenance" runat="server" CssClass="TabLnks"
                    ToolTip="عرض الصيانات المستلمة الخاصه بهذا العميل" OnClick="lnkBtnDeliveredMaintenance_OnClick">المستلمة</asp:LinkButton>
            </div>
        </header>
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkBtnMaintenanceWithRemaining" runat="server" CssClass="TabLnks"
                    ToolTip="عرض الصيانات الغير مكتملة الدفع الخاصه بهذا العميل" OnClick="lnkBtnMaintenanceWithRemaining_OnClick">الغير مكتملة الدفع</asp:LinkButton>
            </div>
        </header>

        <asp:Panel runat="server" ID="PanelMaintenance" CssClass="PreReport_SectionTab">
            <asp:GridView ID="GridViewMaintenance" runat="server" AutoGenerateColumns="False" CssClass="Gridview_Style2"
                EmptyDataText="لا توجد صيانات لهذا العميل"
                HeaderText="اسم الصيانة"
                SortExpression="Title"
                OnRowCommand="GridViewMaintenance_OnRowCommand"
                AllowPaging="True"
                OnPageIndexChanging="GridViewMaintenance_OnPageIndexChanging">
                <Columns>
                    <asp:BoundField DataField="Id" HeaderText="الرقم" SortExpression="Id" />
                    <asp:BoundField DataField="Title" HeaderText="اسم الصيانة" SortExpression="Title" />
                    <asp:BoundField DataField="WorkshopName" HeaderText="الورشة" SortExpression="WorkshopName" />
                    <asp:BoundField DataField="OrderDate" HeaderText="تاريخ الصيانة" SortExpression="OrderDate" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="StatusName" HeaderText="الحالة" SortExpression="StatusName" />
                    <asp:BoundField DataField="ExpiryWarrantyDateText" HeaderText="انتهاء الضمان" SortExpression="ExpiryWarrantyDateText" />
                    <asp:BoundField DataField="Cost" SortExpression="Cost" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" DataFormatString="{0:0.##}" />
                    <asp:BoundField DataField="Price" SortExpression="Price" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" DataFormatString="{0:0.##}" />
                    <asp:BoundField DataField="RemainingAmount" SortExpression="RemainingAmount" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" DataFormatString="{0:0.##}" />
                    <asp:BoundField DataField="Description" SortExpression="Description" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                    <asp:BoundField DataField="ExpectedDeliveryDate" SortExpression="ExpectedDeliveryDate" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                    <asp:BoundField DataField="PaymentCount" SortExpression="PaymentCount" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                    <asp:BoundField DataField="ClientName" SortExpression="ClientName" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                    <asp:BoundField DataField="PhoneNumber" SortExpression="PhoneNumber" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                    <asp:BoundField DataField="WorkshopId" SortExpression="WorkshopId" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                    <asp:TemplateField SortExpression="Id">
                        <ItemTemplate>
                            <asp:LinkButton ID="LnkEditMaintenance" runat="server" CssClass="lnkbtnSelect" CausesValidation="false" CommandName="EditMaintenance">تعديل</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField SortExpression="Id">
                        <ItemTemplate>
                            <asp:LinkButton ID="LnkSelect" runat="server" CssClass="lnkbtnSelect" CausesValidation="false" CommandName="Select">اختر</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <RowStyle CssClass="Row_Style nowrap" />
                <PagerStyle CssClass="PagerStyle" HorizontalAlign="Center" />
                <EmptyDataRowStyle CssClass="EmptyDataRowStyle" />
            </asp:GridView>
        </asp:Panel>
    </asp:Panel>
    <div id="divToPrint">
        <asp:Panel runat="server" ID="PanelMaintenanceDetails" Visible="false">
            <section class="ContactsSection" style="border-radius: 8px; width: 99%; text-align: right; direction: rtl; padding: 10px;">
                <header style="text-align: left" class="skipPrinting">
                    <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/Images/printer.png" Width="24" Height="24" OnClientClick="PrintDivContent('divToPrint');" ToolTip="اطبع التقرير" />
                    <asp:ImageButton ID="ImageButtonBackMaintenance" runat="server" ImageUrl="~/Images/back.png" Width="24" Height="24"
                        ToolTip="رجوع" OnClick="btnBack_OnClick" CausesValidation="false" />
                </header>
                <header class="Prices_Offer_SubHeaderBill" style="margin-bottom: 20px;">
                    <div style="border: 1px solid black">
                        <p style="font: bold 14px arial; margin: 0; padding: 0">تفاصيل الصيانه</p>
                    </div>
                </header>
                <table class="AddProductsTable maintenanceDetails" style="width: 98%">
                    <tr>
                        <td class="RHSTD" style="width: 15%">
                            <p class="RHSP">رقم الصيانة :</p>
                        </td>
                        <td class="RHSTD" style="width: 35%">
                            <asp:Label runat="server" ID="lblId" Text='' />
                        </td>
                        <td class="RHSTD" style="width: 15%">
                            <p class="RHSP">اسم الصيانة :</p>
                        </td>
                        <td class="RHSTD" style="width: 35%">
                            <asp:Label runat="server" ID="lblTitle" Text='' />
                        </td>
                    </tr>
                    <tr>
                        <td class="RHSTD" style="width: 15%">
                            <p class="RHSP">الورشة :</p>
                        </td>
                        <td class="RHSTD" style="width: 35%">
                            <asp:Label runat="server" ID="lblWorkshop" Text='' />
                        </td>
                        <td class="RHSTD" style="width: 15%">
                            <p class="RHSP">الحالة :</p>
                        </td>
                        <td class="RHSTD" style="width: 35%">
                            <asp:Label runat="server" ID="lblStatus" Text='' />
                        </td>
                    </tr>
                    <tr>
                        <td class="RHSTD" style="width: 15%">
                            <p class="RHSP">تاريخ الصيانة :</p>
                        </td>
                        <td class="RHSTD" style="width: 35%">
                            <asp:Label runat="server" ID="lblOrderDate" Text='' />
                        </td>
                        <td class="RHSTD" style="width: 15%">
                            <p class="RHSP">انتهاء الضمان :</p>
                        </td>
                        <td class="RHSTD" style="width: 35%">
                            <asp:Label runat="server" ID="lblExpiryWarrantyDate" Text='' />
                        </td>
                    </tr>
                    <tr>
                        <td class="RHSTD" style="width: 15%">
                            <p class="RHSP">السعر :</p>
                        </td>
                        <td class="RHSTD" style="width: 35%">
                            <asp:Label runat="server" ID="lblPrice" Text='' />
                        </td>
                        <td class="RHSTD" style="width: 15%">
                            <p class="RHSP">المتبقى :</p>
                        </td>
                        <td class="RHSTD" style="width: 35%">
                            <asp:Label runat="server" ID="lblRemainingAmount" Text='' />
                        </td>
                    </tr>
                    <tr>
                        <td class="RHSTD" style="width: 15%">
                            <p class="RHSP">الوصف :</p>
                        </td>
                        <td class="RHSTD" colspan="3" style="width: 35%">
                            <asp:Label runat="server" CssClass="textWithDotsCollapse textWithDots" ID="lblDescription" Text='' /></td>
                    </tr>
                </table>
            </section>
        </asp:Panel>
    </div>
    <asp:Panel runat="server" ID="PanelEditMaintenance" Visible="false">
        <section>
            <table class="AddProductsTable">
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">اسم الصيانه :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtId" CssClass="txts3" Visible="false" AutoCompleteType="Disabled"></asp:TextBox>
                        <asp:TextBox runat="server" ID="txtTitle" CssClass="txts3" PlaceHolder="اسم الصيانه" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>

                    <td class="RHSTD">
                        <p class="RHSP">اسم الورشة :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:DropDownList ID="ddlWorkshops" runat="server" CssClass="txts3"
                            Style="width: 100%; height: auto"
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
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                            ControlToValidate="ddlWorkshops" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="اسم الورشة متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>
                </tr>

                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">اسم العميل :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtEditClientName" CssClass="txts3" PlaceHolder="اسم العميل" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                    <td class="RHSTD">
                        <p class="RHSP" style="white-space: nowrap">رقم التليفون :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtEditPhoneNumber" CssClass="txts3" PlaceHolder="رقم التليفون" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                            ControlToValidate="txtEditClientName" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="اسم العميل متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server"
                            ControlToValidate="txtEditPhoneNumber" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="رقم التليفون متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator2" runat="server"
                            ToolTip="يجب كتابة الرقم بشكل صحيح"
                            ControlToValidate="txtEditPhoneNumber"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ClientValidationFunction="IsValidNumber">
                        <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                    </td>
                </tr>

                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">ت. الصيانة :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="OrderDate" CssClass="txts3" PlaceHolder="تاريخ الصيانة"></asp:TextBox>
                    </td>
                    <td class="RHSTD">
                        <p class="RHSP">ت. التسليم :</p>
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
                    <td class="RHSTD">
                        <p class="RHSP">التكلفة :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtCost" CssClass="txts3" PlaceHolder="التكلفة"></asp:TextBox>
                    </td>
                    <td class="RHSTD">
                        <p class="RHSP">السعر :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtPrice" CssClass="txts3" PlaceHolder="السعر"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD" colspan="4">
                        <br />
                        <br />
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">المدفوع :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtPaidAmount" CssClass="txts3" PlaceHolder="المدفوع"></asp:TextBox>
                    </td>
                    <td colspan="2"></td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <div runat="server" id="priceValiation" visible="false">
                            <img src="Images/Error.png" width="24" height="24" title="لا يجب ان تزيد القيمة المدفوعة عن سعر الصيانة." />
                        </div>
                    </td>
                    <td colspan="2"></td>
                </tr>
                <tr>
                    <td style="vertical-align: top">
                        <p class="RHSP">الوصـــــــف :</p>
                    </td>
                    <td colspan="3">
                        <asp:TextBox ID="txtDescription" runat="server" CssClass="TxtMultiline" AutoCompleteType="Disabled" Width="98%"
                            TextMode="MultiLine" Style="resize: vertical;" placeholder="اضف وصفا للصيانه ....."></asp:TextBox>
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
                <asp:Button ID="btnSave" runat="server" Text="حفظ" CssClass="BtnNext" OnClick="btnSave_Click" />
            </div>
        </footer>
    </asp:Panel>
    <div class="MsgDiv">
        <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
    </div>
</asp:Content>
