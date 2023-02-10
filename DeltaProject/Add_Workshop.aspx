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
                    <td class="RHSTD">
                        <p class="RHSP">اسم الورشة :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtWorkshop_Name" CssClass="txts2" PlaceHolder="اسم الورشة" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td><br /> <br /></td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                                                    ControlToValidate="txtWorkshop_Name" Display="Dynamic" SetFocusOnError="true"
                                                    ToolTip="اسم الورشة متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>
                </tr>
            </table>
        </section>
        <footer class="AddWorkshopFooter">
            <div class="MsgDiv" style="text-align: center">
                <asp:Button ID="BtnSave" runat="server" Text="حفظ" CssClass="BtnNext" OnClick="BtnSave_Click" />
            </div>
            <div class="MsgDiv">
                <asp:Label ID="lblSaveMsg" runat="server" CssClass="MessageLabel"></asp:Label>
            </div>
        </footer>
    </asp:Panel>
</asp:Content>
