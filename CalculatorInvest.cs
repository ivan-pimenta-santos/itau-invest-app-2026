using System.ComponentModel;
using System.Security.AccessControl;

namespace ItauInvestApp;

public class CalculatorInvest
{
    public decimal CalcularManual(List<Operacoes> ListaOper)
    {
        decimal qtd_total = 0;
        decimal custo_total = 0;
        foreach (var oper in ListaOper)
        {
            if (oper.s_tipo_oper == "C")
            {
                qtd_total += oper.i_quant_oper;
                custo_total += (oper.i_quant_oper * oper.f_valor_unit) + oper.f_valor_corr;
            }
            else if (oper.s_tipo_oper == "V")
            {
                qtd_total -= oper.i_quant_oper;
            }
        }
        decimal preco_medio = qtd_total > 0 ? custo_total /qtd_total : 0;     
        Console.WriteLine($"Quantidade total: {qtd_total}");
        Console.WriteLine($"Preco Medio: R$ {preco_medio:F2}");
        return preco_medio;
    }
}