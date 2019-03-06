// created by :Sanu Mohan P
// created date :7/31/2018 5:22:24 PM
// purpose :Email preference mapping
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
namespace Business
{
   public class UserEmailPreferenceMapping
    {
        public int UserEmailPreferenceMappingId { get; set; }
        public int UserId { get; set; }
        public int EmailPreferenceId { get; set; }
        public bool CheckStatus { get; set; }
        public string Description { get; set; }
        public string EmailPreferenceIdList { get; set; }
    }
}
