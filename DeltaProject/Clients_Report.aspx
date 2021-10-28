<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Clients_Report.aspx.cs" Inherits="DeltaProject.Clients_Report" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
    <link href="CSS/jquery-ui-1.10.4.custom.min.css" rel="stylesheet" />
    <script src="Script/jquery-1.10.2.js"></script>
    <script src="Script/jquery-ui-1.10.4.custom.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#<%= TextBoxSearch.ClientID%>').autocomplete({
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
                        <p style="font: bold 28px Arial; color: black; margin: 0; padding: 0">مؤسسة صحارى</p>
                        <p style="font: bold 20px Arial; color: black; line-height: 25px; margin: 0; padding: 0">للتوريد و التركيب</p>
                        <p style="font: bold 16px Arial; color: black; line-height: 25px; margin: 0; padding: 0">جميع مهامات الجهد المنخفض والمتوسط - مستلزمات الآبار - أنظمة الطاقه الشمسية</p>

                        <p style="font: bold 28px Arial; color: black; line-height: 20px; margin: 0; padding: 0">ــــــــــــــــــــ</p>
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
           
            <section class="Search_Section">
                <table class="Search_table">
                    <tr>
                        <td class="Image_td">
                            <asp:ImageButton ID="ImageButtonSearch" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                                             Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearch_OnClick" />
                        </td>
                        <td class="Search_td">
                            <asp:TextBox ID="TextBoxSearch" runat="server" AutoCompleteType="Disabled" CssClass="Search_TextBox"
                                         placeholder="اسم العميل للبحث . . . . ."></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </section>
             <header class="PreSectionTab">
                <div>
                    <asp:LinkButton ID="LinkButton1" runat="server" CssClass="TabLnks" Enabled="false">العملاء</asp:LinkButton>
                </div>
            </header>
            <section class="PreReport_SectionTab">
            <asp:GridView ID="GridViewAllClients" runat="server" AutoGenerateColumns="False"
                          EmptyDataText="لا يوجد عملاء" CssClass="GridReport" ShowFooter="True" OnRowDataBound="GridViewClients_RowDataBound"
                          DataSourceID="ObjectDataSourceClients" AllowPaging="True" PageSize="20">
                <Columns>
                    <asp:BoundField DataField="C_name" HeaderText="العميل" FooterText="اجمـــــــالى" />
                    <asp:BoundField DataField="Address" HeaderText="العنوان" />
                    <asp:BoundField DataField="DebtValue" HeaderText="العنوان" />
                    <asp:TemplateField HeaderText="رقم الفاتورة" SortExpression="Bill_ID">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkBtnSchedule" runat="server" Text='جدوله' ToolTip="جدولة الدين الى دفعات" PostBackUrl='<%# "Client_Debts_Schedule.aspx?ClientName=" + Eval("C_name")%>'></asp:LinkButton>
                    </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                <HeaderStyle CssClass="HeaderIncomeReport" />
                <RowStyle CssClass="Row_Style" />
                <AlternatingRowStyle CssClass="AlternatRowStyle" />
                <FooterStyle CssClass="FooterIncomeReport" />
                <PagerStyle CssClass="PagerStyle" HorizontalAlign="Center" />
            </asp:GridView>
            <asp:ObjectDataSource ID="ObjectDataSourceClients" runat="server"
                SelectMethod="Get_All_Indebted_Clients"
                TypeName="Business_Logic.Client"
                StartRowIndexParameterName="Start_Index"
                MaximumRowsParameterName="Max_Rows"
                SelectCountMethod="Get_All_Indebted_Clients_Count"
                EnablePaging="True">
                <SelectParameters>
                    <asp:ControlParameter ControlID="TextBoxSearch" Name="Client_Name" PropertyName="Text" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
            </section>
        </section>
        <footer class="Prices_Offer_Footer" style="margin-bottom: 25px; text-align: center">
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
                        <p style="font: bold 14px Arial; color: white; line-height: 25px;">العنوان: ملوى - بنى مزار - طريق القاهرة اسيوط الغربى بحرى كمين ملوى 500م</p>
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
</asp:Content>
