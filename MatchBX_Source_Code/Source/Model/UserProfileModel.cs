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
   public class UserProfileModel : DBContext
    {
        public UserProfile GetARecord(int Id)
        {
            return base.GetARecord<UserProfile>(Id);
        }
        public List<UserProfile> GetList()
        {
            return base.GetList<UserProfile>();
        }
        public List<UserProfile> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<UserProfile>(Fields, SelectionCriteria);
        }
        public List<UserProfile> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<UserProfile>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(UserProfile _object)
        {
             int _returnValue= base.Save<UserProfile>("spAddEditUserProfile", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<UserProfile>( Id);
        }
        public List<UserProfile> LoadUserProfile(int userid)
        {
            UserProfile _object = new UserProfile();
            _object.UserId = userid;
            return base.GetCustomFunction<UserProfile>("spLoadUserProfile", _object);
        }
    }
}
