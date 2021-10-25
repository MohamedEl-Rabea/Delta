<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Manage_Permissions.aspx.cs" Inherits="DeltaProject.Manage_Permissions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
    <style>
        .permissions-table {
        }

        .permission-title {
            background-color: #F2F2F2;
            vertical-align: central;
            height: 40px;
        }

        .permissions_section_header {
        }

        .permissions-table label {
            margin-right: 10px;
            margin-left: 10px;
        }

        .permissions-td {
            text-align: right;
            direction: rtl;
            height: 60px;
        }

            .permissions-td label {
                cursor: pointer;
            }

            .permissions-td input {
                cursor: pointer;
            }

        .spacing-td {
            height: 30px;
        }

        .ddl-users {
            direction: rtl;
            width: 50%;
            padding: 10px;
            border: 1px solid black;
            border-radius: 5px 5px;
            font: bold 13px arial;
            color: #2c3e50;
        }

            .ddl-users option {
                font: bold 13px arial;
            }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>إدارة الصلاحيات</p>
    </header>
    <section>
        <asp:Panel ID="pnlAllPermissions" runat="server">
            <table class="permissions-table" border="0">
                <tr>
                    <td colspan="2">
                        <asp:DropDownList ID="ddlUsers" runat="server" CssClass="ddl-users"
                            OnSelectedIndexChanged="ddlUsers_SelectedIndexChanged" AutoPostBack="true">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="spacing-td"></td>
                </tr>
                <tr class="permission-title">
                    <td colspan="2" class="permissions_section_header"><strong><u>إدارة المخازن</u></strong></td>
                </tr>
                <tr>
                    <td class="permissions-td">
                        <asp:CheckBox ID="chk_AddProducts" runat="server" Text="اضافة منتجات" />
                        <asp:CheckBox ID="chk_Update_Products_Amounts" runat="server" Text="تحديث كميات" />
                        <asp:CheckBox ID="chk_Update_Product_Info" runat="server" Text="تحديث كميات" />
                        <asp:CheckBox ID="chk_Delete_Products" runat="server" Text="مسح منتجات" />
                        <asp:CheckBox ID="chk_Search_For_Product" runat="server" Text="استعلام" />
                        <asp:CheckBox ID="chk_Products_Inventory" runat="server" Text="جرد البضائع" />
                        <asp:CheckBox ID="chk_Supplier_Returned_Products" runat="server" Text="مرتجع" />
                        <asp:CheckBox ID="chk_Collect_Product" runat="server" Text="تجميع منتج" />
                    </td>
                </tr>
                <tr class="permission-title">
                    <td colspan="2" class="permissions_section_header"><strong><u>إدارة الموردين</u></strong></td>
                </tr>
                <tr>
                    <td class="permissions-td">
                        <asp:CheckBox ID="chk_Add_Supplier" runat="server" Text="اضافة مورد" />
                        <asp:CheckBox ID="chk_Add_SupplierCheque" runat="server" Text="اضافة شيكات" />
                        <asp:CheckBox ID="chk_Update_Supplier_Info" runat="server" Text="تعديل بيانات" />
                        <asp:CheckBox ID="chk_New_Supplier_Interaction" runat="server" Text="سداد جديد" />
                        <asp:CheckBox ID="chk_Delete_Supplier" runat="server" Text="مسح" />
                        <asp:CheckBox ID="chk_Suppliers_Search" runat="server" Text="استعـــلام" />
                        <asp:CheckBox ID="chk_Supplier_Products" runat="server" Text="استعلام واردات" />
                    </td>
                </tr>
                <tr class="permission-title">
                    <td colspan="2" class="permissions_section_header"><strong><u>إدارة العملاء</u></strong></td>
                </tr>
                <tr>
                    <td class="permissions-td">
                        <asp:CheckBox ID="chk_Add_ClientCheque" runat="server" Text="اضافة شيكات" />
                        <asp:CheckBox ID="chk_Update_Client_Info" runat="server" Text="تعديل بيانات" />
                        <asp:CheckBox ID="chk_Delete_Client" runat="server" Text="مسح" />
                        <asp:CheckBox ID="chk_Search_For_Client" runat="server" Text="استعلام" />
                    </td>
                </tr>
                <tr class="permission-title">
                    <td colspan="2" class="permissions_section_header"><strong><u>إدارة المالية</u></strong></td>
                </tr>
                <tr>
                    <td class="permissions-td">
                        <asp:CheckBox ID="chk_Expenses" runat="server" Text="صرف" />
                        <asp:CheckBox ID="chk_Add_Income" runat="server" Text="اضافة دخل" />
                        <asp:CheckBox ID="chk_Income_Report" runat="server" Text="تقرير الدخل" />
                    </td>
                </tr>
                <tr class="permission-title">
                    <td colspan="2" class="permissions_section_header"><strong><u>إدارة المستخدمين</u></strong></td>
                </tr>
                <tr>
                    <td class="permissions-td">
                        <asp:CheckBox ID="chk_Accounts_Settings" runat="server" Text="إعدادت الحساب" />
                        <asp:CheckBox ID="chk_Manage_Permissions" runat="server" Text="ادارة الصلاحيات" />
                    </td>
                </tr>
                <tr class="permission-title">
                    <td colspan="2" class="permissions_section_header"><strong><u>البيع</u></strong></td>
                </tr>
                <tr>
                    <td class="permissions-td">
                        <asp:CheckBox ID="chk_Sale_Products" runat="server" Text="بيع عادى" />
                        <asp:CheckBox ID="chk_Return_Products" runat="server" Text="مرتجع" />
                        <asp:CheckBox ID="chk_Add_Items_To_Invoice" runat="server" Text="اضافة" />
                    </td>
                </tr>
                <tr class="permission-title">
                    <td colspan="2" class="permissions_section_header"><strong><u>عروض الاسعار</u></strong></td>
                </tr>
                <tr>
                    <td class="permissions-td">
                        <asp:CheckBox ID="chk_Special_Prices_List" runat="server" Text="عرض خاص" />
                        <asp:CheckBox ID="chk_Public_Prices_List" runat="server" Text="عرض عام" />
                    </td>
                </tr>
                <tr class="permission-title">
                    <td colspan="2" class="permissions_section_header"><strong><u>الشيكات</u></strong></td>
                </tr>
                <tr>
                    <td class="permissions-td">
                        <asp:CheckBox ID="chk_Search_For_ClientCheque" runat="server" Text="العملاء" />
                        <asp:CheckBox ID="chk_Search_For_SupplierCheque" runat="server" Text="الموردين" />
                    </td>
                </tr>
                <tr class="permission-title">
                    <td colspan="2" class="permissions_section_header"><strong><u>الفواتير</u></strong></td>
                </tr>
                <tr>
                    <td class="permissions-td">
                        <asp:CheckBox ID="chk_Pay_Bill" runat="server" Text="دفع" />
                        <asp:CheckBox ID="chk_Search_For_Bills" runat="server" Text="استعلام" />
                    </td>
                </tr>
                <tr class="permission-title">
                    <td colspan="2" class="permissions_section_header"><strong><u>التقارير</u></strong></td>
                </tr>
                <tr>
                    <td class="permissions-td">
                        <asp:CheckBox ID="chk_Needs_Report" runat="server" Text="تقرير احتياجات" />
                        <asp:CheckBox ID="chk_Sales_Report" runat="server" Text="تقرير المبيعات" />
                        <asp:CheckBox ID="chk_Suppliers_report" runat="server" Text="تقرير الموردين" />
                        <asp:CheckBox ID="chk_Clients_Report" runat="server" Text="عملاء الديون" />
                        <asp:CheckBox ID="chk_All_Clients_Report" runat="server" Text="كل العملاء" />
                        <asp:CheckBox ID="chk_Client_Statement" runat="server" Text="كشف الحساب" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </section>
    <footer class="AddSupplierFooter">
        <asp:Button ID="BtnUpdate" runat="server" Text="حفظ" CssClass="BtnNext" OnClick="BtnUpdate_Click" />
        <div class="MsgDiv">
            <asp:Label ID="lblFinishMsg" runat="server" CssClass="MessageLabel"></asp:Label>
        </div>
    </footer>
</asp:Content>
