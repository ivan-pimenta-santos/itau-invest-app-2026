using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using ItauInvestApp.Workers; //kafka
using ItauInvestApp;         //calculos

var builder = Host.CreateApplicationBuilder(args);
builder.Services.AddHostedService<CotacaoWorkerItau>();
using IHost host = builder.Build();

Console.WriteLine("Iniciando Processameto de Carteira");
var ListaOper = new List<Operacoes>
{
    new Operacoes { s_ativo_id = "ABCD1", s_tipo_oper = "C", i_quant_oper = 45363, f_valor_unit = 10, f_valor_corr = 3},
    new Operacoes { s_ativo_id = "ABCD1", s_tipo_oper = "C", i_quant_oper = 100, f_valor_unit = 10, f_valor_corr = 3}
};
var main = new CalculatorInvest();
main.CalcularManual(ListaOper);

Console.WriteLine("Iniciando Monitoramento em Segundo Plano...");




await host.RunAsync();


