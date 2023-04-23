using System;

namespace DeltaProject.Business_Logic
{
    [Serializable]
    public class ClassificationAttribute
    {
        public string AttrName { get; set; }
        public string Type { get; set; }
        public bool Optional { get; set; }
    }
}