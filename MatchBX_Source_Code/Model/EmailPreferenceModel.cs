// created by :Sanu Mohan P
// created date :6/25/2018 12:49:12 PM
// purpose :MatchBX
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;using DBFramework;using DBFramework;
namespace Model
{
   public class EmailPreferenceModel : DBContext
    {
        public EmailPreference GetARecord(int Id)
        {
            return base.GetARecord<EmailPreference>(Id);
        }
        public List<EmailPreference> GetList()
        {
            return base.GetList<EmailPreference>();
        }
        public List<EmailPreference> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<EmailPreference>(Fields, SelectionCriteria);
        }
        public List<EmailPreference> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<EmailPreference>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(EmailPreference _object)
        {
             int _returnValue= base.Save<EmailPreference>("spAddEditEmailPreference", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<EmailPreference>( Id);
        }
    }
}
