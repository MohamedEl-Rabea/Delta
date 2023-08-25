using System;

namespace DeltaProject.Business_Logic
{
    [Serializable]
    public class BillItemHistory
    {
        public int Order { get; set; }
        public string OperationType { get; set; }
        public DateTime Date { get; set; }
        public string Description { get; set; }
        public string UserName { get; set; }
    }
}