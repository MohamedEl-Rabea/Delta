using System;

namespace DeltaProject.Business_Logic
{
    [Serializable]
    public class EditHistory
    {
        public DateTime Date { get; set; }
        public string Description { get; set; }
        public string UserName { get; set; }
    }
}