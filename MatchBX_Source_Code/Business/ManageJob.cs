using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace Business
{

    public class ManageJob
    {
        public int JobId { get; set; }
        public string JobReferanceId { get; set; }
        public string JobTitle { get; set; }
        public string JobCompletionDateDisplay { get; set; }
        public string Description { get; set; }
        public string JobStatus { get; set; }
        public string BudgetASP { get; set; }
        public string Bids { get; set; }

        public string FullName { get; set; }

        public string Category { get; set; }

        public string SkillsList { get; set; }

        public string CategoryList { get; set; }

        public int totJobCount { get; set; }

        public int UserId { get; set; }

        public string Email { get; set; }
        
    }
}