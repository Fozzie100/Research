using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading;
using System.Collections.Concurrent;
using System.Collections;

namespace ChunkManager
{
    public class ChunkManager
    {
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        private string _ConnectionString;
        private int _Span;
        private string _ChunkingProcess;
        private string _StagingTable;
        private int _MaxThreads;
        private Dictionary<string, string> _SQLParameters;





        public ChunkManager(string ConnectionString, int Span, string ChunkingProcess, string StagingTable, int MaxThreads, Dictionary<string, string> SQLParameters)
        {
            _ConnectionString = ConnectionString;
            _Span = Span;
            _ChunkingProcess = ChunkingProcess;
            _StagingTable = StagingTable;
            _MaxThreads = MaxThreads;
            _SQLParameters = SQLParameters;

            log.Info("ConnectionString:" + _ConnectionString);
            log.Info("Span:" + _Span.ToString());
            log.Info("ChunkingProcess:" + _ChunkingProcess);
            log.Info("StagingTable:" + _StagingTable);
            log.Info("MaxThreads:" + _MaxThreads.ToString());

        }

        public void ProcessChunks()
        {
            List<ManualResetEvent> doneEvents = new List<ManualResetEvent>();
            List<ChunkProcessor> processors = new List<ChunkProcessor>();
            DataAccess dataAccess = new DataAccess(_ConnectionString);
            dataAccess.ThreadId = 99;
            int totalRows = dataAccess.GetRowsForRun(_SQLParameters, _StagingTable);
            log.Info("There are " + totalRows.ToString() + " to process in Staging Table " + _StagingTable);
            int startRow = 1;
            int endRow = 0;
            int ix = 0;
            int count = 0;
            bool isLastChunk = false;
            ThreadPool.SetMaxThreads(_MaxThreads, _MaxThreads);
            int batchID = 0;
            
            while (true)
            {

                while (startRow <= totalRows)
                {

                    endRow = startRow + _Span - 1;
                    if (endRow > totalRows)
                    {
                        endRow = totalRows;
                        isLastChunk = true;
                    }

                    batchID++;
                    doneEvents.Add(new ManualResetEvent(false));
                    //Call chunking stored procedure here
                    ChunkProcessor processor = new ChunkProcessor(_ConnectionString, _ChunkingProcess, startRow, endRow, _SQLParameters, doneEvents[ix], _StagingTable, batchID);
                    processors.Add(processor);
                    ThreadPool.QueueUserWorkItem(processor.ThreadPoolCallback, ix);

                    

                    startRow = endRow + 1;
                    ix++;
                    count++;
                    if (count == 6 || isLastChunk) //every 4 chunks run a batch
                    {

                        WaitHandle.WaitAll(doneEvents.ToArray());
                        doneEvents.Clear();
                        count = 0;
                        ix = 0;
                    }

                }

                break;
            }
        }
    }
}
