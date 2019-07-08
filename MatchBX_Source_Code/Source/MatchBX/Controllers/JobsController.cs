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
using System.Configuration;
using System.IO;
using System.Collections;
using System.Web.Script.Serialization;
using MatchBX.Models;
using System.Globalization;

namespace MatchBX.Controllers
{
    [CustomExceptionFilter]

    public class JobsController : Controller
    {
        // GET: Jobs
        Job objJob = new Job();
        JobModel objJobMod = new JobModel();
        List<Job> objJobList = new List<Job>();
        TrendingTags objTrending = new TrendingTags();
        TrendingTagsModel objTrendingMod = new TrendingTagsModel();
        List<TrendingTags> objTrendingTagsList = new List<TrendingTags>();
        SkillsModel objSkillsMod = new SkillsModel();
        Skills objSkills = new Skills();
        List<JobCategory> objCategory = new List<JobCategory>();
        JobCategoryModel objCatMod = new JobCategoryModel();
        JobBidding objBidding = new JobBidding();
        List<JobBidding> objBiddingList = new List<JobBidding>();
        JobBiddingModel objBiddingMod = new JobBiddingModel();
        SocialMediaShareModel shareJobObj = new SocialMediaShareModel();
        SocialMediaShare shareObj = new SocialMediaShare();
        MatchBXNotification objNotification = new MatchBXNotification();
        MatchBXNotificationModel objNotiMod = new MatchBXNotificationModel();
        UsersModel objUsersMod = new UsersModel();
        string sourceFolderPath = ConfigurationManager.AppSettings["PathForProjectDocuments"].ToString();
        int _RecordDisplay =5;
        int _TotalRecord = 0;
        int _loadmore = 0;
        string category = string.Empty;

        [NoCache]
        public ActionResult Index(int? id)
        {
            if (Session["IsEmailAlready"] != null)
            {
                ViewBag.IsEmailAlready = "Y";
                Session["IsEmailAlready"] = null;
            }
            else {
                //Session["IsEmailAlready"] = "N";
                ViewBag.IsEmailAlready = "N";
                Session["IsEmailAlready"] = null;
            }
            dynamic model = new ExpandoObject();
            if (Session["FromDetails"] != null && Session["DynModel"] != null)
            {
                model = (dynamic)Session["DynModel"];
                model.TopJobPosters = (List<Job>)Session["TopJobPosters"];
                model.VerifiedPartners = (List<Job>)Session["VerifiedPartners"];
                model.TrendingTags = (List<TrendingTags>)Session["TrendingTags"];
                Session["FromDetails"] = null;
                Session["DynModel"] = null;
            }
            else
            {
                if (id.GetValueOrDefault() == 0)
                {
                    objJob.TrendingTagsIdList = "0";
                }
                else
                {
                    objJob.TrendingTagsIdList = id.GetValueOrDefault().ToString();
                    ViewBag.CurrentTag = id.GetValueOrDefault().ToString();
                }
                objJob.SkillsList = "0";
                List<Job> _JobList = new List<Job>();
                objJob.SortBy = "B";
                GetCategory();
                objJob.FromPage = category;
                //if (Session["UserId"] != null)
                //{
                //    objJob.FromPage = "J";
                //}
                //else
                //{
                //    objJob.FromPage = "B";
                //}  

                _JobList = objJobMod.GetJobDetails(objJob).OrderByDescending(x => x.Rownumber).ToList();
               
                if (_JobList.Count == 1)
                {
                    ViewBag.MetaTag = HomeMetaTags(_JobList[0].JobTitle.ToString(), _JobList[0].JobDescription.ToString());
                }
                else if(_JobList.Count > 1)
                {
                    ViewBag.MetaTag = HomeMetaTags("Hire freelancers, pay in cryptocurrency", "Complete jobs to earn AXPR, or post a job and have great freelancers come to you");
                }

                _TotalRecord = _JobList.Count();
                if (_TotalRecord > _RecordDisplay)
                {
                    _loadmore = 1;
                }
                else
                {
                    _loadmore = 0;
                }


                _JobList.ForEach(x => x.Isloadmore = _loadmore);
                _JobList = _JobList.Take(_RecordDisplay).ToList();
                model.Job = MatchBxCommon.GenerateBadge(_JobList);
                model.TopJobPosters = objJobMod.GetTopJobPosters(objJob);
                model.VerifiedPartners = objJobMod.GetVerifiedPartners(objJob);
                Session["TopJobPosters"] = model.TopJobPosters;
                //if (Session["UserId"] != null)
                //{
                //    objTrending.FromPage = "J";
                //}
                //else
                //{
                //    objTrending.FromPage = "B";
                //}
                // GetCategory();
                objTrending.FromPage = category;
                model.TrendingTags = objTrendingMod.GetTrendingTags(objTrending);
                Session["TrendingTags"] = model.TrendingTags;
                Session["JobCategoryName"] = "";
                Session["JobCategoryId"] = 0;
                //TempData["TrendingTagsFooter"] = MatchBxCommon.GetTrendingTagsFooter();

            }
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

            TempData["TrendingTagsFooter"] = MatchBxCommon.GetTrendingTagsFooter(objTrending.FromPage);
            return View("Index", model);
        }



