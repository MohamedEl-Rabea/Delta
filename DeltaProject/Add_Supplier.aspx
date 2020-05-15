<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Add_Supplier.aspx.cs" Inherits="DeltaProject.Add_Supplier" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
    <link href="CSS/jquery-ui-1.10.4.custom.min.css" rel="stylesheet" />
    <script src="Script/jquery-1.10.2.js"></script>
    <script src="Script/jquery-ui-1.10.4.custom.min.js"></script>
    <script type="text/javascript" src="Script/ValidationScript.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#<%= txtSupplier_Name.ClientID%>').autocomplete({
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
        <p>اضافــــة مورد</p>
    </header>
    <asp:Panel runat="server" ID="PanelAddSupplier">
        <section>
            <table class="AddProductsTable">
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">اسم المـــورد :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtSupplier_Name" CssClass="txts2" PlaceHolder="اسم المورد" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                            ControlToValidate="txtSupplier_Name" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="اسم المورد متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">العنــــــوان :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtAddress" CssClass="txts2" PlaceHolder="عنوان المورد" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">رقم الحساب :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtAccount_Number" CssClass="txts2" PlaceHolder="رقم الحساب البنكى ان وجد" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:CustomValidator ID="CustomValidator10" runat="server"
                            ToolTip="يجب كتابة الرقم بشكل صحيح"
                            ControlToValidate="txtAccount_Number"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ClientValidationFunction="IsValidNumber">
                        <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                    </td>
                </tr>
            </table>
        </section>
        <footer class="AddSupplierFooter">
            <asp:Button ID="BtnFinish" runat="server" Text="انهاء" CssClass="BtnNext" OnClick="BtnFinish_Click" />
            <div class="MsgDiv" style="text-align: right">
                <asp:LinkButton ID="lnkBtnContacts" runat="server" Visible="false" CssClass="UnStyled" OnClick="lnkBtnContacts_Click">اذا كنت تريد اضافة بيانات اتصال خاصه بالمورد اضغط <span class="Link">هنا</span></asp:LinkButton>
            </div>
            <div class="MsgDiv">
                <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
            </div>
        </footer>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelContacts" Visible="false">
        <table class="AddProductsTable">
            <tr>
                <td class="RHSTD">
                    <p class="RHSP">رقم الهاتف :</p>
                </td>
                <td style="text-align: right">
                    <asp:TextBox runat="server" ID="txtPhone" CssClass="txts2" PlaceHolder="رقم الهاتف الخاص بالمورد" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
                <td class="ValodationTD">
                    <asp:Label ID="lblPhoneMsg" runat="server" CssClass="MessageLabel"></asp:Label>
                    <asp:CustomValidator ID="CustomValidator1" runat="server"
                        ToolTip="يجب كتابة الرقم بشكل صحيح"
                        ControlToValidate="txtPhone"
                        Display="Dynamic"
                        SetFocusOnError="true"
                        ClientValidationFunction="IsValidNumber">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:CustomValidator>
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <p class="RHSP">رقم الفاكس :</p>
                </td>
                <td style="text-align: right">
                    <asp:TextBox runat="server" ID="txtFax" CssClass="txts2" PlaceHolder="رقم الفاكس الخاص بالمورد" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
                <td class="ValodationTD">
                    <asp:Label ID="lblFaxMsg" runat="server" CssClass="MessageLabel"></asp:Label>
                    <asp:CustomValidator ID="CustomValidator2" runat="server"
                        ToolTip="يجب كتابة الرقم بشكل صحيح"
                        ControlToValidate="txtFax"
                        Display="Dynamic"
                        SetFocusOnError="true"
                        ClientValidationFunction="IsValidNumber">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:CustomValidator>
                </td>
            </tr>
        </table>
        <footer class="AddSupplierFooter">
            <asp:Button ID="BtnAdd" runat="server" Text="اضافه" CssClass="BtnNext" OnClick="BtnAdd_Click" />
        </footer>
    </asp:Panel>
</asp:Content>
