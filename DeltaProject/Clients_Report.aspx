<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Clients_Report.aspx.cs" Inherits="DeltaProject.Clients_Report" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
    <script>
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
    <header class="Sec_footer" style="text-align: left; margin-top: 25px">
        <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/Images/printer.png" Width="28" Height="28" OnClientClick="PrintDivContent('divToPrint');" ToolTip="اطبع التقرير" />
    </header>
    <div id="divToPrint" class="Prices_Offer_DivBill">
        <%--Report Headre--%>
        <header class="Bill_header">
        </header>
        <header class="Prices_Offer_HeaderBill">
            <table class="Offer_Header_table">
                <tr>
                    <td style="vertical-align: top; width: 270px;">
                        <p style="font: bold 25px Arial; color: black; margin: 0; padding: 0">اولاد صبرة لقطع غيار السيارات</p>
                        <p style="font: bold 20px Arial; color: black; line-height: 25px; margin: 0; padding: 0">النقل التقيل - اكتروس - سيور - مسامير</p>
                        <p style="font: bold 12px Arial; color: black; line-height: 25px; margin: 0; padding: 0">صندفا - امام مجلس قروى صندفا</p>
                        <p style="font: bold 25px Arial; color: black; line-height: 20px; margin: 0; padding: 0">ــــــــــــــــــــ</p>
                    </td>
                    <td>
                        <div class="Logo_divBill">
                            <img src="Images/mamdouhlogo.jpg" class="LogoImage" />
                        </div>
                    </td>
                    <td style="vertical-align: middle; width: 250px;">
                        <p style="font: bold 16px Arial; color: black; line-height: 25px; margin: 0; padding: 0">ادارة / الحاج ممدوح صبره و اولاده</p>
                    </td>
                </tr>
            </table>
        </header>
        <%--Report PreSection--%>
        <header class="Prices_Offer_SubHeaderBill">
            <div>
                <p>تقرير عملاء</p>
            </div>
        </header>
        <div>
            <header class="alarm_Header">
                <p>ملحوظـــــه</p>
            </header>
            <footer class="alarm_Footer">
                <p>- الصف الرمادى يوضح ان القيمة دين على الشركه للعميل</p>
                <p>- الصف الابيض يوضح ان القيمة ديون على العميل للشركه</p>
            </footer>
        </div>
        <section class="ReportDeclarationSection">
            <header class="PreSectionTab">
                <div>
                    <asp:LinkButton ID="LinkButton1" runat="server" CssClass="TabLnks" Enabled="false">العملاء</asp:LinkButton>
                </div>
            </header>
            <section class="PreReport_SectionTab">
                <asp:GridView ID="GridViewClients" runat="server" AutoGenerateColumns="False"
                    EmptyDataText="لا يوجد عملاء" CssClass="GridReport" ShowFooter="True" OnRowDataBound="GridViewClients_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="Client_Name" HeaderText="العميل" FooterText="اجمـــــــالى" />
                        <asp:BoundField DataField="C_Address" HeaderText="العنوان" />
                        <asp:TemplateField HeaderText="قيمة الحساب">
                            <ItemTemplate>
                                <asp:Label ID="lblTotalDebts" runat="server" CssClass="lblInfo"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                    <HeaderStyle CssClass="HeaderIncomeReport" />
                    <RowStyle CssClass="Row_Style" />
                    <AlternatingRowStyle CssClass="AlternatRowStyle" />
                    <FooterStyle CssClass="FooterIncomeReport" />
                </asp:GridView>
            </section>
        </section>
        <footer class="Prices_Offer_Footer" style="margin-bottom: 25px; text-align: center">
            <p class="FooterParagraphReportStyle">Copyright&copy 2016 EL-Delta MIS, All rights reserved</p>
        </footer>
    </div>
</asp:Content>
