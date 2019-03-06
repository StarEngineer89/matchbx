// created by :Sanu Mohan P
// created date :2/6/2019 5:58:59 PM
// purpose :Gig review
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
namespace Business
{
   public class GigReview
    {
        public int GigReviewId { get; set; }
        public int JobId { get; set; }
        public int GigId { get; set; }
        public string Review { get; set; }
        public string GigReviewStatus { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime ModifiedDate { get; set; }
        public int GigSubscriptionId { get; set; }
        public string ProfilePic { get; set; }
        public string FullName { get; set; }
        public string CreatedDateDisplay { get; set; }
        public int JobSeekerRatingInt { get; set; }
        public int Isloadmore { get; set; }
        public string SortBy { get; set; }
        public int UserId { get; set; }
        public string GigTitle { get; set; }
        public string Email { get; set; }
    }
}
