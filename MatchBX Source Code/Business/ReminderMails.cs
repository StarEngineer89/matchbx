// created by :Sanu Mohan P
// created date :10/31/2018 12:24:12 PM
// purpose :ReminderMails
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
namespace Business
{
   public class ReminderMails
    {
        public int ReminderMailsId { get; set; }
        public int JobId { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime ModifiedDate { get; set; }
    }
}
