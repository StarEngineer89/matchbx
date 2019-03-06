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
   public class SkillsModel : DBContext
    {
        public Skills GetARecord(int Id)
        {
            return base.GetARecord<Skills>(Id);
        }
        public List<Skills> GetList()
        {
            return base.GetList<Skills>();
        }
        public List<Skills> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<Skills>(Fields, SelectionCriteria);
        }
        public List<Skills> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<Skills>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(Skills _object)
        {
             int _returnValue= base.Save<Skills>("spAddEditSkills", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<Skills>( Id);
        }
        public List<Skills> GetTopSkills(Skills _object)
        {
            return base.GetCustomFunction<Skills>("spGetSkills", _object);
        }
        public List<Skills> GetUniqueSkills(Skills _object)
        {
            return base.GetCustomFunction<Skills>("spGetUniqueSkills", _object);
        }
    }
}
