// created by :Sanu Mohan P
// created date :6/25/2018 12:49:12 PM
// purpose :MatchBX
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;
using DBFramework;

namespace Model
{
   public class JobModel : DBContext
    {
        public Job GetARecord(int Id)
        {
            return base.GetARecord<Job>(Id);
        }
        public List<Job> GetList()
        {
            return base.GetList<Job>();
        }
        public List<Job> GetList(string Fields, string SelectionCriteria)
        {
            return base.GetList<Job>(Fields, SelectionCriteria);
        }
        public List<Job> GetListFromView(string Fields, string SelectionCriteria,string ViewName)
        {
            return base.GetListFromView<Job>(Fields, SelectionCriteria,ViewName);
        }
        public int Save(Job _object)
        {
             int _returnValue= base.Save<Job>("spAddEditJob", _object);
             return _returnValue;
        }
        public int SaveWithTransaction(Job _object)
        {
            _object.WithTransaction = "Y";
            int _returnValue = base.SaveWithTransaction<Job>("spAddEditJob", _object);
            return _returnValue;
        }
        public bool DeleteRecord(int Id)
        {
            return base.DeleteRecord<Job>( Id);
        }
        public List<Job> GetJobDetails(Job _object)
        {
           
            return base.GetCustomFunction<Job>("spGetJobDetails", _object);
        }
        public List<Job> GetTopJobPosters(Job _object)
        {
            return base.GetCustomFunction<Job>("spGetTopJobPosters", _object);
        }
        
        public List<Job> GetJobPost(int jobid)
        {
            Job _object = new Job();
            _object.JobId = jobid;
            return base.GetCustomFunction<Job>("spLoadJob", _object);
        }
        public List<JobDocuments> GetDocumentsByJobId(int jobid)
        {
            JobDocuments _object = new JobDocuments();
            _object.JobId = jobid;
            return base.GetCustomFunction<JobDocuments>("spLoadDocumentsByJobId", _object);
        }
        public List<JobTrendingTagsMapping> GetTagsByJobId(int jobid)
        {
            JobTrendingTagsMapping _object = new JobTrendingTagsMapping();
            _object.JobId = jobid;
            return base.GetCustomFunction<JobTrendingTagsMapping>("spLoadTagsByJobId", _object);
        }
        public List<JobSkillsMapping> GetSkillsByJobId(int jobid)
        {
            JobSkillsMapping _object = new JobSkillsMapping();
            _object.JobId = jobid;
            return base.GetCustomFunction<JobSkillsMapping>("spLoadSkillsByJobId", _object);
        }
        public List<Skills> GetTopSkills(int JobCategoryId)
        {
            Skills _object = new Skills();
            _object.JobCategoryId = JobCategoryId;
            return base.GetCustomFunction<Skills>("spGetSkills", _object);
        }
        public List<TrendingTags> GetTrendingTags(int JobCategoryId)
        {
            TrendingTags _object = new TrendingTags();
            _object.JobCategoryId = JobCategoryId;
            return base.GetCustomFunction<TrendingTags>("spGetTrendingTags", _object);
        }
        public List<Job> GetJobDetailsForUser(Job _object)
        {
            return base.GetCustomFunction<Job>("spGetJobDetailsForUser", _object);
        }

        public int DeleteJob(Job _object)
        {
            int _returnValue = base.Save<Job>("spDeleteJob", _object);
            return _returnValue;
        }

        public List<Skills> GetSkills()
        {
            Skills _object = new Skills();
            return base.GetCustomFunction<Skills>("spGetAllSkills", _object);
        }


        public List<JobCancellation > GetJobCancelList()
        {
            return base.GetList<JobCancellation>();
        }

        public List<Job> GetJobAnalytics()
        {
            Job _obj = new Job();
            return base.GetCustomFunction<Job>("spJobAnalytics ", _obj);
        }
        public List<Job> GetAutomatedJobsForTrendingTags(Job _object)
        {
         
            return base.GetCustomFunction<Job>("spGetAutomatedJobsForTrendingTags", _object);
        }
        public List<Job> CheckPendingTransactions(Job _object)
        {
            return base.GetCustomFunction<Job>("spPendingTransaction", _object);                                  
        }
        public List<Job> GetJobReview(Job _object)        {
                      
            return base.GetCustomFunction<Job>("spJobReview", _object);
        }
        public List<Job> GetAutomatedJobsForJobReview(Job _object)
        {
            return base.GetCustomFunction<Job>("spGetAutomatedSearchForJobReview", _object);
        }
        public List<Job> GetPendingJobsForApproval(Job _object)
        {
            return base.GetCustomFunction<Job>("spReviewReminderMails", _object);
        }
        public List<Job> GetVerifiedPartners(Job _object)
        {
            return base.GetCustomFunction<Job>("spGetVerifiedPartners", _object);
        }
        public List<Job> GetMyJobs(Job _obj)
        {
            return base.GetCustomFunction<Job>("spGetDashboardJobs", _obj);
        }
        public List<Job> GetJobsBidOn(Job _obj)
        {
            return base.GetCustomFunction<Job>("spGetDashboardJobsBid", _obj);
        }
        public List<Job> GetCurrentBidsForJob(Job _object)
        {
            return base.GetCustomFunction<Job>("spGetJobBiddingDetails", _object);
        }

    }
}
