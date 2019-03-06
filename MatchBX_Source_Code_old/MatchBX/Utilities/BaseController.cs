using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;

namespace MatchBx.Utilities
{
    [SessionExpire]
    [ExceptionLog]
    public class BaseController : Controller
    {
        public void Success(string message, bool dismissable = false,bool IsAjaxRequest=false)
        {
            AddAlert(AlertStyles.Success, message, dismissable, IsAjaxRequest);
        }

        public void Information(string message, bool dismissable = false,bool IsAjaxRequest=false)
        {
            AddAlert(AlertStyles.Information, message, dismissable, IsAjaxRequest);
        }

        public void Warning(string message, bool dismissable = false,bool IsAjaxRequest=false)
        {
            AddAlert(AlertStyles.Warning, message, dismissable, IsAjaxRequest);
        }

        public void Danger(string message, bool dismissable = false,bool IsAjaxRequest=false)
        {
            AddAlert(AlertStyles.Danger, message, dismissable, IsAjaxRequest);
        }
        public string SuccessJavaScript(string message, bool dismissable = false, bool IsAjaxRequest = false)
        {
            return AddSuccessJavascript(AlertStyles.Danger, message, dismissable, IsAjaxRequest);
        }
        public string DangerJavascript(string message, bool dismissable = false, bool IsAjaxRequest = false)
        {
            return AddDangerJavascript(AlertStyles.Danger, message, dismissable, IsAjaxRequest);
        }
        private void AddAlert(string alertStyle, string message, bool dismissable, bool IsAjaxRequest)
        {
            var alerts = TempData.ContainsKey(Alert.TempDataKey)
                ? (List<Alert>)TempData[Alert.TempDataKey]
                : new List<Alert>();

            alerts.Add(new Alert
            {
                AlertStyle = alertStyle,
                Message = message,
                Dismissable = dismissable,
                IsAjaxRequest=IsAjaxRequest
            });

            TempData[Alert.TempDataKey] = alerts;
        }

        private String AddSuccessJavascript(string alertStyle, string message, bool dismissable, bool IsAjaxRequest)
        {
            StringBuilder _html = new StringBuilder();
            _html.Append("<div class='col-md-12 invoice_list_view_infobg invoice_list_view_small_infobg'>");
            _html.Append("<div class='alert alert-success fade in alert-dismissable'>");
            _html.Append("<strong><i class='fa fa-check-circle' aria-hidden='true'></i></strong>");
            _html.Append("<div id='alertsuccess' class='alert_text'>" + message + "</div>");
            _html.Append("</div></div>");
            return _html.ToString();
        }

        private String AddDangerJavascript(string alertStyle, string message, bool dismissable, bool IsAjaxRequest)
        {
            StringBuilder _html = new StringBuilder();
            _html.Append("<div class='col-md-12 invoice_list_view_infobg invoice_list_view_small_infobg'>");
            //_html.Append("<div class='alert alert-success fade in alert-dismissable'>");
            _html.Append("<div class='alert alert-danger fade in alert-dismissable'>");
            //_html.Append(" <strong><i class='fa fa-check-circle' aria-hidden='true'></i></strong>");
            _html.Append(" <strong><i class='fa fa-times-circle' aria-hidden='true'></i></strong>");
            _html.Append("<div id='alertfailure' class='alert_text'>" + message + "</div>");
            _html.Append("</div></div>");
            return _html.ToString();

       
        }

    }
}