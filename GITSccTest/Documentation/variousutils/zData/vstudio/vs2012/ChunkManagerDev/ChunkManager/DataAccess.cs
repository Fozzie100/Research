using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;


namespace ChunkManager
{
    public class DataAccess
    {
        private string _ConnectionString;
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        public int ThreadId { get; set; }


        public DataAccess(string ConnectionString)
        {
            _ConnectionString = ConnectionString;

        }

        public int GetRowsForRun(Dictionary<string,string> SQLParameters,string StagingTable)
        {

            int Rows = 0;
            string sql = "WITH [JobsDefinedCTE] AS (SELECT MAX(jr.Run) as Run FROM [loader].[Job] j " +
                            "INNER JOIN [loader].[JobDefinition] jd " +
                            "ON j.JobDefinitionCode=jd.JobDefinitionCode " +
                            "INNER JOIN  [loader].[JobRun] jr " +
                            "ON j.JobId=jr.JobId " +
                            "WHERE (jr.RunStatus='S' OR jr.RunStatus='W' OR jr.RunStatus='I') " +
                            "AND CobDate= '" + SQLParameters.Where(p => p.Key == "@p_cobdate").FirstOrDefault().Value + "' " +
                            " AND JobDefinitionConfig.value('(/ConductorConfiguration/Processes/IProcessTask/DataEngineFactory/DataEngineConfiguration/EngineConfiguration/Destination/TableName)[1]', 'varchar(50)') = '" + StagingTable + "' " +
                            ") " +
                            "SELECT COUNT(1) as NumRows FROM " + StagingTable + " s INNER JOIN [JobsDefinedCTE] c ON c.Run = s.Run";

            log.Info("Thread " + this.ThreadId.ToString() + " - Row Count SQL = " + sql);
            log.Info("Thread " + this.ThreadId.ToString() + " - Connection String = " + _ConnectionString);

            try
            {
                using (SqlConnection conn = new SqlConnection(_ConnectionString))
                {
                    using (SqlCommand cmd = conn.CreateCommand())
                    {
                        conn.Open();
                        cmd.CommandText = sql;
                        cmd.CommandType = CommandType.Text;
                        cmd.CommandTimeout = 0;

                        SqlDataReader reader = cmd.ExecuteReader();

                        while (reader.Read())
                        {
                            Rows = int.Parse(reader[0].ToString());
                        }
                    }
                }
            }
            catch (SqlException se)
            {
                log.Error("Thread " + this.ThreadId.ToString() + " - " + se.Message);
                //TODO need to implement error handling here
                throw;
            }

            return Rows;
        }

        public bool ExecuteChunkingStoredProcedure(string ChunkingProcess, int StartRow, int EndRow, Dictionary<string, string> SQLParameters)
        {

            bool Success = false;
            try
            {
                using (SqlConnection conn = new SqlConnection(_ConnectionString))
                {
                    using (SqlCommand cmd = conn.CreateCommand())
                    {
                        conn.Open();
                        cmd.CommandText = ChunkingProcess;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandTimeout = 0;

                        foreach (KeyValuePair<string, string> param in SQLParameters)
                        {
                            if (isParameterValid(param.Key,ChunkingProcess))
                                cmd.Parameters.AddWithValue(param.Key, param.Value);
                        }
                        cmd.Parameters.AddWithValue(GetRowParameterName("StartRow",ChunkingProcess), StartRow);
                        cmd.Parameters.AddWithValue(GetRowParameterName("EndRow", ChunkingProcess), EndRow);

                        cmd.ExecuteNonQuery();

                        Success = true;
                    }
                }
            }
            catch (SqlException se)
            {
                log.Error("Thread " + this.ThreadId.ToString() + " - " + se.Message);
                Success = false;
                //TODO need to implement error handling here
                //throw;
            }

            return Success;

        }

        public string GetRowParameterName(string RowType, string ChunkingProcess)
        {

            string paramName = String.Empty;
            string sql = "SELECT PARAMETER_NAME " +
                        " FROM INFORMATION_SCHEMA.PARAMETERS " +
                        " WHERE PARAMETER_NAME like '%"+ RowType + "%'" +
                        " AND SPECIFIC_SCHEMA = '" + ChunkingProcess.Split('.')[0] + "'" +
                        " AND SPECIFIC_NAME = '" + ChunkingProcess.Split('.')[1] + "'";

            log.Info("Thread " + this.ThreadId.ToString() + " - " + RowType + "  Parameter SQL = " + sql);

            try
            {
                using (SqlConnection conn = new SqlConnection(_ConnectionString))
                {
                    using (SqlCommand cmd = conn.CreateCommand())
                    {
                        conn.Open();
                        cmd.CommandText = sql;
                        cmd.CommandType = CommandType.Text;
                        cmd.CommandTimeout = 0;

                        SqlDataReader reader = cmd.ExecuteReader();

                        while (reader.Read())
                        {
                            paramName = reader[0].ToString();
                        }
                    }
                }
            }
            catch (SqlException se)
            {
                log.Error("Thread " + this.ThreadId.ToString() + " - " + se.Message);
                //TODO need to implement error handling here
                throw;
            }

            return paramName;
        }

        public bool isParameterValid(string RowType, string ChunkingProcess)
        {

            string paramName = String.Empty;
            string sql = "SELECT PARAMETER_NAME " +
                        " FROM INFORMATION_SCHEMA.PARAMETERS " +
                        " WHERE PARAMETER_NAME like '%" + RowType + "%'" +
                        " AND SPECIFIC_SCHEMA = '" + ChunkingProcess.Split('.')[0] + "'" +
                        " AND SPECIFIC_NAME = '" + ChunkingProcess.Split('.')[1] + "'";

            log.Info("Thread " + this.ThreadId.ToString() + " - " + RowType + "  Parameter SQL = " + sql);

            try
            {
                using (SqlConnection conn = new SqlConnection(_ConnectionString))
                {
                    using (SqlCommand cmd = conn.CreateCommand())
                    {
                        conn.Open();
                        cmd.CommandText = sql;
                        cmd.CommandType = CommandType.Text;
                        cmd.CommandTimeout = 0;

                        SqlDataReader reader = cmd.ExecuteReader();

                        while (reader.Read())
                        {
                            paramName = reader[0].ToString();
                        }
                    }
                }
            }
            catch (SqlException se)
            {
                log.Error("Thread " + this.ThreadId.ToString() + " - " + se.Message);
                //TODO need to implement error handling here
                throw;
            }
            return !string.IsNullOrEmpty(paramName);
        }


        public void BatchControlUpdate(int run, int batchID,  string batchIDStatus, string stagingTableName, string chunkProcessName)
        {


                //@p_Run INT
                //,@p_BatchID INT
                //,@p_BatchIDStatus CHAR(1)
                //,@p_StagingTableName VARCHAR(128)
                //,@p_ChunkProcessName VARCHAR(128) 
                //, @p_Debug INT = 0

            using (SqlConnection connection = new SqlConnection(_ConnectionString))
            {
                using (SqlCommand command = connection.CreateCommand())
                {

                    command.Connection = connection;
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@p_Run", run);
                    command.Parameters.AddWithValue("@p_BatchID", batchID);
                    command.Parameters.AddWithValue("@p_BatchIDStatus", batchIDStatus);
                    command.Parameters.AddWithValue("@p_StagingTableName", stagingTableName);
                    command.Parameters.AddWithValue("@p_ChunkProcessName", chunkProcessName);
                    command.CommandText = "[routing].[uspBatchControlUpdate]";
                    connection.Open();
                    command.ExecuteNonQuery();


                }
            }


        }

    }
}
