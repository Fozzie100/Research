using System;
using TechTalk.SpecFlow;
using SpecFlowTutorial.Util;

namespace SpecFlowTutorial.Steps
{
    [Binding]
    public class StateTestingSteps
    {
        [Given(@"I have the related definitions table (.*) named as (.*)")]
        public void GivenIHaveTheRelatedDefinitionsTable(Table table)
        {
            // ScenarioContext.Current.Pending();
            //var account = table.CreateInstance<Account>();
            var account = DataTableExtractionMethodsDB.ToDataTable(table);

        }

        //[Given(@"I have the related definitions table")]
        //public void GivenIHaveTheRelatedDefinitionsTable(Table table)
        //{
        //    ScenarioContext.Current.Pending();
        //}


        [Given(@"I have the table")]
        public void GivenIHaveTheTable(Table table)
        {
            var account = DataTableExtractionMethodsDB.ToDataTable(table);
        }


    }
}
