// created by :Sanu Mohan P
// created date :1/7/2019 3:06:14 PM
// purpose :Model,Business classes
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;using DBFramework;
namespace Model
{
   public class GigSkillsMappingModel : DBContext
    {
        public GigSkillsMapping GetARecord(int Id)
        {
            return base.GetARecord<GigSkillsMapping>(Id);
        }
        public List<GigSkillsMapping> GetList()
        {
            return base.GetList<GigSkillsMapping>();
        }
        public List<GigSkillsMapping> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<GigSkillsMapping>(Fields, SelectionCriteria);
        }
        public List<GigSkillsMapping> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<GigSkillsMapping>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(GigSkillsMapping _object)
        {
             int _returnValue= base.Save<GigSkillsMapping>("spAddEditGigSkillsMapping", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<GigSkillsMapping>( Id);
        }
    }
}
