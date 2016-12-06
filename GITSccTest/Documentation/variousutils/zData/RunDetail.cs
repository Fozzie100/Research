using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.XPath;
using System.Collections.ObjectModel;
using System.Windows;
using System.Xml.Serialization;
using System.IO;
using log4net;
using System.Configuration;

namespace BarCap.CreditRisk.Juno.DC.JobTaskRestart
{
   
    public class RunDetail
    {
         public DateTime _COBDate {get;set;}
         public DateTime _COBDatePlusOne { get; set; }
         public string _JobDefinition { get; set; }
         public string _JobDefConfig { get; set; }
         public string _JobStatus { get; set; }
         public string _JobRunStatus { get; set; }
         public string _ExceptionMessage { get; set; }
         public string _LogicalDatasetName { get; set; }
         public string _ChunkProcessName { get; set; }
         public long _Run { get; set; }
         public string _connectionString { get; set; }
         public XmlNode _ChunkManagerFailureEntry { get; set; }
         public List<XmlNode> _TaskProcessToRunAfterFailure { get; set; }
         public static long _RunNumber;

         public static RunDetail GetRunDetail(long runNumber)
         {
             _RunNumber = runNumber;
             RunDetail runDetail;
             var db = new DataAccess();
             List<XmlNode> chunkManagerFailure = new List<XmlNode>();
             List<XmlNode> mySiblingTasksToRun = new List<XmlNode>();
             List<XmlNode> mySiblingTasksToRunTemp = new List<XmlNode>();
             

             var dsRunDetail = db.RunDetailGet(runNumber);
             if (dsRunDetail.Tables[0].Rows.Count == 0)
             {
                runDetail =   new RunDetail()  {_ExceptionMessage="Run number cannot be found"} ;
                goto Normal_End;
             }
             if (dsRunDetail.Tables[0].Rows[0]["BatchIDStatus"] == DBNull.Value)
             {
                 runDetail = new RunDetail() { _ExceptionMessage = "No 'F' - Failed chunk exists for this Run Number" };
                 goto Normal_End;
             }
           
             runDetail = new RunDetail()
             {
                 _COBDate = (Convert.ToDateTime(dsRunDetail.Tables[0].Rows[0]["CobDate"])),
                 _COBDatePlusOne = (Convert.ToDateTime(dsRunDetail.Tables[0].Rows[0]["CobDatePlusOne"])),
                 _JobStatus = dsRunDetail.Tables[0].Rows[0]["JobStatus"].ToString(),
                 _JobRunStatus = dsRunDetail.Tables[0].Rows[0]["RunStatus"].ToString(),
                 _JobDefinition = dsRunDetail.Tables[0].Rows[0]["JobDefinitionCode"].ToString(),
                 _JobDefConfig = dsRunDetail.Tables[0].Rows[0]["JobDefinitionConfig"].ToString(),
                 _LogicalDatasetName = dsRunDetail.Tables[0].Rows[0]["LogicalDatasetName"].ToString(),
                 _ChunkProcessName = dsRunDetail.Tables[0].Rows[0]["ChunkProcessName"].ToString(),
                 _Run = Convert.ToInt64(dsRunDetail.Tables[0].Rows[0]["Run"]),
                 _connectionString = ConfigurationManager.ConnectionStrings["TargetDB"].ConnectionString.ToString()
//     
             };


             System.Xml.XmlDocument xDoc = new XmlDocument();
             xDoc.LoadXml(runDetail._JobDefConfig);

              //Get ChunkManager failure entry point
             var sb = new StringBuilder();
             sb.Append(@"/ConductorConfiguration//Executable[ExecutableName = ""ChunkManager.exe"" and Parameters[contains(.,""ChunkingProcess=");
             sb.Append(runDetail._ChunkProcessName);
             sb.Append(@""")] and Parameters[contains(.,""StagingTable=");
             sb.Append(runDetail._LogicalDatasetName);
             sb.Append(@""")]]");

            
             //Raise error if the failure XmlNode count is not 1
             var foobar = xDoc.SelectNodes(sb.ToString()).Cast<XmlNode>();

             if (foobar.Count<XmlNode>() > 1)
                 throw new Exception("Greater than one Chunk with ''F'' status, contact IT");
             runDetail._ChunkManagerFailureEntry = foobar.First<XmlNode>().ParentNode;
             chunkManagerFailure.Add(foobar.First<XmlNode>().ParentNode);
            

