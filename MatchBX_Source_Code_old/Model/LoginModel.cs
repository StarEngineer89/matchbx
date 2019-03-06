// created by :Sanu Mohan P
// created date :6/20/2018 1:03:44 PM
// purpose :Business class creation
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;using DBFramework;
namespace Model
{
   public class LoginModel : DBContext
    {
        public Login GetARecord(int Id)
        {
            return base.GetARecord<Login>(Id);
        }
        public List<Login> GetList()
        {
            return base.GetList<Login>();
        }
        public List<Login> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<Login>(Fields, SelectionCriteria);
        }
        public List<Login> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<Login>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(Login _object)
        {
             int _returnValue= base.Save<Login>("spAddEditLogin", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<Login>( Id);
        }
        public Login CheckUserOnlineStatus(int ReceiverId,int SendUserId)
        {
            Login _object = new Login();
            _object.UserId = ReceiverId;
            _object.SendUserId = SendUserId;
            return base.GetCustomFunction<Login>("spCheckUserOnlineStatus", _object).FirstOrDefault();
        }
    }
}
