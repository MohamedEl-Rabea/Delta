<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="EditUnit.aspx.cs" Inherits="DeltaProject.EditUnit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .EditTxt-md {
            width: 120px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>تعديل وحدات القياس</p>
    </header>
    <section>
        <table class="AddProductsTable">
            <tr>
                <td width="15%"></td>
                <td class="RHSTD">
                    <p class="RHSP">اسم الوحدة :</p>
                </td>
                <td>
                    <asp:DropDownList ID="ddlUnits" runat="server" CssClass="txts3 autoW"
                                      Style="height: auto"
                                      DataTextField="Name"
                                      DataValueField="Id"
                                      Width="70%" 
                                      AutoPostBack="true"
                                      OnSelectedIndexChanged="ddlUnits_OnSelectedIndexChanged">
                    </asp:DropDownList>
                </td>
            </tr>
        </table>
    </section>
    <br/>
    <asp:Panel runat="server" ID="PanelUnitFactors" Visible="False">
        <section>
            <asp:GridView runat="server" ID="gridViewUnitFactors" CssClass="GridViewBill"
                DataKeyNames="Id"
                ShowHeaderWhenEmpty="true"
                AutoGenerateColumns="False"
                EmptyDataText="لا توجد تحويلات لهذه الوحدة"
                ShowFooter="true"
                OnDataBound="gridViewUnitFactors_OnDataBound"
                OnRowCommand="gridViewUnitFactors_OnRowCommand"
                OnRowDataBound="gridViewUnitFactors_OnRowDataBound">
                <Columns>
                    <asp:BoundField DataField="Id" Visible="false" SortExpression="Id" />
                    <asp:TemplateField HeaderText="اسم الوحدة">
                        <ItemTemplate>
                            <asp:Label ID="lblUnitName" runat="server" Text='<%# Bind("SubUnitName") %>'></asp:Label>
                        </ItemTemplate>
                        <FooterTemplate>
                            <%--<asp:TextBox ID="txtSubUnitName" placeholder="اسم الوحدة" runat="server" CssClass="EditTxt-md"></asp:TextBox>--%>
                            <asp:DropDownList ID="ddlSubUnits" runat="server" CssClass="EditTxt-md"
                                              Style="height: auto"
                                              DataTextField="Name"
                                              DataValueField="Id"
                                              AutoPostBack="true">
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server"
                                ControlToValidate="ddlSubUnits"
                                ValidationGroup="AddSubUnitGroup"
                                Display="Dynamic"
                                SetFocusOnError="true"
                                ToolTip="اسم الوحدة متطلب اساسى"
                                ForeColor="Red"
                                Text="*" 
                                ValidateEmptyText="true">
                            </asp:RequiredFieldValidator>
                        </FooterTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="معامل التحويل">
                        <ItemTemplate>
                            <asp:Label ID="lblFactor" runat="server"  Text='<%# Bind("Factor","{0:G29}") %>'></asp:Label>
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:TextBox ID="txtFactor" placeholder="معامل التحويل" runat="server" CssClass="EditTxt-md" DataFormatString="{0:G29}"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                                                        ControlToValidate="txtFactor" 
                                                        ValidationGroup="AddSubUnitGroup"
                                                        Display="Dynamic"
                                                        SetFocusOnError="true"
                                                        ToolTip="معامل التحويل متطلب اساسى"
                                                        ForeColor="Red"
                                                        Text="*" 
                                                        ValidateEmptyText="true">
                            </asp:RequiredFieldValidator>
                            <asp:CustomValidator ID="CustomValidator2" runat="server" ToolTip="يجب كتابة معامل التحويل بشكل صحيح"
                                                 ControlToValidate="txtFactor"
                                                 Display="Dynamic"
                                                 SetFocusOnError="true"
                                                 ForeColor="Red"
                                                 ValidationGroup="AddSubUnitGroup"
                                                 Text="*" 
                                                 ClientValidationFunction="IsValidDecimal">
                            </asp:CustomValidator>
                        </FooterTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:ImageButton ID="btnDelete" runat="server" ImageUrl="~/Images/Delete.png" Width="16" Height="16"
                                CausesValidation="false" CommandName="Delete_Row" Visible = false
                                OnClientClick="return confirm('سيتم مسح هذه الوحدة . . . هل تريد المتابعه ؟');" />
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:ImageButton ID="btnAdd" runat="server" ValidationGroup="AddSubUnitGroup"
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
                <asp:Button ID="btnSave" runat="server" Text="حفظ" CssClass="BtnNext" OnClick="btnSave_Click" />
            </div>
        </footer>
    </asp:Panel>
    <footer>
        <div class="MsgDiv">
            <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
        </div>
    </footer>
</asp:Content>