        public string HomeMetaTags(string JobTitle,string JobDescription)
        {
            System.Text.StringBuilder strMetaTag = new System.Text.StringBuilder();
            string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
            strMetaTag.AppendFormat(@"<meta name='Keywords' content='{0}' itemprop='keywords' />", JobTitle);
            strMetaTag.AppendFormat(@"<meta name='description' content='{0}' itemprop='description' />", JobDescription);
            strMetaTag.AppendFormat(@"<meta property ='og: tags' />");
            strMetaTag.AppendFormat(@"<meta property ='og:site_name' content ='MatchBX' />");
            strMetaTag.AppendFormat(@"<meta property ='og: title' content='{0}'/>", JobTitle);
            strMetaTag.AppendFormat(@"<meta property ='og:image' content='" + imgUrl + "'/>");
            strMetaTag.AppendFormat(@"<meta property ='og:image:type' content='image/png'/>");
            strMetaTag.AppendFormat(@"<meta property ='og:image:alt' content='{0}'/>", JobTitle);
            strMetaTag.AppendFormat(@"<meta property ='og:image:width' content='50'/>");
            strMetaTag.AppendFormat(@"<meta property ='og:image:height' content='25'/>");
            strMetaTag.AppendFormat(@"<meta property ='og:description' content='{0}'/>", JobDescription);

            strMetaTag.AppendFormat(@"<meta name ='twitter:card' content='summary'/>");
            strMetaTag.AppendFormat(@"<meta name ='twitter:title' content='{0}'/>", JobTitle);
            strMetaTag.AppendFormat(@"<meta property ='twitter:image:src' content='" + imgUrl + "'/>");
            strMetaTag.AppendFormat(@"<meta name ='twitter:description' content='{0}'/>", JobDescription);

            return strMetaTag.ToString();
        }


        [HttpPost]
        public JsonResult PostedJobs(string _searchtext, string trendingtagsid)
        {
            dynamic model = new ExpandoObject();

            //
            //if (id.GetValueOrDefault() == 0)
            //{
                objJob.TrendingTagsIdList = "0";
            //}
            //else
            //{
                objJob.TrendingTagsIdList = "0";    //id.GetValueOrDefault().ToString();
                //ViewBag.CurrentTag = id.GetValueOrDefault().ToString();
            //}
            objJob.SkillsList = "0";
            //List<Job> _JobList = new List<Job>();
            objJob.SortBy = "B";    // "N";    // "B";
            //GetCategory();
            objJob.FromPage = "B";  // category;
            //if (Session["UserId"] != null)
            //{
            //    objJob.FromPage = "J";
            //}
            //else
            //{
            //    objJob.FromPage = "B";
            //}
            //

            ////objJob.TrendingTagsIdList = trendingtagsid;
            ////objJob.SkillsList = "0";
            ////objJob.SortBy = "N";

            //if (Session["UserId"] != null)
            //{
            //    objJob.FromPage = "J";
            //}
            //else
            //{
            //    objJob.FromPage = "B";
            //}
            ////GetCategory();
            ////objTrending.FromPage = category;

            List<Job> _JobList = new List<Job>();
            
            objJobList = MatchBxCommon.GenerateBadge(objJobMod.GetJobDetails(objJob).OrderByDescending(x => x.Rownumber).ToList());
            _JobList = objJobList;
            if (string.IsNullOrWhiteSpace(_searchtext))
            {
                _TotalRecord = _JobList.Count();
                if (_TotalRecord > _RecordDisplay)
                {
                    _loadmore = 1;
                }
                else
                {
                    _loadmore = 0;
                }
                _JobList.ForEach(x => x.Isloadmore = _loadmore);
                model.Job = _JobList.Take(_RecordDisplay).ToList();
            }
           else
            {
               
                _JobList = objJobList.Where(p => p.JobDescription != null && p.JobDescription.ToLower().Contains(_searchtext.ToLower().Trim()) || p.JobTitle != null && p.JobTitle.ToLower().Contains(_searchtext.ToLower().Trim()) || p.JobCompletionDateDisplay != null && p.JobCompletionDateDisplay.ToLower().Contains(_searchtext.ToLower()) || p.TrendingTagsIdList!=null && p.TrendingTagsIdList.ToLower().Contains(_searchtext.ToLower())).ToList();
                _TotalRecord = _JobList.Count();
                if (_TotalRecord > _RecordDisplay)
                {
                    _loadmore = 1;
                }
                else
                {
                    _loadmore = 0;
                }
               _JobList = _JobList.Take(_RecordDisplay).ToList();
               _JobList.ForEach(x=>x.Isloadmore=_loadmore);
                model.Job = _JobList.Take(_RecordDisplay).ToList();
            }
            Session["DynModel"] = model;
          
            return Json(model.Job, JsonRequestBehavior.AllowGet);
        }
        [HttpGet]
        public ActionResult GetAutomatedSearch()
        {
            return View();
        }
        [HttpPost]
        public JsonResult GetAutomatedSearch(string _searchtext)
        {
            JobModel _objMod = new JobModel();
            dynamic model = new ExpandoObject();
            Job _objBus = new Job();
            _objBus.searchText = _searchtext;
            //_objBus.FromPage = "B";
            //if (Session["UserId"] != null)
            //{
            //    _objBus.FromPage = "J";
            //}
            //else
            //{
            //    _objBus.FromPage = "B";
            //}
             GetCategory();
            _objBus.FromPage = category;

            List<Job> _JobList = new List<Job>();
            _JobList = _objMod.GetAutomatedJobsForTrendingTags(_objBus);
            return Json(_JobList, JsonRequestBehavior.AllowGet);

        }

