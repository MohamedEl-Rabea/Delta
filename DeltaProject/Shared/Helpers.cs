using System;
using System.Linq;

namespace DeltaProject.Shared
{
    public static class Helpers
    {
        public static decimal GetFormatedDecimal(decimal number)
        {
            var result  = decimal.Parse(string.Format("{0:G29}", number));
            return result;
        }
    }
}