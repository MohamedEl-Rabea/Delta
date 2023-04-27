<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="AddProduct.aspx.cs" Inherits="DeltaProject.AddProduct" %>
<%@ Import Namespace="DeltaProject.Business_Logic" %>
<%@ Import Namespace="Newtonsoft.Json" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(function () {
            $('#<%= txtSupplierName.ClientID%>').autocomplete({
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
            $('#<%= txtProductName.ClientID%>').autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: "Services/GetProductsNames.asmx/GetProductNames",
                        data: "{ 'name': '" + request.term + "' }",
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
                    <asp:TextBox runat="server" ID="txtSupplierName" CssClass="txts3" PlaceHolder="اسم المورد" AutoCompleteType="Disabled"></asp:TextBox>
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
                        ControlToValidate="txtSupplierName" Display="Dynamic" SetFocusOnError="true"
                        ToolTip="اسم المورد متطلب اساسى"
                        ValidationGroup="SupplierTabNext">
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
                        ValidationGroup="SupplierTabNext">
                            <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                </td>
            </tr>
        </table>
        <footer class="AddSupplierFooter">
            <asp:Button ID="btnNext" runat="server" Text="التالى" CssClass="BtnNext" OnClick="btnNext_Click" ValidationGroup="SupplierTabNext" />
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
                        ToolTip="اسم المنتج متطلب اساسى">
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
                        ToolTip="التصنيف متطلب اساسى">
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
                            ToolTip="ماركة المنتج متطلب اساسى">
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
                                                    ToolTip="الطراز متطلب اساسى">
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
                        ToolTip="سعر الشراء متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                    <asp:CustomValidator ID="CustomValidator3" runat="server"
                        ToolTip="يجب كتابة سعر الشراء بشكل صحيح"
                        ControlToValidate="txtPurchasePrice"
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
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                        ControlToValidate="txtSellPrice" Display="Dynamic" SetFocusOnError="true"
                        ToolTip="سعر البيع متطلب اساسى">
                            <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                    <asp:CustomValidator ID="CustomValidator2" runat="server"
                        ControlToValidate="txtSellPrice"
                        Display="Dynamic"
                        SetFocusOnError="true"
                        ToolTip="يجب كتابة السعر بشكل صحيح"
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
                    <asp:TextBox runat="server" ID="txtAmount" CssClass="txts3" PlaceHolder="الكمية" AutoCompleteType="Disabled"></asp:TextBox>
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
                        ControlToValidate="txtAmount" Display="Dynamic" SetFocusOnError="true"
                        ToolTip="الكميه متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                    </asp:RequiredFieldValidator>
                    <asp:CustomValidator ID="CustomValidator5" runat="server"
                        ToolTip="يجب كتابة الكميه بشكل صحيح"
                        ControlToValidate="txtAmount"
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
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server"
                        ControlToValidate="ddlUnits" Display="Dynamic" SetFocusOnError="true"
                        ToolTip="اسم الوحدة متطلب اساسى">
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
                UseSubmitBehavior="false"/>
        </footer>
    </asp:Panel>
</asp:Content>
