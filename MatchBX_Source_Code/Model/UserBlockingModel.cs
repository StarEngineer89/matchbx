// created by :Sanu Mohan P
// created date :8/1/2018 6:07:06 PM
// purpose :Block reason
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;
using DBFramework;
namespace Model
{
   public class UserBlockingModel : DBContext
    {
        public UserBlocking GetARecord(int Id)
        {
            return base.GetARecord<UserBlocking>(Id);
        }
        public List<UserBlocking> GetList()
        {
            return base.GetList<UserBlocking>();
        }
        public List<UserBlocking> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<UserBlocking>(Fields, SelectionCriteria);
        }
        public List<UserBlocking> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<UserBlocking>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(UserBlocking _object)
        {
             int _returnValue= base.Save<UserBlocking>("spAddEditUserBlocking", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<UserBlocking>( Id);
        }
    }
}
