using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Business;
using DBFramework;
namespace Model
{
    public class ArbitrationModel : DBContext
    {
        public int Save(JobArbitration _object)
        {
            int _returnValue = base.Save<JobArbitration>("spAddEditArbitration", _object);
            return _returnValue;
        }
    }
}