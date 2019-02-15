// created by :Sanu Mohan P
// created date :8/8/2018 7:03:00 PM
// purpose :
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;
using DBFramework;
namespace Model
{
   public class TokenDistributionModel : DBContext
    {
        public TokenDistribution GetARecord(int Id)
        {
            return base.GetARecord<TokenDistribution>(Id);
        }
        public List<TokenDistribution> GetList()
        {
            return base.GetList<TokenDistribution>();
        }
        public List<TokenDistribution> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<TokenDistribution>(Fields, SelectionCriteria);
        }
        public List<TokenDistribution> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<TokenDistribution>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(TokenDistribution _object)
        {
             int _returnValue= base.Save<TokenDistribution>("spAddEditTokenDistribution", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<TokenDistribution>( Id);
        }
    }
}
