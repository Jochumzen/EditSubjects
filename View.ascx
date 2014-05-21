<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="View.ascx.cs" Inherits="Christoc.Modules.EditSubjects.View" %>

 <link href="/DesktopModules/CreatePlugg2/Script/js/jqtree.css" rel="stylesheet" />
    <script src="/DesktopModules/CreatePlugg2/Script/js/tree.jquery.js"></script>

<script src="/DesktopModules/EditSubjects/js/tree.jquery.js"></script>
<link href="/DesktopModules/EditSubjects/js/jqtree.css" rel="stylesheet" />
<link href="/DesktopModules/EditSubjects/module.css" rel="stylesheet" />
<asp:Label runat="server" Visible="False" ID="lblNotEnglish"></asp:Label>

 <div class="tree">
                <div id="tree2"></div>
            </div>
<br />
<asp:Button ID="btnRecorder" runat="server" Text="Reorder Subject" OnClick="btnRecorder_Click" />
<input type="button" id="btnAddnewsub"  value="Add New Subject" onclick="return addNewSubject()" />&nbsp;
<%--<asp:Button ID="btnAddnewsub" OnClientClick="addNewSubject()" runat="server" Text="Add New Subject" OnClick="Button1_Click" />--%>
<asp:Button ID="btnRemoveSub" OnClientClick="removeSubject()" runat="server" Text="Remove Subject" />
<br />
<br /><br />
<asp:Panel ID="pnlAddSub" runat="server">

<h2>Add New Subject</h2>

<div>
    <div class="subjectdiv">
        <asp:TextBox ID="txtAddSubject" runat="server"></asp:TextBox>
    </div>
    <div style="float:left">
        <input type="button" id="addsubject" value="Add after Subject" onclick="return addSubject()" />
         <input type="button" id="Button2" value="Add before Subject" onclick="return addBeforeSubject()" />
         <input type="button" id="Button3" value="Add child Subject" onclick="return addChildSubject()" />

        
    </div>
</div>

<asp:HiddenField ID="hdnTreeData" runat="server" Value="" />
<p>
<asp:Button ID="btn_Save" runat="server" Text="Save Subject" OnClick="btn_Save_Click" OnClientClick="return getjson()" />
</p>
<asp:HiddenField ID="hdnGetJosnResult" runat="server" />
<asp:HiddenField ID="hdnNodeSubjectId" runat="server" />
</asp:Panel>
    <script type="text/javascript">

        $(document).ready(function () {
            $("#" + '<%=pnlAddSub.ClientID%>').hide();

            $('#tree2').tree({
                data: eval($("#" + '<%=hdnTreeData.ClientID%>').attr('value')),
                //data:data,
                dragAndDrop: true,
                selectable: true,
                autoEscape: false,
                autoOpen: true
            });

          //  $('#tree2').tree({
            //    data: eval($("#" + '<%=hdnTreeData.ClientID%>').attr('value')),
            //    dragAndDrop: true
           // });

        });





    </script>

    <style>
        .ui-tabs-vertical
        {
            width: 55em;
        }

            .ui-tabs-vertical .ui-tabs-nav
            {
                padding: .2em .1em .2em .2em;
                float: left;
                width: 12em;
            }

                .ui-tabs-vertical .ui-tabs-nav li
                {
                    clear: left;
                    width: 100%;
                    border-bottom-width: 1px !important;
                    border-right-width: 0 !important;
                    margin: 0 -1px .2em 0;
                }

                    .ui-tabs-vertical .ui-tabs-nav li a
                    {
                        display: block;
                    }

                    .ui-tabs-vertical .ui-tabs-nav li.ui-tabs-active
                    {
                        padding-bottom: 0;
                        padding-right: .1em;
                        border-right-width: 1px;
                        border-right-width: 1px;
                    }

            .ui-tabs-vertical .ui-tabs-panel
            {
                padding: 1em;
                float: right;
                width: 40em;
            }
    </style>
<script type="text/javascript">

    $(document).ready(function () {
        $("#<%=hdnNodeSubjectId.ClientID%>").hide();
        $('#tree2').tree({
            c: eval($("#" + '<%=hdnTreeData.ClientID%>').attr('value')),
            //data:data,
            dragAndDrop: true,
            selectable: true,
            autoEscape: false,
            autoOpen: false
        });

    });

    function getjson() {

        $("#dnn_ctr943_View_pnlAddSub").hide();
        //var record = $('#tree2').tree('getTree');
        
        var record = $('#tree2').tree('toJson');     
        alert(record);
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
        //alert(node.SubjectID);
        $("#<%=hdnNodeSubjectId.ClientID%>").val(node.SubjectID);
    }
    function addNewSubject() {

        $("#" + '<%=pnlAddSub.ClientID%>').show();
     
    }

    function removeSubject() {
        var node = $('#tree2').tree('getSelectedNode');

        var Error = "";

        if (!node)
            Error = 'Please Select Node \n';     

        if (Error != "") {
            alert(Error);
            return false;
        }
      
        $('#tree2').tree('removeNode', node);
      
    }
    function addSubject() {
        var node = $('#tree2').tree('getSelectedNode');
        //var parent_node = node.parent;     
       // var level = node.getLevel();
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
                SubjectId: 2,
                MotherId: 3,
                SubjectOrder:2,
            },
            node
        );
       
        $("#<%=txtAddSubject.ClientID%>").val("");
    }
    function addChildSubject() {
        var node = $('#tree2').tree('getSelectedNode');
       
        var par = $tree.tree('getParentNode', node);
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
            'appendNode',
            {
                label: $("#<%=txtAddSubject.ClientID%>").val(),
            },
            node
             
        );
        $("#<%=txtAddSubject.ClientID%>").val("");
    }
    function addBeforeSubject() {
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
            'addNodeBefore',
            {
                label: $("#<%=txtAddSubject.ClientID%>").val(),
            },
            node
        );
        $("#<%=txtAddSubject.ClientID%>").val("");
    }
</script>
