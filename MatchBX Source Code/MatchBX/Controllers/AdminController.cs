using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MatchBx.Utilities;
using Business;
using Model;
using System.Dynamic;
using System.Text.RegularExpressions;
//using Newtonsoft.Json;
//using System.Globalization;

namespace MatchBX.Controllers
{
    public class AdminController : Controller
    {
        AdminFeatures _objadmFeaturesbus = new AdminFeatures();
        ManageJob _objManageJob = new ManageJob();

        AdminFeatureModel _objadmFeatureModel = new AdminFeatureModel();
        List<AdminFeatures> _lstAdminfeatureFilt = new List<AdminFeatures>();
        List<AdminFeatures> _lstAdminfeature = new List<AdminFeatures>();
        List<ManageJob> _lstManageJob = new List<ManageJob>();
        List<ManageJob> _lstManageJobFilter = new List<ManageJob>();

        Users _objUsers = new Users();
        UsersModel _objUserModel = new UsersModel();
        UserBlockingModel _objUsrBlockModel = new UserBlockingModel();

        JobCancellation _objCancelReasons = new JobCancellation();
        JobModel _ObjJobModel = new JobModel();
        GigModel _ObjGigModel = new GigModel();

        Job jobObject = new Job();
        JobModel jobModel = new JobModel();
        List<Job> jobList = new List<Job>();
        Analytics analyticsObj = new Analytics();
        int ReviewRecord = 0;
        int reviewloadmore = 0;
        int recordDisplay = 5;

        public enum JobLevel
        {
            Posted = 'P',
            Bid = 'B',
            Assigned = 'A',
            Completed = 'C',
            Review = 'R',
            Failed = 'F',
        };
        public enum JobReviewStatus
        {
            Accepted = 'A',            
            Rejected = 'R',
        };
        public enum GigLevel
        {
            Posted = 'P',
            Review = 'R',
            Failed = 'F',
        };
        public enum GigReviewStatus
        {
            Accepted = 'A',
            Rejected = 'R',
        };

