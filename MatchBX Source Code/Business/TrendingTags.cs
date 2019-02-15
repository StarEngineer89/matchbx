// created by :Sanu Mohan P
// created date :6/25/2018 5:12:51 PM
// purpose :Trending Tags 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
namespace Business
{
   public class TrendingTags
    {
        public int TrendingTagsId { get; set; }
        public string Description { get; set; }
        public int JobCategoryId { get; set; }
        public string TagType { get; set; }

        public string FromPage { get; set; }
    }
}
