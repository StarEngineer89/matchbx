using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Quartz;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;

namespace MatchBX.Utilities
{
    public class CoinMarketClass : IJob
    {
        public Task Execute(IJobExecutionContext context)
        {
            decimal exchangerate;
            JobKey key = context.JobDetail.Key;
            JobDataMap dataMap = context.JobDetail.JobDataMap;
            string jobSays = dataMap.GetString("jobSays");
            using (var client = new WebClient())
            {
                try
                {
                    client.Headers.Add("content-type", "application/json");//
                    string response = client.DownloadString("https://api.coinmarketcap.com/v2/ticker/2466/?convert=USD");
                    dynamic dynamicObject = Newtonsoft.Json.JsonConvert.DeserializeObject(response);
                    exchangerate = Convert.ToDecimal(dynamicObject.data.quotes.USD.price);
                    HttpContext.Current.Session["CurrentAXPRrate"] = exchangerate;
                }
                catch (Exception e)
                {
                    exchangerate = 0.001m;
                    //HttpContext.Current.Session["CurrentAXPRrate"] = exchangerate;

                }

            }
            return Task.FromResult<object>(null);
        }
    }
}