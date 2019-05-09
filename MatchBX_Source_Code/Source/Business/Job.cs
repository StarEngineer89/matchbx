// created by :Sanu Mohan P
// created date :6/25/2018 12:48:12 PM
// purpose :MatchBX
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
namespace Business
{
    public class Job
    {
        public Job()
        {
            JobTrendingTagsMappingList = new List<JobTrendingTagsMapping>();
            JobSkillsMappingList = new List<JobSkillsMapping>();
            JobDocumentsList = new List<JobDocuments>();
            TrendingTagsList = new List<TrendingTags>();
            JobSkillsList = new List<Skills>();
            JobBiddingList = new List<JobBidding>();
            CurrentOffersList = new List<Job>();

        }
        public int JobId { get; set; }
        public int UserId { get; set; }

        [Required(ErrorMessage = "Sorry, you need to create a title")]
        [StringLength(200, MinimumLength = 5, ErrorMessage = "Job Title cannot be longer than 200 characters and less than 5 characters")]

        public string JobTitle { get; set; }


        [Required(ErrorMessage = "You need to give more details.")]
        public string JobDescription { get; set; }

        public string JobDescriptionDisplay { get; set; }


        public decimal BudgetASP { get; set; }

        public int BudgetASPInt { get; set; }
        public decimal BudgetInDollar { get; set; }


        [Required(ErrorMessage = "You need to select a job category")]
        public int JobCategoryId { get; set; }

        public decimal Commission { get; set; }
        public decimal TotalBudget { get; set; }
        [Required(ErrorMessage = "You need to provide a completion date")]
        [Display(Name = "Job Completion Date")]
        public DateTime JobCompletionDate { get; set; }
        public string IsActive { get; set; }
        public string JobStatus { get; set; }
        public string ProfilePic { get; set; }
        public string FullName { get; set; }
        public string JobCompletionDateDisplay { get; set; }
        public int JobsCompleted { get; set; }
        public int NoOfJobs { get; set; }
        public decimal DollarCount { get; set; }
        public int BadgeCount { get; set; }
        //  [Required(ErrorMessage = "Please add a few tags. They help people find your job!")]
        public int TrendingTagsId { get; set; }
        public string TrendingTagsIdList { get; set; }
        public string SkillsList { get; set; }
        public decimal MinBudget { get; set; }
        public decimal MaxBudget { get; set; }
        public string SortBy { get; set; }
        public string Child = "JobTrendingTagsMapping;JobSkillsMapping;JobDocuments";
        public List<JobTrendingTagsMapping> JobTrendingTagsMappingList { get; set; }
        public List<JobSkillsMapping> JobSkillsMappingList { get; set; }
        public List<JobDocuments> JobDocumentsList { get; set; }
        //public List<TrendingTags> TrendingTagsList { get; set; }
        //public List<Skills> TopSkillsList { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime ModifiedDate { get; set; }
        public int JobSeekerId { get; set; }
        public string JobReferanceId { get; set; }
        public int PostedDays { get; set; }
        public string LastEdited { get; set; }
        public int SkillsId { get; set; }
        public List<TrendingTags> TrendingTagsList { get; set; }
        public List<Skills> JobSkillsList { get; set; }
        public int Isloadmore { get; set; }
        public string Category { get; set; }
        public decimal JobPosterRating { get; set; }
        public decimal JobSeekerRating { get; set; }

        public string JobStatusSeeker { get; set; }

        public decimal BidAmount { get; set; }
        public string UserRole { get; set; }
        public List<JobBidding> JobBiddingList { get; set; }
        public int JobBiddingId { get; set; }
        public string BidMessage { get; set; }
        public string EndsIn { get; set; }
        public string BidUserName { get; set; }
        public int BidUserId { get; set; }
        public string SeekerFullName { get; set; }
        public int JobPosterId { get; set; }
        public string PosterFullName { get; set; }
        public SocialMediaShare ShareJob { get; set; }
        public string BidUserProfilePic { get; set; }
        public List<UserEmailPreferenceMapping> EmailPreferences { get; set; }

        public int CancelReason { get; set; }
        public string TokenAddressPoster { get; set; }
        public string IsApprovedPoster { get; set; }
        public string TokenAddressSeeker { get; set; }
        public string IsApprovedSeeker { get; set; }
        public int Bid { get; set; }
        public string CreatedDateDisplay { get; set; }
        public string CompletionStatus { get; set; }
        public string JobPosterProfile { get; set; }
        public string JobSeekerProfile { get; set; }

        public string WithTransaction { get; set; }
        [Required(ErrorMessage = "You need to provide a budget.")]
        //[Range(1000.00, double.MaxValue, ErrorMessage = "The budget amount should be a minimum of 1,000 AXPR")]
        //[RegularExpression("^(\\d{1,})(,\\d{1,})*(\\.\\d{1,})?$", ErrorMessage = "Please enter a valid amount.")]
        public string BudgetASPString { get; set; }

        public int messageSender { get; set; }
        public int TotalJobPosters { get; set; }

        public string searchText { get; set; }
        public string IsPending { get; set; }
        public string AcceptStatus { get; set; }
        public string AcceptStatusHover { get; set; }
        public string  Email {get;set;}
        public int NoOfDocuments { get; set; }

        public int Days { get; set; }

        public int Hours { get; set; }
        public string FromPage { get; set; }
        public int GigSubscriptionId { get; set; }
        public int GigsCompleted { get; set; }
        public string CssClass { get; set; }
        public string Type { get; set; }
        public string RedirectUrl { get; set; }
        public int Rownumber { get; set; }
        public string VerifiedPartner { get; set; }
        public int NoOfGigs { get; set; }
        public string PosterProfilePic { get; set; }
        public int ActiveBids { get; set; }
        public int DeclinedBids { get; set; }
        public DateTime CurrentDate { get; set; }
        public string TimeRemaining { get; set; }
        public string SeekerProfilePic { get; set; }
        public int SeekerId { get; set; }
        public string IsExpired { get; set; }
        public int PendingBid { get; set; }
        public List<Job> CurrentOffersList { get; set; }
        public string TokenAddress { get; set; }
        public string BidMessageDisplay { get; set; }
        public string IsAccepted { get; set; }
        public int TransactionDetailId { get; set; }
        public int BidDuration { get; set; }
        public List<Job> DeclinedOffersList { get; set; }
    }
}
