using System;

namespace Business_Logic
{
    public class ClientMaintenanceStatement
    {
        public DateTime? TransactionDate { get; set; }
        public double Debit { get; set; }
        public double Credit { get; set; }
        public double Balance { get; set; }
        public string Statement { get; set; }
    }
}