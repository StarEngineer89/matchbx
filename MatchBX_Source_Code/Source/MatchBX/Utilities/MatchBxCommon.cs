using System;
using System.Net.Mail;
using System.Configuration;
using System.Net;
using System.IO;
using Business;
using Model;
using System.Globalization;
using System.Data;
using System.Web.Mvc;
using MatchBx.Utilities;
using System.Text;
using System.Security.Cryptography;
using System.Web;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;

namespace MatchBx.Utilities
{
    public class MatchBxCommon
    {
        public static void sendForgetPasswordEmail(Users objUserInfo, bool isInternal)
        {
            try
            {
                string startupPath = AppDomain.CurrentDomain.BaseDirectory;
                string targetPath = startupPath + "Template\\Email\\";

                string strMailTemplate = (ConfigurationManager.AppSettings["ForgetMailTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["ForgetMailTemplate"].ToString());
                if (strMailTemplate != "")
                {
                    string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
                    //string siteurl = GetPasswordRestUrl() + "?email=" + objUserInfo.Email;
                    string siteurl = GetPasswordRestUrl() + "?email=" + HttpUtility.UrlEncode(Encrypt(objUserInfo.Email));
                    MailMessage mailMessage = new MailMessage(ConfigurationManager.AppSettings["FromEmail"].ToString(), isInternal ? ConfigurationManager.AppSettings["ContactUsToEmail"].ToString() : objUserInfo.Email);
                    SmtpClient smtpClient = new SmtpClient();
                    mailMessage.Subject = "You’ve requested to reset your password";
                    mailMessage.IsBodyHtml = true;
                    if (File.Exists((strMailTemplate)))
                    {
                        string str = "";
                        StreamReader reader = new StreamReader((strMailTemplate));
                        if(objUserInfo.FullName == null || objUserInfo.FullName == "")
                        {
                            str = reader.ReadToEnd().Replace("#userFullName#", objUserInfo.UserName).Replace("#username#", objUserInfo.UserName).Replace("#password#", objUserInfo.Password).Replace("#SiteURL#", siteurl).Replace("[SiteURL]", siteurl).Replace("#imgURL#", imgUrl);
                        }
                        else
                        {  str = reader.ReadToEnd().Replace("#userFullName#", objUserInfo.FullName).Replace("#username#", objUserInfo.UserName).Replace("#password#", objUserInfo.Password).Replace("#SiteURL#", siteurl).Replace("[SiteURL]", siteurl).Replace("#imgURL#", imgUrl); }
                        
                        if (isInternal)
                        {
                            mailMessage.CC.Add(ConfigurationManager.AppSettings["Mailcc"].ToString());
                        }
                        mailMessage.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());
                        mailMessage.Body = str;
                        smtpClient.Send(mailMessage);
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        private static string Encrypt(string stringToEncrypt)
        {
            byte[] inputByteArray = Encoding.UTF8.GetBytes(stringToEncrypt);
            byte[] rgbIV = { 0x21, 0x43, 0x56, 0x87, 0x10, 0xfd, 0xea, 0x1c };
            byte[] key = { };
            try
            {
                key = System.Text.Encoding.UTF8.GetBytes("A0D1nX0Q");
                DESCryptoServiceProvider des = new DESCryptoServiceProvider();
                MemoryStream ms = new MemoryStream();
                CryptoStream cs = new CryptoStream(ms, des.CreateEncryptor(key, rgbIV), CryptoStreamMode.Write);
                cs.Write(inputByteArray, 0, inputByteArray.Length);
                cs.FlushFinalBlock();
                return Convert.ToBase64String(ms.ToArray());
            }
            catch (Exception e)
            {
                return e.Message;
            }
        }

        public static string Decrypt(string EncryptedText)
        {
            byte[] inputByteArray = new byte[EncryptedText.Length + 1];
            byte[] rgbIV = { 0x21, 0x43, 0x56, 0x87, 0x10, 0xfd, 0xea, 0x1c };
            byte[] key = { };

            try
            {
                key = System.Text.Encoding.UTF8.GetBytes("A0D1nX0Q");
                DESCryptoServiceProvider des = new DESCryptoServiceProvider();
                inputByteArray = Convert.FromBase64String(EncryptedText);
                MemoryStream ms = new MemoryStream();
                CryptoStream cs = new CryptoStream(ms, des.CreateDecryptor(key, rgbIV), CryptoStreamMode.Write);
                cs.Write(inputByteArray, 0, inputByteArray.Length);
                cs.FlushFinalBlock();
                System.Text.Encoding encoding = System.Text.Encoding.UTF8;
                return encoding.GetString(ms.ToArray());
            }
            catch (Exception e)
            {
                return e.Message;
            }
        }


        public static void sendResetPasswordAckEmail(Users objUserInfo, bool isInternal)
        {
            try
            {
                string startupPath = AppDomain.CurrentDomain.BaseDirectory;
                string targetPath = startupPath + "Template\\Email\\";

                string strMailTemplate = (ConfigurationManager.AppSettings["ResetMailTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["ResetMailTemplate"].ToString());
                if (strMailTemplate != "")
                {
                    //TimeZoneInfo infotime = TimeZoneInfo.FindSystemTimeZoneById("Eastern Standard Time (US)");
                    //DateTime thisDate = TimeZoneInfo.ConvertTimeFromUtc(DateTime.Now, infotime);
                    string dateandtime = DateTime.UtcNow.ToString();
                        string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
                    string siteurl = GetPasswordRestUrl() + "?email=" + objUserInfo.Email;
                    MailMessage mailMessage = new MailMessage(ConfigurationManager.AppSettings["FromEmail"].ToString(), isInternal ? ConfigurationManager.AppSettings["ContactUsToEmail"].ToString() : objUserInfo.Email);
                    SmtpClient smtpClient = new SmtpClient();
                    mailMessage.Subject = "Updated MatchBX password confirmation";
                    mailMessage.IsBodyHtml = true;
                    string TimeZone = ConfigurationManager.AppSettings["TimeZone"].ToString();
                    if (File.Exists((strMailTemplate)))
                    {
                        
                        string str = "";
                        StreamReader reader = new StreamReader((strMailTemplate));
                        if (objUserInfo.FullName == null || objUserInfo.FullName == "")
                        {
                            str = reader.ReadToEnd().Replace("#userFullName#", objUserInfo.UserName).Replace("#username#", objUserInfo.UserName).Replace("#password#", objUserInfo.Password).Replace("#SiteURL#", siteurl).Replace("[SiteURL]", siteurl).Replace("#imgURL#", imgUrl).Replace("#time#", DateTime.Now.ToString("hh:mm tt", CultureInfo.GetCultureInfo("en-US"))).Replace("#Timezone#", TimeZone).Replace("#date#", String.Format("{0:MM MMM, yyyy}",DateTime.Now));
                        }
                        else
                        {
                            str = reader.ReadToEnd().Replace("#userFullName#", objUserInfo.FullName).Replace("#username#", objUserInfo.UserName).Replace("#password#", objUserInfo.Password).Replace("#SiteURL#", siteurl).Replace("[SiteURL]", siteurl).Replace("#imgURL#", imgUrl).Replace("#time#", DateTime.Now.ToString("hh:mm tt", CultureInfo.GetCultureInfo("en-US"))).Replace("#Timezone#", TimeZone).Replace("#date#", String.Format("{0:MM MMM, yyyy}",DateTime.Now));
                        }
                            
                        if (isInternal)
                        {
                            mailMessage.CC.Add(ConfigurationManager.AppSettings["Mailcc"].ToString());
                        }
                        mailMessage.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());
                        mailMessage.Body = str;
                        smtpClient.Send(mailMessage);
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }
        }
        private static string GetPasswordRestUrl()
        {
            string url = ConfigurationManager.AppSettings["PassworsResetURL"].ToString();
            if (url.EndsWith("/"))
            {
                url = url.Substring(0, url.Length - 1);
            }

            return url;
        }

        private static string GetEmailVerificationUrl()
        {
            string url = ConfigurationManager.AppSettings["VerificationURL"].ToString();
            if (url.EndsWith("/"))
            {
                url = url.Substring(0, url.Length - 1);
            }

            return url;
        }
        private static string GetSiteUrl()
        {
            string url = ConfigurationManager.AppSettings["SiteURL"].ToString();
            if (url.EndsWith("/"))
            {
                url = url.Substring(0, url.Length - 1);
            }

            return url;
        }

        public static decimal GetExchangeRate()
        {
            decimal exchangerate;
            using (var client = new WebClient())
            {
                try
                {
                    client.Headers.Add("content-type", "application/json");//
                    string response = client.DownloadString("https://api.coinmarketcap.com/v2/ticker/2466/?convert=USD");

                    dynamic dynamicObject = JsonConvert.DeserializeObject(response);
                    exchangerate = Convert.ToDecimal(dynamicObject.data.quotes.USD.price);
                    return exchangerate;
                }
                catch (Exception e)
                {
                    return 0.001m;
                }
             
            }
        }
        public static List<Job> GenerateBadge(List<Job> job)
        {
            decimal exchangerate = GetExchangeRate();
            HttpContext.Current.Session["Exchange"] = exchangerate;
            job.ToList().ForEach(s => s.DollarCount = Math.Round((s.BudgetASP * exchangerate),2));
            job.ToList().ForEach(s => s.BudgetASP = Decimal.Parse((s.BudgetASP).ToString("0.00")));
            job.Where(s => s.DollarCount < 50).ToList().ForEach(s => s.BadgeCount = 1);
            job.Where(s => s.DollarCount >= 50 && s.DollarCount < 150).ToList().ForEach(s => s.BadgeCount = 2);
            job.Where(s => s.DollarCount > 150).ToList().ForEach(s => s.BadgeCount = 3);
            return job;
        }
        public static List<Gig> GenerateBadgeForGig(List<Gig> gig)
        {
            decimal exchangerate = GetExchangeRate();
            HttpContext.Current.Session["Exchange"] = exchangerate;
            gig.ToList().ForEach(s => s.DollarCount = Math.Round((s.BudgetASP * exchangerate), 2));
            gig.ToList().ForEach(s => s.BudgetASP = Decimal.Parse((s.BudgetASP).ToString("0.00")));
            gig.Where(s => s.DollarCount < 50).ToList().ForEach(s => s.BadgeCount = 1);
            gig.Where(s => s.DollarCount >= 50 && s.DollarCount < 150).ToList().ForEach(s => s.BadgeCount = 2);
            gig.Where(s => s.DollarCount > 150).ToList().ForEach(s => s.BadgeCount = 3);
            return gig;
        }
        public static List<Job> GenerateBadgeFromSession(List<Job> job)
        {
            decimal exchangerate = 0.001M;
            if (HttpContext.Current.Session["Exchange"] != null)
             exchangerate =Convert.ToDecimal( HttpContext.Current.Session["Exchange"].ToString());

            job.ToList().ForEach(s => s.DollarCount = Math.Round((s.BudgetASP * exchangerate), 2));
            job.ToList().ForEach(s => s.BudgetASP = Decimal.Parse((s.BudgetASP).ToString("0.00")));
            job.Where(s => s.DollarCount < 50).ToList().ForEach(s => s.BadgeCount = 1);
            job.Where(s => s.DollarCount >= 50 && s.DollarCount < 150).ToList().ForEach(s => s.BadgeCount = 2);
            job.Where(s => s.DollarCount > 150).ToList().ForEach(s => s.BadgeCount = 3);
            return job;
        }
        public static List<TrendingTags> GetTrendingTagsFooter(string from = "")
        {
            TrendingTags objTrending = new TrendingTags();
            objTrending.FromPage = from;
            TrendingTagsModel objTrendingMod = new TrendingTagsModel();
            List<TrendingTags> objTrendingTagsList = new List<TrendingTags>();
            List<TrendingTags> objTrendingTags = new List<TrendingTags>();
            objTrendingTagsList = objTrendingMod.GetTrendingTags(objTrending);
            if(objTrendingTagsList.Count()>8)
            {
                objTrendingTags = objTrendingTagsList.Take(8).ToList();
            }
            else
            {
                objTrendingTags = objTrendingTagsList;
            }
            return objTrendingTags;
        }
        public static void sendMarkasCompleteEmail(string email,bool isInternal, string postername,string seekername, string jobtitle)
        {
            try
            {
                string startupPath = AppDomain.CurrentDomain.BaseDirectory;
                string targetPath = startupPath + "Template\\Email\\";
                string siteurl = ConfigurationManager.AppSettings["SiteURL"].ToString() + "?redirecturl="+ "Y";
                string strMailTemplate = (ConfigurationManager.AppSettings["MarkAsComplete"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["MarkAsComplete"].ToString());
                if (strMailTemplate != "")
                {
                    string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
                    MailMessage mailMessage = new MailMessage(ConfigurationManager.AppSettings["FromEmail"].ToString(), isInternal ? ConfigurationManager.AppSettings["ContactUsToEmail"].ToString() : email);
                    SmtpClient smtpClient = new SmtpClient();
                   mailMessage.Subject = seekername + " has finished your job: " + (jobtitle);
                    mailMessage.IsBodyHtml = true;
                    if (File.Exists((strMailTemplate)))
                    {
                        StreamReader reader = new StreamReader((strMailTemplate));
                        string str = "";
                        str = reader.ReadToEnd().Replace("[username]", seekername).Replace("[jobtitle]", jobtitle).Replace("[SiteURL]", siteurl).Replace("[postername]", postername).Replace("[imgUrl]",imgUrl);
                        if (isInternal)
                        {
                           // str = reader.ReadToEnd().Replace("[username]", username).Replace("[jobtitle]", jobtitle).Replace("[SiteURL]", siteurl);
                            mailMessage.CC.Add(ConfigurationManager.AppSettings["Mailcc"].ToString());
                        }
                        mailMessage.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());
                        mailMessage.Body = str;
                        smtpClient.Send(mailMessage);
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        public static void sendBidOfferEmail(string email, bool isInternal,string username,string jobtitle,decimal bidamount,string fullname )
        {
            try
            {
                string siteurl = ConfigurationManager.AppSettings["SiteURL"].ToString() + "?redirecturl=" + "Y"; 
                string startupPath = AppDomain.CurrentDomain.BaseDirectory;
                string targetPath = startupPath + "Template\\Email\\";
                decimal exchangerate = GetExchangeRate();
                decimal amountinUSD = Math.Round((bidamount * exchangerate), 2);
                string strMailTemplate = (ConfigurationManager.AppSettings["BidOfferMailTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["BidOfferMailTemplate"].ToString());
                if (strMailTemplate != "")
                {
                    string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
                    MailMessage mailMessage = new MailMessage(ConfigurationManager.AppSettings["FromEmail"].ToString(), isInternal ? ConfigurationManager.AppSettings["ContactUsToEmail"].ToString() : email);
                    SmtpClient smtpClient = new SmtpClient();
                    //mailMessage.Subject = ConfigurationManager.AppSettings["ContactEmailSubject"].ToString();
                    mailMessage.Subject = username + " has bid for your job: " + jobtitle;
                     mailMessage.IsBodyHtml = true;
                    if (File.Exists((strMailTemplate)))
                    {
                        StreamReader reader = new StreamReader((strMailTemplate));
                        string str = "";
                        str = reader.ReadToEnd().Replace("[username]", username).Replace("[jobtitle]", jobtitle).Replace("[bidamount]", bidamount.ToString()).Replace("[bidamtinusd]", amountinUSD.ToString()).Replace("[SiteURL]", siteurl).Replace("[fullname]",fullname).Replace("#imgURL#", imgUrl);
                        if (isInternal)
                        {
                            
                            mailMessage.CC.Add(ConfigurationManager.AppSettings["Mailcc"].ToString());
                        }
                        mailMessage.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());
                        mailMessage.Body = str;
                        smtpClient.Send(mailMessage);
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }
        }


        public static void sendBidAcceptanceEmail(string fullname, string username, string JobTitle, int JobId, string email,decimal BidAmount, bool isInternal)
        {
            try
            {
                decimal exchangerate = GetExchangeRate();
                decimal amountinUSD = Math.Round((BidAmount * exchangerate), 2);
                string startupPath = AppDomain.CurrentDomain.BaseDirectory;
                string targetPath = startupPath + "Template\\Email\\";
                string strMailTemplate = (ConfigurationManager.AppSettings["BidAcceptanceMailTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["BidAcceptanceMailTemplate"].ToString());
                if (strMailTemplate != "")
                {
                    string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
                    string siteurl = ConfigurationManager.AppSettings["SiteURL"].ToString() + "?redirecturl=" + "Y";
                    MailMessage mailMessage = new MailMessage(ConfigurationManager.AppSettings["FromEmail"].ToString(), isInternal ? ConfigurationManager.AppSettings["ContactUsToEmail"].ToString() : email);
                    SmtpClient smtpClient = new SmtpClient();
                    mailMessage.Subject = username + " has accepted your bid for job: " + JobTitle;
                    mailMessage.IsBodyHtml = true;
                    if (File.Exists((strMailTemplate)))
                    {
                        StreamReader reader = new StreamReader((strMailTemplate));
                        string str = "";
                        str = reader.ReadToEnd().Replace("[FullName]", fullname).Replace("[Username]", username).Replace("[Job Title]", JobTitle).Replace("[BidAmountAXPR1]", BidAmount.ToString("G29")).Replace("[BidAmountinUSD]", amountinUSD.ToString()).Replace("[SiteURL]",siteurl).Replace("[imgUrl]",imgUrl);
                        if (isInternal)
                        {
                            mailMessage.CC.Add(ConfigurationManager.AppSettings["Mailcc"].ToString());
                        }
                        mailMessage.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());
                        mailMessage.Body = str;
                        smtpClient.Send(mailMessage);
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        public static void sendBidDeclineEmail(string fullname, string username, string JobTitle, int JobId, string email, decimal BidAmount, bool isInternal)
        {
            try
            {
                decimal exchangerate = GetExchangeRate();
                decimal amountinUSD = Math.Round((BidAmount * exchangerate), 2);
                string startupPath = AppDomain.CurrentDomain.BaseDirectory;
                string targetPath = startupPath + "Template\\Email\\";
                string strMailTemplate = (ConfigurationManager.AppSettings["BidDeclineMailTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["BidDeclineMailTemplate"].ToString());
                if (strMailTemplate != "")
                {
                    string siteurl = ConfigurationManager.AppSettings["SiteURL"].ToString() + "?redirecturl=" + "Y"; ;
                    string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
                    MailMessage mailMessage = new MailMessage(ConfigurationManager.AppSettings["FromEmail"].ToString(), isInternal ? ConfigurationManager.AppSettings["ContactUsToEmail"].ToString() : email);
                    SmtpClient smtpClient = new SmtpClient();
                    mailMessage.Subject = "Your job offer on MatchBX has been declined";
                    mailMessage.IsBodyHtml = true;
                    if (File.Exists((strMailTemplate)))
                    {
                        StreamReader reader = new StreamReader((strMailTemplate));
                        string str = "";
                        str = reader.ReadToEnd().Replace("[FullName]", fullname).Replace("[Username]", username).Replace("[Job Title]", JobTitle).Replace("[BidAmountAXPR1]", BidAmount.ToString("G29")).Replace("[BidAmountinUSD]", amountinUSD.ToString()).Replace("[SiteURL]", siteurl).Replace("[imgUrl]", imgUrl);
                        if (isInternal)
                        {
                            mailMessage.CC.Add(ConfigurationManager.AppSettings["Mailcc"].ToString());
                        }
                        mailMessage.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());
                        mailMessage.Body = str;
                        smtpClient.Send(mailMessage);
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }
        }


        public static void sendGigDeclineEmail(string seekerfullname, string posterusername, string GigTitle, string seekeremail, bool isInternal)
        { 
            try
            {                
                string startupPath = AppDomain.CurrentDomain.BaseDirectory;
                string targetPath = startupPath + "Template\\Email\\";
                string strMailTemplate = (ConfigurationManager.AppSettings["GigDeclineOfferMailTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["GigDeclineOfferMailTemplate"].ToString());
                if (strMailTemplate != "")
                {
                    string siteurl = ConfigurationManager.AppSettings["SiteURL"].ToString() + "?redirecturl=" + "Y"; ;
                    string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
                    MailMessage mailMessage = new MailMessage(ConfigurationManager.AppSettings["FromEmail"].ToString(), isInternal ? ConfigurationManager.AppSettings["ContactUsToEmail"].ToString() : seekeremail);
                    SmtpClient smtpClient = new SmtpClient();
                    mailMessage.Subject = "Your service payment request on MatchBX has been declined";
                    mailMessage.IsBodyHtml = true;
                    if (File.Exists((strMailTemplate)))
                    {
                        StreamReader reader = new StreamReader((strMailTemplate));
                        string str = "";
                        str = reader.ReadToEnd().Replace("[FullName]", seekerfullname).Replace("[Job Title]", GigTitle).Replace("[SiteURL]",siteurl).Replace("[imgUrl]",imgUrl);
                        if (isInternal)
                        {
                            mailMessage.CC.Add(ConfigurationManager.AppSettings["Mailcc"].ToString());
                        }
                        mailMessage.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());
                        mailMessage.Body = str;
                        smtpClient.Send(mailMessage);
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<UserEmailPreferenceMapping> EmailPreferences(int userId)
        {
            List<UserEmailPreferenceMapping> emailPref = new List<UserEmailPreferenceMapping>();
            emailPref = new UserEmailPreferenceMappingModel().GetUserEmailPreference(userId);

            return emailPref;
        }
        public static bool checkuseremailpreferences(string preferences,int userid)
        {
            UserEmailPreferenceMapping objemailPref = new UserEmailPreferenceMapping();
            //List<UserEmailPreferenceMapping> objemailPrefList = new List<UserEmailPreferenceMapping>();
            UserEmailPreferenceMappingModel objemailMod = new UserEmailPreferenceMappingModel();
            //objemailPrefList = objemailMod.GetList("*", "UserId=" + userid + " and EmailPreferenceId in (" + preferences + ") and CheckStatus=1");
            objemailPref.UserId = userid;
            objemailPref.EmailPreferenceIdList = preferences;
            bool status = objemailMod.GetEmailNotifications(objemailPref);
            if (status == true)
            {
                return true;
            }
            else
            {
                return false;
            }

        }
        public static void verificationmail(string fullname,string verificationcode, string email, bool isInternal)
        {
            try
            {
                string startupPath = AppDomain.CurrentDomain.BaseDirectory;
                string targetPath = startupPath + "Template\\Email\\";
                string strMailTemplate = (ConfigurationManager.AppSettings["VerificationMailTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["VerificationMailTemplate"].ToString());
                if (strMailTemplate != "")
                {
                    string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
                    string verificationurl = GetEmailVerificationUrl() + "?email=" + email+ "&code="+verificationcode;
                    MailMessage mailMessage = new MailMessage(ConfigurationManager.AppSettings["FromEmail"].ToString(), isInternal ? ConfigurationManager.AppSettings["ContactUsToEmail"].ToString() : email);
                    SmtpClient smtpClient = new SmtpClient();
                    mailMessage.Subject = ConfigurationManager.AppSettings["VerificationMailSubject"].ToString();
                    mailMessage.IsBodyHtml = true;
                    if (File.Exists((strMailTemplate)))
                    {
                        StreamReader reader = new StreamReader((strMailTemplate));
                        string str = "";
                        str = reader.ReadToEnd().Replace("[FullName]", fullname).Replace("[Logo]", imgUrl).Replace("[verificationurl]", verificationurl);
                        if (isInternal)
                        {
                            mailMessage.CC.Add(ConfigurationManager.AppSettings["Mailcc"].ToString());
                        }
                        mailMessage.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());
                        mailMessage.Body = str;
                        smtpClient.Send(mailMessage);
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }
        }


        public static void CancelJobEmail(string jobtitle, string FullName, string email, bool isInternal)
        {
            try
            {
                string startupPath = AppDomain.CurrentDomain.BaseDirectory;
                string targetPath = startupPath + "Template\\Email\\";
                string siteurl = ConfigurationManager.AppSettings["SiteURL"].ToString() + "?redirecturl=" + "Y"; ;
                string strMailTemplate = (ConfigurationManager.AppSettings["JobCancel"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["JobCancel"].ToString());
                if (strMailTemplate != "")
                {
                    string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
                    MailMessage mailMessage = new MailMessage(ConfigurationManager.AppSettings["FromEmail"].ToString(), isInternal ? ConfigurationManager.AppSettings["ContactUsToEmail"].ToString() : email);
                    SmtpClient smtpClient = new SmtpClient();
                    mailMessage.Subject = " Your job has been cancelled ";
                    mailMessage.IsBodyHtml = true;
                    if (File.Exists((strMailTemplate)))
                    {
                        StreamReader reader = new StreamReader((strMailTemplate));
                        string str = "";
                        str = reader.ReadToEnd().Replace("[FIRSTNAME]", FullName).Replace("[JOBNAME]", jobtitle).Replace("[SiteURL]", siteurl).Replace("[imgURL]",imgUrl);
                        if (isInternal)
                        {
                            mailMessage.CC.Add(ConfigurationManager.AppSettings["Mailcc"].ToString());
                        }
                        mailMessage.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());
                        mailMessage.Body = str;
                        smtpClient.Send(mailMessage);
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }
        }


        public static void OfflineMessageMail(int _senderId, int _receiverId,int _MatchBXMessageId)
        {
            try
            {
                string startupPath = AppDomain.CurrentDomain.BaseDirectory;
                string strMailTemplate = startupPath + "Template\\Email\\OfflineMessage.html";
                string siteurl = ConfigurationManager.AppSettings["SiteURL"].ToString()+@"\login?mailMessagId="+ _senderId;
              //  string strMailTemplate = (ConfigurationManager.AppSettings["JobCancel"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["JobCancel"].ToString());
                if (strMailTemplate != "")
                {
                    string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
                    UsersModel _objModel = new UsersModel();
                    Users _objReceiver = _objModel.GetList("*", " UserId=" + _receiverId).FirstOrDefault();
                    Users _objSender= _objModel.GetList("*", " UserId=" + _senderId).FirstOrDefault();

                    MailMessage mailMessage = new MailMessage(ConfigurationManager.AppSettings["FromEmail"].ToString(),_objReceiver.Email );
                    SmtpClient smtpClient = new SmtpClient();
                    mailMessage.Subject = "You have a message from "+ _objSender.FullName;
                    mailMessage.IsBodyHtml = true;
                    if (File.Exists((strMailTemplate)))
                    {
                        
                        StreamReader reader = new StreamReader((strMailTemplate));
                        string str = "";
                        str = reader.ReadToEnd().Replace("#username#", _objReceiver.FullName).Replace("#sender#", _objSender.FullName).Replace("[SiteURL]", siteurl).Replace("#imgURL#", imgUrl);
                        mailMessage.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());
                        mailMessage.Body = str;
                        smtpClient.Send(mailMessage);

                        MatchBXMessageModel _objMessageModel = new MatchBXMessageModel();
                        MatchBXMessage _objMessage = new MatchBXMessage();
                        _objMessage.MatchBXMessageId = _MatchBXMessageId;
                        _objMessage.IsMailSent = 1;
                        _objMessage.ReadStatus = 0;
                        _objMessageModel.Save(_objMessage);

                    }
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        public static void sendJobPostedEmailToAdmin(int type, string jobtitle, int jobId)
        {
            try
            {
                string siteurl = ConfigurationManager.AppSettings["adminJobsUrl"].ToString();
                string startupPath = AppDomain.CurrentDomain.BaseDirectory;
                string targetPath = startupPath + "Template\\Email\\";
                string strMailTemplate = type == 1 ? ((ConfigurationManager.AppSettings["AdminNewJobTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["AdminNewJobTemplate"].ToString())) : ((ConfigurationManager.AppSettings["AdminEditJobTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["AdminEditJobTemplate"].ToString()));
                string jobUrl = ConfigurationManager.AppSettings["adminJobsUrl"].ToString() + jobId;
                var admins = new UsersModel().GetList("*", "UserType = 4 AND IsActive = 1");
                var emails = string.Join(",", from item in admins select item.Email);
                if (strMailTemplate != "")
                {
                    string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
                    MailMessage mailMessage = new MailMessage(ConfigurationManager.AppSettings["FromEmail"].ToString(), emails);
                    SmtpClient smtpClient = new SmtpClient();
                    //mailMessage.Subject = ConfigurationManager.AppSettings["ContactEmailSubject"].ToString();
                    mailMessage.Subject = type == 1 ? "New job posted" : "Job updated";
                    mailMessage.IsBodyHtml = true;
                    if (File.Exists((strMailTemplate)))
                    {
                        StreamReader reader = new StreamReader((strMailTemplate));
                        string str = "";
                        str = reader.ReadToEnd().Replace("[TITLE]", jobtitle).Replace("[jobtitle]", jobtitle).Replace("[JobURL]", jobUrl).Replace("[imgUrl]", imgUrl);
                        //if (isInternal)
                        //{

                        //    mailMessage.CC.Add(ConfigurationManager.AppSettings["Mailcc"].ToString());
                        //}
                        //mailMessage.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());
                        mailMessage.Body = str;
                        smtpClient.Send(mailMessage);
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        public static void sendJobApproveRejectEmailToUser(int type, string jobtitle, string jobDate, string userEmail)
        {
            try
            {
                string siteurl = ConfigurationManager.AppSettings["adminJobsUrl"].ToString();
                string startupPath = AppDomain.CurrentDomain.BaseDirectory;
                string targetPath = startupPath + "Template\\Email\\";
                string strMailTemplate = type == 1 ? ((ConfigurationManager.AppSettings["UserJobApproveTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["UserJobApproveTemplate"].ToString())) : ((ConfigurationManager.AppSettings["UserJobRejectTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["UserJobRejectTemplate"].ToString()));
                string jobUrl = ConfigurationManager.AppSettings["SiteURL"].ToString();
                if (strMailTemplate != "")
                {
                    string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
                    MailMessage mailMessage = new MailMessage(ConfigurationManager.AppSettings["FromEmail"].ToString(), userEmail);
                    SmtpClient smtpClient = new SmtpClient();
                    //mailMessage.Subject = ConfigurationManager.AppSettings["ContactEmailSubject"].ToString();
                    mailMessage.Subject = type == 1 ? "Job approved" : "Job declined";
                    mailMessage.IsBodyHtml = true;
                    if (File.Exists((strMailTemplate)))
                    {
                        StreamReader reader = new StreamReader((strMailTemplate));
                        string str = "";
                        str = reader.ReadToEnd().Replace("[TITLE]", jobtitle).Replace("[DATE]", jobDate).Replace("[URL]", jobUrl).Replace("[imgUrl]", imgUrl);
                        //if (isInternal)
                        //{

                        //    mailMessage.CC.Add(ConfigurationManager.AppSettings["Mailcc"].ToString());
                        //}
                        //mailMessage.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());
                        mailMessage.Body = str;
                        smtpClient.Send(mailMessage);
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }
        }
        public static int  sendPendingApprovalEmailToAdmin(int type, string jobtitle, int jobId,string emails,string date)
        {
            try
            {
                string siteurl = ConfigurationManager.AppSettings["adminJobsUrl"].ToString();
                string startupPath = AppDomain.CurrentDomain.BaseDirectory;
                string targetPath = startupPath + "Template\\Email\\";
                string strMailTemplate = type == 1 ? ((ConfigurationManager.AppSettings["AdminReminderJobTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["AdminReminderJobTemplate"].ToString())) : ((ConfigurationManager.AppSettings["AdminReminderJobTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["AdminReminderJobTemplate"].ToString()));
                string jobUrl = ConfigurationManager.AppSettings["adminJobsUrl"].ToString() + jobId;
                if (strMailTemplate != "")
                {
                    string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
                    MailMessage mailMessage = new MailMessage(ConfigurationManager.AppSettings["FromEmail"].ToString(), emails);
                    SmtpClient smtpClient = new SmtpClient();
                    //mailMessage.Subject = ConfigurationManager.AppSettings["ContactEmailSubject"].ToString();
                    mailMessage.Subject = type == 1 ? "New job posted" : "Job updated";
                    mailMessage.IsBodyHtml = true;
                    if (File.Exists((strMailTemplate)))
                    {
                        StreamReader reader = new StreamReader((strMailTemplate));
                        string str = "";
                        str = reader.ReadToEnd().Replace("[TITLE]", jobtitle).Replace("[jobtitle]", jobtitle).Replace("[JobURL]", jobUrl).Replace("[imgUrl]", imgUrl).Replace("[DATE]",date);
                        mailMessage.Body = str;
                        smtpClient.Send(mailMessage);
                        return 1;
                    }
                    else
                    {
                        return 0;
                    }
                }
                else {
                    return 0;
                }
            }
            catch (Exception)
            {
                return 0;
                throw;
            }
        }

        public static int SendResetWalletEmail(string fullname, string email, bool isInternal)
        {
            try
            {
                if (!String.IsNullOrEmpty(fullname) && !String.IsNullOrEmpty(email))
                {
                    string startupPath = AppDomain.CurrentDomain.BaseDirectory;
                    string targetPath = startupPath + "Template\\Email\\";
                    string strMailTemplate = (ConfigurationManager.AppSettings["ResetWalletEmailTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["ResetWalletEmailTemplate"].ToString());
                    if (strMailTemplate != "")
                    {
                        string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
                        MailMessage mailMessage = new MailMessage(ConfigurationManager.AppSettings["FromEmail"].ToString(), isInternal ? ConfigurationManager.AppSettings["ContactUsToEmail"].ToString() : email);
                        SmtpClient smtpClient = new SmtpClient();
                        mailMessage.Subject = "MatchBX wallet request";
                        mailMessage.IsBodyHtml = true;
                        if (System.IO.File.Exists((strMailTemplate)))
                        {
                            StreamReader reader = new StreamReader((strMailTemplate));
                            string str = "";
                            str = reader.ReadToEnd().Replace("[FullName]", fullname).Replace("[imgUrl]", imgUrl);
                            if (isInternal)
                            {
                                mailMessage.CC.Add(ConfigurationManager.AppSettings["Mailcc"].ToString());
                            }
                            mailMessage.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());
                            mailMessage.Body = str;
                            smtpClient.Send(mailMessage);
                        }
                    }
                    return 1;
                }
                else
                {
                    return 0;
                }
            }
            catch (Exception)
            {
                //throw;
                return 0;
            }
        }

        public static void sendGigPostedEmailToAdmin(int type, string gigtitle, int gigId)
        {
            try
            {
                string siteurl = ConfigurationManager.AppSettings["adminGigsUrl"].ToString();
                string startupPath = AppDomain.CurrentDomain.BaseDirectory;
                string targetPath = startupPath + "Template\\Email\\";
                string strMailTemplate = type == 1 ? ((ConfigurationManager.AppSettings["AdminNewGigTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["AdminNewGigTemplate"].ToString())) : ((ConfigurationManager.AppSettings["AdminEditGigTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["AdminEditGigTemplate"].ToString()));
                string jobUrl = ConfigurationManager.AppSettings["adminGigsUrl"].ToString() + gigId;
                var admins = new UsersModel().GetList("*", "UserType = 4 AND IsActive = 1");
                var emails = string.Join(",", from item in admins select item.Email);
                if (strMailTemplate != "")
                {
                    string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
                    MailMessage mailMessage = new MailMessage(ConfigurationManager.AppSettings["FromEmail"].ToString(), emails);
                    SmtpClient smtpClient = new SmtpClient();
                    //mailMessage.Subject = ConfigurationManager.AppSettings["ContactEmailSubject"].ToString();
                    mailMessage.Subject = type == 1 ? "New service posted" : "Service updated";
                    mailMessage.IsBodyHtml = true;
                    if (File.Exists((strMailTemplate)))
                    {
                        StreamReader reader = new StreamReader((strMailTemplate));
                        string str = "";
                        str = reader.ReadToEnd().Replace("[TITLE]", gigtitle).Replace("[GigURL]", jobUrl).Replace("[imgUrl]", imgUrl);
                        //if (isInternal)
                        //{

                        //    mailMessage.CC.Add(ConfigurationManager.AppSettings["Mailcc"].ToString());
                        //}
                        //mailMessage.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());
                        mailMessage.Body = str;
                        smtpClient.Send(mailMessage);
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }
        }
        public static void sendGigApproveRejectEmailToUser(int type, string gigtitle, string gigDate, string userEmail)
        {
            try
            {
                string siteurl = ConfigurationManager.AppSettings["SiteURL"].ToString() + "?redirecturl=" + "Y";
                string startupPath = AppDomain.CurrentDomain.BaseDirectory;
                string targetPath = startupPath + "Template\\Email\\";
                string strMailTemplate = type == 1 ? ((ConfigurationManager.AppSettings["UserGigApproveTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["UserGigApproveTemplate"].ToString())) : ((ConfigurationManager.AppSettings["UserGigRejectTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["UserGigRejectTemplate"].ToString()));
                string jobUrl = ConfigurationManager.AppSettings["SiteURL"].ToString();
                if (strMailTemplate != "")
                {
                    string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
                    MailMessage mailMessage = new MailMessage(ConfigurationManager.AppSettings["FromEmail"].ToString(), userEmail);
                    SmtpClient smtpClient = new SmtpClient();
                    //mailMessage.Subject = ConfigurationManager.AppSettings["ContactEmailSubject"].ToString();
                    mailMessage.Subject = type == 1 ? "Service approved" : "Service declined";
                    mailMessage.IsBodyHtml = true;
                    if (File.Exists((strMailTemplate)))
                    {
                        StreamReader reader = new StreamReader((strMailTemplate));
                        string str = "";
                        str = reader.ReadToEnd().Replace("[TITLE]", gigtitle).Replace("[DATE]", gigDate).Replace("[URL]", jobUrl).Replace("[imgUrl]", imgUrl);
                        //if (isInternal)
                        //{

                        //    mailMessage.CC.Add(ConfigurationManager.AppSettings["Mailcc"].ToString());
                        //}
                        //mailMessage.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());
                        mailMessage.Body = str;
                        smtpClient.Send(mailMessage);
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        public static void sendGigReviewApproveRejectEmailToUser(int type, string gigtitle, string gigDate, string userEmail)
        {
            try
            {
                string siteurl = ConfigurationManager.AppSettings["SiteURL"].ToString() + "?redirecturl=" + "Y";
                string startupPath = AppDomain.CurrentDomain.BaseDirectory;
                string targetPath = startupPath + "Template\\Email\\";
                string strMailTemplate = type == 1 ? ((ConfigurationManager.AppSettings["UserGigReviewApproveTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["UserGigReviewApproveTemplate"].ToString())) : ((ConfigurationManager.AppSettings["UserGigReviewRejectTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["UserGigReviewRejectTemplate"].ToString()));
                string jobUrl = ConfigurationManager.AppSettings["SiteURL"].ToString();
                if (strMailTemplate != "")
                {
                    string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
                    MailMessage mailMessage = new MailMessage(ConfigurationManager.AppSettings["FromEmail"].ToString(), userEmail);
                    SmtpClient smtpClient = new SmtpClient();
                    //mailMessage.Subject = ConfigurationManager.AppSettings["ContactEmailSubject"].ToString();
                    mailMessage.Subject = type == 1 ? "Service Review approved" : "Service Review declined";
                    mailMessage.IsBodyHtml = true;
                    if (File.Exists((strMailTemplate)))
                    {
                        StreamReader reader = new StreamReader((strMailTemplate));
                        string str = "";
                        str = reader.ReadToEnd().Replace("[TITLE]", gigtitle).Replace("[DATE]", gigDate).Replace("[URL]", jobUrl).Replace("[imgUrl]", imgUrl);
                        //if (isInternal)
                        //{

                        //    mailMessage.CC.Add(ConfigurationManager.AppSettings["Mailcc"].ToString());
                        //}
                        //mailMessage.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());
                        mailMessage.Body = str;
                        smtpClient.Send(mailMessage);
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }
        }
        public static int sendGigPendingApprovalEmailToAdmin(int type, string gigtitle, int gigId, string emails, string date)
        {
            try
            {
                string siteurl = ConfigurationManager.AppSettings["adminGigsUrl"].ToString();
                string startupPath = AppDomain.CurrentDomain.BaseDirectory;
                string targetPath = startupPath + "Template\\Email\\";
                string strMailTemplate = type == 1 ? ((ConfigurationManager.AppSettings["AdminReminderGigTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["AdminReminderGigTemplate"].ToString())) : ((ConfigurationManager.AppSettings["AdminReminderGigTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["AdminReminderGigTemplate"].ToString()));
                string gigUrl = ConfigurationManager.AppSettings["adminJobsUrl"].ToString() + gigId;
                if (strMailTemplate != "")
                {
                    string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
                    MailMessage mailMessage = new MailMessage(ConfigurationManager.AppSettings["FromEmail"].ToString(), emails);
                    SmtpClient smtpClient = new SmtpClient();
                    //mailMessage.Subject = ConfigurationManager.AppSettings["ContactEmailSubject"].ToString();
                    mailMessage.Subject = type == 1 ? "New job posted" : "Job updated";
                    mailMessage.IsBodyHtml = true;
                    if (File.Exists((strMailTemplate)))
                    {
                        StreamReader reader = new StreamReader((strMailTemplate));
                        string str = "";
                        str = reader.ReadToEnd().Replace("[TITLE]", gigtitle).Replace("[GigURL]", gigUrl).Replace("[imgUrl]", imgUrl).Replace("[DATE]", date);
                        mailMessage.Body = str;
                        smtpClient.Send(mailMessage);
                        return 1;
                    }
                    else
                    {
                        return 0;
                    }
                }
                else
                {
                    return 0;
                }
            }
            catch (Exception)
            {
                return 0;
                throw;
            }
        }


        public static void sendGigOfferEmail(string email, bool isInternal, string username, string jobtitle, string fullname)
        {
            try
            {
                string siteurl = ConfigurationManager.AppSettings["SiteURL"].ToString() + "?redirecturl=" + "Y";
                string startupPath = AppDomain.CurrentDomain.BaseDirectory;
                string targetPath = startupPath + "Template\\Email\\";
             
              
                string strMailTemplate = (ConfigurationManager.AppSettings["GigSubcriptionMailTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["GigSubcriptionMailTemplate"].ToString());
                if (strMailTemplate != "")
                {
                    string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
                    MailMessage mailMessage = new MailMessage(ConfigurationManager.AppSettings["FromEmail"].ToString(), isInternal ? ConfigurationManager.AppSettings["ContactUsToEmail"].ToString() : email);
                    SmtpClient smtpClient = new SmtpClient();
                    //mailMessage.Subject = ConfigurationManager.AppSettings["ContactEmailSubject"].ToString();
                    mailMessage.Subject = username + " has purchased  your service: " + jobtitle;
                    mailMessage.IsBodyHtml = true;
                    if (File.Exists((strMailTemplate)))
                    {
                        StreamReader reader = new StreamReader((strMailTemplate));
                        string str = "";
                        str = reader.ReadToEnd().Replace("[username]", username).Replace("[jobtitle]", jobtitle).Replace("[SiteURL]", siteurl).Replace("[fullname]", fullname).Replace("#imgURL#", imgUrl);
                        if (isInternal)
                        {

                            mailMessage.CC.Add(ConfigurationManager.AppSettings["Mailcc"].ToString());
                        }
                        mailMessage.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());
                        mailMessage.Body = str;
                        smtpClient.Send(mailMessage);
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        public static int sendPendingGigApprovalEmailToAdmin(int type, string gigtitle, int gigId, string emails, string date)
        {
            try
            {
                string siteurl = ConfigurationManager.AppSettings["adminJobsUrl"].ToString();
                string startupPath = AppDomain.CurrentDomain.BaseDirectory;
                string targetPath = startupPath + "Template\\Email\\";
                string strMailTemplate = type == 1 ? ((ConfigurationManager.AppSettings["AdminReminderGigTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["AdminReminderGigTemplate"].ToString())) : ((ConfigurationManager.AppSettings["AdminReminderGigTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["AdminReminderGigTemplate"].ToString()));
                string jobUrl = ConfigurationManager.AppSettings["adminGigsUrl"].ToString() + gigId;
                if (strMailTemplate != "")
                {
                    string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
                    MailMessage mailMessage = new MailMessage(ConfigurationManager.AppSettings["FromEmail"].ToString(), emails);
                    SmtpClient smtpClient = new SmtpClient();
                    //mailMessage.Subject = ConfigurationManager.AppSettings["ContactEmailSubject"].ToString();
                    mailMessage.Subject = type == 1 ? "New service posted" : "Service updated";
                    mailMessage.IsBodyHtml = true;
                    if (File.Exists((strMailTemplate)))
                    {
                        StreamReader reader = new StreamReader((strMailTemplate));
                        string str = "";
                        str = reader.ReadToEnd().Replace("[TITLE]", gigtitle).Replace("[jobtitle]", gigtitle).Replace("[GigURL]", jobUrl).Replace("[imgUrl]", imgUrl).Replace("[DATE]", date);
                        mailMessage.Body = str;
                        smtpClient.Send(mailMessage);
                        return 1;
                    }
                    else
                    {
                        return 0;
                    }
                }
                else
                {
                    return 0;
                }
            }
            catch (Exception)
            {
                return 0;
                throw;
            }
        }
        public static void sendGigReviewToAdmin(int type, string gigtitle, int gigReviewId)
        {
            try
            {
                string siteurl = ConfigurationManager.AppSettings["adminGigReviewsUrl"].ToString();
                string startupPath = AppDomain.CurrentDomain.BaseDirectory;
                string targetPath = startupPath + "Template\\Email\\";
                string strMailTemplate = type == 1 ? ((ConfigurationManager.AppSettings["AdminNotificationNewReviewTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["AdminNotificationNewReviewTemplate"].ToString())) : ((ConfigurationManager.AppSettings["AdminNotificationNewReviewTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["AdminNotificationNewReviewTemplate"].ToString()));
                string jobUrl = ConfigurationManager.AppSettings["adminGigReviewsUrl"].ToString() + gigReviewId;
                var admins = new UsersModel().GetList("*", "UserType = 4 AND IsActive = 1");
                var emails = string.Join(",", from item in admins select item.Email);
                if (strMailTemplate != "")
                {
                    string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
                    MailMessage mailMessage = new MailMessage(ConfigurationManager.AppSettings["FromEmail"].ToString(), emails);
                    SmtpClient smtpClient = new SmtpClient();
                    //mailMessage.Subject = ConfigurationManager.AppSettings["ContactEmailSubject"].ToString();
                    mailMessage.Subject = type == 1 ? "New service review posted" : "Service Review updated";
                    mailMessage.IsBodyHtml = true;
                    if (File.Exists((strMailTemplate)))
                    {
                        StreamReader reader = new StreamReader((strMailTemplate));
                        string str = "";
                        str = reader.ReadToEnd().Replace("[TITLE]", gigtitle).Replace("[GigURL]", jobUrl).Replace("[imgUrl]", imgUrl);
                        //if (isInternal)
                        //{

                        //    mailMessage.CC.Add(ConfigurationManager.AppSettings["Mailcc"].ToString());
                        //}
                        //mailMessage.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());
                        mailMessage.Body = str;
                        smtpClient.Send(mailMessage);
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }
        }


    }

}
   