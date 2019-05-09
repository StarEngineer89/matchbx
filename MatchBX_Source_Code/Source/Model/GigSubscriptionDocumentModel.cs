// created by :Sanu Mohan P
// created date :1/7/2019 3:06:14 PM
// purpose :Model,Business classes
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;
using DBFramework;
namespace Model
{
   public class GigSubscriptionDocumentModel : DBContext
    {
        public GigSubscriptionDocument GetARecord(int Id)
        {
            return base.GetARecord<GigSubscriptionDocument>(Id);
        }
        public List<GigSubscriptionDocument> GetList()
        {
            return base.GetList<GigSubscriptionDocument>();
        }
        public List<GigSubscriptionDocument> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<GigSubscriptionDocument>(Fields, SelectionCriteria);
        }
        public List<GigSubscriptionDocument> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<GigSubscriptionDocument>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(GigSubscriptionDocument _object)
        {
             int _returnValue= base.Save<GigSubscriptionDocument>("spAddEditGigSubscriptionDocument", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<GigSubscriptionDocument>( Id);
        }
    }
}
