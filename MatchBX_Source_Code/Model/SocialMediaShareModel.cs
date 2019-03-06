// created by :Sanu Mohan P
// created date :7/31/2018 11:29:35 AM
// purpose :Social media share
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;
using DBFramework;
namespace Model
{
   public class SocialMediaShareModel : DBContext
    {
        public SocialMediaShare GetARecord(int Id)
        {
            return base.GetARecord<SocialMediaShare>(Id);
        }
        public List<SocialMediaShare> GetList()
        {
            return base.GetList<SocialMediaShare>();
        }
        public List<SocialMediaShare> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<SocialMediaShare>(Fields, SelectionCriteria);
        }
        public List<SocialMediaShare> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<SocialMediaShare>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(SocialMediaShare _object)
        {
             int _returnValue= base.Save<SocialMediaShare>("spAddEditSocialMediaShare", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<SocialMediaShare>( Id);
        }
        public SocialMediaShare GetShareDetails(int jobId, int userId)
        {
            SocialMediaShare shareObj = new SocialMediaShare();
            shareObj.JobId = jobId;
            shareObj.UserId = userId;
            return GetCustomFunction<SocialMediaShare>("spGetShareDetails", shareObj).FirstOrDefault();
        }
    }
}
