// created by :Sanu Mohan P
// created date :6/29/2018 12:16:56 PM
// purpose :businee class
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;
using DBFramework;

namespace Model
{
   public class JobTrendingTagsMappingModel : DBContext
    {
        public JobTrendingTagsMapping GetARecord(int Id)
        {
            return base.GetARecord<JobTrendingTagsMapping>(Id);
        }
        public List<JobTrendingTagsMapping> GetList()
        {
            return base.GetList<JobTrendingTagsMapping>();
        }
        public List<JobTrendingTagsMapping> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<JobTrendingTagsMapping>(Fields, SelectionCriteria);
        }
        public List<JobTrendingTagsMapping> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<JobTrendingTagsMapping>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(JobTrendingTagsMapping _object)
        {
             int _returnValue= base.Save<JobTrendingTagsMapping>("spAddEditJobTrendingTagsMapping", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<JobTrendingTagsMapping>( Id);
        }
        
    }
}
