using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace MatchBX
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "Jobs", action = "Index", id = UrlParameter.Optional }
            );
            //routes.MapRoute(
            //    name: "CryptoExchange",
            //    url: "{Profile}/{CryptoExchange}/{id}",
            //    defaults: new { controller = "Profile", action = "CryptoExchange", id = UrlParameter.Optional }
            //);
        }
    }
}
