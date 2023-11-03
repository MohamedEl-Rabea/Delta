using System;

namespace DeltaProject.Business_Logic
{
    [Serializable]
    public class BillDiscount
    {
        public int Id { get; set; }
        public DateTime Date { get; set; }
        public decimal Discount { get; set; }
    }
}