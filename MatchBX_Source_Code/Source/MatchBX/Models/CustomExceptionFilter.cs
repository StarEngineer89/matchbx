using Business;
using Model;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MatchBX.Models
{
    public class CustomExceptionFilter: FilterAttribute, IExceptionFilter
    {
        public void OnException(ExceptionContext filterContext)
        {
            string _BaseURL = ConfigurationManager.AppSettings["BaseURL"].ToString();
            string _RedirectURL = _BaseURL + "/Login/ReDoLogin";

            StackTrace trace = new StackTrace(filterContext.Exception, true);
            StackFrame stackFrame = trace.GetFrame(trace.FrameCount - 1);
            //string fileName = stackFrame.GetFileName();
            //string methodName = stackFrame.GetMethod().Name;

            ErrorLog el = new ErrorLog()
            {
                ErrorLogId = 0,
                ErrorDescription = filterContext.Exception.Message,
                ErrorReportedOn = DateTime.Now,
                ErrorStack = filterContext.Exception.StackTrace.Trim(),
                //ErrorSource = filterContext.Exception.Source,
                //ErrorMethod = stackFrame.GetMethod().Name,
                ErrorSource = filterContext.RouteData.Values["controller"].ToString(),
                ErrorMethod = filterContext.RouteData.Values["action"].ToString(),
                UserId = HttpContext.Current.Session != null ? Convert.ToInt32(HttpContext.Current.Session["UserId"]) : 0,
            };
            string version = System.Web.Configuration.WebConfigurationManager.AppSettings.Get("Status");
            filterContext.ExceptionHandled = true;
            int error = new ErrorLogModel().Save(el);

            //if (!filterContext.ExceptionHandled && filterContext.Exception is NullReferenceException)
            //{
            //    filterContext.Result = new RedirectResult("~/Jobs/Index");
            //    filterContext.ExceptionHandled = true;
            //}
            filterContext.Result = new RedirectResult(_RedirectURL);
            filterContext.ExceptionHandled = true;
        }
    }
}