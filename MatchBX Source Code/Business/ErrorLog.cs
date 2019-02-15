// created by :Sanu Mohan P
// created date :6/20/2018 7:38:15 PM
// purpose :Business class added
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
namespace Business
{
   public class ErrorLog
    {
        public int ErrorLogId { get; set; }
        public string ErrorDescription { get; set; }
        public DateTime ErrorReportedOn { get; set; }
        public string ErrorStack { get; set; }
        public string ErrorSource { get; set; }
        public string ErrorMethod { get; set; }
        public int UserId { get; set; }
    }
}
