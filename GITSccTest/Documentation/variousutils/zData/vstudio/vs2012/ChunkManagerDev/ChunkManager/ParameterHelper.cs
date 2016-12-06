using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ChunkManager
{
    public class ParameterHelper
    {
        public static string getParametersByName(string[] args, string RequiredParam)
        {
            string key;
            string value = string.Empty;
            foreach (string val in args)
            {
                key = val.Split('=')[0];
                value = val.Replace(RequiredParam + "=", "");

                if (key == RequiredParam)
                    return value;

            }

            return value;
        }

        public static Dictionary<string,string> getSQLParameters(string[] args)
        {
            Dictionary<string, string> kvPair = new Dictionary<string, string>();
            string key;
            string value = string.Empty;
            foreach (string val in args)
            {
                key = val.Split('=')[0];
                value = val.Split('=')[1];

                if (key.StartsWith("@"))
                {
                    kvPair.Add(key, value);
                }

            }

            return kvPair;
        }        


    }
}
