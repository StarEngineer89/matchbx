// created by :Sanu Mohan P
// created date :1/21/2019 3:56:26 PM
// purpose :Gig reminder mail
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
namespace Business
{
   public class ReminderMailsGig
    {
        public int ReminderMailsGigId { get; set; }
        public int GigId { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime ModifiedDate { get; set; }
    }
}
