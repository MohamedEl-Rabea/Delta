<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="DeltaProject.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Delta MIS</title>
    <link href="Images/Logo.png" rel="icon" />
    <link href="CSS/LoginStyleSheet.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="BigDiv">
            <header style="width: 100%;">
                <div class="Header_Radius">
                </div>
                <img src="Images/Login_header.png" width="900" height="100" />
            </header>
            <section style="min-height: 485px; width: 100%">
                <header class="Sec_Header">
                    <table>
                        <tr>
                            <td>
                            </td>
                            <td style="vertical-align: central">
                                <table>
                                    <tr>
                                        <td>
                                            <h3 style="color: black; letter-spacing: 2px; font: bold 22px verdana">El-Rabea Management Information System</h3>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <h4 style="letter-spacing: 2px; color: #808080">Trading | Maintenance | Imports | Supplies</h4>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </header>
                <section class="Login_Section">
                    <table class="Login_Table">
                        <tr>
                            <td colspan="2" style="text-align:center">

                            </td>
                        </tr>
                        <tr>
                            <td class="Info_TD">
                                <table>
                                    <tr>
                                        <td style="text-align: right; padding-bottom: 3px;">
                                            <h4>اسم المستخدم</h4>

                                        </td>
                                        <td style="text-align: right">
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                                ControlToValidate="txtUserName" ToolTip="يجب كتابة اسم المستخدم" Font-Bold="true" Text="*" ForeColor="Red" SetFocusOnError="true"
                                                Display="Dynamic">
                                            </asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:TextBox ID="txtUserName" runat="server" CssClass="Usretxt" placeholder="اسم المستخدم" AutoCompleteType="Disabled"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: right; padding-bottom: 3px; padding-top: 7px;">
                                            <h4>الرقم السرى</h4>
                                        </td>
                                        <td style="text-align: right">
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                                                ControlToValidate="txtPassword" ToolTip="يجب كتابة الرقم السرى" Font-Bold="true" Text="*" ForeColor="Red" SetFocusOnError="true"
                                                Display="Dynamic">
                                            </asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:TextBox ID="txtPassword" runat="server" CssClass="Usretxt" placeholder="الرقم السرى" TextMode="Password"></asp:TextBox>

                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Button ID="btnLogin" runat="server" Text="تسجيـل دخـــــول" OnClick="btnLogin_Click" CssClass="LoginBtn" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="text-align: right">
                                <asp:Label ID="lblErrMsg" runat="server" CssClass="LoginErr"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="text-align:center">
                            </td>
                        </tr>
                    </table>
                </section>
            </section>
            <footer style="width: 100%">
                <img src="Images/Login_footer.png" width="900" height="10" />
            </footer>
        </div>
    </form>
</body>
</html>
