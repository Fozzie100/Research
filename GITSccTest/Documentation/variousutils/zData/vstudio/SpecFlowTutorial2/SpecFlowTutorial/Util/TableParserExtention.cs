using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using TechTalk.SpecFlow;

namespace FunctionalTesting.DB
{
    public static class TableParserExtention
    {
        //public static Table ParseTable(this Table inputTable)
        //{
        //    string[] header = new string[inputTable.Header.Count];
        //    inputTable.Header.CopyTo(header, 0);
        //    TechTalk.SpecFlow.Table newtable = new TechTalk.SpecFlow.Table(header);

        //    foreach (var item in inputTable.Rows)
        //    {
        //        string[] cols = new string[item.Values.Count]; //new string[item.Values.Count];
        //        item.Values.CopyTo(cols, 0);
        //        for (int i = 0; i <= cols.Length - 1; i++)
        //        {
        //            cols[i] = cols[i]
        //                .Replace("{ReportingPeriod}", FunctionalTesting.Steps.GRCR_ReferenceValue.ReportingPeriodId.ToString())
        //                .Replace("{PortfolioSlice}", FunctionalTesting.Steps.GRCR_ReferenceValue.PortfolioSliceId.ToString())
        //                .Replace("{EffectiveDateValue}", FunctionalTesting.Steps.GRCR_ReferenceValue.EffectiveDate.ToString())
        //                .Replace("{EffectiveDateValue-1}", FunctionalTesting.Steps.GRCR_ReferenceValue.EffectiveDate.HasValue ? FunctionalTesting.Steps.GRCR_ReferenceValue.EffectiveDate.Value.AddDays(1).AddMonths(-1).AddDays(-1).ToString() : "{EffectiveDateValue-1}")
        //                .Replace("{EffectiveDateValue-2}", FunctionalTesting.Steps.GRCR_ReferenceValue.EffectiveDate.HasValue ? FunctionalTesting.Steps.GRCR_ReferenceValue.EffectiveDate.Value.AddDays(1).AddMonths(-2).AddDays(-1).ToString() : "{EffectiveDateValue-2}")
        //                .Replace("{Run}", FunctionalTesting.Steps.GRCR_ReferenceValue.Run.ToString())
        //                ;
        //        }

        //        newtable.AddRow(cols);

        //    }
        //    return newtable;
        //}
    }
}
