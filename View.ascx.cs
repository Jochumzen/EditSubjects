/*
' Copyright (c) 2014  Plugghest.com
'  All rights reserved.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
' TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
' THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
' CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
' DEALINGS IN THE SOFTWARE.
' 
*/

using System;
using System.Web.UI.WebControls;
using Plugghest.Modules.EditSubjects.Components;
using DotNetNuke.Security;
using DotNetNuke.Services.Exceptions;
using DotNetNuke.Entities.Modules;
using DotNetNuke.Entities.Modules.Actions;
using DotNetNuke.Services.Localization;
using DotNetNuke.UI.Utilities;
using Plugghest.Base2;
using System.Web.Script.Serialization;
using System.Linq;
using System.Collections.Generic;
using System.IO;


namespace Plugghest.Modules.EditSubjects
{
    /// -----------------------------------------------------------------------------
    /// <summary>
    /// The View class displays the content
    /// 
    /// Typically your view control would be used to display content or functionality in your module.
    /// 
    /// View may be the only control you have in your project depending on the complexity of your module
    /// 
    /// Because the control inherits from EditSubjectsModuleBase you have access to any custom properties
    /// defined there, as well as properties from DNN such as PortalId, ModuleId, TabId, UserId and many more.
    /// 
    /// </summary>
    /// -----------------------------------------------------------------------------
    public partial class View : EditSubjectsModuleBase, IActionable
    {
        public string Language;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!UserInfo.IsInRole("Administator"))
            {
                btnReorder.Visible = false;
                btnAddNewSubject.Visible = false;
                btnRemoveSubject.Visible = false;
            }
            Language = (Page as DotNetNuke.Framework.PageBase).PageCulture.Name;
           
            string editStr = Page.Request.QueryString["edit"];
            if (UserInfo.IsInRole("Administator"))
            {
                if (Language == "en-US")
                {
                    if (editStr == "reorder")
                    {
                        btnReorder.Visible = false;
                        btnAddNewSubject.Visible = false;
                        btnRemoveSubject.Visible = false;
                        btnSaveReordering.Visible = true;
                        btnCancelReordering.Visible = true;
                        hdnSelectable.Value = "true";
                        hdnDragAndDrop.Value = "true";
                    }
                    if (editStr == "add")
                    {
                        btnReorder.Visible = false;
                        btnAddNewSubject.Visible = false;
                        btnRemoveSubject.Visible = false;
                        hdnSelectable.Value = "true";
                        pnlAddSubject.Visible = true;
                    }
                    if (editStr == "remove")
                    {
                        btnReorder.Visible = false;
                        btnAddNewSubject.Visible = false;
                        btnRemoveSubject.Visible = false;
                        hdnSelectable.Value = "true";
                        btnRemoveSelectedSubject.Visible = true;
                        btnCancelRemove.Visible = true;
                    }
                }
                else
                {
                    if (editStr == "translate")
                    {
                        btnReorder.Visible = false;
                        btnAddNewSubject.Visible = false;
                        btnRemoveSubject.Visible = false;
                        hdnSelectable.Value = "true";
                        pnlTranslateSubject.Visible = true;
                    }
                    else
                    {
                        btnReorder.Visible = false;
                        btnAddNewSubject.Visible = false;
                        btnRemoveSubject.Visible = false;
                        btnTranslation.Visible = true;
                        hlToEnglish.NavigateUrl = DotNetNuke.Common.Globals.NavigateURL(TabId, "", "language=en-us");
                        hlToEnglish.Visible = true;
                    }
                }  
            } 
           
