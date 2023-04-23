<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AddProductClassification.aspx.cs" Inherits="DeltaProject.AddProductClassification" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>إضافة تصنيفات</p>
    </header>
    <section>
        <table class="AddProductsTable">
            <tr>
                <td width="20%"></td>
                <td class="RHSTD">
                    <p class="RHSP">اسم التصنيف :</p>
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtClassificationName" CssClass="txts3" PlaceHolder="اسم التصنيف" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
                <td width="25%">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Display="Dynamic"
                                                ControlToValidate="txtClassificationName"
                                                SetFocusOnError="true"
                                                ValidationGroup="SaveClassification"
                                                ToolTip="اسم التصنيف متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                </td>
            </tr>
            </table>
    </section>
    <br/>
    <asp:Panel runat="server" ID="PanelClassificationDetails">
        <section>
            <asp:GridView runat="server" ID="gridViewClassificationDetails" CssClass="GridViewBill"
                DataKeyNames="AttrName"
                ShowHeaderWhenEmpty="true"
                AutoGenerateColumns="False"
                EmptyDataText="لا توجد عناصر لهذا التصنيف"
                ShowFooter="true"
                          OnRowDataBound="gridViewClassificationDetails_OnRowDataBound"
                OnRowCommand="gridViewClassificationDetails_OnRowCommand">
                <Columns>
                    <asp:TemplateField HeaderText="الاسم">
                        <ItemTemplate>
                            <asp:Label ID="lblAttrName" runat="server" Text='<%# Bind("AttrName") %>'></asp:Label>
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:TextBox ID="txtAttrName" placeholder="الاسم" runat="server" CssClass="EditTxt-md"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                ControlToValidate="txtAttrName"
                                ValidationGroup="AddAttributes"
                                Display="Dynamic"
                                SetFocusOnError="true"
                                ToolTip="الاسم متطلب اساسى"
                                ForeColor="Red"
                                Text="*" 
                                ValidateEmptyText="true">
                            </asp:RequiredFieldValidator>
                        </FooterTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="النوع">
                        <ItemTemplate>
                            <asp:Label ID="lblType" runat="server"  Text='<%# Bind("Type") %>'></asp:Label>
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:TextBox ID="txtType" placeholder="النوع" runat="server" CssClass="EditTxt-md"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                                                        ControlToValidate="txtType" 
                                                        ValidationGroup="AddAttributes"
                                                        Display="Dynamic"
                                                        SetFocusOnError="true"
                                                        ToolTip="النوع متطلب اساسى"
                                                        ForeColor="Red"
                                                        Text="*" 
                                                        ValidateEmptyText="true">
                            </asp:RequiredFieldValidator>
                        </FooterTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="إختيارى">
                        <ItemTemplate>
                            <asp:CheckBox ID="chklblOptional" runat="server" Checked='<%# Convert.ToBoolean(Eval("Optional") is DBNull ? 0 : Eval("Optional")) %>' Enabled="false" />
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:CheckBox ID="chkOptional" Checked="True" placeholder="إختيارى" runat="server" ></asp:CheckBox>
                        </FooterTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:ImageButton ID="btnDelete" runat="server" ImageUrl="~/Images/Delete.png" Width="16" Height="16"
                                CausesValidation="false" CommandName="Delete_Row" Visible = false
                                OnClientClick="return confirm('سيتم مسح هذا العنصر . . . هل تريد المتابعه ؟');" />
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:ImageButton ID="btnAdd" runat="server" ValidationGroup="AddAttributes"
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
        <footer class="AddSupplierChequeFooter">
            <div class="MsgDiv" style="text-align: center">
                <asp:Button ID="btnSave" runat="server" Text="حفظ" CssClass="BtnNext" OnClick="btnSave_Click" 
                            ValidationGroup="SaveClassification"/>
            </div>
        </footer>
    </asp:Panel>
    <footer>
        <div class="MsgDiv">
            <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
        </div>
    </footer>
</asp:Content>
