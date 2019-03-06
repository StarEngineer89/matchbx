// created by :Sanu Mohan P
// created date :8/15/2018 6:28:45 PM
// purpose :Contract details
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;
using DBFramework;

namespace Model
{
   public class ContractDetailModel : DBContext
    {
        public ContractDetail GetARecord(int Id)
        {
            return base.GetARecord<ContractDetail>(Id);
        }
        public List<ContractDetail> GetList()
        {
            return base.GetList<ContractDetail>();
        }
        public List<ContractDetail> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<ContractDetail>(Fields, SelectionCriteria);
        }
        public List<ContractDetail> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<ContractDetail>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(ContractDetail _object)
        {
             int _returnValue= base.Save<ContractDetail>("spAddEditContractDetail", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<ContractDetail>( Id);
        }
    }
}
