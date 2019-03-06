// created by :Sanu Mohan P
// created date :1/18/2019 12:24:47 PM
// purpose :Model Business layer 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
namespace Business
{
   public class AjaxSession
    {
        public int AjaxSessionId { get; set; }
        public string SessionString { get; set; }

        public int UserId { get; set; }
    }
}
