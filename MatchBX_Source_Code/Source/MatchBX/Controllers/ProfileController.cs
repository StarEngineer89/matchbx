using Business;
using Google.Authenticator;
using MatchBx.Utilities;
using MatchBX.Models;
using Model;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Dynamic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web;
using System.Web.Mvc;
using System.Web.Services;



namespace MatchBX.Controllers
{
    [CustomExceptionFilter]
    public class ProfileController : Controller
    {
        // GET: Profile
        UserProfileModel objProfileMod = new UserProfileModel();
        UserProfile objProfile = new UserProfile();
        Job objJob = new Job();
        Job objCompletedJob = new Job();
        JobModel objJobMod = new JobModel();
        List<Job> objJobList = new List<Job>();
        List<Job> objCompletedJobList = new List<Job>();
        UserSkillsMappingModel objUserSkill = new UserSkillsMappingModel();
        List<UserSkillsMapping> objUserSkillList = new List<UserSkillsMapping>();
        Gig objGig = new Gig();
        GigModel objGigMod = new GigModel();
        List<Gig> objGigList = new List<Gig>();
        Gig objPurchasedGig = new Gig();
        List<Gig> objPurchasedGigList = new List<Gig>();

        dynamic model = new ExpandoObject();
        int _RecordDisplay = 5;

