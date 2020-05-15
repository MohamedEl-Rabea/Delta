<%@ Page Title="" Language="C#" EnableEventValidation="false" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Products_Inventory.aspx.cs" Inherits="DeltaProject.Products_Inventory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
    <script type="text/javascript" src="Script/ValidationScript.js"></script>
    <script type="text/javascript">
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
    <asp:Button ID="BtnAdjustment" runat="server" Text="تسوية الجرد" CssClass="BtnNext" OnClick="BtnAdjustment_Click" />
    <div id="divToPrint" class="Prices_Offer_DivBill">
        <%--Report Headre--%>
        <header class="Bill_header">
        </header>
        <%--Report PreSection--%>
        <header class="Prices_Offer_SubHeaderBill">
            <div>
                <p>تقرير جرد بضائع</p>
            </div>
        </header>
        <section class="ReportDeclarationSection" style="min-height: 50px;">
            <table class="ReportHeaderTable">
                <tr>
                    <td>
                        <p>تقرير بجميع البضائع المسجله لدى النظام والمتواجده لدى مخازن ومعارض الشركه</p>
                    </td>
                </tr>
            </table>
        </section>
        <%-- Infotrmation sections --%>
        <section style="width: 100%; text-align: right; direction: rtl">
            <header class="PreSection">
                <div>
                    <p>بضائع عاديه</p>
                </div>
            </header>
        </section>
        <section class="PreReport_Section">
            <asp:GridView ID="GridViewProducts" runat="server" AutoGenerateColumns="false" CssClass="Gridview_StyleReport" EmptyDataText="لا توجد منتجات">
                <Columns>
                    <asp:BoundField DataField="P_Name" HeaderText="الاسم" />
                    <asp:BoundField DataField="Purchase_Price" HeaderText="سعر الشراء" />
                    <asp:BoundField DataField="Amount" HeaderText="الكميه" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:TextBox ID="txtAmount" AutoCompleteType="Disabled" CssClass="EditTxt" runat="server"></asp:TextBox>
                            <asp:CustomValidator ID="CustomValidator8" runat="server"
                                ToolTip="يجب كتابة الكميه بشكل صحيح"
                                ControlToValidate="txtAmount"
                                Display="Dynamic"
                                SetFocusOnError="true"
                                ForeColor="Red"
                                ClientValidationFunction="IsValidNumber"
                                Text="*">
                            </asp:CustomValidator>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ControlStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ItemStyle-CssClass="NoDispaly">
                        <ItemTemplate>
                            <asp:ImageButton ID="ImageButtonConfirmEdit" runat="server" ImageUrl="~/Images/Ok.png" Width="16" Height="16"
                                ToolTip="تاكيد التعديل" OnClick="ImageButtonConfirmEdit_Click" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <HeaderStyle CssClass="InventoryGridHeader" />
                <RowStyle CssClass="Row_Style" />
                <AlternatingRowStyle CssClass="AlternatRowStyle" />
                <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
            </asp:GridView>
        </section>
        <section style="width: 100%; text-align: right; direction: rtl">
            <header class="PreSection">
                <div>
                    <p>مواتير</p>
                </div>
            </header>
        </section>
        <section class="PreReport_Section">
            <asp:GridView ID="GridViewMotors" runat="server" AutoGenerateColumns="false" CssClass="Gridview_StyleReport" EmptyDataText="لا توجد منتجات">
                <Columns>
                    <asp:BoundField DataField="P_Name" HeaderText="الاسم" />
                    <asp:BoundField DataField="Mark" HeaderText="الماركه" />
                    <asp:BoundField DataField="Inch" HeaderText="البوصه" />
                    <asp:BoundField DataField="Purchase_Price" HeaderText="سعر الشراء" />
                    <asp:BoundField DataField="Amount" HeaderText="الكميه" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:TextBox ID="txtAmount" AutoCompleteType="Disabled" CssClass="EditTxt" runat="server"></asp:TextBox>
                            <asp:CustomValidator ID="CustomValidator8" runat="server"
                                ToolTip="يجب كتابة الكميه بشكل صحيح"
                                ControlToValidate="txtAmount"
                                Display="Dynamic"
                                SetFocusOnError="true"
                                ForeColor="Red"
                                ClientValidationFunction="IsValidNumber"
                                Text="*">
                            </asp:CustomValidator>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ControlStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ItemStyle-CssClass="NoDispaly">
                        <ItemTemplate>
                            <asp:ImageButton ID="ImageButtonConfirmEdit" runat="server" ImageUrl="~/Images/Ok.png" Width="16" Height="16"
                                ToolTip="تاكيد التعديل" OnClick="ImageButtonConfirmEdit_Click" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <HeaderStyle CssClass="InventoryGridHeader" />
                <RowStyle CssClass="Row_Style" />
                <AlternatingRowStyle CssClass="AlternatRowStyle" />
                <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
            </asp:GridView>
        </section>
        <section style="width: 100%; text-align: right; direction: rtl">
            <header class="PreSection">
                <div>
                    <p>طلمبات</p>
                </div>
            </header>
        </section>
        <section class="PreReport_Section">
            <asp:GridView ID="GridViewTol" runat="server" AutoGenerateColumns="false" CssClass="Gridview_StyleReport" EmptyDataText="لا توجد منتجات">
                <Columns>
                    <asp:BoundField DataField="P_Name" HeaderText="الاسم" />
                    <asp:BoundField DataField="Mark" HeaderText="الماركه" />
                    <asp:BoundField DataField="Inch" HeaderText="البوصه" />
                    <asp:BoundField DataField="Style" HeaderText="الطراز" />
                    <asp:BoundField DataField="Purchase_Price" HeaderText="سعر الشراء" />
                    <asp:BoundField DataField="Amount" HeaderText="الكميه" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:TextBox ID="txtAmount" AutoCompleteType="Disabled" CssClass="EditTxt" runat="server"></asp:TextBox>
                            <asp:CustomValidator ID="CustomValidator8" runat="server"
                                ToolTip="يجب كتابة الكميه بشكل صحيح"
                                ControlToValidate="txtAmount"
                                Display="Dynamic"
                                SetFocusOnError="true"
                                ForeColor="Red"
                                ClientValidationFunction="IsValidNumber"
                                Text="*">
                            </asp:CustomValidator>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ControlStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ItemStyle-CssClass="NoDispaly">
                        <ItemTemplate>
                            <asp:ImageButton ID="ImageButtonConfirmEdit" runat="server" ImageUrl="~/Images/Ok.png" Width="16" Height="16"
                                ToolTip="تاكيد التعديل" OnClick="ImageButtonConfirmEdit_Click" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <HeaderStyle CssClass="InventoryGridHeader" />
                <RowStyle CssClass="Row_Style" />
                <AlternatingRowStyle CssClass="AlternatRowStyle" />
                <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
            </asp:GridView>
        </section>
        <footer class="Prices_Offer_Footer" style="margin-bottom: 25px; text-align: center">
            <p class="FooterParagraphReportStyle">Copyright&copy 2015 EL-Safa MIS, All rights reserved</p>
        </footer>
    </div>
</asp:Content>
