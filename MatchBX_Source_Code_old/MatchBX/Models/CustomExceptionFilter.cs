using System;
using System.Collections.Generic;
using System.Configuration;
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