using Business;
using MatchBx.Utilities;
using MatchBX.Models;
using Model;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Dynamic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MatchBX.Controllers
{
    public class GigsController : Controller
    {
        // GET: Gigs

        Gig objGig = new Gig();
        GigModel objGigMod = new GigModel();
        List<Gig> objGigList = new List<Gig>();
        TrendingTags objTrending = new TrendingTags();
        TrendingTagsModel objTrendingMod = new TrendingTagsModel();
        List<TrendingTags> objTrendingTagsList = new List<TrendingTags>();
        SkillsModel objSkillsMod = new SkillsModel();
        Skills objSkills = new Skills();
        List<JobCategory> objCategory = new List<JobCategory>();
        JobCategoryModel objCatMod = new JobCategoryModel();
        // JobBidding objBidding = new JobBidding();
        // List<JobBidding> objBiddingList = new List<JobBidding>();
        // JobBiddingModel objBiddingMod = new JobBiddingModel();
        // SocialMediaShareModel shareJobObj = new SocialMediaShareModel();
        // SocialMediaShare shareObj = new SocialMediaShare();
        MatchBXNotification objNotification = new MatchBXNotification();
        MatchBXNotificationModel objNotiMod = new MatchBXNotificationModel();
        UsersModel objUsersMod = new UsersModel();
        string sourceFolderPath = ConfigurationManager.AppSettings["PathForProjectDocuments"].ToString();
        int _RecordDisplay = 5;
        int _TotalRecord = 0;
        int _loadmore = 0;

        public ActionResult Index()
        {
            return View();
        }

        [NoCache]
        [SessionExpire]
        public ActionResult CreateGig(int? id)
        {
            Session["ExRate"] = MatchBxCommon.GetExchangeRate();
            dynamic model = new ExpandoObject();
            int gigid = id.GetValueOrDefault();
            TempData["Category"] = objCatMod.GetList();
            TempData["Tags"] = new List<TrendingTags>();
            TempData["Skills"] = new List<Skills>();
            //GetTagsnSkills(0);
            if (gigid != 0)
            {
                objGigList = objGigMod.GetGigPost(gigid);
                if (objGigList.Count() > 0)
                {
                    TrendingTagsModel _TrendingTagsModel = new TrendingTagsModel();
                    SkillsModel _SkillsModel = new SkillsModel();
                    //TempData["Tags"] = objJobMod.GetTrendingTags(objJobList[0].JobCategoryId);
                    //TempData["Skills"] = objJobMod.GetTopSkills(objJobList[0].JobCategoryId);
                    if (gigid != 0)
                    {
                        TempData["Tags"] = _TrendingTagsModel.GetList(" * ", " JobCategoryId = " + objGigList[0].JobCategoryId);
                    }
                    else
                    {
                        TempData["Tags"] = _TrendingTagsModel.GetList(" * ", " JobCategoryId = " + objGigList[0].JobCategoryId + " and TagType = 'S'");
                    }
                    TempData["Skills"] = _SkillsModel.GetList(" * ", " JobCategoryId = " + objGigList[0].JobCategoryId);
                    objGigList.FirstOrDefault().GigSkillsMappingList = objGigMod.GetSkillsByGigId(gigid);
                    objGigList.FirstOrDefault().GigTrendingTagsMappingList = objGigMod.GetTagsByGigId(gigid);
                    objGigList.FirstOrDefault().GigDocumentsList = objGigMod.GetDocumentsByGigId(gigid);
                    objGig = objGigList.FirstOrDefault();
                    objGig.BudgetASPString = objGigList.FirstOrDefault().BudgetASP.ToString();
                    objGig.GigId = Convert.ToInt32(id);
                    TempData["SelectedTags"] = objGig.GigTrendingTagsMappingList;
                    TempData["SelectedSkills"] = objGig.GigSkillsMappingList;
                    Session["TrendingTagsList"] = objGig.GigTrendingTagsMappingList;
                    Session["SkillsList"] = objGig.GigSkillsMappingList;
                }

            }
            return View("CreateGig", objGig);


        }


        [NoCache]
        [SessionExpire]
        [HttpPost]
        public ActionResult SaveGig(Gig gig)
        {

            string message = "";

            if (ModelState.IsValid)
            {
                //job.JobTitle = ToCamelCase(job.JobTitle);
                if (Convert.ToInt32(gig.GigTrendingTagsMappingList.Count) == 0)
                {
                    if (Session["TrendingTagsList"] != null)
                    {

                        gig.GigTrendingTagsMappingList = (List<GigTrendingTagsMapping>)Session["TrendingTagsList"];
                    }
                }

                if (Convert.ToInt32(gig.GigSkillsMappingList.Count) == 0)
                {
                    if (Session["SkillsList"] != null)
                    {

                        gig.GigSkillsMappingList = (List<GigSkillsMapping>)Session["SkillsList"];
                    }
                }


                gig.UserId = Convert.ToInt32(Session["UserId"]);


                List<GigDocuments> fileList = new List<GigDocuments>();

                if (TempData["fileList"] != null)
                {
                    fileList = (List<GigDocuments>)TempData.Peek("fileList");
                }

                if (gig != null)
                {
                    if (Convert.ToInt32(gig.GigDocumentsList.Count) == 0)
                    {
                        if (fileList != null)
                        {
                            foreach (var file in fileList)
                            {
                                gig.GigDocumentsList.Add(new GigDocuments() { DocumentName = file.DocumentName.ToString(), IsActive = "Y", FileSize = file.FileSize });
                            }
                        }
                    }

                }

                var _tagsObjModel = new TrendingTagsModel();
                foreach (var item in gig.GigTrendingTagsMappingList)
                {
                    if (item.TrendingTagsId == 0)
                    {
                        var _trendingTag = new TrendingTags()
                        {
                            Description = item.Description,
                            TrendingTagsId = item.TrendingTagsId,
                            JobCategoryId = gig.JobCategoryId,
                            TagType = "U"
                        };
                        item.TrendingTagsId = objTrendingMod.Save(_trendingTag);
                    }
                }
                var gigId = 0;
                if ((gigId = objGigMod.SaveWithTransaction(gig)) > 0)
                {
                    if (Session["UserType"] != null && Session["UserType"].ToString() == "2")
                    {
                        Session["UserType"] = "3";
                        UsersModel _Model = new UsersModel();
                        Users _userobj = new Users();
                        _userobj.UserId = Convert.ToInt32(Session["UserId"]);
                        _userobj.UserType = Session["UserType"].ToString();
                        int k = _Model.ChangeUserRole(_userobj);
                    }
                    if (gig.GigId > 0)
                    {
                        message = "Your GIG has been edited and is now pending for approval";
                        MatchBxCommon.sendGigPostedEmailToAdmin(2, gig.GigTitle, gig.GigId);
                        TempData["CreateGig"] = gig.GigId;
                        TempData["DeleteGig"] = 0;
                    }
                    else
                    {
                        message = "Your GIG has been created and is now pending for approval";
                        MatchBxCommon.sendGigPostedEmailToAdmin(1, gig.GigTitle, gigId);
                        TempData["CreateGig"] = 0;
                        TempData["DeleteGig"] = 0;
                    }

                    TempData.Remove("fileList");
                    Session["FileList"] = null;
                    Session["GigCreated"] = "Y";

                }
                else
                {
                    if (gig.GigId > 0)
                    {
                        message = "Failed to edit GIG";
                    }
                    else
                    {
                        message = "Failed to create GIG";
                    }

                    TempData.Remove("fileList");
                    Session["FileList"] = null;

                    Session["GigCreated"] = "N";

                }
                if (Convert.ToInt32(Session["UserType"]) != 3)
                {
                    Session["FirstLogin"] = "N";
                }

            }
            else
            {
                message = "Failed to create GIG";

                TempData.Remove("fileList");
                Session["FileList"] = null;
                Session["GigCreated"] = "N";
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
            List<GigDocuments> _list = new List<GigDocuments>();
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

                            _list = (List<GigDocuments>)(Session["FileList"]);
                            _list.Add(new GigDocuments { DocumentName = InputFileName, FileSize = size });
                        }
                        else
                        {
                            _list.Add(new GigDocuments { DocumentName = InputFileName, FileSize = size });
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

        public ActionResult SetGigStatus(int id, string status)
        {
            var gigId = 0; 
            var msg = "";
            try
            {
                objGig = new Gig();
                objGig.GigId = id;
                objGig.Status = status;
                if ((gigId = objGigMod.UpdateGigStatus(objGig)) > 0)
                {
                    msg = "success";
                    return Json(msg, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    msg = "failed";
                    return Json(msg, JsonRequestBehavior.AllowGet);
                }
            } catch(Exception e)
            {
                msg = "failed";
                return Json(msg, JsonRequestBehavior.AllowGet);
            }
        }
        public ActionResult AcceptGigRequest(int gigId, int reqId, string type, string address)
        {
            var msg = "";
            try
            {
                objGig = new Gig();
                objGig.GigId = gigId;
                objGig.GigSubscriptionId = reqId;
                objGig.GigSubscriptionStatus = type;
                if ((gigId = objGigMod.SetGigSubsription(objGig)) > 0)
                {
                    if (type == "A")
                    {
                        TokenDistributionModel _TokenDistributionModel = new TokenDistributionModel();
                        TokenDistribution _TokenDistribution = new TokenDistribution();
                        _TokenDistribution.TokenDistributionId = 0;
                        _TokenDistribution.JobBiddingId = 0;
                        _TokenDistribution.TokenAddress = address;
                        _TokenDistribution.UserId = Convert.ToInt32(Session["UserId"]);
                        _TokenDistribution.IsApproved = "N";
                        _TokenDistribution.GigSubscriptionId = reqId;
                        if (_TokenDistributionModel.Save(_TokenDistribution) > 0)
                        {
                            msg = "success";
                        }
                        else
                        {
                            msg = "failed";
                        }
                    } else
                    {
                        msg = "success";
                    }
                    return Json(msg, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    msg = "failed";
                    return Json(msg, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception e)
            {
                msg = "failed";
                return Json(msg, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public JsonResult GigOffer(int GigSubscriptionId, string Status)
        {
            GigSubscription _GigSubscription = new GigSubscription();
            GigSubscriptionModel _GigSubscriptionModel = new GigSubscriptionModel();
            Gig _Gig = new Gig();
            GigModel _GigModel = new GigModel();

            _GigSubscription = _GigSubscriptionModel.GetARecord(GigSubscriptionId);            
            _GigSubscription.Status = Status;
            _Gig = _GigModel.GetARecord(_GigSubscription.GigId);
            int UserId = _Gig.UserId;
            string GigTitle = _Gig.GigTitle;

            if (_GigSubscriptionModel.GigOfferAcceptorDecline(_GigSubscription).FirstOrDefault().JobId > 0)
            {
                _GigSubscription.JobId = _GigSubscriptionModel.GigOfferAcceptorDecline(_GigSubscription).FirstOrDefault().JobId;
                
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
                    Users objUser = new Users();
                    objUser = objUsersMod.GetList("*", " UserId = '" + UserId + "'").FirstOrDefault();
                    string seekeremail = objUser.Email;
                    string posterusername = "@" + Session["UserName"].ToString();
                    string seekerfullname = objUser.FullName != null ? objUser.FullName : objUser.UserName;
                    if (Status == "A")
                    {
                        //MatchBxCommon.sendBidAcceptanceEmail(fullname, username, JobTitle, JobId, email, objJobbidding.BidAmount, false);
                    }
                    else
                    {
                        MatchBxCommon.sendGigDeclineEmail(seekerfullname, posterusername, GigTitle, seekeremail, false);
                    }
                }

            }
            else
            {
                _GigSubscription.JobId = 0;
            }           

            return Json(_GigSubscription, JsonRequestBehavior.AllowGet);
        }

        //[NoCache]
        ////[SessionExpire]
        //public ActionResult Details(int? id)
        //{
        //    TempData["TrendingTagsFooter"] = MatchBxCommon.GetTrendingTagsFooter();
        //    TempData["BidMessage"] = "";
        //    TempData["BidAmount"] = "";
        //    TempData["AXPRFeeAmt"] = "0.00";
        //    TempData["AXPRFeeTotAmt"] = "";
        //    TempData["BidAmountinDollar"] = "";
        //    TempData["JobBiddingId"] = "";
        //    Session["Expired"] = "N";
        //    Session["FromDetails"] = "Y";

        //    dynamic model = new ExpandoObject();
        //    int gigid = id.GetValueOrDefault();
        //    Session["GigId"] = gigid;
        //    if (gigid != 0)
        //    {
        //        objGigList = MatchBxCommon.GenerateBadge(objGigMod.GetGigPost(gigid));
        //        if (objGigList.Count() > 0)
        //        {
        //            objGigList.FirstOrDefault().GigSkillsMappingList = objGigMod.GetSkillsByGigId(gigid);
        //            objGigList.FirstOrDefault().GigTrendingTagsMappingList = objGigMod.GetTagsByGigId(gigid);
        //            objGig = objGigList.FirstOrDefault();
        //            // Session["JobPoster"] = objGig.UserId;

        //            Session["GigCategory"] = CultureInfo.CurrentCulture.TextInfo.ToTitleCase(objGig..ToLower());
        //            Session["GigCategoryHeader"] = CultureInfo.CurrentCulture.TextInfo.ToTitleCase(objGig.Category.ToLower());

        //            if (Session["GigCategoryId"].ToString() == "0")
        //            {
        //                Session["GigCategoryName"] = CultureInfo.CurrentCulture.TextInfo.ToTitleCase("ALL JOBS".ToLower());
        //            }
        //            else
        //            {
        //                Session["GigCategoryName"] = CultureInfo.CurrentCulture.TextInfo.ToTitleCase(objGig.Category.ToLower());
        //            }
        //        }

        //    }
        //    return View("Details", objGig);
        //}

        public ActionResult Search()
        {
            Gig _Gig = new Gig();
            GigModel _GigModel = new GigModel();
            TrendingTagsModel _TrendingTagsModel = new TrendingTagsModel();
            TrendingTags _TrendingTags = new TrendingTags();

            _Gig.TrendingTagsIdList = "0";
            _Gig.SkillsList = "0";
            List<Gig> _GigList = _GigModel.GetGigDetails(_Gig).OrderByDescending(x => x.GigId).ToList<Gig>();

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
            model.Gig = MatchBxCommon.GenerateBadgeForGig(_GigList).OrderByDescending(x=>x.GigId).ToList<Gig>();
            model.TopJobSeekers = _GigModel.GetTopJobSeekers(_Gig);
            model.TrendingTags = _TrendingTagsModel.GetTrendingTagsForGig(_TrendingTags);
            return View("Search", model);
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
        public ActionResult Details(int? id, int? subid)
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
            TempData["GigCompletionDate"] = "";
            TempData["JobCompletionDateDisplay"] = "";
            //Session["Expired"] = "N";
            //Session["FromDetails"] = "Y";
            Session["GigSubDocMasterList"] = null;
            Session["GigSubDocList"] = null;
            TempData["NoofDocuments"] = 0;

            dynamic model = new ExpandoObject();
            GigModel _GigModel = new GigModel();
            Gig _Gig = new Gig();

            int gigid = id.GetValueOrDefault();
            Session["GigId"] = gigid;
            Session["SubGigId"] = subid.GetValueOrDefault();
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
                    //TempData["BidAmountinDollar"] = (Math.Round(exchangerate * (bid + perc), 2)).ToString("#,##0.00");
                    TempData["BidAmountinDollar"] = (Math.Round(exchangerate * (bid), 2)).ToString("#,##0.00");

                    UserProfileModel objProfileMod = new UserProfileModel();
                    UserProfile objProfile = new UserProfile();
                    objProfile = objProfileMod.LoadUserProfile(_Gig.UserId).FirstOrDefault();
                    _Gig.ProfilePic = objProfile.ProfilePic;

                    try
                    {
                        string rating = Adjust(decimal.ToDouble(objProfile.Rating)).ToString();
                        TempData["Rating"] = rating;
                        if (rating.Contains('.'))
                        {
                            string[] parts = rating.Split('.');
                            TempData["RatingWhole"] = parts[0];
                            if (parts[1] != null)
                            {
                                TempData["RatingFraction"] = parts[1];
                            }
                            else
                            {
                                TempData["RatingFraction"] = 0;
                            }
                        }
                        else
                        {
                            TempData["RatingWhole"] = rating;
                            TempData["RatingFraction"] = 0;
                        }
                    }
                    catch (Exception ex)
                    {

                    }


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
                    if (Convert.ToInt32(Session["UserId"]) != _Gig.UserId)
                    {
                        if (subid.GetValueOrDefault() > 0)
                        {
                            GigSubscription _GigSubscription = new GigSubscription();
                            GigSubscriptionModel _GigSubscriptionModel = new GigSubscriptionModel();
                            _GigSubscription.GigSubscriptionId = subid.GetValueOrDefault();
                            
                            List<GigSubscription> _GigSubscriptionList = _GigSubscriptionModel.LoadSubscriptionDetails(_GigSubscription);
                            if (_GigSubscriptionList.Count() > 0)
                            {
                                TempData["BidMessage"] = _GigSubscriptionList.FirstOrDefault().Description;
                                TempData["GigTitle"] = _GigSubscriptionList.FirstOrDefault().Title;
                                TempData["GigCompletionDate"] = _GigSubscriptionList.FirstOrDefault().JobCompletionDate;
                                TempData["GigSubscriptionId"] = _GigSubscriptionList.FirstOrDefault().GigSubscriptionId;
                                TempData["JobCompletionDateDisplay"] = _GigSubscriptionList.FirstOrDefault().JobCompletionDateDisplay;
                                TempData["NoofDocuments"] = _GigSubscriptionList.FirstOrDefault().NoofDocuments;
                            }
                        }
                    }                    
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
        double Adjust(double input)
        {
            double whole = Math.Truncate(input);
            double remainder = input - whole;
            if (remainder < 0.25)
            {
                remainder = 0.0;
            }
            else if (remainder < 0.75)
            {
                remainder = 0.5;
            }
            else
            {
                remainder = 1.0;
            }
            return whole + remainder;
        }
        [HttpPost]
        public ActionResult GigSubcriptionDocuments(int GigSubscriptionId)
        {
            if (Session["GigSubDocMasterList"] != null)
            {
                List<GigSubscriptionDocument> _GigDocumentsList = ((List<GigSubscriptionDocument>)Session["GigSubDocMasterList"]).Where(x => x.IsActive == "Y").ToList();

                if (_GigDocumentsList.Count() > 0)
                {
                    return Json(_GigDocumentsList, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json("Failed", JsonRequestBehavior.AllowGet);
                }
            }
            else
            {
                GigSubscriptionDocumentModel _GigSubscriptionDocumentModel = new GigSubscriptionDocumentModel();
                List<GigSubscriptionDocument> _GigDocumentsList = _GigSubscriptionDocumentModel.GetList(" * ", "GigSubscriptionId = " + GigSubscriptionId + " and IsActive='Y'");
                if (_GigDocumentsList.Count() > 0)
                {
                    Session["GigSubDocMasterList"] = _GigDocumentsList;
                    Session["GigSubDocList"] = _GigDocumentsList;
                    return Json(_GigDocumentsList, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json("Failed", JsonRequestBehavior.AllowGet);
                }
            }
            
        }

        [HttpPost]
        public JsonResult DeleteGigSubcriptionDocuments(int GigSubscriptionDocId)
        {


            List<GigSubscriptionDocument> _GigDocumentsList = new List<GigSubscriptionDocument>();
            List<GigSubscriptionDocument> _GigSubDocumentsList = new List<GigSubscriptionDocument>();
            List<GigSubscriptionDocument> _GigDocumentsMasterList = new List<GigSubscriptionDocument>();
            

            _GigDocumentsList = (List<GigSubscriptionDocument>)Session["GigSubDocList"];
            _GigSubDocumentsList = _GigDocumentsList.Where(x => x.GigSubscriptionDocumentId != GigSubscriptionDocId).ToList();
            Session["GigSubDocList"] = _GigSubDocumentsList;

            _GigDocumentsMasterList = (List<GigSubscriptionDocument>)Session["GigSubDocMasterList"];
            _GigDocumentsMasterList.Where(x => x.GigSubscriptionDocumentId == GigSubscriptionDocId).ToList().ForEach(x=>x.IsActive="N");
            Session["GigSubDocMasterList"] = _GigDocumentsMasterList;

            if (_GigSubDocumentsList.Count() > 0)
            {
                return Json(_GigSubDocumentsList, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json("Failed", JsonRequestBehavior.AllowGet);
            }
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
        public ActionResult SaveGigSubscription(int GigId, int JobPosterId, string Description, string JobCompletionDate, string Title, int GigSubscriptionId)
        {
            GigSubscription _GigSubscription = new GigSubscription();
            GigSubscriptionModel _GigSubscriptionModel = new GigSubscriptionModel();
            string message = "failed";

            _GigSubscription.GigId = GigId;
            _GigSubscription.JobPosterId = JobPosterId;
            _GigSubscription.Description = Description;
            _GigSubscription.GigSubscriptionId = GigSubscriptionId;
            //CultureInfo culture = new CultureInfo("en-US");
            //DateTime tempDate = Convert.ToDateTime(JobCompletionDate, culture);
            DateTime tempDate = DateTime.ParseExact(JobCompletionDate, "dd/MM/yyyy", CultureInfo.InvariantCulture);
            _GigSubscription.JobCompletionDate = tempDate;
            _GigSubscription.IsActive = "Y";
            _GigSubscription.GigSubscriptionStatus = "S";
            _GigSubscription.Title = Title;



            List<GigSubscriptionDocument> fileList = new List<GigSubscriptionDocument>();
            List<GigSubscriptionDocument> fileUpdatedList = new List<GigSubscriptionDocument>();

            if (TempData["fileList"] != null)
            {
                fileList = (List<GigSubscriptionDocument>)TempData.Peek("fileList");
            }

            if(Session["GigSubDocMasterList"]!=null)
            {
                fileUpdatedList = (List<GigSubscriptionDocument>)Session["GigSubDocMasterList"];
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
                    if(fileUpdatedList!=null)
                    {
                        foreach (var file in fileUpdatedList)
                        {
                            _GigSubscription.GigSubscriptionDocumentList.Add(new GigSubscriptionDocument() { DocumentName = file.DocumentName.ToString(), IsActive = file.IsActive, FileSize = file.FileSize,GigSubscriptionDocumentId=file.GigSubscriptionDocumentId,GigSubscriptionId=file.GigSubscriptionId,CreatedDate=file.CreatedDate });
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
                    if (returnvalue > 0)
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

                Session["GigSubDocMasterList"] = null;
                Session["GigSubDocList"] = null;
            }

            return Json(message, JsonRequestBehavior.AllowGet);
        }
    }
}