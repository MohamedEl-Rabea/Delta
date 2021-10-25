<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="NotAuthorized.aspx.cs" Inherits="DeltaProject.NotAuthorized" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Pages_Style_Sheet.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content_Section" runat="server">
    <section class="Login_Section" style="width: 100%; text-align: center; vertical-align: central;">
        <h1 style="color: red; margin-top: 100px;">غير مسموح لك بالوصول</h1>
    </section>
</asp:Content>
