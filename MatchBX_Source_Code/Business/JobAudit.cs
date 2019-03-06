// created by :Sanu Mohan P
// created date :10/24/2018 5:37:00 PM
// purpose :Job audit table
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
namespace Business
{
   public class JobAudit
    {
        public int JobAuditId { get; set; }
        public int JobId { get; set; }
        public int UserId { get; set; }
        public string Status { get; set; }
        public int RejectReason { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime ModifiedDate { get; set; }
    }
}
