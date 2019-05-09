// created by :Prazeed
// created date :7/21/2018 3:24:43 PM
// purpose :Messgae
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;
using DBFramework;
namespace Model
{
   public class MatchBXMessageModel : DBContext
    {
        public MatchBXMessage GetARecord(int Id)
        {
            return base.GetARecord<MatchBXMessage>(Id);
        }
        public List<MatchBXMessage> GetList()
        {
            return base.GetList<MatchBXMessage>();
        }
        public List<MatchBXMessage> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<MatchBXMessage>(Fields, SelectionCriteria);
        }
        public List<MatchBXMessage> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<MatchBXMessage>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(MatchBXMessage _object)
        {
             int _returnValue= base.Save<MatchBXMessage>("spAddEditMatchBXMessage", _object);
             return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<MatchBXMessage>( Id);
        }
        public List<MatchBXMessage> GetChatMessage(int ReceiverId, int SendUserId,int messageJobId)
        {
            MatchBXMessage _object = new MatchBXMessage();
            _object.ReceiverId = ReceiverId;
            _object.SendUserId = SendUserId;
            _object.JobId = messageJobId;
            return base.GetCustomFunction<MatchBXMessage>("spGetChatMessage", _object);
        }
        public List<MatchBXMessage> GetAllChatMessage(int ReceiverId)
        {
            MatchBXMessage _object = new MatchBXMessage();
            _object.ReceiverId = ReceiverId;
            _object.JobId = 0;
            return base.GetCustomFunction<MatchBXMessage>("spGetAllChatMessage", _object);
        }

        public List<MatchBXMessage> ChangeReadStatus(MatchBXMessage _object)
        {
            return base.GetCustomFunction<MatchBXMessage>("spMessageReadStatus", _object);
        }
        public List<MatchBXMessage> GetProjectMessages(int ReceiverId)
        {
            MatchBXMessage _object = new MatchBXMessage();
            _object.ReceiverId = ReceiverId;
            _object.JobId = 0;
            return base.GetCustomFunction<MatchBXMessage>("spGetAllProjectMessage", _object);
        }
        public Users GetMessageStatus(int SenderId)
        {
            Users _object = new Users();
            _object.UserId = SenderId;
            var result = base.GetCustomFunction<Users>("spGetMessageStatus", _object);
            return result.FirstOrDefault();
        }
    }
}
