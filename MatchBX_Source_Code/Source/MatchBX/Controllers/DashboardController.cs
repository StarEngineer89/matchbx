using Business;
using MatchBx.Utilities;
using MatchBX.Models;
using Model;
using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.IO;
using System.Configuration;
using Microsoft.Ajax.Utilities;

namespace MatchBX.Controllers
{
    [CustomExceptionFilter]
    public class DashboardController : Controller
    {
        // GET: Dashboard
        Job objJob = new Job();
        JobModel objJobMod = new JobModel();
        List<Job> objJobList = new List<Job>();
        List<Job> objJobListFiltered = new List<Job>();
        Users objUser = new Users();
        List<Users> objUsersList = new List<Users>();
        UsersModel objUsersMod = new UsersModel();
        MatchBXNotification objNotification = new MatchBXNotification();
        MatchBXNotificationModel objNotiMod = new MatchBXNotificationModel();
        JobBidding objJobbidding = new JobBidding();
        JobBiddingModel objJobbiddingMod = new JobBiddingModel();
        UserProfile objUserProfile = new UserProfile();
        UserProfileModel objProfileMod = new UserProfileModel();
        SkillsModel objSkillsMod = new SkillsModel();
        UserSkillsMappingModel objUserSkillsMod = new UserSkillsMappingModel();
        UserSkillsMapping objUserSkillsMapping = new UserSkillsMapping();
        UserEmailPreferenceMappingModel objEmailPrefMod = new UserEmailPreferenceMappingModel();
        int recordDisplay =5;
        int progressRecord = 0;
        int progressloadmore = 0;
        int postedRecord = 0;
        int postedloadmore = 0;
        int bidRecord = 0;
        int bidloadmore = 0;
        int completeRecord = 0;
        int completeloadmore = 0;
        string sourceFolderPath = ConfigurationManager.AppSettings["PathForProjectDocuments"].ToString();
        Gig objGig = new Gig();
        GigModel objGigMod = new GigModel();

        [NoCache]
        [SessionExpire]
        public ActionResult Index()
        {
           
            Session["JobCategoryId"] = 0;
            TempData["TrendingTagsFooter"] = MatchBxCommon.GetTrendingTagsFooter();
            dynamic model = new ExpandoObject();

            //dynamic modelJobsInProgress = new ExpandoObject();
            //modelJobsInProgress = GetDataForJobsInProgress();
            //model.Progress = modelJobsInProgress.Progress;

            //dynamic modelJobsBidon = new ExpandoObject();
            //modelJobsBidon = GetDataForJobsBidOn();
            //model.Bid = modelJobsBidon.Bid;

            //dynamic modelJobsListed = new ExpandoObject();
            //modelJobsListed = GetDataForJobsListed();
            //model.Posted = modelJobsListed.Posted;

            //dynamic modelJobsCompleted = new ExpandoObject();
            //modelJobsCompleted = GetDataForJobsCompleted();
            //model.Complete = modelJobsCompleted.Complete;

            //dynamic modelJobsPending = new ExpandoObject();
            //modelJobsPending = GetDataForJobsPending();
            //model.Pending = modelJobsPending.Pending;

            List<JobCategory> _JobcategoryList = new List<JobCategory>();
            JobCategoryModel JobModel = new JobCategoryModel();
            _JobcategoryList = JobModel.GetList();
            Session["JobCategory"] = _JobcategoryList;

            objUser.UserId = Convert.ToInt32(Session["UserId"]);

            //List<Gig> gigsList = objGigMod.GetUserGigs(objUser.UserId);
            //if (Convert.ToInt32(Session["UserType"]) == 1 || Convert.ToInt32(Session["UserType"]) == 3)
            //{
            //    model.GigsLibrary = gigsList.Where(g => g.GigStatus == "P" && g.Role == "C").GroupBy(g => g.GigId).Select(g => g.FirstOrDefault()).ToList();
            //    model.GigsInPending = gigsList.Where(g => g.GigStatus == "R" && g.Role == "C").GroupBy(g => g.GigId).Select(g => g.FirstOrDefault()).ToList();
            //    model.GigsSubscriptionRequest = gigsList.Where(g => g.GigSubscriptionStatus == "S" && g.Role == "C").GroupBy(g => g.GigId).Select(g => g.FirstOrDefault()).ToList();
            //}
            //if (Convert.ToInt32(Session["UserType"]) != 1)
            //{
            //    model.GigsSubscriptionPending = gigsList.Where(g => g.GigSubscriptionStatus == "S" && g.Role != "C").ToList();
            //}
            //model.GigsPaymentPending = gigsList.Where(g => g.GigSubscriptionStatus == "A").ToList();

            objGig = new Gig()
            {
                JobCategoryId = 0,
                UserId = objUser.UserId,
                TrendingTagsIdList = "0",
                SkillsList = "0",
                MinBudget = 0,
                MaxBudget = 0,
                SortBy = "Y"
            };
            model.MyServices = objGigMod.GetMyServices(objGig);
            model.PurchasedServices = objGigMod.GetPurchasedServices(objGig);
            objJob = new Job()
            {
                UserId = objUser.UserId,
                CreatedDate = DateTime.Now
            };
            model.MyJobs = objJobMod.GetMyJobs(objJob);
            model.JobsBidOn = objJobMod.GetJobsBidOn(objJob);

            if (objUser.UserId == 0)
            {
                Session.Clear();
                Session.Abandon();
                return RedirectToAction("Index", "Jobs");
            }
            else
            {
                objUser = objUsersMod.GetTransactionDetails(objUser).FirstOrDefault();
                decimal exchangerate = MatchBxCommon.GetExchangeRate();
                if (objUser.UserType == "1")
                {
                    Session["Earnt"] = objUser.Earnt.ToString("#,##0");
                    Session["EarntinDollar"] = Math.Round((objUser.Earnt * exchangerate), 2).ToString("#,##0.00");
                }
                else if (objUser.UserType == "2")
                {
                    Session["Spent"] = objUser.Spent.ToString("#,##0");
                    Session["SpentinDollar"] = Math.Round((objUser.Spent * exchangerate), 2).ToString("#,##0.00");
                }
                else
                {
                    Session["Earnt"] = objUser.Earnt.ToString("#,##0");
                    Session["EarntinDollar"] = Math.Round((objUser.Earnt * exchangerate), 2).ToString("#,##0.00");
                    Session["Spent"] = objUser.Spent.ToString("#,##0");
                    Session["SpentinDollar"] = Math.Round((objUser.Spent * exchangerate), 2).ToString("#,##0.00");
                }
                return View(model);
            }

            
        }
        [HttpPost]
        public PartialViewResult JobsInProgress()
        {

            return PartialView("JobsInProgress", GetDataForJobsInProgress());
        }
        [HttpPost]
        public PartialViewResult JobsInProgressWithouExchange()
        {

            return PartialView("JobsInProgress", GetDataForJobsInProgressWithouExchange());
        }
        [NonAction]
        public object GetDataForJobsInProgress()
        {

            dynamic model = new ExpandoObject();
            objJob.UserId = Convert.ToInt32(Session["UserId"]);

            /*********Jobs in Progress*********/
            objJob.JobStatus = "A";
            objJobList = MatchBxCommon.GenerateBadge(objJobMod.GetJobDetailsForUser(objJob).ToList());
            TempData["JobsProgressCount"] = objJobList.Count();
            progressRecord = objJobList.Count();
            if (progressRecord > recordDisplay)
            {
                progressloadmore = 1;
            }
            else
            {
                progressloadmore = 0;
            }
            objJobList.ForEach(s => s.Isloadmore = progressloadmore);
            objJobList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
            objJobList = CalculateBidAmountinDollar(objJobList);
            model.Progress = objJobList.OrderByDescending(s => s.JobId).Take(recordDisplay).ToList();
            /*********Jobs in Progress End*********/
            return model;
        }
        [NonAction]
        public object GetDataForJobsInProgressWithouExchange()
        {

            dynamic model = new ExpandoObject();
            objJob.UserId = Convert.ToInt32(Session["UserId"]);

            /*********Jobs in Progress*********/
            objJob.JobStatus = "A";
            objJobList = MatchBxCommon.GenerateBadgeFromSession(objJobMod.GetJobDetailsForUser(objJob).ToList());
            TempData["JobsProgressCount"] = objJobList.Count();
            progressRecord = objJobList.Count();
            if (progressRecord > recordDisplay)
            {
                progressloadmore = 1;
            }
            else
            {
                progressloadmore = 0;
            }
            objJobList.ForEach(s => s.Isloadmore = progressloadmore);
            objJobList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
            objJobList = CalculateBidAmountinDollarFromSession(objJobList);
            model.Progress = objJobList.OrderByDescending(s => s.JobId).Take(recordDisplay).ToList();
            /*********Jobs in Progress End*********/
            return model;
        }
        [HttpPost]
        public PartialViewResult JobsBidOn()
        {

            return PartialView("JobsBidOn", GetDataForJobsBidOn());
        }
        [NonAction]
        public object GetDataForJobsBidOn()
        {

            dynamic model = new ExpandoObject();
            objJob.UserId = Convert.ToInt32(Session["UserId"]);

            /*********Jobs bid on*********/
            objJob.JobStatus = "B";
            objJobList = MatchBxCommon.GenerateBadge(objJobMod.GetJobDetailsForUser(objJob).ToList());
            TempData["JobsBidOnCount"] = objJobList.Count();
            bidRecord = objJobList.Count();
            if (bidRecord > recordDisplay)
            {
                bidloadmore = 1;
            }
            else
            {
                bidloadmore = 0;
            }

            objJobList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
            objJobList = CalculateBidAmountinDollar(objJobList);
            objJobList.ForEach(s => s.Isloadmore = bidloadmore);
            model.Bid = objJobList.OrderByDescending(s => s.JobId).Take(recordDisplay).ToList();
            return model;
            /*********Jobs bid on End*********/
        }

        public PartialViewResult JobsListed()
        {

            return PartialView("ListedJobs", GetDataForJobsListed());
        }
        public PartialViewResult JobsListedWithoutExchangeRate()
        {

            return PartialView("ListedJobs", GetDataForJobsListedWithoutExchangeRate());
        }
        public object GetDataForJobsListedWithoutExchangeRate()
        {

            dynamic model = new ExpandoObject();
            objJob.UserId = Convert.ToInt32(Session["UserId"]);

