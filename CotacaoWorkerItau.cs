using Microsoft.Extensions.Hosting;
using Microsoft.VisualBasic;
using Polly; // aplicacao conceito de indepotencia, para evitar duplicidade no banco de cotacao
using Polly.CircuitBreaker;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace ItauInvestApp.Workers
{
    public class CotacaoWorkerItau : BackgroundService
    {
        private readonly HashSet<string> _idsProcessados = new HashSet<string>();
        private static readonly IAsyncPolicy<decimal> _fallbackPolicy = Policy<decimal>
            .Handle<Exception>()
            .FallbackAsync(0.00m, async (result) =>
            {
                Console.WriteLine("Servico indisponível, usando valor zero por padrão");
                await Task.CompletedTask;
            });

        private static readonly AsyncCircuitBreakerPolicy _circuitBreakerPolicy = Policy
            .Handle<Exception>()
            .CircuitBreakerAsync(2, TimeSpan.FromMinutes(1),
                onBreak: (ex, tempo) => Console.WriteLine($"Circuito Aberto por {tempo.TotalSeconds}s!"),
                onReset: () => Console.WriteLine("Circuito Fechado"));

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                string msgKafka = "{'Id': 'IVN1234', 'Ativo': 'ITUB4', 'Preco':46.34}";
                Console.WriteLine($"[Kafka] Nova Mensagem Recebida: {msgKafka}");

                await ProcessarMsg(msgKafka);                
                await Task.Delay(5000, stoppingToken);
            }
        }

        private async Task ProcessarMsg(string mensagem)
        {
            string idMensagem = "IVAN2";

            if (_idsProcessados.Contains(idMensagem))
            {
                Console.WriteLine($"ID {idMensagem} ja foi processado.");
                return;
            }

            decimal precoFinal = await _fallbackPolicy.ExecuteAsync(async () =>
            {
                return await _circuitBreakerPolicy.ExecuteAsync(async () =>
                {
                    Console.WriteLine("Tentando acessar a API de cotacoes...");
                    
                    await Task.Delay(100); 
                    return 46.34m;
                });
            });

            Console.WriteLine($"Processamento Finalizado. Valor {precoFinal}");
            
            _idsProcessados.Add(idMensagem);
            await Task.CompletedTask;
        }
    }
}