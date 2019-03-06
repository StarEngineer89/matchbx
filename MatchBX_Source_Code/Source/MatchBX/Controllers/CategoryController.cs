using Business;
using Model;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using MatchBx.Utilities;
using MatchBX.Models;
using System.Globalization;

namespace MatchBX.Controllers
{
   // [CustomExceptionFilter]
    public class CategoryController : Controller
    {
        // GET: Category
        Job objJob = new Job();
        JobModel objJobMod = new JobModel();
        List<Job> objJobList = new List<Job>();
        TrendingTags objTrending = new TrendingTags();
        TrendingTagsModel objTrendingMod = new TrendingTagsModel();
        List<TrendingTags> objTrendingTagsList = new List<TrendingTags>();
        SkillsModel objSkillsMod = new SkillsModel();
        Skills objSkills = new Skills();
        JobCategoryModel objJobCategoryMod = new JobCategoryModel();
        int _RecordDisplay =5;
        int JobCategoryId;
        int _TotalRecord = 0;
        string category = string.Empty;
        int cattype = 0;

        [NoCache]
        public ActionResult Index(int? id,int? type)
        {

            cattype = type.GetValueOrDefault();
            if(cattype != 0)
            {
                if(cattype == 2)
                {
                    category = "G";
                }
                else
                {
                    category = "J";
                }
            }
            else
            {
                GetCategory();
            }
            
            Session["ExchangeRate"]=MatchBxCommon.GetExchangeRate();
            TempData["TrendingTagsFooter"] = MatchBxCommon.GetTrendingTagsFooter();
            MultipleModel modelMul = new MultipleModel();
            int _loadmore = 0;
            JobCategoryId = id.GetValueOrDefault();
            Session["JobCatId"] = JobCategoryId;
            dynamic model = new ExpandoObject();
            objJob.JobCategoryId = JobCategoryId;
            objJob.FromPage = category;
            objJob.SortBy = "H";
            if (Session["searchmodel"] != null && Session["FromDetails"] != null)
            {
                SearchCriteria _model = (SearchCriteria)Session["searchmodel"];
                objJob.TrendingTagsIdList = _model.populartags;
                objJob.SkillsList = _model.topskills;

                ViewBag.budgetMin = _model.budgetMin;
                ViewBag.MaxBudget = _model.budgetMax;
                objJob.SortBy = _model.sortorder;
                Session["searchmodel"] = null;
                Session["FromDetails"] = null;
            }
            else
            {
                objJob.TrendingTagsIdList = "0";
                objJob.SkillsList = "0";
            }
            objJobList = MatchBxCommon.GenerateBadge(objJobMod.GetJobDetails(objJob).ToList().OrderByDescending(x => x.BudgetASP).ToList());
            //objJobList = MatchBxCommon.GenerateBadge(objJobMod.GetJobDetails(objJob).ToList().OrderByDescending(x => x.BudgetASP).ThenByDescending(x => x.Rownumber).ToList());


            TempData["JobList"] = objJobList;
            _TotalRecord = objJobList.Count();
            if (_TotalRecord > _RecordDisplay)
            {
                _loadmore = 1;
            }
            else
            {
                _loadmore = 0;
            }
            objJobList.ForEach(s => s.Isloadmore = _loadmore);
            objJobList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
            model.Job = objJobList.Take(_RecordDisplay).ToList();
            Session["Category"] = category;
            //if (category == "J")
            //{
            //    objJobList.ForEach(s => s.FromPage = "J");
            //    Session["Category"] = "J";
            //}
            //else {
            //    objJobList.ForEach(s => s.FromPage = "G");
            //    Session["Category"] = "G";
            //}
            objTrending.JobCategoryId= JobCategoryId;
            objTrending.FromPage =  category;
            objTrendingTagsList = objTrendingMod.GetTrendingTags(objTrending);
            model.TrendingTags = objTrendingTagsList;
            objTrendingTagsList.ForEach(s => s.Description = s.Description.Replace("#", ""));
            model.PopularTags = objTrendingTagsList;
            objSkills.JobCategoryId= JobCategoryId;
            Session["JobCategoryId"] = JobCategoryId;
            objSkills.FromPage = category ;
            model.skills = objSkillsMod.GetTopSkills(objSkills);
            List<JobCategory> _JobcategoryList = new List<JobCategory>();
            JobCategoryModel JobModel = new JobCategoryModel();
            _JobcategoryList = JobModel.GetList();
            Session["JobCategory"] = _JobcategoryList;
            model.messageSender = 0;
            if (Request.QueryString["mailMessagId"] != null)
            {
                string _messageSender = Request.QueryString["mailMessagId"].ToString();
                model.messageSender = Convert.ToInt32(_messageSender);
                Session["mailMessagId"] = _messageSender;
            }
            return View("Index", model);
        }
        [HttpPost]
        public JsonResult ApplyFilter(string topskills, decimal budgetMin, decimal budgetMax, string populartags, string sortorder, string _searchtext)
        {
            SearchCriteria searchmodel = new SearchCriteria();
            searchmodel.topskills = topskills;
            searchmodel.budgetMin = budgetMin;
            searchmodel.budgetMax = budgetMax;
            searchmodel.populartags = populartags;
            searchmodel.sortorder = sortorder;
            searchmodel._searchtext = _searchtext;
            Session["searchmodel"] = searchmodel;


            GetCategory();

            int _loadmore = 0;
            dynamic model = new ExpandoObject();
            objJob.JobCategoryId = Convert.ToInt32(Session["JobCatId"].ToString());
            objJob.SkillsList = topskills;
            objJob.MinBudget = budgetMin;
            objJob.MaxBudget = budgetMax;
            objJob.TrendingTagsIdList = populartags;
            objJob.SortBy = sortorder;
            objJob.FromPage = category;
            objJobList = MatchBxCommon.GenerateBadge(objJobMod.GetJobDetails(objJob));
            objJobList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
            if (sortorder == "H")
            {
                objJobList = objJobList.OrderByDescending(x => x.BudgetASP).ToList();
            }
            else if (sortorder == "L")
            {
                objJobList = objJobList.OrderBy(x => x.BudgetASP).ToList();
            }
            else
            {
                //if (objJob.FromPage == "J")
                //{
                    objJobList = objJobList.OrderByDescending(x => x.Rownumber).ToList();
                //}
                //else {
                //    objJobList = objJobList.OrderBy(x => x.BudgetASPInt).ToList();
                //}
            }
            if (string.IsNullOrWhiteSpace(_searchtext))
            {
                _TotalRecord = objJobList.Count();
                if (_TotalRecord > _RecordDisplay)
                {
                   _loadmore = 1;
                }
                else
                {
                    _loadmore = 0;
                }
                objJobList.ForEach(s => s.Isloadmore = _loadmore);
                if (sortorder == "H")
                {
                    objJobList = objJobList.OrderByDescending(x => x.BudgetASP).Take(_RecordDisplay).ToList();
                }
                else if (sortorder == "L")
                {
                   objJobList = objJobList.OrderBy(x => x.BudgetASP).Take(_RecordDisplay).ToList();
                }
                else
                {
                    //if (objJob.FromPage == "J")
                    //{
                    objJobList = objJobList.OrderByDescending(x => x.Rownumber).Take(_RecordDisplay).ToList();
                    //}
                    //else
                    //{
                    //    objJobList = objJobList.OrderBy(x => x.BudgetASPInt).Take(_RecordDisplay).ToList();
                    //}
                }
                  
                objJobList.ForEach(x => x.Isloadmore = _loadmore);
                model.Job = objJobList;
            
            }
            else
            {
                _TotalRecord = objJobList.Where(x => x.JobDescription.ToLower().Contains(_searchtext.ToLower().Trim()) || x.JobTitle.ToLower().Contains(_searchtext.ToLower().Trim()) || x.JobCompletionDateDisplay.ToLower().Contains(_searchtext.ToLower().Trim()) || x.FullName.ToLower().Contains(_searchtext.ToLower().Trim())).ToList().Count();
                _TotalRecord = objJobList.Count();
                if (_TotalRecord > _RecordDisplay)
                {
                    _loadmore = 1;
                }
                else
                {
                    _loadmore = 0;
                }
                objJobList.ForEach(x => x.Isloadmore = _loadmore);
                //if (category == "J")
                //{
                //    objJobList.ForEach(s => s.FromPage = "J");
                //}
                //else
                //{
                //    objJobList.ForEach(s => s.FromPage = "G");
                //}
                model.Job = objJobList.Where(x => x.JobDescription.ToLower().Contains(_searchtext.ToLower().Trim()) || x.JobTitle.ToLower().Contains(_searchtext.ToLower().Trim()) || x.JobCompletionDateDisplay.ToLower().Contains(_searchtext.ToLower().Trim()) || x.FullName.ToLower().Contains(_searchtext.ToLower().Trim())).ToList().OrderByDescending(x=>x.JobId).Take(_RecordDisplay);
                
            }
            return Json(model.Job, JsonRequestBehavior.AllowGet);

        }
        [HttpPost]
        public JsonResult LoadMoreJobs(int id, string topskills, decimal budgetMin, decimal budgetMax, string populartags, string sortorder, string _searchtext)
        {
            GetCategory();
            int index1=0;
            int last=0;
            int _loadmore = 0;
            dynamic model = new ExpandoObject();
            objJob.JobCategoryId = Convert.ToInt32(Session["JobCatId"].ToString());
            objJob.SkillsList = topskills;
            objJob.MinBudget = budgetMin;
            objJob.MaxBudget = budgetMax;
            objJob.TrendingTagsIdList = populartags;
            objJob.SortBy = sortorder;
            objJob.FromPage = category;
             objJobList = MatchBxCommon.GenerateBadge(objJobMod.GetJobDetails(objJob));
            objJobList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
            if (sortorder == "H")
            {
                //objJobList = objJobList.OrderByDescending(x => x.BudgetASP).ThenByDescending(x => x.Rownumber).ToList();
                objJobList = objJobList.OrderByDescending(x => x.BudgetASP).ToList();
                index1 = objJobList.FindIndex(x => x.Rownumber == id);
                last = objJobList.LastIndexOf(objJobList.Last() );
            }
            else if (sortorder == "L")
            {
                //objJobList = objJobList.OrderByDescending(x => x.BudgetASP).ThenByDescending(x => x.Rownumber).ToList();
                objJobList = objJobList.OrderBy(x => x.BudgetASP).ToList();
                index1 = objJobList.FindIndex(x => x.Rownumber == id);
                last = objJobList.LastIndexOf(objJobList.Last());
            }
            else
            {
                //if (category == "J")
                //{
                //    objJobList = objJobList.OrderByDescending(x => x.JobId).ToList();
                //}
                //else {
                //    objJobList = objJobList.OrderBy(x => x.BudgetASPInt).ToList();
                //}
               
                    objJobList = objJobList.OrderByDescending(x => x.Rownumber).ToList();
               

            }
            //if (category == "J")
            //{
            //    objJobList.ForEach(s => s.FromPage = "J");
            //}
            //else
            //{
            //    objJobList.ForEach(s => s.FromPage = "G");
            //}
            if (!string.IsNullOrEmpty(_searchtext))
            {
                objJobList = objJobList.Where(x => x.Rownumber < id).ToList();
               _TotalRecord = objJobList.Where(x => x.JobDescription.ToLower().Contains(_searchtext.ToLower().Trim()) || x.JobTitle.ToLower().Contains(_searchtext.ToLower().Trim()) || x.JobCompletionDateDisplay.ToLower().Contains(_searchtext.ToLower().Trim()) || x.FullName.ToLower().Contains(_searchtext.ToLower().Trim())).ToList().Count();
                
                if (_TotalRecord > _RecordDisplay)
                {
                    _loadmore = 1;
                }
                else {
                    _loadmore = 0;
                }
                objJobList.Where(x => x.JobDescription.ToLower().Contains(_searchtext.ToLower().Trim()) || x.JobTitle.ToLower().Contains(_searchtext.ToLower().Trim()) || x.JobCompletionDateDisplay.ToLower().Contains(_searchtext.ToLower().Trim()) || x.FullName.ToLower().Contains(_searchtext.ToLower().Trim())).ToList().ForEach(s => s.Isloadmore = _loadmore);
                model.Job = objJobList.Where(x => x.JobId < id).ToList().Take(_RecordDisplay);
            }
            else
            {
                if (sortorder == "H")
                {
                    _TotalRecord = objJobList.Where(x => x.BudgetASP < budgetMax).ToList().Count();
                    if (last -_RecordDisplay > index1)
                    //if ( last-1 > index1)
                    {
                        _loadmore = 1;
                    }
                    else
                    {
                        _loadmore = 0;
                    }

                  model.Job = objJobList.Skip(index1 + 1).Take(_RecordDisplay);           // Only consider the next three values

                }
               else if (sortorder == "L")
                {
                    _TotalRecord = objJobList.Where(x => x.BudgetASP > budgetMax).ToList().Count();
                    if (last - _RecordDisplay > index1)
                    //if ( last-1 > index1)
                    {
                        _loadmore = 1;
                    }
                    else
                    {
                        _loadmore = 0;
                    }

                    model.Job = objJobList.Skip(index1 + 1).Take(_RecordDisplay);           // Only consider the next three values

                }
                else
                {
                    //if (category == "J")
                    //{
                        _TotalRecord = objJobList.Where(x => x.Rownumber < id).ToList().Count();
                        if (_TotalRecord > _RecordDisplay)
                        {
                            _loadmore = 1;
                        }
                        else
                        {
                            _loadmore = 0;
                        }
                        model.Job = objJobList.Where(x => x.Rownumber < id).ToList().Take(_RecordDisplay);
                    //}
                    //else { 
                    //    model.Job = objJobList.OrderBy(x => x.BudgetASPInt).Where(x => x.Rownumber > id).Take(_RecordDisplay);
                    //}
                }
                
                objJobList.ForEach(s => s.Isloadmore = _loadmore);
         
              
            }
            return Json(model.Job, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public JsonResult GetRates(int minval,int maxvalue)
        {
            decimal exchangerate = Convert.ToDecimal(Session["ExchangeRate"]);

            Budget model = new Budget();
            //model.Minval= Math.Round((minval * exchangerate), 2);

            //model.Maxval = Math.Round((maxvalue * exchangerate), 2);
            decimal min= Math.Round(((1 / exchangerate) * minval),2);
            model.Minval = min;
            decimal max = Math.Round(((1 / exchangerate) * maxvalue),2);
            model.Maxval = max;
            Session["mindollar"] = min;
            Session["maxdollar"] = max;
            return Json(model, JsonRequestBehavior.AllowGet);

        }
        [HttpPost]
        public JsonResult GetRatesinDollar(int minval, int maxvalue)
        {
            decimal exchangerate = Convert.ToDecimal(Session["ExchangeRate"]);
            Budget model = new Budget();
            model.MinvalDollar = Math.Round((minval * exchangerate),2);
            model.MaxvalDollar = Math.Round((maxvalue * exchangerate),2);
            return Json(model, JsonRequestBehavior.AllowGet);

        }
        [HttpPost]
        public JsonResult SetSearchCategory(string cat)
        {
            //AjaxSession obj = new AjaxSession();
            //obj.SessionString = cat;
            //if (Session["UserId"] != null)
            //{
            //    obj.UserId = Convert.ToInt32(Session["UserId"].ToString());
            //}
            //AjaxSessionModel ObjModel = new AjaxSessionModel();
            //ObjModel.Save(obj);
            Session["category"] = cat;
            return Json("", JsonRequestBehavior.AllowGet);
        }
        [NonAction]
        public void GetCategory()
        {
            //AjaxSession obj = new AjaxSession();
            //AjaxSessionModel ObjModel = new AjaxSessionModel();
            //if (Session["UserId"] != null)
            //{
            //    obj = ObjModel.GetList("*", "UserId=" + Convert.ToInt32(Session["UserId"].ToString())).FirstOrDefault();
            //    if (obj != null)
            //    {
            //        category = obj.SessionString;
            //    }
            //    else
            //    {
            //        category = "J";
            //    }
            //}
            //else
            //{
            //    obj = ObjModel.GetList("*", "UserId=0").FirstOrDefault();
            //    if (obj != null)
            //    {
            //        category = obj.SessionString;
            //    }
            //    else
            //    {
            //        category = "J";
            //    }
            //} 
            if (Session["category"] != null)
            {
                category = Session["category"].ToString();
            }

            else
            {
                category = "B";
            }

        }

        public class Budget
        {
           public decimal Minval { get; set; }
           public decimal Maxval { get; set; }
           public decimal MinvalDollar { get; set; }
           public decimal MaxvalDollar { get; set; }
        }
        public class SearchCriteria
        {
            public string topskills { get; set; }
            public decimal budgetMin { get; set; }
            public decimal budgetMax { get; set; }
            public string populartags { get; set; }
            public string sortorder { get; set; }
            public string _searchtext { get; set; }
        }
    }
}