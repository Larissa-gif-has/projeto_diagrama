-- ==========================================
-- CRIAÇÃO DO BANCO DE DADOS
-- ==========================================
CREATE DATABASE E_commerce;
USE E_commerce;

-- ==========================================
-- TABELA CLIENTE
-- ==========================================
CREATE TABLE Cliente (
    idCliente INT PRIMARY KEY AUTO_INCREMENT,
    Pnome VARCHAR(10),
    Nome_do_meio VARCHAR(3),
    Sobrenome VARCHAR(20),
    CPF CHAR(11) UNIQUE,
    Endereco VARCHAR(45),
    Data_de_Nascimento DATE,
    Tipo ENUM('PF','PJ') -- Cliente pode ser Pessoa Física ou Jurídica
);

-- ==========================================
-- TABELA PEDIDO
-- ==========================================
CREATE TABLE Pedido (
    idPedido INT PRIMARY KEY AUTO_INCREMENT,
    Status_do_pedido ENUM('Em processamento','Enviado','Entregue','Cancelado'),
    Descricao VARCHAR(45),
    Cliente_idCliente INT,
    Frete FLOAT,
    FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente(idCliente)
);

-- ==========================================
-- TABELA PRODUTO
-- ==========================================
CREATE TABLE Produto (
    idProduto INT PRIMARY KEY AUTO_INCREMENT,
    Categoria VARCHAR(45),
    Nome VARCHAR(45),
    Preco DECIMAL(10,2)
);

-- ==========================================
-- RELAÇÃO PRODUTO - PEDIDO (N:N)
-- ==========================================
CREATE TABLE Relacao_Produto_Pedido (
    Produto_idProduto INT,
    Pedido_idPedido INT,
    Quantidade INT,
    Status ENUM('Disponível','Indisponível'),
    PRIMARY KEY (Produto_idProduto, Pedido_idPedido),
    FOREIGN KEY (Produto_idProduto) REFERENCES Produto(idProduto),
    FOREIGN KEY (Pedido_idPedido) REFERENCES Pedido(idPedido)
);

-- ==========================================
-- TABELA ESTOQUE
-- ==========================================
CREATE TABLE Estoque (
    idEstoque INT PRIMARY KEY AUTO_INCREMENT,
    Local VARCHAR(45)
);

-- ==========================================
-- RELAÇÃO PRODUTO - ESTOQUE (N:N)
-- ==========================================
CREATE TABLE Produto_has_Estoque (
    Produto_idProduto INT,
    Estoque_idEstoque INT,
    Quantidade INT,
    PRIMARY KEY (Produto_idProduto, Estoque_idEstoque),
    FOREIGN KEY (Produto_idProduto) REFERENCES Produto(idProduto),
    FOREIGN KEY (Estoque_idEstoque) REFERENCES Estoque(idEstoque)
);

-- ==========================================
-- TABELA FORNECEDOR
-- ==========================================
CREATE TABLE Fornecedor (
    idFornecedor INT PRIMARY KEY AUTO_INCREMENT,
    Razao_Social VARCHAR(45),
    CNPJ VARCHAR(45) UNIQUE
);

-- ==========================================
-- RELAÇÃO FORNECEDOR - PRODUTO (N:N)
-- ==========================================
CREATE TABLE Disponibiliza_Produto (
    Fornecedor_idFornecedor INT,
    Produto_idProduto INT,
    PRIMARY KEY (Fornecedor_idFornecedor, Produto_idProduto),
    FOREIGN KEY (Fornecedor_idFornecedor) REFERENCES Fornecedor(idFornecedor),
    FOREIGN KEY (Produto_idProduto) REFERENCES Produto(idProduto)
);

-- ==========================================
-- TABELA TERCEIRO - VENDEDOR
-- ==========================================
CREATE TABLE Terceiro_Vendedor (
    idTerceiro_Vendedor INT PRIMARY KEY AUTO_INCREMENT,
    Razao_Social VARCHAR(45),
    Local VARCHAR(45)
);

-- ==========================================
-- RELAÇÃO VENDEDOR - PRODUTO (N:N)
-- ==========================================
CREATE TABLE Produtos_por_Vendedor (
    Terceiro_Vendedor_idTerceiro INT,
    Produto_idProduto INT,
    Quantidade INT,
    PRIMARY KEY (Terceiro_Vendedor_idTerceiro, Produto_idProduto),
    FOREIGN KEY (Terceiro_Vendedor_idTerceiro) REFERENCES Terceiro_Vendedor(idTerceiro_Vendedor),
    FOREIGN KEY (Produto_idProduto) REFERENCES Produto(idProduto)
);

