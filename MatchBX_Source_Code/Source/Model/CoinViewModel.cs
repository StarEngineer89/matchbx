using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Model
{
    public class CoinViewModel
    {
        public string id { get; set; }
        public string name { get; set; }
        public string symbol { get; set; }
        public Int64 total_supply { get; set; }
        public Int64 max_supply { get; set; }
        public string last_updated { get; set; }
        public decimal price { get; set; }
        public decimal percent_change_24h { get; set; }

    }
}