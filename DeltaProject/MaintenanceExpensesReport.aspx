<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="MaintenanceExpensesReport.aspx.cs" Inherits="DeltaProject.MaintenanceExpensesReport" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
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

        function AddPartnersGridViews(data) {
            debugger;
            var partners = data.map(x => x.PartnerId).filter(onlyUnique);

            var initHtml = 
                '<table class="GridViewBill" cellspacing="0" rules="all" border="1" style="border-collapse:collapse;">' +
                    '<tbody><tr class="HeaderStyleBill">' +
                    '<th scope="col">التاريخ</th>' +
                    '<th scope="col">القيمة</th>' +
                    '<th scope="col">ملاحظات</th></tr>';

            var html;
            var finalHtml = "";

            $('#divWithdraws').html('');

            for (let p = 0; p < partners.length; p++) {
                var partnerId = partners[p];
                var partnerData = data.filter(c=> c.PartnerId === partnerId);
                   
                html = `<div><p>- ${partnerData[0].PartnerName.trim()} :</p></div>` + initHtml;

                for (let w = 0; w < partnerData.length; w++) {
                    var date = partnerData[w].Date.slice(0, partnerData[w].Date.indexOf('T')).replaceAll('-', ', ');
                    date = date.split(', ').reverse().join(', ');
                    html += `<tr class="RowStyleList">
                             <td>${date}</td>
                             <td>${partnerData[w].Amount}</td>
                             <td>${partnerData[w].Notes.trim()}</td></tr>`;
                }

                let sumAmount = 0;
                partnerData.map(c => c.Amount).forEach(item => {
                    sumAmount += item;
                });

                html +=
                    `<tr class="FooterStyleBill"><td>&nbsp;</td><td>${sumAmount}</td><td>&nbsp;</td></tr></tbody></table>`;
                finalHtml += html;
            }

            $('#divWithdraws').html(finalHtml);
        }

        function onlyUnique(value, index, array) {
            return array.indexOf(value) === index;
        }

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
    <header class="Header">
        <p>تقرير أرباح الصيانات</p>
    </header>
    <section class="Search_Section">
        <table class="Search_table">
            <tr>
                <td class="Image_td">
                    <asp:ImageButton ID="ImageButtonSearch" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                        Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearch_Click" />
                </td>
                <td class="Search_td" style="width: 30%; padding-left: 5px;">
                    <asp:DropDownList ID="ddlWorkshops" runat="server" CssClass="txts3"
                        Style="border: none; width: 100%; height: auto"
                        DataTextField="Name"
                        DataValueField="Id">
                    </asp:DropDownList>
                </td>
                <td class="Search_td" style="width: 30%">
                    <asp:TextBox runat="server" ID="txtStartDate" CssClass="Search_TextBox_md left_border" PlaceHolder="تاريخ بداية الاستعلام . . . . ." AutoCompleteType="Disabled"></asp:TextBox>
                </td>
                <td class="Search_td" style="width: 30%">
                    <asp:TextBox runat="server" ID="txtEndDate" CssClass="Search_TextBox_md left_border" PlaceHolder="تاريخ نهاية الاستعلام . . . . ." AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
        </table>
    </section>
    <asp:Panel ID="PanelErrorMessage" runat="server" CssClass="ErrorMessagePanal" Visible="false">
        <article class="Errorarticle">
            <asp:Label ID="LabelErrMsg" runat="server" CssClass="LblErrorMsg2" Text="لا توجد عمليات مسجله لهذه الورشة"></asp:Label>
        </article>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelReport" Visible="false">
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
            <header class="Prices_Offer_SubHeaderBill">
                <div>
                    <p>تقرير أرباح الصيانات</p>
                </div>
            </header>
            <section class="ReportDeclarationSection">
                <section>
                    <table>
                        <tr>
                            <td>
                                <asp:Label ID="Label1" runat="server" Text="من : " CssClass="lblInfo"></asp:Label>
                            </td>
                            <td style="width: 125px">
                                <asp:Label ID="lblStartDate" runat="server" CssClass="lblInfo2" Text="01/01/0001"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="Label4" runat="server" Text="الى : " CssClass="lblInfo"></asp:Label>
                            </td>
                            <td style="width: 125px">
                                <asp:Label ID="lblEndDate" runat="server" CssClass="lblInfo2" Text="01/01/0001"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="Label3" runat="server" Text="الورشة : " CssClass="lblInfo"></asp:Label>
                            </td>
                            <td style="width: 125px">
                                <asp:Label ID="lblWorkshopName" runat="server" CssClass="lblInfo2" Text="اسم الورشة"></asp:Label>
                            </td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label2" runat="server" Text="الأرباح : " CssClass="lblInfo"></asp:Label>
                            </td>
                            <td style="width: 125px">
                                <asp:Label ID="lblProfit" runat="server" CssClass="lblInfo2" Text="------" DataFormatString="{0:0.##}"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="Label5" runat="server" Text="الديون : " CssClass="lblInfo"></asp:Label>
                            </td>
                            <td style="width: 125px">
                                <asp:Label ID="lblDebit" runat="server" CssClass="lblInfo2" Text="------" DataFormatString="{0:0.##}"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="Label7" runat="server" Text="السحوبات : " CssClass="lblInfo"></asp:Label>
                            </td>
                            <td style="width: 125px">
                                <asp:Label ID="lblWithdraw" runat="server" CssClass="lblInfo2" Text="------" DataFormatString="{0:0.##}"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="Label9" runat="server" Text="صافى الايراد : " CssClass="lblInfo"></asp:Label>
                            </td>
                            <td style="width: 125px">
                                <asp:Label ID="lblNetIncome" runat="server" CssClass="lblInfo2" Text="------" DataFormatString="{0:0.##}"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </section>
                <br />
                <section>
                    <div>
                        <p>جدول الصيانات</p>
                    </div>
                    <asp:GridView runat="server" ID="GridViewMaintenance" CssClass="GridViewBill"
                        AutoGenerateColumns="False" EmptyDataText="لا توجد صيانات" ShowFooter="true">
                        <Columns>
                            <asp:BoundField DataField="OrderDate" HeaderText="تاريخ الصيانة" SortExpression="OrderDate" DataFormatString="{0:dd/MM/yyyy}" />
                            <asp:BoundField DataField="Title" HeaderText="اسم الصيانة" SortExpression="Title" />
                            <asp:BoundField DataField="ClientName" HeaderText="اسم العميل" SortExpression="ClientName" />
                            <asp:BoundField DataField="Cost" HeaderText="التكلفة" SortExpression="Cost" DataFormatString="{0:0.##}" />
                            <asp:BoundField DataField="PaidAmount" HeaderText="المدفوع" SortExpression="Price" DataFormatString="{0:0.##}" />
                            <asp:BoundField DataField="RemainingAmount" HeaderText="المتبقى" SortExpression="RemainingAmount" DataFormatString="{0:0.##}" />
                        </Columns>
                        <HeaderStyle CssClass="HeaderStyleBill" />
                        <RowStyle CssClass="RowStyleList" />
                        <AlternatingRowStyle CssClass="AlternateRowStyleList" />
                        <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                        <FooterStyle CssClass="FooterStyleBill" />
                    </asp:GridView>
                </section>
                <br />
                <asp:Panel runat="server" ID="PanelPastMaintenance" Visible="False">
                    <div>
                        <p>جدول الصيانات السابقة</p>
                    </div>
                    <asp:GridView runat="server" ID="GridPastViewMaintenance" CssClass="GridViewBill"
                                  AutoGenerateColumns="False" EmptyDataText="لا توجد صيانات" ShowFooter="true">
                        <Columns>
                            <asp:BoundField DataField="OrderDate" HeaderText="تاريخ الصيانة" SortExpression="OrderDate" DataFormatString="{0:dd/MM/yyyy}" />
                            <asp:BoundField DataField="Title" HeaderText="اسم الصيانة" SortExpression="Title" />
                            <asp:BoundField DataField="ClientName" HeaderText="اسم العميل" SortExpression="ClientName" />
                            <asp:BoundField DataField="Cost" HeaderText="التكلفة" SortExpression="Cost" DataFormatString="{0:0.##}" />
                            <asp:BoundField DataField="PaidAmount" HeaderText="المدفوع" SortExpression="Price" DataFormatString="{0:0.##}" />
                            <asp:BoundField DataField="RemainingAmount" HeaderText="المتبقى" SortExpression="RemainingAmount" DataFormatString="{0:0.##}" />
                        </Columns>
                        <HeaderStyle CssClass="HeaderStyleBill" />
                        <RowStyle CssClass="RowStyleList" />
                        <AlternatingRowStyle CssClass="AlternateRowStyleList" />
                        <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                        <FooterStyle CssClass="FooterStyleBill" />
                    </asp:GridView>
                </asp:Panel>
                <br />
                <section>
                    <div>
                        <p>جدول المصروفات</p>
                    </div>
                    <asp:GridView runat="server" ID="GridViewExpenses" CssClass="GridViewBill"
                        AutoGenerateColumns="False" EmptyDataText="لا توجد مصروفات" ShowFooter="true">
                        <Columns>
                            <asp:BoundField DataField="Date" HeaderText="التاريخ" SortExpression="Date" DataFormatString="{0:dd/MM/yyyy}" />
                            <asp:BoundField DataField="Amount" HeaderText="القيمة" SortExpression="Amount" DataFormatString="{0:0.##}" />
                            <asp:BoundField DataField="Reason" HeaderText="السبب" SortExpression="Reason" />
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
                        <p>جدول السحوبات</p>
                    </div>
                    <br/>
                    <div id="divWithdraws">

                    </div>
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
</asp:Content>