        [HttpPost]
        public JsonResult LoadMoreJobs(int id,string _searchtext, string trendingtagsid)
        {
            dynamic model = new ExpandoObject();
            objJob.TrendingTagsIdList = trendingtagsid == "" ? "0" : trendingtagsid;
            objJob.SkillsList = "0";
            objJob.SortBy = "N";
            //if (Session["UserId"] != null)
            //{
            //    objJob.FromPage = "J";
            //}
            //else
            //{
            //    objJob.FromPage = "B";
            //}
            GetCategory();
            objJob.FromPage = category;
            List<Job> _JobList = new List<Job>();

            objJobList = MatchBxCommon.GenerateBadge(objJobMod.GetJobDetails(objJob).OrderByDescending(x => x.Rownumber).ToList());
            objJobList = objJobList.Where(x => x.Rownumber < id).ToList();
            if (!string.IsNullOrEmpty(_searchtext))
            {
                _JobList = objJobList.Where(p => p.JobDescription != null && p.JobDescription.ToLower().Contains(_searchtext.ToLower().Trim())||p.JobTitle!=null && p.JobTitle.ToLower().Contains(_searchtext.ToLower().Trim())||p.JobCompletionDateDisplay!=null && p.JobCompletionDateDisplay.ToLower().Contains(_searchtext.ToLower()) || p.TrendingTagsIdList != null && p.TrendingTagsIdList.ToLower().Contains(_searchtext.ToLower())).ToList();
               
                _TotalRecord = _JobList.Count();
                if (_TotalRecord > _RecordDisplay)
                {
                    _loadmore = 1;
                }
                else
                {
                    _loadmore = 0;
                }
                _JobList.ForEach(x => x.Isloadmore = _loadmore);
                model.Job = _JobList.Take(_RecordDisplay);
               
            }
            else
            {
               
                _JobList = objJobList;
                _TotalRecord = _JobList.Count();
                if (_TotalRecord > _RecordDisplay)
                {
                    _loadmore = 1;
                }
                else
                {
                    _loadmore = 0;
                }
                _JobList.ForEach(x => x.Isloadmore = _loadmore);
                model.Job = _JobList.Take(_RecordDisplay);
            }
         
            return Json(model.Job, JsonRequestBehavior.AllowGet);
        }

