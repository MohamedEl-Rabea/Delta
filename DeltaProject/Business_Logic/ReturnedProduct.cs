using System;

namespace DeltaProject.Business_Logic
{
    [Serializable]
    public class ReturnedProduct
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public decimal Quantity { get; set; }
        public int UnitId { get; set; }
        public string UnitName { get; set; }
        public DateTime Date { get; set; }
    }
}