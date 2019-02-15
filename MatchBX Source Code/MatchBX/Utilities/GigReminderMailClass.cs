using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Quartz;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;
using Model;
using Business;
using MatchBx.Utilities;

namespace MatchBX.Utilities
{
    public class GigReminderMailClass : IJob
    {
        public Task Execute(IJobExecutionContext context)

        {
            List<Gig> _PendingList = new List<Gig>();
            GigModel _GigModelObj = new GigModel();
            _PendingList = _GigModelObj.GetGigForApproval(new Gig());
            if (_PendingList != null && _PendingList.Count() > 0)
            {
                foreach (var item in _PendingList)
                {
                    if (MatchBxCommon.sendPendingGigApprovalEmailToAdmin(1, item.GigTitle, item.GigId, item.Email, item.CreatedDateDisplay) == 1)
                    {
                        ReminderMailsGig obj = new ReminderMailsGig();
                        obj.GigId = item.GigId;
                        ReminderMailsGigModel ReminderObj = new ReminderMailsGigModel();
                        ReminderObj.Save(obj);
                    }
                }
            }
            return Task.FromResult<object>(null);
        }
    }
}