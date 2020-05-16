<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Search_For_Bills.aspx.cs" Inherits="DeltaProject.Search_For_Bills" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
    <header class="Header">
        <p>استعلام عن فواتير</p>
    </header>
    <asp:RadioButtonList ID="RadioButtonListCategories" runat="server" RepeatDirection="Horizontal" CssClass="RBLCategories2"
        OnSelectedIndexChanged="RadioButtonListCategories_SelectedIndexChanged" AutoPostBack="true">
        <asp:ListItem Value="Normal" Selected="True">اسم العميل</asp:ListItem>
        <asp:ListItem Value="Motors">رقم الفاتورة</asp:ListItem>
    </asp:RadioButtonList>
    <section class="Search_Section">
        <table class="Search_table">
            <tr>
                <td class="Image_td">
                    <asp:ImageButton ID="ImageButtonSearch" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                        Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearch_Click" />
                </td>
                <td class="Search_td">
                    <asp:TextBox ID="TextBoxSearch" runat="server" AutoCompleteType="Disabled" CssClass="Search_TextBox"
                        placeholder="اسم العميل للبحث . . . . ."></asp:TextBox>
                    <asp:TextBox ID="txtBill_ID" runat="server" AutoCompleteType="Disabled" Visible="false" CssClass="Search_TextBox"
                        placeholder="رقم الفاتورة للبحث . . . . ."></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td></td>
                <td style="text-align: center">
                    <asp:CompareValidator ID="CompareValidator1" runat="server"
                        ControlToValidate="txtBill_ID"
                        Display="Dynamic"
                        Operator="DataTypeCheck"
                        Type="Integer"
                        SetFocusOnError="true"
                        ToolTip="يجب كتابة رقم الفاتورة بشكل صحيح">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:CompareValidator>
                </td>
            </tr>
        </table>
    </section>
    <asp:Panel ID="PanelErrorMessage" runat="server" CssClass="ErrorMessagePanal" Visible="false">
        <article class="Errorarticle">
            <asp:Label ID="LabelErrMsg" runat="server" CssClass="LblErrorMsg2" Text="لا توجد فواتير مسجله لهذا العميل / الرقم"></asp:Label>
        </article>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelBills" Visible="false">
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkBtnPaidBills" runat="server" CssClass="TabLnks"
                    ToolTip="عرض كافة الفواتير التى تم دفعها الخاصه بهذا العميل" OnClick="lnkBtnPaidBills_Click">الفواتير المدفوعه</asp:LinkButton>
            </div>
        </header>
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkBtnUnpaidBills" runat="server" CssClass="TabLnks"
                    ToolTip="عرض كافة الفواتير التى لم يتم دفعها الخاصه بهذا العميل" OnClick="lnkBtnUnpaidBills_Click">الفواتير الغير مدفوعه</asp:LinkButton>
            </div>
        </header>
        <asp:Panel runat="server" ID="PanelPaidBills" CssClass="PreReport_SectionTab" Visible="false">
            <asp:GridView ID="GridViewPaidBills" runat="server" AutoGenerateColumns="False" OnRowCommand="GridViewPaidBills_RowCommand"
                CssClass="Gridview_Style2" EmptyDataText="لا توجد فواتير مدفوعه لهذا العميل"
                DataSourceID="ObjectDataSourcePaidClientBills" AllowPaging="True">
                <Columns>
                    <asp:BoundField DataField="Bill_Date" HeaderText="تاريخ الفاتورة" SortExpression="Bill_Date" DataFormatString="{0:d}" />
                    <asp:BoundField DataField="Client_Name" HeaderText="اسم العميل" SortExpression="Client_Name" />
                    <asp:TemplateField HeaderText="رقم الفاتورة" SortExpression="Bill_ID">
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButtonBill_ID" runat="server" Text='<%# Bind("Bill_ID") %>' ToolTip="الانتقال الى كامل بيانات الفاتورة" CommandName="Select_Bill"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <RowStyle CssClass="Row_Style" />
                <PagerStyle CssClass="PagerStyle" HorizontalAlign="Center" />
                <EmptyDataRowStyle CssClass="Empty_Style" />
            </asp:GridView>
            <asp:ObjectDataSource ID="ObjectDataSourcePaidClientBills" runat="server"
                SelectMethod="Get_All_client_Paid_Bills"
                TypeName="Business_Logic.Bill"
                StartRowIndexParameterName="Start_Index"
                MaximumRowsParameterName="Max_Rows"
                SelectCountMethod="Get_Paid_Count_By_C_Name"
                EnablePaging="True">
                <SelectParameters>
                    <asp:ControlParameter ControlID="TextBoxSearch" Name="Client_Name" PropertyName="Text" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </asp:Panel>
        <asp:Panel runat="server" ID="PanelUnPaidBills" CssClass="PreReport_SectionTab" Visible="false">
            <asp:GridView ID="GridViewUnPaidBills" runat="server" AutoGenerateColumns="False" OnRowCommand="GridViewPaidBills_RowCommand"
                CssClass="Gridview_Style2" EmptyDataText="لا توجد فواتير غير مدفوعه لهذا العميل"
                DataSourceID="ObjectDataSourceUnPaidClientBills" AllowPaging="True">
                <Columns>
                    <asp:BoundField DataField="Bill_Date" HeaderText="تاريخ الفاتورة" SortExpression="Bill_Date" DataFormatString="{0:d}" />
                    <asp:BoundField DataField="Client_Name" HeaderText="اسم العميل" SortExpression="Client_Name" />
                    <asp:TemplateField HeaderText="رقم الفاتورة" SortExpression="Bill_ID">
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButtonBill_ID" runat="server" Text='<%# Bind("Bill_ID") %>' ToolTip="الانتقال الى كامل بيانات الفاتورة" CommandName="Select_Bill"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <RowStyle CssClass="Row_Style" />
                <PagerStyle CssClass="PagerStyle" HorizontalAlign="Center" />
                <EmptyDataRowStyle CssClass="Empty_Style" />
            </asp:GridView>
            <asp:ObjectDataSource ID="ObjectDataSourceUnPaidClientBills" runat="server"
                SelectMethod="Get_All_Client_Unpaid_Bills"
                TypeName="Business_Logic.Bill"
                StartRowIndexParameterName="Start_Index"
                MaximumRowsParameterName="Max_Rows"
                SelectCountMethod="Get_UnPaid_Count_By_C_Name"
                EnablePaging="True">
                <SelectParameters>
                    <asp:ControlParameter ControlID="TextBoxSearch" Name="Client_Name" PropertyName="Text" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </asp:Panel>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelBill" Visible="false">
        <header class="Sec_footer" style="text-align: left; margin-top: 25px">
            <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/Images/printer.png" Width="28" Height="28" OnClientClick="PrintDivContent('divToPrint');" ToolTip="اطبع التقرير" />
        </header>
        <div id="divToPrint" class="Prices_Offer_DivBill">
            <%--Report Headre--%>
            <header class="Bill_header">
            </header>
            <header class="Prices_Offer_HeaderBill" style="border-bottom: none;">
                <table class="Offer_Header_table">
                    <tr>
                        <td style="vertical-align: top; width: 270px;">
                            <p style="font: bold 28px Arial; color: black; margin: 0; padding: 0">شركة صحارى</p>
                            <p style="font: bold 20px Arial; color: black; line-height: 25px; margin: 0; padding: 0">للتجارة و الصيانه</p>
                            <p style="font: bold 16px Arial; color: black; line-height: 25px; margin: 0; padding: 0">خدمات الابار - انظمة الطاقه الشمسيه</p>
                            <p style="font: bold 12px Arial; color: black; line-height: 25px; margin: 0; padding: 0">طريق مصر / اسيوط الغربى بحرى كمين بنى مزار 500متر</p>
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
                <section class="ContactsSection">
                    <p style="font: bold 12px Arial; color: black; line-height: 25px; margin: 0; padding: 0">
                        للاتصــــــــــــال: 
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;01221118328
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;01207245550
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;01282567534
                    </p>
                </section>
            </header>
            <%--Report PreSection--%>
            <header class="Prices_Offer_SubHeaderBill">
                <div>
                    <p>فاتورة بيع</p>
                </div>
            </header>
            <section class="ReportDeclarationSection">
                <section>
                    <table>
                        <tr>
                            <td>
                                <asp:Label ID="Label1" runat="server" Text="تاريخ الفاتورة : " CssClass="lblInfo"></asp:Label>
                            </td>
                            <td style="width: 125px">
                                <asp:Label ID="lblBillDate" runat="server" CssClass="lblInfo2" Text="01/01/0001"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="Label2" runat="server" Text="رقم الفاتورة : " CssClass="lblInfo"></asp:Label>
                            </td>
                            <td style="width: 120px">
                                <asp:Label ID="lblBill_ID" runat="server" CssClass="lblInfo2" Text="رقم الفاتورة"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="Label3" runat="server" Text="العميل : " CssClass="lblInfo"></asp:Label>
                            </td>
                            <td style="width: 120px">
                                <asp:Label ID="lblClientName" runat="server" CssClass="lblInfo2" Text="اسم العميل"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="Label4" runat="server" Text="العنوان : " CssClass="lblInfo"></asp:Label>
                            </td>
                            <td style="width: 120px">
                                <asp:Label ID="lblAddress" runat="server" CssClass="lblInfo2" Text="عنوان العميل"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label5" runat="server" CssClass="lblInfo" Text="تكلفة الفاتورة : "></asp:Label>
                            </td>
                            <td style="width: 120px">
                                <asp:Label ID="lblBillCost" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblDiscount" runat="server" CssClass="lblInfo" Text="الخصم : "></asp:Label>
                            </td>
                            <td style="width: 120px">
                                <asp:Label ID="lblDiscountValue" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="Label6" runat="server" CssClass="lblInfo" Text="المدفوع : "></asp:Label>
                            </td>
                            <td style="width: 120px">
                                <asp:Label ID="lblPaid_Value" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="Label7" runat="server" CssClass="lblInfo" Text="المتبقى : "></asp:Label>
                            </td>
                            <td style="width: 120px">
                                <asp:Label ID="lblRest" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="lblAddtionalCost" runat="server" CssClass="lblInfo" Text="تكلفة اضافيه : "></asp:Label>
                            </td>
                            <td style="width: 120px">
                                <asp:Label ID="lblAdditionalCostValue" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                            </td>
                            <td colspan="6">
                                <asp:Label ID="lblAdditionalcostNotes" runat="server" CssClass="lblInfo2"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </section>
                <br />
                <asp:GridView runat="server" ID="GridViewBillList" CssClass="GridViewBill" AutoGenerateColumns="False" EmptyDataText="لا توجد منتجات"
                    OnRowDataBound="GridViewBillList_RowDataBound" ShowFooter="true">
                    <Columns>
                        <asp:BoundField DataField="P_Name" HeaderText="اسم المنتـــــــــــج" />
                        <asp:BoundField DataField="amount" HeaderText="الكميه" />
                        <asp:BoundField DataField="Sell_Price" HeaderText="سعر الوحده" />
                        <asp:TemplateField HeaderText="سعر الجمله">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblCost"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle CssClass="HeaderStyleBill" />
                    <RowStyle CssClass="RowStyleList" />
                    <AlternatingRowStyle CssClass="AlternateRowStyleList" />
                    <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                    <FooterStyle CssClass="FooterStyleBill" />
                </asp:GridView>
                <header class="PreSectionTab">
                    <div>
                        <asp:LinkButton ID="LinkButton1" runat="server" CssClass="TabLnks" Enabled="false">التعاملات الماديه</asp:LinkButton>
                    </div>
                </header>
                <asp:Panel ID="Panel1" runat="server" CssClass="PreReport_SectionTab">
                    <asp:GridView runat="server" ID="GridViewPayments" CssClass="GridViewBill" AutoGenerateColumns="False" OnRowDataBound="GridViewPayments_RowDataBound">
                        <Columns>
                            <asp:BoundField DataField="Pay_Date" HeaderText="تاريخ التعامل" DataFormatString="{0:d}" />
                            <asp:BoundField DataField="Paid_amount" HeaderText="المدفوع" />
                            <asp:BoundField DataField="Notes" HeaderText="ملاحظــــــــــــات" />
                        </Columns>
                        <HeaderStyle CssClass="HeaderStyleBill" />
                        <RowStyle CssClass="RowStyleList" />
                        <AlternatingRowStyle CssClass="AlternateRowStyleList" />
                    </asp:GridView>
                </asp:Panel>
            </section>
            <footer class="Prices_Offer_Footer" style="margin-bottom: 25px; text-align: center;height:auto">                
                <p class="FooterParagraph" style="font-family: Arial; color: whitesmoke;">تم تطوير هذا النظام بواسطة م/ محمد ربيع</p>
                <p class="FooterParagraph" style="font-family: Arial; color: whitesmoke;">للاتصال / 01001143495</p>
            </footer>
        </div>
    </asp:Panel>
</asp:Content>
