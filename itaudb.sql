-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 26/01/2026 às 02:25
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `itaudb`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `ativos`
--

CREATE TABLE `ativos` (
  `i_id` int(11) NOT NULL,
  `s_cod_ativo` varchar(10) NOT NULL,
  `s_nome_ativo` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `cotacao`
--

CREATE TABLE `cotacao` (
  `i_id` int(11) NOT NULL,
  `i_ativo_id` int(11) NOT NULL,
  `f_valor_unit` decimal(15,2) DEFAULT NULL,
  `d_data_cotacao` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `operacoes`
--

CREATE TABLE `operacoes` (
  `i_id` int(11) NOT NULL,
  `i_usuario_id` int(11) NOT NULL,
  `i_ativo_id` int(11) NOT NULL,
  `i_quant_oper` int(11) NOT NULL,
  `f_valor_unit` decimal(15,2) DEFAULT NULL,
  `s_tipo_oper` enum('c','v') NOT NULL,
  `f_valor_corr` decimal(15,2) DEFAULT NULL,
  `d_data_oper` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `posicao`
--

CREATE TABLE `posicao` (
  `i_id` int(11) NOT NULL,
  `i_usuario_id` int(11) NOT NULL,
  `i_ativo_id` int(11) NOT NULL,
  `i_quant` int(11) NOT NULL,
  `i_valor_medio` decimal(15,2) NOT NULL,
  `i_pl` decimal(15,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuarios`
--

CREATE TABLE `usuarios` (
  `i_id` int(11) NOT NULL,
  `s_nome` varchar(255) NOT NULL,
  `s_email` varchar(255) NOT NULL,
  `f_pct_corretagem` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `ativos`
--
ALTER TABLE `ativos`
  ADD PRIMARY KEY (`i_id`),
  ADD UNIQUE KEY `s_cod_ativo` (`s_cod_ativo`);

--
-- Índices de tabela `cotacao`
--
ALTER TABLE `cotacao`
  ADD PRIMARY KEY (`i_id`),
  ADD KEY `idx_cotacao_ativo_data` (`i_ativo_id`,`d_data_cotacao`);

--
-- Índices de tabela `operacoes`
--
ALTER TABLE `operacoes`
  ADD PRIMARY KEY (`i_id`),
  ADD KEY `i_ativo_id` (`i_ativo_id`),
  ADD KEY `idx_operacoes_usuario` (`i_usuario_id`);

--
-- Índices de tabela `posicao`
--
ALTER TABLE `posicao`
  ADD PRIMARY KEY (`i_id`),
  ADD KEY `i_ativo_id` (`i_ativo_id`),
  ADD KEY `idx_posicao_usuario` (`i_usuario_id`);

--
-- Índices de tabela `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`i_id`),
  ADD UNIQUE KEY `s_email` (`s_email`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `ativos`
--
ALTER TABLE `ativos`
  MODIFY `i_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `cotacao`
--
ALTER TABLE `cotacao`
  MODIFY `i_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `operacoes`
--
ALTER TABLE `operacoes`
  MODIFY `i_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `posicao`
--
ALTER TABLE `posicao`
  MODIFY `i_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `i_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `cotacao`
--
ALTER TABLE `cotacao`
  ADD CONSTRAINT `cotacao_ibfk_1` FOREIGN KEY (`i_ativo_id`) REFERENCES `ativos` (`i_id`);

--
-- Restrições para tabelas `operacoes`
--
ALTER TABLE `operacoes`
  ADD CONSTRAINT `operacoes_ibfk_1` FOREIGN KEY (`i_usuario_id`) REFERENCES `usuarios` (`i_id`),
  ADD CONSTRAINT `operacoes_ibfk_2` FOREIGN KEY (`i_ativo_id`) REFERENCES `ativos` (`i_id`);

--
-- Restrições para tabelas `posicao`
--
ALTER TABLE `posicao`
  ADD CONSTRAINT `posicao_ibfk_1` FOREIGN KEY (`i_usuario_id`) REFERENCES `usuarios` (`i_id`),
  ADD CONSTRAINT `posicao_ibfk_2` FOREIGN KEY (`i_ativo_id`) REFERENCES `ativos` (`i_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
