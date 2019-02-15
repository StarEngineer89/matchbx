// created by :Sanu Mohan P
// created date :1/7/2019 3:06:14 PM
// purpose :Model,Business classes
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
namespace Business
{
   public class GigSkillsMapping
    {
        public int GigSkillsMappingId { get; set; }
        public int GigId { get; set; }
        public int SkillsId { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime ModifiedDate { get; set; }
        public string Description { get; set; }
    }
}