        // GET: Admin
        dynamic model = new ExpandoObject();
        int loadMore;
        int RecordstoDisplay = 5;
        public ActionResult Index(int ? id,int ?jid)
        {
            if (Session["UserType"] == null || Session["UserType"].ToString() != "4")
            {
                TempData["jid"] = jid.GetValueOrDefault();
                //?redirecturl = "+ "Y";
                return RedirectToAction("Index", "Jobs",new{@redirecturl = "Y" });
                }
            else
            {
                TempData["TrendingTagsFooter"] = MatchBxCommon.GetTrendingTagsFooter();
                TempData["BlockReason"] = _objUsrBlockModel.GetList();
                TempData["CancelJobReason"] = _ObjJobModel.GetJobCancelList();

                ViewBag.pageIndex = id;
                if (id == 1)
                {
                    ViewBag.pageTitle = "Manage User";
                }
                else if (id == 2)
                {
                    ViewBag.pageTitle = "Manage Jobs";
                }
                else if (id == 3)
                {
                    ViewBag.pageTitle = "Jobs pending to be approved";
                }
               
                else if (id.GetValueOrDefault() == 0 && jid.GetValueOrDefault() == 0)
                {
                    ViewBag.pageTitle = "Manage User";
                }
                   
                if (jid.GetValueOrDefault()!=0)
                {
                    ViewBag.pageTitle = "Jobs pending to be approved";
                    ViewBag.pageIndex = 3;
                    ViewBag.JobIndex = jid.GetValueOrDefault();
                }
                return View();
            }
        }
        public PartialViewResult manageUser()
        {


            _lstAdminfeature = _objadmFeatureModel.GetAdminDashboard(_objadmFeaturesbus);
            _objadmFeaturesbus.totUserCount = _lstAdminfeature.Count();
            TempData["RecordstotCount"] = _objadmFeaturesbus.totUserCount;
            ViewData["RecordstotCount"] = _objadmFeaturesbus.totUserCount;
            TempData["RecordstoDisplay"] = RecordstoDisplay;
            TempData["CancelJobReason"] = _ObjJobModel.GetJobCancelList();
            _lstAdminfeatureFilt = _lstAdminfeature.GroupBy(x => x.UserId).Select(y => y.First()).ToList();
            string htmlContent = "";
            //foreach (var item1 in _lstAdminfeatureFilt)
            //{
            //    item1.SkillsList = "";
            //foreach (var item2 in _lstAdminfeature)
            //{

            //    if (item1.UserId == item2.UserId)
            //    {

            //        if (item1.Skills != "")
            //        {
            //            htmlContent += "<span class='skills_mngUsr'>";
            //            // item1.SkillsMappingList.Add(new Skills { Description = item2.Skills });
            //            item1.SkillsList += item2.Skills;
            //            htmlContent += item1.SkillsList + "</span>";
            //            item1.SkillsList = htmlContent;
            //        }

            //    }
            //}
            foreach (var item1 in _lstAdminfeatureFilt)
            {
                item1.SkillsList = "";
                foreach (var item2 in _lstAdminfeature)
                {

                    if (item1.UserId == item2.UserId)
                    {

                        if (item1.Skills != "")
                        {
                            htmlContent = "<span class='skills_mngUsr'>";
                            // item1.SkillsMappingList.Add(new Skills { Description = item2.Skills });
                            item1.Skills = item2.Skills;
                            htmlContent += item1.Skills + "</span>";
                            item1.SkillsList += htmlContent;


                        }
                    }

                }
            }

            //}
            model._lstAdminfeatureFilt = _lstAdminfeatureFilt.Take(RecordstoDisplay);
            return PartialView("manageUser", model._lstAdminfeatureFilt);
        }
        public ActionResult BlockUser(string UserId, int BlockReason)
        {
            TempData["CancelJobReason"] = _ObjJobModel.GetJobCancelList();
            TempData["BlockReason"] = _objUsrBlockModel.GetList();
            List<Users> _lstUsers = new List<Users>();
            _lstUsers = _objUserModel.GetList("*", "UserId = " + UserId);

            _objUsers = _lstUsers[0];
            _objUsers.UserId = Convert.ToInt32(UserId);
            _objUsers.BlockReason = BlockReason;
            if (BlockReason == 0)
            {
                _objUsers.IsActive = 1;
            }
            else
            {
                _objUsers.IsActive = 0;
            }
            int Success = _objUserModel.Save(_objUsers);
            return View("Index");
        }
        [HttpPost]
        public JsonResult LoadMoreUser(int id)
        {
            dynamic model = new ExpandoObject();
            TempData["CancelJobReason"] = _ObjJobModel.GetJobCancelList();
            _lstAdminfeature = _objadmFeatureModel.GetAdminDashboard(_objadmFeaturesbus);
            _objadmFeaturesbus.totUserCount = _lstAdminfeature.Count();
            _lstAdminfeature = _objadmFeatureModel.GetAdminDashboard(_objadmFeaturesbus);
            _lstAdminfeatureFilt = _lstAdminfeature.GroupBy(x => x.UserId).Select(y => y.First()).ToList();
            //_lstAdminfeatureFilt[0].totUserCount = _objadmFeaturesbus.totUserCount;
            string htmlContent = "";
            foreach (var item1 in _lstAdminfeatureFilt)
            {
                item1.SkillsList = "";
                foreach (var item2 in _lstAdminfeature)
                {

                    if (item1.UserId == item2.UserId)
                    {
                       
                        if (item1.Skills != "")
                        {
                            htmlContent = "<span class='skills_mngUsr'>";
                            // item1.SkillsMappingList.Add(new Skills { Description = item2.Skills });
                            item1.Skills = item2.Skills;
                            htmlContent += item1.Skills+ "</span>";
                            item1.SkillsList += htmlContent;
                        }
                       

                    }
                }
               
            }
            int Record = _lstAdminfeature.Count();
            if (Record > RecordstoDisplay)
            {
                loadMore = 1;
            }
            else
            {
                loadMore = 0;
            }
            model.totUserCount = _lstAdminfeatureFilt.Count;
            model._lstAdminfeatureFilt = _lstAdminfeatureFilt.Where(x => x.UserId > id).ToList().Take(RecordstoDisplay);
            return Json(model, JsonRequestBehavior.AllowGet);
        }

