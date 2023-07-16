<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="SaleProducts.aspx.cs" Inherits="DeltaProject.SaleProducts" %>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <style>
        .GridViewBillItems .HeaderStyleBill, .GridViewBillItems .RowStyleList, .GridViewBillItems .AlternateRowStyleList{
            font-size: 16px;
        }
    </style>
    <script type="text/javascript" src="Script/ServiseHandler.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#<%= txtProductName.ClientID%>').autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: "Services/GetProductsNames.asmx/GetProductNames",
                        data: "{ 'name': '" + request.term + "' }",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json;charset=utf-8",
                        success: function (result) {
                            response(result.d.map(r => ({ label: r.Item2, value: r.Item2, productId: r.Item1 })));
                        },
                        error: function (error) {
                            alert('Problem');
                        }
                    });
                },
                select: function (event, ui) {
                    $('#<%= txtProductId.ClientID%>').val(ui.item.productId.toString());
                    $('#<%= txtProductId.ClientID%>').change();
                }
            });
        });

        $(function() {
            $('#<%= txtClient_Name.ClientID%>').autocomplete({
                source: function(request, response) {
                    $.ajax({
                        url: "Services/GetNamesService.asmx/Get_Clients_Basic_Data",
                        data: "{ 'Client_Name': '" + request.term + "' }",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json;charset=utf-8",
                        success: function(result) {
                            response(result.d.map(r => ({ label: r.Item1, value: r.Item1, phone: r.Item2 })));
                        },
                        error: function(result) {
                            alert('Problem');
                        }
                    });
                },
                select: function(event, ui) {
                    $('#<%= txtPhoneNumber.ClientID%>').val(ui.item.phone.toString());
                    $('#<%= txtPhoneNumber.ClientID%>').change();
                }
            });
        });
        function PrintDivContent(divId) {
            var printContent = document.getElementById(divId);
            var WinPrint = window.open('', '', 'height=auto,width=auto,resizable=1,scrollbars=1,toolbar=1,sta­tus=0');
            WinPrint.document.write('<html><head><title></title>');
            WinPrint.document.write('<link rel="stylesheet" href="CSS/Pages_Style_Sheet.css" type="text/css" />');
            WinPrint.document.write('</head><body >');
            WinPrint.document.write(printContent.innerHTML);
            WinPrint.document.write('</body></html>');
            WinPrint.document.close();
            WinPrint.focus();
            WinPrint.print();
        }
    </script>
    <style type="text/css">
        .auto-style1 {
            width: 109px;
        }

        .auto-style2 {
            text-align: right;
            width: 109px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>عملية بيع</p>
    </header>
    <asp:Panel runat="server" ID="PanelSearch" Visible="true">
        <asp:RadioButtonList ID="RadioButtonListCategories" runat="server" RepeatDirection="Horizontal"
                             CssClass="RBLCategories2"
                             OnSelectedIndexChanged="RadioButtonListCategories_SelectedIndexChanged"
                             AutoPostBack="true">
            <asp:ListItem Value="Products" Selected="True">منتجات مستودع</asp:ListItem>
            <asp:ListItem Value="Services">خدمات</asp:ListItem>
        </asp:RadioButtonList> 
        <section class="Search_Section">
            <table class="Search_table">
                <tr>
                    <td class="Image_td">
                        <asp:ImageButton ID="ImageButtonSearch" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                            Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearch_Click" />
                    </td>
                    <td class="Search_td">
                        <asp:TextBox runat="server" ID="txtProductId" CssClass="NoDispaly"></asp:TextBox>
                        <asp:TextBox ID="txtProductName" runat="server" AutoCompleteType="Disabled" CssClass="Search_TextBox"
                            placeholder="اسم المنتج للبحث . . . . ."></asp:TextBox>
                    </td>
                </tr>
            </table>
        </section>
        <asp:Panel runat="server" ID="PanelInitailResult" CssClass="PanelProductList" Visible="false">
            <asp:GridView ID="GridViewProducts" runat="server" AutoGenerateColumns="false"
                CssClass="GridViewList" EmptyDataText="لا توجد منتجات">
                <Columns>
                    <asp:BoundField DataField="Id" SortExpression="Id" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                    <asp:BoundField DataField="Name" HeaderText="اسم المنتج" SortExpression="Name" />
                    <asp:BoundField DataField="PurchasePrice"  ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                    <asp:BoundField DataField="SellPrice" HeaderText="سعر البيع" SortExpression="SellPrice" DataFormatString="{0:0.##}" />
                    <asp:BoundField DataField="Quantity" HeaderText="الكميه" SortExpression="Quantity" DataFormatString="{0:0.##}" ItemStyle-CssClass="remainingQuantity"/>
                    <asp:BoundField DataField="UnitName" HeaderText="الوحدة" SortExpression="UnitName" />

                    <asp:TemplateField HeaderText="الكميه المطلوبة">
                        <ItemTemplate>
                            <asp:TextBox ID="txtAmount" CssClass="EditTxt quantity" runat="server" AutoCompleteType="Disabled" placeholder="الكميه"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                                                        ControlToValidate="txtAmount" Display="Dynamic" SetFocusOnError="true"
                                                        ToolTip="الكميه المطلوبة متطلب اساسى" ValidationGroup="<%# Container.DataItemIndex %>">
                                <img src="Images/Error.png" width="15" height="15"/>
                            </asp:RequiredFieldValidator>
                            <asp:CustomValidator ID="CustomValidator9" runat="server"
                                ToolTip="يجب كتابة الكميه بشكل صحيح"
                                ControlToValidate="txtAmount"
                                Display="Dynamic"
                                SetFocusOnError="true"
                                ForeColor="Red"
                                ClientValidationFunction="IsValidNumber"
                                ValidationGroup="<%# Container.DataItemIndex %>">
                                <img src="Images/Error.png" width="15" height="15"/>
                            </asp:CustomValidator>
                            <asp:CustomValidator ID="CustomValidator1" runat="server"
                                                 ToolTip="يجب الا تزيد الكميه المطلوبه عن الكميه المتبقيه"
                                                 ControlToValidate="txtAmount"
                                                 Display="Dynamic"
                                                 SetFocusOnError="true"
                                                 ClientValidationFunction="IsValidQuantity" ValidationGroup="<%# Container.DataItemIndex %>">
                                <img src="Images/Error.png" width="15" height="15"/>
                            </asp:CustomValidator>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="السعر">
                        <ItemTemplate>
                            <asp:TextBox ID="txtPrice" CssClass="EditTxt price" runat="server" AutoCompleteType="Disabled" placeholder="السعر"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                                        ControlToValidate="txtPrice" Display="Dynamic" SetFocusOnError="true"
                                                        ToolTip="السعر متطلب اساسى" ValidationGroup="<%# Container.DataItemIndex %>">
                                <img src="Images/Error.png" width="15" height="15"/>
                            </asp:RequiredFieldValidator>
                            <asp:CustomValidator ID="CustomValidator10" runat="server"
                                ToolTip="يجب كتابة السعر بشكل صحيح"
                                ControlToValidate="txtPrice"
                                Display="Dynamic"
                                SetFocusOnError="true"
                                ForeColor="Red"
                                ClientValidationFunction="IsValidNumber"
                                ValidationGroup="<%# Container.DataItemIndex %>">
                                <img src="Images/Error.png" width="15" height="15"/>
                            </asp:CustomValidator>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="الخصم">
                        <ItemTemplate>
                            <asp:TextBox ID="txtDiscount" CssClass="EditTxt" runat="server" AutoCompleteType="Disabled" placeholder="الخصم" ></asp:TextBox>
                            <asp:CustomValidator ID="CustomValidator11" runat="server"
                                                 ToolTip="يجب كتابة الخصم بشكل صحيح"
                                                 ControlToValidate="txtPrice"
                                                 Display="Dynamic"
                                                 SetFocusOnError="true"
                                                 ClientValidationFunction="IsValidNumber"
                                                 ValidationGroup="<%# Container.DataItemIndex %>">
                                <img src="Images/Error.png" width="15" height="15"/>
                            </asp:CustomValidator>
                            <asp:CustomValidator ID="CustomValidator21" runat="server"
                                                 ToolTip="يجب الا يزيد الخصم عن اجمالى سعر المنتج"
                                                 ControlToValidate="txtDiscount"
                                                 Display="Dynamic"
                                                 SetFocusOnError="true"
                                                 ClientValidationFunction="IsValidDiscount" 
                                                 ValidationGroup="<%# Container.DataItemIndex %>">
                                <img src="Images/Error.png" width="15" height="15"/>
                            </asp:CustomValidator>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Button ID="btnAdd" runat="server" Text="اضافه" CssClass="BtnaddInGrid" OnClick="btnAdd_Click" ValidationGroup="<%# Container.DataItemIndex %>"/>
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
            <asp:Panel runat="server" ID="PanelAddFreeItem" CssClass="PanelProductList" Visible="false">
                <table class="AddFreeItemTable">
                    <tr>
                        <td class="RHSTD">
                            <p class="RHSP">اسم الخدمه :</p>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtFreeItemName" CssClass="EditTxtFreeItemName" PlaceHolder="اسم الخدمه" AutoCompleteType="Disabled"></asp:TextBox>
                        </td>
                        <td class="RHSTD">
                            <p class="RHSP">الكميه :</p>
                        </td>
                        <td style="text-align: right">
                            <asp:TextBox runat="server" ID="txtFreeItemAmount" CssClass="EditTxtFreeItemPrice" PlaceHolder="الكميه" AutoCompleteType="Disabled"></asp:TextBox>
                        </td>
                        <td class="RHSTD">
                            <p class="RHSP">السعر :</p>
                        </td>
                        <td style="text-align: right">
                            <asp:TextBox runat="server" ID="txtFreeItemPrice" CssClass="EditTxtFreeItemPrice" PlaceHolder="السعر" AutoCompleteType="Disabled"></asp:TextBox>
                        </td>
                        <td class="RHSTD">
                            <asp:Button ID="btnAddFreeItem" runat="server" Text="اضافه" CssClass="BtnaddInGrid" OnClick="btnAddFreeItem_Click" />
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <asp:Panel runat="server" ID="PanelFinish" Visible="false">
                <footer class="AddSupplierFooter" style="text-align: center">
                    <br />
                    <asp:Button ID="btnFinish" runat="server" Text="تم" CssClass="BtnNext" OnClick="btnFinish_Click" />
                    <div class="MsgDiv">
                        <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
                    </div>
                </footer>
            </asp:Panel>
        </asp:Panel>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelProductList" Visible="false">
        <section>
            <header class="ListHeader">
                <p>قائمة المنتجات</p>
            </header>
            <br />
            <asp:Panel ID="PanelList" runat="server" CssClass="PanelProductList">
                <asp:GridView runat="server" ID="GridViewItemsList" CssClass="GridViewList" AutoGenerateColumns="False" EmptyDataText="لا توجد منتجات"
                    OnRowCommand="GridViewItemsList_RowCommand" OnRowDataBound="GridViewItemsList_OnRowDataBound">
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:ImageButton ID="ImageButtonEdit" runat="server" ImageUrl="~/Images/Edit.png" Width="16" Height="16"
                                    CommandName="Edit_Row" CausesValidation="false" />
                                <asp:ImageButton ID="ImageButtonDelete" runat="server" ImageUrl="~/Images/Delete.png" Width="16" Height="16"
                                    CausesValidation="false" CommandName="Delete_Row"
                                    OnClientClick="return confirm('سيتم مسح هذا المنتج من جدول المنتجات . . . هل تريد المتابعه ؟');" />
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:ImageButton ID="ImageButtonCancelEdit" runat="server" ImageUrl="~/Images/Cancel.png" Width="16" Height="16"
                                    ToolTip="الغاء التعديل" CausesValidation="false" CommandName="Cancel_Update" />
                                <asp:ImageButton ID="btnConfirmEdit" runat="server" ImageUrl="~/Images/Ok.png" Width="16" Height="16"
                                    ToolTip="تاكيد التعديل" OnClick="btnConfirmEdit_OnClick" ValidationGroup="<%# Container.DataItemIndex %>" />
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="ProductId" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly"/>
                        <asp:BoundField DataField="Name" HeaderText="الاسم" ReadOnly="true" />
                        <asp:BoundField DataField="Quantity" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly remainingQuantity"/>
                        <asp:TemplateField HeaderStyle-CssClass="NoDisplay">
                            <EditItemTemplate>
                                <asp:Label runat="server" ID="lblIsService" Text='<%# Bind("IsService") %>' CssClass="NoDispaly isService"></asp:Label>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="الكميه المطلوبة">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblQuantity" Text='<%# Bind("SoldQuantity") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtQuantity" CssClass="EditTxt quantity" runat="server" AutoCompleteType="Disabled" Text='<%# Bind("SoldQuantity") %>' placeholder="الكميه"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                                                            ControlToValidate="txtQuantity" Display="Dynamic" SetFocusOnError="true"
                                                            ToolTip="الكميه المطلوبة متطلب اساسى" ValidationGroup="<%# Container.DataItemIndex %>">
                                    <img src="Images/Error.png" width="15" height="15"/>
                                </asp:RequiredFieldValidator>
                                <asp:CustomValidator ID="CustomValidator9" runat="server"
                                    ToolTip="يجب كتابة الكميه بشكل صحيح"
                                    ControlToValidate="txtQuantity"
                                    Display="Dynamic"
                                    SetFocusOnError="true"
                                    ForeColor="Red"
                                    ClientValidationFunction="IsValidNumber" ValidationGroup="<%# Container.DataItemIndex %>">
                                    <img src="Images/Error.png" width="15" height="15"/>
                                </asp:CustomValidator>
                                <asp:CustomValidator ID="CustomValidator22" runat="server"
                                                     ToolTip="يجب الا تزيد الكميه المطلوبه عن الكميه المتبقيه"
                                                     ControlToValidate="txtQuantity"
                                                     Display="Dynamic"
                                                     SetFocusOnError="true"
                                                     ClientValidationFunction="IsValidQuantity" ValidationGroup="<%# Container.DataItemIndex %>">
                                    <img src="Images/Error.png" width="15" height="15"/>
                                </asp:CustomValidator>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="السعر">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblPrice" Text='<%# Bind("SpecifiedPrice") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtPrice" CssClass="EditTxt price" runat="server" Text='<%# Bind("SpecifiedPrice") %>'
                                    AutoCompleteType="Disabled" placeholder="السعر"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                                                            ControlToValidate="txtPrice" Display="Dynamic" SetFocusOnError="true"
                                                            ToolTip="االسعر متطلب اساسى" ValidationGroup="<%# Container.DataItemIndex %>">
                                    <img src="Images/Error.png" width="15" height="15"/>
                                </asp:RequiredFieldValidator>
                                <asp:CustomValidator ID="CustomValidator12" runat="server"
                                    ToolTip="يجب كتابة السعر بشكل صحيح"
                                    ControlToValidate="txtPrice"
                                    Display="Dynamic"
                                    SetFocusOnError="true"
                                    ForeColor="Red"
                                    ClientValidationFunction="IsValidNumber" ValidationGroup="<%# Container.DataItemIndex %>">
                                    <img src="Images/Error.png" width="15" height="15"/>
                                </asp:CustomValidator>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="الخصم">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblDiscount" Text='<%# Bind("Discount") %>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:Label runat="server" ID="lblEditDiscount" Text='<%# Bind("Discount") %>'></asp:Label>
                                <asp:TextBox ID="txtDiscount" CssClass="EditTxt" runat="server" Text='<%# Bind("Discount") %>'
                                             AutoCompleteType="Disabled" placeholder="الخصم"></asp:TextBox>
                                <asp:CustomValidator ID="CustomValidator13" runat="server"
                                                     ToolTip="يجب كتابة الخصم بشكل صحيح"
                                                     ControlToValidate="txtPrice"
                                                     Display="Dynamic"
                                                     SetFocusOnError="true"
                                                     ForeColor="Red"
                                                     ClientValidationFunction="IsValidNumber" ValidationGroup="<%# Container.DataItemIndex %>">
                                    <img src="Images/Error.png" width="15" height="15"/>
                                    <asp:CustomValidator ID="CustomValidator20" runat="server"
                                                         ToolTip="يجب الا يزيد الخصم عن اجمالى سعر المنتج"
                                                         ControlToValidate="txtDiscount"
                                                         Display="Dynamic"
                                                         SetFocusOnError="true"
                                                         ForeColor="Red"
                                                         ClientValidationFunction="IsValidDiscount" 
                                                         ValidationGroup="<%# Container.DataItemIndex %>">
                                        <img src="Images/Error.png" width="15" height="15"/>
                                    </asp:CustomValidator>
                                </asp:CustomValidator>
                            </EditItemTemplate>
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
                            <p class="RHSP">التكلفه :</p>
                        </td>
                        <td style="width: 120px">
                            <asp:Label ID="lblTotalCost" runat="server" CssClass="Infolbl" Text="0"></asp:Label>
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
                        <td class="auto-style1"></td>
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
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                                ToolTip="يجب كتابة القيمة المدفوعه"
                                ControlToValidate="txtPaid_Amount"
                                Display="Dynamic"
                                SetFocusOnError="true"
                                ForeColor="Red">
                                <img src="Images/Error.png" width="24" height="24"/>
                            </asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td class="RHSTD">
                            <p class="RHSP">تكلفه اضافيه :</p>
                        </td>
                        <td style="text-align: right; padding-left: 5px;">
                            <asp:TextBox runat="server" ID="txtAdditionalCost" CssClass="Smalltxts"
                                PlaceHolder="تكلفه اضافيه على الفاتورة" AutoCompleteType="Disabled"></asp:TextBox>
                        </td>
                        <td class="auto-style2">
                            <p class="RHSP">ملاحظات التكلفه :</p>
                        </td>
                        <td style="text-align: right" colspan="3">
                            <asp:TextBox runat="server" ID="txtAdditionalcostNotes" CssClass="Smalltxts2"
                                PlaceHolder="اضافة اى ملاحظات تتعلق بالتكلفه المضافه" AutoCompleteType="Disabled"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="RHSTD">
                            <br />
                            <br />
                        </td>
                        <td style="text-align: center">
                            <asp:CustomValidator ID="CustomValidator3" runat="server"
                                ToolTip="يجب كتابة التكلفه الاضافيه بشكل سليم"
                                ControlToValidate="txtAdditionalCost"
                                Display="Dynamic"
                                SetFocusOnError="true"
                                ForeColor="Red"
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
            <asp:Button ID="btnConfirm" runat="server" Text="التالي" CssClass="BtnNext" OnClick="btnConfirm_Click" />
            <div class="MsgDiv">
                <asp:Label ID="lblConfirmMsg" runat="server" CssClass="MessageLabel"></asp:Label>
            </div>
        </footer>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelClientInfo" Visible="false">
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
                    <asp:CustomValidator ID="CustomValidator2" runat="server"
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
        <table class="AddProductsTable">
            <tr>
                <td class="RHSTD">
                    <p class="RHSP">اسم العميل :</p>
                </td>
                <td style="text-align: right">
                    <asp:TextBox runat="server" ID="txtClient_Name" CssClass="txts2" PlaceHolder="اسم العميل" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
                <td style="text-align: center">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                        ControlToValidate="txtClient_Name" Display="Dynamic" SetFocusOnError="true"
                        ToolTip="اسم العميل متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <p class="RHSP">رقم التليفون :</p>
                </td>
                <td style="text-align: right">
                    <asp:TextBox runat="server" ID="txtPhoneNumber" CssClass="txts2" PlaceHolder="رقم التليفون" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
                <td style="text-align: center">
                    <asp:CustomValidator ID="CustomValidator5" runat="server"
                                         ToolTip="يجب كتابة الرقم بشكل صحيح"
                                         ControlToValidate="txtPhoneNumber"
                                         Display="Dynamic"
                                         SetFocusOnError="true"
                                         ClientValidationFunction="IsValidNumber">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:CustomValidator>
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <p class="RHSP">عنوان العميل :</p>
                </td>
                <td style="text-align: right">
                    <asp:TextBox runat="server" ID="txtAddress" CssClass="txts2" PlaceHolder="اضف عنوان للعميل فى حالة لم يكن مسجل لديك من قبل" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
            </tr>
            <tr>
                <td style="vertical-align: top">
                    <p class="RHSP">ملاحظــــــــات :</p>
                </td>
                <td>
                    <asp:TextBox ID="TxtDesc" runat="server" CssClass="TxtMultiline" AutoCompleteType="Disabled"
                        TextMode="MultiLine" placeholder="اضف وصفا للمنتج ....."></asp:TextBox>
                </td>
            </tr>
        </table>
        <br />
        <br />
        <footer class="AddSupplierFooter">
            <asp:Button ID="btnBill" runat="server" Text="فاتورة" CssClass="BtnNext" OnClick="btnBill_Click" />
        </footer>
    </asp:Panel>

    <asp:Panel runat="server" ID="PanelBill" Visible="false">
        <header class="Sec_footer" style="text-align: left; margin-top: 25px">
            <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/Images/printer.png" Width="28" Height="28" OnClientClick="PrintDivContent('divToPrint');" ToolTip="اطبع التقرير" />
        </header>
        <div id="divToPrint" class="Prices_Offer_DivBill">
            <%--Report Headre--%>
            <header class="Bill_header">
            </header>
            <header class="Prices_Offer_HeaderBill" style="border-bottom: none;">
                <table class="Offer_Header_table">
                    <tr>
                        <td style="vertical-align: top; width: 270px;">
                            <p style="font: bold 28px Arial; color: black; margin: 0; padding: 0">مؤسسة صحارى</p>
                            <p style="font: bold 20px Arial; color: black; line-height: 25px; margin: 0; padding: 0">للتوريد و التركيب</p>
                            <p style="font: bold 16px Arial; color: black; line-height: 25px; margin: 0; padding: 0">جميع مهامات الجهد المنخفض والمتوسط - مستلزمات الآبار - أنظمة الطاقه الشمسية</p>

                        </td>
                        <td>
                            <div class="Logo_divBill">
                                <img src="Images/Logo.jpg" width="90" height="90" class="LogoImage" />
                            </div>
                        </td>
                        <td style="vertical-align: middle; width: 250px;">
                            <p style="font: bold 16px Arial; color: black; line-height: 25px; margin: 0; padding: 0">ادارة م / ممدوح عبدالحميد</p>
                            <p style="font: bold 16px Arial; color: black; line-height: 25px; margin: 0; padding: 0">&nbsp;&nbsp;&nbsp;م / محمد ممدوح</p>
                            <p style="font: bold 16px Arial; color: black; line-height: 25px; margin: 0; padding: 0">&nbsp;&nbsp;م / على ممدوح</p>
                        </td>
                    </tr>
                </table>
                <section class="ContactsSection">
                </section>
            </header>
            <%--Report PreSection--%>
            <header class="Prices_Offer_SubHeaderBill">
                <div>
                    <p>عرض سعر</p>
                </div>
            </header>
            <section class="ReportDeclarationSection">
                <section>
                    <table>
                        <tr>
                            <td>
                                <asp:Label runat="server" Text="تاريخ العرض : " CssClass="lblInfo"></asp:Label>
                            </td>
                            <td style="width: 120px">
                                <asp:Label ID="lblBillDate" runat="server" CssClass="lblInfo2" Text="01/01/0001"></asp:Label>
                            </td>
                            <td>
                                <asp:Label runat="server" Text="رقم العرض : " CssClass="lblInfo"></asp:Label>
                            </td>
                            <td style="width: 120px">
                                <asp:Label ID="lblBill_ID" runat="server" CssClass="lblInfo2" Text="رقم العرض"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="Label1" runat="server" Text="العميل : " CssClass="lblInfo"></asp:Label>
                            </td>
                            <td style="width: 120px">
                                <asp:Label ID="lblClientName" runat="server" CssClass="lblInfo2" Text="اسم العميل"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="Label2" runat="server" Text="العنوان : " CssClass="lblInfo"></asp:Label>
                            </td>
                            <td style="width: 120px">
                                <asp:Label ID="lblAddress" runat="server" CssClass="lblInfo2" Text="عنوان العميل"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="Label3" runat="server" CssClass="lblInfo" Text="الاجمالى : "></asp:Label>
                            </td>
                            <td style="width: 120px">
                                <asp:Label ID="lblBillCost" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblAddtionalCost" runat="server" CssClass="lblInfo" Text="تكلفة اضافيه : "></asp:Label>
                            </td>
                            <td style="width: 120px">
                                <asp:Label ID="lblAdditionalCostValue" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="Label4" runat="server" CssClass="lblInfo" Text="المدفوع : "></asp:Label>
                            </td>
                            <td style="width: 120px">
                                <asp:Label ID="lblPaid_Value" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="Label7" runat="server" CssClass="lblInfo" Text="المتبقى : "></asp:Label>
                            </td>
                            <td style="width: 120px">
                                <asp:Label ID="lblRest" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="lblPreAdditionalcostNotes" runat="server" CssClass="lblInfo" Text="ملاحظات التكلفه الاضافيه : "></asp:Label>
                            </td>
                            <td colspan="5">
                                <asp:Label ID="lblAdditionalcostNotes" runat="server" CssClass="lblInfo2" Text=" ملاحظات التكلفه الاضافيه"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </section>
                <br />
                <asp:GridView runat="server" ID="GridViewBillList" CssClass="GridViewBill GridViewBillItems" AutoGenerateColumns="False" EmptyDataText="لا توجد منتجات"
                    OnRowDataBound="GridViewBillList_RowDataBound" ShowFooter="true">
                    <Columns>
                        <asp:BoundField DataField="Name" HeaderText="اسم المنتج" SortExpression="Name" />
                        <asp:BoundField DataField="UnitName" HeaderText="الوحدة" SortExpression="UnitName" />
                        <asp:BoundField DataField="SoldQuantity" HeaderText="الكميه" SortExpression="SoldQuantity" DataFormatString="{0:0.##}" />
                        <asp:BoundField DataField="ReturnedQuantity" HeaderText="المرتجع" SortExpression="ReturnedQuantity" DataFormatString="{0:0.##}" />
                        <asp:BoundField DataField="SpecifiedPrice" HeaderText="سعر البيع" SortExpression="SpecifiedPrice" DataFormatString="{0:0.##}" />
                        <asp:BoundField DataField="Discount" HeaderText="الخصم" SortExpression="Discount" DataFormatString="{0:0.##}" />
                        <asp:TemplateField HeaderText="سعر الجمله">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblCost"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle CssClass="HeaderStyleBill" />
                    <RowStyle CssClass="RowStyleList" />
                    <AlternatingRowStyle CssClass="AlternateRowStyleList" />
                    <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                    <FooterStyle CssClass="FooterStyleBill" />
                </asp:GridView>
            </section>
            <footer class="Prices_Offer_Footer" style="margin-bottom: 25px; text-align: center; height: auto">
                <table class="Offer_Header_table">
                    <tr>
                        <td style="width: 30%; text-align: right; vertical-align: top; padding-right: 10px;">
                            <p style="font: bold 14px Arial; color: white; line-height: 25px; text-decoration: underline">المقر الرئيسى</p>
                            <p style="font: bold 14px Arial; color: white; line-height: 25px;">العنوان: المنيا - بنى مزار - طريق القاهرة اسيوط الغربى بحرى كمين بنى مزار 500م</p>
                            <p style="font: bold 14px Arial; color: white; line-height: 25px;">للاتصال: 01000901815 - 01206778015</p>
                            <p style="font: bold 14px Arial; color: white; line-height: 25px; margin-right: 25px;"></p>
                        </td>
                        <td style="width: 30%; text-align: right; vertical-align: top; padding-right: 10px;">
                            <p style="font: bold 14px Arial; color: white; line-height: 25px; text-decoration: underline">مقر ملوى</p>
                            <p style="font: bold 14px Arial; color: white; line-height: 25px;">العنوان: المنيا - ملوى - طريق القاهرة اسيوط الغربى بحرى كمين ملوى 500م</p>
                            <p style="font: bold 14px Arial; color: white; line-height: 25px;">للاتصال: 01027793162 - 01110211419</p>
                        </td>
                        <td style="width: 30%; text-align: right; vertical-align: top; padding-right: 10px;">
                            <p style="font: bold 14px Arial; color: white; line-height: 25px; text-decoration: underline">مقر الواحات</p>
                            <p style="font: bold 14px Arial; color: white; line-height: 25px;">العنوان: غرب غرب المنيا - طريق الواحات</p>
                        </td>
                    </tr>
                </table>
            </footer>
        </div>
    </asp:Panel>
</asp:Content>