-- ==========================================
-- TABELA PAGAMENTO
-- ==========================================
CREATE TABLE Pagamento (
    idPagamento INT PRIMARY KEY AUTO_INCREMENT,
    Metodo ENUM('Cartão','Boleto','Pix','Transferência'),
    Valor DECIMAL(10,2),
    Pedido_idPedido INT,
    FOREIGN KEY (Pedido_idPedido) REFERENCES Pedido(idPedido)
);

-- ==========================================
-- TABELA ENTREGA
-- ==========================================
CREATE TABLE Entrega (
    idEntrega INT PRIMARY KEY AUTO_INCREMENT,
    Pedido_idPedido INT,
    Status ENUM('A caminho','Entregue','Cancelada'),
    Codigo_Rastreio VARCHAR(30),
    FOREIGN KEY (Pedido_idPedido) REFERENCES Pedido(idPedido)
);

-- ==========================================
-- INSERINDO DADOS PARA TESTES
-- ==========================================
-- Clientes
INSERT INTO Cliente (Pnome, Nome_do_meio, Sobrenome, CPF, Endereco, Data_de_Nascimento, Tipo)
VALUES
('Ana', 'L', 'Souza', '12345678901', 'Rua A, 100', '1995-05-12', 'PF'),
('Loja', NULL, 'Tech', '98765432100', 'Av. B, 200', '2000-10-01', 'PJ');

-- Produtos
INSERT INTO Produto (Categoria, Nome, Preco)
VALUES
('Eletrônico', 'Mouse Gamer', 120.00),
('Eletrônico', 'Teclado Mecânico', 250.00),
('Acessório', 'Headset', 150.00);

-- Pedido
INSERT INTO Pedido (Status_do_pedido, Descricao, Cliente_idCliente, Frete)
VALUES
('Enviado', 'Compra de periféricos', 1, 20.00);

-- Pagamento
INSERT INTO Pagamento (Metodo, Valor, Pedido_idPedido)
VALUES
('Pix', 520.00, 1);

-- Entrega
INSERT INTO Entrega (Pedido_idPedido, Status, Codigo_Rastreio)
VALUES
(1, 'A caminho', 'BR123456789');

-- ==========================================
-- QUERIES SQL PARA O DESAFIO
-- ==========================================

-- 1. Selecionar todos os clientes
SELECT Pnome, Sobrenome, Tipo FROM Cliente;

-- 2. Selecionar produtos com preço maior que 150
SELECT * FROM Produto WHERE Preco > 150;

-- 3. Listar produtos ordenados do mais caro para o mais barato
SELECT Nome, Preco FROM Produto ORDER BY Preco DESC;

-- 4. Calcular preço com taxa adicional de 10%
SELECT Nome, Preco, Preco * 1.10 AS Preco_Com_Taxa FROM Produto;

-- 5. Listar clientes e os pedidos com forma de pagamento
SELECT c.Pnome, p.idPedido, pag.Metodo, pag.Valor
FROM Cliente c
JOIN Pedido p ON c.idCliente = p.Cliente_idCliente
JOIN Pagamento pag ON p.idPedido = pag.Pedido_idPedido;

-- 6. Contar quantos pedidos foram feitos por cliente
SELECT c.Pnome, COUNT(p.idPedido) AS Total_Pedidos
FROM Cliente c
JOIN Pedido p ON c.idCliente = p.Cliente_idCliente
GROUP BY c.Pnome
HAVING Total_Pedidos >= 1;

-- 7. Listar todos os pedidos e o status da entrega
SELECT p.idPedido, e.Status, e.Codigo_Rastreio
FROM Pedido p
JOIN Entrega e ON p.idPedido = e.Pedido_idPedido;

-- 8. Relacionar produtos, fornecedores e estoques
SELECT pr.Nome AS Produto, f.Razao_Social AS Fornecedor, e.Local AS Estoque, pe.Quantidade
FROM Produto pr
JOIN Disponibiliza_Produto dp ON pr.idProduto = dp.Produto_idProduto
JOIN Fornecedor f ON dp.Fornecedor_idFornecedor = f.idFornecedor
JOIN Produto_has_Estoque pe ON pr.idProduto = pe.Produto_idProduto
JOIN Estoque e ON pe.Estoque_idEstoque = e.idEstoque;
