// created by :Sanu Mohan P
// created date :7/10/2018 11:30:48 AM
// purpose :User skill mapping
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;
using DBFramework;

namespace Model
{
   public class UserSkillsMappingModel : DBContext
    {
        public UserSkillsMapping GetARecord(int Id)
        {
            return base.GetARecord<UserSkillsMapping>(Id);
        }
        public List<UserSkillsMapping> GetList()
        {
            return base.GetList<UserSkillsMapping>();
        }
        public List<UserSkillsMapping> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<UserSkillsMapping>(Fields, SelectionCriteria);
        }
        public List<UserSkillsMapping> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<UserSkillsMapping>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(UserSkillsMapping _object)
        {
             int _returnValue= base.Save<UserSkillsMapping>("spAddEditUserSkillsMapping", _object);
             return _returnValue;
        }

        public int SaveWithTransaction(UserSkillsMapping _object)
        {
            int _returnValue = base.SaveWithTransaction<UserSkillsMapping>("spAddEditUserSkillsMapping", _object);
            return _returnValue;
        }


        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<UserSkillsMapping>( Id);
        }

        public bool Delete(UserSkillsMapping _object)
        {
            List<UserSkillsMapping> _list = base.GetCustomFunction<UserSkillsMapping>("spDeleteUserSkills", _object);
            return _list.Count > 0 ? true : false;
        }

        public List<UserSkillsMapping> LoadSkillsByUserId(int userId)
        {
            UserSkillsMapping _object = new UserSkillsMapping();
            _object.UserId = userId;
            return base.GetCustomFunction<UserSkillsMapping>("spLoadSkillsByUserId", _object);
        }
        public List<UserSkillsMapping> SkillsByUserId(int userId)
        {
            UserSkillsMapping _object = new UserSkillsMapping();
            _object.UserId = userId;
            return base.GetCustomFunction<UserSkillsMapping>("spGetUserSkills", _object);
        }
    }
}
