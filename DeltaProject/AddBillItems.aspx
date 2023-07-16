<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AddBillItems.aspx.cs" Inherits="DeltaProject.AddBillItems" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="Script/ServiseHandler.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#<%= txtClientName.ClientID%>').autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: "Services/GetNamesService.asmx/Get_Clients_Names",
                        data: "{ 'Client_Name': '" + request.term + "' }",
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>عملية اضافه لفاتورة</p>
    </header>
    <asp:Panel runat="server" ID="PanelSearchClient">
        <asp:RadioButtonList ID="RadioButtonListCategories" runat="server" RepeatDirection="Horizontal" CssClass="RBLCategories"
            OnSelectedIndexChanged="RadioButtonListCategories_SelectedIndexChanged" AutoPostBack="true">
            <asp:ListItem Value="ClientName" Selected="True">اسم العميل</asp:ListItem>
            <asp:ListItem Value="PhoneNumber">رقم التليفون</asp:ListItem>
            <asp:ListItem Value="BillNumber">رقم الفاتورة</asp:ListItem>
        </asp:RadioButtonList>
        <section class="Search_Section">
            <table class="Search_table">
                <tr>
                    <td class="Image_td">
                        <asp:ImageButton ID="ImageButtonSearch" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                            Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearch_Click" />
                    </td>
                    <td class="Search_td">
                        <asp:TextBox ID="txtClientName" runat="server" AutoCompleteType="Disabled" CssClass="Search_TextBox"
                            placeholder="اسم العميل للبحث . . . . ."></asp:TextBox>
                        <asp:TextBox ID="txtPhoneNumber" runat="server" AutoCompleteType="Disabled" Visible="false" CssClass="Search_TextBox"
                            placeholder="رقم التليفون للبحث . . . . ."></asp:TextBox>
                        <asp:TextBox ID="txtBillId" runat="server" AutoCompleteType="Disabled" Visible="false" CssClass="Search_TextBox"
                            placeholder="رقم الفاتورة للبحث . . . . ."></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td style="text-align: center">
                        <asp:CustomValidator ID="CustomValidator2" runat="server"
                            ToolTip="يجب كتابة الرقم بشكل صحيح"
                            ControlToValidate="txtPhoneNumber"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ClientValidationFunction="IsValidNumber">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                        <asp:CompareValidator ID="CompareValidator1" runat="server"
                            ControlToValidate="txtBillId"
                            Display="Dynamic"
                            Operator="DataTypeCheck"
                            Type="Integer"
                            SetFocusOnError="true"
                            ToolTip="يجب كتابة رقم الفاتورة بشكل صحيح">
                        <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CompareValidator>
                    </td>
                </tr>
            </table>
        </section>
    </asp:Panel>
    <asp:Panel ID="PanelErrorMessage" runat="server" CssClass="ErrorMessagePanal" Visible="false">
        <article class="Errorarticle">
            <asp:Label ID="LabelErrMsg" runat="server" CssClass="LblErrorMsg2" Text="هذا العميل/الرقم غير مسجل لدينا ... اما هناك خطأ فى الاسم/الرقم او لو يدرج اى اسم/رقم"></asp:Label>
        </article>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelBills" CssClass="PreReport_SectionTab" Visible="false">
        <asp:GridView ID="GridViewBills" runat="server" AutoGenerateColumns="False" OnRowCommand="GridViewBills_RowCommand"
            CssClass="Gridview_Style2" EmptyDataText="لا توجد فواتير لهذا العميل"
            DataSourceID="ObjectDataSourceBills" AllowPaging="True">
            <Columns>
                <asp:BoundField DataField="Date" HeaderText="تاريخ الفاتورة" SortExpression="Date" DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="ClientName" HeaderText="اسم العميل" SortExpression="ClientName" />
                <asp:TemplateField HeaderText="رقم الفاتورة" SortExpression="Id">
                    <ItemTemplate>
                        <asp:LinkButton ID="linkBillId" runat="server" Text='<%# Bind("Id") %>' ToolTip="الانتقال الى كامل بيانات الفاتورة" CommandName="SelectBill"></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <RowStyle CssClass="Row_Style" />
            <PagerStyle CssClass="PagerStyle" HorizontalAlign="Center" />
            <EmptyDataRowStyle CssClass="Empty_Style" />
        </asp:GridView>
        <asp:ObjectDataSource ID="ObjectDataSourceBills" runat="server"
            SelectMethod="GetAllBills"
            TypeName="DeltaProject.Business_Logic.SaleBill"
            StartRowIndexParameterName="startIndex"
            MaximumRowsParameterName="maxRows"
            SelectCountMethod="GetBillsCount"
            EnablePaging="True">
            <SelectParameters>
                <asp:ControlParameter ControlID="txtClientName" Name="clientName" PropertyName="Text" Type="String" />
                <asp:ControlParameter ControlID="txtPhoneNumber" Name="phoneNumber" PropertyName="Text" Type="String" />
                <asp:ControlParameter ControlID="txtBillId" Name="billId" PropertyName="Text" Type="Int32" />
            </SelectParameters>
        </asp:ObjectDataSource>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelAddItems" Visible="False">
        <asp:RadioButtonList ID="RadioButtonListItems" runat="server" RepeatDirection="Horizontal"
            CssClass="RBLCategories2"
            OnSelectedIndexChanged="RadioButtonListItems_SelectedIndexChanged"
            AutoPostBack="true">
            <asp:ListItem Value="Products" Selected="True">منتجات مستودع</asp:ListItem>
            <asp:ListItem Value="Services">خدمات</asp:ListItem>
        </asp:RadioButtonList>
        <section class="Search_Section">
            <table class="Search_table">
                <tr>
                    <td class="Image_td">
                        <asp:ImageButton ID="ImageButtonSearchItems" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                            Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearchItems_Click" />
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
                CssClass="GridViewList" EmptyDataText="لا توجد منتجات" OnRowDataBound="GridViewProducts_OnRowDataBound">
                <Columns>
                    <asp:BoundField DataField="Id" SortExpression="Id" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                    <asp:BoundField DataField="Name" HeaderText="اسم المنتج" SortExpression="Name" />
                    <asp:BoundField DataField="PurchasePrice" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                    <asp:BoundField DataField="SellPrice" HeaderText="سعر البيع" SortExpression="SellPrice" DataFormatString="{0:0.##}" />
                    <asp:BoundField DataField="Quantity" HeaderText="الكميه" SortExpression="Quantity" DataFormatString="{0:0.##}" ItemStyle-CssClass="remainingQuantity" />
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
                            <asp:Label ID="lblPrice" runat="server" CssClass="price" Text='0'></asp:Label>
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
                            <asp:TextBox ID="txtDiscount" CssClass="EditTxt" runat="server" AutoCompleteType="Disabled" placeholder="الخصم"></asp:TextBox>
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
                            <asp:Button ID="btnAdd" runat="server" Text="اضافه" CssClass="BtnaddInGrid" OnClick="btnAdd_Click" ValidationGroup="<%# Container.DataItemIndex %>" />
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
                        <asp:BoundField DataField="ProductId" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                        <asp:BoundField DataField="Name" HeaderText="الاسم" ReadOnly="true" />
                        <asp:BoundField DataField="Quantity" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly remainingQuantity" />
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
                                <asp:Label runat="server" ID="lblProductId" CssClass="NoDispaly" Text='<%# Bind("ProductId") %>'></asp:Label>
                                <asp:Label runat="server" ID="lblPrice" CssClass="price" Text='<%# Bind("SpecifiedPrice") %>'></asp:Label>
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
                                    <img src="Images/Error.png" width="15" height="15" />
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
                    </tr>
                </table>
            </footer>
        </section>
        <br />
        <footer class="AddSupplierFooter">
            <asp:Button ID="btnConfirm" runat="server" Text="انهاء" CssClass="BtnNext" OnClick="btnConfirm_Click" />
            <div class="MsgDiv">
                <asp:Label ID="lblConfirmMsg" runat="server" CssClass="MessageLabel"></asp:Label>
            </div>
        </footer>
    </asp:Panel>
</asp:Content>
