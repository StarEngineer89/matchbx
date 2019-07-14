using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Business
{
    public class JobArbitration
    {
        public List<Job> MyJobs { get; set; }
        public int ArbitrationId { get; set; }
        public int JobId { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public String Issue { get; set; }
        public string Outcome { get; set; }
        public Decimal Stake { get; set; }
        public string CryptoSymbol { get; set; }
        public Boolean IsActive { get; set; }

        
    }
}