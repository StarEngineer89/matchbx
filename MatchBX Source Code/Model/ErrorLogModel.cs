// created by :Sanu Mohan P
// created date :6/20/2018 7:40:21 PM
// purpose :Model class added
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;using DBFramework;using DBFramework;
namespace Model
{
   public class ErrorLogModel : DBContext
    {
        public ErrorLog GetARecord(int Id)
        {
            return base.GetARecord<ErrorLog>(Id);
        }
        public List<ErrorLog> GetList()
        {
            return base.GetList<ErrorLog>();
        }
        public List<ErrorLog> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<ErrorLog>(Fields, SelectionCriteria);
        }
        public List<ErrorLog> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<ErrorLog>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(ErrorLog _object)
        {
             int _returnValue= base.Save<ErrorLog>("spAddEditErrorLog", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<ErrorLog>( Id);
        }
    }
}
