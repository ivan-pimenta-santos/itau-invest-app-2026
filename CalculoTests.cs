using ItauInvestApp;
using Xunit;

namespace ItauInvestTests.tests;

public class CalculoTests
{
    [Fact]
    public void TestCalculoPrecoMedioSucesso()
    {
        var calculadora = new CalculatorInvest();
        var operacoes = new List<Operacoes>
        {
            new Operacoes { s_tipo_oper = "C", i_quant_oper = 10, f_valor_unit = 100, f_valor_corr = 10 },
            new Operacoes { s_tipo_oper = "C", i_quant_oper = 10, f_valor_unit = 120, f_valor_corr = 10 }
        };
        var resultado = calculadora.CalcularManual(operacoes);
        Assert.Equal(111m, resultado);
    }
    [Fact]
    public void TestListaRetornoZero()
    {
        var calculadora = new CalculatorInvest();
        var listaVazia = new List<Operacoes>();
        var resultado = calculadora.CalcularManual(listaVazia);
        Assert.Equal(0, resultado);
    }
}