// created by :Sanu Mohan P
// created date :6/25/2018 5:12:51 PM
// purpose :Trending Tags 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;
using DBFramework;

namespace Model
{
   public class TrendingTagsModel : DBContext
    {
        public TrendingTags GetARecord(int Id)
        {
            return base.GetARecord<TrendingTags>(Id);
        }
        public List<TrendingTags> GetList()
        {
            return base.GetList<TrendingTags>();
        }
        public List<TrendingTags> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<TrendingTags>(Fields, SelectionCriteria);
        }
        public List<TrendingTags> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<TrendingTags>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(TrendingTags _object)
        {
             int _returnValue= base.Save<TrendingTags>("spAddEditTrendingTags", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<TrendingTags>( Id);
        }
        public List<TrendingTags> GetTrendingTags(TrendingTags _object)
        {
            return base.GetCustomFunction<TrendingTags>("spGetTrendingTags", _object);
        }
        public List<TrendingTags> GetTrendingTagsForGig(TrendingTags _object)
        {
            return base.GetCustomFunction<TrendingTags>("spGetTrendingTagsForGig", _object);
        }
    }
}
