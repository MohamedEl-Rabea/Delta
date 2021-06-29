<%--<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Add_SupplierCheque.aspx.cs" Inherits="DeltaProject.Add_SupplierCheque" %>--%>

<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Add_SupplierCheque.aspx.cs" Inherits="DeltaProject.Add_SupplierCheque" %>

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
        <p>اضافــــة شيك مورد</p>
    </header>
    <asp:Panel runat="server" ID="PanelAddSupplierCheque">
        <section>
            <table class="AddProductsTable">
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">اسم المورد :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtSupplier_Name" CssClass="txts3" PlaceHolder="اسم المورد" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>

                    <td class="RHSTD">
                        <p class="RHSP">تاريخ الاستحقاق :</p>
                    </td>
                    <td style="text-align: right"> 
                        <asp:TextBox runat="server" ID="DueDate" CssClass="txts3" PlaceHolder="تاريخ الاستحقاق" TextMode="Date"></asp:TextBox>
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

                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td class="ValodationTD">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                            ControlToValidate="DueDate" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="تاريخ الاستحقاق متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>
                </tr>

                <tr>
                    <td class="RHSTD2">
                        <p class="RHSP">قيمة الشيك :</p>
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="txtboxChequeValue" CssClass="txts3" PlaceHolder="قيمة الشيك" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>

                    <td class="RHSTD">
                        <p class="RHSP">رقم الشيك :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtChequeNumber" CssClass="txts3" PlaceHolder="رقم الشيك" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td style="text-align: center">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                            ControlToValidate="txtboxChequeValue" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="قيمة الشيك متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator3" runat="server"
                            ToolTip="يجب كتابة قيمة الشيك بشكل صحيح"
                            ControlToValidate="txtboxChequeValue"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ClientValidationFunction="IsValidNumber">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                    </td>

                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td style="text-align: center">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                            ControlToValidate="txtChequeNumber" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="رقم الشيك متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator4" runat="server"
                            ToolTip="يجب كتابة رقم الشيك بشكل صحيح"
                            ControlToValidate="txtChequeNumber"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ClientValidationFunction="IsValidNumber">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                    </td>
                </tr>
                
      
                <tr>
                    <td class="RHSTD2">
                        <p class="RHSP">تبيه قبل :</p>
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="txtboxAlertBefore" CssClass="txts3" PlaceHolder="مدة اظهار الاشعار" Text="1" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>

                    <td class="RHSTD">
                        <p class="RHSP">ملاحظات :</p>
                    </td>
                    <td style="text-align: right">
                        <asp:TextBox runat="server" ID="txtNotes" CssClass="txts3" PlaceHolder="ملاحظات" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>

                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td style="text-align: center">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                            ControlToValidate="txtboxAlertBefore" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="مدة اظهار الاشعار متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator5" runat="server"
                            ToolTip="يجب كتابة المدة بشكل صحيح"
                            ControlToValidate="txtboxAlertBefore"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ClientValidationFunction="IsValidNumber">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                    </td>
                </tr>
                
            </table>
        </section>
        <footer class="AddSupplierChequeFooter">
            <div class="MsgDiv" style="text-align: center">
               <asp:Button ID="BtnFinish" runat="server" Text="انهاء" CssClass="BtnNext" OnClick="BtnFinish_Click" />
            </div>
            <div class="MsgDiv">
                <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
            </div>
        </footer>
    </asp:Panel>
    
</asp:Content>