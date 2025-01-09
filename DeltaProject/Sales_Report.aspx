<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Sales_Report.aspx.cs" Inherits="DeltaProject.Sales_Report" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="Script/ServiseHandler.js"></script>
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
    <link href="CSS/jquery-ui-1.10.4.custom.min.css" rel="stylesheet" />
    <script src="Script/jquery-1.10.2.js"></script>
    <script src="Script/jquery-ui-1.10.4.custom.min.js"></script>
    <script type="text/javascript" src="Script/ValidationScript.js"></script>
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
    <header class="Header">
        <p>تقرير المبيعات</p>
    </header>
    <table class="AddProductsTable">
        <tr>
            <td class="RHSTD">
                <p class="RHSP">من :</p>
            </td>
            <td>
                <asp:TextBox runat="server" ID="txtStartDay" ClientIDMode="Static" CssClass="DateTxts" PlaceHolder="يوم" AutoCompleteType="Disabled"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox runat="server" ID="txtStartMonth" ClientIDMode="Static" CssClass="DateTxts_MID" PlaceHolder="شهر" AutoCompleteType="Disabled"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox runat="server" ID="txtStartYear" ClientIDMode="Static" CssClass="DateTxts" PlaceHolder="سنه" AutoCompleteType="Disabled"></asp:TextBox>
            </td>
            <td>
                <asp:Button ID="BtnGetDate" runat="server" Text=":" CausesValidation="false" CssClass="GetDateStyle"
                    OnClientClick="return GetDate2('txtStartDay', 'txtStartMonth', 'txtStartYear')" />
            </td>
        </tr>
        <tr>
            <td class="RHSTD">
                <br />
                <br />
            </td>
            <td style="text-align: center">
                <asp:RequiredFieldValidator ID="RequiredFieldValidatorDay" runat="server" ControlToValidate="txtStartDay" Display="Dynamic" SetFocusOnError="true"
                    ErrorMessage="يجب اضافة يوم الشراء" ToolTip="يجب اضافة يوم الشراء">
                    <img src="Images/Error.png" width="24" height="24"/>
                </asp:RequiredFieldValidator>
                <asp:RangeValidator ID="RangeValidatorDay" runat="server" ErrorMessage="RangeValidator" Display="Dynamic"
                    ControlToValidate="txtStartDay" Type="Integer" MinimumValue="1" MaximumValue="31" ToolTip="يجب اضافة اليوم بشكل صحيح مابين 1-31">
                    <img src="Images/Error.png" width="24" height="24"/>
                </asp:RangeValidator>
            </td>
            <td style="text-align: center">
                <asp:RequiredFieldValidator ID="RequiredFieldValidatorMonth" runat="server" ControlToValidate="txtStartMonth" Display="Dynamic" SetFocusOnError="true"
                    ErrorMessage="يجب اضافة شهر الشراء" ToolTip="يجب اضافة شهر الشراء">
                    <img src="Images/Error.png" width="24" height="24"/>
                </asp:RequiredFieldValidator>
                <asp:RangeValidator ID="RangeValidatorMonth" runat="server" ErrorMessage="RangeValidator" Display="Dynamic"
                    ControlToValidate="txtStartMonth" Type="Integer" MinimumValue="1" MaximumValue="12" ToolTip="يجب اضافة اليوم بشكل صحيح مابين 1-12">
                    <img src="Images/Error.png" width="24" height="24"/>
                </asp:RangeValidator>
            </td>
            <td style="text-align: center">
                <asp:RequiredFieldValidator ID="RequiredFieldValidatorYear" runat="server" ControlToValidate="txtStartYear" Display="Dynamic" SetFocusOnError="true"
                    ErrorMessage="يجب اضافة سنة الشراء" ToolTip="يجب اضافة سنة الشراء">
                    <img src="Images/Error.png" width="24" height="24"/>
                </asp:RequiredFieldValidator>
                <asp:CustomValidator ID="CustomValidator1" runat="server"
                    ToolTip="يجب اضافة سنة الشراء بشكل صحيح"
                    ControlToValidate="txtStartYear"
                    Display="Dynamic"
                    SetFocusOnError="true"
                    ClientValidationFunction="IsValidYear">
                    <img src="Images/Error.png" width="24" height="24"/>
                </asp:CustomValidator>
            </td>
        </tr>
        <tr>
            <td class="RHSTD">
                <p class="RHSP">الى :</p>
            </td>
            <td>
                <asp:TextBox runat="server" ID="txtEndDay" ClientIDMode="Static" CssClass="DateTxts" PlaceHolder="يوم" AutoCompleteType="Disabled"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox runat="server" ID="txtEndMonth" ClientIDMode="Static" CssClass="DateTxts_MID" PlaceHolder="شهر" AutoCompleteType="Disabled"></asp:TextBox>
            </td>
            <td>
                <asp:TextBox runat="server" ID="txtEndYear" ClientIDMode="Static" CssClass="DateTxts" PlaceHolder="سنه" AutoCompleteType="Disabled"></asp:TextBox>
            </td>
            <td>
                <asp:Button ID="Button1" runat="server" Text=":" CausesValidation="false" CssClass="GetDateStyle"
                    OnClientClick="return GetDate2('txtEndDay', 'txtEndMonth', 'txtEndYear')" />
            </td>
        </tr>
        <tr>
            <td class="RHSTD">
                <br />
                <br />
            </td>
            <td style="text-align: center">
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtEndDay" Display="Dynamic" SetFocusOnError="true"
                    ErrorMessage="يجب اضافة يوم الشراء" ToolTip="يجب اضافة يوم الشراء">
                    <img src="Images/Error.png" width="24" height="24"/>
                </asp:RequiredFieldValidator>
                <asp:RangeValidator ID="RangeValidator1" runat="server" ErrorMessage="RangeValidator" Display="Dynamic"
                    ControlToValidate="txtEndDay" Type="Integer" MinimumValue="1" MaximumValue="31" ToolTip="يجب اضافة اليوم بشكل صحيح مابين 1-31">
                    <img src="Images/Error.png" width="24" height="24"/>
                </asp:RangeValidator>
            </td>
            <td style="text-align: center">
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtEndMonth" Display="Dynamic" SetFocusOnError="true"
                    ErrorMessage="يجب اضافة شهر الشراء" ToolTip="يجب اضافة شهر الشراء">
                    <img src="Images/Error.png" width="24" height="24"/>
                </asp:RequiredFieldValidator>
                <asp:RangeValidator ID="RangeValidator2" runat="server" ErrorMessage="RangeValidator" Display="Dynamic"
                    ControlToValidate="txtEndMonth" Type="Integer" MinimumValue="1" MaximumValue="12" ToolTip="يجب اضافة اليوم بشكل صحيح مابين 1-12">
                    <img src="Images/Error.png" width="24" height="24"/>
                </asp:RangeValidator>
            </td>
            <td style="text-align: center">
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtEndYear" Display="Dynamic" SetFocusOnError="true"
                    ErrorMessage="يجب اضافة سنة الشراء" ToolTip="يجب اضافة سنة الشراء">
                    <img src="Images/Error.png" width="24" height="24"/>
                </asp:RequiredFieldValidator>
                <asp:CustomValidator ID="CustomValidator2" runat="server"
                    ToolTip="يجب اضافة سنة الشراء بشكل صحيح"
                    ControlToValidate="txtEndYear"
                    Display="Dynamic"
                    SetFocusOnError="true"
                    ClientValidationFunction="IsValidYear">
                    <img src="Images/Error.png" width="24" height="24"/>
                </asp:CustomValidator>
            </td>
        </tr>
    </table>
    <footer class="AddSupplierFooter">
        <asp:Button ID="BtnReport" runat="server" Text="تقرير" CssClass="BtnNext" OnClick="BtnReport_Click" />
    </footer>
    <asp:Panel runat="server" ID="PanelReport" Visible="false">
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
                        <td style="text-align: center">
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
                    <p>تقرير مبيعات</p>
                </div>
            </header>
            <section class="ReportDeclarationSection">
                <header class="PreSectionTab">
                    <div>
                        <asp:LinkButton ID="LinkButton1" runat="server" CssClass="TabLnks" Enabled="false">المبيعات</asp:LinkButton>
                    </div>
                </header>
                <section class="PreReport_SectionTab">
                    <asp:GridView ID="GridViewSales" runat="server" AutoGenerateColumns="False" EmptyDataText="لا يوجد مبيعات"
                        CssClass="GridViewList" OnRowDataBound="GridViewSales_RowDataBound" ShowFooter="true">
                        <Columns>
                            <asp:BoundField DataField="Bill_Date" HeaderText="التاريخ" DataFormatString="{0:d}" FooterText="اجمـــــــالى" />
                            <asp:BoundField DataField="P_Name" HeaderText="اسم المنتج" />
                            <asp:BoundField DataField="Amount" HeaderText="الكميه المباعه" />
                            <asp:BoundField DataField="Purchase_Price" HeaderText="سعر الشراء" />
                            <asp:BoundField DataField="Specified_Price" HeaderText="السعر المحدد" />
                            <asp:BoundField DataField="Sell_Price" HeaderText="سعر البيع" />
                            <asp:BoundField DataField="Discount" HeaderText="الخصم" />
                            <asp:BoundField DataField="Total" HeaderText="الاجمالى" />
                        </Columns>
                        <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                        <HeaderStyle CssClass="HeaderIncomeReport" />
                        <RowStyle CssClass="Row_Style" />
                        <AlternatingRowStyle CssClass="AlternatRowStyle" />
                        <FooterStyle CssClass="FooterIncomeReport" />
                    </asp:GridView>
                </section>

                <header class="PreSectionTab">
                    <div>
                        <asp:LinkButton ID="LinkButton2" runat="server" CssClass="TabLnks" Enabled="false">الصيانة</asp:LinkButton>
                    </div>
                </header>
                <section class="PreReport_SectionTab">
                    <asp:GridView ID="GridViewMaintenance" runat="server" AutoGenerateColumns="False" EmptyDataText="لا يوجد صيانات"
                        CssClass="GridViewList">
                        <Columns>
                            <asp:BoundField DataField="WorkshopName" HeaderText="الورشة" />
                            <asp:BoundField DataField="Cost" HeaderText="التكلفة" />
                            <asp:BoundField DataField="Price" HeaderText="السعر" />
                            <asp:BoundField DataField="Expenses" HeaderText="المصروفات" />
                        </Columns>
                        <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                        <HeaderStyle CssClass="HeaderIncomeReport" />
                        <RowStyle CssClass="Row_Style" />
                        <AlternatingRowStyle CssClass="AlternatRowStyle" />
                        <FooterStyle CssClass="FooterIncomeReport" />
                    </asp:GridView>
                </section>

                <header class="PreSectionTab">
                    <div>
                        <asp:LinkButton ID="LinkButton3" runat="server" CssClass="TabLnks" Enabled="false">الونش</asp:LinkButton>
                    </div>
                </header>
                <section class="PreReport_SectionTab">
                    <asp:GridView ID="GridViewLoader" runat="server" AutoGenerateColumns="False" EmptyDataText="لا يوجد عمليات ونش"
                        CssClass="GridViewList">
                        <Columns>
                            <asp:BoundField DataField="LoaderName" HeaderText="الونش" />
                            <asp:BoundField DataField="Cost" HeaderText="التكلفة" />
                            <asp:BoundField DataField="Expenses" HeaderText="المصروفات" />
                        </Columns>
                        <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                        <HeaderStyle CssClass="HeaderIncomeReport" />
                        <RowStyle CssClass="Row_Style" />
                        <AlternatingRowStyle CssClass="AlternatRowStyle" />
                        <FooterStyle CssClass="FooterIncomeReport" />
                    </asp:GridView>
                </section>
                <br />
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
