using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
namespace Business
{
    public class AdminFeatures
    {
        public int UserId { get; set; }

        public string UserName { get; set; }

        public string FullName { get; set; }

        public string Email { get; set; }

        public string Skills { get; set; }

        public string Role { get; set; }

        public string JobsListed { get; set; }

        public string JobsBidon { get; set; }

        public int JobsCompleted { get; set; }

        public int JobsinProgress { get; set; }

        public int BlockReason { get; set; }

        public string UserStatus { get; set; }

        public string SkillsList { get; set; }
        public List<Skills> SkillsMappingList { get; set; }

        public int totUserCount { get; set; }

        public string VerifiedPartner { get; set; }
    }


}