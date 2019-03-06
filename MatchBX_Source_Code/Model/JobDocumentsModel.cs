// created by :Sanu Mohan P
// created date :6/29/2018 12:16:56 PM
// purpose :businee class
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;using DBFramework;
namespace Model
{
   public class JobDocumentsModel : DBContext
    {
        public JobDocuments GetARecord(int Id)
        {
            return base.GetARecord<JobDocuments>(Id);
        }
        public List<JobDocuments> GetList()
        {
            return base.GetList<JobDocuments>();
        }
        public List<JobDocuments> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<JobDocuments>(Fields, SelectionCriteria);
        }
        public List<JobDocuments> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<JobDocuments>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(JobDocuments _object)
        {
             int _returnValue= base.Save<JobDocuments>("spAddEditJobDocuments", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<JobDocuments>( Id);
        }
        
    }
}
