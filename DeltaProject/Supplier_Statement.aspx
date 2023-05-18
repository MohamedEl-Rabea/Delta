<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Supplier_Statement.aspx.cs" Inherits="DeltaProject.Supplier_Statement" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(function () {
            $('#<%= ddlSuppliers.ClientID%>').select2();
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
        });

        function storeContentToExportPdf(divId) {
            var pdfContent = '<html><head><title></title>';
            pdfContent += '<link rel="stylesheet" href="CSS/Pages_Style_Sheet.css" type="text/css" />';
            pdfContent += '</head><body >';
            pdfContent += $('#' + divId).html();
            pdfContent += '</body></html>';
            $('#<%= pdfHiddenContentField.ClientID %>').val(pdfContent);
        }

        function PrintDivContent(divId) {
            var printContent = document.getElementById(divId);
            var WinPrint = window.open('', '', 'height=auto,width=auto,resizable=1,scrollbars=1,toolbar=1,sta­tus=0');
            WinPrint.document.write('<html><head><title></title>');
            WinPrint.document.write('<link rel="stylesheet" href="CSS/Pages_Style_Sheet.css" type="text/css" />');
            WinPrint.document.write('</head><body >');
            WinPrint.document.write(printContent.innerHTML);
            WinPrint.document.write('</body></html>');
            WinPrint.document.close();
            WinPrint.focus();
            WinPrint.print();
        }

        function SetTarget() {
            document.forms[0].target = "_blank";
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>كشف حساب مورد</p>
    </header>
    <asp:RadioButtonList ID="RadioButtonListCategories" runat="server" RepeatDirection="Horizontal" CssClass="RBLCategories2"
                         OnSelectedIndexChanged="RadioButtonListCategories_SelectedIndexChanged" AutoPostBack="true">
        <asp:ListItem Value="SupplierName" Selected="True">اسم المورد</asp:ListItem>
        <asp:ListItem Value="PhoneNumber">رقم التليفون</asp:ListItem>
    </asp:RadioButtonList>
    <section class="Search_Section">
        <table class="Search_table">
            <tr>
                <td class="Image_td">
                    <asp:ImageButton ID="ImageButtonSearch" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                                     Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearch_Click" />
                </td>
                <td class="Search_td select2NoBorder">
                    <asp:DropDownList ID="ddlSuppliers" runat="server" CssClass="Search_TextBox_md"
                                      Style="height: auto"
                                      DataTextField="Name"
                                      DataValueField="Id"
                                      AutoPostBack="True">
                    </asp:DropDownList>
                    <asp:TextBox ID="txtPhoneNumber" runat="server" AutoCompleteType="Disabled" Visible="false" CssClass="Search_TextBox_md"
                                 placeholder="رقم التليفون للبحث . . . . ."></asp:TextBox>
                </td>
                <td class="Search_td">
                    <asp:TextBox runat="server" ID="txtStartDate" CssClass="Search_TextBox_md left_border" PlaceHolder="تاريخ بداية الاستعلام . . . . ." AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td></td>
                <td style="text-align: center">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                                                ControlToValidate="ddlSuppliers" Display="Dynamic" SetFocusOnError="true"
                                                ToolTip="اسم المورد متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                    <asp:CustomValidator ID="CustomValidator1" runat="server"
                                         ToolTip="يجب كتابة الرقم بشكل صحيح"
                                         ControlToValidate="txtPhoneNumber"
                                         Display="Dynamic"
                                         SetFocusOnError="true"
                                         ClientValidationFunction="IsValidNumber">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:CustomValidator>
                </td>
                <td></td>
            </tr>
        </table>
    </section>
    <asp:Panel ID="PanelErrorMessage" runat="server" CssClass="ErrorMessagePanal" Visible="false">
        <article class="Errorarticle">
            <asp:Label ID="LabelErrMsg" runat="server" CssClass="LblErrorMsg2" Text="لا توجد فواتير مسجله لهذا المورد"></asp:Label>
        </article>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelStatementList" Visible="false">
        <header class="Sec_footer" style="text-align: left; margin-top: 25px">
            <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/Images/printer.png" Width="28" Height="28" OnClientClick="PrintDivContent('divToPrint');" ToolTip="اطبع التقرير" />
            <asp:ImageButton ID="ImageButton2" runat="server" ImageUrl="~/Images/pdf.png" Width="28" Height="28" OnClick="ImageButton2_Click" OnClientClick="storeContentToExportPdf('divToPrint');" ToolTip="استخراج PDF" />
        </header>
        <asp:HiddenField ID="pdfHiddenContentField" runat="server" />
        <div id="divToPrint" class="Prices_Offer_DivBill">
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
            <asp:Panel runat="server" ID="PanelStatement" Visible="False">
                <header class="Prices_Offer_SubHeaderBill">
                    <div>
                        <p>كشف حساب</p>
                    </div>
                </header>
                <section class="ReportDeclarationSection">
                    <section>
                        <table>
                            <tr>
                                <td>
                                    <asp:Label ID="Label1" runat="server" Text="تاريخ البداية : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="width: 125px">
                                    <asp:Label ID="lblStartDate" runat="server" CssClass="lblInfo2" Text="01/01/0001"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="Label3" runat="server" Text="اسم المورد : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="width: 125px">
                                    <asp:Label ID="lblSupplierName" runat="server" CssClass="lblInfo2" Text="اسم المورد"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="Label2" runat="server" Text="صافى الحساب : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="width: 125px">
                                    <asp:Label ID="lblBalance" runat="server" CssClass="lblInfo2" Text="صافى الحساب"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </section>
                    <br />
                    <asp:GridView runat="server" ID="GridViewStatement" CssClass="GridViewBill"
                        AutoGenerateColumns="False" 
                        EmptyDataText="لا توجد معاملات مادية" 
                        ShowFooter="true"
                        DataKeyNames="InvoiceId"
                        OnRowDataBound="GridViewStatement_RowDataBound"
                        OnRowCommand="GridViewStatement_OnRowCommand">
                        <Columns>
                            <asp:BoundField DataField="InvoiceId" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                            <asp:BoundField DataField="TransactionDate" HeaderText="تاريخ الحركة" DataFormatString="{0:dd/MM/yyyy}" />
                            <asp:BoundField DataField="Debit" HeaderText="مدين" />
                            <asp:BoundField DataField="Credit" HeaderText="دائن" />
                            <asp:BoundField DataField="Balance" HeaderText="رصيد" />
                            <asp:BoundField DataField="Description" HeaderText="البيان" />
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkDetails" runat="server" CssClass="lnkbtnSelect" OnClientClick="SetTarget();"
                                                    CausesValidation="false" CommandName="Details">التفاصيل</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <HeaderStyle CssClass="HeaderStyleBill" />
                        <RowStyle CssClass="RowStyleList" />
                        <AlternatingRowStyle CssClass="AlternateRowStyleList" />
                        <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                        <FooterStyle CssClass="FooterStyleBill" />
                    </asp:GridView>
                </section>
            </asp:Panel>
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
</asp:Content>
