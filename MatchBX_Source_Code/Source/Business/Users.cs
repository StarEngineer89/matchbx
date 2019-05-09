// created by :Sanu Mohan P
// created date :6/20/2018 1:01:37 PM
// purpose :Business class creation
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Business
{
   public class Users
    {
        public Users()
        {
            UserProfileList = new List<UserProfile>();
            UserSkillsMappingList = new List<UserSkillsMapping>();
        }
        public int UserId { get; set; }
        [Required(ErrorMessage = "User Name required")]
        [DataType(DataType.Text, ErrorMessage = "Invalid User Name")]
        //[Remote("CheckExistingUsername", "user", AdditionalFields = "UserInfoId", ErrorMessage = "User Name already exists!")]
        [Remote("CheckUserName", "Login", ErrorMessage = "User Name already exists. Please use a different User Name.")]
        public string UserName { get; set; }
        [Required(ErrorMessage = "Password required")]
        [StringLength(100, ErrorMessage = "Password must have a minimum of {2} characters.", MinimumLength = 8)]
        [DataType(DataType.Password)]
        public string Password { get; set; }
        [Required(ErrorMessage = "Full Name of the User Required")]
        [DataType(DataType.Text, ErrorMessage = "Invalid Name of the User")]
        public string FullName { get; set; }
        [Required(ErrorMessage = "Email required")]
        [DataType(DataType.EmailAddress, ErrorMessage = "Invalid Email")]
        [Remote("CheckUserEmail", "Login", ErrorMessage = "E-mail address already exists. Please use a different E-mail address.")]
        public string Email { get; set; }
        public int IsActive { get; set; }
        public string UserType { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime ModifiedDate { get; set; }
        public bool RememberMe { get; set; }
        public string RetMsg { get; set; }
        public List<UserProfile> UserProfileList { get; set; }
        public List<UserSkillsMapping> UserSkillsMappingList { get; set; }
        public int BlockReason { get; set; }
        public string Child = "UserProfile;UserSkillsMapping";
        public string VerificationCode { get; set; }
        public string HubId { get; set; }

        public decimal Spent { get; set; }
        public decimal Earnt { get; set; }
        public string NotificationStatus { get; set; }
        public string MessageStatus { get; set; }
        public string VerifiedPartner { get; set; }
        public string ProjectMsgStatus { get; set; }
    }
}
