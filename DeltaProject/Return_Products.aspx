<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Return_Products.aspx.cs" Inherits="DeltaProject.Return_Products" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="Script/ValidationScript.js"></script>
    <script type="text/javascript" src="Script/ServiseHandler.js"></script>
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
    <link href="CSS/jquery-ui-1.10.4.custom.min.css" rel="stylesheet" />
    <script type="text/javascript" src="Script/jquery-2.1.4.js"></script>
    <script src="Script/jquery-1.10.2.js"></script>
    <script src="Script/jquery-ui-1.10.4.custom.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#<%= txtP_Name.ClientID%>').autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: "Services/GetProductsNames.asmx/Get_Products_Names_Form_Bills",
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
            $('#<%= txtClient.ClientID%>').autocomplete({
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
    <asp:Panel runat="server" ID="PanelSearchClient">
        <header class="Header">
            <p>مرتجع فواتير</p>
        </header>
        <asp:RadioButtonList ID="RadioButtonListCategories" runat="server" RepeatDirection="Horizontal" CssClass="RBLCategories2"
            OnSelectedIndexChanged="RadioButtonListCategories_SelectedIndexChanged" AutoPostBack="true">
            <asp:ListItem Value="Normal" Selected="True">اسم العميل</asp:ListItem>
            <asp:ListItem Value="Motors">رقم الفاتورة</asp:ListItem>
        </asp:RadioButtonList>
        <section class="Search_Section">
            <table class="Search_table">
                <tr>
                    <td class="Image_td">
                        <asp:ImageButton ID="ImageButtonSearch" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                            Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearch_Click" />
                    </td>
                    <td class="Search_td">
                        <asp:TextBox ID="txtClient" runat="server" AutoCompleteType="Disabled" CssClass="Search_TextBox"
                            placeholder="اسم العميل للبحث . . . . ."></asp:TextBox>
                        <asp:TextBox ID="txtBill_ID" runat="server" AutoCompleteType="Disabled" Visible="false" CssClass="Search_TextBox"
                            placeholder="رقم الفاتورة للبحث . . . . ."></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td style="text-align: center">
                        <asp:CompareValidator ID="CompareValidator1" runat="server"
                            ControlToValidate="txtBill_ID"
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
    <asp:Panel runat="server" ID="PanelBills" Visible="false">
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkBtnPaidBills" runat="server" CssClass="TabLnks"
                    ToolTip="عرض كافة الفواتير التى تم دفعها الخاصه بهذا العميل" OnClick="lnkBtnPaidBills_Click">الفواتير المدفوعه</asp:LinkButton>
            </div>
        </header>
        <header class="PreSectionTab">
            <div>
                <asp:LinkButton ID="lnkBtnUnpaidBills" runat="server" CssClass="TabLnks"
                    ToolTip="عرض كافة الفواتير التى لم يتم دفعها الخاصه بهذا العميل" OnClick="lnkBtnUnpaidBills_Click">الفواتير الغير مدفوعه</asp:LinkButton>
            </div>
        </header>
        <asp:Panel runat="server" ID="PanelPaidBills" CssClass="PreReport_SectionTab" Visible="false">
            <asp:GridView ID="GridViewPaidBills" runat="server" AutoGenerateColumns="False" OnRowCommand="GridViewPaidBills_RowCommand"
                CssClass="Gridview_Style2" EmptyDataText="لا توجد فواتير مدفوعه لهذا العميل"
                DataSourceID="ObjectDataSourcePaidClientBills" AllowPaging="True">
                <Columns>
                    <asp:BoundField DataField="Bill_Date" HeaderText="تاريخ الفاتورة" SortExpression="Bill_Date" DataFormatString="{0:d}" />
                    <asp:BoundField DataField="Client_Name" HeaderText="اسم العميل" SortExpression="Client_Name" />
                    <asp:TemplateField HeaderText="رقم الفاتورة" SortExpression="Bill_ID">
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButtonBill_ID" runat="server" Text='<%# Bind("Bill_ID") %>' ToolTip="الانتقال الى كامل بيانات الفاتورة" CommandName="Select_Bill"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <RowStyle CssClass="Row_Style" />
                <PagerStyle CssClass="PagerStyle" HorizontalAlign="Center" />
                <EmptyDataRowStyle CssClass="Empty_Style" />
            </asp:GridView>
            <asp:ObjectDataSource ID="ObjectDataSourcePaidClientBills" runat="server"
                SelectMethod="Get_All_client_Paid_Bills"
                TypeName="Business_Logic.Bill"
                StartRowIndexParameterName="Start_Index"
                MaximumRowsParameterName="Max_Rows"
                SelectCountMethod="Get_Paid_Count_By_C_Name"
                EnablePaging="True">
                <SelectParameters>
                    <asp:ControlParameter ControlID="txtClient" Name="Client_Name" PropertyName="Text" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </asp:Panel>
        <asp:Panel runat="server" ID="PanelUnPaidBills" CssClass="PreReport_SectionTab" Visible="false">
            <asp:GridView ID="GridViewUnPaidBills" runat="server" AutoGenerateColumns="False" OnRowCommand="GridViewPaidBills_RowCommand"
                CssClass="Gridview_Style2" EmptyDataText="لا توجد فواتير غير مدفوعه لهذا العميل"
                DataSourceID="ObjectDataSourceUnPaidClientBills" AllowPaging="True">
                <Columns>
                    <asp:BoundField DataField="Bill_Date" HeaderText="تاريخ الفاتورة" SortExpression="Bill_Date" DataFormatString="{0:d}" />
                    <asp:BoundField DataField="Client_Name" HeaderText="اسم العميل" SortExpression="Client_Name" />
                    <asp:TemplateField HeaderText="رقم الفاتورة" SortExpression="Bill_ID">
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButtonBill_ID" runat="server" Text='<%# Bind("Bill_ID") %>' ToolTip="الانتقال الى كامل بيانات الفاتورة" CommandName="Select_Bill"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <RowStyle CssClass="Row_Style" />
                <PagerStyle CssClass="PagerStyle" HorizontalAlign="Center" />
                <EmptyDataRowStyle CssClass="Empty_Style" />
            </asp:GridView>
            <asp:ObjectDataSource ID="ObjectDataSourceUnPaidClientBills" runat="server"
                SelectMethod="Get_All_Client_Unpaid_Bills"
                TypeName="Business_Logic.Bill"
                StartRowIndexParameterName="Start_Index"
                MaximumRowsParameterName="Max_Rows"
                SelectCountMethod="Get_UnPaid_Count_By_C_Name"
                EnablePaging="True">
                <SelectParameters>
                    <asp:ControlParameter ControlID="txtClient" Name="Client_Name" PropertyName="Text" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </asp:Panel>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelBill" Visible="false">
        <section class="ContactsSection" style="border-radius: 8px; width: 99%; text-align: right; direction: rtl; padding: 10px;">
            <header class="Prices_Offer_SubHeaderBill" style="margin-bottom: 10px;">
                <div style="border: 1px solid black">
                    <p style="font: bold 13px arial; margin: 0; padding: 0">بيانات الفاتورة</p>
                </div>
            </header>
            <table class="AddProductsTable">
                <tr>
                    <td>
                        <asp:Label ID="Label1" runat="server" Text="تاريخ الفاتورة : " CssClass="lblInfo"></asp:Label>
                    </td>
                    <td style="width: 125px">
                        <asp:Label ID="lblBillDate" runat="server" CssClass="lblInfo2"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="Label2" runat="server" Text="رقم الفاتورة : " CssClass="lblInfo"></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblBill_ID" runat="server" CssClass="lblInfo2"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="Label3" runat="server" Text="العميل : " CssClass="lblInfo"></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblClientName" runat="server" CssClass="lblInfo2"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="Label4" runat="server" Text="العنوان : " CssClass="lblInfo"></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblAddress" runat="server" CssClass="lblInfo2"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <br />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label5" runat="server" CssClass="lblInfo" Text="تكلفة الفاتورة : "></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblBillCost" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="lblDiscount" runat="server" CssClass="lblInfo" Text="الخصم : "></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblDiscountValue" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="Label6" runat="server" CssClass="lblInfo" Text="المدفوع : "></asp:Label>
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
                        <asp:Label ID="lblAddtionalCost" runat="server" CssClass="lblInfo" Text="تكلفة اضافيه : "></asp:Label>
                    </td>
                    <td style="width: 120px">
                        <asp:Label ID="lblAdditionalCostValue" runat="server" CssClass="lblInfo2" Text="0.00"></asp:Label>
                    </td>
                    <td colspan="6">
                        <asp:Label ID="lblAdditionalcostNotes" runat="server" CssClass="lblInfo2" Text=" ملاحظات التكلفه الاضافيه"></asp:Label>
                    </td>
                </tr>
            </table>
        </section>
        <br />
        <br />
        <section class="ContactsSection" style="border-radius: 8px; width: 99%; text-align: right; direction: rtl; padding: 10px;">
            <header class="Prices_Offer_SubHeaderBill" style="margin-bottom: 10px;">
                <div style="border: 1px solid black">
                    <p style="font: bold 13px arial; margin: 0; padding: 0">محتويات الفاتورة</p>
                </div>
            </header>
            <asp:GridView runat="server" ID="GridViewBillList" CssClass="GridViewBill" AutoGenerateColumns="False" EmptyDataText="لا توجد منتجات">
                <Columns>
                    <asp:BoundField DataField="P_Name" HeaderText="اسم المنتـــــــــــج" />
                    <asp:BoundField DataField="amount" HeaderText="الكميه" />
                    <asp:BoundField DataField="Sell_Price" HeaderText="سعر الوحده" />
                </Columns>
                <HeaderStyle CssClass="HeaderStyleBill" />
                <RowStyle CssClass="RowStyleList" />
                <AlternatingRowStyle CssClass="AlternateRowStyleList" />
                <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
            </asp:GridView>
        </section>
        <br />
        <br />
        <section>
            <table class="AddProductsTable">
                <tr>
                    <td>
                        <p class="RHSP">اسم المنتــــج : </p>
                    </td>
                    <td>&nbsp;&nbsp;<asp:TextBox runat="server" ID="txtP_Name" CssClass="MidTexts" PlaceHolder="اسم المنتج للمرتجع" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                    <td>
                        <p class="RHSP">الكميه :</p>
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="txtReturnedAmount" CssClass="MidTexts" PlaceHolder="الكميه المعاده" AutoCompleteType="Disabled"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <br />
                        <br />
                    </td>
                    <td style="text-align: center">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                            ControlToValidate="txtP_Name" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="اسم المنتج مطلوب">
                        <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                    </td>
                    <td></td>
                    <td style="text-align: center">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                            ControlToValidate="txtReturnedAmount" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="الكميه متطلب اساسى">
                        <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:CompareValidator ID="CompareValidator2" runat="server"
                            ControlToValidate="txtReturnedAmount" Display="Dynamic" SetFocusOnError="true"
                            ToolTip="يجب كتابة الكميه بشكل صحيح"
                            Operator="DataTypeCheck" Type="Double">
                        <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CompareValidator>
                    </td>
                </tr>
            </table>
            <table class="AddProductsTable">
                <tr>
                    <td class="RHSTD">
                        <p class="RHSP">تاريخ المرتجع :</p>
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
                            ErrorMessage="يجب اضافة يوم المرتجع" ToolTip="يجب اضافة يوم المرتجع" ValidationGroup="AddProducts">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:RangeValidator ID="RangeValidatorDay" runat="server" ErrorMessage="RangeValidator" Display="Dynamic"
                            ControlToValidate="txtDay" Type="Integer" MinimumValue="1" MaximumValue="31" ToolTip="يجب اضافة اليوم بشكل صحيح مابين 1-31" ValidationGroup="AddProducts">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RangeValidator>
                    </td>
                    <td style="text-align: center">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorMonth" runat="server" ControlToValidate="txtMonth" Display="Dynamic" SetFocusOnError="true"
                            ErrorMessage="يجب اضافة شهر المرتجع" ToolTip="يجب اضافة شهر المرتجع" ValidationGroup="AddProducts">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:RangeValidator ID="RangeValidatorMonth" runat="server" ErrorMessage="RangeValidator" Display="Dynamic"
                            ControlToValidate="txtMonth" Type="Integer" MinimumValue="1" MaximumValue="12" ToolTip="يجب اضافة اليوم بشكل صحيح مابين 1-12" ValidationGroup="AddProducts">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RangeValidator>
                    </td>
                    <td style="text-align: center">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorYear" runat="server" ControlToValidate="txtYear" Display="Dynamic" SetFocusOnError="true"
                            ErrorMessage="يجب اضافة سنة المرتجع" ToolTip="يجب اضافة سنة المرتجع" ValidationGroup="AddProducts">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator1" runat="server"
                            ToolTip="يجب اضافة سنة المرتجع بشكل صحيح"
                            ControlToValidate="txtYear"
                            Display="Dynamic"
                            SetFocusOnError="true"
                            ClientValidationFunction="IsValidYear" ValidationGroup="AddProducts">
                    <img src="Images/Error.png" width="24" height="24"/>
                        </asp:CustomValidator>
                    </td>

                </tr>
            </table>
            <footer class="AddSupplierFooter">
                <asp:Button ID="BtnFinish" runat="server" Text="انهاء" CssClass="BtnNext"
                    UseSubmitBehavior="false"
                    OnClientClick="this.disabled='true';this.value='Please wait....';" OnClick="BtnFinish_Click" />
                <div class="MsgDiv">
                    <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
                </div>
            </footer>
            <asp:Panel runat="server" ID="PanelRest" Visible="false">
                <footer class="AddSupplierFooter">
                    <div style="direction: rtl">
                        <table class="AddProductsTable" style="text-align: right">
                            <tr>
                                <td>
                                    <b>المتبقى من قيمة المدفوع لفاتورة = </b>
                                </td>
                                <td>
                                    <asp:Label ID="lblRestOfMoney" runat="server"></asp:Label>
                                </td>
                                <td>
                                    <b>هل تم دفعها للعميل</b>
                                </td>
                                <td>
                                    <asp:RadioButtonList ID="RBLYesOrNo" RepeatDirection="Horizontal" runat="server">
                                        <asp:ListItem>نعم</asp:ListItem>
                                        <asp:ListItem>لا</asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <asp:Button ID="BtnConfirm" runat="server" Text="تأكيد" CssClass="BtnNext"
                        UseSubmitBehavior="false"
                        OnClientClick="this.disabled='true';this.value='Please wait....';" OnClick="BtnConfirm_Click" />
                    <div class="MsgDiv">
                        <asp:Label ID="lblConfirm" runat="server" CssClass="MessageLabel"></asp:Label>
                    </div>
                </footer>
            </asp:Panel>
            <div class="MsgDiv" style="text-align: right">
                <asp:LinkButton ID="lnkBtnAddProducts" runat="server" ValidationGroup="AddProducts" CssClass="UnStyled" OnClick="lnkBtnAddProducts_Click">
                    اذا كنت تريد اضافة منتجات جديده للفاتورة اضغط <span class="Link">هنا</span></asp:LinkButton>
            </div>
        </section>
    </asp:Panel>
    <asp:Panel runat="server" ID="PanelSale" Visible="false">
        <header class="Header">
            <p>عملية اضافه لفاتورة</p>
        </header>
        <asp:Panel runat="server" ID="PanelCustomerType">
            <asp:RadioButtonList ID="Custmer" runat="server" RepeatDirection="Horizontal" CssClass="RBLCategories"
                OnSelectedIndexChanged="Custmer_SelectedIndexChanged" AutoPostBack="true">
                <asp:ListItem Value="Special">بيع جمله</asp:ListItem>
                <asp:ListItem Value="Regular">بيع قطاعى</asp:ListItem>
            </asp:RadioButtonList>
        </asp:Panel>
        <asp:Panel runat="server" ID="PanelSearch" Visible="false">
            <asp:RadioButtonList ID="RBLProductType" runat="server" RepeatDirection="Horizontal" CssClass="RBLCategories"
                OnSelectedIndexChanged="RBLProductType_SelectedIndexChanged" AutoPostBack="true">
                <asp:ListItem Value="Normal" Selected="True">منتجات عاديه</asp:ListItem>
                <asp:ListItem Value="Tol">طلمبات</asp:ListItem>
                <asp:ListItem Value="Motors">مواتير</asp:ListItem>
            </asp:RadioButtonList>
            <section class="Search_Section">
                <table class="Search_table">
                    <tr>
                        <td class="Image_td">
                            <asp:ImageButton ID="ImageButtonSearchProducts" runat="server" ImageUrl="~/Images/common_search_lookup.png"
                                Width="24" Height="24" CssClass="Search_Button" CausesValidation="false" OnClick="ImageButtonSearchProducts_Click" />
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
            <asp:Panel runat="server" ID="PanelInitailResult" CssClass="PanelProductList" Visible="false">
                <asp:GridView ID="GridViewProducts" runat="server" AutoGenerateColumns="false"
                    CssClass="GridViewList" EmptyDataText="لا توجد منتجات">
                    <Columns>
                        <asp:BoundField DataField="P_Name" HeaderText="الاسم" />
                        <asp:BoundField DataField="Mark" HeaderText="الماركه" />
                        <asp:BoundField DataField="Inch" HeaderText="البوصه" />
                        <asp:BoundField DataField="Style" HeaderText="الطراز" />
                        <asp:BoundField DataField="Special_Price" HeaderText="سعر البيع" />
                        <asp:BoundField DataField="Regulare_Price" HeaderText="سعر البيع" />
                        <asp:BoundField DataField="Purchase_Price" HeaderText="سعر الشراء" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                        <asp:BoundField DataField="Amount" HeaderText="الكميه المتاحه" />
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
                        <asp:TemplateField HeaderText="السعر">
                            <ItemTemplate>
                                <asp:TextBox ID="txtPrice" CssClass="EditTxt" runat="server" AutoCompleteType="Disabled" placeholder="السعر"></asp:TextBox>
                                <asp:CustomValidator ID="CustomValidator10" runat="server"
                                    ToolTip="يجب كتابة السعر بشكل صحيح"
                                    ControlToValidate="txtPrice"
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
                        <asp:Button ID="BtnDoneAdding" runat="server" Text="تم" CssClass="BtnNext" OnClick="BtnDoneAdding_Click" />
                        <div class="MsgDiv">
                            <asp:Label ID="lblAddedMsg" runat="server" CssClass="MessageLabel"></asp:Label>
                        </div>
                    </footer>
                </asp:Panel>
            </asp:Panel>
        </asp:Panel>
        <asp:Panel runat="server" ID="PanelProductList" Visible="false">
            <section>
                <header class="ListHeader">
                    <p>قائمة المنتجـــــات</p>
                </header>
                <br />
                <asp:Panel ID="PanelList" runat="server" CssClass="PanelProductList">
                    <asp:GridView runat="server" ID="GridViewProductsList" CssClass="GridViewList" AutoGenerateColumns="False" EmptyDataText="لا توجد منتجات"
                        OnRowDataBound="GridViewProductsList_RowDataBound" OnRowCommand="GridViewProductsList_RowCommand">
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
                                        ToolTip="تاكيد التعديل" CausesValidation="false" CommandName="Confirm_Update" />
                                </EditItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="P_Name" HeaderText="الاسم" ReadOnly="true" />
                            <asp:BoundField DataField="Mark" HeaderText="الماركه" ReadOnly="true" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                            <asp:BoundField DataField="Inch" HeaderText="البوصه" ReadOnly="true" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                            <asp:BoundField DataField="Style" HeaderText="الطراز" ReadOnly="true" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                            <asp:BoundField DataField="Purchase_Price" HeaderText="سعر الشراء" ReadOnly="true" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                            <asp:TemplateField HeaderText="الكميه المطلوبة">
                                <ItemTemplate>
                                    <asp:Label runat="server" ID="lblAmount" Text='<%# Bind("Amount") %>'></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtAmount" CssClass="EditTxt" runat="server" AutoCompleteType="Disabled" Text='<%# Bind("Amount") %>' placeholder="الكميه"></asp:TextBox>
                                    <asp:CustomValidator ID="CustomValidator9" runat="server"
                                        ToolTip="يجب كتابة الكميه بشكل صحيح"
                                        ControlToValidate="txtAmount"
                                        Display="Dynamic"
                                        SetFocusOnError="true"
                                        ForeColor="Red"
                                        Text="*"
                                        ClientValidationFunction="IsValidNumber">
                                    </asp:CustomValidator>
                                </EditItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="السعر">
                                <ItemTemplate>
                                    <asp:Label runat="server" ID="lblPrice" Text='<%# Bind("Regulare_Price") %>'></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtPrice" CssClass="EditTxt" runat="server" Text='<%# Bind("Regulare_Price") %>'
                                        AutoCompleteType="Disabled" placeholder="السعر"></asp:TextBox>
                                    <asp:CustomValidator ID="CustomValidator10" runat="server"
                                        ToolTip="يجب كتابة السعر بشكل صحيح"
                                        ControlToValidate="txtPrice"
                                        Display="Dynamic"
                                        SetFocusOnError="true"
                                        ForeColor="Red"
                                        Text="*"
                                        ClientValidationFunction="IsValidNumber">
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
                <br />
                <footer class="AddSupplierFooter">
                    <asp:Button ID="BtnAddToBill" runat="server" Text="انهاء" CssClass="BtnNext" OnClick="BtnAddToBill_Click" />
                    <div class="MsgDiv">
                        <asp:Label ID="lblConfirmMsg" runat="server" CssClass="MessageLabel"></asp:Label>
                    </div>
                </footer>
            </section>
        </asp:Panel>
    </asp:Panel>
</asp:Content>
