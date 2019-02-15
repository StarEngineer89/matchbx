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
    public class GigsTempController : Controller
    {
        // GET: GigsTemp      
        int _RecordDisplay = 5;
        int _TotalRecord = 0;
        int _loadmore = 0;
        string sourceFolderPath = ConfigurationManager.AppSettings["PathForProjectDocuments"].ToString();
        public ActionResult Index()
        {
            return View("Search");
        }
        public ActionResult Search()
        {
            Gig _Gig = new Gig();
            GigModel _GigModel = new GigModel();
            TrendingTagsModel _TrendingTagsModel = new TrendingTagsModel();
            TrendingTags _TrendingTags = new TrendingTags();

            _Gig.TrendingTagsIdList = "0";
            _Gig.SkillsList = "0";
            List<Gig> _GigList = _GigModel.GetGigDetails(_Gig);

            _TotalRecord = _GigList.Count();
            if (_TotalRecord > _RecordDisplay)
            {
                _loadmore = 1;
            }
            else
            {
                _loadmore = 0;
            }

            _GigList.ForEach(x => x.Isloadmore = _loadmore);
            _GigList = _GigList.Take(_RecordDisplay).ToList();

            dynamic model = new ExpandoObject();
            model.Gig = MatchBxCommon.GenerateBadgeForGig(_GigList);
            model.TopJobSeekers = _GigModel.GetTopJobSeekers(_Gig);
            model.TrendingTags = _TrendingTagsModel.GetTrendingTagsForGig(_TrendingTags);
            return View("Search",model);
        }

        [HttpPost]
        public JsonResult LoadMoreGigs(int id, string _searchtext, string trendingtagsid)
        {
            dynamic model = new ExpandoObject();
            Gig _Gig = new Gig();
            GigModel _GigModel = new GigModel();
            _Gig.TrendingTagsIdList = trendingtagsid;
            _Gig.SkillsList = "0";
            List<Gig> _GigList = new List<Gig>();
            List<Gig> objGigList = new List<Gig>();

            objGigList = MatchBxCommon.GenerateBadgeForGig(_GigModel.GetGigDetails(_Gig).OrderByDescending(x => x.GigId).Where(x => x.GigId < id).ToList());
            if (!string.IsNullOrEmpty(_searchtext))
            {
                _GigList = objGigList.Where(p => p.GigDescription != null && p.GigDescription.ToLower().Contains(_searchtext.ToLower().Trim()) || p.GigTitle != null && p.GigTitle.ToLower().Contains(_searchtext.ToLower().Trim()) || p.GigDurationString != null && p.GigDurationString.ToLower().Contains(_searchtext.ToLower()) || p.TrendingTagsIdList != null && p.TrendingTagsIdList.ToLower().Contains(_searchtext.ToLower())).ToList();

                _TotalRecord = _GigList.Count();
                if (_TotalRecord > _RecordDisplay)
                {
                    _loadmore = 1;
                }
                else
                {
                    _loadmore = 0;
                }
                _GigList.ForEach(x => x.Isloadmore = _loadmore);
                model.Gig = _GigList.Take(_RecordDisplay);

            }
            else
            {

                _GigList = objGigList;
                _TotalRecord = _GigList.Count();
                if (_TotalRecord > _RecordDisplay)
                {
                    _loadmore = 1;
                }
                else
                {
                    _loadmore = 0;
                }
                _GigList.ForEach(x => x.Isloadmore = _loadmore);
                model.Gig = _GigList.Take(_RecordDisplay);
            }

            return Json(model.Gig, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        public JsonResult PostedGigs(string _searchtext, string trendingtagsid)
        {
            dynamic model = new ExpandoObject();
            Gig _Gig = new Gig();
            GigModel _GigModel = new GigModel();

            _Gig.TrendingTagsIdList = trendingtagsid;
            _Gig.SkillsList = "0";            

            List<Gig> _GigList = MatchBxCommon.GenerateBadgeForGig(_GigModel.GetGigDetails(_Gig).OrderByDescending(x => x.GigId).ToList());            
            if (string.IsNullOrWhiteSpace(_searchtext))
            {
                _TotalRecord = _GigList.Count();
                if (_TotalRecord > _RecordDisplay)
                {
                    _loadmore = 1;
                }
                else
                {
                    _loadmore = 0;
                }
                _GigList.ForEach(x => x.Isloadmore = _loadmore);
                model.Gig = _GigList.Take(_RecordDisplay).ToList();
            }
            else
            {

                _GigList = _GigList.Where(p => p.GigDescription != null && p.GigDescription.ToLower().Contains(_searchtext.ToLower().Trim()) || p.GigTitle != null && p.GigTitle.ToLower().Contains(_searchtext.ToLower().Trim()) || p.GigDurationString != null && p.GigDurationString.ToLower().Contains(_searchtext.ToLower()) || p.TrendingTagsIdList != null && p.TrendingTagsIdList.ToLower().Contains(_searchtext.ToLower())).ToList();
                _TotalRecord = _GigList.Count();
                if (_TotalRecord > _RecordDisplay)
                {
                    _loadmore = 1;
                }
                else
                {
                    _loadmore = 0;
                }
                _GigList = _GigList.Take(_RecordDisplay).ToList();
                _GigList.ForEach(x => x.Isloadmore = _loadmore);
                model.Gig = _GigList.Take(_RecordDisplay).ToList();
            }
            Session["DynModel"] = model;

            return Json(model.Gig, JsonRequestBehavior.AllowGet);
        }
        public JsonResult GetAutomatedSearch(string _searchtext)
        {
            GigModel _GigModel = new GigModel();
            dynamic model = new ExpandoObject();
            Gig _Gig = new Gig();
            _Gig.searchText = _searchtext;
            List<Gig> _GigList = new List<Gig>();
            _GigList = _GigModel.GetAutomatedGigForTrendingTags(_Gig);
            return Json(_GigList, JsonRequestBehavior.AllowGet);
        }
        public ActionResult Details(int? id)
        {
            //TempData["TrendingTagsFooter"] = MatchBxCommon.GetTrendingTagsFooter();
            TempData["BidMessage"] = "";
            TempData["GigAmount"] = "";
            TempData["AXPRFeeAmt"] = "0.00";
            TempData["AXPRFeeTotAmt"] = "";
            TempData["BidAmountinDollar"] = "";
            TempData["GigSubscriptionId"] = 0;
            TempData["GigCompletionDate"] = "";
            TempData["GigTitle"] = string.Empty;
            //Session["Expired"] = "N";
            //Session["FromDetails"] = "Y";

            dynamic model = new ExpandoObject();
            GigModel _GigModel = new GigModel();
            Gig _Gig = new Gig();            

            int gigid = id.GetValueOrDefault();
            Session["GigId"] = gigid;
            if (gigid != 0)
            {
                List<Gig> _GigList = MatchBxCommon.GenerateBadgeForGig(_GigModel.GetGigPost(gigid));
                if (_GigList.Count() > 0)
                {

                    //ViewBag.MetaTag = HomeMetaTags(objJobList[0].JobTitle.ToString(), objJobList[0].JobDescription.ToString());

                    _GigList.FirstOrDefault().GigSkillsMappingList = _GigModel.GetSkillsByGigId(gigid);
                    _GigList.FirstOrDefault().GigTrendingTagsMappingList = _GigModel.GetTagsByGigId(gigid);
                    _Gig = _GigList.FirstOrDefault();
                    //Session["JobPoster"] = objJob.UserId;

                    Session["JobCategory"] = CultureInfo.CurrentCulture.TextInfo.ToTitleCase(_Gig.Category.ToLower());
                    Session["JobCategoryHeader"] = CultureInfo.CurrentCulture.TextInfo.ToTitleCase(_Gig.Category.ToLower());

                    if (Session["JobCategoryId"].ToString() == "0")
                    {
                        Session["JobCategoryName"] = CultureInfo.CurrentCulture.TextInfo.ToTitleCase("ALL JOBS".ToLower());
                    }
                    else
                    {
                        Session["JobCategoryName"] = CultureInfo.CurrentCulture.TextInfo.ToTitleCase(_Gig.Category.ToLower());
                    }

                    decimal exchangerate = MatchBxCommon.GetExchangeRate();                    
                    int bid = Convert.ToInt32(_Gig.BudgetASP);
                    decimal perc = (Convert.ToDecimal(bid) * 3) / 100;
                    TempData["AXPRFeeAmt"] = perc.ToString("#,##0.00");
                    string totalfees = (bid + perc).ToString("#,##0.00");
                    TempData["AXPRFeeTotAmt"] = totalfees;
                    TempData["GigAmount"] = _Gig.BudgetASP.ToString() + " AXPR";
                    TempData["BidAmountinDollar"] = (Math.Round(exchangerate * (bid + perc), 2)).ToString("#,##0.00");

                    //TimeSpan span = objJob.JobCompletionDate.Subtract(DateTime.Now);
                    //string EndingIn = span.Days + " DAYS, " + span.Hours + " HOURS, " + span.Minutes + " MINS";
                    //if (span.Days == 0 || objJob.JobStatus == "P")
                    //{
                    //    Session["Expired"] = "N";
                    //    EndingIn = span.Days + " DAYS, " + Math.Abs(span.Hours) + " HOURS, " + Math.Abs(span.Minutes) + " MINS";
                    //}
                    //else if (span.Days < 0 || span.Hours < 0 || span.Minutes < 0 || objJob.JobStatus == "A" || objJob.JobStatus == "C" || objJob.JobStatusSeeker == "C")
                    //{
                    //    Session["Expired"] = "Y";
                    //}
                    //TempData["EndingIn"] = EndingIn;
                    //if (Convert.ToInt32(Session["UserId"]) != _Gig.UserId)
                    //{
                    //    GigSubscription _GigSubscription = new GigSubscription();
                    //    GigSubscriptionModel _GigSubscriptionModel = new GigSubscriptionModel();
                    //    _GigSubscription.UserId = Convert.ToInt32(Session["UserId"]);
                    //    _GigSubscription.GigId = _Gig.GigId;

                    //    List<GigSubscription> _GigSubscriptionList = _GigSubscriptionModel.LoadJobBiddingDetails(_JobBidding);
                    //    if (objBiddingList.Count() > 0)
                    //    {
                    //        TempData["BidMessage"] = objBiddingList.FirstOrDefault().BidMessage;
                    //        TempData["BidAmount"] = (objBiddingList.FirstOrDefault().BidAmount).ToString("#,##0") + " AXPR";
                    //        int bid = Convert.ToInt32(objBiddingList.FirstOrDefault().BidAmount);
                    //        decimal perc = (Convert.ToDecimal(bid) * 3) / 100;
                    //        TempData["AXPRFeeAmt"] = perc.ToString("#,##0.00");

                    //        string totalfees = (bid - perc).ToString("#,##0.00");
                    //        TempData["AXPRFeeTotAmt"] = totalfees;
                    //        decimal exchangerate = MatchBxCommon.GetExchangeRate();
                    //        TempData["BidAmountinDollar"] = (Math.Round(exchangerate * (objBiddingList.FirstOrDefault().BidAmount), 2)).ToString("#,##0.00");
                    //        TempData["JobBiddingId"] = objBiddingList.FirstOrDefault().JobBiddingId;
                    //        TempData["TokenDistributionId"] = objBiddingList.FirstOrDefault().TokenDistributionId;
                    //        TempData["IsPendingStatus"] = objBiddingList.FirstOrDefault().IsPending;
                    //    }
                    //    else
                    //    {
                    //        TempData["IsPendingStatus"] = "N";
                    //    }
                }

                //objJob.ShareJob = shareJobObj.GetShareDetails(jobid, Convert.ToInt32(Session["UserId"]));
                //if (objJob.ShareJob == null)
                //{
                //    objJob.ShareJob = new SocialMediaShare();
                //    objJob.ShareJob.JobId = jobid;
                //    objJob.ShareJob.UserId = Convert.ToInt32(Session["UserId"]);
                //    objJob.ShareJob.FBShare = null;
                //    objJob.ShareJob.TwitterShare = null;
                //}
                //}

            }
            return View("Details", _Gig);
        }

        [NoCache]
        [SessionExpire]
        public ActionResult UploadSubscriptionDocuments()
        {

            bool isSavedSuccessfully = true;
            string fName = "";
            List<GigSubscriptionDocument> _list = new List<GigSubscriptionDocument>();
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

                            _list = (List<GigSubscriptionDocument>)(Session["FileList"]);
                            _list.Add(new GigSubscriptionDocument { DocumentName = InputFileName, FileSize = size });
                        }
                        else
                        {
                            _list.Add(new GigSubscriptionDocument { DocumentName = InputFileName, FileSize = size });
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
        [HttpPost]
        [AllowAnonymous]
        public ActionResult SaveGigSubscription(int GigId,int JobPosterId,string Description,string JobCompletionDate,string Title)
        {
            GigSubscription _GigSubscription = new GigSubscription();
            GigSubscriptionModel _GigSubscriptionModel = new GigSubscriptionModel();
            string message = "failed";
         
                _GigSubscription.GigId = GigId;
                _GigSubscription.JobPosterId = JobPosterId;
                _GigSubscription.Description = Description;
                //CultureInfo culture = new CultureInfo("en-US");
                //DateTime tempDate = Convert.ToDateTime(JobCompletionDate, culture);
                DateTime tempDate= DateTime.ParseExact(JobCompletionDate, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                _GigSubscription.JobCompletionDate = tempDate;
                _GigSubscription.IsActive = "Y";
                _GigSubscription.GigSubscriptionStatus = "S";
               _GigSubscription.Title = Title;



            List<GigSubscriptionDocument> fileList = new List<GigSubscriptionDocument>();

            if (TempData["fileList"] != null)
            {
                fileList = (List<GigSubscriptionDocument>)TempData.Peek("fileList");
            }

            if (GigId != 0)
            {
                if (Convert.ToInt32(_GigSubscription.GigSubscriptionDocumentList.Count) == 0)
                {
                    if (fileList != null)
                    {
                        foreach (var file in fileList)
                        {
                            _GigSubscription.GigSubscriptionDocumentList.Add(new GigSubscriptionDocument() { DocumentName = file.DocumentName.ToString(), IsActive = "Y", FileSize = file.FileSize });
                        }
                    }
                }

            }

            var gigId = 0;
            if ((gigId = _GigSubscriptionModel.SaveWithTransaction(_GigSubscription)) > 0)
            {
                Users _objuser = new Users();
                UsersModel objUsersMod = new UsersModel();
                if (Convert.ToInt32(Session["UserType"]) == 1)
                {
                    _objuser.UserId = Convert.ToInt32(Session["UserId"]);
                    _objuser.UserType = "3";
                    int returnvalue = objUsersMod.ChangeUserRole(_objuser);
                    if(returnvalue>0)
                    {
                        Session["UserType"] = "3";
                    }

                }
                message = "success";
                if (MatchBxCommon.checkuseremailpreferences("4,5", Convert.ToInt32(Session["UserId"])) == true)
                {
                    try
                    {
                        
                        Gig _objGig = new Gig();
                        GigModel _objGigModel = new GigModel();
                        _objGig = _objGigModel.GetARecord(GigId);
                        _objuser = objUsersMod.GetList("*", " UserId = '" + _objGig.UserId + "'").FirstOrDefault();
                        string email = _objuser.Email;
                        string fullname = _objuser.FullName != null ? _objuser.FullName : _objuser.UserName;
                        MatchBxCommon.sendGigOfferEmail(email, false, Session["UserName"].ToString(), Title, fullname);
                    }
                    catch (Exception e)
                    {
                    }
                }
            }

            return Json(message, JsonRequestBehavior.AllowGet);
        }

     }
}