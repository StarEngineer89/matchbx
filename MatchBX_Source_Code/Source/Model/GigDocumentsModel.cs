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
   public class GigDocumentsModel : DBContext
    {
        public GigDocuments GetARecord(int Id)
        {
            return base.GetARecord<GigDocuments>(Id);
        }
        public List<GigDocuments> GetList()
        {
            return base.GetList<GigDocuments>();
        }
        public List<GigDocuments> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<GigDocuments>(Fields, SelectionCriteria);
        }
        public List<GigDocuments> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<GigDocuments>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(GigDocuments _object)
        {
             int _returnValue= base.Save<GigDocuments>("spAddEditGigDocuments", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<GigDocuments>( Id);
        }
    }
}
