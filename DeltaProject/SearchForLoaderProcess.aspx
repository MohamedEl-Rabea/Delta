<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="SearchForLoaderProcess.aspx.cs" Inherits="DeltaProject.SearchForLoaderProcess" Culture="ar-EG" %>

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
            $('#<%= txtStartDate.ClientID%>').datepicker(options);
            $('#<%= txtEndDate.ClientID%>').datepicker(options);
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
        <p>إستعلام عن عمليات الونش</p>
    </header>
    <asp:RadioButtonList ID="RadioButtonListCategories" runat="server" RepeatDirection="Horizontal" CssClass="RBLCategories"
        OnSelectedIndexChanged="RadioButtonListCategories_SelectedIndexChanged" AutoPostBack="true">
        <asp:ListItem Value="ClientName" Selected="True">اسم العميل</asp:ListItem>
        <asp:ListItem Value="LoaderProcessId">رقم عملية الونش</asp:ListItem>
    </asp:RadioButtonList>
    <section class="Search_Section">
        <table class="Search_table">
            <tr>
                <td class="Image_td">
                    <asp:ImageButton ID="ImageButtonSearch" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                        Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearch_Click" />
                </td>
                <td class="Search_td" colspan="2">
                    <asp:TextBox ID="txtClientName" runat="server" AutoCompleteType="Disabled" CssClass="Search_TextBox_md"
                        placeholder="اسم العميل للبحث . . . . ."></asp:TextBox>
                    <asp:TextBox ID="txtLoaderProcessId" runat="server" AutoCompleteType="Disabled" Visible="false" CssClass="Search_TextBox_md"
                        placeholder="رقم عملية الونش للبحث . . . . ."></asp:TextBox>
                </td>
                <td class="Search_td">
                    <asp:TextBox runat="server" ID="txtStartDate" CssClass="Search_TextBox_md left_border" PlaceHolder="تاريخ بداية الاستعلام . . . . ." AutoCompleteType="Disabled"></asp:TextBox>
                </td>
                <td class="Search_td">
                    <asp:TextBox runat="server" ID="txtEndDate" CssClass="Search_TextBox_md left_border" PlaceHolder="تاريخ نهاية الاستعلام . . . . ." AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <asp:CompareValidator ID="CompareValidator1" runat="server"
                        ControlToValidate="txtLoaderProcessId"
                        Display="Dynamic"
                        Operator="DataTypeCheck"
                        Type="Integer"
                        SetFocusOnError="true"
                        ToolTip="يجب كتابة رقم عملية الونش بشكل صحيح">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:CompareValidator>
                </td>
                <td colspan="2"></td>
            </tr>
        </table>
    </section>
    <asp:Panel ID="PanelErrorMessage" runat="server" CssClass="ErrorMessagePanal" Visible="false">
        <article class="Errorarticle">
            <asp:Label ID="LabelErrMsg" runat="server" CssClass="LblErrorMsg2" Text="لا توجد عمليات مسجله لهذا العميل / الفترة"></asp:Label>
        </article>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelAllProcesses" Visible="false">
        <asp:Panel runat="server" ID="PanelProcesses" CssClass="PreReport_SectionTab">
            <asp:GridView ID="GridViewProcess" runat="server" AutoGenerateColumns="False" CssClass="Gridview_Style2"
                EmptyDataText="لا توجد عمليات مسجله لهذا العميل / الفترة"
                HeaderText="اسم الونش"
                SortExpression="LoaderName"
                DataKeyNames="Id"
                OnRowCommand="GridViewProcess_OnRowCommand"
                AllowPaging="True"
                OnPageIndexChanging="GridViewProcess_OnPageIndexChanging">
                <Columns>
                    <asp:BoundField DataField="Id" HeaderText="الرقم" SortExpression="Id" />
                    <asp:BoundField DataField="LoaderName" HeaderText="اسم الونش" SortExpression="LoaderName" />
                    <asp:BoundField DataField="PermissionNumber" HeaderText="رقم الاذن" SortExpression="PermissionNumber" />
                    <asp:BoundField DataField="ClientName" HeaderText="اسم العميل" SortExpression="ClientName" />
                    <asp:BoundField DataField="Date" HeaderText="التاريخ" SortExpression="Date" DataFormatString="{0:dd/MM/yyyy hh:mm tt}" />
                    <asp:BoundField DataField="Cost" HeaderText="التكلفة" SortExpression="Cost" DataFormatString="{0:0.##}" />
                    <asp:BoundField DataField="RemainingAmount" HeaderText="المتبقى" SortExpression="RemainingAmount" DataFormatString="{0:0.##}" />
                    <asp:BoundField DataField="Description" SortExpression="Description" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                    <asp:BoundField DataField="PhoneNumber" SortExpression="PhoneNumber" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                    <asp:BoundField DataField="PaymentCount" SortExpression="PaymentCount" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                    <asp:BoundField DataField="LoaderId" SortExpression="LoaderId" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                    <asp:TemplateField SortExpression="Id">
                        <ItemTemplate>
                            <asp:LinkButton ID="LnkEditLoader" runat="server" CssClass="lnkbtnSelect" CausesValidation="false" CommandName="EditLoader">تعديل</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField SortExpression="Id">
                        <ItemTemplate>
                            <asp:LinkButton ID="LnkDetails" runat="server" CssClass="lnkbtnSelect" CausesValidation="false" CommandName="Details">التفاصيل</asp:LinkButton>
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
        <asp:Panel runat="server" ID="PanelLoaderDetails" Visible="false">
            <header class="Sec_footer" style="text-align: left; margin-top: 25px">
                <div class="dropdown">
                    <asp:ImageButton ID="ImageButton2" runat="server" ImageUrl="~/Images/printer.png" Width="24" Height="24" OnClientClick="PrintDivContent('divToPrint');" ToolTip="اطبع التقرير" />
                </div>
            </header>
            <div id="divToPrint" class="Prices_Offer_DivBill" style="min-height: 750px">
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
                        <p>عملية ونش</p>
                    </div>
                </header>
                <section class="ReportDeclarationSection" style="min-height: 550px">
                    <section>
                        <table class="ReportHeader" style="width: 100%">
                            <tr>
                                <td style="width: 40px">
                                    <asp:Label runat="server" Text="تاريخ العملية : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="width: 120px">
                                    <asp:Label ID="lblDate" runat="server" CssClass="lblInfo2" Text="01/01/0001"></asp:Label>
                                </td>
                                <td style="width: 40px">
                                    <asp:Label runat="server" Text="رقم العملية : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="width: 120px">
                                    <asp:Label ID="lblId" runat="server" CssClass="lblInfo2" Text="رقم العملية"></asp:Label>
                                </td>
                                <td style="width: 40px">
                                    <asp:Label ID="Label2" runat="server" Text="رقم الاذن : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="width: 120px">
                                    <asp:Label ID="lblPermissionNumber" runat="server" CssClass="lblInfo2" Text="رقم الاذن"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 40px">
                                    <asp:Label ID="Label3" runat="server" Text="اسم الونش : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="width: 120px">
                                    <asp:Label ID="lblLoaderName" runat="server" CssClass="lblInfo2" Text="اسم الونش"></asp:Label>
                                </td>
                                <td style="width: 40px">
                                    <asp:Label ID="Label11" runat="server" Text="التكلفة : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="width: 120px">
                                    <asp:Label ID="lblCost" runat="server" CssClass="lblInfo2" Text="التكلفة"></asp:Label>
                                </td>
                                <td style="width: 40px">
                                    <asp:Label ID="Label10" runat="server" Text="المتبقى : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="width: 120px">
                                    <asp:Label ID="lblRemainingAmount" runat="server" CssClass="lblInfo2" Text="المتبقى"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 40px">
                                    <asp:Label ID="Label6" runat="server" Text="اسم العميل : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="width: 120px">
                                    <asp:Label ID="lblClientName" runat="server" CssClass="lblInfo2" Text="اسم العميل"></asp:Label>
                                </td>
                                <td style="width: 40px">
                                    <asp:Label ID="Label12" runat="server" Text="الوصف : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td colspan="3">
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
                                <asp:LinkButton ID="LinkButton2" runat="server" CssClass="TabLnks" Enabled="false">سجل التعديلات</asp:LinkButton>
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
    <asp:Panel runat="server" ID="PanelEditLoaderProcess" Visible="false">
        <section>
            <table class="AddProductsTable">
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">اسم الونش :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:DropDownList ID="ddlLoaders" runat="server" CssClass="txts3"
                            Style="width: 100%; height: auto"
                            DataTextField="Name"
                            DataValueField="Id">
                        </asp:DropDownList>
                    </td>
                    <td class="RHSTD">
                        <p class="RHSP">رقم الإذن :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtId" CssClass="txts3" Visible="false" AutoCompleteType="Disabled"></asp:TextBox>
                        <asp:TextBox runat="server" ID="txtPermissionNumber" CssClass="txts3" PlaceHolder="رقم الإذن" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                            ControlToValidate="ddlLoaders" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="اسم الونش متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                            ControlToValidate="txtPermissionNumber" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="رقم الاذن متطلب اساسى">
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
                        <p class="RHSP">رقم التليفون :</p>
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
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server"
                            ControlToValidate="txtEditPhoneNumber" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="رقم التليفون متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator1" runat="server"
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
                        <p class="RHSP">التكلفة :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtCost" CssClass="txts3" PlaceHolder="التكلفة" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                    <td class="RHSTD">
                        <p class="RHSP">المدفوع :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtPaid" CssClass="txts3" PlaceHolder="المدفوع" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                            ControlToValidate="txtCost" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="التكلفة متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator5" runat="server"
                            ToolTip="يجب كتابة التكلفة بشكل صحيح"
                            ControlToValidate="txtCost"
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
                            ControlToValidate="txtPaid" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="المبلغ المدفوع متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator2" runat="server"
                            ToolTip="يجب كتابة المبلغ المدفوع بشكل صحيح"
                            ControlToValidate="txtPaid"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ClientValidationFunction="IsValidDecimal">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                    </td>
                </tr>

                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">ت. الخروج :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="date" CssClass="txts3" PlaceHolder="تاريخ ووقت الخروج"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server"
                            ControlToValidate="Date" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="تاريخ ووقت الخروج متطلب اساسى">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>
                </tr>

                <tr>
                    <td style="vertical-align: top">
                        <p class="RHSP">الوصـــــــف :</p>
                    </td>
                    <td colspan="3">
                        <asp:TextBox ID="txtDescription" runat="server" CssClass="TxtMultiline" AutoCompleteType="Disabled" Width="98%"
                            TextMode="MultiLine" placeholder="اضف وصفا لعملية الونش ....."></asp:TextBox>
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