        [NoCache]
        [SessionExpire]
        public ActionResult PostJob(int ?id)
        {
                Session["ExRate"] = MatchBxCommon.GetExchangeRate();
                dynamic model = new ExpandoObject();
                int jobid = id.GetValueOrDefault();
                TempData["Category"] = objCatMod.GetList();
                TempData["Tags"] = new List<TrendingTags>();
                TempData["Skills"] = new List<Skills>();
                //GetTagsnSkills(0);
                if (jobid != 0)
                {
                    objJobList = objJobMod.GetJobPost(jobid);
                if (objJobList.Count() > 0)
                {
                    TrendingTagsModel _TrendingTagsModel = new TrendingTagsModel();
                    SkillsModel _SkillsModel = new SkillsModel();
                    //TempData["Tags"] = objJobMod.GetTrendingTags(objJobList[0].JobCategoryId);
                    //TempData["Skills"] = objJobMod.GetTopSkills(objJobList[0].JobCategoryId);
                    if (jobid != 0)
                    {
                        TempData["Tags"] = _TrendingTagsModel.GetList(" * ", " JobCategoryId = " + objJobList[0].JobCategoryId);
                    }
                    else
                    {
                        TempData["Tags"] = _TrendingTagsModel.GetList(" * ", " JobCategoryId = " + objJobList[0].JobCategoryId + " and TagType = 'S'");
                    }
                    TempData["Skills"] = _SkillsModel.GetList(" * ", " JobCategoryId = " + objJobList[0].JobCategoryId);
                    objJobList.FirstOrDefault().JobSkillsMappingList = objJobMod.GetSkillsByJobId(jobid);
                    objJobList.FirstOrDefault().JobTrendingTagsMappingList = objJobMod.GetTagsByJobId(jobid);
                    objJobList.FirstOrDefault().JobDocumentsList = objJobMod.GetDocumentsByJobId(jobid);
                    objJob = objJobList.FirstOrDefault();
                    objJob.BudgetInDollar = objJob.BudgetASP;
                    objJob.BudgetASP = objJob.BudgetASP * (decimal)Session["ExRate"];
                    objJob.BudgetASPString = "$ " + objJob.BudgetASP.ToString("#,##0.00");
                    objJob.JobId = Convert.ToInt32(id);
                    TempData["SelectedTags"] = objJob.JobTrendingTagsMappingList;
                    TempData["SelectedSkills"] = objJob.JobSkillsMappingList;
                    Session["TrendingTagsList"] = objJob.JobTrendingTagsMappingList;
                    Session["SkillsList"] = objJob.JobSkillsMappingList;

                }

            }
            return View("PostJob", objJob);

        }

        [NoCache]
        [SessionExpire]
        [HttpPost]
        public ActionResult SaveJob(Job job)
        {
            
            string message = "";

            if (ModelState.IsValid)
            {
                //job.JobTitle = ToCamelCase(job.JobTitle);
                if (Convert.ToInt32(job.JobTrendingTagsMappingList.Count) == 0)
                {
                    if (Session["TrendingTagsList"] != null)
                    {

                        job.JobTrendingTagsMappingList = (List<JobTrendingTagsMapping>)Session["TrendingTagsList"];
                    }
                }

                if (Convert.ToInt32(job.JobSkillsMappingList.Count) == 0)
                {
                    if (Session["SkillsList"] != null)
                    {

                        job.JobSkillsMappingList = (List<JobSkillsMapping>)Session["SkillsList"];
                    }
                }


                job.UserId = Convert.ToInt32(Session["UserId"]);


                List<JobDocuments> fileList = new List<JobDocuments>();

                if (TempData["fileList"] != null)
                {
                    fileList = (List<JobDocuments>)TempData.Peek("fileList");
                }

                if (job != null)
                {
                    if (Convert.ToInt32(job.JobDocumentsList.Count) == 0)
                    {
                        if (fileList != null)
                        {
                            foreach (var file in fileList)
                            {
                                job.JobDocumentsList.Add(new JobDocuments() { DocumentName = file.DocumentName.ToString(), IsActive = "Y", Filesize = file.Filesize });
                            }
                        }
                    }

                }

                var _tagsObjModel = new TrendingTagsModel();
                foreach(var item in job.JobTrendingTagsMappingList)
                {
                    if(item.TrendingTagsId == 0)
                    {
                        var _trendingTag = new TrendingTags() {
                            Description = item.Description,
                            TrendingTagsId = item.TrendingTagsId,
                            JobCategoryId = job.JobCategoryId,
                            TagType = "U"
                        };
                        item.TrendingTagsId = objTrendingMod.Save(_trendingTag);
                    }
                }
                var jobId = 0;
                if ((jobId = objJobMod.SaveWithTransaction(job)) > 0)
                {
                    if (Session["UserType"] != null && Session["UserType"].ToString() == "1")
                    {
                        Session["UserType"] = "3";
                        UsersModel _Model = new UsersModel();
                        Users _userobj = new Users();
                        _userobj.UserId = Convert.ToInt32(Session["UserId"]);
                        _userobj.UserType = Session["UserType"].ToString();
                       int k=  _Model.ChangeUserRole(_userobj);

                    }
                    if (job.JobId > 0)
                    {
                        message = "Your job has been edited and is now pending for approval";
                        MatchBxCommon.sendJobPostedEmailToAdmin(2, job.JobTitle, job.JobId);
                        TempData["postJob"] = job.JobId;
                        TempData["DeleteJob"] = 0;
                    }
                    else
                    {
                       // message = "Your job has been posted and is now live";
                        message = "Your job has been posted and is now pending for approval";
                        MatchBxCommon.sendJobPostedEmailToAdmin(1, job.JobTitle, jobId);
                        TempData["postJob"] = 0;
                        TempData["DeleteJob"] = 0;
                    }

                    TempData.Remove("fileList");
                    Session["FileList"] = null;
                    Session["JobPosted"] = "Y";

                }
                else
                {
                    if (job.JobId > 0)
                    {
                        message = "Failed to edit job";
                    }
                    else
                    {
                        message = "Failed to post job";
                    }

                    TempData.Remove("fileList");
                    Session["FileList"] = null;

                    Session["JobPosted"] = "N";

                }
                if (Convert.ToInt32(Session["UserType"]) != 3)
                {
                    Session["FirstLogin"] = "N";
                }

            }
            else
            {
                message = "Failed to post job";

                TempData.Remove("fileList");
                Session["FileList"] = null;
                Session["JobPosted"] = "N";
                Session["FirstLogin"] = "N";
            }

             return Json(message, JsonRequestBehavior.AllowGet);
           
        }

