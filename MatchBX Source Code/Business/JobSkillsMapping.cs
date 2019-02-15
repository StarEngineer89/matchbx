// created by :Sanu Mohan P
// created date :6/29/2018 12:16:56 PM
// purpose :businee class
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
namespace Business
{
   public class JobSkillsMapping
    {
        public int JobSkillsMappingId { get; set; }
        public int JobId { get; set; }
        public int SkillsId { get; set; }
        public string Description { get; set; }
    }
}
