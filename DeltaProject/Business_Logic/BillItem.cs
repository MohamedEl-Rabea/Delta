using System;

namespace DeltaProject.Business_Logic
{
    [Serializable]
    public class BillItem
    {
        public int Id { get; set; }
        public int BillId { get; set; }
        public int ProductId { get; set; }
        public string Name { get; set; }
        public decimal PurchasePrice { get; set; }
        public decimal SellPrice { get; set; }
        public decimal SpecifiedPrice { get; set; }
        public decimal Quantity { get; set; }
        public decimal ProductQuantity { get; set; }
        public decimal SoldQuantity { get; set; }
        public decimal ReturnedQuantity { get; set; }
        public decimal Discount { get; set; }
        public decimal TotalCost => Quantity * SpecifiedPrice - Discount;
        public string UnitName { get; set; }
        public bool IsService { get; set; }
        public string Notes { get; set; }
    }
}