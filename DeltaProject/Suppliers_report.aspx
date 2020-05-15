<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Suppliers_report.aspx.cs" Inherits="DeltaProject.Suppliers_report" %>

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
                        <p style="font: bold 28px Arial; color: black; margin: 0; padding: 0">شركة صحارى</p>
                        <p style="font: bold 20px Arial; color: black; line-height: 25px; margin: 0; padding: 0">للتجارة و الصيانه</p>
                        <p style="font: bold 16px Arial; color: black; line-height: 25px; margin: 0; padding: 0">خدمات الابار - انظمة الطاقه الشمسيه</p>
                        <p style="font: bold 12px Arial; color: black; line-height: 25px; margin: 0; padding: 0">طريق مصر / اسيوط الغربى بحرى كمين بنى مزار 500متر</p>
                        <p style="font: bold 28px Arial; color: black; line-height: 20px; margin: 0; padding: 0">ــــــــــــــــــــ</p>
                    </td>
                    <td>
                        <div class="Logo_divBill">
                            <img src="Images/LogoBill.png" width="90" height="90" class="LogoImage" />
                        </div>
                    </td>
                    <td style="vertical-align: middle; width: 250px;">
                        <p style="font: bold 16px Arial; color: black; line-height: 25px; margin: 0; padding: 0">ادارة م / ممدوح عبدالحميد</p>
                        <p style="font: bold 16px Arial; color: black; line-height: 25px; margin: 0; padding: 0">&nbsp;&nbsp;&nbsp;م / محمد ممدوح</p>
                        <p style="font: bold 16px Arial; color: black; line-height: 25px; margin: 0; padding: 0">&nbsp;&nbsp;م / على ممدوح</p>
                    </td>
                </tr>
            </table>
        </header>
        <%--Report PreSection--%>
        <header class="Prices_Offer_SubHeaderBill">
            <div>
                <p>تقرير موردين</p>
            </div>
        </header>
        <div>
            <header class="alarm_Header">
                <p>ملحوظـــــه</p>
            </header>
            <footer class="alarm_Footer">
                <p>- الصف الرمادى يوضح ان القيمة دين على الشركه للمورد</p>
                <p>- الصف الابيض يوضح ان القيمة ديون على المورد للشركه</p>
            </footer>
        </div>
        <section class="ReportDeclarationSection">
            <header class="PreSectionTab">
                <div>
                    <asp:LinkButton ID="LinkButton1" runat="server" CssClass="TabLnks" Enabled="false">الموردين</asp:LinkButton>
                </div>
            </header>
            <section class="PreReport_SectionTab">
                <asp:GridView ID="GridViewSuppliers" runat="server" AutoGenerateColumns="False"
                    EmptyDataText="لا يوجد موردين" CssClass="GridReport" ShowFooter="true" OnRowDataBound="GridViewSuppliers_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="S_Name" HeaderText="المورد" FooterText="اجمـــــــالى" />
                        <asp:BoundField DataField="S_Address" HeaderText="العنوان" />
                        <asp:BoundField DataField="Account_Number" HeaderText="رقم الحساب البنكى" />
                        <asp:BoundField DataField="debts" HeaderText="قيمة الحساب مع الشركه" />
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
