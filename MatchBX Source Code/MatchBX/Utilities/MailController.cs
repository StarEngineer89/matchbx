using MatchBx.Utilities;
using Model;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.Mvc;

namespace MatchBX.Utilities
{
    public class MailController : Controller
    {
        [HttpPost]
        [AllowAnonymous]
        public ActionResult SendBidAcceptEmail(string fullname, string username, string JobTitle, int JobId, string email, decimal BidAmount, bool isInternal)
        {
            try
            {
                if (!String.IsNullOrEmpty(fullname) && !String.IsNullOrEmpty(username) && !String.IsNullOrEmpty(JobTitle) && JobId != 0 && !String.IsNullOrEmpty(email) && BidAmount != 0)
                {
                    //decimal exchangerate = MatchBxCommon.GetExchangeRate();
                    //decimal amountinUSD = Math.Round((BidAmount * exchangerate), 2);
                    string startupPath = AppDomain.CurrentDomain.BaseDirectory;
                    string targetPath = startupPath + "Template\\Email\\";
                    string strMailTemplate = "";
                    var jobObj = new JobModel().GetARecord(JobId);
                    if (jobObj.GigSubscriptionId > 0)
                    {
                        strMailTemplate = (ConfigurationManager.AppSettings["GigAcceptanceMailTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["GigAcceptanceMailTemplate"].ToString());
                        if (strMailTemplate != "")
                        {
                            string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
                            string siteurl = ConfigurationManager.AppSettings["SiteURL"].ToString() + "?redirecturl=" + "Y";
                            MailMessage mailMessage = new MailMessage(ConfigurationManager.AppSettings["FromEmail"].ToString(), isInternal ? ConfigurationManager.AppSettings["ContactUsToEmail"].ToString() : email);
                            SmtpClient smtpClient = new SmtpClient();
                            mailMessage.Subject = username + " has completed the payment for your GIG: " + JobTitle;
                            mailMessage.IsBodyHtml = true;
                            if (System.IO.File.Exists((strMailTemplate)))
                            {
                                StreamReader reader = new StreamReader((strMailTemplate));
                                string str = "";
                                str = reader.ReadToEnd().Replace("[FullName]", fullname).Replace("[Username]", username).Replace("[Gig Title]", JobTitle).Replace("[SiteURL]", siteurl).Replace("[imgUrl]", imgUrl);
                                if (isInternal)
                                {
                                    mailMessage.CC.Add(ConfigurationManager.AppSettings["Mailcc"].ToString());
                                }
                                mailMessage.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());
                                mailMessage.Body = str;
                                smtpClient.Send(mailMessage);
                            }
                        }
                        return Json("Success", JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        strMailTemplate = (ConfigurationManager.AppSettings["BidAcceptanceMailTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["BidAcceptanceMailTemplate"].ToString());
                        if (strMailTemplate != "")
                        {
                            string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
                            string siteurl = ConfigurationManager.AppSettings["SiteURL"].ToString() + "?redirecturl=" + "Y";
                            MailMessage mailMessage = new MailMessage(ConfigurationManager.AppSettings["FromEmail"].ToString(), isInternal ? ConfigurationManager.AppSettings["ContactUsToEmail"].ToString() : email);
                            SmtpClient smtpClient = new SmtpClient();
                            mailMessage.Subject = username + " has accepted your bid for job: " + JobTitle;
                            mailMessage.IsBodyHtml = true;
                            if (System.IO.File.Exists((strMailTemplate)))
                            {
                                StreamReader reader = new StreamReader((strMailTemplate));
                                string str = "";
                                str = reader.ReadToEnd().Replace("[FullName]", fullname).Replace("[Username]", username).Replace("[Job Title]", JobTitle).Replace("[SiteURL]", siteurl).Replace("[imgUrl]", imgUrl);
                                if (isInternal)
                                {
                                    mailMessage.CC.Add(ConfigurationManager.AppSettings["Mailcc"].ToString());
                                }
                                mailMessage.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());
                                mailMessage.Body = str;
                                smtpClient.Send(mailMessage);
                            }
                        }
                        return Json("Success", JsonRequestBehavior.AllowGet);
                    }
                }
                else
                {
                    return Json("Failed. Please submit with all details.", JsonRequestBehavior.AllowGet);
                }              
            }
            catch (Exception)
            {
                //throw;
                return Json("Failed", JsonRequestBehavior.AllowGet);
            }            
        }

        //public ActionResult SendResetWalletEmail(string fullname, string email, bool isInternal)
        //{
        //    try
        //    {
        //        if (!String.IsNullOrEmpty(fullname) && !String.IsNullOrEmpty(email))
        //        {
        //            string startupPath = AppDomain.CurrentDomain.BaseDirectory;
        //            string targetPath = startupPath + "Template\\Email\\";
        //            string strMailTemplate = (ConfigurationManager.AppSettings["ResetWalletEmailTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["ResetWalletEmailTemplate"].ToString());
        //            if (strMailTemplate != "")
        //            {
        //                string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
        //                MailMessage mailMessage = new MailMessage(ConfigurationManager.AppSettings["FromEmail"].ToString(), isInternal ? ConfigurationManager.AppSettings["ContactUsToEmail"].ToString() : email);
        //                SmtpClient smtpClient = new SmtpClient();
        //                mailMessage.Subject = "MatchBX wallet request";
        //                mailMessage.IsBodyHtml = true;
        //                if (System.IO.File.Exists((strMailTemplate)))
        //                {
        //                    StreamReader reader = new StreamReader((strMailTemplate));
        //                    string str = "";
        //                    str = reader.ReadToEnd().Replace("[FullName]", fullname).Replace("[imgUrl]", imgUrl);
        //                    if (isInternal)
        //                    {
        //                        mailMessage.CC.Add(ConfigurationManager.AppSettings["Mailcc"].ToString());
        //                    }
        //                    mailMessage.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());
        //                    mailMessage.Body = str;
        //                    smtpClient.Send(mailMessage);
        //                }
        //            }
        //            return Json("Success", JsonRequestBehavior.AllowGet);
        //        }
        //        else
        //        {
        //            return Json("Failed. Please submit with all details.", JsonRequestBehavior.AllowGet);
        //        }
        //    }
        //    catch (Exception)
        //    {
        //        //throw;
        //        return Json("Failed", JsonRequestBehavior.AllowGet);
        //    }
        //}

        public ActionResult SendResetWalletConfirmationEmail(string fullname, string email, bool isInternal)
        {
            try
            {
                if (!String.IsNullOrEmpty(fullname) && !String.IsNullOrEmpty(email))
                {
                    string startupPath = AppDomain.CurrentDomain.BaseDirectory;
                    string targetPath = startupPath + "Template\\Email\\";
                    string siteurl = ConfigurationManager.AppSettings["SiteURL"].ToString() + "?redirecturl=" + "Y"; ;
                    string strMailTemplate = (ConfigurationManager.AppSettings["ResetWalletEmailConfirmationTemplate"].ToString() == "") ? "" : (targetPath + ConfigurationManager.AppSettings["ResetWalletEmailConfirmationTemplate"].ToString());
                    if (strMailTemplate != "")
                    {
                        string imgUrl = ConfigurationManager.AppSettings["ImgURL"].ToString();
                        MailMessage mailMessage = new MailMessage(ConfigurationManager.AppSettings["FromEmail"].ToString(), isInternal ? ConfigurationManager.AppSettings["ContactUsToEmail"].ToString() : email);
                        SmtpClient smtpClient = new SmtpClient();
                        mailMessage.Subject = "MatchBX wallet reset";
                        mailMessage.IsBodyHtml = true;
                        if (System.IO.File.Exists((strMailTemplate)))
                        {
                            StreamReader reader = new StreamReader((strMailTemplate));
                            string str = "";
                            str = reader.ReadToEnd().Replace("[FullName]", fullname).Replace("[imgUrl]", imgUrl).Replace("[SiteURL]", siteurl);
                            if (isInternal)
                            {
                                mailMessage.CC.Add(ConfigurationManager.AppSettings["Mailcc"].ToString());
                            }
                            mailMessage.Bcc.Add(ConfigurationManager.AppSettings["MailBcc"].ToString());
                            mailMessage.Body = str;
                            smtpClient.Send(mailMessage);
                        }
                    }
                    return Json("Success", JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json("Failed. Please submit with all details.", JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception)
            {
                //throw;
                return Json("Failed", JsonRequestBehavior.AllowGet);
            }
        }
    }
}