        [NoCache]
        [SessionExpire]
        public ActionResult UploadDocuments()
        {
           

            bool isSavedSuccessfully = true;
            string fName = "";
            List<JobDocuments> _list = new List<JobDocuments>();
            foreach (string fileName in Request.Files)
            {
                HttpPostedFileBase file = Request.Files[fileName];
                if (file != null)
                {
                    String _fileName = Path.GetFileNameWithoutExtension(file.FileName);
                    String extension = Path.GetExtension(file.FileName);
                    var InputFileName = _fileName + DateTime.Now.ToString("-yyyy-MM-dd-HH-mm-ss") + extension;
                    var ServerSavePath = Path.Combine(sourceFolderPath + InputFileName);
                    try
                    {
                        file.SaveAs(ServerSavePath);
                        double size = (double)(file.ContentLength / 1024);

                        if (Session["FileList"] != null)
                        {

                            _list = (List<JobDocuments>)(Session["FileList"]);
                            _list.Add(new JobDocuments { DocumentName = InputFileName, Filesize = size });
                        }
                        else
                        {
                            _list.Add(new JobDocuments { DocumentName = InputFileName, Filesize = size });
                        }
                        Session["FileList"] = _list;
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("Exception caught: {0}", ex);
                    }
                  
                   
  
                    TempData["fileList"] = Session["FileList"];

                }

            }

            if (isSavedSuccessfully)
            {
                return Json(new { Message = fName });
            }
            else
            {
                return Json(new { Message = "Error in saving file" });
            }
        }

        [NoCache]
        [SessionExpire]
        public ActionResult DeleteJob(Job job)
        {
            string message = "";
            job.IsActive = "N";
            if(objJobMod.DeleteJob(job)>0)
            {
                message = "Job Deleted";
                TempData["DeleteJob"] = 1;
                TempData["postJob"] = 0;
            }
            else
            {
                message = "Failed to delete job post";
                TempData["DeleteJob"] = 0;
                TempData["postJob"] = 0;
            }
            return Json(message, JsonRequestBehavior.AllowGet);
        }
        public ActionResult GetTagsnSkills(int category, int jobId)
        {
            //TempData["Tags"] = objJobMod.GetTrendingTags(category);
            TrendingTagsModel _TrendingTagsModel = new TrendingTagsModel();
            SkillsModel _SkillsModel = new SkillsModel();
            Job _objJobList = new Job();
            if (jobId != 0)
            {                
                _objJobList.TrendingTagsList = _TrendingTagsModel.GetList(" * ", " JobCategoryId = " + category);
                TempData["Tags"] = _objJobList.TrendingTagsList;
            } else
            {                
                _objJobList.TrendingTagsList = _TrendingTagsModel.GetList(" * ", " JobCategoryId = " + category + " and TagType = 'S'");
                TempData["Tags"] = _objJobList.TrendingTagsList;
            }
            //TempData["Skills"] = objJobMod.GetTopSkills(category);

            //_objJobList.TrendingTagsList =  objJobMod.GetTrendingTags(category);

            //_objJobList.JobSkillsList = objJobMod.GetTopSkills(category);
            _objJobList.JobSkillsList = _SkillsModel.GetList(" * ", " JobCategoryId = " + category);
            TempData["Skills"] = _objJobList.JobSkillsList;
            return Json(_objJobList, JsonRequestBehavior.AllowGet);
        }

