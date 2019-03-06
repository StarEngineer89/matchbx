using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;

namespace MatchBX.Hubs
{
    public class NotificationHub : Hub
    {
        public void Hello()
        {
            Clients.All.hello();
        }
        public void Send(int sendUserId, int receiverUserId, string name, string notification, string header, string Url)
        {            
            Business.MatchBXNotification _obj = new Business.MatchBXNotification();
            Model.MatchBXNotificationModel _model = new Model.MatchBXNotificationModel();
            _obj.SenderId = sendUserId;
            _obj.ReceiverId = receiverUserId;
            _obj.Notification = notification;
            _obj.ReadStatus = 0;
            _obj.Header = header;
            _obj.Url = Url;
            _model.Save(_obj);
            //Clients.All.a

            Clients.All.addNewMessageToPage(notification, receiverUserId, sendUserId, "Notification", "", "");
        }      
       
    }
}