// created by :Sanu Mohan P
// created date :8/8/2018 7:03:00 PM
// purpose :
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
namespace Business
{
   public class TokenDistribution
    {
        public int TokenDistributionId { get; set; }
        public int UserId { get; set; }
        public string TokenAddress { get; set; }
        public string IsApproved { get; set; }
        public int JobBiddingId { get; set; }
        public int GigSubscriptionId { get; set; }
    }
}
