/*
' Copyright (c) 2014  Christoc.com
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
using Christoc.Modules.EditSubjects.Components;
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
using Plugghest.Subjects;


namespace Christoc.Modules.EditSubjects
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
        protected void Page_Load(object sender, EventArgs e)
        {
            if((Page as DotNetNuke.Framework.PageBase).PageCulture.Name != "en-US")
            {
                lblNotEnglish.Text = "Subjects can only be edited in English. Please switch language to English to edit subjects.";
                lblNotEnglish.Visible = true;
                //Todo: Hide other controls
                return;
            }

            try
            {
                if (!IsPostBack)
                {
                  //  btnAddnewsub.Visible = false;
                    BindTree();
                }
            }
            catch (Exception exc) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }

        public void BindTree()
        {
          
            //BaseHandler sh = new BaseHandler();
            //var tree = sh.GetSubjectsAsTree("en-US");
            //JavaScriptSerializer TheSerializer = new JavaScriptSerializer();
            //hdnTreeData.Value = TheSerializer.Serialize(tree);

            SubjectHandler objsubhandler = new SubjectHandler();

            var tree = objsubhandler.GetSubjectsAsTree();
            JavaScriptSerializer TheSerializer = new JavaScriptSerializer();
            hdnTreeData.Value = TheSerializer.Serialize(tree);

        }

        protected void btnSaveSubjects_Click(object sender, EventArgs e)
        {
            //JavaScriptSerializer js = new JavaScriptSerializer();
            //string json = hdnGetJosnResult.Value;
            //var flatSubjects = js.Deserialize<Subject[]>(json).ToList();

            //BaseHandler sh = new BaseHandler();

            //Todo: Finish Save
        }

        protected void btnAddSubject_Click(object sender, EventArgs e)
        {
            //if (hdnNodeSubjectId.Value != "")
            //{
            //    BaseHandler sh = new BaseHandler();

            //    Subject SelectedSubject = h.GetSubject(Convert.ToInt32(hdnNodeSubjectId.Value));

            //    //Get All subjects with same mother as selected but with higher Order
            //    var updateSubjects = h.GetSubjectsFromMotherWhereOrderGreaterThan(SelectedSubject.Mother, SelectedSubject.SubjectOrder);
            //    //Increase Order by one to make room for new subject
            //    foreach (Subject s in updateSubjects)
            //    {
            //        s.SubjectOrder += 1;
            //        h.UpdateSubject(s);
            //    }

            //    Subject newSubject = new Subject();
            //    newSubject.label = txtAddSubject.Text;
            //    newSubject.SubjectOrder = SelectedSubject.SubjectOrder + 1;
            //    newSubject.Mother = SelectedSubject.Mother;
            //    h.CreateSubject(newSubject);

            //    BindTree();
            //}
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

        protected void btn_Save_Click(object sender, EventArgs e)
        {
            JavaScriptSerializer js = new JavaScriptSerializer();
            string json = hdnGetJosnResult.Value;
            var flatSubjects = js.Deserialize<Plugghest.Subjects.Subject[]>(json).ToList();
            var flatSubjects1 = js.Deserialize<Plugghest.Base2.Subject[]>(json).ToList();

            BaseHandler sh = new BaseHandler();
            sh.UpdateSubjectTree(flatSubjects1);
            BindTree();


            //JavaScriptSerializer js = new JavaScriptSerializer();
            //string json = hdnGetJosnResult.Value;
            //List<Plugghest.Base2.Subject> subjects = js.Deserialize<Plugghest.Base2.Subject[]>(json).ToList();
            //BaseHandler bh = new BaseHandler();
            //bh.UpdateSubjectTree(subjects);
            //BindTree();
        }

        protected void btnRecorder_Click(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            pnlAddSub.Visible = true;
        }
    }
}