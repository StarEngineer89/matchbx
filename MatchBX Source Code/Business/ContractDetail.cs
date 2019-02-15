// created by :Sanu Mohan P
// created date :8/15/2018 6:28:45 PM
// purpose :Contract details
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
namespace Business
{
   public class ContractDetail
    {
        public int ContractDetailId { get; set; }
        public string TokenAddress { get; set; }
        public string EscrowAddress { get; set; }
        public string TokenABI { get; set; }
        public string EscrowABI { get; set; }
        public string OwnerAddress { get; set; }
        public string PrivateKeyHash { get; set; }
    }
}
