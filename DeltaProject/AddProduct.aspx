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

        function AddClassificationElements(attributes) {
            $('#divClassificationAttributes').html('');
            var html = '<table class="AddProductsTable">';
            for (let i = 0; i < attributes.length; i = i + 2) {
                html += `<tr><td class="RHSTD"><p class="RHSP">${attributes[i].AttrName.trim()} :</p></td >`;
                html +=
                    `<td id="tdClassification" style="text-align: right"><input ID ="txtAttrName{${i}}" type="${attributes[i].Type}" class = "txts3" 
                     style="margin-right: 5px;" PlaceHolder = "${attributes[i].AttrName.trim()}" AutoCompleteType = "Disabled"/></td>`;

                if (i + 1 < attributes.length) {
                    html += `<td class="RHSTD"><p class="RHSP">${attributes[i + 1].AttrName} :</p></td >`;
                    html +=
                        `<td id="tdClassification" style="text-align: right"><input ID ="txtAttrName{${i + 1}}" type="${attributes[i + 1].Type}" class = "txts3"
                         PlaceHolder = "${attributes[i + 1].AttrName}" AutoCompleteType = "Disabled"/></td>`;
                } else {
                    html += '<td></td><td></td>';
                }

                html += '</tr><tr><td class="RHSTD"><br /><br /></td>';

                if (attributes[i].Optional) {
                    html+= `<td style="text-align: center"><span hidden="hidden" ID ="valAttrName{${i}}" title="${attributes[i].AttrName.trim()} متطلب اساسى">
                         <img src="Images/Error.png" width="24" height="24"></span></td>`;
                } else {
                    html += '<td><br /><br /></td>';
                }
               
                if (i + 1 < attributes.length && attributes[i + 1].Optional) {
                    html += `<td class="RHSTD"><br /><br /></td>
                             <td style="text-align: center"><span hidden="hidden" ID ="valAttrName{${i + 1}}" title="${attributes[i + 1].AttrName.trim()} متطلب اساسى">
                             <img src="Images/Error.png" width="24" height="24"></span></td>`;
                } else {
                    html += '<td class="RHSTD"><br /><br /></td><td><br /><br /></td>';
                }

                html += '</tr>';
            }
            html += '</table>';
            $('#divClassificationAttributes').html(html);
        }


        function CheckValidation() {
            var classificationInputs = $('input[id^="txtAttrName"]');

            for (var i = 0; i < classificationInputs.length; i++) {
                var id = classificationInputs[i].id;
                id = id.replace("txt", "val");
                var valElement = document.getElementById(id);
                if (classificationInputs[i].value === "") {
                    $(valElement).show();
                } else {
                    $(valElement).hide();
                }
            }
        }
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
                        AutoPostBack="true"
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
            
            <tr>
                <td colspan="4">
                    <asp:Panel runat="server" ID="PanelClassificationAttributes" Visible="True">
                        <div id="divClassificationAttributes">

                        </div>
                    </asp:Panel>
                </td>
            </tr>

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
                UseSubmitBehavior="false" OnClientClick="CheckValidation()"/>
        </footer>
    </asp:Panel>
</asp:Content>
