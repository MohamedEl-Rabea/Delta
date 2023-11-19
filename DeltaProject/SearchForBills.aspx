<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="SearchForBills.aspx.cs" Inherits="DeltaProject.SearchForBills" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .GridViewBillItems .HeaderStyleBill, .GridViewBillItems .RowStyleList, .GridViewBillItems .AlternateRowStyleList {
            font-size: 16px;
        }

        .nowrap {
            white-space: nowrap;
        }
    </style>
    <style>
        .dropbtn {
            padding: 16px;
            font-size: 16px;
            border: none;
            cursor: pointer;
        }

        .dropdown {
            position: relative;
            display: inline-block;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #f1f1f1;
            min-width: 160px;
            overflow: auto;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            z-index: 1;
        }

            .dropdown-content a {
                color: black;
                padding: 12px 16px;
                text-decoration: none;
                display: block;
            }

                .dropdown-content a:hover {
                    background-color: #ddd;
                }
        /*
        .dropdown:hover .dropdown-content {display: block;}*/
    </style>
    <script type="text/javascript" src="Script/ServiseHandler.js"></script>
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
        function PrintDivContent(divId, printAll) {
            debugger;
            var printContent = document.getElementById(divId).cloneNode(true);
            if (!printAll) {
                $(printContent).find('.skipPrinting').remove();
            } else {
                $(printContent).find(".skipPrintCol").remove();
            }
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

        function ShowPrintOptions() {
            $('.dropdown-content').css('display', 'block');
        }

        window.onclick = function (event) {
            if (!event.target.matches('.dropbtn')) {
                $('.dropdown-content').css('display', 'none');
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <asp:Panel runat="server" ID="PanelSearchClient">
        <header class="Header">
            <p>استعلام عن فواتير</p>
        </header>
        <asp:RadioButtonList ID="RadioButtonListCategories" runat="server" RepeatDirection="Horizontal" CssClass="RBLCategories"
            OnSelectedIndexChanged="RadioButtonListCategories_SelectedIndexChanged" AutoPostBack="true">
            <asp:ListItem Value="ClientName" Selected="True">اسم العميل</asp:ListItem>
            <asp:ListItem Value="PhoneNumber">رقم التليفون</asp:ListItem>
            <asp:ListItem Value="BillNumber">رقم الفاتورة</asp:ListItem>
        </asp:RadioButtonList>
        <section class="Search_Section">
            <table class="Search_table">
                <tr>
                    <td class="Image_td">
                        <asp:ImageButton ID="ImageButtonSearch" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                            Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearch_Click" />
                    </td>
                    <td class="Search_td">
                        <asp:TextBox ID="txtClientName" runat="server" AutoCompleteType="Disabled" CssClass="Search_TextBox"
                            placeholder="اسم العميل للبحث . . . . ."></asp:TextBox>
                        <asp:TextBox ID="txtPhoneNumber" runat="server" AutoCompleteType="Disabled" Visible="false" CssClass="Search_TextBox"
                            placeholder="رقم التليفون للبحث . . . . ."></asp:TextBox>
                        <asp:TextBox ID="txtBillId" runat="server" AutoCompleteType="Disabled" Visible="false" CssClass="Search_TextBox"
                            placeholder="رقم الفاتورة للبحث . . . . ."></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td style="text-align: center">
                        <asp:CustomValidator ID="CustomValidator2" runat="server"
                            ToolTip="يجب كتابة الرقم بشكل صحيح"
                            ControlToValidate="txtPhoneNumber"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ClientValidationFunction="IsValidNumber">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                        <asp:CompareValidator ID="CompareValidator1" runat="server"
                            ControlToValidate="txtBillId"
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
    </asp:Panel>
    <asp:Panel ID="PanelErrorMessage" runat="server" CssClass="ErrorMessagePanal" Visible="false">
        <article class="Errorarticle">
            <asp:Label ID="LabelErrMsg" runat="server" CssClass="LblErrorMsg2" Text="هذا العميل/الرقم غير مسجل لدينا ... اما هناك خطأ فى الاسم/الرقم او لو يدرج اى اسم/رقم"></asp:Label>
        </article>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelBills" Visible="false">
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkPaidBills" runat="server" CssClass="TabLnks"
                    ToolTip="عرض كافة الفواتير التى تم دفعها الخاصه بهذا العميل" OnClick="lnkPaidBills_Click">الفواتير المدفوعه</asp:LinkButton>
            </div>
        </header>
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkUnpaidBills" runat="server" CssClass="TabLnks"
                    ToolTip="عرض كافة الفواتير التى لم يتم دفعها الخاصه بهذا العميل" OnClick="lnkUnpaidBills_Click">الفواتير الغير مدفوعه</asp:LinkButton>
            </div>
        </header>
        <asp:Panel runat="server" ID="PanelPaidBills" CssClass="PreReport_SectionTab" Visible="false">
            <asp:GridView ID="GridViewPaidBills" runat="server" AutoGenerateColumns="False" OnRowCommand="GridViewPaidBills_RowCommand"
                CssClass="Gridview_Style2" EmptyDataText="لا توجد فواتير مدفوعه لهذا العميل"
                DataSourceID="ObjectDataSourcePaidBills" AllowPaging="True">
                <Columns>
                    <asp:BoundField DataField="Date" HeaderText="تاريخ الفاتورة" SortExpression="Date" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="ClientName" HeaderText="اسم العميل" SortExpression="ClientName" />
                    <asp:TemplateField HeaderText="رقم الفاتورة" SortExpression="Id">
                        <ItemTemplate>
                            <asp:LinkButton ID="linkBillId" runat="server" Text='<%# Bind("Id") %>' ToolTip="الانتقال الى كامل بيانات الفاتورة" CommandName="SelectBill"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <RowStyle CssClass="Row_Style" />
                <PagerStyle CssClass="PagerStyle" HorizontalAlign="Center" />
                <EmptyDataRowStyle CssClass="Empty_Style" />
            </asp:GridView>
            <asp:ObjectDataSource ID="ObjectDataSourcePaidBills" runat="server"
                SelectMethod="GetAllPaidBills"
                TypeName="DeltaProject.Business_Logic.SaleBill"
                StartRowIndexParameterName="startIndex"
                MaximumRowsParameterName="maxRows"
                SelectCountMethod="GetAllPaidBillsCount"
                EnablePaging="True">
                <SelectParameters>
                    <asp:ControlParameter ControlID="txtClientName" Name="clientName" PropertyName="Text" Type="String" />
                    <asp:ControlParameter ControlID="txtPhoneNumber" Name="phoneNumber" PropertyName="Text" Type="String" />
                    <asp:ControlParameter ControlID="txtBillId" Name="billId" PropertyName="Text" Type="Int32" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </asp:Panel>
        <asp:Panel runat="server" ID="PanelPaidUnBills" CssClass="PreReport_SectionTab" Visible="false">
            <asp:GridView ID="GridViewUnPaidBills" runat="server" AutoGenerateColumns="False" OnRowCommand="GridViewUnPaidBills_RowCommand"
                CssClass="Gridview_Style2" EmptyDataText="لا توجد فواتير مدفوعه لهذا العميل"
                DataSourceID="ObjectDataSourceUnPaidBills" AllowPaging="True">
                <Columns>
                    <asp:BoundField DataField="Date" HeaderText="تاريخ الفاتورة" SortExpression="Date" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="ClientName" HeaderText="اسم العميل" SortExpression="ClientName" />
                    <asp:TemplateField HeaderText="رقم الفاتورة" SortExpression="Id">
                        <ItemTemplate>
                            <asp:LinkButton ID="linkBillId" runat="server" Text='<%# Bind("Id") %>' ToolTip="الانتقال الى كامل بيانات الفاتورة" CommandName="SelectBill"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <RowStyle CssClass="Row_Style" />
                <PagerStyle CssClass="PagerStyle" HorizontalAlign="Center" />
                <EmptyDataRowStyle CssClass="Empty_Style" />
            </asp:GridView>
            <asp:ObjectDataSource ID="ObjectDataSourceUnPaidBills" runat="server"
                SelectMethod="GetAllUnPaidBills"
                TypeName="DeltaProject.Business_Logic.SaleBill"
                StartRowIndexParameterName="startIndex"
                MaximumRowsParameterName="maxRows"
                SelectCountMethod="GetAllUnPaidBillsCount"
                EnablePaging="True">
                <SelectParameters>
                    <asp:ControlParameter ControlID="txtClientName" Name="clientName" PropertyName="Text" Type="String" />
                    <asp:ControlParameter ControlID="txtPhoneNumber" Name="phoneNumber" PropertyName="Text" Type="String" />
                    <asp:ControlParameter ControlID="txtBillId" Name="billId" PropertyName="Text" Type="Int32" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </asp:Panel>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelBillDetails" Visible="false">
        <header class="Sec_footer" style="text-align: left; margin-top: 25px">
            <div class="dropdown">
                <img id="imgPrint" src="Images/printer.png" width="28" height="28" class="dropbtn" onclick="ShowPrintOptions()" />
                <div class="dropdown-content">
                    <a onclick="PrintDivContent('divToPrint', false)" style="cursor: pointer">طباعة المحتويات</a>
                    <a onclick="PrintDivContent('divToPrint', true)" style="cursor: pointer">طباعة كاملة</a>
                </div>
            </div>
        </header>
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
                    <p>عرض سعر</p>
                </div>
            </header>
            <section class="ReportDeclarationSection">
                <section>
                    <table class="ReportHeader">
                        <tr>
                            <td>
                                <asp:Label runat="server" Text="تاريخ العرض : " CssClass="lblInfo"></asp:Label>
                            </td>
                            <td style="width: 120px">
                                <asp:Label ID="lblBillDate" runat="server" CssClass="lblInfo2" Text="01/01/0001"></asp:Label>
                            </td>
                            <td>
                                <asp:Label runat="server" Text="رقم العرض : " CssClass="lblInfo"></asp:Label>
                            </td>
                            <td style="width: 120px">
                                <asp:Label ID="lblBillId" runat="server" CssClass="lblInfo2" Text="رقم العرض"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="Label1" runat="server" Text="العميل : " CssClass="lblInfo"></asp:Label>
                            </td>
                            <td style="width: 120px">
                                <asp:Label ID="lblClientName" runat="server" CssClass="lblInfo2" Text="اسم العميل"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="Label2" runat="server" Text="العنوان : " CssClass="lblInfo"></asp:Label>
                            </td>
                            <td style="width: 120px">
                                <asp:Label ID="lblAddress" runat="server" CssClass="lblInfo2" Text="عنوان العميل"></asp:Label>
                            </td>
                             <td>
                                <asp:Label ID="Label6" runat="server" Text="رقم التليفون : " CssClass="lblInfo"></asp:Label>
                            </td>
                            <td style="width: 120px">
                                <asp:Label ID="lblPhoneNumber" runat="server" CssClass="lblInfo2" Text="رقم التليفون"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label3" runat="server" CssClass="lblInfo" Text="الاجمالى : "></asp:Label>
                            </td>
                            <td style="width: 120px">
                                <asp:Label ID="lblBillCost" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblAddtionalCost" runat="server" CssClass="lblInfo" Text="تكلفة اضافيه : "></asp:Label>
                            </td>
                            <td style="width: 120px">
                                <asp:Label ID="lblAdditionalCostValue" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="Label4" runat="server" CssClass="lblInfo" Text="المدفوع : "></asp:Label>
                            </td>
                            <td style="width: 120px">
                                <asp:Label ID="lblPaidValue" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                            </td>
                           <td>
                                <asp:Label ID="Label5" runat="server" CssClass="lblInfo" Text="اجمالى الخصم : "></asp:Label>
                            </td>
                            <td style="width: 120px">
                                <asp:Label ID="lblGeneralDiscount" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
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
                                <asp:Label ID="lblPreAdditionalcostNotes" runat="server" CssClass="lblInfo" Text="ملاحظات التكلفه الاضافيه : "></asp:Label>
                            </td>
                            <td colspan="5">
                                <asp:Label ID="lblAdditionalcostNotes" runat="server" CssClass="lblInfo2" Text=" ملاحظات التكلفه الاضافيه"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </section>
                <br />
                <asp:GridView runat="server" ID="GridViewBillItems" CssClass="GridViewBill GridViewBillItems" AutoGenerateColumns="False" EmptyDataText="لا توجد منتجات"
                    OnRowDataBound="GridViewBillItems_OnRowDataBound" ShowFooter="true">
                    <Columns>
                        <asp:BoundField DataField="Name" HeaderText="اسم المنتج" SortExpression="Name" />
                        <asp:BoundField DataField="UnitName" HeaderText="الوحدة" SortExpression="UnitName" />
                        <asp:BoundField DataField="SoldQuantity" HeaderText="الكميه" SortExpression="SoldQuantity" DataFormatString="{0:0.##}" />
                        <asp:BoundField DataField="ReturnedQuantity" HeaderText="المرتجع" SortExpression="ReturnedQuantity" DataFormatString="{0:0.##}" />
                        <asp:BoundField DataField="SpecifiedPrice" HeaderText="سعر البيع" SortExpression="SpecifiedPrice" DataFormatString="{0:0.##}" />
                        <asp:BoundField DataField="Discount" HeaderText="الخصم" SortExpression="Discount" DataFormatString="{0:0.##}" />
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
                <section class="skipPrinting">
                    <br />
                    <header class="PreSectionTab">
                        <div>
                            <asp:LinkButton ID="LinkButton1" runat="server" CssClass="TabLnks" Enabled="false">عمليات على الفاتورة</asp:LinkButton>
                        </div>
                    </header>
                    <asp:Panel ID="PanelHistory" runat="server" CssClass="PreReport_SectionTab">
                        <asp:GridView runat="server" ID="GridViewHistory" CssClass="GridViewBill GridViewBillItems" AutoGenerateColumns="False" EmptyDataText="لا يوجد عمليات">
                            <Columns>
                                <asp:BoundField DataField="OperationType" HeaderText="نوع العملية" ItemStyle-CssClass="nowrap" HeaderStyle-CssClass="nowrap" />
                                <asp:BoundField DataField="Date" HeaderText="التاريخ" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-CssClass="nowrap" />
                                <asp:BoundField DataField="Description" HeaderText="الوصف" />
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
</asp:Content>
