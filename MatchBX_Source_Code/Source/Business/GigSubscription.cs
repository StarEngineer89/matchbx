// created by :Sanu Mohan P
// created date :1/7/2019 3:06:14 PM
// purpose :Model,Business classes
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
namespace Business
{
   public class GigSubscription
    {
        public GigSubscription()
        {
            GigSubscriptionDocumentList = new List<GigSubscriptionDocument>();
        }
        public int GigSubscriptionId { get; set; }
        public int GigId { get; set; }
        public int JobPosterId { get; set; }
        public string Description { get; set; }
        public string IsActive { get; set; }
        public string GigSubscriptionStatus { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime ModifiedDate { get; set; }
        public string PosterFullName { get; set; }
        public string PosterProfilePic { get; set; }
        public int UserId { get; set; }        
        public DateTime JobCompletionDate { get; set; }
        public List<GigSubscriptionDocument> GigSubscriptionDocumentList { get; set; }
        public string WithTransaction { get; set; }
        public string Child = "GigSubscriptionDocument";
        public string Title { get; set; }
        public string Status { get; set; }
        public int JobId { get; set; }
        public string JobCompletionDateDisplay { get; set; }
        public string SubscribedDateDisplay { get; set; }
        public int JobsCompleted { get; set; }
        public int NoofDocuments { get; set; }
        public string JobStatus { get; set; }
        public string PurchasedDateDisplay { get; set; }
        public string JobStatusSeeker { get; set; }
    }
}
