// created by :Sanu Mohan P
// created date :6/25/2018 12:48:12 PM
// purpose :MatchBX
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
namespace Business
{
   public class UserProfile
    {
        public int UserProfileId { get; set; }
        public int UserId { get; set; }
        public string ProfilePic { get; set; }
        public string Bio { get; set; }
        public decimal Rating { get; set; }
        public string UserName { get; set; }
        public string FullName { get; set; }
        public int RatingCount { get; set; }
        public int UserType { get; set; }
        public string VerifiedPartner { get; set; }
        // Gus:
        public int TwoFA { get; set; }
    }
}
