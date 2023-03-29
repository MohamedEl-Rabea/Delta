<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AddUnit.aspx.cs" Inherits="DeltaProject.AddUnit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .addUnitFactor {
            text-align: -webkit-center;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>اضافــــة وحدة قياس</p>
    </header>
 
    <asp:Panel runat="server" ID="PanelAddUnit">
        <table class="AddProductsTable">
            <tr>
                <td class="RHSTD">
                    <p class="RHSP">اسم الوحدة :</p>
                </td>
                <td style="text-align: right">
                    <asp:TextBox runat="server" ID="txtMainUnitName" CssClass="txts3" Width="90%" PlaceHolder="اسم الوحدة" AutoCompleteType="Disabled"></asp:TextBox>
                </td>

                <td>
                    <asp:ImageButton ID="btnAddUnitFactors" runat="server" ImageUrl="~/Images/AddNew.png" Width="20" Height="20"
                        ToolTip="إضافة تحويل جديد" OnClick="btnAddUnitFactors_OnClick"></asp:ImageButton>
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
                <td class="ValodationTD">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                        ControlToValidate="txtMainUnitName" Display="Dynamic" SetFocusOnError="true"
                        ToolTip="اسم الوحدة متطلب اساسى" ValidationGroup="AddMainUnitGroup"> 
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                </td>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
            </tr>
        </table>
    </asp:Panel>
    
    <asp:Panel runat="server" ID="PanelAddUnitFactor" CssClass="addUnitFactor" Visible="False">
        <table class="AddProductsTable" style="width: 85%">
            <tr>
                <td class="RHSTD">
                    <p class="RHSP">اسم الوحدة :</p>
                </td>
                <td style="text-align: right">
                    <asp:DropDownList ID="ddlUnits" runat="server" CssClass="txts3 w200"
                                      Style="height: auto"
                        DataTextField="Name"
                        DataValueField="Id">
                    </asp:DropDownList>
                </td>
                <td class="RHSTD">
                    <p class="RHSP">معامل التحويل :</p>
                </td>
                <td style="text-align: right">
                    <asp:TextBox runat="server" ID="txtFactor" CssClass="txts3 w200" PlaceHolder="معامل التحويل" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
                <td>
                    <asp:Button ID="btnAddSubUnitFactor" runat="server" Text="اضافه" CssClass="BtnaddInGrid" ValidationGroup="AddSubUnitGroup" OnClick="btnAddSubUnitFactor_OnClick" />
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
                <td class="ValodationTD">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                        ControlToValidate="ddlUnits" Display="Dynamic" SetFocusOnError="true"
                        ToolTip="اسم الوحدة متطلب اساسى" ValidationGroup="AddSubUnitGroup">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                </td>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
                <td class="ValodationTD">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                        ControlToValidate="txtFactor" Display="Dynamic" SetFocusOnError="true"
                        ToolTip="معامل التحويل متطلب اساسى" ValidationGroup="AddSubUnitGroup">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                    <asp:CustomValidator ID="CustomValidator2" runat="server" ToolTip="يجب كتابة معامل التحويل بشكل صحيح"
                                         ControlToValidate="txtFactor"
                                         Display="Dynamic"
                                         SetFocusOnError="true"
                                         ForeColor="Red"
                                         ValidationGroup="AddSubUnitGroup"
                                         ClientValidationFunction="IsValidDecimal">
                        <img src="Images/Error.png" width="15" height="15"/>
                    </asp:CustomValidator>
                </td>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
            </tr>
        </table>
    </asp:Panel>

    <asp:Panel runat="server" ID="PanelUnitFactors" Visible="False" CssClass="addUnitFactor">
         <section style="Width: 80%;margin-left: 35px;">
         <br />
            <header class="ListHeader">
                <p>قائمة التحويلات</p>
            </header>
            <br />
            <asp:GridView runat="server" ID="GridViewPreviewUnitFactorList" CssClass="GridViewList" AutoGenerateColumns="False" OnRowCommand="GridViewPreviewUnitFactorList_OnRowCommand">
                <Columns>
                    <asp:BoundField DataField="SubUnitName" HeaderText="الاسم" ReadOnly="true" />
                    <asp:BoundField DataField="Factor" HeaderText="معامل التحويل" ReadOnly="true" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:ImageButton ID="ImageButtonDelete" runat="server" ImageUrl="~/Images/Delete.png" Width="16" Height="16"
                                             CausesValidation="false" CommandName="Delete_Row"
                                             OnClientClick="return confirm('سيتم مسح هذا العنصر من الجدول . . . هل تريد المتابعه ؟');" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <HeaderStyle CssClass="HeaderStyleList" />
                <RowStyle CssClass="RowStyleList" />
                <AlternatingRowStyle CssClass="AlternateRowStyleList" />
                <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
            </asp:GridView>
         </section> 
    </asp:Panel>
   
    <footer>
        <div class="MsgDiv" style="text-align: center">
            <asp:Button ID="btnSave" runat="server" Text="حفظ" CssClass="BtnNext" OnClick="btnSave_Click" ValidationGroup="AddMainUnitGroup" />
        </div>
        <div class="MsgDiv">
            <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
        </div>
    </footer>
</asp:Content>
