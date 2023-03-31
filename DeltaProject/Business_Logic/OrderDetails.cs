namespace DeltaProject.Business_Logic
{
    public class OrderDetails
    {
        public int Id { get; set; }
        public int OrderId { get; set; }
        public string ProductName { get; set; }
        public decimal Price { get; set; }
        public decimal Amount { get; set; }
    }
}