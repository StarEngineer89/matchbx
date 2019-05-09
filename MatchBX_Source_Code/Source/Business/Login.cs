// created by :Sanu Mohan P
// created date :6/20/2018 1:01:37 PM
// purpose :Business class creation
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
namespace Business
{
   public class Login
    {
        public int LoginId { get; set; }
        public int UserId { get; set; }
        public DateTime LoginDate { get; set; }
        public string IPAddress { get; set; }
        public DateTime LogoutDate { get; set; }
        public string HubId { get; set; }
        public string IsOnline { get; set; }
        public int SendUserId { get; set; }
        public int IsMailSent { get; set; }
        public string ProfilePic { get; set; }
    }
}
 