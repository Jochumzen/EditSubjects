﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="View.ascx.cs" Inherits="Christoc.Modules.EditSubjects.View" %>

<script src="/DesktopModules/EditSubjects/js/tree.jquery.js"></script>
<link href="/DesktopModules/EditSubjects/js/jqtree.css" rel="stylesheet" />
<link href="/DesktopModules/EditSubjects/module.css" rel="stylesheet" />

<asp:Label runat="server" Visible="False" ID="lblNotEnglish"></asp:Label>
<asp:HiddenField ID="hdnTreeData" runat="server" Value="" />
<asp:HiddenField ID="hdnDragAndDrop" runat="server" Value="false" />
<asp:HiddenField ID="hdnSelectable" runat="server" Value="false" />
<asp:HiddenField ID="hdnGetJosnResult" runat="server" />
<asp:HiddenField ID="hdnNodeSubjectId" runat="server" />

<div class="tree">
    <div id="tree2"></div>
</div>
<br />

<asp:Button ID="btnReorder" runat="server" Text="Reorder Subjects" OnClick="btnReorder_Click" />
<asp:Button ID="btnAddNewSubject" runat="server" Text="Add New Subjects" OnClick="btnAddNewSubject_Click" />
<asp:Button ID="btnRemoveSubject" runat="server" Text="Remove Subjects" OnClick="btnRemoveSubject_Click" />
<asp:Button ID="btnSaveReordering" runat="server" Text="Save Reordering" Visible="False" OnClientClick ="getjson();" OnClick="btnSaveReordering_Click"/>
<asp:Button ID="btnCancelReordering" Text="Exit Reordering Mode" runat="server" Visible="False" OnClick="btnCancelReordering_Click"/>
<asp:Button ID="btnRemoveSelectedSubject" Text="Remove selected subject" runat="server" Visible="False" OnClientClick ="return getsubjectid();" OnClick="btnRemoveSelectedSubject_Click"/>
<asp:Button ID="btnCancelRemove" Text="Cancel Remove" runat="server" Visible="False" OnClick="btnCancelRemove_Click"/>

<br />
<br /><br />

<asp:Panel ID="pnlAddSubject" runat="server" Visible="False">

    <h2>Add New Subject</h2>
    <div>
        <div class="subjectdiv">
            <asp:TextBox ID="txtAddSubject" runat="server" Width="316px"></asp:TextBox>
        </div>
        <asp:Button ID="btnAddAfter" Text="Add After Selection" runat="server" OnClientClick="return getsubjectid();" OnClick="btnAddAfter_Click" />
        <asp:Button ID="btnAddBefore" Text="Add Before Selection" runat="server" OnClientClick="return getsubjectid();" OnClick="btnAddBefore_Click"/>
        <asp:Button ID="btnAddChild" Text="Add As Child of Selection" runat="server" OnClientClick="return getsubjectid();" OnClick="btnAddChild_Click"/>
        <asp:Button ID="btnCancelAdd" Text="Exit Add Mode" runat="server" OnClick="btnCancelAdd_Click"/>
    </div>
    <br />
</asp:Panel>

<script type="text/javascript">

    $(document).ready(function () {

        $('#tree2').tree({
            data: eval($("#" + '<%=hdnTreeData.ClientID%>').attr('value')),
            dragAndDrop: eval($("#" + '<%=hdnDragAndDrop.ClientID%>').attr('value')),
            selectable: eval($("#" + '<%=hdnSelectable.ClientID%>').attr('value')),
            autoEscape: false,
            autoOpen: false
        });
    });
</script>

<script type="text/javascript">

    function getjson() {
        var record = $('#tree2').tree('toJson');     
        $("#<%=hdnGetJosnResult.ClientID%>").val(record);
        return true;
    }

    function getsubjectid() {
        var node = $('#tree2').tree('getSelectedNode');

        var Error = "";

        if (!node)
            Error = 'Please Select Node \n';
        if ($("#<%=txtAddSubject.ClientID%>").val() == '')
            Error += 'Please Enter Subject Name';

        if (Error != "") {
            alert(Error);
            return false;
        }
        $("#<%=hdnNodeSubjectId.ClientID%>").val(node.SubjectId);
    }

</script>
