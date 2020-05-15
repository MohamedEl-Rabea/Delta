<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Update_Supplier_Info.aspx.cs" Inherits="DeltaProject.Update_Supplier_Info" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="Script/ServiseHandler.js"></script>
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
    <link href="CSS/jquery-ui-1.10.4.custom.min.css" rel="stylesheet" />
    <script src="Script/jquery-1.10.2.js"></script>
    <script src="Script/jquery-ui-1.10.4.custom.min.js"></script>
    <script type="text/javascript" src="Script/ValidationScript.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#<%= TextBoxSearch.ClientID%>').autocomplete({
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
        <p>تعديل بيانات مورد</p>
    </header>
    <section class="Search_Section">
        <table class="Search_table">
            <tr>
                <td class="Image_td">
                    <asp:ImageButton ID="ImageButtonSearch" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                        Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearch_Click" />
                </td>
                <td class="Search_td">
                    <asp:TextBox ID="TextBoxSearch" runat="server" AutoCompleteType="Disabled" CssClass="Search_TextBox"
                        placeholder="اسم المورد للبحث . . . . ."></asp:TextBox>
                </td>
            </tr>
        </table>
    </section>
    <asp:Panel runat="server" ID="PaenlSupplierInfo" Visible="false">
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
                        <asp:TextBox runat="server" ID="txtSupplier_Name" CssClass="txts2" PlaceHolder="اسم المورد" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
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
        <br />
        <br />
        <footer class="AddSupplierFooter">
            <asp:Button ID="BtnFinish" runat="server" Text="انهاء" CssClass="BtnNext" OnClick="BtnFinish_Click" />
            <div class="MsgDiv">
                <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
            </div>
        </footer>
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
                            Width="150px" EmptyDataText="لا يوجد ارقام هاتف" CssClass="GridViewList" OnRowCommand="GridViewPhones_RowCommand">
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:ImageButton ID="ImageButtonEdit" runat="server" ImageUrl="~/Images/Edit.png" Width="16" Height="16"
                                            CommandName="Edit_Row" CausesValidation="false" />
                                        <asp:ImageButton ID="ImageButtonDelete" runat="server" ImageUrl="~/Images/Delete.png" Width="16" Height="16"
                                            CausesValidation="false" CommandName="Delete_Row"
                                            OnClientClick="return confirm('سيتم مسح هذا الرقم من بيانات المورد . . . هل تريد المتابعه ؟');" />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:ImageButton ID="ImageButtonCancelEdit" runat="server" ImageUrl="~/Images/Cancel.png" Width="16" Height="16" ToolTip="الغاء التعديل" CausesValidation="false" CommandName="Cancel_Update" />
                                        <asp:ImageButton ID="ImageButtonConfirmEdit" runat="server" ImageUrl="~/Images/Ok.png" Width="16" Height="16" ToolTip="تاكيد التعديل" CommandName="Confirm_Update" />
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="رقم الهاتف">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtPhone" runat="server" CssClass="EditTxtName" Text='<%# Bind("Phone") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblPhone" runat="server" Text='<%# Bind("Phone") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                            <HeaderStyle CssClass="ConatactsHeader" />
                            <RowStyle CssClass="Row_Style" />
                            <AlternatingRowStyle CssClass="AlternatRowStyle" />
                        </asp:GridView>
                    </td>
                    <td style="padding-right: 150px">
                        <asp:GridView ID="GridViewFaxs" runat="server" AutoGenerateColumns="False"
                            EmptyDataText="لا يوجد ارقام فاكس" Width="150px" CssClass="GridViewList" OnRowCommand="GridViewFaxs_RowCommand">
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:ImageButton ID="ImageButtonEdit" runat="server" ImageUrl="~/Images/Edit.png" Width="16" Height="16" CommandName="Edit_Row" CausesValidation="false" />
                                        <asp:ImageButton ID="ImageButtonDelete" runat="server" ImageUrl="~/Images/Delete.png" Width="16" Height="16" CausesValidation="false" CommandName="Delete_Row"
                                            OnClientClick="return confirm('سيتم مسح هذا الرقم من بيانات المورد . . . هل تريد المتابعه ؟');" />
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:ImageButton ID="ImageButtonCancelEdit" runat="server" ImageUrl="~/Images/Cancel.png" Width="16" Height="16" ToolTip="الغاء التعديل" CausesValidation="false" CommandName="Cancel_Update" />
                                        <asp:ImageButton ID="ImageButtonConfirmEdit" runat="server" ImageUrl="~/Images/Ok.png" Width="16" Height="16" ToolTip="تاكيد التعديل" CommandName="Confirm_Update" />
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="رقم الفاكس">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtFax" CssClass="EditTxtName" runat="server" Text='<%# Bind("Fax") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblFax" runat="server" Text='<%# Bind("Fax") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
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
        <div class="MsgDiv" style="text-align: right">
            <table style="float: right; direction: rtl">
                <tr>
                    <td>
                        <p class="UnStyled">اذا كنت تريد اضافة بيانات اتصال جديده اضغط</p>
                    </td>
                    <td>
                        <asp:LinkButton ID="lnkBtnContacts" runat="server" CssClass="Link" OnClick="lnkBtnContacts_Click">هنا</asp:LinkButton>
                    </td>
                </tr>
            </table>
        </div>
        <br />
        <br />
    </asp:Panel>
    <asp:Panel ID="PanelErrorMessage" runat="server" CssClass="ErrorMessagePanal" Visible="false">
        <article class="Errorarticle">
            <asp:Label ID="LabelErrMsg" runat="server" CssClass="LblErrorMsg2" Text="هذا المورد غير مسجل لدينا ... اما هناك خطأ فى الاسم او لو يدرج اى اسم"></asp:Label>
        </article>
    </asp:Panel>
    <footer class="AddSupplierFooter">
        <div class="MsgDiv">
            <asp:Label ID="lblContactsMsg" runat="server" CssClass="MessageLabel"></asp:Label>
        </div>
    </footer>
</asp:Content>