        public PartialViewResult ManageJob()
        {
            dynamic model = new ExpandoObject();
            _lstManageJob = _objadmFeatureModel.GetManageJob(_objManageJob);

            _objManageJob.totJobCount = _lstManageJob.Count();
            TempData["RecordstotCount"] = _objManageJob.totJobCount;
            ViewData["RecordstotCount"] = _objManageJob.totJobCount;

            TempData["RecordstoDisplay"] = RecordstoDisplay;
            _lstManageJobFilter = _lstManageJob.GroupBy(x => x.JobId).Select(y => y.First()).ToList();
            string htmlContent1 = "";
            foreach (var item1 in _lstManageJobFilter)
            {
                item1.SkillsList = "";
                foreach (var item2 in _lstManageJob)
                {
                    if (item1.JobId == item2.JobId)
                    {
                        if (item1.Description != "" && item1.Description != null)
                        {
                            htmlContent1 = "<span class='skills_mngUsr'>";
                            item1.Description = item2.Description;
                            htmlContent1 += item1.Description + "</span>";
                            item1.SkillsList += htmlContent1;
                        }
                    }

                }
            }




            model._lstManageJobFilter = _lstManageJobFilter.Take(RecordstoDisplay);
            return PartialView("ManageJob", model._lstManageJobFilter);
        }

        [HttpPost]
        public JsonResult LoadMoreJob(int id)
        {
            dynamic model = new ExpandoObject();
            _lstManageJob = _objadmFeatureModel.GetManageJob(_objManageJob);
            _objManageJob.totJobCount = _lstManageJob.Count();
            _lstManageJobFilter = _lstManageJob.GroupBy(x => x.JobId).Select(y => y.First()).ToList();
            string htmlContent1 = "";
            foreach (var item1 in _lstManageJobFilter)
            {
                item1.SkillsList = "";
                foreach (var item2 in _lstManageJob)
                {
                    if (item1.JobId == item2.JobId)
                    {
                        if (item1.Description != "" && item1.Description != null)
                        {
                            htmlContent1 = "<span class='skills_mngUsr'>";
                            item1.Description = item2.Description;
                            htmlContent1 += item1.Description + "</span>";
                            item1.SkillsList += htmlContent1;
                        }
                    }
                }

            }

            int Record = _lstManageJob.Count();
            if (Record > RecordstoDisplay)
            {
                loadMore = 1;
            }
            else
            {
                loadMore = 0;
            }
            model.totJobCount = _lstManageJobFilter.Count;
            model._lstManageJobFilter = _lstManageJobFilter.Where(x => x.JobId > id).ToList().Take(RecordstoDisplay);
            return Json(model, JsonRequestBehavior.AllowGet);
        }

        public ActionResult JobCancelProcess(string JobId, string UserId,string Email, int CancelReason)
        {
            TempData["BlockReason"] = _objUsrBlockModel.GetList();
            TempData["CancelJobReason"] = _ObjJobModel.GetJobCancelList();
            Job _objJob = new Job();
            List<Job> _lstJobs = new List<Job>();
            _lstJobs = _ObjJobModel.GetList("*", "JobId = " + JobId);
            _objJob = _lstJobs[0];

            List<Users> _lstUsers = new List<Users>();
            _lstUsers = _objUserModel.GetList("*", "UserId = " + UserId);
            _objUsers = _lstUsers[0];

            
            _objJob.JobId = Convert.ToInt32(JobId);
            _objJob.CancelReason = CancelReason;
            if (CancelReason == 0)
            {
                _objJob.IsActive = "Y";
            }
            else
            {
                _objJob.IsActive = "N";
            }

            int Success = _ObjJobModel.Save(_objJob);
            if (Convert.ToInt32(Success) > 0)
            {
                MatchBxCommon.CancelJobEmail(_objJob.JobTitle,_objUsers.FullName,Email,false);
            }

            return View("Index");
        }
        public ActionResult JobReviewProcess(string JobId, string UserId, string Email, int RejectionReason, int AdminUserId, string JobTitle, string CreatedDateDisplay)
        {
            TempData["BlockReason"] = _objUsrBlockModel.GetList();
            TempData["CancelJobReason"] = _ObjJobModel.GetJobCancelList();
            string _Message = "";
            Job _objJob = new Job();
            List<Job> _lstJobs = new List<Job>();
            _lstJobs = _ObjJobModel.GetList("*", "JobId = " + JobId);
            _objJob = _lstJobs[0];

            List<Users> _lstUsers = new List<Users>();
            _lstUsers = _objUserModel.GetList("*", "UserId = " + UserId);
            _objUsers = _lstUsers[0];


            _objJob.JobId = Convert.ToInt32(JobId);
            _objJob.CancelReason = RejectionReason;
            if (RejectionReason == 0)
            {
                _objJob.IsActive = "Y";
                _objJob.JobStatus = JobLevel.Posted.ToString();
            }
            else
            {
                _objJob.IsActive = "N";
                _objJob.JobStatus = JobLevel.Failed.ToString();
            }
            _objJob.WithTransaction = "N";
            _objJob.GigSubscriptionId = 0;
            int Success = _ObjJobModel.Save(_objJob);
            if (Convert.ToInt32(Success) > 0)
            {
                JobAuditModel _JobAuditModel = new JobAuditModel();
                JobAudit _JobAudit = new JobAudit();

                _JobAudit.JobId = Convert.ToInt32(Success);
                _JobAudit.UserId = Convert.ToInt32(Session["UserId"]);
                _JobAudit.Status = RejectionReason == 0 ? JobReviewStatus.Accepted.ToString() : JobReviewStatus.Rejected.ToString();
                _JobAudit.RejectReason = RejectionReason;
                if(_JobAuditModel.Save(_JobAudit) > 0)
                {
                    if (RejectionReason == 0)
                    {
                        MatchBxCommon.sendJobApproveRejectEmailToUser(1, JobTitle, CreatedDateDisplay, Email);
                    }
                    else
                    {
                        MatchBxCommon.sendJobApproveRejectEmailToUser(0, JobTitle, CreatedDateDisplay, Email);
                    }
                    _Message = "Success";
                }    
                else
                {
                    _Message = "Failed";
                }                                
            }
            else
            {
                _Message = "Failed";
            }
            return Json(_Message, JsonRequestBehavior.AllowGet);
        }

