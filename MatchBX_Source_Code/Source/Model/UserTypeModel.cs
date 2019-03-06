// created by :Sanu Mohan P
// created date :6/20/2018 3:11:52 PM
// purpose :Model class
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;
using DBFramework;

namespace Model
{
   public class UserTypeModel : DBContext
    { 
        public UserType GetARecord(int Id)
        {
            return base.GetARecord<UserType>(Id);
        }
        public List<UserType> GetList()
        {
            return base.GetList<UserType>();
        }
        public List<UserType> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<UserType>(Fields, SelectionCriteria);
        }
        public List<UserType> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<UserType>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(UserType _object)
        {
             int _returnValue= base.Save<UserType>("spAddEditUserType", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<UserType>( Id);
        }
    }
}
