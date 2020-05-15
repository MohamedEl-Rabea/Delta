<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Collect_Product.aspx.cs" Inherits="DeltaProject.Collect_Product" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
    <link href="CSS/jquery-ui-1.10.4.custom.min.css" rel="stylesheet" />
    <script type="text/javascript" src="Script/jquery-2.1.4.js"></script>
    <script src="Script/jquery-1.10.2.js"></script>
    <script src="Script/jquery-ui-1.10.4.custom.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#<%= TextBoxSearch.ClientID%>').autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: "Services/GetProductsNames.asmx/Get_Products_Names",
                        data: "{ 'p_name': '" + request.term + "' }",
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
        <p>تجميع منتج</p>
    </header>
    <asp:Panel runat="server" ID="PnlCollectProducts">
        <section class="Search_Section">
            <table class="Search_table">
                <tr>
                    <td class="Image_td">
                        <asp:ImageButton ID="ImageButtonSearch" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                            Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearch_Click" />
                    </td>
                    <td class="Search_td">
                        <asp:TextBox ID="TextBoxSearch" runat="server" AutoCompleteType="Disabled" CssClass="Search_TextBox"
                            placeholder="اسم المنتج للبحث . . . . ."></asp:TextBox>
                    </td>
                </tr>
            </table>
        </section>
        <asp:Panel runat="server" ID="PanelInitailResult" CssClass="PanelProductList">
            <asp:GridView ID="GridViewProducts" runat="server" AutoGenerateColumns="false" CssClass="GridViewList" EmptyDataText="لا توجد منتجات">
                <Columns>
                    <asp:BoundField DataField="P_Name" HeaderText="الاسم" />
                    <asp:BoundField DataField="Purchase_Price" HeaderText="سعر الشراء" />
                    <asp:BoundField DataField="Amount" HeaderText="الكميه" />
                    <asp:TemplateField HeaderText="الكميه المطلوبة">
                        <ItemTemplate>
                            <asp:TextBox ID="txtAmount" CssClass="EditTxt" runat="server" AutoCompleteType="Disabled" placeholder="الكميه"></asp:TextBox>
                            <asp:CustomValidator ID="CustomValidator9" runat="server"
                                ToolTip="يجب كتابة الكميه بشكل صحيح"
                                ControlToValidate="txtAmount"
                                Display="Dynamic"
                                SetFocusOnError="true"
                                ForeColor="Red"
                                Text="*"
                                ClientValidationFunction="IsValidNumber">
                            </asp:CustomValidator>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Button ID="Btnadd" runat="server" Text="اضافه" CssClass="BtnaddInGrid" OnClick="Btnadd_Click" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <HeaderStyle CssClass="HeaderStyleList" />
                <RowStyle CssClass="RowStyleListHigher" />
                <AlternatingRowStyle CssClass="AlternateRowStyleListHigher" />
                <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                <SelectedRowStyle CssClass="SelectedRowStyle" />
            </asp:GridView>
            <br />
            <asp:Panel runat="server" ID="PanelFinish" Visible="false">
                <footer class="AddSupplierFooter" style="text-align: center">
                    <asp:Button ID="BtnFinish" runat="server" Text="تم" CssClass="BtnNext" OnClick="BtnFinish_Click" />
                    <div class="MsgDiv">
                        <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
                    </div>
                </footer>
            </asp:Panel>
        </asp:Panel>
    </asp:Panel>
    <asp:Panel runat="server" ID="PnlGeneratedProductInfo" Visible="false">
        <header style="text-align: left">
            <asp:ImageButton ID="ImageButtonBackToAddProducts" runat="server" ImageUrl="~/Images/back.png" Width="24" Height="24"
                ToolTip="رجوع" OnClick="ImageButtonBackToAddProducts_Click" CausesValidation="false" />
        </header>
        <br />
        <section>
            <header class="ListHeader">
                <p>المكونـــــــ ــات</p>
            </header>
            <br />
            <asp:Panel ID="Panel1" runat="server" CssClass="PanelProductList">
                <asp:GridView runat="server" ID="GridViewSelectedProducts" CssClass="GridViewList"
                    AutoGenerateColumns="False" EmptyDataText="لا توجد منتجات" OnRowCommand="GridViewSelectedProducts_RowCommand" OnRowDataBound="GridViewSelectedProducts_RowDataBound">
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:ImageButton ID="ImageButtonEdit" runat="server" ImageUrl="~/Images/Edit.png" Width="16" Height="16"
                                    CommandName="Edit_Row" CausesValidation="false" />
                                <asp:ImageButton ID="ImageButtonDelete" runat="server" ImageUrl="~/Images/Delete.png" Width="16" Height="16"
                                    CausesValidation="false" CommandName="Delete_Row"
                                    OnClientClick="return confirm('سيتم مسح هذا البند من جدول المنتجات . . . هل تريد المتابعه ؟');" />
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:ImageButton ID="ImageButtonCancelEdit" runat="server" ImageUrl="~/Images/Cancel.png" Width="16" Height="16"
                                    ToolTip="الغاء التعديل" CausesValidation="false" CommandName="Cancel_Update" />
                                <asp:ImageButton ID="ImageButtonConfirmEdit" runat="server" ImageUrl="~/Images/Ok.png" Width="16" Height="16"
                                    ToolTip="تاكيد التعديل" CommandName="Confirm_Update" CausesValidation="false" />
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="P_Name" HeaderText="الاسم" ReadOnly="true" />
                        <asp:BoundField DataField="Purchase_Price" HeaderText="سعر الشراء" ReadOnly="true" />
                        <asp:TemplateField HeaderText="الكميـــه">
                            <EditItemTemplate>
                                <asp:TextBox ID="txtAmount" CssClass="EditTxt" runat="server" AutoCompleteType="Disabled" Text='<%# Bind("Amount") %>'></asp:TextBox>
                                <asp:CustomValidator ID="CustomValidator9" runat="server"
                                    ToolTip="يجب كتابة الكميه بشكل صحيح"
                                    ControlToValidate="txtAmount"
                                    Display="Dynamic"
                                    SetFocusOnError="true"
                                    ForeColor="Red"
                                    Text="*" ValidateEmptyText="true"
                                    ClientValidationFunction="IsValidNumber">
                                </asp:CustomValidator>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="lblAmount" runat="server" Text='<%# Bind("Amount") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle CssClass="HeaderStyleList" />
                    <RowStyle CssClass="RowStyleList" />
                    <AlternatingRowStyle CssClass="AlternateRowStyleList" />
                    <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                </asp:GridView>
            </asp:Panel>
            <br />
            <br />
            <footer style="border-top: 2px solid #2c3e50; border-bottom: 2px solid #2c3e50; padding-top: 10px; padding-bottom: 10px;">
                <table class="AddProductsTable">
                    <tr>
                        <td class="RHSTD2">
                            <p class="RHSP">اسم المنتـــــــــج :</p>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtboxP_name" CssClass="txts2" PlaceHolder="اسم المنتــج" AutoCompleteType="Disabled"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="RHSTD">
                            <br />
                            <br />
                        </td>
                        <td style="text-align: center">
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                                ControlToValidate="txtboxP_name" Display="Dynamic" SetFocusOnError="true"
                                ToolTip="اسم المنتج متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                            </asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td class="RHSTD2">
                            <p class="RHSP">سعر الشـــــــراء :</p>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtboxPurchasePrice" CssClass="txts2" PlaceHolder="سعر الشـــراء" AutoCompleteType="Disabled"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="RHSTD">
                            <br />
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td class="RHSTD2">
                            <p class="RHSP">سعر البيع العادى :</p>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtboxRegularSellPrice" CssClass="txts2" PlaceHolder="سعر البيع العادى" AutoCompleteType="Disabled"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="RHSTD2">
                            <br />
                            <br />
                        </td>
                        <td style="text-align: center">
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                                ControlToValidate="txtboxRegularSellPrice" Display="Dynamic" SetFocusOnError="true"
                                ToolTip="سعر البيع العادى متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                            </asp:RequiredFieldValidator>
                            <asp:CustomValidator ID="CustomValidator2" runat="server"
                                ControlToValidate="txtboxRegularSellPrice"
                                Display="Dynamic"
                                SetFocusOnError="true"
                                ToolTip="يجب كتابة السعر بشكل صحيح"
                                ClientValidationFunction="IsValidNumber">
                        <img src="Images/Error.png" width="24" height="24"/>
                            </asp:CustomValidator>
                        </td>
                    </tr>
                    <tr>
                        <td class="RHSTD2">
                            <p class="RHSP">سعر البيع الخاص :</p>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtboxSpecialSellPrice" CssClass="txts2" PlaceHolder="سعر البيع الخاص" AutoCompleteType="Disabled"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="RHSTD2">
                            <br />
                            <br />
                        </td>
                        <td style="text-align: center">
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                                ControlToValidate="txtboxSpecialSellPrice" Display="Dynamic" SetFocusOnError="true"
                                ToolTip="سعر البيع الخاص متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                            </asp:RequiredFieldValidator>
                            <asp:CustomValidator ID="CustomValidator4" runat="server"
                                ToolTip="يجب كتابة سعر البيع الخاص بشكل صحيح"
                                ControlToValidate="txtboxSpecialSellPrice"
                                Display="Dynamic"
                                SetFocusOnError="true"
                                ClientValidationFunction="IsValidNumber">
                    <img src="Images/Error.png" width="24" height="24"/>
                            </asp:CustomValidator>
                        </td>
                    </tr>
                    <tr>
                        <td class="RHSTD2">
                            <p class="RHSP">الكميــــــــــــــــــة :</p>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtboxAmount" CssClass="txts2" PlaceHolder="الكمية" AutoCompleteType="Disabled"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="RHSTD2">
                            <br />
                            <br />
                        </td>
                        <td style="text-align: center">
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                                ControlToValidate="txtboxAmount" Display="Dynamic" SetFocusOnError="true"
                                ToolTip="الكميه متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                            </asp:RequiredFieldValidator>
                            <asp:CustomValidator ID="CustomValidator5" runat="server"
                                ToolTip="يجب كتابة الكميه بشكل صحيح"
                                ControlToValidate="txtboxAmount"
                                Display="Dynamic"
                                SetFocusOnError="true"
                                ClientValidationFunction="IsValidNumber">
                    <img src="Images/Error.png" width="24" height="24"/>
                            </asp:CustomValidator>
                        </td>
                    </tr>
                    <tr>
                        <td style="vertical-align: top">
                            <p class="RHSP">الوصــــــــــــــــف :</p>
                        </td>
                        <td>
                            <asp:TextBox ID="TxtDesc" runat="server" CssClass="TxtMultiline" AutoCompleteType="Disabled"
                                TextMode="MultiLine" placeholder="اضف وصفا للمنتج ....."></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </footer>
        </section>
        <br />
        <footer class="AddSupplierFooter">
            <asp:Button ID="BtnDone" runat="server" Text="انهاء" CssClass="BtnNext" OnClick="BtnDone_Click" />
            <div class="MsgDiv">
                <asp:Label ID="lblDoneMsg" runat="server"  CssClass="MessageLabel"></asp:Label>
            </div>
        </footer>
    </asp:Panel>
</asp:Content>
