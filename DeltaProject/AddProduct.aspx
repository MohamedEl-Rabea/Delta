<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AddProduct.aspx.cs" Inherits="DeltaProject.AddProduct" %>
<%@ Import Namespace="DeltaProject.Business_Logic" %>
<%@ Import Namespace="Newtonsoft.Json" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(function() {
            $('#<%= ddlSuppliers.ClientID%>').select2();
            $('#<%= ddlClassifications.ClientID%>').select2();
            $('#<%= ddlUnits.ClientID%>').select2();
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

        $(function () {
            var options = $.extend(
                {},
                $.datepicker.regional["ar"],
                {
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'dd/mm/yy',
                }
            );
            $('#<%= txtPurchaseDate.ClientID%>').datepicker(options);
            $('#<%= txtPurchaseDate.ClientID%>').datepicker("setDate", new Date());
        });
    </script>
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>اضافة منتجـات</p>
    </header>

    <asp:Panel runat="server" ID="PanelAddSupplier">
        <table class="AddProductsTable">
            <tr>
                <td class="RHSTD">
                    <p class="RHSP">اسم المورد :</p>
                </td>
                <td style="text-align: right">
                    <asp:DropDownList ID="ddlSuppliers" runat="server" CssClass="txts3"
                                      Style="height: auto"
                                      DataTextField="Name"
                                      DataValueField="Id"
                                      AutoPostBack="True">
                    </asp:DropDownList>
                </td>
                <td class="RHSTD">
                    <p class="RHSP">تاريخ الشراء :</p>
                </td>
                <td style="text-align: right">
                    <asp:TextBox runat="server" ID="txtPurchaseDate" CssClass="txts3" PlaceHolder="تاريخ الشراء"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
                <td class="ValodationTD">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                        ControlToValidate="ddlSuppliers" Display="Dynamic" SetFocusOnError="true"
                        ToolTip="اسم المورد متطلب اساسى"
                        ValidationGroup="SupplierTabGroup">
                            <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                </td>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
                <td class="ValodationTD">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                        ControlToValidate="txtPurchaseDate" Display="Dynamic" SetFocusOnError="true"
                        ToolTip="تاريخ الشراء متطلب اساسى"
                        ValidationGroup="SupplierTabGroup">
                            <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                </td>
            </tr>
        </table>
        <footer class="AddSupplierFooter">
            <asp:Button ID="btnNext" runat="server" Text="التالى" CssClass="BtnNext" OnClick="btnNext_Click" ValidationGroup="SupplierTabGroup" />
        </footer>
    </asp:Panel>

    <asp:Panel runat="server" ID="PanelAddProducts" Visible="false">
        <header style="text-align: left">
            <asp:ImageButton ID="btnBackToAddSupplier" runat="server" ImageUrl="~/Images/back.png" Width="24" Height="24"
                ToolTip="رجوع" OnClick="btnBackToAddSupplier_Click" CausesValidation="false" />
        </header>
        <br />
        <table class="AddProductsTable">
            <tr>
                <td class="RHSTD">
                    <p class="RHSP">اسم المنتج :</p>
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtProductId" CssClass="txts3 NoDispaly"></asp:TextBox>
                    <asp:TextBox runat="server" ID="txtProductName" CssClass="txts3" PlaceHolder="اسم المنتج" AutoCompleteType="Disabled"
                                 OnTextChanged="txtProductName_OnTextChanged" AutoPostBack="true" ></asp:TextBox>
                </td>
                <td class="RHSTD">
                    <p class="RHSP">التصنيف :</p>
                </td>
                <td style="text-align: right">
                    <asp:DropDownList ID="ddlClassifications" runat="server" CssClass="txts3"
                        Style="width: 100%; height: auto"
                        DataTextField="Name"
                        DataValueField="Id"
                        AutoPostBack="True"
                        OnSelectedIndexChanged="ddlClassifications_OnSelectedIndexChanged">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
                <td style="text-align: center">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                        ControlToValidate="txtProductName" Display="Dynamic" SetFocusOnError="true"
                        ValidationGroup="ProductTabGroup" ToolTip="اسم المنتج متطلب اساسى" >
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                </td>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
                <td style="text-align: center">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server"
                        ControlToValidate="ddlClassifications" Display="Dynamic" SetFocusOnError="true"
                        ValidationGroup="ProductTabGroup" ToolTip="التصنيف متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                </td>
            </tr>
            <asp:Panel runat="server" ID="PanelClassificationMotors" Visible="False">
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">الماركه :</p>
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="txtMark" CssClass="txts3" PlaceHolder="الماركه" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                    <td class="RHSTD">
                        <p class="RHSP">البوصه :</p>
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="txtInch" CssClass="txts3" PlaceHolder="البوصه" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td style="text-align: center">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server"
                            ControlToValidate="txtMark" Display="Dynamic" SetFocusOnError="true"
                            ValidationGroup="ProductTabGroup" ToolTip="ماركة المنتج متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td style="text-align: center">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server"
                            ControlToValidate="txtInch" Display="Dynamic" SetFocusOnError="true"
                            ValidationGroup="ProductTabGroup" ToolTip="البوصه متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator10" runat="server"
                            ToolTip="يجب كتابة البوصه بشكل صحيح"
                            ControlToValidate="txtInch"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ClientValidationFunction="IsValidNumber" 
                            ValidationGroup="ProductTabGroup" >
                        <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                    </td>
                </tr>
            </asp:Panel>
            <asp:Panel runat="server" ID="PanelClassificationPumps" Visible="False">
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">الطراز :</p>
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="txtStyle" CssClass="txts3" PlaceHolder="الطراز" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="RHSTD">
                        <br />
                        <br />
                    </td>
                    <td style="text-align: center">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server"
                                                    ControlToValidate="txtStyle" Display="Dynamic" SetFocusOnError="true"
                                                    ValidationGroup="ProductTabGroup" ToolTip="الطراز متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>
                </tr>
            </asp:Panel>

            <tr>
                <td class="RHSTD">
                    <p class="RHSP">سعر الشـراء :</p>
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtPurchasePrice" CssClass="txts3" PlaceHolder="سعر الشـراء" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
                <td class="RHSTD">
                    <p class="RHSP">سعر البيع :</p>
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtSellPrice" CssClass="txts3" PlaceHolder="سعر البيع" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
                <td style="text-align: center">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                        ControlToValidate="txtPurchasePrice" Display="Dynamic" SetFocusOnError="true"
                        ToolTip="سعر الشراء متطلب اساسى" ValidationGroup="ProductTabGroup" >
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                    <asp:CustomValidator ID="CustomValidator3" runat="server"
                        ToolTip="يجب كتابة سعر الشراء بشكل صحيح"
                        ControlToValidate="txtPurchasePrice"
                        Display="Dynamic"
                        SetFocusOnError="true"
                        ValidationGroup="ProductTabGroup" 
                        ClientValidationFunction="IsValidNumber">
                    <img src="Images/Error.png" width="24" height="24"/>
                    </asp:CustomValidator>
                </td>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
                <td style="text-align: center">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                        ControlToValidate="txtSellPrice" Display="Dynamic" SetFocusOnError="true"
                        ValidationGroup="ProductTabGroup" ToolTip="سعر البيع متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                    <asp:CustomValidator ID="CustomValidator2" runat="server"
                        ControlToValidate="txtSellPrice"
                        Display="Dynamic"
                        SetFocusOnError="true"
                        ValidationGroup="ProductTabGroup" ToolTip="يجب كتابة السعر بشكل صحيح"
                        ClientValidationFunction="IsValidNumber">
                            <img src="Images/Error.png" width="24" height="24"/>
                    </asp:CustomValidator>
                </td>
            </tr>

            <tr>
                <td class="RHSTD">
                    <p class="RHSP">الكمية :</p>
                </td>
                <td>
                    <asp:TextBox runat="server" ID="txtQuantity" CssClass="txts3" PlaceHolder="الكمية" AutoCompleteType="Disabled"></asp:TextBox>
                </td>
                <td class="RHSTD">
                    <p class="RHSP">اسم الوحدة :</p>
                </td>
                <td style="text-align: right">
                    <asp:DropDownList ID="ddlUnits" runat="server" CssClass="txts3"
                        Style="width: 100%; height: auto"
                        DataTextField="Name"
                        DataValueField="Id">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
                <td style="text-align: center">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server"
                        ControlToValidate="txtQuantity" Display="Dynamic" SetFocusOnError="true"
                        ValidationGroup="ProductTabGroup" ToolTip="الكميه متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                    <asp:CustomValidator ID="CustomValidator5" runat="server"
                        ToolTip="يجب كتابة الكميه بشكل صحيح"
                        ControlToValidate="txtQuantity"
                        Display="Dynamic"
                        SetFocusOnError="true"
                        ValidationGroup="ProductTabGroup" 
                        ClientValidationFunction="IsValidNumber">
                    <img src="Images/Error.png" width="24" height="24"/>
                    </asp:CustomValidator>
                </td>
                <td class="RHSTD">
                    <br />
                    <br />
                </td>
                <td style="text-align: center">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server"
                        ControlToValidate="ddlUnits" Display="Dynamic" SetFocusOnError="true"
                        ValidationGroup="ProductTabGroup" ToolTip="اسم الوحدة متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                </td>
            </tr>

            <tr>
                <td class="RHSTD" style="vertical-align: top">
                    <p class="RHSP">الوصـف :</p>
                </td>
                <td colspan="3">
                    <asp:TextBox ID="txtDescription" runat="server" CssClass="TxtMultiline" AutoCompleteType="Disabled"
                        Width="98%" TextMode="MultiLine" placeholder="اضف وصفا للمنتج ....."></asp:TextBox>
                </td>
            </tr>
        </table>
        <br />
        <footer class="AddSupplierFooter">
            <div class="MsgDiv">
                <asp:Label ID="lblMsg" runat="server" CssClass="MessageLabel"></asp:Label>
            </div>
            <asp:Button ID="BtnNextToProductsList" runat="server" Text="التالى" CssClass="BtnNext"
                UseSubmitBehavior="false" OnClick="btnNextToProductsList_Click" ToolTip="الانتقال الى القائمة" />
            <asp:Button ID="btnAddProduct" runat="server" Text="اضافه" CssClass="BtnAdd" OnClick="btnAddProduct_Click" ToolTip="اضف الى القائمة"
                UseSubmitBehavior="false" ValidationGroup="ProductTabGroup" />
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
                <p>قائمة المنتجات</p>
            </header>
            <br />
            <asp:Panel runat="server" CssClass="PanelProductList">
                <asp:GridView runat="server" ID="GridViewProductsList" CssClass="GridViewList" AutoGenerateColumns="False" 
                              EmptyDataText="لا توجد منتجات" 
                              OnRowCommand="GridViewProductsList_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="Id" SortExpression="Id" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                        <asp:BoundField DataField="ClassificationId" SortExpression="ClassificationId" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                        <asp:BoundField DataField="Mark" SortExpression="Mark" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                        <asp:BoundField DataField="Inch" SortExpression="Inch" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                        <asp:BoundField DataField="Style" SortExpression="Style" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                        <asp:BoundField DataField="UnitId" SortExpression="UnitId" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                        <asp:BoundField DataField="Description" SortExpression="Description" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                       
                        <asp:BoundField DataField="Name" HeaderText="اسم المنتج" SortExpression="Name" />
                        <asp:BoundField DataField="ClassificationName" HeaderText="التصنيف" SortExpression="ClassificationName" />
                        <asp:BoundField DataField="PurchasePrice" HeaderText="سعر الشراء" SortExpression="PurchasePrice" DataFormatString="{0:0.##}"/>
                        <asp:BoundField DataField="SellPrice" HeaderText="سعر البيع" SortExpression="SellPrice" DataFormatString="{0:0.##}"/>
                        <asp:BoundField DataField="Quantity" HeaderText="الكميه" SortExpression="Quantity" DataFormatString="{0:0.##}"/>
                        <asp:BoundField DataField="UnitName" HeaderText="الوحدة" SortExpression="UnitName" />
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:ImageButton ID="ImageButtonDelete" runat="server" ImageUrl="~/Images/Delete.png" Width="16" Height="16"
                                                 CausesValidation="false" CommandName="Delete_Row"
                                                 OnClientClick="return confirm('سيتم مسح هذا المنتج . . . هل تريد المتابعه ؟');" />
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
                <table class="InfoTable">
                    <tr>
                        <td class="RHSTD">
                            <p class="RHSP">المورد :</p>
                        </td>
                        <td>
                            <asp:Label ID="lblSupplierName" runat="server" CssClass="Infolbl" Text="غير معروف"></asp:Label>
                        </td>
                        <td class="RHSTD">
                            <p class="RHSP">تاريخ الشراء :</p>
                        </td>
                        <td style="direction: rtl">
                            <asp:Label ID="lblPurchaseDate" runat="server" CssClass="Infolbl" ></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td class="RHSTD">
                            <p class="RHSP">التكلفه :</p>
                        </td>
                        <td>
                            <asp:Label ID="lblTotalCost" runat="server" CssClass="Infolbl"></asp:Label>
                        </td>
                        <td class="RHSTD">
                            <p class="RHSP">المدفوع :</p>
                        </td>
                        <td>
                            <asp:TextBox runat="server" ID="txtPaidAmount" CssClass="Smalltxts" PlaceHolder="المدفوع" AutoCompleteType="Disabled"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <br />
                            <br />
                        </td>
                        <td style="padding-right: 80px;">
                            <asp:CustomValidator ID="CustomValidatorPaidAmount" runat="server"
                                ToolTip="يجب كتابة القيمة المدفوعه بشكل صحيح"
                                ControlToValidate="txtPaidAmount"
                                Display="Dynamic"
                                SetFocusOnError="true"
                                ForeColor="Red"
                                ValidateEmptyText="true"
                                ClientValidationFunction="IsValidNumber"
                                ValidationGroup="SaveGroup">
                                <img src="Images/Error.png" width="24" height="24"/>
                            </asp:CustomValidator>
                        </td>
                    </tr>
                </table>
            </footer>
        </section>
        <br />
        <footer class="AddSupplierFooter">
            <asp:Button ID="btnSave" runat="server" Text="حفظ" CssClass="BtnNext" OnClick="btnSave_Click"
                UseSubmitBehavior="false"
                OnClientClick="this.disabled='true';this.value='Please wait....';" ValidationGroup="SaveGroup" />
        </footer>
    </asp:Panel>
    <footer class="AddSupplierFooter">
        <div class="MsgDiv">
            <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
        </div>
    </footer>
</asp:Content>
