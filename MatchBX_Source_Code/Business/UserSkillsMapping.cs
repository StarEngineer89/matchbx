// created by :Sanu Mohan P
// created date :7/10/2018 11:30:48 AM
// purpose :User skill mapping
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
namespace Business
{
   public class UserSkillsMapping
    {

        public UserSkillsMapping()
        {
         
            UserSkillsMappingList = new List<UserSkillsMapping>();
        }
        public int UserSkillsMappingId { get; set; }
        public int UserId { get; set; }
        public int SkillsId { get; set; }
        public string Description { get; set; }

        public string SkillsList { get; set; }

        public List<UserSkillsMapping> UserSkillsMappingList { get; set; }
    }
}
