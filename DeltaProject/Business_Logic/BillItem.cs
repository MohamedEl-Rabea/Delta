using System;

namespace DeltaProject.Business_Logic
{
    [Serializable]
    public class BillItem
    {
        public int Id { get; set; }
        public int ProductId { get; set; }
        public string Name { get; set; }
        public decimal PurchasePrice { get; set; }
        public decimal SellPrice { get; set; }
        public decimal SpecifiedPrice { get; set; }
        public decimal Quantity { get; set; }
        public decimal SoldQuantity { get; set; }
        public decimal ReturnedQuantity { get; set; } = 0;
        public decimal Discount { get; set; }
        public string UnitName { get; set; }
        public bool IsService { get; set; }
    }
}