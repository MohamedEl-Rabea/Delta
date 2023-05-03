using System;

namespace DeltaProject.Business_Logic
{
    [Serializable]
    public class NewProduct
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int ClassificationId { get; set; }
        public string ClassificationName { get; set; }
        public decimal Quantity { get; set; }
        public int UnitId { get; set; }
        public string UnitName { get; set; }
        public decimal? Factor { get; set; }
        public decimal PurchasePrice { get; set; }
        public decimal SellPrice { get; set; }
        public string Description { get; set; }
        public string Mark { get; set; }
        public double? Inch { get; set; }
        public string Style { get; set; }
    }
}