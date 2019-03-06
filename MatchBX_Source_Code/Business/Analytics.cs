using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Business
{
    public class Analytics
    {
        public int TotalJobs { get; set; }
        public int TotalJobPosters { get; set; }
        public decimal TotalBudget { get; set; }
        public List<string> Categories { get; set; }
        public List<string> Posters { get; set; }
        public List<JobAnalytics> JobAnalytics { get; set; }
    }
    public class JobAnalytics
    {
        public string Date { get; set; }
        public string JobID { get; set; }
        public string Category { get; set; }
        public string PosterBy { get; set; }
        public decimal AXP { get; set; }
        public int Response { get; set; }
    }
    public class UserDetails
    {
        public string UserId { get; set; }
        public string UserName { get; set; }
        public string FullName { get; set; }
        public string Email { get; set; }
        public string IsActive { get; set; }
        public string UserType { get; set; }
        public string CreatedDate { get; set; }
        public string ModifiedDate { get; set; }
        public string Geography { get; set; }
    }
    public class VanityMatrics
    {
        public List<UserDetails> UserDetails { get; set; }
        public List<JobDetails> JobDetails { get; set; }
        public List<LoginDetails> LoginDetails { get; set; }
        public List<BidDetails> BidDetails { get; set; }
    }
    public class JobDetails
    {
        public int JobId { get; set; }
        public string JobCategory { get; set; }
        public string CreatedDate { get; set; }
        public double TotalBudget { get; set; }
        public string JobStatus { get; set; }
        public double AXPComp { get; set; }
        public double ComComp { get; set; }
        public string Poster { get; set; }

    }
    public class LoginDetails
    {
        public int UserId { get; set; }
        public string LoginDate { get; set; }
    }
    public class BidDetails
    {
        public string JobBiddingId { get; set; }
        public string JobId { get; set; }
        public string UserId { get; set; }
        public string BidAmount { get; set; }
        public string BidMessage { get; set; }
        public string IsActive { get; set; }
        public string CreatedDate { get; set; }
        public string ModifiedDate { get; set; }
        public string IsAccepted { get; set; }
    }
}