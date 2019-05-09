// created by :Sanu Mohan P
// created date :10/24/2018 5:37:00 PM
// purpose :Job audit table
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;
using DBFramework;
namespace Model
{
   public class JobAuditModel : DBContext
    {
        public JobAudit GetARecord(int Id)
        {
            return base.GetARecord<JobAudit>(Id);
        }
        public List<JobAudit> GetList()
        {
            return base.GetList<JobAudit>();
        }
        public List<JobAudit> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<JobAudit>(Fields, SelectionCriteria);
        }
        public List<JobAudit> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<JobAudit>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(JobAudit _object)
        {
             int _returnValue= base.Save<JobAudit>("spAddEditJobAudit", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<JobAudit>( Id);
        }
    }
}
