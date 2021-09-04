<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Suppliers_Search.aspx.cs" Inherits="DeltaProject.Suppliers_Search" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="Script/ServiseHandler.js"></script>
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
    <link href="CSS/jquery-ui-1.10.4.custom.min.css" rel="stylesheet" />
    <script src="Script/jquery-1.10.2.js"></script>
    <script src="Script/jquery-ui-1.10.4.custom.min.js"></script>
    <script type="text/javascript" src="Script/ValidationScript.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#<%= TextBoxSearch.ClientID%>').autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: "Services/GetNamesService.asmx/Get_Suppliers_Names",
                        data: "{ 'supplier_name': '" + request.term + "' }",
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>استعلام عن مورد</p>
    </header>
    <section class="Search_Section">
        <table class="Search_table">
            <tr>
                <td class="Image_td">
                    <asp:ImageButton ID="ImageButtonSearch" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                        Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearch_Click" />
                </td>
                <td class="Search_td">
                    <asp:TextBox ID="TextBoxSearch" runat="server" AutoCompleteType="Disabled" CssClass="Search_TextBox"
                        placeholder="اسم المورد للبحث . . . . ."></asp:TextBox>
                </td>
            </tr>
        </table>
    </section>
    <asp:Panel runat="server" ID="PaenlSupplierInfo" Visible="false">
        <section style="width: 100%; text-align: right; direction: rtl">
            <header class="PreSection">
                <div>
                    <p>بيانات شخصيه</p>
                </div>
            </header>
        </section>
        <section class="PreReport_Section">
            <table class="AddProductsTable">
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">اسم المـــورد :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:Label ID="lblName" runat="server" CssClass="lblInfo"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <br />
                        <br />
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">العنــــــوان :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:Label ID="lblAddress" runat="server" CssClass="lblInfo"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <br />
                        <br />
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">رقم الحساب :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:Label ID="lblAccountNumber" runat="server" CssClass="lblInfo"></asp:Label>
                    </td>
                </tr>
            </table>
        </section>
        <br />
        <br />
        <section style="width: 100%; text-align: right; direction: rtl">
            <header class="PreSection">
                <div>
                    <p>بيانات اتصال</p>
                </div>
            </header>
        </section>
        <section class="PreReport_Section">
            <table style="width: 100%;">
                <tr>
                    <td style="padding-right: 150px">
                        <asp:GridView ID="GridViewPhones" runat="server" AutoGenerateColumns="False"
                            Width="150px" EmptyDataText="لا يوجد ارقام هاتف" CssClass="GridViewList">
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <img width="16" height="16" src="Images/phone.png" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Phone" HeaderText="رقم الهاتف" />
                            </Columns>
                            <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                            <HeaderStyle CssClass="ConatactsHeader" />
                            <RowStyle CssClass="Row_Style" />
                            <AlternatingRowStyle CssClass="AlternatRowStyle" />
                        </asp:GridView>
                    </td>
                    <td style="padding-right: 150px">
                        <asp:GridView ID="GridViewFaxs" runat="server" AutoGenerateColumns="False"
                            EmptyDataText="لا يوجد ارقام فاكس" Width="150px" CssClass="GridViewList">
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <img width="16" height="16" src="Images/fax.png" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Fax" HeaderText="رقم الفاكس" />
                            </Columns>
                            <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                            <HeaderStyle CssClass="ConatactsHeader" />
                            <RowStyle CssClass="Row_Style" />
                            <AlternatingRowStyle CssClass="AlternatRowStyle" />
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </section>
        <br />
        <br />
        <section style="width: 100%; text-align: right; direction: rtl">
            <header class="PreSection">
                <div>
                    <p>سجل التعامل المادى</p>
                </div>
            </header>
        </section>
        <section class="PreReport_Section">
            <asp:Panel runat="server" ID="PanelNotice" Visible="false">
                <div>
                    <header class="alarm_Header">
                        <p>ملحوظـــــه</p>
                    </header>
                    <footer class="alarm_Footer">
                        <p>- الصف الرمادى يوضح ان القيمة المدفوعه هى مدفوعه من المورد</p>
                        <p>- الصف الابيض يوضح ان القيمة المدفوعه هى مدفوعه من مؤسسة صحارى للمورد</p>
                    </footer>
                </div>
            </asp:Panel>
            <br />
            <asp:Panel runat="server" CssClass="PanelImages">
                <asp:GridView ID="GridViewSupplierRecord" runat="server" AutoGenerateColumns="False"
                    EmptyDataText="لا يوجد تعاملات سابقه" CssClass="GridViewList" OnRowDataBound="GridViewSupplierRecord_RowDataBound" ShowFooter="true">
                    <Columns>
                        <asp:BoundField DataField="Pay_Date" HeaderText="التاريخ" DataFormatString="{0:d}" />
                        <asp:BoundField DataField="Previous_debts" HeaderText="الدين السابق" ControlStyle-CssClass="NoDispaly" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" />
                        <asp:BoundField DataField="Current_Debts" HeaderText="الدين الحالى" ControlStyle-CssClass="NoDispaly" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" />
                        <asp:BoundField DataField="Paid_amount" HeaderText="القيمه المدفوعه" />
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkDetails" runat="server" CssClass="Link" OnClick="lnkDetails_Click">تفاصيل ومرفقات</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                    <HeaderStyle CssClass="ConatactsHeader" />
                    <RowStyle CssClass="Row_Style" />
                    <AlternatingRowStyle CssClass="AlternatRowStyle" />
                    <FooterStyle CssClass="Footer_Row" />
                </asp:GridView>
            </asp:Panel>
        </section>
        <asp:Panel ID="PanelNotes" runat="server" Visible="false">
            <table class="Sec_table">
                <tr>
                    <td class="td_lbls" style="vertical-align: top">
                        <asp:Label ID="Label17" runat="server" Text="تفاصيل :" CssClass="lblInfo"></asp:Label>
                    </td>
                    <td class="td_txts">
                        <asp:TextBox ID="TxtNotes" runat="server" CssClass="TxtMultiline" AutoCompleteType="Disabled" Enabled="false" TextMode="MultiLine" placeholder="لا توجد تفاصيل"></asp:TextBox>
                    </td>
                </tr>
            </table>
            <br />
            <asp:Panel runat="server" ID="PanelImages" CssClass="PanelImages">
                <asp:GridView ID="GridViewImages" runat="server" CssClass="GridViewList" AutoGenerateColumns="false" EmptyDataText="لا يوجد مرفقات">
                    <Columns>
                        <asp:TemplateField HeaderStyle-CssClass="NoDispaly">
                            <ItemTemplate>
                                <asp:Image ID="Image1" runat="server" ImageUrl='<%# "data:Image/Png;base64,"+ Convert.ToBase64String((byte[])Eval("Image")) %>'
                                    Width="660" Height="360" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataRowStyle CssClass="EmptyDataRowStyle" />
                </asp:GridView>
            </asp:Panel>
        </asp:Panel>
    </asp:Panel>
    <asp:Panel ID="PanelErrorMessage" runat="server" CssClass="ErrorMessagePanal" Visible="false">
        <article class="Errorarticle">
            <asp:Label ID="LabelErrMsg" runat="server" CssClass="LblErrorMsg2" Text="هذا المورد غير مسجل لدينا ... اما هناك خطأ فى الاسم او لو يدرج اى اسم"></asp:Label>
        </article>
    </asp:Panel>
</asp:Content>
