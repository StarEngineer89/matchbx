using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Model;
using Business;
namespace MatchBX.Controllers
{
    public class HomeController : Controller
    {
        MatchBXNotification objNotification = new MatchBXNotification();
        MatchBXNotificationModel objNotiMod = new MatchBXNotificationModel();
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
        public ActionResult Chat()
        {
            return View();
        }
        public ActionResult ChatTest()
        {
            return View();
        }
        public ActionResult ChatPartial(int prmUserId, string from)
        {
           // ViewBag.From = from;
            TempData["FromMsg"] = from;      
            return PartialView("~/Views/Shared/Chat.cshtml");
        }
        public ActionResult ChatForSendMessage(int _prmSendUserId, string from,string _prmJobSeeker,string _prmBidUserProfilePic,int _prmJobID, string _prmJobTitle, int _prmReceiverId = 0)
        {
           // ViewBag.From = from;
            MatchBXMessage _obj = new MatchBXMessage();
            _obj.SendUserId = _prmSendUserId;
            _obj.JobSeeker = _prmJobSeeker;
            _obj.BidUserProfilePic = _prmBidUserProfilePic;
            _obj.ReceiverId = _prmReceiverId != 0 ? _prmReceiverId : Convert.ToInt32(Session["UserId"]);
            _obj.JobId = _prmJobID;
            _obj.JobTitle = _prmJobTitle;
            Session["messageJobId"] = _prmJobID;
            return PartialView("~/Views/Shared/Chat.cshtml",_obj);
        }
        public ActionResult ChatFromMail(int _prmSendUserId)
        {
            // ViewBag.From = from;
            UserProfileModel _objUserModel = new UserProfileModel();
            UserProfile _profile = _objUserModel.LoadUserProfile(_prmSendUserId).FirstOrDefault();

            MatchBXMessage _obj = new MatchBXMessage();
            _obj.SendUserId = _prmSendUserId;
            _obj.BidUserProfilePic = _profile.ProfilePic;
            _obj.JobSeeker = _profile.FullName;
            _obj.ReceiverId = Convert.ToInt32(Session["UserId"]);
            Session["mailMessagId"] = 0;
            return PartialView("~/Views/Shared/Chat.cshtml", _obj);
        }
        public ActionResult LoadAllChat(int prmReceiverId, int prmSendUserId)
        {
            var userId = Convert.ToInt32(Session["UserId"]);
            //int messageJobId = Convert.ToInt32(Session["messageJobId"]);
            int messageJobId = 0;
            MatchBXMessageModel _objModel = new MatchBXMessageModel();
            List<MatchBXMessage> _list = new List<MatchBXMessage>();
            _list = _objModel.GetChatMessage(prmReceiverId, prmSendUserId, messageJobId);

            if (_list.Where(m => m.ReadStatus == 0).ToList().Count > 0 && prmSendUserId != userId)
            {
                var _obj = new MatchBXMessage();
                _obj.ReceiverId = prmReceiverId;
                _obj.SendUserId = prmSendUserId;
                _obj.ReadStatus = 1;
                _obj.JobId = 0;
                _objModel.ChangeReadStatus(_obj);
            }
            Session["messageJobId"] = 0;
            return Json(_list, JsonRequestBehavior.AllowGet);
        }
        public ActionResult LoadChatLandingDetails(int prmReceiverId)
        {
            MatchBXMessageModel _objModel = new MatchBXMessageModel();
            List<MatchBXMessage> _list = new List<MatchBXMessage>();
            _list = _objModel.GetAllChatMessage(prmReceiverId);
            if (_list.Where(m => m.ReadStatus == 0 && m.JobId == 0).ToList().Count == 0)
            {
                Session["MessageStatus"] = "N";
            }
            return Json(_list, JsonRequestBehavior.AllowGet);
        }