             //if null, go to parent and the sibling of that.  This sibling(if it exists) will be a post process
             var nextProcessorPostProcessAfterAnchor = runDetail._ChunkManagerFailureEntry.NextSibling;
             while (!(nextProcessorPostProcessAfterAnchor == null))
             {
                 mySiblingTasksToRun.Add(nextProcessorPostProcessAfterAnchor);
                 nextProcessorPostProcessAfterAnchor = nextProcessorPostProcessAfterAnchor.NextSibling;
             }

             //Now check if we are a <Processes> or a <PostProcesses> parent of _ChunkManagerFailureEntry
             var processesOrPostProcessesElement = runDetail._ChunkManagerFailureEntry.ParentNode;

             //So if the failure was within the Processes element, get all the IPostProcessTask
             if (processesOrPostProcessesElement.Name == "Processes")
             {
                mySiblingTasksToRunTemp = (xDoc.SelectNodes(@"/ConductorConfiguration/PostProcesses/IPostProcessTask").Cast<XmlNode>()).ToList<XmlNode>();
             }

             //Concatenate ChunkManager failure XML Node with all sibling element tasks in the Process and PostProcess parent elements
             runDetail._TaskProcessToRunAfterFailure = chunkManagerFailure.Concat(mySiblingTasksToRun).Concat(mySiblingTasksToRunTemp).ToList();
            
             Normal_End:

             return runDetail;


