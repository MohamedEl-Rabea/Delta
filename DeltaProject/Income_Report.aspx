<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Income_Report.aspx.cs" Inherits="DeltaProject.Income_Report" %>

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
    <style type="text/css">
        .auto-style2 {
            width: 104px;
        }

        .auto-style3 {
            width: 298px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>تقرير الدخل</p>
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
                <asp:Button ID="BtnGetDate" runat="server" Text=":" CausesValidation="false" CssClass="GetDateStyle" UseSubmitBehavior="false"
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
                    ErrorMessage="يجب اضافة يوم التقرير" ToolTip="يجب اضافة يوم التقرير">
                    <img src="Images/Error.png" width="24" height="24"/>
                </asp:RequiredFieldValidator>
                <asp:RangeValidator ID="RangeValidatorDay" runat="server" ErrorMessage="RangeValidator" Display="Dynamic"
                    ControlToValidate="txtStartDay" Type="Integer" MinimumValue="1" MaximumValue="31" ToolTip="يجب اضافة اليوم بشكل صحيح مابين 1-31">
                    <img src="Images/Error.png" width="24" height="24"/>
                </asp:RangeValidator>
            </td>
            <td style="text-align: center">
                <asp:RequiredFieldValidator ID="RequiredFieldValidatorMonth" runat="server" ControlToValidate="txtStartMonth" Display="Dynamic" SetFocusOnError="true"
                    ErrorMessage="يجب اضافة شهر التقرير" ToolTip="يجب اضافة شهر التقرير">
                    <img src="Images/Error.png" width="24" height="24"/>
                </asp:RequiredFieldValidator>
                <asp:RangeValidator ID="RangeValidatorMonth" runat="server" ErrorMessage="RangeValidator" Display="Dynamic"
                    ControlToValidate="txtStartMonth" Type="Integer" MinimumValue="1" MaximumValue="12" ToolTip="يجب اضافة اليوم بشكل صحيح مابين 1-12">
                    <img src="Images/Error.png" width="24" height="24"/>
                </asp:RangeValidator>
            </td>
            <td style="text-align: center">
                <asp:RequiredFieldValidator ID="RequiredFieldValidatorYear" runat="server" ControlToValidate="txtStartYear" Display="Dynamic" SetFocusOnError="true"
                    ErrorMessage="يجب اضافة سنة" ToolTip="يجب اضافة سنة">
                    <img src="Images/Error.png" width="24" height="24"/>
                </asp:RequiredFieldValidator>
                <asp:CustomValidator ID="CustomValidator1" runat="server"
                    ToolTip="يجب اضافة سنة بشكل صحيح"
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
                <asp:Button ID="Button1" runat="server" Text=":" CausesValidation="false" CssClass="GetDateStyle" UseSubmitBehavior="false"
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
                    ErrorMessage="يجب اضافة يوم التقرير" ToolTip="يجب اضافة يوم التقرير">
                    <img src="Images/Error.png" width="24" height="24"/>
                </asp:RequiredFieldValidator>
                <asp:RangeValidator ID="RangeValidator1" runat="server" ErrorMessage="RangeValidator" Display="Dynamic"
                    ControlToValidate="txtEndDay" Type="Integer" MinimumValue="1" MaximumValue="31" ToolTip="يجب اضافة اليوم بشكل صحيح مابين 1-31">
                    <img src="Images/Error.png" width="24" height="24"/>
                </asp:RangeValidator>
            </td>
            <td style="text-align: center">
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtEndMonth" Display="Dynamic" SetFocusOnError="true"
                    ErrorMessage="يجب اضافة شهر التقرير" ToolTip="يجب اضافة شهر التقرير">
                    <img src="Images/Error.png" width="24" height="24"/>
                </asp:RequiredFieldValidator>
                <asp:RangeValidator ID="RangeValidator2" runat="server" ErrorMessage="RangeValidator" Display="Dynamic"
                    ControlToValidate="txtEndMonth" Type="Integer" MinimumValue="1" MaximumValue="12" ToolTip="يجب اضافة اليوم بشكل صحيح مابين 1-12">
                    <img src="Images/Error.png" width="24" height="24"/>
                </asp:RangeValidator>
            </td>
            <td style="text-align: center">
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtEndYear" Display="Dynamic" SetFocusOnError="true"
                    ErrorMessage="يجب اضافة سنة التقرير" ToolTip="يجب اضافة سنة التقرير">
                    <img src="Images/Error.png" width="24" height="24"/>
                </asp:RequiredFieldValidator>
                <asp:CustomValidator ID="CustomValidator2" runat="server"
                    ToolTip="يجب اضافة سنة التقرير بشكل صحيح"
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
                    <p>تقرير دخل</p>
                </div>
            </header>
            <section class="ReportDeclarationSection">
                <header class="PreSectionTab">
                    <div>
                        <asp:LinkButton ID="LinkButton1" runat="server" CssClass="TabLnks" Enabled="false">المبيعات</asp:LinkButton>
                    </div>
                </header>
                <section class="PreReport_SectionTab">
                    <table class="GridsTable">
                        <tr>
                            <td>
                                <asp:GridView ID="GridViewSales" runat="server" AutoGenerateColumns="False"
                                    EmptyDataText="لا يوجد مبيعات" CssClass="GridViewList" Width="385" ShowFooter="true" OnRowDataBound="GridViewSales_RowDataBound">
                                    <Columns>
                                        <asp:BoundField DataField="Pay_Date" HeaderText="التاريخ" DataFormatString="{0:d}" FooterText="اجمـــــــالى" />
                                        <asp:BoundField DataField="All_Sales" HeaderText="اجمالى المبيعات" />
                                    </Columns>
                                    <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                                    <HeaderStyle CssClass="HeaderIncomeReport" />
                                    <RowStyle CssClass="Row_Style" />
                                    <AlternatingRowStyle CssClass="AlternatRowStyle" />
                                    <FooterStyle CssClass="FooterIncomeReport" />
                                </asp:GridView>
                            </td>
                            <td>
                                <asp:GridView ID="GridViewPaid_Sales" runat="server" AutoGenerateColumns="False"
                                    EmptyDataText="لا يوجد مبيعات" Width="385px" CssClass="GridViewList" ShowFooter="True" OnRowDataBound="GridViewPaid_Sales_RowDataBound">
                                    <Columns>
                                        <asp:BoundField DataField="Paid_Sales" HeaderText="مبيعات مدفوعه + تكلفات الفواتير الاضافيه" />
                                    </Columns>
                                    <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                                    <HeaderStyle CssClass="HeaderIncomeReport" />
                                    <RowStyle CssClass="Row_Style" />
                                    <AlternatingRowStyle CssClass="AlternatRowStyle" />
                                    <FooterStyle CssClass="FooterIncomeReport" />
                                </asp:GridView>
                            </td>
                        </tr>
                    </table>

                </section>

                <header class="PreSectionTab">
                    <div>
                        <asp:LinkButton ID="LinkButton6" runat="server" CssClass="TabLnks" Enabled="false">دخل المواتير والطلمبات او غيره</asp:LinkButton>
                    </div>
                </header>
                <section class="PreReport_SectionTab">
                    <asp:GridView ID="GridViewOtherIncome" runat="server" AutoGenerateColumns="False"
                        EmptyDataText="لا يوجد مبيعات" CssClass="GridViewList" ShowFooter="true" OnRowDataBound="GridViewOtherIncome_RowDataBound">
                        <Columns>
                            <asp:BoundField DataField="Pay_Date" HeaderText="التاريخ" DataFormatString="{0:d}" FooterText="اجمـــــــالى" />
                            <asp:BoundField DataField="All_Sales" HeaderText="اجمالى المبيعات" />
                            <asp:BoundField DataField="Notes" HeaderText="الملاحظات" />
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
                        <asp:LinkButton ID="LinkButton2" runat="server" CssClass="TabLnks" Enabled="false">ديون مسددة من العملاء</asp:LinkButton>
                    </div>
                </header>
                <section class="PreReport_SectionTab">
                    <asp:GridView ID="GridViewDebts" runat="server" AutoGenerateColumns="False"
                        EmptyDataText="لا يوجد ديون مسددة" CssClass="GridViewList" ShowFooter="true" OnRowDataBound="GridViewDebts_RowDataBound">
                        <Columns>
                            <asp:BoundField DataField="Pay_Date" HeaderText="التاريخ" DataFormatString="{0:d}" FooterText="اجمـــــــالى" />
                            <asp:BoundField DataField="Paid_Debts" HeaderText="القيمة المدفوعه" />
                        </Columns>
                        <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                        <HeaderStyle CssClass="HeaderIncomeReport" />
                        <RowStyle CssClass="Row_Style" />
                        <AlternatingRowStyle CssClass="AlternatRowStyle" />
                        <FooterStyle CssClass="FooterIncomeReport" />
                    </asp:GridView>
                </section>
                <section class="ContactsSection" style="padding: 10px;">
                    <table class="AddProductsTable">
                        <tr>
                            <td style="width: 300px; text-align: right">
                                <asp:Label ID="Label1" runat="server" Text="اجمالى الايرادات (مبيعات مدفوعه  + ديون مسددة) : " CssClass="lblInfo"></asp:Label>
                            </td>
                            <td style="text-align: right">
                                <asp:Label ID="lblTotalIncome" runat="server" CssClass="lblInfo2"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </section>
                <header class="PreSectionTab">
                    <div>
                        <asp:LinkButton ID="LinkButton3" runat="server" CssClass="TabLnks" Enabled="false">مصروفات عاديه</asp:LinkButton>
                    </div>
                </header>
                <section class="PreReport_SectionTab">
                    <asp:GridView ID="GridViewExpenses" runat="server" AutoGenerateColumns="False"
                        EmptyDataText="لا يوجد مصروفات" CssClass="GridViewList" ShowFooter="true" OnRowDataBound="GridViewExpenses_RowDataBound">
                        <Columns>
                            <asp:BoundField DataField="Pay_Date" HeaderText="التاريخ" DataFormatString="{0:d}" FooterText="اجمــــــــــــــــــــالى" />
                            <asp:BoundField DataField="Category" HeaderText="القسم" />
                            <asp:BoundField DataField="Paid_Value" HeaderText="القيمة المصروفه" />
                            <asp:BoundField DataField="Notes" HeaderText="ملاحظــــات" ControlStyle-CssClass="NotesStyle" ItemStyle-CssClass="NotesStyle" />
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
                        <asp:LinkButton ID="LinkButton5" runat="server" CssClass="TabLnks" Enabled="false">ديون موردين مسددة && شراء منتجات</asp:LinkButton>
                    </div>
                </header>
                <section class="PreReport_SectionTab">
                    <asp:GridView ID="GridViewHugeExpenses" runat="server" AutoGenerateColumns="False"
                        EmptyDataText="لا يوجد مصروفات" CssClass="GridViewList" ShowFooter="true" OnRowDataBound="GridViewHugeExpenses_RowDataBound">
                        <Columns>
                            <asp:BoundField DataField="Pay_Date" HeaderText="التاريخ" DataFormatString="{0:d}" FooterText="اجمــــــــــــــــــــالى" />
                            <asp:BoundField DataField="Category" HeaderText="القسم" />
                            <asp:BoundField DataField="Paid_Value" HeaderText="القيمة المصروفه" />
                            <asp:BoundField DataField="Notes" HeaderText="ملاحظــــات" ControlStyle-CssClass="NotesStyle" ItemStyle-CssClass="NotesStyle" />
                        </Columns>
                        <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                        <HeaderStyle CssClass="HeaderIncomeReport" />
                        <RowStyle CssClass="Row_Style" />
                        <AlternatingRowStyle CssClass="AlternatRowStyle" />
                        <FooterStyle CssClass="FooterIncomeReport" />
                    </asp:GridView>
                </section>
                <section class="ContactsSection" style="padding: 10px;">
                    <table class="AddProductsTable">
                        <tr>
                            <td style="width: 300px; text-align: right">
                                <asp:Label ID="Label2" runat="server" Text="اجمالى المصروفات : " CssClass="lblInfo"></asp:Label>
                            </td>
                            <td style="text-align: right">
                                <asp:Label ID="lblExpenses" runat="server" CssClass="lblInfo2"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </section>
                <header class="PreSectionTab">
                    <div>
                        <asp:LinkButton ID="LinkButton4" runat="server" CssClass="TabLnks" Enabled="false">الخلاصــــــه</asp:LinkButton>
                    </div>
                </header>
                <section class="PreReport_SectionTab">
                    <section class="ContactsSection" style="padding: 10px; background-color: #e1e1da">
                        <table class="AddProductsTable">
                            <tr>
                                <td style="text-align: right" class="auto-style2">
                                    <asp:Label ID="Label3" runat="server" Text="صافى الدخل : " CssClass="lblInfo"></asp:Label>
                                </td>
                                <td style="text-align: right">
                                    <asp:Label ID="lblNetValue" runat="server" CssClass="lblInfo2"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </section>
                </section>
                <br />
            </section>
            <footer class="Prices_Offer_Footer" style="margin-bottom: 25px; text-align: center">
                <p class="FooterParagraphReportStyle">Copyright&copy 2016 EL-Delta MIS, All rights reserved</p>
            </footer>
        </div>
    </asp:Panel>
</asp:Content>
