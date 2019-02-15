using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;using DBFramework;using DBFramework;
using DBFramework;

namespace Model
{
    public class AdminFeatureModel:DBContext
    {
        public List<AdminFeatures> GetAdminDashboard(AdminFeatures _object)
        {
            return base.GetCustomFunction<AdminFeatures>("spGetAdminDashboard", _object);
      
        }

        public List<ManageJob> GetManageJob(ManageJob _object)
        {
            return base.GetCustomFunction<ManageJob>("spManageJobs", _object);

        }

        //For analytics
        public List<UserDetails> GetUserDetails()
        {
            var _object = new UserDetails();
            return base.GetCustomFunction<UserDetails>("spAnalyticsUsers", _object);
        }
        public List<LoginDetails> GetLoginDetails()
        {
            var _object = new LoginDetails();
            return base.GetCustomFunction<LoginDetails>("spAnalyticsLogin", _object);
        }
        public List<JobDetails> GetJobDetails()
        {
            var _object = new JobDetails();
            return base.GetCustomFunction<JobDetails>("spAnalyticsJobDetail", _object);
        }
        public List<BidDetails> GetBidDetails()
        {
            var _object = new BidDetails();
            return base.GetCustomFunction<BidDetails>("spAnalyticsJobBidding", _object);
        }
        //End of analytics
    }
}