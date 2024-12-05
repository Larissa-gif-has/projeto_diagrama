CREATE TABLE `Clientes` (
  `id_cliente` INT PRIMARY KEY AUTO_INCREMENT,
  `nome` VARCHAR(100),
  `endereco` VARCHAR(255),
  `telefone` VARCHAR(15)
);

CREATE TABLE `Veiculos` (
  `id_veiculo` INT PRIMARY KEY AUTO_INCREMENT,
  `modelo` VARCHAR(100),
  `placa` VARCHAR(10),
  `ano` INT,
  `id_cliente` INT
);

CREATE TABLE `Mecanicos` (
  `id_mecanico` INT PRIMARY KEY AUTO_INCREMENT,
  `nome` VARCHAR(100),
  `endereco` VARCHAR(255),
  `especialidade` VARCHAR(50)
);

CREATE TABLE `OrdensServico` (
  `id_os` INT PRIMARY KEY AUTO_INCREMENT,
  `numero_os` VARCHAR(20),
  `data_emissao` DATE,
  `valor_total` DECIMAL(10,2),
  `status` VARCHAR(20),
  `data_conclusao` DATE,
  `id_veiculo` INT
);

CREATE TABLE `Servicos` (
  `id_servico` INT PRIMARY KEY AUTO_INCREMENT,
  `descricao` VARCHAR(255),
  `preco_mao_obra` DECIMAL(10,2)
);

CREATE TABLE `Pecas` (
  `id_peca` INT PRIMARY KEY AUTO_INCREMENT,
  `nome` VARCHAR(100),
  `preco` DECIMAL(10,2)
);

CREATE TABLE `OrdensServico_Servicos` (
  `id_os` INT,
  `id_servico` INT,
  `quantidade` INT
);

CREATE TABLE `OrdensServico_Pecas` (
  `id_os` INT,
  `id_peca` INT,
  `quantidade` INT
);

CREATE TABLE `EquipeMecanicos` (
  `id_os` INT,
  `id_mecanico` INT
);

ALTER TABLE `Veiculos` ADD FOREIGN KEY (`id_cliente`) REFERENCES `Clientes` (`id_cliente`);

ALTER TABLE `OrdensServico` ADD FOREIGN KEY (`id_veiculo`) REFERENCES `Veiculos` (`id_veiculo`);

ALTER TABLE `OrdensServico_Servicos` ADD FOREIGN KEY (`id_os`) REFERENCES `OrdensServico` (`id_os`);

ALTER TABLE `OrdensServico_Servicos` ADD FOREIGN KEY (`id_servico`) REFERENCES `Servicos` (`id_servico`);

ALTER TABLE `OrdensServico_Pecas` ADD FOREIGN KEY (`id_os`) REFERENCES `OrdensServico` (`id_os`);

ALTER TABLE `OrdensServico_Pecas` ADD FOREIGN KEY (`id_peca`) REFERENCES `Pecas` (`id_peca`);

ALTER TABLE `EquipeMecanicos` ADD FOREIGN KEY (`id_os`) REFERENCES `OrdensServico` (`id_os`);

ALTER TABLE `EquipeMecanicos` ADD FOREIGN KEY (`id_mecanico`) REFERENCES `Mecanicos` (`id_mecanico`);
