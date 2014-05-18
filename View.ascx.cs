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
using Plugghest.Subjects;
using System.Web.Script.Serialization;
using System.Linq;
using System.Collections.Generic;
using System.IO;

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
            try
            {
                if (!IsPostBack)
                {
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
            SubjectHandler sh = new SubjectHandler();

            var tree = sh.GetSubjectsAsTree();
            JavaScriptSerializer TheSerializer = new JavaScriptSerializer();
            hdnTreeData.Value = TheSerializer.Serialize(tree);
        }

        protected void btnSaveSubjects_Click(object sender, EventArgs e)
        {
            JavaScriptSerializer js = new JavaScriptSerializer();
            string json = hdnGetJosnResult.Value;
            var flatSubjects = js.Deserialize<Subject[]>(json).ToList();

            SubjectHandler sh = new SubjectHandler();

            //Todo: Finish Save
        }

        protected void btnAddSubject_Click(object sender, EventArgs e)
        {
            //if (hdnNodeSubjectId.Value != "")
            //{
            //    SubjectHandler h = new SubjectHandler();

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
    }
}