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
   public class GigModel : DBContext
    {
        public Gig GetARecord(int Id)
        {
            return base.GetARecord<Gig>(Id);
        }
        public List<Gig> GetList()
        {
            return base.GetList<Gig>();
        }
        public List<Gig> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<Gig>(Fields, SelectionCriteria);
        }
        public List<Gig> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<Gig>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(Gig _object)
        {
             int _returnValue= base.Save<Gig>("spAddEditGig", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<Gig>( Id);
        }
        public List<Gig> GetGigPost(int gigid)
        {
            Gig _object = new Gig();
            _object.GigId = gigid;
            return base.GetCustomFunction<Gig>("spLoadGig", _object);
        }
        public List<GigSkillsMapping> GetSkillsByGigId(int gigid)
        {
            GigSkillsMapping _object = new GigSkillsMapping();
            _object.GigId = gigid;
            return base.GetCustomFunction<GigSkillsMapping>("spLoadSkillsByGigId", _object);
        }
        public List<GigTrendingTagsMapping> GetTagsByGigId(int gigid)
        {
            GigTrendingTagsMapping _object = new GigTrendingTagsMapping();
            _object.GigId = gigid;
            return base.GetCustomFunction<GigTrendingTagsMapping>("spLoadTagsByGigId", _object);
        }
        public List<GigDocuments> GetDocumentsByGigId(int gigid)
        {
            GigDocuments _object = new GigDocuments();
            _object.GigId = gigid;
            return base.GetCustomFunction<GigDocuments>("spLoadDocumentsByGigId", _object);
        }
        public int SaveWithTransaction(Gig _object)
        {
            _object.WithTransaction = "Y";
            int _returnValue = base.SaveWithTransaction<Gig>("spAddEditGig", _object);
            return _returnValue;
        }
        public List<Gig> GetGigReview(Gig _object)

        {
            return base.GetCustomFunction<Gig>("spGigReview", _object);
        }
        public List<Gig> GetUserGigs(int userId)
        {
            Gig _object = new Gig();
            _object.UserId = userId;
            return base.GetCustomFunction<Gig>("spGetGigDetailsForUser", _object);
        }
        public List<Gig> GetGigDetails(Gig _object)
        {
            return base.GetCustomFunction<Gig>("spGetGigDetails", _object);
        }
        public List<Gig> GetTopJobSeekers(Gig _object)
        {
            return base.GetCustomFunction<Gig>("spGetTopJobSeekers", _object);
        }
        public List<Gig> GetAutomatedGigForTrendingTags(Gig _object)
        {

            return base.GetCustomFunction<Gig>("spGetAutomatedGigForTrendingTags", _object);
        }
        public List<Gig> GetAutomatedGigsForGigReview(Gig _object)
        {
            return base.GetCustomFunction<Gig>("spGetAutomatedSearchForGigReview", _object);
        }
        public int UpdateGigStatus(Gig _obj)
        {
            int _retValue = base.SaveWithTransaction<Gig>("spSetGigStatus", _obj);
            return _retValue;
        }
        public int SetGigSubsription(Gig _obj)
        {
            int _retValue = base.SaveWithTransaction<Gig>("spAcceptOrDeclineGigSubscription", _obj);
            return _retValue;
        }
        public List<Gig> GetGigDetailsProfile(Gig _object)
        {
            return base.GetCustomFunction<Gig>("spGetGigDetailsProfile", _object);
        }
        public List<Gig> GetGigForApproval(Gig _object)
        {
            return base.GetCustomFunction<Gig>("spReviewReminderMailsGig", _object);
        }
        public int CancelGigSubsription(Gig _obj)
        {
            int _retValue = base.SaveWithTransaction<Gig>("spCancelGigSubscription", _obj);
            return _retValue;
        }
        public List<Gig> GetPurchasedGig(Gig _object)
        {
            return base.GetCustomFunction<Gig>("spGetPurchasedGig", _object);
        }
        public List<Gig> GetMyServices(Gig _obj)
        {
            return base.GetCustomFunction<Gig>("spGetDashboardServiceDetails", _obj);
        }
        public List<Gig> GetPurchasedServices(Gig _obj)
        {
            return base.GetCustomFunction<Gig>("spGetDashboardPurchaseDetails", _obj);
        }
    }

}