        public ActionResult LoadProjectMessages(int prmReceiverId)
        {
            MatchBXMessageModel _objModel = new MatchBXMessageModel();
            List<MatchBXMessage> _list = new List<MatchBXMessage>();
            _list = _objModel.GetProjectMessages(prmReceiverId);
            if (_list.Where(m => m.ReadStatus == 0 && m.JobId != 0).ToList().Count == 0)
            {
                Session["ProjectMsgStatus"] = "N";
            }
            return Json(_list, JsonRequestBehavior.AllowGet);
        }
        [AllowAnonymous]
        [HttpPost]
        public ActionResult LoadProjectMessageForJob(int _prmSendUserId, int _prmJobID)
        {
            var userId = Convert.ToInt32(Session["UserId"]);
            int messageJobId = _prmJobID;
            MatchBXMessageModel _objModel = new MatchBXMessageModel();
            List<MatchBXMessage> _list = new List<MatchBXMessage>();
            _list = _objModel.GetChatMessage(userId, _prmSendUserId, _prmJobID);

            if (_list.Where(m => m.ReadStatus == 0).ToList().Count > 0 && _prmSendUserId != userId)
            {
                var _objMsg = new MatchBXMessage();
                _objMsg.ReceiverId = _prmSendUserId;
                _objMsg.SendUserId = userId;
                _objMsg.ReadStatus = 1;
                _objMsg.JobId = _prmJobID;
                _objModel.ChangeReadStatus(_objMsg);
            }
            Session["messageJobId"] = _prmJobID;
            return Json(_list, JsonRequestBehavior.AllowGet);
        }

        public ActionResult CheckAllMsgRead(int prmReceiverId)
        {
            MatchBXMessageModel _objModel = new MatchBXMessageModel();
            //List<MatchBXMessage> _list = new List<MatchBXMessage>();
            var msgStatus = _objModel.GetMessageStatus(prmReceiverId);
            if(msgStatus.MessageStatus == "N")
            {
                Session["MessageStatus"] = "N";
            }
            if (msgStatus.ProjectMsgStatus == "N")
            {
                Session["ProjectMsgStatus"] = "N";
            }
            return Json(msgStatus, JsonRequestBehavior.AllowGet);
        }
        public ActionResult GetNotification()
        {
            List<MatchBXNotification> notificationList = new List<MatchBXNotification>();
            notificationList = objNotiMod.GetNotificationsForReceiver(Convert.ToInt32(Session["UserId"]));
            var unread = notificationList.Count(n => n.ReadStatus == 0);
            dynamic NotificationObject = new System.Dynamic.ExpandoObject();
            NotificationObject.List = notificationList;
            NotificationObject.Unread = unread;
            return Json(NotificationObject, JsonRequestBehavior.AllowGet);
        }
        public ActionResult SetNotificationsRead(List<MatchBXNotification> notifications)
        {
            if (notifications != null)
            {
                foreach (var notification in notifications)
                {
                    var status = objNotiMod.Save(notification);
                }
            
            Session["NotificationStatus"] = "N";
            }
            return Json("success", JsonRequestBehavior.AllowGet);
        }
        public ActionResult SetNotificationsReadStatus(int ReceiverId)
        {
            objNotification.ReceiverId = ReceiverId;
            if (objNotiMod.SetNotificationsReadStatus(objNotification))
            {
                Session["NotificationStatus"] = "N";
                return Json("success", JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json("failed", JsonRequestBehavior.AllowGet);
            }            
            
        }

        [HttpGet]
        public ActionResult IsUserApproved(int UserId,string Address)
        {
            var data = "Failed";
            TransactionDetailModel _TransactionDetailModel = new TransactionDetailModel();
            TransactionDetail _TransactionDetail = _TransactionDetailModel.GetList(" IsApproved,Amount ", " UserId = " + UserId + " and Address = '" + Address + "' and IsApproved <> 'F' and TransactionType = 'A'").FirstOrDefault();
            if (_TransactionDetail != null)
            {
                //data = new JavaScriptSerializer().Serialize(_ContractDetail);
                return Json(_TransactionDetail, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(data, JsonRequestBehavior.AllowGet);
            }

        }

    }
}