            /*********Jobs Listed*********/
            objJob.JobStatus = "P";
            decimal exchangerate = MatchBxCommon.GetExchangeRate();
            objJobList = MatchBxCommon.GenerateBadgeFromSession(objJobMod.GetJobDetailsForUser(objJob).ToList());
            objJobListFiltered = objJobList.GroupBy(x => x.JobId).Select(y => y.First()).ToList();
            foreach (var item1 in objJobListFiltered)
            {
                foreach (var item2 in objJobList)
                {
                    if (item1.JobId == item2.JobId)
                    {
                        if (item1.JobBiddingId > 0)
                        {
                            item1.JobBiddingList.Add(new JobBidding
                            {
                                JobBiddingId = item2.JobBiddingId,
                                BidMessage = item2.BidMessage,
                                BidAmount = item2.BidAmount,
                                BidUserName = item2.BidUserName,
                                UserId = item2.BidUserId,
                                BidUserProfilePic = item2.BidUserProfilePic,
                                TokenAddressPoster = item2.TokenAddressPoster,
                                TokenAddressSeeker = item2.TokenAddressSeeker,
                                IsApprovedPoster = item2.IsApprovedPoster,
                                IsApprovedSeeker = item2.IsApprovedSeeker,
                                BidAmountinDollar = Math.Round((item2.BidAmount * exchangerate), 2),
                                CompletionStatus = item2.CompletionStatus,
                                IsPending = item2.IsPending,
                                AcceptStatus = item2.AcceptStatus,
                                AcceptStatusHover = item2.AcceptStatusHover
                            });
                        }

                    }
                }
            }
            TempData["JobsListedCount"] = objJobListFiltered.Count();
            postedRecord = objJobListFiltered.Count();
            if (postedRecord > recordDisplay)
            {
                postedloadmore = 1;
            }
            else
            {
                postedloadmore = 0;
            }
            objJobListFiltered.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
            objJobListFiltered.ForEach(s => s.Isloadmore = postedloadmore);
            objJobListFiltered = CalculateBidAmountinDollarFromSession(objJobListFiltered);
            objJobListFiltered.ForEach(s => s.EndsIn = (s.JobCompletionDate.Subtract(DateTime.Now)).Days + " days, " + (s.JobCompletionDate.Subtract(DateTime.Now)).Hours + " hours");
            model.Posted = objJobListFiltered.OrderByDescending(s => s.JobId).Take(recordDisplay).ToList();
            /*********Jobs Listed End*********/
            return model;
        }
        public object GetDataForJobsListed()
        {

            dynamic model = new ExpandoObject();
            objJob.UserId = Convert.ToInt32(Session["UserId"]);

            /*********Jobs Listed*********/
            objJob.JobStatus = "P";
            decimal exchangerate = MatchBxCommon.GetExchangeRate();
            objJobList = MatchBxCommon.GenerateBadge(objJobMod.GetJobDetailsForUser(objJob).ToList());
            objJobListFiltered = objJobList.GroupBy(x => x.JobId).Select(y => y.First()).ToList();
            foreach (var item1 in objJobListFiltered)
            {
                foreach (var item2 in objJobList)
                {
                    if (item1.JobId == item2.JobId)
                    {
                        if (item1.JobBiddingId > 0)
                        {
                            item1.JobBiddingList.Add(new JobBidding
                            {
                                JobBiddingId = item2.JobBiddingId,
                                BidMessage = item2.BidMessage,
                                BidAmount = item2.BidAmount,
                                BidUserName = item2.BidUserName,
                                UserId = item2.BidUserId,
                                BidUserProfilePic = item2.BidUserProfilePic,
                                TokenAddressPoster = item2.TokenAddressPoster,
                                TokenAddressSeeker = item2.TokenAddressSeeker,
                                IsApprovedPoster = item2.IsApprovedPoster,
                                IsApprovedSeeker = item2.IsApprovedSeeker,
                                BidAmountinDollar = Math.Round((item2.BidAmount * exchangerate), 2),
                                CompletionStatus = item2.CompletionStatus,
                                IsPending = item2.IsPending,
                                AcceptStatus = item2.AcceptStatus,
                                AcceptStatusHover = item2.AcceptStatusHover
                            });
                        }

                    }
                }
            }
            TempData["JobsListedCount"] = objJobListFiltered.Count();
            postedRecord = objJobListFiltered.Count();
            if (postedRecord > recordDisplay)
            {
                postedloadmore = 1;
            }
            else
            {
                postedloadmore = 0;
            }
            objJobListFiltered.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
            objJobListFiltered.ForEach(s => s.Isloadmore = postedloadmore);
            objJobListFiltered = CalculateBidAmountinDollar(objJobListFiltered);
            objJobListFiltered.ForEach(s => s.Days = (s.JobCompletionDate.Subtract(DateTime.Now)).Days);
            objJobListFiltered.ForEach(s => s.Hours = (s.JobCompletionDate.Subtract(DateTime.Now)).Hours);
            objJobListFiltered.ForEach(s => s.Hours = (s.Days) >= 0 ? Math.Abs((s.Hours)) : s.Hours);
            objJobListFiltered.ForEach(s => s.EndsIn = (s.Days) + " days, " + (s.Hours) + " hours");
            //objJobListFiltered.ForEach(s => s.EndsIn = (s.JobCompletionDate.Subtract(DateTime.Now)).Days + " days, " + (s.JobCompletionDate.Subtract(DateTime.Now)).Hours + " hours");
            model.Posted = objJobListFiltered.OrderByDescending(s => s.JobId).Take(recordDisplay).ToList();
            /*********Jobs Listed End*********/
            return model;
        }

        [HttpPost]
        public PartialViewResult JobsCompleted()
        {

            return PartialView("JobsCompleted", GetDataForJobsCompleted());
        }
        public object GetDataForJobsCompleted()
        {

            dynamic model = new ExpandoObject();
            objJob.UserId = Convert.ToInt32(Session["UserId"]);

            /*********Jobs complete*********/
            objJob.JobStatus = "C";
            objJobList = MatchBxCommon.GenerateBadge(objJobMod.GetJobDetailsForUser(objJob).ToList());
            TempData["JobsCompleteCount"] = objJobList.Count();
            completeRecord = objJobList.Count();
            if (completeRecord > recordDisplay)
            {
                completeloadmore = 1;
            }
            else
            {
                completeloadmore = 0;
            }
            objJobList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
            objJobList = CalculateBidAmountinDollar(objJobList);
            objJobList.ForEach(s => s.Isloadmore = completeloadmore);

            model.Complete = objJobList.OrderByDescending(x => x.JobId).Take(recordDisplay).ToList();
            /*********Jobs complete End*********/
            return model;
        }

        [HttpPost]
        public PartialViewResult JobsPending()
        {
            return PartialView("JobsPending", GetDataForJobsPending());
        }
        public object GetDataForJobsPending()
        {
            dynamic model = new ExpandoObject();
            objJob.UserId = Convert.ToInt32(Session["UserId"]);

            objJob.JobStatus = "R";
            objJobList = MatchBxCommon.GenerateBadge(objJobMod.GetJobDetailsForUser(objJob).ToList());
            TempData["JobsPendingCount"] = objJobList.Count();
            completeRecord = objJobList.Count();
            //if (completeRecord > recordDisplay)
            //{
            //    completeloadmore = 1;
            //}
            //else
            //{
                //completeloadmore = 0;
            //}
            objJobList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
            objJobList = CalculateBidAmountinDollar(objJobList);
            //objJobList.ForEach(s => s.Isloadmore = completeloadmore);

            model.Pending = objJobList.OrderByDescending(x => x.JobId).ToList();

            return model;
        }

        [HttpPost]
        public PartialViewResult AddProfile()
        {

            dynamic model = new ExpandoObject();
            objUserProfile= objProfileMod.LoadUserProfile(Convert.ToInt32(Session["UserId"])).FirstOrDefault();
            objUserProfile.UserName = objUserProfile.UserName.Remove(0, 1);
            model.User = objUserProfile;
            Session["SkillsList"] = objUserSkillsMod.SkillsByUserId(Convert.ToInt32(Session["UserId"]));
            model.UserSkills = Session["SkillsList"];
            model.Skills = objSkillsMod.GetUniqueSkills(new Skills());
            return PartialView("Profile", model);
        }


