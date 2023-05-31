<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="InvoiceDetails.aspx.cs" Inherits="DeltaProject.InvoiceDetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <asp:Panel runat="server" ID="PanelStatementList">
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
            <asp:Panel runat="server" ID="PanelInvoiceDetails">
                <header class="Prices_Offer_SubHeaderBill">
                    <div>
                        <p>التفاصيل</p>
                    </div>
                </header>
                <section class="ReportDeclarationSection">
                    <section>
                        <table>
                            <tr>
                                <td>
                                    <asp:Label ID="Label6" runat="server" Text="رقم الفاتورة : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="width: 125px">
                                    <asp:Label ID="lblInvoiceId" runat="server" CssClass="lblInfo2" Text="------"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="Label4" runat="server" Text="تاريخ الفاتورة : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="width: 125px">
                                    <asp:Label ID="lblInvoiceDate" runat="server" CssClass="lblInfo2" Text="------"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="Label10" runat="server" Text="اسم المورد : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="width: 125px">
                                    <asp:Label ID="lblInvoiceSupplierName" runat="server" CssClass="lblInfo2" Text="------"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="Label8" runat="server" Text="اجمالى الفاتورة : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="width: 125px">
                                    <asp:Label ID="lblInvoiceCost" runat="server" CssClass="lblInfo2" Text="------" 
                                               DataFormatString="{0:0.##}" ForeColor="Green"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="Label5" runat="server" Text="المدفوع : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="width: 125px">
                                    <asp:Label ID="lblInvoicePaid" runat="server" CssClass="lblInfo2" Text="------" 
                                               DataFormatString="{0:0.##}" ForeColor="Green"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="Label9" runat="server" Text="المتبقى : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="width: 125px">
                                    <asp:Label ID="lblInvoiceRemaining" runat="server" CssClass="lblInfo2" Text="------" 
                                               DataFormatString="{0:0.##}" ForeColor="Red"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </section>
                    <br />
                    <section>
                        <div>
                            <p>جدول المنتجات</p>
                        </div>
                        <asp:GridView runat="server" ID="GridViewProducts" CssClass="GridViewBill"
                                      AutoGenerateColumns="False" EmptyDataText="لا توجد منتجات" ShowFooter="true"
                                      OnRowDataBound="GridViewProducts_OnRowDataBound">
                            <Columns>
                                <asp:BoundField DataField="Name" HeaderText="اسم المنتج" SortExpression="Name" />
                                <asp:BoundField DataField="ClassificationName" HeaderText="التصنيف" SortExpression="ClassificationName" />
                                <asp:BoundField DataField="Mark" HeaderText="الماركة" SortExpression="Mark" />
                                <asp:BoundField DataField="Inch" HeaderText="البوصة" SortExpression="Inch" />
                                <asp:BoundField DataField="Style" HeaderText="الطراز" SortExpression="Style" />
                                <asp:BoundField DataField="PurchasePrice" HeaderText="سعر الشراء" SortExpression="PurchasePrice" DataFormatString="{0:0.##}"/>
                                <asp:BoundField DataField="Quantity" HeaderText="الكميه" SortExpression="Quantity" DataFormatString="{0:0.##}"/>
                                <asp:BoundField DataField="UnitName" HeaderText="الوحدة" SortExpression="UnitName" />
                            </Columns>
                            <HeaderStyle CssClass="HeaderStyleBill" />
                            <RowStyle CssClass="RowStyleList" />
                            <AlternatingRowStyle CssClass="AlternateRowStyleList" />
                            <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                            <FooterStyle CssClass="FooterStyleBill" />
                        </asp:GridView>
                    </section>
                    
                    <br />
                    <section>
                        <div>
                            <p>جدول المرتجعات</p>
                        </div>
                        <asp:GridView runat="server" ID="GridViewReturns" CssClass="GridViewBill"
                                      AutoGenerateColumns="False" EmptyDataText="لا توجد عمليات" ShowFooter="true">
                            <Columns>
                                <asp:BoundField DataField="Name" HeaderText="اسم المنتج" SortExpression="Name" />
                                <asp:BoundField DataField="Quantity" HeaderText="الكميه" SortExpression="Quantity" DataFormatString="{0:0.##}"/>
                                <asp:BoundField DataField="UnitName" HeaderText="الوحدة" SortExpression="UnitName" />
                                <asp:BoundField DataField="Date" HeaderText="التاريخ" SortExpression="PaymentDate" DataFormatString="{0:dd/MM/yyyy}" />
                            </Columns>
                            <HeaderStyle CssClass="HeaderStyleBill" />
                            <RowStyle CssClass="RowStyleList" />
                            <AlternatingRowStyle CssClass="AlternateRowStyleList" />
                            <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                            <FooterStyle CssClass="FooterStyleBill" />
                        </asp:GridView>
                    </section>
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
