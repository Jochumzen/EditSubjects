﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="View.ascx.cs" Inherits="Plugghest.Modules.EditSubjects.View" %>

<script src="/js/jqTree/tree.jquery.js"></script>
<link href="/js/jqTree/jqtree.css" rel="stylesheet" />

<asp:HiddenField ID="hdnTreeData" runat="server" Value="" />
<asp:HiddenField ID="hdnDragAndDrop" runat="server" Value="false" />
<asp:HiddenField ID="hdnSelectable" runat="server" Value="false" />
<asp:HiddenField ID="hdnGetJosnResult" runat="server" />
<asp:HiddenField ID="hdnNodeSubjectId" runat="server" />
<asp:HiddenField ID="hdnIsTranslate" runat="server" Value="true" />


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
<asp:Button ID="btnTranslation" resourcekey="Translate.Text" runat="server" Visible="False" OnClick="btnTranslation_Click" />
<br />
<asp:HyperLink ID="hlToEnglish" Text="Switch to English to edit subjects" Visible="False" runat ="server" Font-Size="Small" />
<asp:Label ID="lblCannotDelete" Text = "Cannot delete the selected subject as it has children. Delete the children first." Visible ="false" runat = "server" />
<br />

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

<asp:Panel ID="pnlTranslateSubject" runat ="server" Visible ="false" >
    <asp:Label ID="lblSelectSubject" resourcekey="Select" runat="server" /><br />
    <asp:Label ID="lblInEnglish" resourcekey="InEnglish" runat="server" />
    <asp:Label ID="lblEnglish" Text="" runat="server" /><br />
    <asp:Label ID="lblStatus" resourcekey="Status" runat="server" />
    <asp:Label ID="lblStatusHuman" resourcekey="StatusHuman" runat="server" />
    <asp:Label ID="lblStatusGoogle" resourcekey="StatusGoogle" runat="server" /><br />
    <asp:Label ID="lblNewTranslation" resourcekey="NewTranslation"  runat="server" />
    &nbsp;
    <asp:TextBox ID="tbNewTranslation" runat ="server" Width="446px"  /><br />
    <asp:Button ID="btnSaveTranslation" resourcekey="SaveTranslation" runat="server" OnClientClick="return getsubjectidTransl();" OnClick="btnSaveTranslation_Click" />
    <asp:Button ID="btnExitTranslationMode" resourcekey="ExitTranslation" runat="server" OnClick="btnExitTranslationMode_Click" />
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

    $('#tree2').bind(
    'tree.click',
    function (event) {
        var node = event.node;
        $("#<%=lblStatusHuman.ClientID%>").css('display', 'block');
        if ($("#<%=hdnIsTranslate.ClientID%>").val() == 'true')
            $("#<%=lblEnglish.ClientID%>").html(node.EnglishTitle);
    }
    );

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

    function getsubjectidTransl() {
        var node = $('#tree2').tree('getSelectedNode');
        var Error = "";

        if (!node)
            Error = 'Please Select Node \n';
        if ($("#<%=tbNewTranslation.ClientID%>").val() == '')
            Error += 'Please Enter Translation';

        if (Error != "") {
            alert(Error);
            return false;
        }
        $("#<%=hdnNodeSubjectId.ClientID%>").val(node.SubjectId);
    }
</script>
