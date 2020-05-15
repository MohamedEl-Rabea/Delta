<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Update_Product_Info.aspx.cs" Inherits="DeltaProject.Update_Product_Info" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
        $(function () {
            $('#<%= TextBoxMotors.ClientID%>').autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: "Services/GetProductsNames.asmx/Get_MotorsProducts_Names",
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
        $(function () {
            $('#<%= TextBoxTol.ClientID%>').autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: "Services/GetProductsNames.asmx/Get_TolProducts_Names",
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
        <p>تحديث بيانات منتج</p>
    </header>
    <asp:RadioButtonList ID="RadioButtonListCategories" runat="server" RepeatDirection="Horizontal" CssClass="RBLCategories"
        OnSelectedIndexChanged="RadioButtonListCategories_SelectedIndexChanged" AutoPostBack="true">
        <asp:ListItem Value="Normal" Selected="True">منتجات عاديه</asp:ListItem>
        <asp:ListItem Value="Tol">طلمبات</asp:ListItem>
        <asp:ListItem Value="Motors">مواتير</asp:ListItem>
    </asp:RadioButtonList>
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
                    <asp:TextBox ID="TextBoxTol" runat="server" AutoCompleteType="Disabled" CssClass="Search_TextBox"
                        placeholder="اسم المنتج للبحث . . . . ." Visible="false"></asp:TextBox>
                    <asp:TextBox ID="TextBoxMotors" runat="server" AutoCompleteType="Disabled" CssClass="Search_TextBox"
                        placeholder="اسم المنتج للبحث . . . . ." Visible="false"></asp:TextBox>
                </td>
            </tr>
        </table>
    </section>
    <asp:Panel ID="PanelProducts" runat="server" CssClass="PanelSuppliersList">
        <asp:GridView ID="GridViewProducts" runat="server" AutoGenerateColumns="false" CssClass="GridViewList" EmptyDataText="لا توجد نتائج">
            <Columns>
                <asp:BoundField DataField="P_Name" HeaderText="الاسم" />
                <asp:BoundField DataField="Mark" HeaderText="الماركه" />
                <asp:BoundField DataField="Inch" HeaderText="البوصه" />
                <asp:BoundField DataField="Style" HeaderText="الطراز" />
                <asp:BoundField DataField="Purchase_Price" HeaderText="سعر الشراء" />
                <asp:BoundField DataField="Amount" HeaderText="الكميه" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton ID="LnkSelect" runat="server" CssClass="lnkbtnSelect" OnClick="LnkSelect_Click" CausesValidation="false">تحديث</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <HeaderStyle CssClass="HeaderStyleList" />
            <RowStyle CssClass="RowStyleListHigher" />
            <AlternatingRowStyle CssClass="AlternateRowStyleListHigher" />
            <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
            <SelectedRowStyle CssClass="SelectedRowStyle" />
        </asp:GridView>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelSuppliers" CssClass="Container" Visible="false">
        <header class="ListHeader">
            <p>المورديـــــــــن</p>
        </header>
        <br />
        <br />
        <asp:Panel ID="Panel1" runat="server" CssClass="PanelSuppliersList">
            <asp:GridView ID="GridViewProductSuppliers" runat="server" AutoGenerateColumns="False" CssClass="GridViewList"
                OnRowDataBound="GridViewProductSuppliers_RowDataBound" OnRowCommand="GridViewProductSuppliers_RowCommand" EmptyDataText="لا يوجد موردين لهذا المنتج">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:ImageButton ID="ImageButtonEdit" runat="server" ImageUrl="~/Images/Edit.png" Width="16" Height="16"
                                CommandName="Edit_Row" CausesValidation="false" />
                            <asp:ImageButton ID="ImageButtonDelete" runat="server" ImageUrl="~/Images/Delete.png" Width="16" Height="16"
                                CausesValidation="false" CommandName="Delete_Row"
                                OnClientClick="return confirm('سيتم مسح هذا البند من الجدول . . . هل تريد المتابعه ؟');" />
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:ImageButton ID="ImageButtonCancelEdit" runat="server" ImageUrl="~/Images/Cancel.png" Width="16" Height="16"
                                ToolTip="الغاء التعديل" CausesValidation="false" CommandName="Cancel_Update" />
                            <asp:ImageButton ID="ImageButtonConfirmEdit" runat="server" ImageUrl="~/Images/Ok.png" Width="16" Height="16"
                                ToolTip="تاكيد التعديل" CommandName="Confirm_Update" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="المورد">
                        <EditItemTemplate>
                            <asp:TextBox ID="txtSupplier" AutoCompleteType="Disabled" CssClass="EditTxt" runat="server" Text='<%# Bind("Supplier_Name") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="lblsupplier" runat="server" Text='<%# Bind("Supplier_Name") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="تاريخ الشراء">
                        <EditItemTemplate>
                            <asp:TextBox ID="txtPurchaseDay" runat="server" CssClass="GridTxtDay" MaxLength="2" placeholder="يوم"
                                Text='<%# GetDay((DateTime)Eval("Purchase_Date")) %>' AutoCompleteType="Disabled"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                                ControlToValidate="txtPurchaseDay" ToolTip="يجب اضافة اليوم" Display="Dynamic" Text="*" ForeColor="Red"></asp:RequiredFieldValidator>
                            <asp:RangeValidator ID="RangeValidatorDay1" runat="server" Display="Dynamic"
                                ControlToValidate="txtPurchaseDay" Type="Integer" MinimumValue="1" MaximumValue="31" ToolTip="يجب اضافة اليوم بشكل صحيح مابين 1-31" Text="*" ForeColor="Red">
                            </asp:RangeValidator>
                            <asp:TextBox ID="txtPurchaseMonth" runat="server" CssClass="GridTxtMonth" MaxLength="2" placeholder="شهر"
                                Text='<%# GetMonth((DateTime)Eval("Purchase_Date")) %>' AutoCompleteType="Disabled"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server"
                                ControlToValidate="txtPurchaseMonth" ToolTip="يجب اضافة الشهر" Display="Dynamic" Text="*" ForeColor="Red"></asp:RequiredFieldValidator>
                            <asp:RangeValidator ID="RangeValidator1" runat="server" Display="Dynamic"
                                ControlToValidate="txtPurchaseMonth" Type="Integer" MinimumValue="1" MaximumValue="12" ToolTip="يجب اضافة الشهر بشكل صحيح مابين 1-12" Text="*" ForeColor="Red">
                            </asp:RangeValidator>
                            <asp:TextBox ID="txtPurchaseYear" runat="server" CssClass="GridTxtYear" MaxLength="4" placeholder="سنه"
                                Text='<%# GetYear((DateTime)Eval("Purchase_Date")) %>' AutoCompleteType="Disabled"></asp:TextBox>
                            <asp:CustomValidator ID="CustomValidator1" runat="server"
                                ToolTip="يجب اضافة السنة بشكل صحيح"
                                ControlToValidate="txtPurchaseYear"
                                Display="Dynamic"
                                SetFocusOnError="true"
                                ValidateEmptyText="true"
                                ClientValidationFunction="IsValidYear"
                                Text="*"
                                ForeColor="Red">
                            </asp:CustomValidator>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="lblPurchase_Date" runat="server" Text='<%# Bind("Purchase_Date", "{0:d}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="السعر">
                        <ItemTemplate>
                            <asp:Label ID="lblPrice" runat="server" Text='<%# Bind("Price") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="الكميه">
                        <EditItemTemplate>
                            <asp:TextBox ID="txtSupplierAmount" AutoCompleteType="Disabled" CssClass="GridTxtAmount" runat="server" Text='<%# Bind("Amount") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="lblSupplierAmount" runat="server" Text='<%# Bind("Amount") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="المرتجع">
                        <EditItemTemplate>
                            <asp:TextBox ID="txtReturnedAmount" runat="server" placeholder="الكميه" AutoCompleteType="Disabled" CssClass="GridTxtAmount"
                                Text='<%# Bind("Returned_Products") %>'></asp:TextBox>
                            <asp:CustomValidator ID="CustomValidator2" runat="server"
                                ToolTip="يجب اضافة الكميه المرتجعه بشكل صحيح"
                                ControlToValidate="txtReturnedAmount"
                                Display="Dynamic"
                                SetFocusOnError="true"
                                ValidateEmptyText="true"
                                ClientValidationFunction="IsValidNumber"
                                Text="*"
                                ForeColor="Red">
                            </asp:CustomValidator>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="lblReturnedProducts" runat="server" Text='<%# Bind("Returned_Products") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="تاريخ المرتجع">
                        <EditItemTemplate>
                            <asp:TextBox ID="txtReturnDay" runat="server" CssClass="GridTxtDay" MaxLength="2" placeholder="يوم"
                                Text='<%# GetDay((DateTime)Eval("Return_Date")) %>' AutoCompleteType="Disabled"></asp:TextBox>
                            <asp:RangeValidator ID="RangeValidatorDay2" runat="server" Display="Dynamic"
                                ControlToValidate="txtReturnDay" Type="Integer" MinimumValue="1" MaximumValue="31" ToolTip="يجب اضافة اليوم بشكل صحيح مابين 1-31" Text="*" ForeColor="Red">
                            </asp:RangeValidator>
                            <asp:TextBox ID="txtReturnMonth" runat="server" CssClass="GridTxtMonth" MaxLength="2" placeholder="شهر"
                                Text='<%# GetMonth((DateTime)Eval("Return_Date"))%>' AutoCompleteType="Disabled"></asp:TextBox>
                            <asp:RangeValidator ID="RangeValidator5" runat="server" Display="Dynamic"
                                ControlToValidate="txtReturnMonth" Type="Integer" MinimumValue="1" MaximumValue="12" ToolTip="يجب اضافة الشهر بشكل صحيح مابين 1-12" Text="*" ForeColor="Red">
                            </asp:RangeValidator>
                            <asp:TextBox ID="txtReturnYear" runat="server" CssClass="GridTxtYear" MaxLength="4" placeholder="سنه"
                                Text='<%# GetYear((DateTime)Eval("Return_Date"))%>' AutoCompleteType="Disabled"></asp:TextBox>
                            <asp:CustomValidator ID="CustomValidator3" runat="server"
                                ToolTip="يجب اضافة السنة بشكل صحيح"
                                ControlToValidate="txtReturnYear"
                                Display="Dynamic"
                                SetFocusOnError="true"
                                ClientValidationFunction="IsValidYear"
                                Text="*"
                                ForeColor="Red">
                            </asp:CustomValidator>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="lblReturnDate" runat="server" Text='<%# Bind("Return_Date", "{0:d}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <HeaderStyle CssClass="HeaderStyleList" />
                <RowStyle CssClass="RowStyleList" />
                <AlternatingRowStyle CssClass="AlternateRowStyleList" />
                <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
            </asp:GridView>
        </asp:Panel>
        <footer class="UpdateProductFooter">
            <div>
                <table style="float: right; width: 100px;">
                    <tr>
                        <td>
                            <asp:ImageButton ID="ImageButton2" runat="server" ImageUrl="~/Images/BackDisabled.png" Width="20" Height="28"
                                ToolTip="السابق" Enabled="false" />
                        </td>
                        <td>
                            <asp:ImageButton ID="ImageButtonBackToAddProducts" runat="server" ImageUrl="~/Images/Next.png" Width="20" Height="28"
                                ToolTip="الانتقال الى بيانات المنتج المحدد" CausesValidation="false" OnClick="ImageButtonBackToAddProducts_Click" />
                        </td>
                    </tr>
                </table>
            </div>
            <div class="MsgDiv">
                <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
            </div>
        </footer>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelProductInfo" CssClass="Container" Visible="false">
        <header class="ListHeader">
            <p>بيانات المنتج</p>
        </header>
        <br />
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
                    <asp:TextBox runat="server" ID="txtboxAmount" CssClass="txts2" Enabled="false" PlaceHolder="الكمية" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="RHSTD2">
                    <br />
                    <br />
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
        <footer class="UpdateProductFooter" style="text-align: left">
            <asp:Button ID="BtnUpdateProductInfo" runat="server" Text="تحديث" CssClass="BtnNext" OnClick="BtnUpdateProductInfo_Click" />
            <div>
                <table style="float: right; width: 100px;">
                    <tr>
                        <td>
                            <asp:ImageButton ID="ImageButtonBack" runat="server" ImageUrl="~/Images/back.png" Width="20" Height="28"
                                ToolTip="الانتقال الى بيانات الموردين للمنتج المحدد" CausesValidation="false" OnClick="ImageButtonBack_Click" />
                        </td>
                        <td>
                            <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/Images/NextDisabled.png" Width="20" Height="28"
                                ToolTip="التالى" Enabled="false" />
                        </td>
                    </tr>
                </table>
            </div>
            <div class="MsgDiv">
                <asp:Label ID="lblProductInfoMsg" runat="server" CssClass="MessageLabel"></asp:Label>
            </div>
        </footer>
    </asp:Panel>
</asp:Content>