        public PartialViewResult JobReview(int ?jid)
        {
            TempData["message"] = string.Empty;
            dynamic model = new ExpandoObject();
            JobCategoryModel objCatMod = new JobCategoryModel();   
            var categoryList = objCatMod.GetList();
            categoryList.ForEach(c =>
            {
                // start by converting entire string to lower case
                var lowerCase = c.Category.ToLower();
                // matches the first sentence of a string, as well as subsequent sentences
                var r = new Regex(@"(^[a-z])|\.\s+(.)", RegexOptions.ExplicitCapture);
                // MatchEvaluator delegate defines replacement of setence starts to uppercase
                c.Category = r.Replace(lowerCase, s => s.Value.ToUpper());
            });
            TempData["Category"] = categoryList;
            TempData["CancelJobReason"] = _ObjJobModel.GetJobCancelList();
            JobModel _JobModel = new JobModel();
            Job _Job = new Job();
            _Job.JobCategoryId = 0;
            _Job.SortBy = "N";
            List<Job> _JobList = MatchBxCommon.GenerateBadge(_JobModel.GetJobReview(_Job));
            if (jid.GetValueOrDefault() != 0)
            {
                _JobList = _JobList.Where(x => x.JobId == jid.GetValueOrDefault()).ToList();
            }
          
            foreach (Job _job in _JobList)
            {
                _JobList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
                _JobList.ForEach(s => s.EndsIn = (s.JobCompletionDate.Subtract(DateTime.Now)).Days + " days, " + (s.JobCompletionDate.Subtract(DateTime.Now)).Hours + " hours");
            }
            var objJobListFiltered = _JobList.GroupBy(x => x.JobId).Select(y => y.First()).ToList();
            ReviewRecord = objJobListFiltered.Count();
            if (ReviewRecord > recordDisplay)
            {
                reviewloadmore = 1;
            }
            else
            {
                reviewloadmore = 0;
            }

            objJobListFiltered.ForEach(s => s.Isloadmore = reviewloadmore);
            if (_JobList.Count() == 0 && jid.GetValueOrDefault()!=0)
            {
                JobModel jobmodel = new JobModel();
               
                Job obj = jobmodel.GetARecord(jid.GetValueOrDefault());

                if (obj != null)
                {
                    TempData["message"] = obj.JobStatus != "F" ? "This job is already approved" : "This job is already rejected";
                }
                else
                {
                    TempData["message"] = "This job does not exist";
                }
            }
            model.JobReview = objJobListFiltered.OrderByDescending(x => x.JobId).Take(recordDisplay).ToList();
            return PartialView("JobReview", model.JobReview);
        }
        [HttpPost]
        public JsonResult LoadMoreListedJobs(int id, string _searchtext, int JobCategoryId, string SortBy)
        {
            JobModel _JobModel = new JobModel();
            Job _Job = new Job();
            _Job.JobCategoryId = JobCategoryId;
            _Job.SortBy = SortBy;
            List<Job> _JobList = new List<Job>();
            _JobList = SortBy == "N" ? (MatchBxCommon.GenerateBadge(_JobModel.GetJobReview(_Job).Where(x => x.JobId < id).ToList())) : (MatchBxCommon.GenerateBadge(_JobModel.GetJobReview(_Job).Where(x => x.JobId > id).ToList()));
            if (_JobList.Count > 0)
            {
                foreach (Job _job in _JobList)
                {
                    _JobList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
                    _JobList.ForEach(s => s.EndsIn = (s.JobCompletionDate.Subtract(DateTime.Now)).Days + " days, " + (s.JobCompletionDate.Subtract(DateTime.Now)).Hours + " hours");
                }
                if (!String.IsNullOrEmpty(_searchtext))
                {
                    _JobList = _JobList.Where(p => p.JobDescription != null && p.JobDescription.ToLower().Contains(_searchtext.ToLower().Trim()) || p.JobTitle != null && p.JobTitle.ToLower().Contains(_searchtext.ToLower().Trim()) || p.JobCompletionDateDisplay != null && p.JobCompletionDateDisplay.ToLower().Contains(_searchtext.ToLower()) || p.TrendingTagsIdList != null && p.TrendingTagsIdList.ToLower().Contains(_searchtext.ToLower())).ToList();
                }
                var objJobListFiltered = _JobList.GroupBy(x => x.JobId).Select(y => y.First()).ToList();
                ReviewRecord = objJobListFiltered.Count();
                if (ReviewRecord > recordDisplay)
                {
                    reviewloadmore = 1;
                }
                else
                {
                    reviewloadmore = 0;
                }
                objJobListFiltered.ForEach(x => x.Isloadmore = reviewloadmore);
                model.JobReview = objJobListFiltered.Take(recordDisplay);
                return Json(model.JobReview, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json("Failed", JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult JobReviewFilter(string _searchtext, int JobCategoryId, string SortBy)
        {
            JobModel _JobModel = new JobModel();
            Job _Job = new Job();
            _Job.JobCategoryId = JobCategoryId;
            _Job.SortBy = SortBy;
            List<Job> _JobList = new List<Job>();
            _JobList = MatchBxCommon.GenerateBadge(_JobModel.GetJobReview(_Job));           
            if (_JobList.Count > 0)
            {
                foreach (Job _job in _JobList)
                {
                    _JobList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
                    _JobList.ForEach(s => s.EndsIn = (s.JobCompletionDate.Subtract(DateTime.Now)).Days + " days, " + (s.JobCompletionDate.Subtract(DateTime.Now)).Hours + " hours");
                }
                if (!String.IsNullOrEmpty(_searchtext))
                {
                    _JobList = _JobList.Where(p => p.JobDescription != null && p.JobDescription.ToLower().Contains(_searchtext.ToLower().Trim()) || p.JobTitle != null && p.JobTitle.ToLower().Contains(_searchtext.ToLower().Trim()) || p.JobCompletionDateDisplay != null && p.JobCompletionDateDisplay.ToLower().Contains(_searchtext.ToLower()) || p.TrendingTagsIdList != null && p.TrendingTagsIdList.ToLower().Contains(_searchtext.ToLower())).ToList();
                }
                var objJobListFiltered = _JobList.GroupBy(x => x.JobId).Select(y => y.First()).ToList();
                ReviewRecord = objJobListFiltered.Count();
                if (ReviewRecord > recordDisplay)
                {
                    reviewloadmore = 1;
                }
                else
                {
                    reviewloadmore = 0;
                }
                objJobListFiltered.ForEach(x => x.Isloadmore = reviewloadmore);
                model.JobReview = objJobListFiltered.Take(recordDisplay).ToList();
                return Json(model.JobReview, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json("Failed", JsonRequestBehavior.AllowGet);
            }
            
        }
        public ActionResult JobDocuments(int JobId)
        {
            JobDocumentsModel _JobDocumentsModel = new JobDocumentsModel();
            List<JobDocuments> _JobDocumentsList = _JobDocumentsModel.GetList(" * ", "JobId = " + JobId);
            if(_JobDocumentsList.Count() > 0)
            {
                return Json(_JobDocumentsList, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json("Falied", JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult GetAutomatedSearch(string _searchtext)
        {
            JobModel _objMod = new JobModel();
            Job _objBus = new Job();
            _objBus.searchText = _searchtext;
            List<Job> _JobList = new List<Job>();
            _JobList = _objMod.GetAutomatedJobsForJobReview(_objBus);
            return Json(_JobList, JsonRequestBehavior.AllowGet);
        }


        public ActionResult Analytics()
        {
            ViewBag.pageTitle = "Analytics";
            return View();
        }

        public ActionResult JobAnalytics()
        {
            jobList = jobModel.GetJobAnalytics();
            var jobPosters = new List<string>();
            var jobCategories = new List<string>();
            var budgetAXP = 0m;
            analyticsObj.JobAnalytics = new List<JobAnalytics>();

            foreach (var job in jobList)
            {
                if(!jobPosters.Contains(job.FullName))
                {
                    jobPosters.Add(job.FullName);
                }
                if(!jobCategories.Contains(job.Category))
                {
                    jobCategories.Add(job.Category);
                }
                budgetAXP += job.BudgetASP;
                analyticsObj.JobAnalytics.Add(new JobAnalytics
                {
                    Date = job.CreatedDate.ToString(),
                    JobID = job.JobReferanceId,
                    Category = job.Category,
                    PosterBy = job.FullName,
                    AXP = job.BudgetASP,
                    Response = job.Bid
                });
            }
            analyticsObj.TotalJobs = jobList.Count;
            analyticsObj.TotalJobPosters = jobList.FirstOrDefault().TotalJobPosters;
            analyticsObj.TotalBudget = budgetAXP;
            analyticsObj.Categories = jobCategories;
            analyticsObj.Posters = jobPosters;
            return PartialView(analyticsObj);
        }

        public ActionResult VanityMatrics()
        {
            var CountryArray = new string[] { "Brazil", "Japan", "India", "Indonesia", "United States", "Germany", "Russia", "Mexico", "United Kingdom", "China" };
            var vmObject = new VanityMatrics();
            //var analyticsJSON = System.IO.File.ReadAllText(Server.MapPath(@"~/Content/Country.json"));
            //vmObject.UserDetails = JsonConvert.DeserializeObject<RootObject>(analyticsJSON);
            var userDetails = _objadmFeatureModel.GetUserDetails();
            vmObject.UserDetails = new List<UserDetails>();

            Random rnd = new Random();
            foreach (var user in userDetails.Where(s=>s.IsActive=="True"))
            {
                string s = CountryArray[rnd.Next(CountryArray.Length)];
                user.Geography = s;
                vmObject.UserDetails.Add(user);
            }
            vmObject.JobDetails = _objadmFeatureModel.GetJobDetails();
            vmObject.LoginDetails = _objadmFeatureModel.GetLoginDetails();
            vmObject.BidDetails = _objadmFeatureModel.GetBidDetails();
            return PartialView(vmObject);
        }

        public ActionResult WebAnalytics()
        {
            return PartialView();
        }

        public ActionResult GigReview(int? Gigid)
        {
            if (Session["UserType"] == null || Session["UserType"].ToString() != "4")
            {
                TempData["gigid"] = Gigid.GetValueOrDefault();
                return RedirectToAction("Index", "Jobs", new { @redirecturl = "Y" });
            }
            else
            {
                JobCategoryModel objCatMod = new JobCategoryModel();
                var categoryList = objCatMod.GetList();
                dynamic model = new ExpandoObject();
                categoryList.ForEach(c =>
                {
                    var lowerCase = c.Category.ToLower();
                    var r = new Regex(@"(^[a-z])|\.\s+(.)", RegexOptions.ExplicitCapture);
                    c.Category = r.Replace(lowerCase, s => s.Value.ToUpper());
                });
                TempData["Category"] = categoryList;
                TempData["message"] = string.Empty;
                TempData["BlockReason"] = _objUsrBlockModel.GetList();
                TempData["CancelJobReason"] = _ObjJobModel.GetJobCancelList();
                GigModel _GigModel = new GigModel();

                Gig _Gig = new Gig();
                _Gig.JobCategoryId = 0;
                _Gig.SortBy = "N";



                List<Gig> _GigList = new List<Gig>();
                _GigList = MatchBxCommon.GenerateBadgeForGig(_GigModel.GetGigReview(_Gig));
                if (Gigid.GetValueOrDefault() != 0)
                {
                    _GigList = _GigList.Where(x => x.GigId == Gigid.GetValueOrDefault()).ToList<Gig>();
                }
                if (_GigList.Count > 0)
                {
                    //foreach (Job _job in _GigList)
                    //{
                    _GigList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
                    // }
                    //if (!String.IsNullOrEmpty(_searchtext))
                    //{
                    //    _GigList = _GigList.Where(p => p.JobDescription != null && p.JobDescription.ToLower().Contains(_searchtext.ToLower().Trim()) || p.JobTitle != null && p.JobTitle.ToLower().Contains(_searchtext.ToLower().Trim()) || p.JobCompletionDateDisplay != null && p.JobCompletionDateDisplay.ToLower().Contains(_searchtext.ToLower()) || p.TrendingTagsIdList != null && p.TrendingTagsIdList.ToLower().Contains(_searchtext.ToLower())).ToList();
                    //}
                    var objJobListFiltered = _GigList.GroupBy(x => x.GigId).Select(y => y.First()).ToList();
                    ReviewRecord = objJobListFiltered.Count();
                    if (ReviewRecord > recordDisplay)
                    {
                        reviewloadmore = 1;
                    }
                    else
                    {
                        reviewloadmore = 0;
                    }
                    objJobListFiltered.ForEach(x => x.Isloadmore = reviewloadmore);
                    model.GigReview = objJobListFiltered.Take(recordDisplay).ToList();

                }
                else
                {
                    model.GigReview = new List<Gig>();
                }
                return View("GigReview", model.GigReview);
            }
        
        }
        [HttpPost]
        public ActionResult GigReviewFilter(string _searchtext, int JobCategoryId, string SortBy)

        {

            GigModel _GigModel = new GigModel();
            Gig _Gig = new Gig();
            _Gig.JobCategoryId = JobCategoryId;
            _Gig.SortBy = SortBy;
            List<Gig> _GigList = new List<Gig>();
            _GigList = MatchBxCommon.GenerateBadgeForGig(_GigModel.GetGigReview(_Gig));
            if (_GigList.Count > 0)
            {
                //foreach (Job _job in _GigList)
                //{
                _GigList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
                // }
                if (!String.IsNullOrEmpty(_searchtext))
                {
                    _GigList = _GigList.Where(p => p.GigDescription != null && p.GigDescription.ToLower().Contains(_searchtext.ToLower().Trim()) || p.GigTitle != null && p.GigTitle.ToLower().Contains(_searchtext.ToLower().Trim()) || p.TrendingTagsIdList != null && p.TrendingTagsIdList.ToLower().Contains(_searchtext.ToLower()) || p.SkillsList != null && p.SkillsList.ToLower().Contains(_searchtext.ToLower())).ToList();
                }
                var objJobListFiltered = _GigList.GroupBy(x => x.GigId).Select(y => y.First()).ToList();
                ReviewRecord = objJobListFiltered.Count();
                if (ReviewRecord > recordDisplay)
                {
                    reviewloadmore = 1;
                }
                else
                {
                    reviewloadmore = 0;
                }
                objJobListFiltered.ForEach(x => x.Isloadmore = reviewloadmore);
                model.JobReview = objJobListFiltered.Take(recordDisplay).ToList();
                return Json(model.JobReview, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json("Failed", JsonRequestBehavior.AllowGet);
            }

        }
        [HttpPost]
        public ActionResult LoadMoreGig(string _searchtext, int JobCategoryId, string SortBy, int id)
        {
            GigModel _GigModel = new GigModel();
            Gig _Gig = new Gig();
            _Gig.JobCategoryId = JobCategoryId;
            _Gig.SortBy = SortBy;
            List<Gig> _GigList = new List<Gig>();
            _GigList = SortBy == "N" ? (MatchBxCommon.GenerateBadgeForGig(_GigModel.GetGigReview(_Gig).Where(x => x.GigId < id).ToList())) : (MatchBxCommon.GenerateBadgeForGig(_GigModel.GetGigReview(_Gig).Where(x => x.GigId > id).ToList()));
            if (_GigList.Count > 0)
            {
                //foreach (Job _job in _JobList)
                //{
                _GigList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
                // _JobList.ForEach(s => s.EndsIn = (s.JobCompletionDate.Subtract(DateTime.Now)).Days + " days, " + (s.JobCompletionDate.Subtract(DateTime.Now)).Hours + " hours");
                //}
                if (!String.IsNullOrEmpty(_searchtext))
                {
                    _GigList = _GigList.Where(p => p.GigDescription != null && p.GigDescription.ToLower().Contains(_searchtext.ToLower().Trim()) || p.GigTitle != null && p.GigTitle.ToLower().Contains(_searchtext.ToLower().Trim()) || p.TrendingTagsIdList != null && p.TrendingTagsIdList.ToLower().Contains(_searchtext.ToLower()) || p.SkillsList != null && p.SkillsList.ToLower().Contains(_searchtext.ToLower())).ToList();
                }
                var objJobListFiltered = _GigList.GroupBy(x => x.GigId).Select(y => y.First()).ToList();
                ReviewRecord = objJobListFiltered.Count();
                if (ReviewRecord > recordDisplay)
                {
                    reviewloadmore = 1;
                }
                else
                {
                    reviewloadmore = 0;
                }
                objJobListFiltered.ForEach(x => x.Isloadmore = reviewloadmore);
                model.GigReview = objJobListFiltered.Take(recordDisplay);
                return Json(model.GigReview, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json("Failed", JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public ActionResult GigReviewProcess(string GigId, string UserId, string Email, int RejectionReason, int AdminUserId, string GigTitle, string CreatedDateDisplay)
        {
            TempData["BlockReason"] = _objUsrBlockModel.GetList();
            TempData["CancelJobReason"] = _ObjJobModel.GetJobCancelList();
            string _Message = "";
            Gig _objgig = new Gig();
            List<Gig> _lstGigs = new List<Gig>();
            _lstGigs = _ObjGigModel.GetList("*", "GigId = " + GigId);
            _objgig = _lstGigs[0];

            List<Users> _lstUsers = new List<Users>();
            _lstUsers = _objUserModel.GetList("*", "UserId = " + UserId);
            _objUsers = _lstUsers[0];


            _objgig.GigId = Convert.ToInt32(GigId);
            _objgig.CancelReason = RejectionReason;
            if (RejectionReason == 0)
            {
                _objgig.IsActive = "Y";
                _objgig.GigStatus = GigLevel.Posted.ToString();
            }
            else
            {
                _objgig.IsActive = "N";
                _objgig.GigStatus = GigLevel.Failed.ToString();
            }

            int Success = _ObjGigModel.Save(_objgig);
            if (Convert.ToInt32(Success) > 0)
            {

                if (RejectionReason == 0)
                {
                    MatchBxCommon.sendGigApproveRejectEmailToUser(1, GigTitle, CreatedDateDisplay, Email);
                }
                else
                {
                    MatchBxCommon.sendGigApproveRejectEmailToUser(0, GigTitle, CreatedDateDisplay, Email);
                }
                _Message = "Success";

            }
            else
            {
                _Message = "Failed";
            }
            return Json(_Message, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public ActionResult GigDocuments(int GigId)
        {

            GigDocumentsModel _GigDocumentsModel = new GigDocumentsModel();
            List<GigDocuments> _GigDocumentsList = _GigDocumentsModel.GetList(" * ", "GigId = " + GigId);
            if (_GigDocumentsList.Count() > 0)
            {
                return Json(_GigDocumentsList, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json("Falied", JsonRequestBehavior.AllowGet);
            }
        }
        [HttpPost]
        public JsonResult GetAutomatedSearchForGigs(string _searchtext)
        {
            GigModel _objMod = new GigModel();
            Gig _objBus = new Gig();
            _objBus.searchText = _searchtext;
            List<Gig> _GigList = new List<Gig>();
            _GigList = _objMod.GetAutomatedGigsForGigReview(_objBus);
            return Json(_GigList, JsonRequestBehavior.AllowGet);
        }

    }


}   
