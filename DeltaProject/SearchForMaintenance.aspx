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
    <asp:RadioButtonList ID="RadioButtonListCategories" runat="server" RepeatDirection="Horizontal" CssClass="RBLCategories"
        OnSelectedIndexChanged="RadioButtonListCategories_SelectedIndexChanged" AutoPostBack="true">
        <asp:ListItem Value="ClientName" Selected="True">اسم العميل</asp:ListItem>
        <asp:ListItem Value="PhoneNumber">رقم التليفون</asp:ListItem>
        <asp:ListItem Value="MaintenanceId">رقم الصيانة</asp:ListItem>
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
                    <asp:TextBox ID="txtMaintenanceId" runat="server" AutoCompleteType="Disabled" Visible="false" CssClass="Search_TextBox"
                        placeholder="رقم الصيانة للبحث . . . . ."></asp:TextBox>
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
                    <asp:CompareValidator ID="CompareValidator1" runat="server"
                        ControlToValidate="txtMaintenanceId"
                        Display="Dynamic"
                        Operator="DataTypeCheck"
                        Type="Integer"
                        SetFocusOnError="true"
                        ToolTip="يجب كتابة رقم الصيانة بشكل صحيح">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:CompareValidator>
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
    <div>
        <asp:Panel runat="server" ID="PanelMaintenanceDetails" Visible="false">
            <header class="Sec_footer" style="text-align: left; margin-top: 25px">
                <div class="dropdown">
                    <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/Images/printer.png" Width="24" Height="24" OnClientClick="PrintDivContent('divToPrint');" ToolTip="اطبع التقرير" />
                </div>
            </header>
            <div id="divToPrint" class="Prices_Offer_DivBill" style="min-height:750px">
                <%--Report Headre--%>
                <header class="Bill_header">
                </header>
                <header class="Prices_Offer_HeaderBill" style="border-bottom: none;">
                    <table class="Offer_Header_table">
                        <tr>
                            <td style="vertical-align: top; width: 270px;">
                                <p style="font: bold 28px Arial; color: black; margin: 0; padding: 0">مؤسسة صحارى</p>
                                <p style="font: bold 20px Arial; color: black; line-height: 25px; margin: 0; padding: 0">للتوريد و التركيب</p>
                                <p style="font: bold 16px Arial; color: black; line-height: 25px; margin: 0; padding: 0">جميع مهامات الجهد المنخفض والمتوسط - مستلزمات الآبار - أنظمة الطاقه الشمسية</p>

                            </td>
                            <td>
                                <div class="Logo_divBill">
                                    <img src="Images/Logo.jpg" width="90" height="90" class="LogoImage" />
                                </div>
                            </td>
                            <td style="vertical-align: middle; width: 250px;">
                                <p style="font: bold 16px Arial; color: black; line-height: 25px; margin: 0; padding: 0">ادارة م / ممدوح عبدالحميد</p>
                                <p style="font: bold 16px Arial; color: black; line-height: 25px; margin: 0; padding: 0">&nbsp;&nbsp;&nbsp;م / محمد ممدوح</p>
                                <p style="font: bold 16px Arial; color: black; line-height: 25px; margin: 0; padding: 0">&nbsp;&nbsp;م / على ممدوح</p>
                            </td>
                        </tr>
                    </table>
                    <section class="ContactsSection">
                    </section>
                </header>
                <%--Report PreSection--%>
                <header class="Prices_Offer_SubHeaderBill">
                    <div>
                        <p>عملية صيانة</p>
                    </div>
                </header>
                <section class="ReportDeclarationSection" style="min-height:550px">
                    <section>
                        <table class="ReportHeader" style="width:100%">
                            <tr>
                                <td style="width: 40px">
                                    <asp:Label runat="server" Text="تاريخ الصيانة : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="width: 120px">
                                    <asp:Label ID="lblOrderDate" runat="server" CssClass="lblInfo2" Text="01/01/0001"></asp:Label>
                                </td>
                                <td style="width: 40px">
                                    <asp:Label runat="server" Text="رقم الصيانة : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="width: 120px">
                                    <asp:Label ID="lblId" runat="server" CssClass="lblInfo2" Text="رقم الصيانة"></asp:Label>
                                </td>
                                <td style="width: 40px">
                                    <asp:Label ID="Label1" runat="server" Text="اسم الصيانة : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="width: 120px">
                                    <asp:Label ID="lblTitle" runat="server" CssClass="lblInfo2" Text="اسم الصيانة"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 40px">
                                    <asp:Label ID="Label2" runat="server" Text="الورشة : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="width: 120px">
                                    <asp:Label ID="lblWorkshop" runat="server" CssClass="lblInfo2" Text="الورشة"></asp:Label>
                                </td>
                                <td style="width: 40px">
                                    <asp:Label ID="Label6" runat="server" Text="الحالة : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="width: 120px">
                                    <asp:Label ID="lblStatus" runat="server" CssClass="lblInfo2" Text="الحالة"></asp:Label>
                                </td>
                               <td style="width: 40px">
                                    <asp:Label ID="Label11" runat="server" Text="انتهاء الضمان : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="width: 120px">
                                    <asp:Label ID="lblExpiryWarrantyDate" runat="server" CssClass="lblInfo2" Text="انتهاء الضمان"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 40px">
                                    <asp:Label ID="Label8" runat="server" Text="السعر : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="width: 120px">
                                    <asp:Label ID="lblPrice" runat="server" CssClass="lblInfo2" Text="السعر"></asp:Label>
                                </td>
                                <td style="width: 40px">
                                    <asp:Label ID="Label10" runat="server" Text="المتبقى : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="width: 120px">
                                    <asp:Label ID="lblRemainingAmount" runat="server" CssClass="lblInfo2" Text="المتبقى"></asp:Label>
                                </td>
                                <td style="width: 40px">
                                    <asp:Label ID="Label12" runat="server" Text="الوصف : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="width: 120px">
                                    <asp:Label ID="lblDescription" runat="server" CssClass="lblInfo2 textWithDotsCollapse textWithDots" Text="الوصف"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </section>
                    <br />
                    <section class="skipPrinting">
                        <br />
                        <header class="PreSectionTab">
                            <div>
                                <asp:LinkButton ID="LinkButton1" runat="server" CssClass="TabLnks" Enabled="false">سجل التعديلات</asp:LinkButton>
                            </div>
                        </header>
                        <asp:Panel ID="PanelHistory" runat="server" CssClass="PreReport_SectionTab">
                            <asp:GridView runat="server" ID="GridViewHistory" CssClass="GridViewBill GridViewBillItems" AutoGenerateColumns="False" EmptyDataText="لا توجد تعديلات">
                                <Columns>
                                    <asp:BoundField DataField="Date" HeaderText="التاريخ" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-CssClass="nowrap" />
                                    <asp:BoundField DataField="Description" HeaderText="الوصف" HeaderStyle-Width="70%" ItemStyle-CssClass="textWithDotsCollapse textWithDots" />
                                    <asp:BoundField DataField="UserName" HeaderText="بواسطة" ItemStyle-CssClass="skipPrintCol nowrap" HeaderStyle-CssClass="skipPrintCol" />
                                </Columns>
                                <HeaderStyle CssClass="HeaderStyleBill" />
                                <RowStyle CssClass="RowStyleList" />
                                <AlternatingRowStyle CssClass="AlternateRowStyleList" />
                                <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                            </asp:GridView>
                        </asp:Panel>
                    </section>
                </section>
                <footer class="Prices_Offer_Footer" style="margin-bottom: 25px; text-align: center; height: auto">
                    <table class="Offer_Header_table">
                        <tr>
                            <td style="width: 30%; text-align: right; vertical-align: top; padding-right: 10px;">
                                <p style="font: bold 14px Arial; color: white; line-height: 25px; text-decoration: underline">المقر الرئيسى</p>
                                <p style="font: bold 14px Arial; color: white; line-height: 25px;">العنوان: المنيا - بنى مزار - طريق القاهرة اسيوط الغربى بحرى كمين بنى مزار 500م</p>
                                <p style="font: bold 14px Arial; color: white; line-height: 25px;">للاتصال: 01000901815 - 01206778015</p>
                                <p style="font: bold 14px Arial; color: white; line-height: 25px; margin-right: 25px;"></p>
                            </td>
                            <td style="width: 30%; text-align: right; vertical-align: top; padding-right: 10px;">
                                <p style="font: bold 14px Arial; color: white; line-height: 25px; text-decoration: underline">مقر ملوى</p>
                                <p style="font: bold 14px Arial; color: white; line-height: 25px;">العنوان: المنيا - ملوى - طريق القاهرة اسيوط الغربى بحرى كمين ملوى 500م</p>
                                <p style="font: bold 14px Arial; color: white; line-height: 25px;">للاتصال: 01027793162 - 01110211419</p>
                            </td>
                            <td style="width: 30%; text-align: right; vertical-align: top; padding-right: 10px;">
                                <p style="font: bold 14px Arial; color: white; line-height: 25px; text-decoration: underline">مقر الواحات</p>
                                <p style="font: bold 14px Arial; color: white; line-height: 25px;">العنوان: غرب غرب المنيا - طريق الواحات</p>
                            </td>
                        </tr>
                    </table>
                </footer>
            </div>
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