             //BarCap.CreditRisk.Juno.DC.JobTaskRestart.Restart.grdTasks.ItemsSource = RunDetail.RunDetailTasks.GetRunDetailTasksReStart();
         }


        public class RunDetailTasks
         {
             public int Order { get; set; }
             public string SqlCommand { get; set; }
             public string Type { get; set; }
             public string ConnectionString { get; set; }
             public string ExecutablePath { get; set; }
             public string ExecutableName { get; set; }
             public string Parameters { get; set; }
             public string TaskAndParams { get; set; } // calculated 'display' value datagrid binding
             private static RunDetail _runDetail;

             private RunDetailTasks(XmlNode candElement, int order)
             {
                 var xDoc = new XmlDocument();
                                 
                 using (StringReader s = new StringReader(candElement.InnerXml))
                 {
                    xDoc.Load(s);
                 }

                 Order = order;
                 Parameters = !(xDoc.SelectSingleNode(@"//Parameters") == null) ? xDoc.SelectSingleNode(@"//Parameters").InnerText.ReplaceTokensAll(_runDetail) : null;
                 ExecutablePath = !(xDoc.SelectSingleNode(@"//ExecutablePath") == null) ? xDoc.SelectSingleNode(@"//ExecutablePath").InnerText.ReplaceTokensAll(_runDetail) : null;
                 ExecutableName = !(xDoc.SelectSingleNode(@"//ExecutableName") == null) ? xDoc.SelectSingleNode(@"//ExecutableName").InnerText.ReplaceTokensAll(_runDetail) : null;
                 SqlCommand = !(xDoc.SelectSingleNode(@"//SqlCommand") == null) ? xDoc.SelectSingleNode(@"//SqlCommand").InnerText.ReplaceTokensAll(_runDetail) : null;
                 ConnectionString = !(xDoc.SelectSingleNode(@"//ConnectionString") == null) ? xDoc.SelectSingleNode(@"//ConnectionString").InnerText.ReplaceTokensAll(_runDetail) : null;

                 //Calculate 'Display' column for grid
                 if (!(ExecutableName == null))
                 {
                     Type = "EXE";
                     TaskAndParams = ExecutableName + " " + ExecutableName + " " + Parameters;
                 }
                 else if (!(SqlCommand == null))
                 {
                     Type = "SQL";
                     TaskAndParams = SqlCommand;
                 }
                 else
                 {
                     Type = "UKN";
                     TaskAndParams = "INVALID TASK TYPE CONTACT IT";
                 }
             }
             //private TokenReplacer _tokenReplacer;

             //public RunDetailTasks(ILog logger)
             //{
             //    _tokenReplacer = new TokenReplacer(logger);
             //}



             public static ObservableCollection<RunDetailTasks> GetRunDetailTasksReStart(RunDetail runDetail, ILog logger)
             {
                 _runDetail = runDetail;
                 //Get all Task Nodes down from this point onwards
                 
                 //Generate Token Key/Value dictionary lookup
                 // var tokenLookup = new Dictionary<string, string> = new Dictionary<string,string>;

                // var mytask = GetTasks(runDetail._ChunkManagerFailureEntry.InnerXml);

                 //loop through XMLNode list, converting taskproccess tokens into runtime values
                 //adding the RunDetail task to collection.
                 //Properties are Order, SqlCommand, ConnectionString, ExecutablePath, ExecutableName, Parameters, DisplayTaskDetails(Use WPF Converter in template)
                 var tokenReplacer = new TokenReplacer(logger);
                  var rundetailTasks = new ObservableCollection<RunDetailTasks>();
                 //possible create Controller for parsing
                 for (int i = 0; i < runDetail._TaskProcessToRunAfterFailure.Count; i++)
                 {
                     rundetailTasks.Add(new RunDetailTasks(runDetail._TaskProcessToRunAfterFailure[i], i + 1));

                     //rundetailTasks.Add(new RunDetailTasks() {  Order = i + 1,
                     //                                           ExecutablePath = runDetail._TaskProcessToRunAfterFailure[i].SelectSingleNode(@"//ExecutablePath").InnerText.ReplaceTokensAll(runDetail),
                     //                                           ExecutableName = runDetail._TaskProcessToRunAfterFailure[i].SelectSingleNode(@"//ExecutableName").InnerText.ReplaceTokensAll(runDetail),
                     //                                           Parameters = runDetail._TaskProcessToRunAfterFailure[i].SelectSingleNode(@"//Parameters").InnerText.ReplaceTokensAll(runDetail),
                     //                                           SqlCommand = runDetail._TaskProcessToRunAfterFailure[i].SelectSingleNode(@"//SqlCommand").InnerText.ReplaceTokensAll(runDetail),
                     //                                           ConnectionString = runDetail._TaskProcessToRunAfterFailure[i].SelectSingleNode(@"//ConnectionString").InnerText.ReplaceTokensAll(runDetail)
                     
                     //});
                    
                 }

                                  
                
                 //rundetailTasks.Add(new RunDetailTasks() { Order = 1, TaskAndParams = "ChunkManger.exe ConnectionString=data source=LDNDCM05330V05B\\LF6_MAIN2_DEV;initial catalog=JUNO_DEV05;integrated security=True; @p_run=12629 Span=500000 ChunkingProcess=bi.uspLoadFDFS_ImpStockAcctFactDataChunk @p_cobdate=30May2015 StagingTable=stg.BARCLAYCARD_IMP_STOCK_ACCT MaxThreads=6" });
                 //rundetailTasks.Add(new RunDetailTasks() { Order = 2, TaskAndParams = "bi.uspLoadGRCR_MDRFactData @p_cobdate='[[CobDate|ddMMMyyyy]]'" });
                 //    employees.Add(new Employee() { Name = "Adams", Title = "President 2", WasReelected = false, Affiliation = Party.Federalist });
                 //    employees.Add(new Employee() { Name = "Jefferson", Title = "President 3", WasReelected = true, Affiliation = Party.DemocratRepublican });
                 //    employees.Add(new Employee() { Name = "Madison", Title = "President 4", WasReelected = true, Affiliation = Party.DemocratRepublican });
                 //    employees.Add(new Employee() { Name = "Monroe", Title = "President 5", WasReelected = true, Affiliation = Party.DemocratRepublican });
                 return rundetailTasks;
             }

             private static List<Executable> GetTasks(string xmlData)
             {
                 List<Executable> obj = null;
                 XmlSerializer serializer = new XmlSerializer(typeof(List<Executable>), new XmlRootAttribute("Exroot"));
                 StringReader reader = new StringReader(xmlData.Replace("&", "&amp;"));

                StringReader reader2 = new StringReader("<Exroot><Executable><ExecutablePath>pathhere</ExecutablePath><ExecutableName>ChunkManager.exe</ExecutableName><Parameters>ConnectionString=[[ConnectionString]]</Parameters><ExitCode>1</ExitCode></Executable></Exroot>");
                 //StringReader reader2 = new StringReader("<Exroot><Executable><RunDatabaseCommand><TaskName>PostProcess 2 - ArrearBandAttr Dimension Table Populate</TaskName><ConnectionString>[[ConnectionString]]</ConnectionString><SqlCommand>bi.uspLoadDimensionDataWrapper @p_Run=[[run]]</SqlCommand></RunDatabaseCommand></Executable></Exroot>");
                 //System.Xml.XmlReader xmlReader2 = System.Xml.XmlReader.Create(reader2);

                 //var filecanberead = xmlReader2.Read();
                 using (System.Xml.XmlReader xmlReader = System.Xml.XmlReader.Create(reader2))
                 {
                     obj = (List<Executable>)serializer.Deserialize(xmlReader);
                     //var newobj = serializer.Deserialize(xmlReader);
                 }
                 return obj;
             }

            
         }
    }
}
