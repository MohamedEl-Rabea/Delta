<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Accounts_Settings.aspx.cs" Inherits="DeltaProject.Accounts_Settings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>اعدادات الحسابات</p>
    </header>
    <section>
        <table class="AddProductsTable">
            <tr>
                <td class="RHSTD">
                    <p class="RHSP">اسم المستخدم :</p>
                </td>
                <td style="text-align: right">
                    <asp:TextBox runat="server" ID="txtUser_Name" CssClass="txts2" PlaceHolder="اسم المستخدم" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
                <td class="ValodationTD">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                        ControlToValidate="txtUser_Name" Display="Dynamic" SetFocusOnError="true"
                        ToolTip="اسم المستخدم متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <p class="RHSP">الرقم السرى :</p>
                </td>
                <td style="text-align: right">
                    <asp:TextBox runat="server" ID="txtPassword" CssClass="txts2" TextMode="Password" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
                <td style="text-align:center">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                        ControlToValidate="txtPassword" Display="Dynamic" SetFocusOnError="true"
                        ToolTip="الرقم السرى متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <p class="RHSP">تأكيد الرقم :</p>
                </td>
                <td style="text-align: right">
                    <asp:TextBox runat="server" ID="txtConfirmPassword" CssClass="txts2" TextMode="Password" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
                <td style="text-align:center">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                        ControlToValidate="txtConfirmPassword" Display="Dynamic" SetFocusOnError="true"
                        ToolTip="تأكيد الرقم متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>

                    <asp:CompareValidator ID="CompareValidator1" runat="server"
                        ControlToValidate="txtConfirmPassword" 
                       ControlToCompare="txtPassword" Display="Dynamic" SetFocusOnError="true"
                        ToolTip="الرقم التأكيدى غير متطابق">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:CompareValidator>
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <p class="RHSP">الرقم الحالى:</p>
                </td>
                <td style="text-align: right">
                    <asp:TextBox runat="server" ID="txtCurrentPassword" CssClass="txts2" TextMode="Password"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
                <td style="text-align:center">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                        ControlToValidate="txtConfirmPassword" Display="Dynamic" SetFocusOnError="true"
                        ToolTip="الرقم الحالى متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                </td>
            </tr>
        </table>
    </section>
    <footer class="AddSupplierFooter">
        <asp:Button ID="BtnUpdate" runat="server" Text="تعديل" CssClass="BtnNext" OnClick="BtnUpdate_Click" />
        <div class="MsgDiv">
            <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
        </div>
    </footer>
</asp:Content>