        public List<Job> CalculateBidAmountinDollar(List<Job> jobList)
        {
            decimal exchangerate = MatchBxCommon.GetExchangeRate();
            jobList.ToList().ForEach(s => s.BudgetInDollar = Math.Round((s.BidAmount * exchangerate), 2));
            return jobList;
        }
        public List<Job> CalculateBidAmountinDollarFromSession(List<Job> jobList)
        {
            decimal exchangerate = 0.001M;
            if (Session["Exchange"] != null)
                exchangerate = Convert.ToDecimal(Session["Exchange"].ToString());
            jobList.ToList().ForEach(s => s.BudgetInDollar = Math.Round((s.BidAmount * exchangerate), 2));
            return jobList;
        }
        [HttpPost]
        public JsonResult LoadMoreListedJobs(int id)
        {
            dynamic model = new ExpandoObject();
            objJob.UserId = Convert.ToInt32(Session["UserId"]);
            objJob.JobStatus = "P";
            decimal exchangerate = MatchBxCommon.GetExchangeRate();
            objJobList = MatchBxCommon.GenerateBadge(objJobMod.GetJobDetailsForUser(objJob).Where(x => x.JobId < id).ToList());
            objJobListFiltered = objJobList.GroupBy(x => x.JobId).Select(y => y.First()).ToList();
            foreach (var item1 in objJobListFiltered)
            {
                foreach (var item2 in objJobList)
                {
                    if (item1.JobId == item2.JobId)
                    {
                        if (item1.JobBiddingId > 0)
                        {
                            item1.JobBiddingList.Add(new JobBidding
                            {
                                JobBiddingId = item2.JobBiddingId,
                                BidMessage = item2.BidMessage,
                                BidAmount = item2.BidAmount,
                                BidUserName = item2.BidUserName,
                                UserId = item2.BidUserId,
                                BidUserProfilePic = item2.BidUserProfilePic,
                                TokenAddressPoster = item2.TokenAddressPoster,
                                TokenAddressSeeker = item2.TokenAddressSeeker,
                                IsApprovedPoster = item2.IsApprovedPoster,
                                IsApprovedSeeker = item2.IsApprovedSeeker,
                                BidAmountinDollar = Math.Round((item2.BidAmount * exchangerate), 2),
                                CompletionStatus = item2.CompletionStatus,                                
                                IsPending = item2.IsPending,
                                AcceptStatus = item2.AcceptStatus,
                                AcceptStatusHover = item2.AcceptStatusHover
                            });
                        }
                    }
                }
            }
            postedRecord = objJobListFiltered.Count();
            if (postedRecord > recordDisplay)
            {
                postedloadmore = 1;
            }
            else
            {
                postedloadmore = 0;
            }
            objJobListFiltered.ForEach(x => x.Isloadmore = postedloadmore);
            objJobListFiltered = CalculateBidAmountinDollar(objJobListFiltered);
            objJobListFiltered.ForEach(s => s.EndsIn = (s.JobCompletionDate.Subtract(DateTime.Now)).Days + " days, " + (s.JobCompletionDate.Subtract(DateTime.Now)).Hours + " hours");
            model.Posted = objJobListFiltered.OrderByDescending(s => s.JobId).Take(recordDisplay);
            return Json(model.Posted, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public JsonResult LoadMoreProgressJobs(int id)
        {
            dynamic model = new ExpandoObject();
            objJob.UserId = Convert.ToInt32(Session["UserId"]);
            objJob.JobStatus = "A";
            objJobList = MatchBxCommon.GenerateBadge(objJobMod.GetJobDetailsForUser(objJob).Where(x => x.JobId < id).ToList());
            progressRecord = objJobList.Count();
            if (progressRecord > recordDisplay)
            {
                progressloadmore = 1;
            }
            else
            {
                progressloadmore = 0;
            }
            objJobList.ForEach(x => x.Isloadmore = progressloadmore);
            objJobList = CalculateBidAmountinDollar(objJobList);
            model.Progress = objJobList.OrderByDescending(s=>s.JobId).Take(recordDisplay);
            return Json(model.Progress, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public JsonResult LoadMoreCompletedJobs(int id)
        {
            dynamic model = new ExpandoObject();
            objJob.UserId = Convert.ToInt32(Session["UserId"]);
            objJob.JobStatus = "C";
            objJobList = MatchBxCommon.GenerateBadge(objJobMod.GetJobDetailsForUser(objJob).Where(x => x.JobId < id).ToList());
            completeRecord = objJobList.Count();
            if (completeRecord > recordDisplay)
            {
                completeloadmore = 1;
            }
            else
            {
                completeloadmore = 0;
            }
            objJobList.ForEach(x => x.Isloadmore = completeloadmore);
            objJobList = CalculateBidAmountinDollar(objJobList);
            model.Complete = objJobList.OrderByDescending(x => x.JobId).Take(recordDisplay);
            return Json(model.Complete, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public JsonResult LoadMoreBidJobs(int id)
        {
            dynamic model = new ExpandoObject();
            objJob.UserId = Convert.ToInt32(Session["UserId"]);
            objJob.JobStatus = "B";
            objJobList = MatchBxCommon.GenerateBadge(objJobMod.GetJobDetailsForUser(objJob).Where(x => x.JobId < id).ToList());
            bidRecord = objJobList.Count();
            if (bidRecord > recordDisplay)
            {
                bidloadmore = 1;
            }
            else
            {
                bidloadmore = 0;
            }
            objJobList.ForEach(x => x.Isloadmore = bidloadmore);
            objJobList = CalculateBidAmountinDollar(objJobList);
            objJobList.ForEach(s => s.Isloadmore = bidloadmore);
            model.Bid = objJobList.OrderByDescending(s => s.JobId).Take(recordDisplay);
            return Json(model.Bid, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public JsonResult MarkasComplete(int JobId, string UserRole, int UserId, string JobTitle)
        {
        
            string message = "";
            objJob.JobId = JobId;
            objJob.UserId = UserId;
            //objJob = objJobMod.GetARecord(JobId);
            objJob = objJobMod.GetJobAndPosterDetails(objJob).FirstOrDefault();
            if (Convert.ToInt32(Session["UserType"]) == 1)
            {
                objJob.JobStatusSeeker = "C";
            }
            else if (Convert.ToInt32(Session["UserType"]) == 2)
            {
                objJob.JobStatus = "C";
            }
            else if (Convert.ToInt32(Session["UserType"]) == 3)
            {
                if (UserRole == "P")
                {
                    objJob.JobStatus = "C";
                }
                else
                {
                    objJob.JobStatusSeeker = "C";
                }
            }
            if (objJobMod.Save(objJob) > 0)
            {
                //objNotification.ReceiverId = UserId;
                //objNotification.SenderId = Convert.ToInt32(Session["UserId"]); 

                //objNotification.Notification = "@"+Session["UserName"] + " has finished your job " + JobTitle  ;
                //objNotification.ReadStatus = 0;
                //objNotification.Header = "Job completed";
                //objNotiMod.Save(objNotification);

                //objUser = objUsersMod.GetList("*", " UserId = '" + UserId + "'").FirstOrDefault();
                string email = objJob.Email;
                string postername = objJob.FullName;
                string seekername = "@" + Session["UserName"].ToString();
                string jobtitle = JobTitle;
                if (MatchBxCommon.checkuseremailpreferences("4,2", Convert.ToInt32(Session["UserId"])) == true)
                {
                    if (Convert.ToInt32(Session["UserType"]) == 1)
                    {
                        MatchBxCommon.sendMarkasCompleteEmail(email, false, postername, seekername, jobtitle);
                    }
                    else if (Convert.ToInt32(Session["UserType"]) == 3)
                    {
                        if (UserRole != "P")
                        {
                            MatchBxCommon.sendMarkasCompleteEmail(email, false, postername, seekername, jobtitle);
                        }
                    }
                }

                message = "Success";
            }
            else
            {
                message = "Failed";
            }
            return Json(message, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public JsonResult RateUser(int JobId, int rating, string UserRole)
        {
            objJob = objJobMod.GetARecord(JobId);
            string message = "";
            if (Convert.ToInt32(Session["UserType"]) == 1)
            {
                objJob.JobPosterRating = rating;
            }
            else if (Convert.ToInt32(Session["UserType"]) == 2)
            {
                objJob.JobSeekerRating = rating;
            }
            else if (Convert.ToInt32(Session["UserType"]) == 3)
            {
                if (UserRole == "P")
                {
                    objJob.JobSeekerRating = rating;
                }
                else
                {
                    objJob.JobPosterRating = rating;
                }
            }
            if (objJobMod.Save(objJob) > 0)
            {
                message = "Success";
            }
            else
            {
                message = "Failed";
            }
            return Json(message, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public JsonResult BidOffer(int JobId, int JobBiddingId, string Status, string JobTitle, int UserId, string TokenAddressSeeker, string IsApprovedSeeker, decimal bidamount, int bidDuration)
        {
           
            string message = "";
            objJobbidding = objJobbiddingMod.GetList("*", " JobBiddingId = '" + JobBiddingId + "'").FirstOrDefault();
            objJobbidding.JobStatus = Status;
            //if(Status == "A")
            //{
            //    objJobbidding.JobCompletionDate = DateTime.Now.AddDays(bidDuration);
            //}
            if (objJobbiddingMod.JobBidAcceptorDecline(objJobbidding))
            {
                message = "Success";                  
                
                //objNotification.ReceiverId = UserId;
                //objNotification.SenderId = Convert.ToInt32(Session["UserId"]);
                //objNotification.ReadStatus = 0;
                //if (Status == "A")
                //{



                //    objNotification.Notification = "@" + Session["UserName"] + " has accepted your bid for job: " + JobTitle;
                //    objNotification.Header = "Bid accepted";
                //}
                //else
                //{
                //    objNotification.Notification = "Your job has been cancelled as it went against the terms of this jobsite";
                //    objNotification.Header = "Bid cancelled";
                //}
                //objNotiMod.Save(objNotification);
                if (MatchBxCommon.checkuseremailpreferences("2,4", UserId) == true)
                {
                    objUser = objUsersMod.GetList("*", " UserId = '" + UserId + "'").FirstOrDefault();
                    string email = objUser.Email;
                    string username = "@"+Session["UserName"].ToString();
                    string fullname = objUser.FullName != null ? objUser.FullName : objUser.UserName;
                    if (Status == "A")
                    {
                        //MatchBxCommon.sendBidAcceptanceEmail(fullname, username, JobTitle, JobId, email, objJobbidding.BidAmount, false);
                    }
                    else
                    {
                        MatchBxCommon.sendBidDeclineEmail(fullname, username, JobTitle, JobId, email, objJobbidding.BidAmount, false);
                    }
                }

            }
            else
            {
                message = "Failed";
            }
           
            return Json(message, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public JsonResult SaveTransactionDetail(int JobId, int UserId,string TransactionType,string ProcessType,string Hash, decimal BidAmount, string Address)
        {
            decimal BurnPer = 0;
            if (ProcessType == "C")
            {
                BurnPer = Convert.ToDecimal(ConfigurationManager.AppSettings["BurnPercentage"]);
                //var jobObj = objJobMod.GetARecord(JobId);
                //var jobObj = objJobMod.GetList(" * ", "JobId =" + JobId).FirstOrDefault();
                //if (jobObj.GigSubscriptionId > 0)
                //{
                //    BidAmount = jobObj.BudgetASP;
                //}
                //else {
                //    BidAmount = objJobbiddingMod.GetList(" BidAmount ", " JobId = " + JobId + " and IsAccepted = 'Y' ").FirstOrDefault().BidAmount;
                //}
                objJobbidding.JobId = JobId;
                BidAmount = objJobbiddingMod.GetBudgetAmount(objJobbidding).FirstOrDefault().BidAmount;
            }
            string message = "";
            TransactionDetailModel _TransactionDetailModel = new TransactionDetailModel();
            TransactionDetail _TransactionDetail = new TransactionDetail();

            _TransactionDetail.UserId = UserId;
            _TransactionDetail.JobId = JobId;
            _TransactionDetail.Hash = Hash;            
            _TransactionDetail.Amount = BidAmount;           
            _TransactionDetail.TransactionType = TransactionType;
            _TransactionDetail.ProcessType = ProcessType;           
            _TransactionDetail.IsApproved = "N";
            _TransactionDetail.Address = Address;
            _TransactionDetail.BurnPer = BurnPer;
            if (_TransactionDetailModel.Save(_TransactionDetail) > 0)
            {
                message = "Success";
            }
            else
            {
                message = "Failed";
            }
            return Json(message, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult UpdateApprovalTransaction(int UserId,string Address)
        {
            
            string message = "";
            TransactionDetailModel _TransactionDetailModel = new TransactionDetailModel();
            TransactionDetail _TransactionDetail = new TransactionDetail();

            _TransactionDetail.UserId = UserId;            
            _TransactionDetail.Address = Address;
            if (_TransactionDetailModel.UpdateApprovalTransaction(_TransactionDetail) > 0)
            {
                message = "Success";
            }
            else
            {
                message = "Failed";
            }
            return Json(message, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult CheckPendingTransactions(int JobId)
        {           
            string message = "";
            JobModel _JobModel = new JobModel();
            Job _Job = new Job();
            List<Job> _JobList = new List<Job>();

            _Job.JobId = JobId;
            _JobList = _JobModel.CheckPendingTransactions(_Job);
            if (_JobList.Count > 0)
            {                
                return Json(_JobList, JsonRequestBehavior.AllowGet);
            }
            else
            {                
                return Json("Failed", JsonRequestBehavior.AllowGet);
            }            
        }

        [HttpPost]
        public JsonResult UpdateTransactionDetail(int JobId, int UserId, string TransactionType, string ProcessType, string Hash)
        {            
            TransactionDetailModel _TransactionDetailModel = new TransactionDetailModel();
            TransactionDetail _TransactionDetail = new TransactionDetail();

            string message = "";
            _TransactionDetail.UserId = UserId;
            _TransactionDetail.JobId = JobId;
            _TransactionDetail.Hash = Hash;            
            _TransactionDetail.TransactionType = TransactionType;
            _TransactionDetail.ProcessType = ProcessType;
            _TransactionDetail.IsApproved = "N";
            if (_TransactionDetailModel.UpdateTransactionDetail(_TransactionDetail))
            {
                message = "Success";
            }
            else
            {
                message = "Failed";
            }
            return Json(message, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult MetaMaskCancel(int JobId)
        {           
            string message = "";
            objJobbidding.JobId = JobId;
            if (objJobbiddingMod.MetaMaskCancel(objJobbidding))
            {
                message = "Success";
            }
            else
            {
                message = "Failed";
            }
            return Json(message, JsonRequestBehavior.AllowGet);
        }
        
        [HttpPost]
        public JsonResult DeleteOffer(int JobBiddingId)
        {
            string message = "";
            JobBiddingModel _JobBiddingModel = new JobBiddingModel();
            JobBidding _JobBidding = new JobBidding();
            if(JobBiddingId > 0)
            {
                _JobBidding = _JobBiddingModel.GetList(" * ", " JobBiddingId = " + JobBiddingId).FirstOrDefault();
                _JobBidding.IsActive = "N";
                if(_JobBiddingModel.Save(_JobBidding) > 0)
                {
                    message = "Success";
                }
                else
                {
                    message = "Failed";
                }
            }            
            return Json(message, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public PartialViewResult Security()
        {
            TempData["Password"] = objUsersMod.GetList("*", " UserId = '" + Convert.ToInt32(Session["UserId"]) + "'").FirstOrDefault().Password;
            return PartialView("Security");
        }
        [HttpPost]
        public JsonResult UpdateSecurity(string Password)
        {
            string message = "";
            objUser = objUsersMod.GetList("*", " UserId = '" + Convert.ToInt32(Session["UserId"]) + "'").FirstOrDefault();
            objUser.Password = Password;
            objNotification.ReceiverId = objUser.UserId;
            objNotification.SenderId = objUser.UserId;
            objNotification.ReadStatus = 0;
            objNotification.Notification = "Password has been reset by " + objUser.UserName;
            int returnValue = objUsersMod.Save(objUser);
            if (returnValue > 0)
            {
                MatchBxCommon.sendResetPasswordAckEmail(objUser, false);
                //int retstatus = objNotiMod.Save(objNotification);
                message = "Success";
            }
            else
            {
                message = "Failed";
            }
            return Json(message, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public JsonResult UpdateProfile(string UserName, string FullName, string Bio, int[] skills)
        {
            dynamic result = new ExpandoObject();
            string message = "";
            string profilepic = "";
            objUser = objUsersMod.GetList("*", " UserId = '" + Convert.ToInt32(Session["UserId"]) + "'").FirstOrDefault();
            objUser.UserName = UserName;
            if(FullName!="")
            {
                objUser.FullName = CultureInfo.CurrentCulture.TextInfo.ToTitleCase(FullName);
            }
            else
            {
                objUser.FullName = FullName;
            }
            
            objUserProfile = objProfileMod.GetList("*", " UserId = '" + Convert.ToInt32(Session["UserId"]) + "'").FirstOrDefault();
            UserProfile objProfile = new UserProfile();
            if (objUserProfile != null)
            {
                objProfile = objUserProfile;
                objProfile.Bio = Bio;
                if (Session["TempProfilePic"] != null)
                {
                    objProfile.ProfilePic = "/ProfilePic/" + Session["TempProfilePic"].ToString();
                    profilepic = "/ProfilePic/" + Session["TempProfilePic"].ToString();
                }
                else
                {
                    profilepic = Session["ProfilePic"].ToString();
                }
            }
            objProfile.UserId = Convert.ToInt32(Session["UserId"]);


            objUser.UserProfileList.Add(objProfile);

            List<UserSkillsMapping> objSelectedSkills = (List<UserSkillsMapping>)Session["SkillsList"];

            List<UserSkillsMapping> objDelSkills = (List<UserSkillsMapping>)Session["SkillsList"];

            List<UserSkillsMapping> objFilteredSkills = new List<UserSkillsMapping>();

            if (skills != null)
            {
                foreach (var item in skills)
                {
                    objUser.UserSkillsMappingList.Add(new UserSkillsMapping
                    {
                        UserId = Convert.ToInt32(Session["UserId"]),
                        SkillsId = item
                    });
                }
                foreach (var item1 in objUser.UserSkillsMappingList)
                {
                    foreach (var item2 in objSelectedSkills)
                    {
                        if (item1.SkillsId == item2.SkillsId)
                        {
                            item1.UserSkillsMappingId = item2.UserSkillsMappingId;
                        }
                    }
                }
                foreach (var item3 in objDelSkills)
                {
                    var status = 1;
                    foreach (var item4 in objUser.UserSkillsMappingList)
                    {
                        if (!objUser.UserSkillsMappingList.Any(x => x.SkillsId == item3.SkillsId))
                        {
                            status = 1;
                        }
                        else
                        {
                            status = 0;
                        }
                    }
                    if (status == 1)
                    {
                        objFilteredSkills.Add(item3);
                    }
                }

            }
            else
            {
                objFilteredSkills = objDelSkills;
            }
            string delskills = "";
            foreach (var item in objFilteredSkills)
            {
                if (objFilteredSkills.IndexOf(item) == objFilteredSkills.Count() - 1)
                {
                    delskills += item.SkillsId;
                }
                else
                {
                    delskills += item.SkillsId + ",";
                }

            }

            if (objUsersMod.SaveWithTransaction(objUser) > 0)
            {
                if (delskills.Length > 0)
                {
                    objUserSkillsMapping.UserId = Convert.ToInt32(Session["UserId"]);
                    objUserSkillsMapping.SkillsList = delskills;
                    if (objUserSkillsMod.Delete(objUserSkillsMapping))
                    {
                        message = "Success";
                    }

                }
                else
                {
                    message = "Success";
                }
                Session["ProfilePic"]= profilepic;
                result.Src = profilepic;
                result.Message = message;

            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public JsonResult CheckUserNameAvailabilty(string UserName)
        {
            string message = "";
            objUsersList = objUsersMod.GetList("*", " UserName = '" + UserName + "'");
            if (objUsersList.Count() > 0)
            {
                message = "True";
            }
            else
            {
                message = "False";
            }
            return Json(message, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public PartialViewResult EmailPreferences()
        {
            List<EmailPreference> prefs = new List<EmailPreference>();
            prefs = new EmailPreferenceModel().GetList();

            List<UserEmailPreferenceMapping> emailPref = new List<UserEmailPreferenceMapping>();
            emailPref = new UserEmailPreferenceMappingModel().GetUserEmailPreference(Convert.ToInt32(Session["UserId"]));

            if (prefs.Count > emailPref.Count && emailPref.Count > 0)
            {
                foreach (var pref in prefs)
                {
                    if (!emailPref.Any(p => p.EmailPreferenceId == pref.EmailPreferenceId))
                    {
                        emailPref.Add(new UserEmailPreferenceMapping()
                        {
                            CheckStatus = true,
                            Description = pref.Description,
                            EmailPreferenceId = pref.EmailPreferenceId,
                            UserEmailPreferenceMappingId = 0,
                            UserId = Convert.ToInt32(Session["UserId"])
                        });
                    }
                }
            }
            else if (emailPref.Count == 0)
            {
                foreach (var pref in prefs)
                {
                    emailPref.Add(new UserEmailPreferenceMapping()
                    {
                        CheckStatus = true,
                        Description = pref.Description,
                        EmailPreferenceId = pref.EmailPreferenceId,
                        UserEmailPreferenceMappingId = 0,
                        UserId = Convert.ToInt32(Session["UserId"])
                    });
                }
            }

            objJob.EmailPreferences = emailPref;
            return PartialView("Preferences", objJob);
        }

        [HttpPost]
        public ActionResult UpdateEmailPreference(List<UserEmailPreferenceMapping> userPref)
        {
            var userId = Convert.ToInt32(Session["UserId"]);
            userPref.ForEach(u => u.UserId = userId);
            var status = 1;
            try
            {
                foreach (var item in userPref)
                {
                    if (objEmailPrefMod.Save(item) >0)
                    {
                        status *= 1;
                    }
                    else
                    {
                        status *= 0;
                    }
                }
                if (status == 1)
                {
                    return Json("Email preferences updated", JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json("Email preferences not updated.", JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception e)
            {
                return Json("Can't update your email preferences", JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult Home()
        {
            Session["category"] = "B";
            if (Session["UserId"] != null)
            {
                return RedirectToAction("Index", "Dashboard");
            }
            else
            {
                return RedirectToAction("Index", "Jobs");
            }
        }

        public ActionResult UploadDocuments()
        {            
            string message = "";           

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
                        message = InputFileName;
                    }
                    catch (Exception ex)
                    {
                        message = "failed";
                    }                  

                }
                else
                {
                    message = "failed";
                }

            }                      
            return Json(message, JsonRequestBehavior.AllowGet);
        }
        public ActionResult DownloadFile(string FileName)
        {

            //string path = AppDomain.CurrentDomain.BaseDirectory + sourceFolderPath;
            string path = sourceFolderPath;
            string virtualpath = "~/Documents/" + FileName;
            var absolutePath = HttpContext.Server.MapPath(virtualpath);
            if (System.IO.File.Exists(absolutePath))
            {
                byte[] fileBytes = System.IO.File.ReadAllBytes(absolutePath);
                string fileName = FileName;
                return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, fileName);
            }
            else {
                return new HttpStatusCodeResult(System.Net.HttpStatusCode.NotFound);
            }
        }
        [HttpPost]
        public JsonResult CheckApprovedAmount(int UserId)
        {            
            TransactionDetail _TransactionDetail = new TransactionDetail();
            TransactionDetailModel _TransactionDetailModel = new TransactionDetailModel();
            _TransactionDetail.UserId = UserId;
            _TransactionDetail = _TransactionDetailModel.CheckApprovedAmount(_TransactionDetail).FirstOrDefault();            
            return Json(_TransactionDetail, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public JsonResult ResetWallet(string WalletAddress, int UserId)
        {
            string message = "";
            TransactionDetail _TransactionDetail = new TransactionDetail();
            TransactionDetailModel _TransactionDetailModel = new TransactionDetailModel();
            _TransactionDetail.Address = WalletAddress;
            _TransactionDetail.UserId = UserId;
            if (_TransactionDetailModel.ResetWalletAddress(_TransactionDetail) > 0)
            {
                message = "Success";
                MatchBxCommon.SendResetWalletEmail(Session["FullName"].ToString(), Session["Email"].ToString(), false);
            }
            else
            {
                message = "Failed";
            }
            return Json(message, JsonRequestBehavior.AllowGet);
        }

        //[HttpPost]
        //public PartialViewResult LoadGigsLibrary()
        //{
        //    dynamic model = new ExpandoObject();
        //    List<Gig> objGigList = MatchBxCommon.GenerateBadgeForGig(objGigMod.GetUserGigs(Convert.ToInt32(Session["UserId"])).GroupBy(g => g.GigId).Select(g => g.FirstOrDefault()).ToList());
        //    objGigList = objGigList.Where(x => x.Role == "C" && x.GigStatus == "P").OrderByDescending(x => x.GigId).ToList();

        //    completeRecord = objGigList.Count();
        //    if (completeRecord > recordDisplay)
        //    {
        //        bidloadmore = 1;
        //    }
        //    else
        //    {
        //        bidloadmore = 0;
        //    }

        //    objGigList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
        //    decimal exchangerate = MatchBxCommon.GetExchangeRate();
        //    objGigList.ForEach(s => s.BudgetInDollar = Math.Round((s.BudgetInDollar * exchangerate), 2));
        //    objGigList.ForEach(s => s.Isloadmore = bidloadmore);
        //    TempData["Library"] = objGigList.Count;
        //    model.Library = objGigList.Take(recordDisplay).ToList();
        //    return PartialView("GigsLibrary", model);
        //}
        [HttpPost]
        public PartialViewResult LoadMyServices()
        {
            objGig = new Gig()
            {
                JobCategoryId = 0,
                UserId = Convert.ToInt32(Session["UserId"]),
                TrendingTagsIdList = "0",
                SkillsList = "0",
                MinBudget = 0,
                MaxBudget = 0,
                SortBy = "Y"
            };
            dynamic model = new ExpandoObject();
            List<Gig> objGigList = MatchBxCommon.GenerateBadgeForGig(objGigMod.GetMyServices(objGig));
            objGigList = objGigList.OrderByDescending(x => x.GigId).ToList();

            completeRecord = objGigList.Count();
            if (completeRecord > recordDisplay)
            {
                bidloadmore = 1;
            }
            else
            {
                bidloadmore = 0;
            }

            objGigList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
            decimal exchangerate = MatchBxCommon.GetExchangeRate();
            objGigList.ForEach(s => s.BudgetInDollar = Math.Round((s.BudgetInDollar * exchangerate), 2));
            objGigList.ForEach(s => s.Isloadmore = bidloadmore);
            TempData["MyServices"] = objGigList.Count;
            model.Services = objGigList.Take(recordDisplay).ToList();
            return PartialView("MyServices", model);
        }
        [HttpPost]
        public PartialViewResult LoadPurchasedServices()
        {
            objGig = new Gig()
            {
                JobCategoryId = 0,
                UserId = Convert.ToInt32(Session["UserId"]),
                TrendingTagsIdList = "0",
                SkillsList = "0",
                MinBudget = 0,
                MaxBudget = 0,
                SortBy = "Y"
            };
            dynamic model = new ExpandoObject();
            List<Gig> objGigList = MatchBxCommon.GenerateBadgeForGig(objGigMod.GetPurchasedServices(objGig));
            objGigList = objGigList.OrderByDescending(x => x.GigSubscriptionId).ToList();

            completeRecord = objGigList.Count();
            if (completeRecord > recordDisplay)
            {
                bidloadmore = 1;
            }
            else
            {
                bidloadmore = 0;
            }

            objGigList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
            decimal exchangerate = MatchBxCommon.GetExchangeRate();
            objGigList.ForEach(s => s.BudgetInDollar = Math.Round((s.BudgetInDollar * exchangerate), 2));
            objGigList.ForEach(s => s.Isloadmore = bidloadmore);
            TempData["PurchasedServices"] = objGigList.Count;
            model.PurchasedServices = objGigList.Take(recordDisplay).ToList();
            return PartialView("PurchasedServices", model);
        }
        [HttpPost]
        public PartialViewResult LoadMyJobs()
        {
            objJob = new Job()
            {
                UserId = Convert.ToInt32(Session["UserId"]),
                CurrentDate = DateTime.Now
            };
            dynamic model = new ExpandoObject();
            List<Job> objJobList = MatchBxCommon.GenerateBadge(objJobMod.GetMyJobs(objJob));
            objJobList = objJobList.OrderByDescending(x => x.JobId).ToList();

            completeRecord = objJobList.Count();
            if (completeRecord > recordDisplay)
            {
                bidloadmore = 1;
            }
            else
            {
                bidloadmore = 0;
            }

            objJobList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
            decimal exchangerate = MatchBxCommon.GetExchangeRate();
            objJobList.ForEach(s => s.BudgetInDollar = Math.Round((s.BudgetInDollar * exchangerate), 2));
            objJobList.ForEach(s => s.Isloadmore = bidloadmore);
            TempData["MyJobs"] = objJobList.Count;
            model.MyJobs = objJobList.Take(recordDisplay).ToList();
            return PartialView("MyJobs", model);
        }
        [HttpPost]
        public PartialViewResult LoadJobsBidOn()
        {
            objJob = new Job()
            {
                UserId = Convert.ToInt32(Session["UserId"]),
                CurrentDate = DateTime.Now
            };
            dynamic model = new ExpandoObject();
            List<Job> objJobList = MatchBxCommon.GenerateBadge(objJobMod.GetJobsBidOn(objJob));
            objJobList = objJobList.OrderByDescending(x => x.JobBiddingId).ToList();

            completeRecord = objJobList.Count();
            if (completeRecord > recordDisplay)
            {
                bidloadmore = 1;
            }
            else
            {
                bidloadmore = 0;
            }

            objJobList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
            decimal exchangerate = MatchBxCommon.GetExchangeRate();
            objJobList.ForEach(s => s.BudgetInDollar = Math.Round((s.BudgetInDollar * exchangerate), 2));
            objJobList.ForEach(s => s.Isloadmore = bidloadmore);
            TempData["JobsBidOn"] = objJobList.Count;
            model.JobsBidOn = objJobList.Take(recordDisplay).ToList();
            return PartialView("JobsBidOn", model);
        }
        [HttpPost]
        public PartialViewResult LoadGigsPending()
        {
            dynamic model = new ExpandoObject();
            List<Gig> objGigList = MatchBxCommon.GenerateBadgeForGig(objGigMod.GetUserGigs(Convert.ToInt32(Session["UserId"])).GroupBy(g => g.GigId).Select(g => g.FirstOrDefault()).ToList());
            objGigList = objGigList.Where(x => x.Role == "C" && x.GigStatus == "R").OrderByDescending(x => x.GigId).ToList();

            completeRecord = objGigList.Count();
            if (completeRecord > recordDisplay)
            {
                bidloadmore = 1;
            }
            else
            {
                bidloadmore = 0;
            }

            objGigList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
            decimal exchangerate = MatchBxCommon.GetExchangeRate();
            objGigList.ForEach(s => s.BudgetInDollar = Math.Round((s.BudgetInDollar * exchangerate), 2));
            objGigList.ForEach(s => s.Isloadmore = bidloadmore);
            TempData["Pending"] = objGigList.Count;
            model.Pending = objGigList.Take(recordDisplay).ToList();
            return PartialView("GigsPending", model);
        }
        [HttpPost]
        public PartialViewResult LoadGigsSubRequest()
        {
            dynamic model = new ExpandoObject();
            List<Gig> objGigList = MatchBxCommon.GenerateBadgeForGig(objGigMod.GetUserGigs(Convert.ToInt32(Session["UserId"])).ToList());
            List<Gig> objGigListMain = new List<Gig>();
            List<GigSubscription> objGigSubscription = new List<GigSubscription>();
            foreach (var gig in objGigList)
            {
                var nop = objGigListMain.Where(x => x.GigId == gig.GigId).ToList().Count;
                if (objGigListMain.Where(x => x.GigId == gig.GigId).ToList().Count == 0)
                {
                    objGigListMain.Add(new Gig()
                    {
                        GigTitle = gig.GigTitle,
                        GigId = gig.GigId,
                        GigDescription = gig.GigDescription,
                        BudgetASP = gig.BudgetASP,
                        BudgetInDollar = gig.BudgetInDollar,
                        UserId = gig.UserId,
                        Commission = gig.Commission,
                        TotalBudget = gig.TotalBudget,
                        IsGigEnabled = gig.IsGigEnabled,
                        GigDuration = gig.GigDuration,
                        Role = gig.Role,
                        GigSubscriptionList = new List<GigSubscription>()
                    });
                    if (gig.GigSubscriptionStatus == "S")
                    {
                        objGigSubscription.Add(new GigSubscription()
                        {
                            GigSubscriptionId = gig.GigSubscriptionId,
                            GigId = gig.GigId,
                            JobPosterId = gig.JobPosterId,
                            Description = gig.Description,
                            IsActive = gig.IsActive,
                            CreatedDate = gig.CreatedDate,
                            ModifiedDate = gig.ModifiedDate,
                            PosterFullName = gig.PosterFullName,
                            PosterProfilePic = gig.PosterProfilePic,
                            GigSubscriptionStatus = gig.GigSubscriptionStatus,
                            SubscribedDateDisplay = gig.SubscribedDateDisplay,
                            JobsCompleted = gig.JobsCompleted,
                            JobCompletionDateDisplay = gig.JobCompletionDateDisplay,
                            Title = gig.Title
                        });
                    }
                }
                else
                {
                    if (gig.GigSubscriptionStatus == "S")
                    {
                        objGigSubscription.Add(new GigSubscription()
                        {
                            GigSubscriptionId = gig.GigSubscriptionId,
                            GigId = gig.GigId,
                            JobPosterId = gig.JobPosterId,
                            Description = gig.Description,
                            IsActive = gig.IsActive,
                            CreatedDate = gig.CreatedDate,
                            ModifiedDate = gig.ModifiedDate,
                            PosterFullName = gig.PosterFullName,
                            PosterProfilePic = gig.PosterProfilePic,
                            GigSubscriptionStatus = gig.GigSubscriptionStatus,
                            SubscribedDateDisplay = gig.SubscribedDateDisplay,
                            JobsCompleted = gig.JobsCompleted,
                            JobCompletionDateDisplay = gig.JobCompletionDateDisplay,
                            Title = gig.Title
                        });
                    }
                }
            }
            foreach (var gigSub in objGigSubscription)
            {
                objGigListMain.Where(x => x.GigId == gigSub.GigId).ToList().ForEach(p => { p.GigSubscriptionList.Add(gigSub); p.GigSubscriptionStatus = "S"; });
            }
            objGigListMain = objGigListMain.Where(x => x.Role == "C" && x.GigSubscriptionStatus == "S").OrderByDescending(x => x.GigId).ToList();

            completeRecord = objGigListMain.Count();
            if (completeRecord > recordDisplay)
            {
                bidloadmore = 1;
            }
            else
            {
                bidloadmore = 0;
            }

            objGigListMain.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
            decimal exchangerate = MatchBxCommon.GetExchangeRate();
            objGigListMain.ForEach(s => s.BudgetInDollar = Math.Round((s.BudgetInDollar * exchangerate), 2));
            objGigListMain.ForEach(s => s.Isloadmore = bidloadmore);
            TempData["SubRequest"] = objGigListMain.Count;
            model.Request = objGigListMain.Take(recordDisplay).ToList();
            return PartialView("GigsSubRequest", model);
        }
        [HttpPost]
        public PartialViewResult LoadGigsSubPending()
        {
            dynamic model = new ExpandoObject();
            List<Gig> objGigList = MatchBxCommon.GenerateBadgeForGig(objGigMod.GetUserGigs(Convert.ToInt32(Session["UserId"])).ToList());
            objGigList = objGigList.Where(x => x.Role != "C" && x.GigSubscriptionStatus == "S").OrderByDescending(x => x.GigSubscriptionId).ToList();

            completeRecord = objGigList.Count();
            if (completeRecord > recordDisplay)
            {
                bidloadmore = 1;
            }
            else
            {
                bidloadmore = 0;
            }

            objGigList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
            decimal exchangerate = MatchBxCommon.GetExchangeRate();
            objGigList.ForEach(s => s.BudgetInDollar = Math.Round((s.BudgetInDollar * exchangerate), 2));
            objGigList.ForEach(s => s.Isloadmore = bidloadmore);
            TempData["SubPending"] = objGigList.Count;
            model.SubPending = objGigList.Take(recordDisplay).ToList();
            return PartialView("GigsSubPending", model);
        }
        [HttpPost]
        public PartialViewResult LoadGigsPayPending()
        {
            dynamic model = new ExpandoObject();
            List<Gig> objGigList = MatchBxCommon.GenerateBadgeForGig(objGigMod.GetUserGigs(Convert.ToInt32(Session["UserId"])).ToList());
            var PayToMePending = objGigList.Where(x => x.Role == "C" && x.GigSubscriptionStatus == "A").OrderByDescending(x => x.GigSubscriptionId).ToList();
            var PayToYouPending = objGigList.Where(x => x.Role != "C" && x.GigSubscriptionStatus == "A").OrderByDescending(x => x.GigSubscriptionId).ToList();
            PayToMePending.AddRange(PayToYouPending);

            completeRecord = PayToMePending.Count();
            if (completeRecord > recordDisplay)
            {
                bidloadmore = 1;
            }
            else
            {
                bidloadmore = 0;
            }

            PayToMePending.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
            decimal exchangerate = MatchBxCommon.GetExchangeRate();
            PayToMePending.ForEach(s => s.BudgetInDollar = Math.Round((s.BudgetInDollar * exchangerate), 2));
            PayToMePending.ForEach(s => s.Isloadmore = bidloadmore);
            PayToMePending = PayToMePending.OrderByDescending(x => x.GigSubscriptionId).ToList();
            TempData["PayPending"] = PayToMePending.Count;
            model.PayPending = PayToMePending.Take(recordDisplay).ToList();
            return PartialView("GigsPayPending", model);
        }
        //public PartialViewResult LoadMoreGigs(string type, int id)
        //{
        //    objJob.UserId = Convert.ToInt32(Session["UserId"]);
        //    decimal exchangerate = MatchBxCommon.GetExchangeRate();
        //    List<Gig> objGigList = new List<Gig>();
        //    List<Gig> objGigListFiltered = new List<Gig>();
        //    #region library
        //    if (type == "library")
        //    {
        //        objGigList = MatchBxCommon.GenerateBadgeForGig(objGigMod.GetUserGigs(Convert.ToInt32(Session["UserId"])).Where(g => g.GigId < id).GroupBy(g => g.GigId).Select(g => g.FirstOrDefault()).ToList());
        //        objGigList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
        //        objGigList.ForEach(s => s.BudgetInDollar = Math.Round((s.BudgetInDollar * exchangerate), 2));
        //        objGigListFiltered = objGigList.GroupBy(x => x.GigId).Select(y => y.First()).ToList();
        //        objGigListFiltered = objGigListFiltered.Where(x => x.Role == "C" && x.GigStatus == "P").OrderByDescending(x => x.GigId).ToList();

        //        postedRecord = objGigListFiltered.Count();
        //        if (postedRecord > recordDisplay)
        //        {
        //            postedloadmore = 1;
        //        }
        //        else
        //        {
        //            postedloadmore = 0;
        //        }

        //        objGigListFiltered.ForEach(x => { x.Isloadmore = postedloadmore; x.Category = "library"; });
        //        objGigListFiltered = objGigListFiltered.Take(recordDisplay).ToList();
        //    }
        //    #endregion
        //    #region pending
        //    else if (type == "pending")
        //    {
        //        objGigList = MatchBxCommon.GenerateBadgeForGig(objGigMod.GetUserGigs(Convert.ToInt32(Session["UserId"])).Where(g => g.GigId < id).GroupBy(g => g.GigId).Select(g => g.FirstOrDefault()).ToList());
        //        objGigList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
        //        objGigList.ForEach(s => s.BudgetInDollar = Math.Round((s.BudgetInDollar * exchangerate), 2));
        //        objGigListFiltered = objGigList.GroupBy(x => x.GigId).Select(y => y.First()).ToList();
        //        objGigListFiltered = objGigListFiltered.Where(x => x.Role == "C" && x.GigStatus == "R").OrderByDescending(x => x.GigId).ToList();

        //        postedRecord = objGigListFiltered.Count();
        //        if (postedRecord > recordDisplay)
        //        {
        //            postedloadmore = 1;
        //        }
        //        else
        //        {
        //            postedloadmore = 0;
        //        }

        //        objGigListFiltered.ForEach(x => { x.Isloadmore = postedloadmore; x.Category = "pending"; });
        //        objGigListFiltered = objGigListFiltered.Take(recordDisplay).ToList();
        //    }
        //    #endregion
        //    #region subreq
        //    else if (type == "subreq")
        //    {
        //        objGigList = MatchBxCommon.GenerateBadgeForGig(objGigMod.GetUserGigs(Convert.ToInt32(Session["UserId"])).ToList());
        //        objGigList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
        //        objGigList.ForEach(s => s.BudgetInDollar = Math.Round((s.BudgetInDollar * exchangerate), 2));
        //        List<Gig> objGigListMain = new List<Gig>();
        //        List<GigSubscription> objGigSubscription = new List<GigSubscription>();
        //        foreach (var gig in objGigList)
        //        {
        //            var nop = objGigListMain.Where(x => x.GigId == gig.GigId).ToList().Count;
        //            if (objGigListMain.Where(x => x.GigId == gig.GigId).ToList().Count == 0)
        //            {
        //                objGigListMain.Add(new Gig()
        //                {
        //                    GigTitle = gig.GigTitle,
        //                    GigId = gig.GigId,
        //                    GigDescription = gig.GigDescription,
        //                    BudgetASP = gig.BudgetASP,
        //                    BudgetInDollar = gig.BudgetInDollar,
        //                    UserId = gig.UserId,
        //                    Commission = gig.Commission,
        //                    TotalBudget = gig.TotalBudget,
        //                    IsGigEnabled = gig.IsGigEnabled,
        //                    GigDuration = gig.GigDuration,
        //                    GigSubscriptionStatus = gig.GigSubscriptionStatus,
        //                    Role = gig.Role,
        //                    GigSubscriptionList = new List<GigSubscription>()
        //                });
        //                if (gig.GigSubscriptionStatus == "S")
        //                {
        //                    objGigSubscription.Add(new GigSubscription()
        //                    {
        //                        GigSubscriptionId = gig.GigSubscriptionId,
        //                        GigId = gig.GigId,
        //                        JobPosterId = gig.JobPosterId,
        //                        Description = gig.Description,
        //                        IsActive = gig.IsActive,
        //                        CreatedDate = gig.CreatedDate,
        //                        ModifiedDate = gig.ModifiedDate,
        //                        PosterFullName = gig.PosterFullName,
        //                        PosterProfilePic = gig.PosterProfilePic,
        //                        SubscribedDateDisplay = gig.SubscribedDateDisplay,
        //                        JobsCompleted = gig.JobsCompleted,
        //                        JobCompletionDateDisplay = gig.JobCompletionDateDisplay,
        //                        Title = gig.Title
        //                    });
        //                }
        //            }
        //            else
        //            {
        //                if (gig.GigSubscriptionStatus == "S")
        //                {
        //                    objGigSubscription.Add(new GigSubscription()
        //                    {
        //                        GigSubscriptionId = gig.GigSubscriptionId,
        //                        GigId = gig.GigId,
        //                        JobPosterId = gig.JobPosterId,
        //                        Description = gig.Description,
        //                        IsActive = gig.IsActive,
        //                        CreatedDate = gig.CreatedDate,
        //                        ModifiedDate = gig.ModifiedDate,
        //                        PosterFullName = gig.PosterFullName,
        //                        PosterProfilePic = gig.PosterProfilePic,
        //                        SubscribedDateDisplay = gig.SubscribedDateDisplay,
        //                        JobsCompleted = gig.JobsCompleted,
        //                        JobCompletionDateDisplay = gig.JobCompletionDateDisplay,
        //                        Title = gig.Title
        //                    });
        //                }
        //            }
        //        }
        //        foreach (var gigSub in objGigSubscription)
        //        {
        //            objGigListMain.Where(x => x.GigId == gigSub.GigId).ToList().ForEach(p => { p.GigSubscriptionList.Add(gigSub); p.GigSubscriptionStatus = "S"; });
        //        }

        //        objGigListMain.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
        //        objGigListMain.ForEach(s => s.BudgetInDollar = Math.Round((s.BudgetInDollar * exchangerate), 2));
        //        objGigListFiltered = objGigListMain.Where(x => x.Role == "C" && x.GigSubscriptionStatus == "S").OrderByDescending(x => x.GigId).Where(x => x.GigId < id).ToList();

        //        postedRecord = objGigListFiltered.Count();
        //        if (postedRecord > recordDisplay)
        //        {
        //            postedloadmore = 1;
        //        }
        //        else
        //        {
        //            postedloadmore = 0;
        //        }

        //        objGigListFiltered.ForEach(x => { x.Isloadmore = postedloadmore; x.Category = "subreq"; });
        //        objGigListFiltered = objGigListFiltered.Take(recordDisplay).ToList();
        //    }
        //    #endregion
        //    #region subpending
        //    else if (type == "subpen")
        //    {
        //        objGigList = MatchBxCommon.GenerateBadgeForGig(objGigMod.GetUserGigs(Convert.ToInt32(Session["UserId"])).Where(g => g.GigSubscriptionId < id).ToList());
        //        objGigList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
        //        objGigList.ForEach(s => s.BudgetInDollar = Math.Round((s.BudgetInDollar * exchangerate), 2));
        //        objGigListFiltered = objGigList.GroupBy(x => x.GigId).Select(y => y.First()).ToList();
        //        objGigListFiltered = objGigListFiltered.Where(x => x.Role != "C" && x.GigSubscriptionStatus == "S").OrderByDescending(x => x.GigSubscriptionId).ToList();

        //        postedRecord = objGigListFiltered.Count();
        //        if (postedRecord > recordDisplay)
        //        {
        //            postedloadmore = 1;
        //        }
        //        else
        //        {
        //            postedloadmore = 0;
        //        }

        //        objGigListFiltered.ForEach(x => { x.Isloadmore = postedloadmore; x.Category = "subpen"; });
        //        objGigListFiltered = objGigListFiltered.Take(recordDisplay).ToList();
        //    }
        //    #endregion
        //    #region paypen
        //    else if (type == "paypen")
        //    {
        //        objGigList = MatchBxCommon.GenerateBadgeForGig(objGigMod.GetUserGigs(Convert.ToInt32(Session["UserId"])).Where(g => g.GigSubscriptionId < id).ToList());
        //        objGigList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
        //        objGigList.ForEach(s => s.BudgetInDollar = Math.Round((s.BudgetInDollar * exchangerate), 2));
        //        objGigListFiltered = objGigList.Where(x => x.Role == "C" && x.GigSubscriptionStatus == "A").OrderByDescending(x => x.GigSubscriptionId).ToList();
        //        objGigListFiltered.AddRange(objGigList.Where(x => x.Role != "C" && x.GigSubscriptionStatus == "A").OrderByDescending(x => x.GigSubscriptionId).ToList());
        //        objGigListFiltered = objGigListFiltered.OrderByDescending(x => x.GigSubscriptionId).ToList();

        //        postedRecord = objGigListFiltered.Count();
        //        if (postedRecord > recordDisplay)
        //        {
        //            postedloadmore = 1;
        //        }
        //        else
        //        {
        //            postedloadmore = 0;
        //        }

        //        objGigListFiltered.ForEach(x => { x.Isloadmore = postedloadmore; x.Category = "paypen"; });
        //        objGigListFiltered = objGigListFiltered.Take(recordDisplay).ToList();
        //    }
        //    #endregion
        //    return PartialView("GigsRow", objGigListFiltered);
        //}
        public PartialViewResult LoadMoreServices(string type, int id, string filterBy)
        {
            objJob.UserId = Convert.ToInt32(Session["UserId"]);
            decimal exchangerate = MatchBxCommon.GetExchangeRate();
            List<Gig> objGigList = new List<Gig>();
            List<Gig> objGigListFiltered = new List<Gig>();
            #region library
            if (type == "myservices")
            {
                objGig = new Gig()
                {
                    JobCategoryId = 0,
                    UserId = objJob.UserId,
                    TrendingTagsIdList = "0",
                    SkillsList = "0",
                    MinBudget = 0,
                    MaxBudget = 0,
                    SortBy = "Y"
                };
                objGigList = MatchBxCommon.GenerateBadgeForGig(objGigMod.GetMyServices(objGig));
                objGigList = objGigList.Where(g => g.GigId < id).OrderByDescending(x => x.GigId).ToList();
                objGigList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
                objGigList.ForEach(s => s.BudgetInDollar = Math.Round((s.BudgetInDollar * exchangerate), 2));

                postedRecord = objGigList.Count();
                if (postedRecord > recordDisplay)
                {
                    postedloadmore = 1;
                }
                else
                {
                    postedloadmore = 0;
                }

                objGigList.ForEach(x => { x.Isloadmore = postedloadmore; x.Category = "myservices"; });
                objGigListFiltered = objGigList.Take(recordDisplay).ToList();
            }
            #endregion
            #region purchased services
            else if (type == "purchasedservices")
            {
                objGig = new Gig()
                {
                    JobCategoryId = 0,
                    UserId = Convert.ToInt32(Session["UserId"]),
                    TrendingTagsIdList = "0",
                    SkillsList = "0",
                    MinBudget = 0,
                    MaxBudget = 0,
                    SortBy = "Y"
                };
                if (id != 0)
                {
                    objGigList = MatchBxCommon.GenerateBadgeForGig(objGigMod.GetPurchasedServices(objGig).Where(g => g.GigSubscriptionId < id).OrderByDescending(g => g.GigSubscriptionId).ToList());
                }
                else
                {
                    objGigList = MatchBxCommon.GenerateBadgeForGig(objGigMod.GetPurchasedServices(objGig).OrderByDescending(g => g.GigSubscriptionId).ToList());
                }
                //objGigList = MatchBxCommon.GenerateBadgeForGig(objGigMod.GetPurchasedServices(objGig).Where(g => g.GigSubscriptionId < id).OrderByDescending(g => g.GigSubscriptionId).ToList());
                objGigList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
                objGigList.ForEach(s => s.BudgetInDollar = Math.Round((s.BudgetInDollar * exchangerate), 2));
               
                switch(filterBy)
                {
                    case "jc":
                        objGigList = objGigList.Where(x => x.JobStatus == "C").ToList();
                        break;
                    case "jp":
                        objGigList = objGigList.Where(x => x.GigSubscriptionStatus == "J" && x.IsApproved == "Y" && x.JobStatus != "C" && x.JobStatusSeeker != "C").ToList();
                        break;
                    case "pf":
                        objGigList = objGigList.Where(x => x.GigSubscriptionStatus == "S").ToList();
                        break;
                    case "pp":
                        objGigList = objGigList.Where(x => x.GigSubscriptionStatus == "A" && x.TransactionType != "D" && x.IsApproved != "Y").ToList();
                        break;
                    case "pc":
                        objGigList = objGigList.Where(x => x.GigSubscriptionStatus == "A" && x.TransactionType == "D" && x.IsApproved != "Y").ToList();
                        break;
                    case "pr":
                        objGigList = objGigList.Where(x => x.GigSubscriptionStatus == "J" && x.JobStatusSeeker == "C" && x.JobStatus == "A").ToList();
                        break;
                }

                postedRecord = objGigList.Count();
                if (postedRecord > recordDisplay)
                {
                    postedloadmore = 1;
                }
                else
                {
                    postedloadmore = 0;
                }

                objGigList.ForEach(x => { x.Isloadmore = postedloadmore; x.Category = "purchasedservices"; });

                objGigListFiltered = objGigList.Take(recordDisplay).ToList();
            }
            #endregion
            #region myjobs
            else if(type == "myjobs")
            {
                objJob = new Job()
                {
                    UserId = Convert.ToInt32(Session["UserId"]),
                    CurrentDate = DateTime.Now
                };
                dynamic model = new ExpandoObject();
                List<Job> objJobList = new List<Job>();
                if (id != 0)
                {
                    objJobList = MatchBxCommon.GenerateBadge(objJobMod.GetMyJobs(objJob).Where(g => g.JobId < id).OrderByDescending(g => g.JobId).ToList());
                }
                else
                {
                    objJobList = MatchBxCommon.GenerateBadge(objJobMod.GetMyJobs(objJob).OrderByDescending(g => g.JobId).ToList());
                }
                objJobList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
                objJobList.ForEach(s => s.BudgetInDollar = Math.Round((s.BudgetInDollar * exchangerate), 2));

                switch (filterBy)
                {
                    case "aj":
                        objJobList = objJobList.Where(x => x.IsActive == "Y" && x.IsExpired != "Y" && (x.JobStatus == "P" || x.JobStatus == "B") && x.PendingBid == 0).ToList();
                        break;
                    case "jc":
                        objJobList = objJobList.Where(x => x.JobStatus == "C").ToList();
                        break;
                    case "jb":
                        objJobList = objJobList.Where(x => x.IsExpired == "Y" && x.JobStatus != "C" && (x.JobStatusSeeker == "A" || x.JobStatusSeeker == "C")).ToList();
                        break;
                    case "je":
                        objJobList = objJobList.Where(x => x.IsExpired == "Y" && x.JobStatus != "C" && x.JobStatusSeeker == null).ToList();
                        break;
                    case "jp":
                        objJobList = objJobList.Where(x => x.IsActive == "Y" && x.IsExpired != "Y" && x.JobStatus == "A" && x.JobStatusSeeker == "A").ToList();
                        break;
                    case "jr":
                        objJobList = objJobList.Where(x => x.IsActive == "Y" && x.IsExpired != "Y" && x.JobStatus == "A" && x.JobStatusSeeker == "C").ToList();
                        break;
                    case "pa":
                        objJobList = objJobList.Where(x => x.JobStatus == "R" && x.IsExpired != "Y").ToList();
                        break;
                    case "pp":
                        objJobList = objJobList.Where(x => x.IsActive == "Y" && x.IsExpired != "Y" && x.JobStatus == "B" && x.PendingBid != 0).ToList();
                        break;
                }

                postedRecord = objJobList.Count();
                if (postedRecord > recordDisplay)
                {
                    postedloadmore = 1;
                }
                else
                {
                    postedloadmore = 0;
                }

                objJobList.ForEach(x => { x.Isloadmore = postedloadmore; x.Category = "myjobs"; });

                return PartialView("JobsRow", objJobList.Take(recordDisplay).ToList());
            }
            #endregion
            #region jobs bid on
            else if (type == "jobsBidOn")
            {
                objJob = new Job()
                {
                    UserId = Convert.ToInt32(Session["UserId"]),
                    CurrentDate = DateTime.Now
                };
                dynamic model = new ExpandoObject();
                List<Job> objJobList = new List<Job>();
                if (id != 0)
                {
                    objJobList = MatchBxCommon.GenerateBadge(objJobMod.GetJobsBidOn(objJob).Where(g => g.JobId < id).OrderByDescending(g => g.JobId).ToList());
                }
                else
                {
                    objJobList = MatchBxCommon.GenerateBadge(objJobMod.GetJobsBidOn(objJob).OrderByDescending(g => g.JobId).ToList());
                }
                //List<Job> objJobList = MatchBxCommon.GenerateBadge(objJobMod.GetJobsBidOn(objJob).Where(g => g.JobId < id).OrderByDescending(g => g.JobId).ToList());
                objJobList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
                objJobList.ForEach(s => s.BudgetInDollar = Math.Round((s.BudgetInDollar * exchangerate), 2));

                switch (filterBy)
                {
                    case "jc":
                        objJobList = objJobList.Where(x => x.JobStatus == "C" && x.JobStatusSeeker == "C" && x.TransactionDetailId != 0).ToList();
                        break;
                    case "jp":
                        objJobList = objJobList.Where(x => x.JobStatusSeeker == "A" && x.JobStatus == "A").ToList();
                        break;
                    case "pc":
                        objJobList = objJobList.Where(x => x.JobStatusSeeker == "C" && x.JobStatus == "A").ToList();
                        break;
                    case "pi":
                        objJobList = objJobList.Where(x => x.JobStatus == "C" && x.JobStatusSeeker == "C" && x.TransactionDetailId == 0).ToList();
                        break;
                    case "pp":
                        objJobList = objJobList.Where(x => x.JobStatus == "B" && x.IsAccepted != "Y" && x.IsPending == "Y").ToList();
                        break;
                }

                postedRecord = objJobList.Count();
                if (postedRecord > recordDisplay)
                {
                    postedloadmore = 1;
                }
                else
                {
                    postedloadmore = 0;
                }

                objJobList.ForEach(x => { x.Isloadmore = postedloadmore; x.Category = "jobsBidOn"; });

                return PartialView("JobsRow", objJobList.Take(recordDisplay).ToList());
            }
            #endregion
            #region subreq
            //else if (type == "subreq")
            //{
            //    objGigList = MatchBxCommon.GenerateBadgeForGig(objGigMod.GetUserGigs(Convert.ToInt32(Session["UserId"])).ToList());
            //    objGigList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
            //    objGigList.ForEach(s => s.BudgetInDollar = Math.Round((s.BudgetInDollar * exchangerate), 2));
            //    List<Gig> objGigListMain = new List<Gig>();
            //    List<GigSubscription> objGigSubscription = new List<GigSubscription>();
            //    foreach (var gig in objGigList)
            //    {
            //        var nop = objGigListMain.Where(x => x.GigId == gig.GigId).ToList().Count;
            //        if (objGigListMain.Where(x => x.GigId == gig.GigId).ToList().Count == 0)
            //        {
            //            objGigListMain.Add(new Gig()
            //            {
            //                GigTitle = gig.GigTitle,
            //                GigId = gig.GigId,
            //                GigDescription = gig.GigDescription,
            //                BudgetASP = gig.BudgetASP,
            //                BudgetInDollar = gig.BudgetInDollar,
            //                UserId = gig.UserId,
            //                Commission = gig.Commission,
            //                TotalBudget = gig.TotalBudget,
            //                IsGigEnabled = gig.IsGigEnabled,
            //                GigDuration = gig.GigDuration,
            //                GigSubscriptionStatus = gig.GigSubscriptionStatus,
            //                Role = gig.Role,
            //                GigSubscriptionList = new List<GigSubscription>()
            //            });
            //            if (gig.GigSubscriptionStatus == "S")
            //            {
            //                objGigSubscription.Add(new GigSubscription()
            //                {
            //                    GigSubscriptionId = gig.GigSubscriptionId,
            //                    GigId = gig.GigId,
            //                    JobPosterId = gig.JobPosterId,
            //                    Description = gig.Description,
            //                    IsActive = gig.IsActive,
            //                    CreatedDate = gig.CreatedDate,
            //                    ModifiedDate = gig.ModifiedDate,
            //                    PosterFullName = gig.PosterFullName,
            //                    PosterProfilePic = gig.PosterProfilePic,
            //                    SubscribedDateDisplay = gig.SubscribedDateDisplay,
            //                    JobsCompleted = gig.JobsCompleted,
            //                    JobCompletionDateDisplay = gig.JobCompletionDateDisplay,
            //                    Title = gig.Title
            //                });
            //            }
            //        }
            //        else
            //        {
            //            if (gig.GigSubscriptionStatus == "S")
            //            {
            //                objGigSubscription.Add(new GigSubscription()
            //                {
            //                    GigSubscriptionId = gig.GigSubscriptionId,
            //                    GigId = gig.GigId,
            //                    JobPosterId = gig.JobPosterId,
            //                    Description = gig.Description,
            //                    IsActive = gig.IsActive,
            //                    CreatedDate = gig.CreatedDate,
            //                    ModifiedDate = gig.ModifiedDate,
            //                    PosterFullName = gig.PosterFullName,
            //                    PosterProfilePic = gig.PosterProfilePic,
            //                    SubscribedDateDisplay = gig.SubscribedDateDisplay,
            //                    JobsCompleted = gig.JobsCompleted,
            //                    JobCompletionDateDisplay = gig.JobCompletionDateDisplay,
            //                    Title = gig.Title
            //                });
            //            }
            //        }
            //    }
            //    foreach (var gigSub in objGigSubscription)
            //    {
            //        objGigListMain.Where(x => x.GigId == gigSub.GigId).ToList().ForEach(p => { p.GigSubscriptionList.Add(gigSub); p.GigSubscriptionStatus = "S"; });
            //    }

            //    objGigListMain.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
            //    objGigListMain.ForEach(s => s.BudgetInDollar = Math.Round((s.BudgetInDollar * exchangerate), 2));
            //    objGigListFiltered = objGigListMain.Where(x => x.Role == "C" && x.GigSubscriptionStatus == "S").OrderByDescending(x => x.GigId).Where(x => x.GigId < id).ToList();

            //    postedRecord = objGigListFiltered.Count();
            //    if (postedRecord > recordDisplay)
            //    {
            //        postedloadmore = 1;
            //    }
            //    else
            //    {
            //        postedloadmore = 0;
            //    }

            //    objGigListFiltered.ForEach(x => { x.Isloadmore = postedloadmore; x.Category = "subreq"; });
            //    objGigListFiltered = objGigListFiltered.Take(recordDisplay).ToList();
            //}
            #endregion
            #region subpending
            //else if (type == "subpen")
            //{
            //    objGigList = MatchBxCommon.GenerateBadgeForGig(objGigMod.GetUserGigs(Convert.ToInt32(Session["UserId"])).Where(g => g.GigSubscriptionId < id).ToList());
            //    objGigList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
            //    objGigList.ForEach(s => s.BudgetInDollar = Math.Round((s.BudgetInDollar * exchangerate), 2));
            //    objGigListFiltered = objGigList.GroupBy(x => x.GigId).Select(y => y.First()).ToList();
            //    objGigListFiltered = objGigListFiltered.Where(x => x.Role != "C" && x.GigSubscriptionStatus == "S").OrderByDescending(x => x.GigSubscriptionId).ToList();

            //    postedRecord = objGigListFiltered.Count();
            //    if (postedRecord > recordDisplay)
            //    {
            //        postedloadmore = 1;
            //    }
            //    else
            //    {
            //        postedloadmore = 0;
            //    }

            //    objGigListFiltered.ForEach(x => { x.Isloadmore = postedloadmore; x.Category = "subpen"; });
            //    objGigListFiltered = objGigListFiltered.Take(recordDisplay).ToList();
            //}
            #endregion
            #region paypen
            //else if (type == "paypen")
            //{
            //    objGigList = MatchBxCommon.GenerateBadgeForGig(objGigMod.GetUserGigs(Convert.ToInt32(Session["UserId"])).Where(g => g.GigSubscriptionId < id).ToList());
            //    objGigList.ForEach(s => s.BudgetASPInt = Convert.ToInt32(s.BudgetASP));
            //    objGigList.ForEach(s => s.BudgetInDollar = Math.Round((s.BudgetInDollar * exchangerate), 2));
            //    objGigListFiltered = objGigList.Where(x => x.Role == "C" && x.GigSubscriptionStatus == "A").OrderByDescending(x => x.GigSubscriptionId).ToList();
            //    objGigListFiltered.AddRange(objGigList.Where(x => x.Role != "C" && x.GigSubscriptionStatus == "A").OrderByDescending(x => x.GigSubscriptionId).ToList());
            //    objGigListFiltered = objGigListFiltered.OrderByDescending(x => x.GigSubscriptionId).ToList();

            //    postedRecord = objGigListFiltered.Count();
            //    if (postedRecord > recordDisplay)
            //    {
            //        postedloadmore = 1;
            //    }
            //    else
            //    {
            //        postedloadmore = 0;
            //    }

            //    objGigListFiltered.ForEach(x => { x.Isloadmore = postedloadmore; x.Category = "paypen"; });
            //    objGigListFiltered = objGigListFiltered.Take(recordDisplay).ToList();
            //}
            #endregion
            return PartialView("GigsRow", objGigListFiltered);
        }
        [HttpPost]
        public ActionResult CancelSubscription(int GigId, int SubId)
        {
            var gigId = 0;
            var msg = "";
            try
            {
                objGig = new Gig();
                objGig.GigId = GigId;
                objGig.GigSubscriptionId = SubId;
                if ((gigId = objGigMod.CancelGigSubsription(objGig)) > 0)
                {
                    msg = "success";
                }
                else
                {
                    msg = "failed";
                }
                return Json(msg, JsonRequestBehavior.AllowGet);
            }
            catch (Exception e)
            {
                msg = "failed";
                return Json(msg, JsonRequestBehavior.AllowGet);
            }
        }
        [HttpPost]
        public JsonResult ReviewGig(GigReview GigReview)
        {
            GigReviewModel _GigReviewModel = new GigReviewModel();
            GigSubscriptionModel _GigSubscriptionModel = new GigSubscriptionModel();
            int _GigId = _GigSubscriptionModel.GetARecord(GigReview.GigSubscriptionId).GigId;

            GigReview.GigId = _GigId;
            string message = "";           
            if (_GigReviewModel.Save(GigReview) > 0)
            {
                var _gigReviewId = _GigReviewModel.Id;
                GigReview _objGigReview = _GigReviewModel.GetARecord(_gigReviewId);                
                GigModel _GigModel = new GigModel();
                Gig _Gig = _GigModel.GetARecord(_objGigReview.GigId);
                MatchBxCommon.sendGigReviewToAdmin(1, _Gig.GigTitle, _gigReviewId);
                message = "Success";
            }
            else
            {
                message = "Failed";
            }
            return Json(message, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public ActionResult CancelBid(int bidId)
        {
            var msg = "";
            try
            {
                var objBid = new JobBidding();
                objBid.JobBiddingId = bidId;
                if (new JobBiddingModel().CancelBid(objBid))
                {
                    msg = "success";
                }
                else
                {
                    msg = "failed";
                }
                return Json(msg, JsonRequestBehavior.AllowGet);
            }
            catch (Exception e)
            {
                msg = "failed";
                return Json(msg, JsonRequestBehavior.AllowGet);
            }
        }
    }
}