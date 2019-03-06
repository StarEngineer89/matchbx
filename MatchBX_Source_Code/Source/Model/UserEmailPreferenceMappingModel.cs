// created by :Sanu Mohan P
// created date :7/31/2018 5:22:24 PM
// purpose :Email preference mapping
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;
using DBFramework;

namespace Model
{
   public class UserEmailPreferenceMappingModel : DBContext
    {
        public UserEmailPreferenceMapping GetARecord(int Id)
        {
            return base.GetARecord<UserEmailPreferenceMapping>(Id);
        }
        public List<UserEmailPreferenceMapping> GetList()
        {
            return base.GetList<UserEmailPreferenceMapping>();
        }
        public List<UserEmailPreferenceMapping> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<UserEmailPreferenceMapping>(Fields, SelectionCriteria);
        }
        public List<UserEmailPreferenceMapping> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<UserEmailPreferenceMapping>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(UserEmailPreferenceMapping _object)
        {
             int _returnValue= base.Save<UserEmailPreferenceMapping>("spAddEditUserEmailPreferenceMapping", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<UserEmailPreferenceMapping>( Id);
        }

        public List<UserEmailPreferenceMapping> GetUserEmailPreference(int id)
        {
            UserEmailPreferenceMapping prefObj = new UserEmailPreferenceMapping();
            prefObj.UserId = id;
            return base.GetCustomFunction<UserEmailPreferenceMapping>("spGetEmailPreference", prefObj);
        }
        public bool GetEmailNotifications(UserEmailPreferenceMapping _object)
        {
            List<UserEmailPreferenceMapping> _list = base.GetCustomFunction<UserEmailPreferenceMapping>("spGetEmailNotifications", _object);
            return _list.Count > 0 ? true : false;
        }
    }
}
