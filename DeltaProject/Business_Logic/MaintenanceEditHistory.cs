using System;

namespace DeltaProject.Business_Logic
{
    [Serializable]
    public class MaintenanceEditHistory
    {
        public DateTime Date { get; set; }
        public string Description { get; set; }
        public string UserName { get; set; }
    }
}