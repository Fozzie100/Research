using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using TechTalk.SpecFlow;

namespace SpecFlowTutorial.Util
{
    public static class DataTableExtractionMethodsDB
    {
        /// <summary>Returns a query to load a column from a given entity.* table
        /// and some columns from the joined entity.History table.</summary>
        /// <param name="entityTable">Table name without brackets and entity. prefix.</param>
        /// <param name="columnName">Wanted column name without prefix.</param>
        //public static string MakeQueryingEntityTableWithColumnQuery(string entityTable, string columnName)
        //{
        //    entityTable = Tools.StripOfBrackets(entityTable);
        //    columnName = Tools.StripOfBrackets(columnName);

        //    string ret = String.Format(GenericSqls.QueryEntityTableWithColumnQuery, entityTable, columnName);
        //    return ret;
        //}

        /// <summary>Converts a specflow table to a DataTable</summary>
        /// <param name="specflowTable">The table to be converted</param>
        public static DataTable ToDataTable(this TechTalk.SpecFlow.Table specflowTable)
        {
            DataTable dt = new DataTable();
            foreach (var item in specflowTable.Header)
            {
                dt.Columns.Add(item);
            }
            foreach (var item in specflowTable.Rows)
            {
                string[] row = new string[item.Values.Count];
                item.Values.CopyTo(row, 0);
                //row = row.ParseArray();
                dt.Rows.Add(row);
            }

            return dt;
        }
    }

}
