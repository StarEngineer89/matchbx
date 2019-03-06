// created by :Sanu Mohan P
// created date :1/7/2019 3:06:14 PM
// purpose :Model,Business classes
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Business
{
    public class Gig
    {
        public Gig()
        {
            GigTrendingTagsMappingList = new List<GigTrendingTagsMapping>();
            GigSkillsMappingList = new List<GigSkillsMapping>();
            GigDocumentsList = new List<GigDocuments>();
            TrendingTagsList = new List<TrendingTags>();
            GigSkillsList = new List<Skills>();

        }

        public int GigId { get; set; }
        [Required(ErrorMessage = "You need to select a category.")]
        public int JobCategoryId { get; set; }
        public int UserId { get; set; }
        [Required(ErrorMessage = "Sorry, you need to create a title")]
        [StringLength(200, MinimumLength = 5, ErrorMessage = "Service Title cannot be longer than 200 characters and less than 5 characters")]
        public string GigTitle { get; set; }
        [Required(ErrorMessage = "You need to give more details.")]
        public string GigDescription { get; set; }
        public decimal BudgetASP { get; set; }
        public decimal Commission { get; set; }
        public decimal TotalBudget { get; set; }
        [Required(ErrorMessage = "You need to provide a duration")]
        [Range(1, int.MaxValue, ErrorMessage = "Duration must be greater than 0")]
        [RegularExpression("([1-9][0-9]*)", ErrorMessage = "Duration must be a number")]
        public int GigDuration { get; set; }
        public string IsActive { get; set; }
        public string IsGigEnabled { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime ModifiedDate { get; set; }
        public string GigStatus { get; set; }
        public int CancelReason { get; set; }
        public string SortBy { get; set; }

        public string Child = "GigTrendingTagsMapping;GigSkillsMapping;GigDocuments";
        public List<GigTrendingTagsMapping> GigTrendingTagsMappingList { get; set; }
        public List<GigSkillsMapping> GigSkillsMappingList { get; set; }
        public List<GigDocuments> GigDocumentsList { get; set; }
        public List<TrendingTags> TrendingTagsList { get; set; }
        public List<Skills> GigSkillsList { get; set; }
        public List<GigSubscription> GigSubscriptionList { get; set; }
        public List<GigSubscription> GigActiveOrdersList { get; set; }
        public List<GigSubscription> GigCompletedOrdersList { get; set; }

        [Required(ErrorMessage = "You need to provide a budget.")]
        [MinLength(4, ErrorMessage = "The budget amount should be a minimum of 1,000 AXPR")]
        // [Range(1000, int.MaxValue, ErrorMessage = "The budget amount should be a minimum of 1,000 AXPR")]
        public string BudgetASPString { get; set; }
        public decimal BudgetInDollar { get; set; }
        public string GigDurationString { get; set; }
        public string TrendingTagsIdList { get; set; }
        public string SkillsList { get; set; }
        public string WithTransaction { get; set; }
        public int BudgetASPInt { get; set; }
        public decimal DollarCount { get; set; }
        public int Isloadmore { get; set; }
        public int BadgeCount { get; set; }
        public string CreatedDateDisplay { get; set; }
        public string ProfilePic { get; set; }
        public string FullName { get; set; }
        public int JobsCompleted { get; set; }
        public string Status { get; set; }
        public int JobCompletedSeeker { get; set; }
        public string PosterName { get; set; }
        public string PosterProfilePic { get; set; }
        public string Description { get; set; }
        public int GigSubscriptionId { get; set; }
        public string Role { get; set; }
        public string Email { get; set; }
        public decimal MinBudget { get; set; }
        public decimal MaxBudget { get; set; }
        public string GigDescriptionDisplay { get; set; }
        public int NoOfDocuments { get; set; }
        public int JobPosterId { get; set; }
        public string searchText { get; set; }
        public string PosterFullName { get; set; }
        public string GigSubscriptionStatus { get; set; }
        public int PostedDays { get; set; }
        public string Category { get; set; }
        public string LastEdited { get; set; }
        public DateTime GigCompletionDate { get; set; }
        public string GigCompletionDateDisplay { get; set; }
        public int LoginUserId { get; set; }
        public string TokenAddress { get; set; }
        public string FromPage { get; set; }
        [Required(ErrorMessage = "You need to provide deliverables")]
        public string Deliverables { get; set; }
        public int JobId { get; set; }
        public string Title { get; set; }
        public int messageSender { get; set; }
        public string SubscribedDateDisplay { get; set; }
        public string JobCompletionDateDisplay { get; set; }
        public int GigsCompleted { get; set; }
        public List<GigReview> GigReviewList { get; set; }
        public string VerifiedPartner { get; set; }
        public int SubscriedGigs { get; set; } 
        public int ActiveGigs { get; set; }
        public int CompletedGigs { get; set; }
        public string GigSubscriptionDisplay { get; set; }
        public int GigSubscribed { get; set; }
        public string IsApproved { get; set; }
        public string JobStatus { get; set; }
        public string JobStatusSeeker { get; set; }
        public string TransactionType { get; set; }
    }
}
