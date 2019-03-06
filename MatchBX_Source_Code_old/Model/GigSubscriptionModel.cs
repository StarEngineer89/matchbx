// created by :Sanu Mohan P
// created date :1/7/2019 3:06:14 PM
// purpose :Model,Business classes
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;using DBFramework;
namespace Model
{
   public class GigSubscriptionModel : DBContext
    {
        public GigSubscription GetARecord(int Id)
        {
            return base.GetARecord<GigSubscription>(Id);
        }
        public List<GigSubscription> GetList()
        {
            return base.GetList<GigSubscription>();
        }
        public List<GigSubscription> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<GigSubscription>(Fields, SelectionCriteria);
        }
        public List<GigSubscription> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<GigSubscription>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(GigSubscription _object)
        {
             int _returnValue= base.Save<GigSubscription>("spAddEditGigSubscription", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<GigSubscription>( Id);
        }
        public int SaveWithTransaction(GigSubscription _object)
        {
            _object.WithTransaction = "Y";
            int _returnValue = base.SaveWithTransaction<GigSubscription>("spAddEditGigSubscription", _object);
            return _returnValue;
        }        
        public List<GigSubscription> GigOfferAcceptorDecline(GigSubscription _object)
        {
            List<GigSubscription> _list = base.GetCustomFunction<GigSubscription>("spGigPayAccept", _object);
            return _list;
        }
        public List<GigSubscription> LoadSubscriptionDetails(GigSubscription _object)
        {
            List<GigSubscription> _list = base.GetCustomFunction<GigSubscription>("spLoadSubscriptionDetails", _object);
            return _list;
        }
    }
}
