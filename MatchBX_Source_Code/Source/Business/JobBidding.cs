// created by :Sanu Mohan P
// created date :7/4/2018 1:18:14 PM
// purpose :Business,Model,Sp creation
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
namespace Business
{
    public class JobBidding
    {
        public int JobBiddingId { get; set; }
        public int JobId { get; set; }
        public int UserId { get; set; }
        public decimal BidAmount { get; set; }
        public string BidMessage { get; set; }
        public string IsActive { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime ModifiedDate { get; set; }

        public string IsAccepted { get; set; }
        public string Status { get; set; }
        public string BidUserName { get; set; }
        public string BidUserProfilePic { get; set; }
        public string JobStatus { get; set; }
        public string TokenAddressPoster { get; set; }
        public string IsApprovedPoster { get; set; }
        public string TokenAddressSeeker { get; set; }
        public string IsApprovedSeeker { get; set; }
        public int TokenDistributionId { get; set; }

        public decimal BidAmountinDollar { get; set; }
        public string DeclineType { get; set; }
        public string CompletionStatus { get; set; }
        public string IsPending { get; set; }
        public string AcceptStatus { get; set; }
        public string AcceptStatusHover { get; set; }

    }
}
