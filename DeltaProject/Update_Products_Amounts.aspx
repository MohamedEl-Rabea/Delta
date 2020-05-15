<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Update_Products_Amounts.aspx.cs" Inherits="DeltaProject.Update_Products_Amounts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
    <link href="CSS/jquery-ui-1.10.4.custom.min.css" rel="stylesheet" />
    <script type="text/javascript" src="Script/ServiseHandler.js"></script>    
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
        <p>تحديث كميات</p>
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
                <asp:BoundField DataField="Purchase_Price" HeaderText="السعر" />
                <asp:BoundField DataField="Amount" HeaderText="الكميه" />
                <asp:BoundField DataField="IsCollected" HeaderStyle-CssClass="NoDispaly" ItemStyle-CssClass="NoDispaly" />
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
        </asp:GridView>
    </asp:Panel>
    <asp:Panel runat="server" ID="AmountPanel" Visible="false">
        <table class="AddProductsTable">
            <tr>
                <td class="RHSTD2">
                    <p class="RHSP">اسم المـــــــورد :</p>
                </td>
                <td>
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
                <td class="RHSTD2">
                    <p class="RHSP">اسم المنتـــــــــج :</p>
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtboxP_name" Enabled="false" CssClass="txts2" PlaceHolder="اسم المنتــج" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
                <td style="text-align: center"></td>
            </tr>
            <asp:Panel runat="server" ID="PanelMotors" Visible="false">
                <tr>
                    <td class="RHSTD2">
                        <p class="RHSP">المـــــــــــــــاركه :</p>
                    </td>
                    <td>
                        <asp:TextBox runat="server" Enabled="false" ID="txtMark" CssClass="txts2" PlaceHolder="المـــــــاركه" AutoCompleteType="Disabled"></asp:TextBox>
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
                        <p class="RHSP">البوصـــــــــــــــه :</p>
                    </td>
                    <td>
                        <asp:TextBox runat="server" Enabled="false" ID="txtInch" CssClass="txts2" PlaceHolder="البوصــــــه" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                </tr>
            </asp:Panel>
            <asp:Panel runat="server" ID="PanelTol" Visible="false">
                <tr>
                    <td class="RHSTD2">
                        <p class="RHSP">الطــــــــــــــــراز :</p>
                    </td>
                    <td>
                        <asp:TextBox runat="server" Enabled="false" ID="txtStyle" CssClass="txts2" PlaceHolder="الطـــــــراز" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    
                </tr>
            </asp:Panel>
            <tr>
                <td class="RHSTD2">
                    <p class="RHSP">سعر الشـــــــراء :</p>
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtboxPurchasePrice" Enabled="false" CssClass="txts2" PlaceHolder="سعر الشـــراء" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
                <td style="text-align: center"></td>
            </tr>
            <tr>
                <td class="RHSTD2">
                    <p class="RHSP">سعر البيع العادى :</p>
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtboxRegularSellPrice" Enabled="false" CssClass="txts2" PlaceHolder="سعر البيع العادى" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="RHSTD2">
                    <br />
                    <br />
                </td>
                <td style="text-align: center"></td>
            </tr>
            <tr>
                <td class="RHSTD2">
                    <p class="RHSP">سعر البيع الخاص :</p>
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtboxSpecialSellPrice" Enabled="false" CssClass="txts2" PlaceHolder="سعر البيع الخاص" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="RHSTD2">
                    <br />
                    <br />
                </td>
                <td style="text-align: center"></td>
            </tr>
            <tr>
                <td class="RHSTD2">
                    <p class="RHSP">الكميــــــــــــــــــة :</p>
                </td>
                <td>
                    <asp:TextBox runat="server" ID="TxtCurrentAmount" Enabled="false" CssClass="txts2" PlaceHolder="الكمية" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    <br />
                    <br />
                </td>
            </tr>
            <tr>
                <td class="RHSTD2">
                    <p class="RHSP">الكميه المضافــــه :</p>
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtboxAddedAmount" CssClass="txts2" PlaceHolder="الكمية" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="RHSTD2">
                    <br />
                    <br />
                </td>
                <td style="text-align: center">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                        ControlToValidate="txtboxAddedAmount" Display="Dynamic" SetFocusOnError="true"
                        ToolTip="الكميه متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                    <asp:CustomValidator ID="CustomValidator5" runat="server"
                        ToolTip="يجب كتابة الكميه بشكل صحيح"
                        ControlToValidate="txtboxAddedAmount"
                        Display="Dynamic"
                        SetFocusOnError="true"
                        ClientValidationFunction="IsValidNumber">
                    <img src="Images/Error.png" width="24" height="24"/>
                    </asp:CustomValidator>
                </td>
            </tr>

        </table>
        <table class="AddProductsTable">
            <tr>
                <td class="RHSTD2">
                    <p class="RHSP">تاريخ الشــــــراء :</p>
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtDay" ClientIDMode="Static" Width="212" CssClass="DateTxts" PlaceHolder="يوم" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtMonth" ClientIDMode="Static" Width="212" CssClass="DateTxts_MID" PlaceHolder="شهر" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtYear" ClientIDMode="Static" Width="212" CssClass="DateTxts" PlaceHolder="سنه" AutoCompleteType="Disabled"></asp:TextBox>
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
                <td></td>
            </tr>
        </table>
        <asp:Panel runat="server" ID="PanelCost" Visible="false">
            <table class="InfoTable">
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
                            ClientValidationFunction="IsValidNumber">
                                <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <footer class="AddSupplierFooter">
            <div class="MsgDiv">
                <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
            </div>
            <asp:Button ID="BtnConfirm" runat="server" Text="تأكيد" CssClass="BtnNext"
                UseSubmitBehavior="false"
                OnClientClick="this.disabled='true';this.value='Please wait....';" OnClick="BtnConfirm_Click" />
        </footer>
    </asp:Panel>
</asp:Content>