        [NoCache]
        //[SessionExpire]
        public ActionResult Index(int? id)
        {

            TempData["TrendingTagsFooter"] = MatchBxCommon.GetTrendingTagsFooter();
            TempData["RecordDisplay"] = _RecordDisplay;
            //Session["ProfilePic"] = "/Content/images/client_pic_1.png";
            int userid = id.GetValueOrDefault();
            if (userid.ToString() != null)
            {
                Session["MemberNo"] = userid;
                Session["PublicProfileId"] = userid;

                // Gus: 2FA
                TwoFactorAuthenticator tfa = new TwoFactorAuthenticator();
                string useruniquekey = Convert.ToString(userid) + Session["UserName"];
                Session["Useruniquekey"] = useruniquekey;
                var setupinfo = tfa.GenerateSetupCode("MatchBX-" + Session["email"], useruniquekey, 280, 280);
                ViewBag.qrcode = setupinfo.QrCodeSetupImageUrl;
                ViewBag.manualcode = setupinfo.ManualEntryKey;
            }

            objProfile = objProfileMod.LoadUserProfile(userid).FirstOrDefault();

            try
            {
                string rating = Adjust(decimal.ToDouble(objProfile.Rating)).ToString();
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

            model.Profile = objProfile;

            objUserSkillList = objUserSkill.SkillsByUserId(userid);
            objUserSkillList.ToList().ForEach(x => x.Description = "#" + x.Description.ToString());

            string userskilllist = "";
            foreach (var item in objUserSkillList)
            {
                if (objUserSkillList.IndexOf(item) == objUserSkillList.Count - 1)
                {
                    userskilllist += item.Description;
                }
                else
                {
                    userskilllist += item.Description + ", ";
                }
            }

            model.UserSkill = objUserSkillList;
            model.Skill = userskilllist;

            if (userid != 0)
            {
                objJob.TrendingTagsIdList = "0";
                objJob.SkillsList = "0";
                objJob.UserId = userid;
                Session["PublicProfileId"] = userid;
                objCompletedJob.TrendingTagsIdList = "0";
                objCompletedJob.SkillsList = "0";
                objCompletedJob.JobSeekerId = userid;
                objCompletedJob.FromPage = "J";
                objJob.FromPage = "J";
                //objGig.TrendingTagsIdList = "0";
                //objGig.SkillsList = "0";
                objGig.UserId = userid;
                objGig.LoginUserId = Convert.ToInt32(Session["UserId"]);
                objPurchasedGig.UserId = userid;
                objCompletedJobList = objJobMod.GetJobDetails(objCompletedJob);
                model.CompletedJobCount = objCompletedJobList.Count();
                model.CompletedJob = MatchBxCommon.GenerateBadge(objCompletedJobList.Take(_RecordDisplay).ToList());
                objJobList = objJobMod.GetJobDetails(objJob);
                model.ListedJobCount = objJobList.Count();
                model.ListedJob = MatchBxCommon.GenerateBadge(objJobList.Take(_RecordDisplay).ToList());
                objGigList = objGigMod.GetGigDetailsProfile(objGig);
                model.ListedGigCount = objGigList.Count();
                model.ListedGig = MatchBxCommon.GenerateBadgeForGig(objGigList.Take(_RecordDisplay).ToList());
                //model.UserSkill = objUserSkill.LoadSkillsByUserId(userid);
                objPurchasedGigList = objGigMod.GetPurchasedGig(objPurchasedGig);
                model.PurchasedGigCount = objPurchasedGigList.Count();
                model.PurchasedGig = MatchBxCommon.GenerateBadgeForGig(objPurchasedGigList.Take(_RecordDisplay).ToList());
                model.WithID = "Y";
            }
            else
            {
                model.WithID = "N";
            }
            model.messageSender = 0;
            //model.Job.messageSender=0;
            return View("Index", model);
        }

        //[HttpPost]        
        //[WebMethod]
        public bool VerifyAuth(string code) //FormCollection fc)
        {
            TwoFactorAuthenticator tfa = new TwoFactorAuthenticator();
            string useruniquekey = Convert.ToString(Session["UserId"]) + Session["UserName"];
            bool isvalid = tfa.ValidateTwoFactorPIN(useruniquekey, code);
            return isvalid && objProfileMod.Save2FA(Convert.ToInt32(Session["UserId"]), isvalid) > 0;
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
        public JsonResult ListedJobLoadMore(int id, string skillid)
        {
            objJob.TrendingTagsIdList = "0";
            objJob.SkillsList = "0";
            objJob.UserId = Convert.ToInt32(Session["PublicProfileId"]);
            objJobList = MatchBxCommon.GenerateBadge(objJobMod.GetJobDetails(objJob));
            model.ListedJob = objJobList.Where(x => x.JobId < id).ToList().Take(_RecordDisplay);
            return Json(model.ListedJob, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public JsonResult ListedGigsLoadMore(int id, string skillid)
        {
            //objGig.TrendingTagsIdList = "0";
            //objGig.SkillsList = "0";
            objGig.UserId = Convert.ToInt32(Session["PublicProfileId"]);
            objGig.LoginUserId = Convert.ToInt32(Session["UserId"]);
            objGigList = MatchBxCommon.GenerateBadgeForGig(objGigMod.GetGigDetailsProfile(objGig));
            model.ListedGig = objGigList.Where(x => x.GigId < id).ToList().Take(_RecordDisplay);
            return Json(model.ListedGig, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult PurchasedGigsLoadMore(int id)
        {
            objPurchasedGig.UserId = Convert.ToInt32(Session["PublicProfileId"]);
            objPurchasedGigList = MatchBxCommon.GenerateBadgeForGig(objGigMod.GetPurchasedGig(objPurchasedGig));
            model.PurchasedGig = objPurchasedGigList.Where(x => x.GigSubscriptionId > id).ToList().Take(_RecordDisplay);
            return Json(model.PurchasedGig, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult CompletedJobLoadMore(int id, string skillid)
        {
            objCompletedJob.TrendingTagsIdList = "0";
            objCompletedJob.SkillsList = skillid;
            objCompletedJob.JobSeekerId = Convert.ToInt32(Session["PublicProfileId"]);
            objCompletedJobList = MatchBxCommon.GenerateBadge(objJobMod.GetJobDetails(objCompletedJob));
            model.CompletedJob = objCompletedJobList.Where(x => x.JobId < id).ToList().Take(_RecordDisplay);
            return Json(model.CompletedJob, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public JsonResult LoadTaggedCompletedJobs(string skillid)
        {
            objCompletedJob.TrendingTagsIdList = "0";
            objCompletedJob.SkillsList = skillid;
            objCompletedJob.JobSeekerId = 1;
            objCompletedJobList = objJobMod.GetJobDetails(objCompletedJob);
            model.CompletedJob = MatchBxCommon.GenerateBadge(objCompletedJobList.Take(_RecordDisplay).ToList());
            model.CompletedJobCount = objCompletedJobList.Count();
            return Json(model, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public JsonResult UploadProfilePic()
        {

            string sourceFolderPath = ConfigurationManager.AppSettings["PathForProfilePic"].ToString();
            string message = "";
            if (Request.Files.Count > 0)
            {
                try
                {
                    HttpFileCollectionBase files = Request.Files;
                    HttpPostedFileBase file = files[0];
                    string filename;
                    if (Request.Browser.Browser.ToUpper() == "IE" || Request.Browser.Browser.ToUpper() == "INTERNETEXPLORER")
                    {
                        string[] testfiles = file.FileName.Split(new char[] { '\\' });
                        filename = testfiles[testfiles.Length - 1];
                    }
                    else
                    {
                        filename = file.FileName;
                    }
                    String fileName = Path.GetFileNameWithoutExtension(filename);
                    String extension = Path.GetExtension(filename);
                    fileName = fileName + DateTime.Now.ToString("-yyyy-MM-dd-HH-mm-ss") + Session["UserName"].ToString() + extension;
                    var path = Path.Combine(sourceFolderPath, fileName);
                    file.SaveAs(path);
                    Session["TempProfilePic"] = fileName;
                    message = fileName;

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
            return Json(message, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult UploadDP(string imageData)
        {
            string message = "";
            string sourceFolderPath = ConfigurationManager.AppSettings["PathForProfilePic"].ToString();
            string fileName = DateTime.Now.ToString("-yyyy-MM-dd-HH-mm-ss") + Session["UserName"].ToString() + ".png";
            string fileNameWithPath = sourceFolderPath + fileName;
            using (FileStream fs = new FileStream(fileNameWithPath, FileMode.Create))
            {
                using (BinaryWriter bw = new BinaryWriter(fs))
                {
                    byte[] data = Convert.FromBase64String(imageData);
                    bw.Write(data);
                    bw.Close();
                    message = fileName;
                    Session["TempProfilePic"] = fileName;
                }
            }

            return Json(message, JsonRequestBehavior.AllowGet);
        }
        [NoCache]
        //[SessionExpire]
        public ActionResult CryptoExchange(int? id)
        {
            var Coins = MatchBxCommon.GetOnlyUsefullCoins();

            return View("CryptoExchange", Coins);
        }




        [NoCache]
        [HttpPost]
        public ActionResult CryptoExchange(int? id, FormCollection form)
        {

            string fba = form["fba"];
            string fbb = form["fbb"];
            string fbc = form["fbc"];



            var price = MatchBxCommon.CoinConverter(fba, fbc, Convert.ToDecimal(fbb));
            ViewBag.fba = fba;
            ViewBag.fbb = fbb;
            ViewBag.fbc = fbc;
            ViewBag.fbd = price;
            var Coins = MatchBxCommon.GetOnlyUsefullCoins();
            return View("CryptoExchange", Coins);
        }

        [NoCache]
        //[SessionExpire]
        public ActionResult Arbitration(int? id)
        {

            JobArbitration _objArbitration = new JobArbitration();

            var userId = Convert.ToInt32(Session["UserId"]);
            objJob = new Job()
            {
                UserId = userId,
                CreatedDate = DateTime.Now
            };
            _objArbitration.MyJobs = objJobMod.GetMyJobs(objJob);
            return View("Arbitration", _objArbitration);
        }
        [NoCache]
        [HttpPost]
        public ActionResult Arbitration(int? id, FormCollection form)
        {
            JobArbitration _objArbitration = new JobArbitration();
            var userId = Convert.ToInt32(Session["UserId"]);
            objJob = new Job()
            {
                UserId = userId,
                CreatedDate = DateTime.Now
            };
            _objArbitration.MyJobs = objJobMod.GetMyJobs(objJob);
            _objArbitration.JobId = Convert.ToInt32(form["jobs"]);
            _objArbitration.CreatedBy = Convert.ToInt32(Session["UserId"]);
            _objArbitration.CreatedDate = DateTime.Now;
            _objArbitration.Issue = form["issue"];
            _objArbitration.Outcome = form["outcome"];
            _objArbitration.Stake = Convert.ToDecimal(form["stakeAmount"]);
            _objArbitration.CryptoSymbol =Convert.ToString (form["stakeCrypto"]);
            _objArbitration.IsActive = true; 

            ArbitrationModel _objModelArbitation = new ArbitrationModel();

            try
            {
                _objModelArbitation.Save(_objArbitration);
                ViewBag.Success = true;

            }
            catch (Exception Ex)
            {
                ViewBag.Success = false;


            }

            return View("Arbitration", _objArbitration);
        }


    }
}
