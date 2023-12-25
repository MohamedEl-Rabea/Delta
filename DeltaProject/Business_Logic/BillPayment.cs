using System;

namespace DeltaProject.Business_Logic
{
    [Serializable]
    public class BillPayment
    {
        public int Id { get; set; }
        public decimal PaidAmount { get; set; }
        public DateTime PaymentDate { get; set; }
        public string Notes { get; set; }
    }
}