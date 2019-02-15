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
    public class ReminderMailClass : IJob
    {
        public Task Execute(IJobExecutionContext context)
        {
            List<Job> _PendingList = new List<Job>();
            JobModel _JobModelObj = new JobModel();
            _PendingList = _JobModelObj.GetPendingJobsForApproval(new Job());
            if(_PendingList!=null && _PendingList.Count()>0)
            {
                foreach (var item in _PendingList)
                {
                    if (MatchBxCommon.sendPendingApprovalEmailToAdmin(1, item.JobTitle, item.JobId, item.Email,item.CreatedDateDisplay) == 1)
                    {
                        ReminderMails obj = new ReminderMails();
                        obj.JobId = item.JobId;
                        ReminderMailsModel ReminderObj = new ReminderMailsModel();
                        ReminderObj.Save(obj);
                    }
                }
            }
            return Task.FromResult<object>(null);
        }
    }
}