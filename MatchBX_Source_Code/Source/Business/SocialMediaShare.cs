// created by :Sanu Mohan P
// created date :7/31/2018 11:29:35 AM
// purpose :Social media share
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
namespace Business
{
   public class SocialMediaShare
    {
        public int SocialMediaShareId { get; set; }
        public int JobId { get; set; }
        public int UserId { get; set; }
        public string FBShare { get; set; }
        public string TwitterShare { get; set; }
    }
}
