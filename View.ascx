<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="View.ascx.cs" Inherits="Christoc.Modules.EditSubjects.View" %>

<script src="/DesktopModules/Plugghest_Subjects/js/tree.jquery.js"></script>
<link href="/DesktopModules/Plugghest_Subjects/js/jqtree.css" rel="stylesheet" />
<link href="/DesktopModules/Plugghest_Subjects/module.css" rel="stylesheet" />


<div style="background-color: #D8CACC; padding: 20px;">
    <div id="tree2"></div>
    </div>
<br />
<asp:Button ID="btnSaveSubjects" Text="Save Subjects" runat="server" OnClick="btnSaveSubjects_Click" OnClientClick="return getjson()" />

<br /><br />
<h2>Add New Subject</h2>

<div>
    <div class="subjectdiv">
        <asp:TextBox ID="txtAddSubject" runat="server"></asp:TextBox>
    </div>
    <div style="float:left">
        <input type="button" id="addsubject" value="Add Subject" onclick="return addSubject()" />
    </div>
</div>

<asp:HiddenField ID="hdnTreeData" runat="server" Value="" />
<asp:HiddenField ID="hdnGetJosnResult" runat="server" />
<asp:HiddenField ID="hdnNodeSubjectId" runat="server" />

<script type="text/javascript">

    $(document).ready(function () {
        $('#tree2').tree({
            data: eval($("#" + '<%=hdnTreeData.ClientID%>').attr('value')),
            //data:data,
            dragAndDrop: true,
            selectable: true,
            autoEscape: false,
            autoOpen: false
        });

    });

    function getjson() {

        var record = $('#tree2').tree('toJson');
        alert(record);


        return false;

        $("#<%=hdnGetJosnResult.ClientID%>").val(record);

        alert($("#<%=hdnGetJosnResult.ClientID%>").val());
        return false;
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
        //alert(node.SubjectID);
        $("#<%=hdnNodeSubjectId.ClientID%>").val(node.SubjectID);
    }

    function addSubject() {
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
        $('#tree2').tree(
            'addNodeAfter',
            {
                label: $("#<%=txtAddSubject.ClientID%>").val(), 
            },
            node
        );
    }
</script>
