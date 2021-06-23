using System;

namespace DeltaProject.Business_Logic
{
    public class ClientCheque
    {
        public int Id { get; set; }
        public string ClientName { get; set; }
        public DateTime DueDate { get; set; }
        public bool Collected { get; set; }
        public string ChequeNumber { get; set; }
        public int AlertBefore { get; set; }
        public string Notes { get; set; }
    }
}