// created by :Sanu Mohan P
// created date :2/6/2019 5:58:59 PM
// purpose :Gig review
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;
using DBFramework;

namespace Model
{
   public class GigReviewModel : DBContext
    {
        public GigReview GetARecord(int Id)
        {
            return base.GetARecord<GigReview>(Id);
        }
        public List<GigReview> GetList()
        {
            return base.GetList<GigReview>();
        }
        public List<GigReview> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<GigReview>(Fields, SelectionCriteria);
        }
        public List<GigReview> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<GigReview>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(GigReview _object)
        {
             int _returnValue= base.Save<GigReview>("spAddEditGigReview", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<GigReview>( Id);
        }
        public List<GigReview> GetReviewForGig(int gigid)
        {
            GigReview _object = new GigReview();
            _object.GigId = gigid;
            return base.GetCustomFunction<GigReview>("spGetReviewForGig", _object);
        }
        public List<GigReview> GigReviewAdmin(string sortby)
        {
            GigReview _object = new GigReview();
            _object.SortBy = sortby;
            return base.GetCustomFunction<GigReview>("spGigReviewAdmin", _object);
        }
    }
}
