using System;

namespace Business_Logic
{
    public class ClientStatement 
    {
        public DateTime? TransactionDate { get; set; }
        public double Debit { get; set; }
        public double Credit { get; set; }
        public double Balance { get; set; }
        public string Statement { get; set; }

        public static List<ClientStatement> GetAllStatement(string clientName, DateTime? startDate)
        {
            var invoicesStatement = GetInvoicesStatement(clientName, startDate);
            var maintenanceStatement = GetMaintenanceStatement(clientName, startDate);
            var loadersStatement = GetLoadersStatement(clientName, startDate);

            var allStatements = new List<ClientStatement>();

            //Prev balance
            if (startDate.HasValue)
            {
                var prevStatement = invoicesStatement
                    .Union(maintenanceStatement)
                    .Union(loadersStatement)
                    .Where(p => p.TransactionDate is null);

                if (prevStatement.Any())
                    allStatements.Add(prevStatement.Aggregate((accClientStatement, currentClientStatement) => new ClientStatement
                    {
                        Debit = accClientStatement.Debit + currentClientStatement.Debit,
                        Credit = accClientStatement.Credit + currentClientStatement.Credit,
                        Balance = accClientStatement.Balance + currentClientStatement.Balance,
                        Statement = accClientStatement.Statement
                    }));
            }

            allStatements.AddRange(invoicesStatement
                .Union(maintenanceStatement)
                .Union(loadersStatement)
                .Where(p => p.TransactionDate != null)
                .OrderBy(p => p.TransactionDate));

            var prevBalance = allStatements.FirstOrDefault()?.Balance ?? 0;

            for (int i = 1; i < allStatements.Count; i++)
            {
                allStatements[i].Balance = prevBalance + allStatements[i].Debit - allStatements[i].Credit;
                prevBalance = allStatements[i].Balance;
            }

            return allStatements;
        }

        public static List<ClientStatement> GetInvoicesStatement(string clientName, DateTime? startDate)
        {
            var clientStatementList = new List<ClientStatement>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("Get_Client_Statement", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@Client_Name", SqlDbType.NVarChar).Value = clientName;
            if (startDate.HasValue)
                cmd.Parameters.AddWithValue("@Start_Date", startDate);

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                var clientStatement = new ClientStatement();
                clientStatement.TransactionDate = rdr["TransactionDate"] is DBNull ? (DateTime?)null : Convert.ToDateTime(rdr["TransactionDate"]);
                clientStatement.Debit = Convert.ToDouble(rdr["Debit"]);
                clientStatement.Credit = Convert.ToDouble(rdr["Credit"]);
                clientStatement.Balance = Convert.ToDouble(rdr["Balance"]);
                clientStatement.Statement = rdr["Statement"].ToString();
                clientStatementList.Add(clientStatement);
            }
            rdr.Close();
            con.Close();
            return clientStatementList;
        }

        public static List<ClientStatement> GetMaintenanceStatement(string clientName, DateTime? startDate)
        {
            List<ClientStatement> clientMaintenanceStatements = new List<ClientStatement>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("GetClientMaintenanceStatement", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@clientName", SqlDbType.NVarChar).Value = clientName;
            if (startDate.HasValue)
                cmd.Parameters.AddWithValue("@startDate", startDate);

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                var clientMaintenanceStatement = new ClientStatement();
                clientMaintenanceStatement.TransactionDate = rdr["TransactionDate"] is DBNull ? (DateTime?)null : Convert.ToDateTime(rdr["TransactionDate"]);
                clientMaintenanceStatement.Debit = Convert.ToDouble(rdr["Debit"]);
                clientMaintenanceStatement.Credit = Convert.ToDouble(rdr["Credit"]);
                clientMaintenanceStatement.Balance = Convert.ToDouble(rdr["Balance"]);
                clientMaintenanceStatement.Statement = rdr["Statement"].ToString();
                clientMaintenanceStatements.Add(clientMaintenanceStatement);
            }
            rdr.Close();
            con.Close();
            return clientMaintenanceStatements;
        }

        public static List<ClientStatement> GetLoadersStatement(string clientName, DateTime? startDate)
        {
            List<ClientStatement> clientMaintenanceStatements = new List<ClientStatement>();
            string CS = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SqlConnection con = new SqlConnection(CS);
            SqlCommand cmd = new SqlCommand("GetClientLoaderProcessStatement", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@clientName", SqlDbType.NVarChar).Value = clientName;
            if (startDate.HasValue)
                cmd.Parameters.AddWithValue("@startDate", startDate);

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                var clientMaintenanceStatement = new ClientStatement();
                clientMaintenanceStatement.TransactionDate = rdr["TransactionDate"] is DBNull ? (DateTime?)null : Convert.ToDateTime(rdr["TransactionDate"]);
                clientMaintenanceStatement.Debit = Convert.ToDouble(rdr["Debit"]);
                clientMaintenanceStatement.Credit = Convert.ToDouble(rdr["Credit"]);
                clientMaintenanceStatement.Balance = Convert.ToDouble(rdr["Balance"]);
                clientMaintenanceStatement.Statement = rdr["Statement"].ToString();
                clientMaintenanceStatements.Add(clientMaintenanceStatement);
            }
            rdr.Close();
            con.Close();
            return clientMaintenanceStatements;
        }
    }
}