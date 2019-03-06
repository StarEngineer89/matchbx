// created by :Sanu Mohan P
// created date :6/20/2018 1:03:44 PM
// purpose :Business class creation
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;
using DBFramework;

namespace Model
{
   public class UsersModel : DBContext
    {
        public Users GetARecord(int Id)
        {
            return base.GetARecord<Users>(Id);
        }
        public List<Users> GetList()
        {
            return base.GetList<Users>();
        }
        public List<Users> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<Users>(Fields, SelectionCriteria);
        }
        public List<Users> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<Users>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(Users _object)
        {
             int _returnValue= base.Save<Users>("spAddEditUsers", _object);
             return _returnValue;
        }
        public int SaveWithTransaction(Users _object)
        {
            int _returnValue = base.SaveWithTransaction<Users>("spAddEditUsers", _object);
            return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<Users>( Id);
        }

        public object GroupBy(Func<object, object> p)
        {
            throw new NotImplementedException();
        }
        public List<Users> GetUserDetails(Users _object)
        {
            return base.GetCustomFunction<Users>("spGetUserDetails", _object);
        }
        public List<Users> GetTransactionDetails(Users _object)
        {
            return base.GetCustomFunction<Users>("spGetTransactionDetails", _object);
        }
        public int ChangeUserRole(Users _object)
        {
            int _returnValue = base.Save<Users>("spUpdateUserRole", _object);
            return _returnValue;
        }
        public int VerifyPartner(int userId, string status)
        {
            Users user = new Users();
            user.UserId = userId;
            user.VerifiedPartner = status;
            int _returnValue = base.SaveWithTransaction<Users>("spVerifyPartner", user);
            return _returnValue;
        }
    }
}
