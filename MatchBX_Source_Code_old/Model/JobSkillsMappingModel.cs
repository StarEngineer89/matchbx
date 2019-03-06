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
   public class JobSkillsMappingModel : DBContext
    {
        public JobSkillsMapping GetARecord(int Id)
        {
            return base.GetARecord<JobSkillsMapping>(Id);
        }
        public List<JobSkillsMapping> GetList()
        {
            return base.GetList<JobSkillsMapping>();
        }
        public List<JobSkillsMapping> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<JobSkillsMapping>(Fields, SelectionCriteria);
        }
        public List<JobSkillsMapping> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<JobSkillsMapping>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(JobSkillsMapping _object)
        {
             int _returnValue= base.Save<JobSkillsMapping>("spAddEditJobSkillsMapping", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<JobSkillsMapping>( Id);
        }
       
    }
}
