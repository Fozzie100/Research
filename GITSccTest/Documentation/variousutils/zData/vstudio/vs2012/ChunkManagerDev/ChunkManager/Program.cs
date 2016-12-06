using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

//Here is the once-per-application setup information
[assembly: log4net.Config.XmlConfigurator(Watch = true)]

namespace ChunkManager
{
    class Program
    {
        static void Main(string[] args)
        {

            /*
            string ConnectionString = args[0].ToString();
            int RunId = int.Parse(args[1]);
            int Span = int.Parse(args[2]);
            string ChunkingProcess = args[3].ToString();
            string StagingTable = args[4].ToString();
            int MaxThreads = int.Parse(args[5]);
            ChunkManager manager = new ChunkManager(ConnectionString, RunId, Span, ChunkingProcess, StagingTable,MaxThreads);

            */
            ChunkManager manager = new ChunkManager(ParameterHelper.getParametersByName(args, "ConnectionString"),
                                                    int.Parse(ParameterHelper.getParametersByName(args, "Span")),
                                                    ParameterHelper.getParametersByName(args, "ChunkingProcess"),
                                                    ParameterHelper.getParametersByName(args, "StagingTable"),
                                                    int.Parse(ParameterHelper.getParametersByName(args, "MaxThreads")),
                                                    ParameterHelper.getSQLParameters(args));
           manager.ProcessChunks();

            Environment.Exit(0);
        }


    }
}