            if (!IsPostBack)
            {
                BindTree();
            }
        }

        public void BindTree()
        {          
            BaseHandler objsubhandler = new BaseHandler();
            var tree = objsubhandler.GetSubjectsAsTree(Language);
            JavaScriptSerializer TheSerializer = new JavaScriptSerializer();
            hdnTreeData.Value = TheSerializer.Serialize(tree);
        }

        protected void btnReorder_Click(object sender, EventArgs e)
        {
            Response.Redirect(DotNetNuke.Common.Globals.NavigateURL(TabId, "", "edit=reorder"));
        }

        protected void btnAddNewSubject_Click(object sender, EventArgs e)
        {
            Response.Redirect(DotNetNuke.Common.Globals.NavigateURL(TabId, "", "edit=add"));
        }

        protected void btnRemoveSubject_Click(object sender, EventArgs e)
        {
            Response.Redirect(DotNetNuke.Common.Globals.NavigateURL(TabId, "", "edit=remove"));
        }

        protected void btnSaveReordering_Click(object sender, EventArgs e)
        {
            JavaScriptSerializer js = new JavaScriptSerializer();
            string json = hdnGetJosnResult.Value;
            var flatSubjects1 = js.Deserialize<Plugghest.Base2.Subject[]>(json).ToList();

            BaseHandler sh = new BaseHandler();
            sh.UpdateSubjectTree(flatSubjects1);
            BindTree();
        }

        protected void btnCancelReordering_Click(object sender, EventArgs e)
        {
            Response.Redirect(DotNetNuke.Common.Globals.NavigateURL(TabId, "", ""));
        }

        protected void btnRemoveSelectedSubject_Click(object sender, EventArgs e)
        {
            BaseHandler bh = new BaseHandler();
            Subject s = bh.FindSubject(Language, Convert.ToInt32(hdnNodeSubjectId.Value));
            if (s.children.Count == 0)
            {
                bh.DeleteSubject(Convert.ToInt32(hdnNodeSubjectId.Value));
                lblCannotDelete.Visible = false;
            }
            else
                lblCannotDelete.Visible = true;
            BindTree();
        }

        protected void btnCancelRemove_Click(object sender, EventArgs e)
        {
            Response.Redirect(DotNetNuke.Common.Globals.NavigateURL(TabId, "", ""));
        }

        protected void btnAddAfter_Click(object sender, EventArgs e)
        {
            BaseHandler bh = new BaseHandler();
            SubjectEntity SelectedSubject = bh.GetSubjectEntity(Convert.ToInt32(hdnNodeSubjectId.Value));
            CreateSubject(SelectedSubject.SubjectOrder + 1, SelectedSubject.MotherId);
        }

        protected void btnAddBefore_Click(object sender, EventArgs e)
        {
            BaseHandler bh = new BaseHandler();
            SubjectEntity SelectedSubject = bh.GetSubjectEntity(Convert.ToInt32(hdnNodeSubjectId.Value));
            CreateSubject(SelectedSubject.SubjectOrder, SelectedSubject.MotherId);
        }

        protected void btnAddChild_Click(object sender, EventArgs e)
        {
            BaseHandler bh = new BaseHandler();
            SubjectEntity SelectedSubject = bh.GetSubjectEntity(Convert.ToInt32(hdnNodeSubjectId.Value));
            CreateSubject(1, SelectedSubject.SubjectId);
        }

        private void CreateSubject(int order, int motherId)
        {
            BaseHandler bh = new BaseHandler();
            Subject newSubject = new Subject();
            newSubject.label = txtAddSubject.Text;
            newSubject.SubjectOrder = order;
            newSubject.MotherId = motherId;
            bh.CreateSubject(newSubject, this.UserId);
            txtAddSubject.Text = "";
            BindTree();
        }

        protected void btnCancelAdd_Click(object sender, EventArgs e)
        {
            Response.Redirect(DotNetNuke.Common.Globals.NavigateURL(TabId, "", ""));
        }

        public ModuleActionCollection ModuleActions
        {
            get
            {
                var actions = new ModuleActionCollection
                    {
                        {
                            GetNextActionID(), Localization.GetString("EditModule", LocalResourceFile), "", "", "",
                            EditUrl(), false, SecurityAccessLevel.Edit, true, false
                        }
                    };
                return actions;
            }
        }

        protected void btnTranslation_Click(object sender, EventArgs e)
        {
            Response.Redirect(DotNetNuke.Common.Globals.NavigateURL(TabId, "", "edit=translate"));
        }

        protected void btnExitTranslationMode_Click(object sender, EventArgs e)
        {
            Response.Redirect(DotNetNuke.Common.Globals.NavigateURL(TabId, "", ""));
        }

        protected void btnSaveTranslation_Click(object sender, EventArgs e)
        {
            BaseHandler bh = new BaseHandler();
            PHText t = bh.GetCurrentVersionText(Language, Convert.ToInt32(hdnNodeSubjectId.Value), ETextItemType.Subject);
            t.Text = tbNewTranslation.Text;
            t.CultureCodeStatus = ECultureCodeStatus.HumanTranslated;
            bh.SavePhText(t);
            tbNewTranslation.Text = "";
            BindTree();
        }

    }
}