using System;

namespace DeltaProject.Business_Logic
{
    public class InvoicePayment
    {
        public int Id { get; set; }
        public int InvoiceId { get; set; }
        public decimal PaidAmount { get; set; }
        public DateTime PaymentDate { get; set; }
        public string Notes { get; set; }
    }
}