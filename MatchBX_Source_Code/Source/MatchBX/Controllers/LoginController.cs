using Business;
using MatchBx.Utilities;
using MatchBX.Models;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security;
using Model;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Security.Principal;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace MatchBX.Controllers
{
    [ExceptionLogAttribute]
    public class LoginController : Controller
    {
        // GET: Login
        Users objUsers = new Users();
        UsersModel objUsersMod = new UsersModel();
        List<Users> objUsersList = new List<Users>();
        Login objLogin = new Login();
        LoginModel objLoginMod = new LoginModel();
        UserProfile objUserProfile = new UserProfile();
        UserProfileModel objProfileMod = new UserProfileModel();
        List<UserProfile> objProfileList = new List<UserProfile>();

        private ApplicationSignInManager _signInManager;
        private ApplicationUserManager _userManager;

        public LoginController()
        {
        }

        public LoginController(ApplicationUserManager userManager, ApplicationSignInManager signInManager)
        {
            UserManager = userManager;
            SignInManager = signInManager;
        }

        public ApplicationSignInManager SignInManager
        {
            get
            {
                return _signInManager ?? HttpContext.GetOwinContext().Get<ApplicationSignInManager>();
            }
            private set
            {
                _signInManager = value;
            }
        }

        public ApplicationUserManager UserManager
        {
            get
            {
                return _userManager ?? HttpContext.GetOwinContext().GetUserManager<ApplicationUserManager>();
            }
            private set
            {
                _userManager = value;
            }
        }

        public ActionResult Index()
        {
            return View();
        }
        
        // GET: /Login/Login
        [AllowAnonymous]
        [OutputCache(Duration = 3600, VaryByParam = "none")]  
        public ActionResult Login()
        {
            LoginViewModel model = new LoginViewModel();
            if (Request.Cookies["userLogin"] != null)
                model.UserName = Request.Cookies["userLogin"].Values["UserName"];
            ViewBag.UserName = model.UserName;
            return View("Login");
        }

        // POST: /Login/Login
        [HttpPost]
        [AllowAnonymous]
        //[ValidateAntiForgeryToken]
        public JsonResult Login(MatchBX.Models.LoginViewModel model)
        {
            MessageDetails _MessageModel = new MessageDetails();
            if (ModelState.IsValid)
            {
                objUsers.Email = model.UserName;
                objUsers.Password = model.Password;
                objUsers.HubId = model.HubId;
                if(ValidateUser(objUsers,""))
                {
                    FormsAuthentication.SetAuthCookie(Session["Email"].ToString(), false);
                    HttpCookie usercookie = new HttpCookie("userLogin");

                    #region Remember Me Cookie Setting
                    if (model.RememberMe)
                    {
                        usercookie.Values.Add("UserName", Session["Email"].ToString());
                        usercookie.Expires = DateTime.Now.AddDays(15);
                        Response.Cookies.Add(usercookie);
                    }
                    else if (Request.Cookies["userLogin"] != null)
                    {
                        model.UserName = Request.Cookies["userLogin"].Values["UserName"];
                    }
                    else
                    {
                        usercookie.Expires = DateTime.Now.AddDays(-1);
                    }
                    #endregion
                     Session["FirstLogin"] = "N";
                    _MessageModel.Status = "true";
                    if(Convert.ToInt32(Session["UserType"]) == 4)
                    {
                        if (TempData["jid"] != null)
                        {
                            _MessageModel.RedirectUrl = "/Admin/Index?jid="+ TempData["jid"].ToString();
                             TempData["jid"] = null;
                        }
                        else if (TempData["gigid"] != null)
                        {
                            _MessageModel.RedirectUrl = "/Admin/GigReview?Gigid=" + TempData["gigid"].ToString();
                            TempData["gigid"] = null;
                        }
                        else
                        {
                            _MessageModel.RedirectUrl = "/Admin/Index";
                        }
                       
                    }
                   else {
                        _MessageModel.RedirectUrl = "/Dashboard/Index";
                    }
                   
                    //return RedirectToAction("Index", "Dashboard");

                    //List<Login> objUsersLoginList = new List<Login>();

                    //objUsersLoginList = objLoginMod.GetList("*", "UserId = '" + Convert.ToInt32(Session["UserId"]) + "'");
                    //if (objUsersLoginList.Count > 1)
                    //{
                    //    return RedirectToAction("Index", "Dashboard");
                    //}
                    //else
                    //{
                    //    if (Convert.ToInt32(Session["UserType"]) != 2)
                    //    {
                    //        return RedirectToAction("SkillMapping", "Login");
                    //    }
                    //    else
                    //    {
                    //        return RedirectToAction("Index", "Dashboard");
                    //    }
                    //}
                    return Json(_MessageModel, JsonRequestBehavior.AllowGet);
                }
                else
                {
                 
                    _MessageModel.Status = "false";
                    _MessageModel.RedirectUrl = "";
                    _MessageModel.Message = "Sorry, your login details are incorrect. Please try again.";
                     return Json(_MessageModel, JsonRequestBehavior.AllowGet);
                }
            }
            else
            {
                return Json(_MessageModel, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult ReDoLogin()
        {
            return PartialView("_ReDoLogin");
        }


        [AllowAnonymous]
        public ActionResult VerifyUserEmail(string email, string code)
        {
            //objUsersList = objUsersMod.GetList("*", " Email = '" + email + "' and VerificationCode='"+code+"'");
            //if (objUsersList.Count() > 0)
            //{
            //    objUsers = objUsersList.FirstOrDefault();
            //    if(objUsers.IsActive!=1)
            //    { 
            //        objUsers.IsActive = 1;

            //        int returnValue = objUsersMod.Save(objUsers);
            //        if (returnValue > 0)
            //        {
            //            if (ValidateUser(objUsers, code))
            //            {                            
            //                Session["FirstLogin"] = "Y";                            
            //                return RedirectToAction("Index", "Dashboard");
            //                #region
            //                //List<Login> objUsersLoginList = new List<Login>();

            //                //objUsersLoginList = objLoginMod.GetList("*", "UserId = '" + Convert.ToInt32(Session["UserId"]) + "'");
            //                //if (objUsersLoginList.Count > 1)
            //                //{
            //                //    return RedirectToAction("Index", "Dashboard");
            //                //}
            //                //else
            //                //{
            //                //    if (Convert.ToInt32(Session["UserType"]) != 2)
            //                //    {
            //                //        return RedirectToAction("SkillMapping", "Login");
            //                //    }
            //                //    else
            //                //    {
            //                //        return RedirectToAction("Index", "Dashboard");
            //                //    }
            //                //}
            //                #endregion
            //            }
            //            else
            //            {
            //                Session["VerificationMessage"] = "failed";
            //                return RedirectToAction("Index", "Jobs");
            //            }
            //        }
            //        else
            //        {
            //            Session["VerificationMessage"] = "failed";
            //            return RedirectToAction("Index", "Jobs");
            //        }
            //    }
            //    else
            //    {
            //        Session["VerificationMessage"] = "verified";
            //        return RedirectToAction("Index", "Jobs");
            //    }
            //}
            //else
            //{
            //    Session["VerificationMessage"] = "failed";
            //    return RedirectToAction("Index", "Jobs");
            //}

            objUsersList = objUsersMod.GetList("*", " Email = '" + email + "' and IsActive=1 ");
            if (objUsersList.Count() > 0)
            {
                Session["IsEmailAlready"] = "Y";

                return RedirectToAction("Index", "Jobs");
            }
            else
            {
                objUsersList = objUsersMod.GetList("*", " Email = '" + email + "' and VerificationCode='" + code + "'");
                if (objUsersList.Count() > 0)
                {
                    objUsers = objUsersList.FirstOrDefault();
                    if (objUsers.IsActive != 1)
                    {
                        objUsers.IsActive = 1;
                        int returnValue = objUsersMod.Save(objUsers);
                        if (returnValue > 0)
                        {
                            if (ValidateUser(objUsers, code))
                            {
                                Session["FirstLogin"] = "Y";
                                return RedirectToAction("Index", "Dashboard");
                            }
                            else
                            {
                                Session["VerificationMessage"] = "failed";
                                return RedirectToAction("Index", "Jobs");
                            }
                        }
                        else
                        {
                            Session["VerificationMessage"] = "failed";
                            return RedirectToAction("Index", "Jobs");
                        }
                    }
                    else
                    {
                        Session["VerificationMessage"] = "verified";
                        return RedirectToAction("Index", "Jobs");
                    }
                }
                return RedirectToAction("Index", "Jobs");
            }
        }

        public bool ValidateUser(Users user,string code)
         {
            string email = user.Email; 
            string password = user.Password;
            //objUsersList = objUsersMod.GetList("*", " Email = '" + email + "' and Password = '" + password + "'");
            objUsersList = objUsersMod.GetUserDetails(user);
            
            if (objUsersList.Count() > 0)
            {
                if (objUsersList[0].IsActive == 0 && code=="")
                {
                    TempData["ErrorMessage"] = "Account not verified";
                    return false;
                }
                else if (objUsersList[0].IsActive==0 && objUsersList[0].BlockReason!=0)
                {
                    TempData["ErrorMessage"] = "Account blocked by admin";
                    return false;
                }
                else
                {
                    Session["UserName"] = objUsersList[0].UserName;
                    Session["UserId"] = objUsersList[0].UserId;
                    Session["MemberNo"] = objUsersList[0].UserId;
                    Session["UserType"] = objUsersList[0].UserType;
                    Session["FullName"] = objUsersList[0].FullName == null ? "@"+objUsersList[0].UserName : objUsersList[0].FullName;
                    Session["Email"] = objUsersList[0].Email;
                    Session["NotificationStatus"] = objUsersList[0].NotificationStatus;
                    Session["MessageStatus"] = objUsersList[0].MessageStatus;
                    Session["ProjectMsgStatus"] = objUsersList[0].ProjectMsgStatus;
                    //Session["ProfilePic"] = objProfileMod.GetARecord(objUsersList[0].UserId).ProfilePic;
                    SetSession();
                    if (objProfileMod.GetList("*", "UserId=" + objUsersList[0].UserId).Count() > 0)
                    {
                        Session["ProfilePic"] = objProfileMod.GetList("*", "UserId=" + objUsersList[0].UserId).FirstOrDefault().ProfilePic;
                        if(Session["ProfilePic"]==null || Session["ProfilePic"].ToString()=="")
                        {
                            Session["ProfilePic"] = "/Content/images/user.png";
                        }
                    }
                    else
                    {
                        Session["ProfilePic"]= "/Content/images/user.png";
                    }
                    TempData["UserId"] = objUsersList[0].UserId;
                    objLogin.UserId = objUsersList[0].UserId;
                    objLogin.IPAddress = GetIPAddress();
                    objLogin.LoginDate = DateTime.Now;
                    objLogin.HubId = user.HubId;
                    int returnValue = objLoginMod.Save(objLogin);
                    if (returnValue > 0)
                    {
                        Session["LoginId"] = returnValue;
                        return true;
                    }
                    else
                    {
                        TempData["ErrorMessage"] = "Login Failed";
                        return false;
                    }
                }
                
            }  
            else
            {
                TempData["ErrorMessage"] = "Sorry, your login details are incorrect. Please try again.";
                return false;
            }
                
        }
        public void SetSession()
        {
            AjaxSession obj = new AjaxSession();
            if(Session["UserId"]!=null)
            {
                obj.SessionString = Session["UserType"].ToString() == "2" ? "G" : "J";
                obj.UserId = Convert.ToInt32(Session["UserId"].ToString());
                AjaxSessionModel ObjModel = new AjaxSessionModel();
                ObjModel.Save(obj);
            }
           
        }
        public bool ValidateExternalUser(Users user)
        {
            string email = user.Email;
            string password = user.Password;
            objUsersList = objUsersMod.GetList("*", " UserName = '" + user.Email + "'");
            if (objUsersList.Count() > 0)
            {
                if (objUsersList[0].IsActive == 0)
                {
                    TempData["ErrorMessage"] = "Account blocked by admin";
                    return false;
                }
                else
                {
                    Session["UserName"] = objUsersList[0].UserName;
                    Session["UserId"] = objUsersList[0].UserId;
                    Session["MemberNo"]= objUsersList[0].UserId;
                    Session["UserType"] = objUsersList[0].UserType;
                    Session["FullName"] = objUsersList[0].FullName;
                    Session["Email"] = objUsersList[0].Email;
                    objLogin.UserId = objUsersList[0].UserId;
                    objLogin.IPAddress = GetIPAddress();
                    objLogin.LoginDate = DateTime.Now;
                    int returnValue = objLoginMod.Save(objLogin);
                    if (returnValue > 0)
                    {
                        Session["LoginId"] = returnValue;
                        return true;
                    }
                    else
                    {
                        TempData["ErrorMessage"] = "Login Failed";
                        return false;
                    }
                }

            }
            else
            {
                TempData["ErrorMessage"] = "Sorry, your login details are incorrect. Please try again.";
                return false;
            }
        }

        public string GetIPAddress()
        {
            string ipaddress;
            ipaddress = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            if (ipaddress == "" || ipaddress == null)
                ipaddress = Request.ServerVariables["REMOTE_ADDR"];
            return ipaddress;
        }

        // GET: /Login/Register
        [AllowAnonymous]
        [OutputCache(Duration = 3600, VaryByParam = "none")]
        public ActionResult Register()
        {
            //RegisterViewModel model = new RegisterViewModel();
            return View("Register");
        }

        // POST: /Login/Register
        [HttpPost]
        [AllowAnonymous]
        //[ValidateAntiForgeryToken]
        public JsonResult Register(MatchBX.Models.RegisterViewModel model)
        {
            MessageDetails _ModelMessage = new MessageDetails();
            if (ModelState.IsValid)
            {
                Guid obj = Guid.NewGuid();
                string verificationcode = obj.ToString();
                objUsers.VerificationCode = verificationcode;
                objUsers.Password = model.Password;
                objUsers.Email = model.Email;
                string fullname = "";
                if(model.FullName!=null)
                {
                    fullname = CultureInfo.CurrentCulture.TextInfo.ToTitleCase(model.FullName);
                }
                //else
                //{
                //    fullname = model.FullName.ToString();
                //}
                string userName = "";
                if (model.UserName != null)
                {
                    userName = CultureInfo.CurrentCulture.TextInfo.ToTitleCase(model.UserName);
                }
                //else
                //{
                //    userName = model.UserName.ToString();
                //}
                objUsers.FullName = fullname;
                objUsers.UserName = userName;
                objUsers.IsActive = 0;
                objUsers.CreatedDate = DateTime.Now;
                objUsers.ModifiedDate = DateTime.Now;
                if (SaveUserInfo(objUsers))
                {
                    _ModelMessage.Status = "true";
                    _ModelMessage.RedirectUrl = "/Login/Onboarding";

                   // return RedirectToAction("Onboarding", "Login");
                }
                else
                {
                    _ModelMessage.Status = "false";
                    //return View("_Register",model);
                }
            }
            return Json(_ModelMessage, JsonRequestBehavior.AllowGet);
        }
        public bool SaveUserInfo(Users user)
        {
            int returnValue = objUsersMod.Save(user);
            if (returnValue > 0)
            {
                Session["TempUserId"] = returnValue;
                return true;
            }
            else
            {
                TempData["ErrorMessage"] = "User Registration Failed";
                return false;
            }
        }

        // GET: /Login/Onboarding
        [AllowAnonymous]
        public ActionResult Onboarding()
        {
            return View();
        }

        // POST: /Login/Onboarding
        [HttpPost]
        [AllowAnonymous]
        public ActionResult Onboarding(string type)
        {
            var message = "";
            if (ModelState.IsValid)
            {
                if(SaveUserType(type))
                {
                    return Json("success", JsonRequestBehavior.AllowGet);
                    //return RedirectToAction("Login", "Login");
                }
                else
                {
                    message = TempData["ErrorMessage"].ToString();
                    return Json(message, JsonRequestBehavior.AllowGet);
                }
            }
            //return View(model);
            return Json("User preference not saved", JsonRequestBehavior.AllowGet);
        }

        [AllowAnonymous]
        public ActionResult ResendMail()
        {
            return View();
        }



        [HttpPost]
        [AllowAnonymous]
        public JsonResult ResendMail(int id)
        {
            objUsersList = objUsersMod.GetList("*", " UserId = '" + id + "'");
            if (objUsersList.Count() > 0)
            {
                objUsers = objUsersList.FirstOrDefault();
                string fullname = objUsers.FullName != null ? objUsers.FullName : "@" + objUsers.UserName;
                MatchBxCommon.verificationmail(fullname, objUsers.VerificationCode, objUsers.Email, false);
                return Json("success", JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json("failed", JsonRequestBehavior.AllowGet);
            }
        }
        public bool SaveUserType(string type)
        {
            int tempuserid = Convert.ToInt32(Session["TempUserId"]);
            objUsersList = objUsersMod.GetList("*", " UserId = '" + tempuserid + "'");
            if(objUsersList.Count()>0)
            {
                objUsers = objUsersList[0];
                objUsers.UserType = type;
                objUsers.ModifiedDate = DateTime.Now;
                int returnValue = objUsersMod.Save(objUsers);
                if (returnValue > 0)
                {
                    string fullname = objUsers.FullName != null ? objUsers.FullName : "@"+objUsers.UserName;
                    MatchBxCommon.verificationmail(fullname,objUsers.VerificationCode,objUsers.Email,false);
                    return true;
                }
                else
                {
                    TempData["ErrorMessage"] = "User preference not saved";
                    return false;
                }
            }
            else
            {
                TempData["ErrorMessage"] = "No such user exists";
                return false;
            }
            
        }


        // GET: /Login/ForgotPassword
        [AllowAnonymous]
        public ActionResult ForgotPassword()
        {
            
            return View();
        }

        // POST: /Login/ForgotPassword
        [HttpPost]
        [AllowAnonymous]
        //[ValidateAntiForgeryToken]
        public ActionResult ForgotPassword(MatchBX.Models.ForgotPasswordViewModel model)
        {
            objUsers.Email = model.Email;
            MessageDetails _Model = new MessageDetails();
            if (ModelState.IsValid)
            {
                ValidateEmail(objUsers);

                _Model.Message = TempData.Peek("ErrorMessage").ToString();
                _Model.Status = TempData.Peek("Status").ToString();
                return Json(_Model, JsonRequestBehavior.AllowGet);
            }
            else
            {
                _Model.Message = "Invalid Email";
                _Model.Status = "false";
                return Json(_Model, JsonRequestBehavior.AllowGet);
            }
            

        }

        public bool ValidateEmail(Users user)
        {
            string email = user.Email;
            objUsersList = objUsersMod.GetList("*", " Email = '" + email + "' and IsActive=1");
            if (objUsersList.Count() > 0)
            {
                objUsers.UserId = objUsersList[0].UserId;
                objUsers.Password = objUsersList[0].Password;
                objUsers.Email = objUsersList[0].Email;
                objUsers.FullName = objUsersList[0].FullName;
                objUsers.UserName = objUsersList[0].UserName;
                MatchBxCommon.sendForgetPasswordEmail(objUsers, false);
                TempData["ErrorMessage"] = "Instructions to reset your password have been sent to your e-mail address. If you need further assistance, please contact support@matchbx.io";
                TempData["Status"] = "true";
                return true;
            }
            else
            {
                TempData["ErrorMessage"] = "Account with specified email not found." ;
                TempData["Status"] = "false";
                return false;
            }
                
        }

        // GET: /Login/ResetPassword
        [AllowAnonymous]
        
        public ActionResult ResetPassword(string email)
        {
            MatchBX.Models.ResetPasswordViewModel model = new ResetPasswordViewModel();
            model.Email = email;
            TempData["ErrorMessage"] = "";
            return View(model);
        }

        // POST: /Login/ResetPassword
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
       
        public ActionResult ResetPassword(MatchBX.Models.ResetPasswordViewModel model)
        {
            string decryptemail= MatchBxCommon.Decrypt(model.Email);
            if (ModelState.IsValid)
            {
                ResetUserPassword(decryptemail, model.Password);
            }

            return View(model);
        }

        public bool ResetUserPassword(string email,string password)
        {
            MatchBXNotification objNotification = new MatchBXNotification();
            MatchBXNotificationModel objNotiMod = new MatchBXNotificationModel();
            objUsersList = objUsersMod.GetList("*", " Email = '" + email + "' and IsActive=1");
            if (objUsersList.Count() > 0)
            {
                objUsers = objUsersList[0];
                objUsers.Password = password;
                objNotification.ReceiverId = objUsers.UserId;
                objNotification.SenderId = objUsers.UserId;
                objNotification.ReadStatus = 0;
                objNotification.Notification = "Your password has been reset ";
                objNotification.Header = "Reset Password";
                int returnValue = objUsersMod.Save(objUsers);
                if(returnValue>0)
                {
                    MatchBxCommon.sendResetPasswordAckEmail(objUsers, false);
                   int retstatus = objNotiMod.Save(objNotification);
                    TempData["ErrorMessage"] = "Your password has been reset successfully.";
                    return true;
                }
                else
                {
                    TempData["ErrorMessage"] = "Password Reset Failed";
                    return false;
                }
            }
            else
            {
                TempData["ErrorMessage"] = "The email is not registered for a Matchbx Account. Please try again";
                return false;
            }
            
        }

        [AllowAnonymous]
        public ActionResult CheckUserName(string UserName)
        {
            bool ifUserNameExist = true;
            objUsersList = objUsersMod.GetList("*", "( UserName = '" + UserName + "' and IsActive=1 ) OR (UserName = '" + UserName + "' and ISNULL(BlockReason,0)!=0)");
            if (objUsersList.Count() > 0)
            {
                ifUserNameExist = false;
            }
            return Json(ifUserNameExist, JsonRequestBehavior.AllowGet);
        }

        [AllowAnonymous]
        public ActionResult CheckUserEmail(string Email)
        {
            bool ifUserEmailExist = true;
            objUsersList = objUsersMod.GetList("*", "( Email = '" + Email + "' and  IsActive=1 ) OR (Email = '" + Email + "' and ISNULL(BlockReason,0) !=0 ) ");
            if (objUsersList.Count() > 0)
            {
                ifUserEmailExist = false;
            }
            return Json(ifUserEmailExist, JsonRequestBehavior.AllowGet);
        }
        [AllowAnonymous]
        public ActionResult ValidatePassword(string Password)
        {
            bool isValidPassword = true;
            if ((Regex.IsMatch(Password, @"[a-zA-Z]{8,}")) && (Regex.IsMatch(Password, @"[0-9]{1,}")))
            {
                isValidPassword = true;
            }
            else
            {
                isValidPassword = false;
            }
            return Json(isValidPassword, JsonRequestBehavior.AllowGet);
        }

        // POST: /Login/LogOff
        //[HttpPost]
        //[ValidateAntiForgeryToken]
        public ActionResult LogOff()
        {
            objLogin.UserId = Convert.ToInt32(Session["UserId"]);
            objLogin.LogoutDate = DateTime.Now;
            objLogin.LoginId = Convert.ToInt32(Session["LoginId"]);
            objLoginMod.Save(objLogin);
            Session.Clear();
            Session.Abandon();
            FormsAuthentication.SignOut();
            HttpContext.User = new GenericPrincipal(new GenericIdentity(string.Empty), null);
            // return RedirectToAction("Login", "Login");
            return RedirectToAction("Index", "Jobs");
        }


        //
        // POST: /Account/ExternalLogin
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult ExternalLogin(string provider, string returnUrl)
        {
            // Request a redirect to the external login provider
            return new ChallengeResult(provider, Url.Action("ExternalLoginCallback", "Login", new { ReturnUrl = returnUrl }));
        }

        //
        // GET: /Account/ExternalLoginCallback
        [AllowAnonymous]
        public async Task<ActionResult> ExternalLoginCallback(string returnUrl)
        {
            //string controllerName = ControllerContext.RouteData.Values["Controller"].ToString();
            //string actionName = ControllerContext.RouteData.Values["Action"].ToString();
            // Home is default controller
            //var controller = (Request.UrlReferrer.Segments.Skip(1).Take(1).SingleOrDefault() ?? "Home").Trim('/');

            //// Index is default action 
            //var action = (Request.UrlReferrer.Segments.Skip(2).Take(1).SingleOrDefault() ?? "Index").Trim('/');

            var loginInfo = await AuthenticationManager.GetExternalLoginInfoAsync();
            if (loginInfo == null)
            {
                return RedirectToAction("Login");
            }

            // Sign in the user with this external login provider if the user already has a login
            //var result = await SignInManager.ExternalSignInAsync(loginInfo, isPersistent: false);
            //switch (result)
            //{
            //    case SignInStatus.Success:
            //        return RedirectToLocal(returnUrl);
            //    case SignInStatus.LockedOut:
            //        return View("Lockout");
            //    case SignInStatus.RequiresVerification:
            //        return RedirectToAction("SendCode", new { ReturnUrl = returnUrl, RememberMe = false });
            //    case SignInStatus.Failure:
            //    default:
            //        // If the user does not have an account, then prompt the user to create an account
            //        ViewBag.ReturnUrl = returnUrl;
            //        ViewBag.LoginProvider = loginInfo.Login.LoginProvider;
            //        return View("ExternalLoginConfirmation", new ExternalLoginConfirmationViewModel { Email = loginInfo.Email });
            //}
            Users _user = new Users();
            _user.Email = loginInfo.Email;
            _user.FullName = loginInfo.DefaultUserName;
            if(ValidateExternalUser(_user))
            {
                FormsAuthentication.SetAuthCookie(Session["Email"].ToString(), false);
                HttpCookie usercookie = new HttpCookie("userLogin");
                usercookie.Expires = DateTime.Now.AddDays(-1);
                return PartialView("Register");
            } else
            {
                RegisterViewModel model = new RegisterViewModel();
                if(loginInfo.Email != null)
                {
                    model.Email = loginInfo.Email;
                }
                model.FullName = loginInfo.DefaultUserName;
                ViewBag.ReturnUrl = returnUrl;
                ViewBag.LoginProvider = loginInfo.Login.LoginProvider;
                return PartialView("Register", model);
            }

        }

        //
        // POST: /Account/ExternalLoginConfirmation
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> ExternalLoginConfirmation(ExternalLoginConfirmationViewModel model, string returnUrl)
        {
            if (User.Identity.IsAuthenticated)
            {
                return RedirectToAction("Index", "Manage");
            }

            if (ModelState.IsValid)
            {
                // Get the information about the user from the external login provider
                var info = await AuthenticationManager.GetExternalLoginInfoAsync();
                if (info == null)
                {
                    return View("ExternalLoginFailure");
                }

                objUsers.UserName = model.Email;
                objUsers.Password = System.Web.Security.Membership.GeneratePassword(8, 3);
                objUsers.Email = model.Email;
                objUsers.FullName = info.DefaultUserName;
                objUsers.IsActive = 1;
                objUsers.CreatedDate = DateTime.Now;
                objUsers.ModifiedDate = DateTime.Now;
                if (SaveUserInfo(objUsers))
                {
                    return RedirectToAction("Onboarding", "Login");
                }
                else
                {
                    return View(model);
                }

                //var user = new ApplicationUser { UserName = model.Email, Email = model.Email };
                //var result = await UserManager.CreateAsync(user);
                //if (result.Succeeded)
                //{
                //    result = await UserManager.AddLoginAsync(user.Id, info.Login);
                //    if (result.Succeeded)
                //    {
                //        await SignInManager.SignInAsync(user, isPersistent: false, rememberBrowser: false);
                //        return RedirectToLocal(returnUrl);
                //    }
                //}
                //AddErrors(result);
            }

            ViewBag.ReturnUrl = returnUrl;
            return View(model);
        }

        //
        // GET: /Account/ExternalLoginFailure
        [AllowAnonymous]
        public ActionResult ExternalLoginFailure()
        {
            return View();
        }
        public ActionResult SkillMapping()
        {
            JobModel objJobMod = new JobModel();
            TempData["Skills"] = objJobMod.GetSkills();
            return View();
        }
        public ActionResult SaveUserSkillMapping(UserSkillsMapping userSkills)
        {
            string message = "";
            if (ModelState.IsValid)
            {
                UserSkillsMappingModel objSkillMod = new UserSkillsMappingModel();
                UserSkillsMapping objSkillMapping = new UserSkillsMapping();
                int retval = 0;
                for (int i = 0; i < userSkills.UserSkillsMappingList.Count; i++)
                {
                    objSkillMapping.UserId = userSkills.UserSkillsMappingList[i].UserId;
                    objSkillMapping.SkillsId = userSkills.UserSkillsMappingList[i].SkillsId;
                    objSkillMapping.Description = userSkills.UserSkillsMappingList[i].Description;
                    retval = objSkillMod.Save(objSkillMapping);
                }
                //objSkillMapping.UserSkillsMappingList = userSkills.UserSkillsMappingList;

                if (retval > 0)
                {
                    Session["FirstLogin"] = "N";
                    Session["UserSkillsMapping"] = "Y";
                    message = "Success";
                }
                else
                {
                    message = "Fail";
                }
            }
            
                return Json(message, JsonRequestBehavior.AllowGet);
              
           }
                
        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                if (_userManager != null)
                {
                    _userManager.Dispose();
                    _userManager = null;
                }

                if (_signInManager != null)
                {
                    _signInManager.Dispose();
                    _signInManager = null;
                }
            }

            base.Dispose(disposing);
        }

        public class MessageDisplay {

            public string message { get; set; }
            public string status { get; set; }
        }

        #region Helpers
        // Used for XSRF protection when adding external logins
        private const string XsrfKey = "XsrfId";

        private IAuthenticationManager AuthenticationManager
        {
            get
            {
                return HttpContext.GetOwinContext().Authentication;
            }
        }

        private void AddErrors(IdentityResult result)
        {
            foreach (var error in result.Errors)
            {
                ModelState.AddModelError("", error);
            }
        }

        private ActionResult RedirectToLocal(string returnUrl)
        {
            if (Url.IsLocalUrl(returnUrl))
            {
                return Redirect(returnUrl);
            }
            return RedirectToAction("Index", "Home");
        }

        internal class ChallengeResult : HttpUnauthorizedResult
        {
            public ChallengeResult(string provider, string redirectUri)
                : this(provider, redirectUri, null)
            {
            }

            public ChallengeResult(string provider, string redirectUri, string userId)
            {
                LoginProvider = provider;
                RedirectUri = redirectUri;
                UserId = userId;
            }

            public string LoginProvider { get; set; }
            public string RedirectUri { get; set; }
            public string UserId { get; set; }

            public override void ExecuteResult(ControllerContext context)
            {
                var properties = new AuthenticationProperties { RedirectUri = RedirectUri };
                if (UserId != null)
                {
                    properties.Dictionary[XsrfKey] = UserId;
                }
                context.HttpContext.GetOwinContext().Authentication.Challenge(properties, LoginProvider);
            }
        }
        #endregion

        public class MessageDetails {

            public string Status { get; set; }
            public string RedirectUrl { get; set; }

            public string Message { get; set; }
        }

        public ActionResult PrivacyPolicy()

        {
            return View();
        }
        public ActionResult Terms()

        {
            return View();
        }
    }
}