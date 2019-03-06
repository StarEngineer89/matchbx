// created by :Prazeed
// created date :7/21/2018 3:24:43 PM
// purpose :Messgae
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
namespace Business
{
   public class MatchBXMessage
    {
        public int MatchBXMessageId { get; set; }
        public int SendUserId { get; set; }
        public int ReceiverId { get; set; }
        public string Message { get; set; }
        public int ReadStatus { get; set; }
        public string ReceiverName { get; set; }
        public string SendUserName { get; set; }
        public string CreatedDateTime { get; set; }
        public string ProfilePic { get; set; }
        public string HubId { get; set; }

        public string JobSeeker { get; set; }
        public string BidUserProfilePic { get; set; }
        public string IsOnline { get; set; }
        public int RoomId { get; set; }
        public int IsMailSent { get; set; }
        public int UnreadCount { get; set; }
        public string MessageType { get; set; }
        public decimal FileSize { get; set; }
        public string FileName { get; set; }
        public int JobId { get; set; }

    }
}
