// created by :Sanu Mohan P
// created date :7/4/2018 1:18:14 PM
// purpose :Business,Model,Sp creation
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;
using DBFramework;

namespace Model
{
   public class JobBiddingModel : DBContext
    {
        public JobBidding GetARecord(int Id)
        {
            return base.GetARecord<JobBidding>(Id);
        }
        public List<JobBidding> GetList()
        {
            return base.GetList<JobBidding>();
        }
        public List<JobBidding> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<JobBidding>(Fields, SelectionCriteria);
        }
        public List<JobBidding> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<JobBidding>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(JobBidding _object)
        {
             int _returnValue= base.Save<JobBidding>("spAddEditJobBidding", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<JobBidding>( Id);
        }
        public bool JobBidAcceptorDecline(JobBidding _object)
        {
            List<JobBidding> _list = base.GetCustomFunction<JobBidding>("spJobBidAccept", _object);
            return _list.Count > 0 ? true : false;
        }
        public List<JobBidding> LoadJobBiddingDetails(JobBidding _object)
        {
            List<JobBidding> _list = base.GetCustomFunction<JobBidding>("spLoadBidDetails", _object);
            return _list;
        }
        public bool MetaMaskCancel(JobBidding _object)
        {
            List<JobBidding> _list = base.GetCustomFunction<JobBidding>("spMetaMaskCancel", _object);
            return _list.Count > 0 ? true : false;
        }
        public bool CancelBid(JobBidding _obj)
        {
            List<JobBidding> _list = base.GetCustomFunction<JobBidding>("spCancelBid", _obj);
            return _list.Count > 0 ? true : false;
        }
    }
}
