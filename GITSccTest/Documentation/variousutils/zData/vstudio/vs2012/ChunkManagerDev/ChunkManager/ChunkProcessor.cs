using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;


namespace ChunkManager
{
    public class ChunkProcessor
    {
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        private ManualResetEvent _DoneEvent;
        private string _ConnectionString;
        private string _ChunkingProcess;
        private string _StagingTableName;   //PP
        private int _batchID;    //PP
        private int _StartRow;
        private int _EndRow;
        private Dictionary<string, string> _SQLParameters;

        public ChunkProcessor(string ConnectionString,string ChunkingProcess, int StartRow, int EndRow,Dictionary<string, string> SQLParameters,ManualResetEvent doneEvent, string StagingTableName, int batchID)
        {
            _DoneEvent = doneEvent;
            _ChunkingProcess = ChunkingProcess;
            _StartRow = StartRow;
            _EndRow = EndRow;
            _ConnectionString = ConnectionString;
            _SQLParameters = SQLParameters;
            _StagingTableName = StagingTableName;   //PP
            _batchID = batchID;                     //PP
        }

        public void ThreadPoolCallback(Object threadContext)
        {

            int threadIndex = (int)threadContext;
            log.Info("Thread " + threadIndex.ToString() + "- started");
            ProcessChunk(threadIndex);
            log.Info("Thread " + threadIndex.ToString() + "- comlete");
            _DoneEvent.Set();
        }


        public void ProcessChunk(int ThreadId)
        {
            DataAccess dataAccess = new DataAccess(_ConnectionString);
            dataAccess.ThreadId = ThreadId;

            int retrycount = 0;
            while (true)
            {
                log.Info("Thread " + ThreadId.ToString() + "- Stored Procedure : " + _ChunkingProcess + "  for StartRow : " + _StartRow.ToString() + " EndRow : " + _EndRow.ToString());

                string myRun;   //PP
                _SQLParameters.TryGetValue("@p_run", out myRun);  //PP
                //PP - put in 'R' - Running mode
                dataAccess.BatchControlUpdate(Convert.ToInt32(myRun), _batchID, "R", _StagingTableName, _ChunkingProcess);  //PP
                if (dataAccess.ExecuteChunkingStoredProcedure(_ChunkingProcess,  _StartRow, _EndRow,_SQLParameters) == true)
                {
                   
                    dataAccess.BatchControlUpdate(Convert.ToInt32(myRun), _batchID, "S", _StagingTableName, _ChunkingProcess);  //PP
                    log.Info("Thread " + ThreadId.ToString() + "- Stored Procedure : " + _ChunkingProcess + "  Completed Successfully");
                    break;
                }
                else
                {
                    retrycount++;
                    log.Info("Thread " + ThreadId.ToString() + "- Stored Procedure : " + _ChunkingProcess + "  Failed - Retrying attempt : " + retrycount.ToString());
                    //10 second sleep to allow other threads to process
                    System.Threading.Thread.Sleep(10000);
                    if (retrycount == 3)
                    {
                        string msg = "Thread " + ThreadId.ToString() + _ChunkingProcess + " failed more than 3 times cancelling execution and raising exception";
                        throw new Exception(msg);
                    }
                }
            }
        }


    }
}
