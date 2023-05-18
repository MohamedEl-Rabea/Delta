<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="SearchForSupplier.aspx.cs" Inherits="DeltaProject.SearchForSupplier" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(function () {
            $('#<%= ddlSuppliers.ClientID%>').select2();
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>استعلام عن مورد</p>
    </header>
    <asp:RadioButtonList ID="RadioButtonListCategories" runat="server" RepeatDirection="Horizontal" CssClass="RBLCategories2"
        OnSelectedIndexChanged="RadioButtonListCategories_SelectedIndexChanged" AutoPostBack="true">
        <asp:ListItem Value="SupplierName" Selected="True">اسم المورد</asp:ListItem>
        <asp:ListItem Value="PhoneNumber">رقم التليفون</asp:ListItem>
    </asp:RadioButtonList>
    <section class="Search_Section">
        <table class="Search_table">
            <tr>
                <td class="Image_td">
                    <asp:ImageButton ID="ImageButtonSearch" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                        Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearch_Click"/>
                </td>
                <td class="Search_td select2NoBorder">
                    <asp:DropDownList ID="ddlSuppliers" runat="server" CssClass="Search_TextBox"
                                      Style="height: auto"
                                      DataTextField="Name"
                                      DataValueField="Id"
                                      AutoPostBack="True">
                    </asp:DropDownList>
                    <asp:TextBox ID="txtPhoneNumber" runat="server" AutoCompleteType="Disabled" Visible="false" CssClass="Search_TextBox"
                        placeholder="رقم التليفون للبحث . . . . ."></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td></td>
                <td style="text-align: center">
                    <asp:CustomValidator ID="CustomValidator1" runat="server"
                        ToolTip="يجب كتابة الرقم بشكل صحيح"
                        ControlToValidate="txtPhoneNumber"
                        Display="Dynamic"
                        SetFocusOnError="true"
                        ClientValidationFunction="IsValidNumber">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:CustomValidator>
                </td>
            </tr>
        </table>
    </section>

    <asp:Panel runat="server" ID="PanelSupplierData" Visible="False">
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
                        <asp:Label ID="lblSupplierName" runat="server" CssClass="lblInfo"></asp:Label>
                    </td>
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
                    <td colspan="2"></td>
                </tr>
            </table>
        </section>
        
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
    </asp:Panel>
    <asp:Panel ID="PanelErrorMessage" runat="server" CssClass="ErrorMessagePanal" Visible="false">
        <article class="Errorarticle">
            <asp:Label ID="LabelErrMsg" runat="server" CssClass="LblErrorMsg2" Text="هذا المورد غير مسجل لدينا ... اما هناك خطأ فى الاسم او رقم التليفون"></asp:Label>
        </article>
    </asp:Panel>
</asp:Content>
