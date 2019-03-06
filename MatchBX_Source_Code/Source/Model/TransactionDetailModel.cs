// created by :Sanu Mohan P
// created date :8/13/2018 3:36:31 PM
// purpose :Transaction details
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;
using DBFramework;

namespace Model
{
   public class TransactionDetailModel : DBContext
    {
        public TransactionDetail GetARecord(int Id)
        {
            return base.GetARecord<TransactionDetail>(Id);
        }
        public List<TransactionDetail> GetList()
        {
            return base.GetList<TransactionDetail>();
        }
        public List<TransactionDetail> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<TransactionDetail>(Fields, SelectionCriteria);
        }
        public List<TransactionDetail> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<TransactionDetail>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(TransactionDetail _object)
        {
             int _returnValue= base.Save<TransactionDetail>("spAddEditTransactionDetail", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<TransactionDetail>( Id);
        }
        public bool UpdateTransactionDetail(TransactionDetail _object)
        {
            List<TransactionDetail> _list = base.GetCustomFunction<TransactionDetail>("spUpdateTransactionDetail", _object);
            return _list.Count > 0 ? true : false;
        }
        public  List<TransactionDetail> CheckApprovedAmount(TransactionDetail _object)
        {            
            List<TransactionDetail> _list = base.GetCustomFunction<TransactionDetail>("spCheckApprovedAmount", _object);
            return _list;
        }
        public int UpdateApprovalTransaction(TransactionDetail _object)
        {
            int _returnValue = base.Save<TransactionDetail>("spUpdateApprovalTransaction", _object);
            return _returnValue;
        }
        public int ResetWalletAddress(TransactionDetail _object)
        {
            int _returnValue = base.Save<TransactionDetail>("spResetWalletAddress", _object);
            return _returnValue;
        }
    }
}
