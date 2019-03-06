using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace MatchBX.Models
{
    public class ExternalLoginConfirmationViewModel
    {
        [Required]
        [Display(Name = "Email")]
        public string Email { get; set; }
    }

    public class ExternalLoginListViewModel
    {
        public string ReturnUrl { get; set; }
    }

    public class SendCodeViewModel
    {
        public string SelectedProvider { get; set; }
        public ICollection<System.Web.Mvc.SelectListItem> Providers { get; set; }
        public string ReturnUrl { get; set; }
        public bool RememberMe { get; set; }
    }

    public class VerifyCodeViewModel
    {
        [Required]
        public string Provider { get; set; }

        [Required]
        [Display(Name = "Code")]
        public string Code { get; set; }
        public string ReturnUrl { get; set; }

        [Display(Name = "Remember this browser?")]
        public bool RememberBrowser { get; set; }

        public bool RememberMe { get; set; }
    }

    public class ForgotViewModel
    {
        [Required(ErrorMessage ="Email is required")]
        [Display(Name = "Email")]
        [EmailAddress(ErrorMessage = "Invalid Email")]
        public string Email { get; set; }
    }

    public class LoginViewModel
    {
        [Required]
        [Display(Name = "Email Address")]
        [EmailAddress]
        public string UserName { get; set; }

        [Required]
        [DataType(DataType.Password)]
        [Display(Name = "Password")]
        public string Password { get; set; }

        [Display(Name = "Remember me?")]
        public bool RememberMe { get; set; }

        public string HubId { get; set; }
    }

    public class RegisterViewModel
    {
        [Required(ErrorMessage = "Please tell us your username")]
        [DataType(DataType.Text, ErrorMessage = "Invalid username")]
        //[Remote("CheckExistingUsername", "user", AdditionalFields = "UserInfoId", ErrorMessage = "User Name already exists!")]
        [Remote("CheckUserName", "Login", ErrorMessage = "Sorry, someone's already picked that!")]
        public string UserName { get; set; }
        [Required(ErrorMessage = "Password required")]
        //[StringLength(100, ErrorMessage = "Password must have a minimum of {2} characters.", MinimumLength = 8)]
        [Remote("ValidatePassword", "Login", ErrorMessage = "Password must contain at least 8 letters and 1 number")]
        [DataType(DataType.Password)]
        public string Password { get; set; }
        //[Required(ErrorMessage = "Full name of the User Required")]
        [DataType(DataType.Text, ErrorMessage = "Invalid full name")]
        public string FullName { get; set; }
        [Required(ErrorMessage = "Please tell us your email address")]
        //[DataType(DataType.EmailAddress, ErrorMessage = "Invalid Email")]
        [EmailAddress(ErrorMessage = "Invalid Email")]
        [Remote("CheckUserEmail", "Login", ErrorMessage = "Email address already exists. Please use a different Email address.")]
        public string Email { get; set; }
        [Required(ErrorMessage = "You need to confirm you have read the privacy statement and our T&Cs")]
        public bool Node_check { get; set; }
    }

    public class ResetPasswordViewModel
    {
        //[Required]
        //[EmailAddress]
        //[Display(Name = "Email")]
        public string Email { get; set; }

        [Required(ErrorMessage = "Password required")]
        [Remote("ValidatePassword", "Login", ErrorMessage = "Password must contain at least 8 letters and 1 number")]
        [DataType(DataType.Password)]
        [Display(Name = "Password")]
        public string Password { get; set; }

        [DataType(DataType.Password)]
        [Display(Name = "Confirm password")]
        [System.ComponentModel.DataAnnotations.CompareAttribute("Password", ErrorMessage = "Passwords don’t match! Please correct")]
        public string ConfirmPassword { get; set; }

        public string Code { get; set; }
    }

    public class ForgotPasswordViewModel
    {
        [Required (ErrorMessage = "Please tell us your email address.")]
        [EmailAddress]
        [Display(Name = "Email")]
        public string Email { get; set; }
    }
}
