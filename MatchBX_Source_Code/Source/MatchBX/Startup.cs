using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(MatchBX.Startup))]
namespace MatchBX
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
            //app.MapSignalR();
        }
    }
}
