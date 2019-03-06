// created by :Sanu Mohan P
// created date :6/25/2018 12:49:12 PM
// purpose :MatchBX
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;
using DBFramework;

namespace Model
{
   public class JobCategoryModel : DBContext
    {
        public JobCategory GetARecord(int Id)
        {
            return base.GetARecord<JobCategory>(Id);
        }
        public List<JobCategory> GetList()
        {
            return base.GetList<JobCategory>();
        }
        public List<JobCategory> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<JobCategory>(Fields, SelectionCriteria);
        }
        public List<JobCategory> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<JobCategory>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(JobCategory _object)
        {
             int _returnValue= base.Save<JobCategory>("spAddEditJobCategory", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<JobCategory>( Id);
        }
    }
}
