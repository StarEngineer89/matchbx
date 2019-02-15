// created by :Sanu Mohan P
// created date :6/29/2018 12:16:56 PM
// purpose :businee class
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
namespace Business
{
   public class JobTrendingTagsMapping
    {
        public int JobTrendingTagsMappingId { get; set; }
        public int JobId { get; set; }
        //[Required(ErrorMessage = "Please add a few tags. They help people find your job!")]
        public int TrendingTagsId { get; set; }
        public string Description { get; set; }
    }
}
