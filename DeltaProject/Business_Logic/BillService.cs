using System;

namespace DeltaProject.Business_Logic
{
    [Serializable]
    public class BillService
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public decimal Quantity { get; set; }
        public decimal SellPrice { get; set; }
    }
}