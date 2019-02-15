// created by :Sanu Mohan P
// created date :1/7/2019 3:06:14 PM
// purpose :Model,Business classes
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
namespace Business
{
   public class GigSubscriptionDocument
    {
        public int GigSubscriptionDocumentId { get; set; }
        public string DocumentName { get; set; }
        public int GigSubscriptionId { get; set; }
        public string IsActive { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime ModifiedDate { get; set; }
        public double FileSize { get; set; }
    }
}
