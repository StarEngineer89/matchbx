// created by :Sanu Mohan P
// created date :1/18/2019 12:24:47 PM
// purpose :Model Business layer 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;using DBFramework;using DBFramework;using DBFramework;
using DBFramework;

namespace Model
{
   public class AjaxSessionModel : DBContext
    {
        public AjaxSession GetARecord(int Id)
        {
            return base.GetARecord<AjaxSession>(Id);
        }
        public List<AjaxSession> GetList()
        {
            return base.GetList<AjaxSession>();
        }
        public List<AjaxSession> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<AjaxSession>(Fields, SelectionCriteria);
        }
        public List<AjaxSession> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<AjaxSession>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(AjaxSession _object)
        {
             int _returnValue= base.Save<AjaxSession>("spAddEditAjaxSession", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<AjaxSession>( Id);
        }
    }
}
