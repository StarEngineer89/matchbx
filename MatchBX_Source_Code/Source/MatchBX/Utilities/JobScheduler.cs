using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Quartz;
using Quartz.Impl;

namespace MatchBX.Utilities
{
    public class JobScheduler
    {

        public static void Start()
        {
            IScheduler scheduler = StdSchedulerFactory.GetDefaultScheduler().GetAwaiter().GetResult();
            scheduler.Start();
            // define the job and tie it to our HelloJob class
            IJobDetail CoinMarketjob = JobBuilder.Create<CoinMarketClass>()
                .WithIdentity("getrate", "group1")
                .Build();
            // Trigger the job to run now, and then every 40 seconds
            ITrigger triggerCoinMarket = TriggerBuilder.Create()
              .WithIdentity("exchangerate", "group1")
              .StartNow()
              .WithSimpleSchedule(x => x
                  .WithIntervalInSeconds(60)
                  .RepeatForever())
              .Build();


            IJobDetail Reminderjob = JobBuilder.Create<ReminderMailClass>()
            .WithIdentity("remindermail", "group2")
            .Build();
            ITrigger triggerReminder = TriggerBuilder.Create()
           .WithIdentity("reminder", "group2")
           .StartNow()
           .WithSimpleSchedule(x => x
               .WithIntervalInSeconds(80)
               .RepeatForever())
           .Build();

            IJobDetail ReminderGig = JobBuilder.Create<GigReminderMailClass>()
         .WithIdentity("remindermailGig", "group3")
         .Build();
            ITrigger triggerReminderGig = TriggerBuilder.Create()
           .WithIdentity("reminderGig", "group3")
           .StartNow()
           .WithSimpleSchedule(x => x
               .WithIntervalInSeconds(180)
               .RepeatForever())
           .Build();

            scheduler.ScheduleJob(CoinMarketjob, triggerCoinMarket);
            scheduler.ScheduleJob(Reminderjob, triggerReminder);
            //scheduler.ScheduleJob(ReminderGig, triggerReminderGig);
        }
    }
}