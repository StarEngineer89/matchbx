// created by :Sanu Mohan P
// created date :1/7/2019 3:06:15 PM
// purpose :Model,Business classes
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;
using DBFramework;

namespace Model
{
   public class GigTrendingTagsMappingModel : DBContext
    {
        public GigTrendingTagsMapping GetARecord(int Id)
        {
            return base.GetARecord<GigTrendingTagsMapping>(Id);
        }
        public List<GigTrendingTagsMapping> GetList()
        {
            return base.GetList<GigTrendingTagsMapping>();
        }
        public List<GigTrendingTagsMapping> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<GigTrendingTagsMapping>(Fields, SelectionCriteria);
        }
        public List<GigTrendingTagsMapping> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<GigTrendingTagsMapping>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(GigTrendingTagsMapping _object)
        {
             int _returnValue= base.Save<GigTrendingTagsMapping>("spAddEditGigTrendingTagsMapping", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<GigTrendingTagsMapping>( Id);
        }
    }
}