        public ActionResult UploadFiles(HttpPostedFileBase[] file)
        {
            ArrayList fileList = new ArrayList();
            if (ModelState.IsValid)
            {
                foreach (HttpPostedFileBase _file in file)
                {
                    if (_file != null)
                    {
                        String fileName = Path.GetFileNameWithoutExtension(_file.FileName);
                        String extension = Path.GetExtension(_file.FileName);
                        var InputFileName = fileName + DateTime.Now.ToString("-yyyy-MM-dd-HH-mm-ss") + extension;
                        var ServerSavePath = Path.Combine(sourceFolderPath + InputFileName);
                        try
                        {
                            _file.SaveAs(ServerSavePath);
                            fileList.Add(InputFileName);

                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine("Exception caught: {0}", ex);
                        }
                        TempData["fileList"] = fileList;

                    }

                }
                return Json(true, JsonRequestBehavior.AllowGet);
            }
            return Json(false, JsonRequestBehavior.AllowGet);
        }

        public ActionResult CalculateBudgetinDollar(string budget)
        {
            try
            {
                decimal bidbudget = Convert.ToDecimal(budget);
                decimal exchangerate = MatchBxCommon.GetExchangeRate();
                decimal budgetindollar = bidbudget / exchangerate;
                return Json(budgetindollar, JsonRequestBehavior.AllowGet);
            }
            catch(Exception ex)
            {
                return Json("Exception", JsonRequestBehavior.AllowGet);
            }
        }
        public ActionResult CalculateBudgetinDollarPostJob(string budget)
        {
            try
            {
                decimal bidbudget = Convert.ToDecimal(budget);
                decimal exchangerate = Convert.ToDecimal(Session["ExRate"]);
                decimal budgetindollar = exchangerate * bidbudget;
                return Json(budgetindollar, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json("Exception", JsonRequestBehavior.AllowGet);
            }


        }

        [NoCache]
        [SessionExpire]
        [HttpPost]
        [AllowAnonymous]
      
        public ActionResult BidJob(decimal bidamount, int bidDuration, string bidmessage, int jobid, int bidid,int jobposterid,string jobtitle, int _TokenDistributionId, string _AccountInfo)
        {
            Users _objuser = new Users();
            objBidding.UserId = Convert.ToInt32(Session["UserId"]);
            objBidding.BidAmount = bidamount;
            objBidding.BidDuration = bidDuration;
            objBidding.BidMessage = bidmessage;
            objBidding.JobId = jobid;
            objBidding.JobBiddingId = bidid;
            objBidding.IsAccepted = "N";
            objBidding.IsActive = "Y";
           string BidUserName = "@"+Session["UserName"].ToString();
            decimal bidAmount = bidamount;
            string message = "";
            if (objBiddingMod.Save(objBidding)>0)
            {

                if (bidmessage != string.Empty)
                {
                    MatchBXMessage _objMessage = new MatchBXMessage();
                    MatchBXMessageModel _objMessageModel = new MatchBXMessageModel();

                    _objMessage.SendUserId = Convert.ToInt32(Session["UserId"]);
                    _objMessage.Message = bidmessage;
                    _objMessage.ReceiverId = jobposterid;
                    _objMessage.ReadStatus = 0;
                    _objMessage.MessageType = "J";
                    _objMessage.FileSize = 0;
                    _objMessage.FileName = "";
                    _objMessage.JobId = jobid;

                    _objMessageModel.Save(_objMessage);
                }
                

                if (MatchBxCommon.checkuseremailpreferences("4,5", Convert.ToInt32(Session["UserId"])) ==true)
                {
                    _objuser = objUsersMod.GetList("*", " UserId = '" + jobposterid + "'").FirstOrDefault();
                    string email = _objuser.Email;
                  
                    string fullname = _objuser.FullName != null ? _objuser.FullName : _objuser.UserName;
                    //string fullname = objUsersMod.FullName != null ? objUser.FullName : objUser.UserName;
                    MatchBxCommon.sendBidOfferEmail(email, false,BidUserName,jobtitle, bidAmount,fullname);
                }
                objJob = objJobMod.GetList("*", " JobId = '" + jobid + "'").FirstOrDefault();
                objJob.JobStatus = "B";
                if(objJobMod.Save(objJob)>0)
                {
                    TokenDistributionModel _TokenDistributionModel = new TokenDistributionModel();
                    TokenDistribution _TokenDistribution = new TokenDistribution();

                    if (_TokenDistributionId > 0)
                    {
                        _TokenDistribution = _TokenDistributionModel.GetList("*", " TokenDistributionId = '" + _TokenDistributionId + "'").FirstOrDefault();
                        _TokenDistribution.TokenAddress = _AccountInfo;
                    }
                    else
                    {
                        _TokenDistribution.TokenDistributionId = 0;
                        _TokenDistribution.JobBiddingId = objBiddingMod.Id;
                        _TokenDistribution.TokenAddress = _AccountInfo;
                        _TokenDistribution.UserId = Convert.ToInt32(Session["UserId"]);
                        _TokenDistribution.IsApproved = "N";
                    }
                    if (_TokenDistributionModel.Save(_TokenDistribution) > 0)
                    {
                        message = "Success";
                    }
                    else
                    {
                        message = "Failed";
                    }
                }
                else
                {
                    message = "Failed";
                }
            }
            else
            {
                message = "Failed";
            }
            return Json(message,JsonRequestBehavior.AllowGet);
        }
        [NoCache]
        //[SessionExpire]
        public ActionResult Details(int? id, string type = "")
        {
            TempData["TrendingTagsFooter"] = MatchBxCommon.GetTrendingTagsFooter();
            TempData["BidMessage"] = "";
            TempData["BidAmount"] = "";
            TempData["AXPRFeeAmt"] = "0.00";
            TempData["AXPRFeeTotAmt"] = "";
            TempData["BidAmountinDollar"] = "";
            TempData["JobBiddingId"] = "";
            Session["Expired"] = "N";
            Session["FromDetails"] = "Y";
            //if(Session["JobCategoryName"]==null || Session["JobCategoryName"].ToString()=="")
            //{
            //    Session["JobCategoryName"] = "";
            //}
            dynamic model = new ExpandoObject();
            //Session["ProfilePic"] = "/Content/images/client_pic_1.png";

            int jobid = id.GetValueOrDefault();
            Session["JobId"] = jobid;
            if (jobid != 0)
            {
                objJobList = MatchBxCommon.GenerateBadge(objJobMod.GetJobPost(jobid));
                if (objJobList.Count() > 0)
                {

                    ViewBag.MetaTag = HomeMetaTags(objJobList[0].JobTitle.ToString(), objJobList[0].JobDescription.ToString());

                    objJobList.FirstOrDefault().JobSkillsMappingList = objJobMod.GetSkillsByJobId(jobid);
                    objJobList.FirstOrDefault().JobTrendingTagsMappingList = objJobMod.GetTagsByJobId(jobid);
                    objJob = objJobList.FirstOrDefault();
                    JobModel _ObjModel = new JobModel();
                    decimal exchangerate1 = MatchBxCommon.GetExchangeRate();
                    if (type == "A")
                    {
                        objJob.CurrentOffersList = _ObjModel.GetCurrentBidsForJob(new Job { JobId = jobid });
                        objJob.CurrentOffersList.ForEach(x => x.DollarCount = Math.Round(exchangerate1 * (x.BidAmount), 2));
                    }
                    else if(type == "C")
                    {
                        objJob.DeclinedOffersList = _ObjModel.GetDeclinedBidsForJob(new Job { JobId = jobid });
                        objJob.DeclinedOffersList.ForEach(x => x.DollarCount = Math.Round(exchangerate1 * (x.BidAmount), 2));
                    }
                    Session["JobPoster"] = objJob.UserId;
                
                    Session["JobCategory"] = CultureInfo.CurrentCulture.TextInfo.ToTitleCase(objJob.Category.ToLower());
                    Session["JobCategoryHeader"] = CultureInfo.CurrentCulture.TextInfo.ToTitleCase(objJob.Category.ToLower());

                    if (Session["JobCategoryId"].ToString() == "0")
                    {
                        Session["JobCategoryName"] = CultureInfo.CurrentCulture.TextInfo.ToTitleCase("ALL JOBS".ToLower());
                    }
                    else
                    {
                        Session["JobCategoryName"] = CultureInfo.CurrentCulture.TextInfo.ToTitleCase(objJob.Category.ToLower());
                    }

                    TimeSpan span = objJob.JobCompletionDate.Subtract(DateTime.Now);
                    string EndingIn = (span.Days + 1) + " DAYS, " + (span.Hours + 1) + " HOURS, " + span.Minutes + " MINS";
                    if (span.Days == 0 ||  objJob.JobStatus == "P" )
                    {
                        Session["Expired"] = "N";
                        EndingIn = (span.Days + 1) + " DAYS, " + Math.Abs(span.Hours + 1) + " HOURS, " +Math.Abs(span.Minutes) + " MINS";
                    }
                   else  if (span.Days < 0 || span.Hours < 0 || span.Minutes < 0 || objJob.JobStatus == "A" || objJob.JobStatus == "C" || objJob.JobStatusSeeker == "C")
                    {
                        Session["Expired"] = "Y";
                    }
                    TempData["EndingIn"] = EndingIn;
                    if (Convert.ToInt32(Session["UserId"]) != objJob.UserId)
                    {
                        JobBidding _JobBidding = new JobBidding();
                        _JobBidding.UserId = Convert.ToInt32(Session["UserId"]);
                        _JobBidding.JobId = objJob.JobId;

                        objBiddingList = objBiddingMod.LoadJobBiddingDetails(_JobBidding);
                        if (objBiddingList.Count() > 0)
                        {
                            decimal exchangerate = MatchBxCommon.GetExchangeRate();
                            TempData["BidMessage"] = objBiddingList.FirstOrDefault().BidMessage;
                            TempData["BidAmount"] = "$ " + (objBiddingList.FirstOrDefault().BidAmount * exchangerate).ToString("#,##0.00");
                            TempData["BidDuration"] = objBiddingList.FirstOrDefault().BidDuration;
                            decimal bid = Convert.ToDecimal(objBiddingList.FirstOrDefault().BidAmount);
                            decimal perc = (Convert.ToDecimal(bid) * 3) / 100;
                            TempData["AXPRFeeAmt"] = perc.ToString("#,##0.00");
                            
                            string totalfees= (bid - perc).ToString("#,##0.00");
                            TempData["AXPRFeeTotAmt"] = totalfees;
                            
                            TempData["BidAmountinDollar"] = objBiddingList.FirstOrDefault().BidAmount.ToString("#,##0.00");
                            TempData["JobBiddingId"] = objBiddingList.FirstOrDefault().JobBiddingId;
                            TempData["TokenDistributionId"] = objBiddingList.FirstOrDefault().TokenDistributionId;
                            TempData["IsPendingStatus"] = objBiddingList.FirstOrDefault().IsPending;
                        }
                        else
                        {
                            decimal exchangerate = MatchBxCommon.GetExchangeRate();
                            TempData["IsPendingStatus"] = "N";
                            TempData["BidAmount"]  = "$ " + (objJob.BudgetASP * exchangerate).ToString("#,##0.00");
                            TempData["BidDuration"] = 0;
                            decimal bid = Convert.ToDecimal(objJob.BudgetASP);
                            decimal perc = (Convert.ToDecimal(bid) * 3) / 100;
                            TempData["AXPRFeeAmt"] = perc.ToString("#,##0.00");

                            string totalfees = (bid - perc).ToString("#,##0.00");
                            TempData["AXPRFeeTotAmt"] = totalfees;
                            TempData["BidAmountinDollar"] = objJob.BudgetASP.ToString("#,##0.00");
                        }
                    }

                    //objJob.ShareJob = shareJobObj.GetShareDetails(jobid, Convert.ToInt32(Session["UserId"]));
                    //if(objJob.ShareJob == null)
                    //{
                    //    objJob.ShareJob = new SocialMediaShare();
                    //    objJob.ShareJob.JobId = jobid;
                    //    objJob.ShareJob.UserId = Convert.ToInt32(Session["UserId"]);
                    //    objJob.ShareJob.FBShare = null;
                    //    objJob.ShareJob.TwitterShare = null;
                    //}
                }

            }
            return View("Details", objJob);
        }

        [HttpGet]
        public ActionResult GetContractDetails()
        {
            var data = "Failed";
            ContractDetailModel _ContractDetailModel = new ContractDetailModel();
            ContractDetail _ContractDetail = _ContractDetailModel.GetList(" * ", "" ).FirstOrDefault();
            if (_ContractDetail != null)
            {
                //data = new JavaScriptSerializer().Serialize(_ContractDetail);
                return Json(_ContractDetail, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(data, JsonRequestBehavior.AllowGet);
            }

        }

        public ActionResult ShareJob(SocialMediaShare share)
        {
            if(share.JobId != 0 && share.UserId !=0 && (share.FBShare != null || share.TwitterShare != null))
            {
                shareJobObj.Save(share);
                var message = "";
                if(share.FBShare == "Y")
                {
                    message = "Job successfully shared to Facebook.";
                } else if(share.TwitterShare == "Y")
                {
                    message = "Job successfully shared to Twitter.";
                } else
                {
                    message = "Job successfully shared.";
                }
                return Json(message, JsonRequestBehavior.AllowGet);
            } else
            {
                return Json("Failed", JsonRequestBehavior.AllowGet);
            }
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
        //public string ToCamelCase(string the_string)
        //{
        //    // If there are 0 or 1 characters, just return the string.
        //    if (the_string == null || the_string.Length < 2)
        //        return the_string;

        //    // Split the string into words.
        //    string[] words = the_string.Split(
        //        new char[] { },
        //        StringSplitOptions.RemoveEmptyEntries);

        //    // Combine the words.
        //    string result = words[0].ToLower();
        //    for (int i = 1; i < words.Length; i++)
        //    {
        //        result +=
        //            words[i].Substring(0, 1).ToUpper() +
        //            words[i].Substring(1);
        //    }

        //    return result;
        //}
    }
}