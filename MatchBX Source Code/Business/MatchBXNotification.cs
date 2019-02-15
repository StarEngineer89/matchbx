// created by :Sanu Mohan P
// created date :7/27/2018 4:46:52 PM
// purpose :MatchBX notifications
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
namespace Business
{
   public class MatchBXNotification
    {
        public int MatchBXNotificationId { get; set; }
        public int SenderId { get; set; }
        public string SenderFullName { get; set;}
        public int ReceiverId { get; set; }
        public string ReceiverFullName { get; set; }
        public string Header { get; set; }
        public string Notification { get; set; }
        public int ReadStatus { get; set; }
        public string CreatedTimeDisplay { get; set; }
        public string Url { get; set; }
    }
}
