// created by :Sanu Mohan P
// created date :7/27/2018 4:46:52 PM
// purpose :MatchBX notifications
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;
using DBFramework;
namespace Model
{
   public class MatchBXNotificationModel : DBContext
    {
        public MatchBXNotification GetARecord(int Id)
        {
            return base.GetARecord<MatchBXNotification>(Id);
        }
        public List<MatchBXNotification> GetList()
        {
            return base.GetList<MatchBXNotification>();
        }
        public List<MatchBXNotification> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<MatchBXNotification>(Fields, SelectionCriteria);
        }
        public List<MatchBXNotification> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<MatchBXNotification>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(MatchBXNotification _object)
        {
             int _returnValue= base.Save<MatchBXNotification>("spAddEditMatchBXNotification", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<MatchBXNotification>( Id);
        }
        public List<MatchBXNotification> GetNotificationsForReceiver(int id)
        {
            MatchBXNotification _obj = new MatchBXNotification();
            _obj.ReceiverId = id;
            return base.GetCustomFunction<MatchBXNotification>("spGetNotifications", _obj);
        }
        public bool SetNotificationsReadStatus(MatchBXNotification _object)
        {
            List<MatchBXNotification> _list = base.GetCustomFunction<MatchBXNotification>("spSetNotificationsReadStatus", _object);
            return _list.Count > 0 ? true : false;
        }
    }
}
