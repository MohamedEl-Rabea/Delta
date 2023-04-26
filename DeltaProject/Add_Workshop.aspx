<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Add_Workshop.aspx.cs" Inherits="DeltaProject.Add_Workshop" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
        <header class="Header">
        <p>اضافــــة ورشة</p>
    </header>
    <asp:Panel runat="server" ID="PanelAddWorkshop">
        <section>
            <table class="AddProductsTable">
                <tr>
                    <td style="width: 20%"></td>
                    <td class="RHSTD">
                        <p class="RHSP">اسم الورشة :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtWorkshop_Name" CssClass="txts3" PlaceHolder="اسم الورشة" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                    <td style="width: 25%">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                            ControlToValidate="txtWorkshop_Name" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="اسم الورشة متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>
                </tr>
            </table>
        </section>
        <br/>
        <asp:Panel runat="server" ID="PanelPartners">
            <section>
                <asp:GridView runat="server" ID="gridViewPartners" CssClass="GridViewBill"
                    DataKeyNames="Id"
                    ShowHeaderWhenEmpty="true"
                    AutoGenerateColumns="False"
                    EmptyDataText="لا يوجد شركاء"
                    ShowFooter="true"
                    OnRowCommand="gridViewPartners_OnRowCommand"
                    OnRowDataBound="gridViewPartners_OnRowDataBound">
                    <Columns>
                        <asp:BoundField DataField="Id" Visible="false" SortExpression="Id" />
                        <asp:TemplateField HeaderText="اسم الشريك">
                            <ItemTemplate>
                                <asp:Label ID="lblPartnerName" runat="server" Text='<%# Bind("Name") %>'></asp:Label>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox ID="txtPartnerName" placeholder="اسم الشريك" runat="server" CssClass="EditTxt-md"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                    ControlToValidate="txtPartnerName"
                                    ValidationGroup="AddPartnerGroup"
                                    Display="Dynamic"
                                    SetFocusOnError="true"
                                    ToolTip="اسم الشريك متطلب اساسى"
                                    ForeColor="Red"
                                    Text="*"
                                    ValidateEmptyText="true">
                                </asp:RequiredFieldValidator>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:ImageButton ID="btnDelete" runat="server" ImageUrl="~/Images/Delete.png" Width="16" Height="16"
                                    CausesValidation="false" CommandName="Delete_Row" Visible="false"
                                    OnClientClick="return confirm('سيتم مسح هذا الشريك . . . هل تريد المتابعه ؟');" />
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:ImageButton ID="btnAdd" runat="server" ValidationGroup="AddPartnerGroup"
                                    ImageUrl="~/Images/AddNew.png"
                                    Width="20"
                                    Height="20"
                                    CommandName="Add_Row"
                                    CausesValidation="true" />
                            </FooterTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle CssClass="HeaderStyleBill" />
                    <RowStyle CssClass="RowStyleList" Height="25px" />
                    <AlternatingRowStyle CssClass="AlternateRowStyleList" />
                    <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                    <FooterStyle CssClass="FooterStyleBill" />
                </asp:GridView>
            </section>
            <footer class="AddWorkshopFooter">
                <div class="MsgDiv" style="text-align: center">
                    <asp:Button ID="BtnSave" runat="server" Text="حفظ" CssClass="BtnNext" OnClick="BtnSave_Click" Enabled="False" />
                </div>
            </footer>
        </asp:Panel>
        <footer class="AddWorkshopFooter">
            <div class="MsgDiv">
                <asp:Label ID="lblSaveMsg" runat="server" CssClass="MessageLabel"></asp:Label>
            </div>
        </footer>
    </asp:Panel>
</asp:Content>
