<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Units.aspx.cs" Inherits="DeltaProject.Units" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .HeaderStyleList, .RowStyleList, .AlternateRowStyleList {
            font-size: 16px
        }

            .RowStyleList table {
                background-color: #f2f2f2;
            }

            .AlternateRowStyleList table {
                background-color: white;
            }

        .HeaderStyleList {
            background-color: #ddd;
        }

        .borderd {
            direction: rtl;
            padding: 10px;
            border: 1px solid #ddd;
            margin: 10px 0;
        }
    </style>
    <script type="text/javascript">
        function Expand(el) {
            var img = $(el).attr("src");
            if (img.includes("plus")) {
                $(el).closest('td').next('td').find("table").show();
                $(el).attr("src", "Images/minus.png");
            } else {
                $(el).closest('td').next('td').find("table").hide();
                $(el).attr("src", "Images/plus.png");
            }
        };
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <header class="Header">
        <p>وحدات القياس</p>
    </header>
    <asp:Panel runat="server">
        <asp:GridView ID="gridViewUnits" runat="server" AutoGenerateColumns="false" DataKeyNames="Id"
            OnRowCommand="gridViewUnits_OnRowCommand"
            OnRowDataBound="gridViewUnits_OnRowDataBound"
            CssClass="Gridview_Style2"
            Style="border: 1px solid #ddd;">
            <Columns>
                <asp:BoundField DataField="Id" SortExpression="Id" ItemStyle-CssClass="NoDispaly" HeaderStyle-CssClass="NoDispaly" ControlStyle-CssClass="NoDispaly" />
                <asp:TemplateField ItemStyle-Width="5%">
                    <ItemTemplate>
                        <img alt="" style="cursor: pointer" src="images/plus.png" onclick="Expand(this)" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="اسم الوحدة">
                    <ItemTemplate>
                        <asp:Label runat="server" Text='<%#Eval("MainUnitName")%>' />
                        <asp:Panel ID="PanelUnitFactors" runat="server">
                            <asp:GridView ID="gridViewUnitFactors" runat="server" AutoGenerateColumns="false"
                                hidden="true"
                                CssClass="Gridview_Style2 borderd"
                                EmptyDataText="لا توجد تحويلات لهذه الوحدة">
                                <Columns>
                                    <asp:BoundField DataField="SubUnitName" HeaderText="اسم الوحدة" />
                                    <asp:BoundField DataField="Factor" HeaderText="معامل التحويل" DataFormatString="{0:G29}" />
                                </Columns>
                                <HeaderStyle CssClass="HeaderStyleList" />
                                <RowStyle CssClass="RowStyleList" />
                                <AlternatingRowStyle CssClass="AlternateRowStyleList" />
                                <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
                            </asp:GridView>
                        </asp:Panel>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField ItemStyle-Width="5%">
                    <ItemTemplate>
                        <asp:ImageButton ID="btnDeleteUnit" runat="server" ImageUrl="~/Images/Delete.png" Width="16" Height="16"
                            CausesValidation="false" CommandName="Delete_Row"
                            OnClientClick="return confirm('سيتم مسح هذه الوحده . . . هل تريد المتابعه ؟');" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <HeaderStyle CssClass="HeaderStyleList" />
            <RowStyle CssClass="RowStyleList" />
            <AlternatingRowStyle CssClass="AlternateRowStyleList" />
            <EmptyDataRowStyle CssClass="EmptyDataRowStyleList" />
        </asp:GridView>

        <footer>
            <div class="MsgDiv">
                <asp:Label ID="lblSaveMsg" runat="server" CssClass="MessageLabel" ForeColor="Green"></asp:Label>
            </div>
        </footer>
    </asp:Panel>
</asp:Content>
