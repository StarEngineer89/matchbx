// created by :Sanu Mohan P
// created date :10/31/2018 12:24:13 PM
// purpose :ReminderMails
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;
using DBFramework;
namespace Model
{
   public class ReminderMailsModel : DBContext
    {
        public ReminderMails GetARecord(int Id)
        {
            return base.GetARecord<ReminderMails>(Id);
        }
        public List<ReminderMails> GetList()
        {
            return base.GetList<ReminderMails>();
        }
        public List<ReminderMails> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<ReminderMails>(Fields, SelectionCriteria);
        }
        public List<ReminderMails> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<ReminderMails>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(ReminderMails _object)
        {
             int _returnValue= base.Save<ReminderMails>("spAddEditReminderMails", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<ReminderMails>( Id);
        }
    }
}
