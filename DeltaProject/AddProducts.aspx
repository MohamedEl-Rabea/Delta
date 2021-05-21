<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AddProducts.aspx.cs" Inherits="DeltaProject.AddProducts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="Script/ServiseHandler.js"></script>
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

        $(function () {
            $('#<%= txtboxP_name.ClientID%>').autocomplete({
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
                        error: function (error) {
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
        <p>اضافــــة منتجـــــــات</p>
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
                    <td></td>
                </tr>
            </table>
            <table class="AddProductsTable">
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">تاريخ الشراء :</p>
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="txtDay" ClientIDMode="Static" CssClass="DateTxts" PlaceHolder="يوم" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="txtMonth" ClientIDMode="Static" CssClass="DateTxts_MID" PlaceHolder="شهر" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="txtYear" ClientIDMode="Static" CssClass="DateTxts" PlaceHolder="سنه" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                    <td>
                        <asp:Button ID="BtnGetDate" runat="server" Text=":" CausesValidation="false" CssClass="GetDateStyle"
                            OnClientClick="return GetDate()" />
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td style="text-align: center">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorDay" runat="server" ControlToValidate="txtDay" Display="Dynamic" SetFocusOnError="true"
                            ErrorMessage="يجب اضافة يوم الشراء" ToolTip="يجب اضافة يوم الشراء">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:RangeValidator ID="RangeValidatorDay" runat="server" ErrorMessage="RangeValidator" Display="Dynamic"
                            ControlToValidate="txtDay" Type="Integer" MinimumValue="1" MaximumValue="31" ToolTip="يجب اضافة اليوم بشكل صحيح مابين 1-31">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RangeValidator>
                    </td>
                    <td style="text-align: center">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorMonth" runat="server" ControlToValidate="txtMonth" Display="Dynamic" SetFocusOnError="true"
                            ErrorMessage="يجب اضافة شهر الشراء" ToolTip="يجب اضافة شهر الشراء">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:RangeValidator ID="RangeValidatorMonth" runat="server" ErrorMessage="RangeValidator" Display="Dynamic"
                            ControlToValidate="txtMonth" Type="Integer" MinimumValue="1" MaximumValue="12" ToolTip="يجب اضافة اليوم بشكل صحيح مابين 1-12">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RangeValidator>
                    </td>
                    <td style="text-align: center">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorYear" runat="server" ControlToValidate="txtYear" Display="Dynamic" SetFocusOnError="true"
                            ErrorMessage="يجب اضافة سنة الشراء" ToolTip="يجب اضافة سنة الشراء">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator1" runat="server"
                            ToolTip="يجب اضافة سنة الشراء بشكل صحيح"
                            ControlToValidate="txtYear"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ClientValidationFunction="IsValidYear">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                    </td>

                </tr>
            </table>
        </section>
        <footer class="AddSupplierFooter">
            <asp:Button ID="ButtonNext" runat="server" Text="التالى" CssClass="BtnNext" OnClick="ButtonNext_Click" />
        </footer>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelAddProducts" Visible="false">
        <section>
            <header style="text-align: left">
                <asp:ImageButton ID="ImageButtonBackToAddSupplier" runat="server" ImageUrl="~/Images/back.png" Width="24" Height="24"
                    ToolTip="رجوع" OnClick="ImageButtonBackToAddSupplier_Click" CausesValidation="false" />
            </header>
            <br />
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
                <asp:Panel runat="server" ID="PanelMotors" Visible="false">
                    <tr>
                        <td class="RHSTD2">
                            <p class="RHSP">المـــــــــــــــاركه :</p>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtMark" CssClass="txts2" PlaceHolder="المـــــــاركه" AutoCompleteType="Disabled"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="RHSTD">
                            <br />
                            <br />
                        </td>
                        <td style="text-align: center">
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server"
                                ControlToValidate="txtMark" Display="Dynamic" SetFocusOnError="true"
                                ToolTip="ماركة المنتج متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                            </asp:RequiredFieldValidator>
                        </td>
                    </tr>

                    <tr>
                        <td class="RHSTD2">
                            <p class="RHSP">البوصـــــــــــــــه :</p>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtInch" CssClass="txts2" PlaceHolder="البوصــــــه" AutoCompleteType="Disabled"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="RHSTD">
                            <br />
                            <br />
                        </td>
                        <td style="text-align: center">
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server"
                                ControlToValidate="txtInch" Display="Dynamic" SetFocusOnError="true"
                                ToolTip="البوصه متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                            </asp:RequiredFieldValidator>
                            <asp:CustomValidator ID="CustomValidator10" runat="server"
                                ToolTip="يجب كتابة البوصه بشكل صحيح"
                                ControlToValidate="txtInch"
                                Display="Dynamic"
                                SetFocusOnError="true"
                                ClientValidationFunction="IsValidNumber">
                        <img src="Images/Error.png" width="24" height="24"/>
                            </asp:CustomValidator>
                        </td>
                    </tr>
                </asp:Panel>
                <asp:Panel runat="server" ID="PanelTol" Visible="false">
                    <tr>
                        <td class="RHSTD2">
                            <p class="RHSP">الطــــــــــــــــراز :</p>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtStyle" CssClass="txts2" PlaceHolder="الطـــــــراز" AutoCompleteType="Disabled"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="RHSTD">
                            <br />
                            <br />
                        </td>
                        <td style="text-align: center">
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server"
                                ControlToValidate="txtStyle" Display="Dynamic" SetFocusOnError="true"
                                ToolTip="ماركة المنتج متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                            </asp:RequiredFieldValidator>
                        </td>
                    </tr>
                </asp:Panel>
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
                    <td style="text-align: center">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                            ControlToValidate="txtboxPurchasePrice" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="سعر الشراء متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator3" runat="server"
                            ToolTip="يجب كتابة سعر الشراء بشكل صحيح"
                            ControlToValidate="txtboxPurchasePrice"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ClientValidationFunction="IsValidNumber">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
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
            <br />
        </section>
        <footer class="AddSupplierFooter">
            <div class="MsgDiv">
                <asp:Label ID="lblMsg" runat="server" CssClass="MessageLabel"></asp:Label>
            </div>
            <asp:Button ID="BtnNextToProductsList" runat="server" Text="التالى" CssClass="BtnNext"
                UseSubmitBehavior="false" OnClick="BtnNextToProductsList_Click" ToolTip="الانتقال الى القائمة" />
            <asp:Button ID="BtnAddProductToList" runat="server" Text="اضافه" CssClass="BtnAdd" OnClick="BtnAddProductToList_Click" ToolTip="اضف الى القائمة"
                UseSubmitBehavior="false"
                OnClientClick="this.disabled='true';this.value='Please wait....';" />
        </footer>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelProductsList" Visible="false">
        <header style="text-align: left">
            <asp:ImageButton ID="ImageButtonBackToAddProducts" runat="server" ImageUrl="~/Images/back.png" Width="24" Height="24"
                ToolTip="رجوع" OnClick="ImageButtonBackToAddProducts_Click" CausesValidation="false" />
        </header>
        <br />
        <section>
            <header class="ListHeader">
                <p>قائمة المنتجـــــات</p>
            </header>
            <br />
            <asp:Panel runat="server" CssClass="PanelProductList">
                <asp:GridView runat="server" ID="GridViewProductsList" CssClass="GridViewList"
                     AutoGenerateColumns="False" EmptyDataText="لا توجد منتجات" OnRowCommand="GridViewProductsList_RowCommand" OnRowDataBound="GridViewProductsList_RowDataBound">
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:ImageButton ID="ImageButtonEdit" runat="server" ImageUrl="~/Images/Edit.png" Width="16" Height="16"
                                    CommandName="Edit_Row" CausesValidation="false" />
                                <asp:ImageButton ID="ImageButtonDelete" runat="server" ImageUrl="~/Images/Delete.png" Width="16" Height="16"
                                    CausesValidation="false" CommandName="Delete_Row"
                                    OnClientClick="return confirm('سيتم مسح هذا البند من جدول المشتريات . . . هل تريد المتابعه ؟');" />
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:ImageButton ID="ImageButtonCancelEdit" runat="server" ImageUrl="~/Images/Cancel.png" Width="16" Height="16"
                                    ToolTip="الغاء التعديل" CausesValidation="false" CommandName="Cancel_Update" />
                                <asp:ImageButton ID="ImageButtonConfirmEdit" runat="server" ImageUrl="~/Images/Ok.png" Width="16" Height="16"
                                    ToolTip="تاكيد التعديل" CommandName="Confirm_Update" />
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="اسم المنتج">
                            <EditItemTemplate>
                                <asp:TextBox ID="txtP_name" CssClass="EditTxtName" AutoCompleteType="Disabled" runat="server" Text='<%# Bind("P_name") %>'></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                                    ControlToValidate="txtP_name" Display="Dynamic" SetFocusOnError="true"
                                    ToolTip="اسم المنتج متطلب اساسى"
                                    ForeColor="Red"
                                    Text="*" ValidateEmptyText="true">
                                </asp:RequiredFieldValidator>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="lblP_name" runat="server" Text='<%# Bind("P_name") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="الماركة">
                            <EditItemTemplate>
                                <asp:TextBox ID="txtP_Mark" CssClass="EditTxt" AutoCompleteType="Disabled" runat="server" Text='<%# Bind("Mark") %>'></asp:TextBox>
                                <asp:RequiredFieldValidator ID="Required3" runat="server"
                                    ControlToValidate="txtP_Mark" Display="Dynamic" SetFocusOnError="true"
                                    ToolTip="ماركة المنتج متطلب اساسى"
                                    ForeColor="Red"
                                    Text="*" ValidateEmptyText="true">
                                </asp:RequiredFieldValidator>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="lblP_Mark" runat="server" Text='<%# Bind("Mark") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="بوصه">
                            <EditItemTemplate>
                                <asp:TextBox ID="txtP_Inch" CssClass="EditTxt" AutoCompleteType="Disabled" runat="server" Text='<%# Bind("Inch") %>'></asp:TextBox>
                                <asp:RequiredFieldValidator ID="Required2" runat="server"
                                    ControlToValidate="txtP_Inch" Display="Dynamic" SetFocusOnError="true"
                                    ToolTip="بوصه المنتج متطلب اساسى"
                                    ForeColor="Red"
                                    Text="*" ValidateEmptyText="true">
                                </asp:RequiredFieldValidator>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="lblP_Inch" runat="server" Text='<%# Bind("Inch") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="طراز">
                            <EditItemTemplate>
                                <asp:TextBox ID="txtP_Style" CssClass="EditTxt" AutoCompleteType="Disabled" runat="server" Text='<%# Bind("Style") %>'></asp:TextBox>
                                <asp:RequiredFieldValidator ID="Required1" runat="server"
                                    ControlToValidate="txtP_Style" Display="Dynamic" SetFocusOnError="true"
                                    ToolTip="طراز المنتج متطلب اساسى"
                                    ForeColor="Red"
                                    Text="*" ValidateEmptyText="true">
                                </asp:RequiredFieldValidator>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="lblP_Style" runat="server" Text='<%# Bind("Style") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="سعر الشراء">
                            <EditItemTemplate>
                                <asp:TextBox ID="txtPurchase_Price" CssClass="EditTxt" AutoCompleteType="Disabled" runat="server" Text='<%# Bind("Purchase_Price") %>'></asp:TextBox>
                                <asp:CustomValidator ID="CustomValidator6" runat="server"
                                    ToolTip="يجب كتابة السعر بشكل صحيح"
                                    ControlToValidate="txtPurchase_Price"
                                    Display="Dynamic"
                                    SetFocusOnError="true"
                                    ForeColor="Red"
                                    Text="*" ValidateEmptyText="true"
                                    ClientValidationFunction="IsValidNumber">
                                </asp:CustomValidator>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="lblPurchase_Price" runat="server" Text='<%# Bind("Purchase_Price") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="السعر العادى">
                            <EditItemTemplate>
                                <asp:TextBox ID="txtRegulare_Price" CssClass="EditTxt" AutoCompleteType="Disabled" runat="server" Text='<%# Bind("Regulare_Price") %>'></asp:TextBox>
                                <asp:CustomValidator ID="CustomValidator7" runat="server"
                                    ToolTip="يجب كتابة السعر بشكل صحيح"
                                    ControlToValidate="txtRegulare_Price"
                                    Display="Dynamic"
                                    SetFocusOnError="true"
                                    ForeColor="Red"
                                    Text="*" ValidateEmptyText="true"
                                    ClientValidationFunction="IsValidNumber">
                                </asp:CustomValidator>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="lblRegulare_Price" runat="server" Text='<%# Bind("Regulare_Price") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="السعر الخاص">
                            <EditItemTemplate>
                                <asp:TextBox ID="txtSpecial_Price" CssClass="EditTxt" AutoCompleteType="Disabled" runat="server" Text='<%# Bind("Special_Price") %>'></asp:TextBox>
                                <asp:CustomValidator ID="CustomValidator8" runat="server"
                                    ToolTip="يجب كتابة السعر بشكل صحيح"
                                    ControlToValidate="txtSpecial_Price"
                                    Display="Dynamic"
                                    SetFocusOnError="true"
                                    ForeColor="Red"
                                    Text="*" ValidateEmptyText="true"
                                    ClientValidationFunction="IsValidNumber">
                                </asp:CustomValidator>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="lblSpecial_Price" runat="server" Text='<%# Bind("Special_Price") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
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
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:Label ID="lblDecription" runat="server" Text='<%# Bind("Description") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="NoDisplay" />
                            <ItemStyle CssClass="NoDispaly" />
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
                <table class="InfoTable">
                    <tr>
                        <td>
                            <p class="RHSP">المورد :</p>
                        </td>
                        <td>
                            <asp:Label ID="lblSupplier" runat="server" CssClass="Infolbl" Text="غير معروف"></asp:Label>
                        </td>
                        <td>
                            <p class="RHSP">تاريخ الشراء :</p>
                        </td>
                        <td style="direction: rtl">
                            <asp:Label ID="lblPurchaseDate" runat="server" CssClass="Infolbl"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p class="RHSP">التكلفه :</p>
                        </td>
                        <td>
                            <asp:Label ID="lblTotalCost" runat="server" CssClass="Infolbl"></asp:Label>
                        </td>
                        <td>
                            <p class="RHSP">المدفوع :</p>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtPaid_Amount" CssClass="Smalltxts" PlaceHolder="المدفوع" AutoCompleteType="Disabled"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <br />
                            <br />
                        </td>
                        <td></td>
                        <td></td>
                        <td style="padding-right: 100px;">
                            <asp:CustomValidator ID="CustomValidatorPaidAmount" runat="server"
                                ToolTip="يجب كتابة القيمة المدفوعه بشكل صحيح"
                                ControlToValidate="txtPaid_Amount"
                                Display="Dynamic"
                                SetFocusOnError="true"
                                ForeColor="Red"
                                ValidateEmptyText="true"
                                ClientValidationFunction="IsValidNumber"
                                ValidationGroup="FinishGroup">
                                <img src="Images/Error.png" width="24" height="24"/>
                            </asp:CustomValidator>
                        </td>
                    </tr>
                </table>
            </footer>
        </section>
        <br />
        <footer class="AddSupplierFooter">
            <asp:Button ID="BtnFinish" runat="server" Text="انهاء" CssClass="BtnNext" OnClick="BtnFinish_Click"
                UseSubmitBehavior="false"
                OnClientClick="this.disabled='true';this.value='Please wait....';" ValidationGroup="FinishGroup" />
            <div class="MsgDiv">
                <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
            </div>
        </footer>
    </asp:Panel>
</asp:Content>
