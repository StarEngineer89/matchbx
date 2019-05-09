// created by :Sanu Mohan P
// created date :1/21/2019 3:56:26 PM
// purpose :Gig reminder mail
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;
using DBFramework;
namespace Model
{
   public class ReminderMailsGigModel : DBContext
    {
        public ReminderMailsGig GetARecord(int Id)
        {
            return base.GetARecord<ReminderMailsGig>(Id);
        }
        public List<ReminderMailsGig> GetList()
        {
            return base.GetList<ReminderMailsGig>();
        }
        public List<ReminderMailsGig> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<ReminderMailsGig>(Fields, SelectionCriteria);
        }
        public List<ReminderMailsGig> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<ReminderMailsGig>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(ReminderMailsGig _object)
        {
             int _returnValue= base.Save<ReminderMailsGig>("spAddEditReminderMailsGig", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<ReminderMailsGig>( Id);
        }
    }
}
