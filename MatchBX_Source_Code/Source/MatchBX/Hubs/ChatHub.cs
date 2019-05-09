using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;
using MatchBx.Utilities;
namespace MatchBX.Hubs
{
    public class ChatHub : Hub
    {
        public void Hello()
        {
            Clients.All.hello();
        }
      
        public void Send(int sendUserId, int receiverUserId,  string roomId, string message, string type, decimal filesize, string filename,int messagejobID)
        {                       
            Business.MatchBXMessage _obj = new Business.MatchBXMessage();
            Model.MatchBXMessageModel _model = new Model.MatchBXMessageModel();
            _obj.SendUserId = sendUserId;
            _obj.ReceiverId = receiverUserId;
            _obj.Message = message;
            _obj.MessageType = type;
            _obj.FileSize = filesize;
            _obj.FileName = filename;
            _obj.JobId = messagejobID;
            _model.Save(_obj);

            Model.LoginModel _objLoginModel = new Model.LoginModel();
            Business.Login _objLogin = new Business.Login();
            _objLogin = _objLoginModel.CheckUserOnlineStatus(receiverUserId, sendUserId);

            Clients.All.addNewMessageToPage(message, receiverUserId, sendUserId, "Chat", _objLogin.IsOnline, roomId, type, filesize, filename,_objLogin.ProfilePic);
            if (_objLogin.IsMailSent == 0)
            {
                MatchBxCommon.OfflineMessageMail(sendUserId, receiverUserId, _model.Id);
            }
        }
        //public void Send(int sendUserId, int receiverUserId, string roomId, string type,string label)
        //{
        //    // Clients.Client(connId).addNewMessageToPage( message, receiverUserId, sendUserId);
        //    Clients.All.addNewMessageToPage("", receiverUserId, sendUserId, type,"", roomId);
        //}
    }
}