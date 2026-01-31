# itau-invest-app-2026
App de investimentos p/ processo seletivo Itaú. Testes unitários e segurança. [Tecnologia principal: C#]

## Respostas Teóricas do desafio:

### //TOPICO 1// Modelagem de Banco Relacional:

**A Justificativa da escolha dos tipos de dados:**
> - Para exemplares em que o nome era "codigo ativo" por exemplo, optei por STRING, por justamente ser o código da ação, como exemplo: ITUB4. 
> - No caso das escolhas dos valores monetários, DECIMAL(15,2), por chegar até a casa do trilhão, com isso, atendendo até o mais alto valor de movimentação da atualidade.
> - Já para os IDs, o int é a melhor opção por padrão. 
> - Escolhi o ENUM 'c' 'v' pois operacoes seria uma tabela mais pesada, por conta disso, onde o usuario do banco entenderia e poderia traduzir utilizando um case em uma query, caso precisar coletar infos e mandar para outros setores em um codigo mais "amigavel"
> - Optei por deixar em snake_case por ter sido solicitado no teste, mas em particular, eu gosto do camelCase por conta da agilidade na escrita ao fazer uma query
> - No caso do VARCHAR eu optei por 255, dando assim mais liberdade e evitando riscos da quantidade de letras não comportar dentro da coluna, como por exemplo, o email




### //TOPICO 2// Indice e Performance:

**Propor Index:**
> - Em operações coloco em **usuario_id** e **data_oper**, pelo motivo da performance em consulta com esses valores no **WHERE** ou no **JOIN**. 
> - Em cotação um index composto, enfatizando o **ativo_id** para o **join** e **data_cotação** para performance no **WHERE**. 
> - Em posição um index em **usuario_id**, para performar o join com a tabela de usuários, cuja a mesma é importante para facilitar a leitura dos dados e apresentá-los de maneira mais amigável

Indexes:
```

CREATE INDEX idx_operacoes_data_usuario ON Operacoes (i_usuario_id, d_data_oper DESC);
CREATE INDEX idx_cotacao_ativo_data ON cotacao (i_ativo_id, d_data_cotacao DESC);
CREATE INDEX idx_posicao_usuario ON posicao (i_usuario_id);
```

**Escrever o SQL da consulta:** 
```

select b.d_data_oper           as data_operacao,
          c.d_data_cotacao,
          d.s_nome                  as nome_usuario, 
          d.s_email,
          b.f_valor_unit            as valor_operacao,
          c.f_valor_unit            as valor_cotacao,
          a.s_cod_ativo,
          a.s_nome_ativo,
          (c.f_valor_unit - b.f_valor_unit) as PL_value,
          ((c.f_valor_unit - b.f_valor_unit) / b.f_valor_unit) * 100 as PL_percent
            from ativo a 
                        inner join operacoes b on a.i_id = b.i_ativo_id
                        inner join cotacao c on a.i_id = c.i_ativo_id
                        inner join usuario d on b.i_usuario_id = d.i_id
        where 1=1
            and d.i_id = 1
            and a.i_id = 10
            and b.d_data_oper >= DATE_SUB(NOW(), INTERVAL 30 DAY) 
            order by c.d_data_cotacao desc 
            limit 1
```

**Criar estrutura para atualizar posição:**
```

DELIMITER //

CREATE TRIGGER trg_update_pl
AFTER INSERT ON cotacao FOR EACH ROW
BEGIN    
    UPDATE posicao 
    SET f_pl = (NEW.f_valor_unit - f_valor_medio) * i_quantidade
    WHERE i_ativo_id = NEW.i_ativo_id; 
END //

DELIMITER ;
```



### //TOPICO 3// Aplicação:

**Criar aplicação:**
> Lógica de Cálculo O foco aqui foi criar o algoritmo que calcula o Preço Médio e o Saldo. A regra aplicada diz que quando há uma Compra (C), nós aumentamos a quantidade de ações e somamos o valor gasto (Preço x Quantidade + Taxa de Corretagem) ao custo total. Já na Venda (V), nós apenas diminuímos  a quantidade de ações do saldo, sem mexer no preço médio. Para evitar que o programa trave caso a quantidade chegue a zero, usamos uma trava de segurança que  impede a divisão por zero. Nesta etapa, os dados foram escritos manualmente no código apenas para testar se a conta estava certa.

**Async/Await:**
> Integração e Performance Aqui o objetivo foi tornar o sistema profissional usando o Dapper e Programação Assíncrona. O Dapper funciona como uma ponte que conecta o C# ao Banco de Dados SQL, transformando as linhas da tabela em informações que o código entende automaticamente. Usamos o comando Async e Await para que o programa não fique "congelado" enquanto espera os dados virem do banco; o sistema faz a requisição e continua disponível para outras tarefas até a resposta chegar. A ConnectionString foi usada como o "endereço" completo para encontrar o banco de dados.



### //TOPICO 4// Logica de Negocio - Preço Médio:

> Implementação de lógica de calculos nos codigos, onde compras atualizam o preço médio e vendas geram lucros ou prejuizos, sempre descontando a taxa de corretagem.


### //TOPICO 5// Testes Unitários:

```

"Resultado:
C:\Users\ivanp\Desktop\TesteItau> dotnet test ItauInvestTests.tests/ItauInvestTests.tests.csproj
  Determinando os projetos a serem restaurados...
  Todos os projetos estão atualizados para restauração.
  ItauInvestApp -> C:\Users\ivanp\Desktop\TesteItau\ItauInvestApp\bin\Debug\net8.0\ItauInvestApp.dll
  ItauInvestTests.tests -> C:\Users\ivanp\Desktop\TesteItau\ItauInvestTests.tests\bin\Debug\net8.0\ItauInvestTests.tests.dll
Execução de teste para C:\Users\ivanp\Desktop\TesteItau\ItauInvestTests.tests\bin\Debug\net8.0\ItauInvestTests.tests.dll (.NETCoreApp,Version=v8.0)
Versão do VSTest 17.11.1 (x64)

Iniciando execução de teste, espere...
1 arquivos de teste no total corresponderam ao padrão especificado.

Aprovado!  – Com falha:     0, Aprovado:     3, Ignorado:     0, Total:     3, Duração: 408 ms - ItauInvestTests.tests.dll (net8.0)"
```



### //Topico 6// Testes Mutantes:

**Dar um exemplo e explicar conceito:**
> O teste mutante é feito para validar a qualidade dos testes de unidade, nele modificamos o codigo para causar erros propositais, tendo assim a garantia que minha suite de testes não tenha falsos positivos.
Nesse caso, um exemplo prático no meu código seria a mudança de um sinal, quebrando o valor esperado pela lógica, exemplo: se na condição if (tipo == 'C') trocarmos para if (tipo == 'V'), corromperia a logica, por conta da ação que é dependente dessa condição, o valor que o usuário comprasse de operação seria subtraido, e nao somado



### //Topico 7// Integração entre Sistemas:

> Adicionar um dotnet worker service: Codigo no GitHub Através do kafka, foi criado um serviço que opera em background para atualizar preços de ações, eu utilizei um mock para testar para garantir o isolamento dos testes. Estrategias de Retry: Codigo no GitHub Conceito de indepotencia aplicada, para evitar duplicidades, caso algum resultado se repita, foi criado um step que avisa se o resultado do valor, no caso o mock, for a mesma coisa do update anterior, evitando assim, salvar duplicadas no banco de dados.



### //Topico 8// Engenharia de Caos:

> Criado no código, utiliza a lógica de um disjuntor, que, ao identificar um problema grave, desarma. A biblioteca Polly foi usada para o monitoramento de erros . Fallback já executa uma ação de segurança, como usar um valor padrão ou log de aviso. Essa etapa é importante para evitar travamento no programa.



### //Topico 9// Escalabilidade e Performance:

**Aplicação de Autoscalling:** 
> Autoscalling Horizontal é quando se implementa um cluster, exemplo Kubernetes, que ao subir o consumo de RAM/CPU,  cria instancias para distribuir as requisicoes

**Round Robin x Latencia:**
> Round Robin distribui as cargas de forma orquestrada, mas não inteligente, ela apenas vai revezando, já a latência,  ao notar que uma maquina está com a latencia mais baixa, joga a requisição nela, tornando tudo mais equilibrado, com isso  sendo até mais performatico que o round robin

### //Topico 10// Documentação e APIs:

Documentação YAML criada e inserida no GITHUB
