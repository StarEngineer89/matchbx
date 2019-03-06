// created by :Sanu Mohan P
// created date :1/7/2019 3:06:15 PM
// purpose :Model,Business classes
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
namespace Business
{
   public class GigTrendingTagsMapping
    {
        public int GigTrendingTagsMappingId { get; set; }
        public int GigId { get; set; }
        public int TrendingTagsId { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime ModifiedDate { get; set; }
        public string Description { get; set; }
    }
}
