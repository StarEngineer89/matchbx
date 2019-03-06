// created by :Sanu Mohan P
// created date :8/13/2018 3:36:31 PM
// purpose :Transaction details
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
namespace Business
{
   public class TransactionDetail
    {
        public int TransactionDetailId { get; set; }
        public int UserId { get; set; }
        public int JobId { get; set; }
        public string Hash { get; set; }
        public decimal Amount { get; set; }
        public string TransactionType { get; set; }
        public string ProcessType { get; set; }
        public string IsApproved { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime ModifiedDate { get; set; }
        public string Address { get; set; }
        public decimal BurnPer { get; set; }
    }
}
