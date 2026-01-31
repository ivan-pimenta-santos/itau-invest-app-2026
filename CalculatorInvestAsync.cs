

namespace ItauInvestApp;

using Dapper;
using Microsoft.Data.SqlClient;

public class CalculatorInvestAsync
{
    public async Task CalcularPrecoMedAsync(string connectionString)
    {
        try
        {
            using var connection = new SqlConnection(connectionString);
            var sql = "SELECT * FROM Operacoes";
            var listaOper = await connection.QueryAsync<Operacoes>(sql);
            decimal qtd_total = 0;
            decimal custo_total = 0;
            foreach (var oper in listaOper)
            {
                if (oper.s_tipo_oper == "C")
                {
                    qtd_total += oper.i_quant_oper;
                    custo_total += (oper.i_quant_oper * oper.f_valor_unit) + oper.f_valor_corr;
                }
                else if  (oper.s_tipo_oper == "V")
                {
                     qtd_total -= oper.i_quant_oper;
                 }
            }
            decimal preco_medio = qtd_total > 0 ? custo_total / qtd_total :0;
            Console.WriteLine($"Quantidade total: {qtd_total}");
            Console.WriteLine($"Preco Medio: R$ {preco_medio:F2}");
        }
        catch (DivideByZeroException)
        {
            Console.WriteLine($"ERROR! Você não possue ações!");
        }
        catch (Exception)
        {
            Console.WriteLine($"Erro inesperado, tente novamente mais tarde");
        }
    }
}