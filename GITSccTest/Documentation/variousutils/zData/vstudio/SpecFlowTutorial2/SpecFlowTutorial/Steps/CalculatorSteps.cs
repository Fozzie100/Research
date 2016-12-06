using System;
using TechTalk.SpecFlow;
using NUnit.Framework;

namespace SpecFlowTutorial.Steps
{
    [Binding]
    public class CalculatorSteps
    {
        private int result { get; set; }
        private Calculator calculator = new Calculator();
        [Given(@"I have entered (.*) into the calculator")]
        public void GivenIHaveEnteredIntoTheCalculator(int number)
        {
            // ScenarioContext.Current.Pending();
            calculator.FirstNumber = number;
        }

        [Given(@"I have also entered (.*) into the calculator")]
        public void GivenIHaveAlsoEnteredIntoTheCalculator(int number)
        {
            // ScenarioContext.Current.Pending();
            //calculator.FirstNumber = number;
            calculator.SecondNumber = number;
        }
        
        [When(@"I press add")]
        public void WhenIPressAdd()
        {
            //ScenarioContext.Current.Pending();
            result = calculator.Add();
        }
        
        [Then(@"the result should be (.*) on the screen")]
        public void ThenTheResultShouldBeOnTheScreen(int expectedResult)
        {
            //ScenarioContext.Current.Pending();
            Assert.AreEqual(expectedResult, result);
        }

        //public void ThenTheResultShouldBeOnTheScreen(int expectedResult)
        //{
        //    Assert.AreEqual(expectedResult, result);
        //}
    }
}
