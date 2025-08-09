-- Criacao das tabelas

-- Clientes
CREATE TABLE Cliente (
  id_cliente SERIAL PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  cpf VARCHAR(11) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  telefone VARCHAR(11) UNIQUE NOT NULL,
  data_nascimento DATE NOT NULL,
  data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );

-- Entregador
CREATE TABLE Entregador (
  id_entregador SERIAL PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  cpf VARCHAR(11) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  telefone VARCHAR(11) UNIQUE NOT NULL,
  data_nascimento DATE NOT NULL,
  data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );

-- Bairro
CREATE TABLE Bairro (
  id_bairro SERIAL PRIMARY KEY,
  bairro VARCHAR(100) UNIQUE NOT NULL
  );

-- Cep
CREATE TABLE Cep (
  cep VARCHAR(8) PRIMARY KEY,
  logradouro VARCHAR(100) NOT NULL,
  id_bairro INT NOT NULL,
  UNIQUE(cep, logradouro),
  
  FOREIGN KEY (id_bairro) REFERENCES Bairro(id_bairro)
  );

-- Endereco
CREATE TABLE Endereco (
  id_endereco SERIAL PRIMARY KEY,
  id_cliente INT NOT NULL,
  cep VARCHAR(8) NOT NULL,
  numero VARCHAR (10) NOT NULL DEFAULT 'NAO INFORMADO',
  complemento VARCHAR(50),
  data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
 FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
 FOREIGN KEY (cep) REFERENCES Cep(cep)
  );

-- Categoria
CREATE TABLE Categoria (
  id_categoria SERIAL PRIMARY KEY,
  nome_categoria VARCHAR(100) UNIQUE NOT NULL,
  data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
 );

-- Produto
CREATE TABLE Produto (
  id_produto SERIAL PRIMARY KEY,
  nome_produto VARCHAR(100) UNIQUE NOT NULL,
  id_categoria INT NOT NULL,
  custo DECIMAL(5,2) NOT NULL,
  preco DECIMAL(5,2) NOT NULL,
  data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
 );

-- Adicional
CREATE TABLE Adicional (
  id_adicional SERIAL PRIMARY KEY,
  nome_adicional VARCHAR(100) UNIQUE NOT NULL,
  id_categoria INT NOT NULL,
  custo DECIMAL(5,2) NOT NULL,
  preco DECIMAL(5,2) NOT NULL,
  data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
 );

-- Forma_pagamento
CREATE TABLE Forma_pagamento (
  id_forma_pagamento SERIAL PRIMARY KEY,
  forma_pagamento VARCHAR (50) UNIQUE NOT NULL,
  data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
 );

-- Status_pedido
CREATE TABLE Status_pedido (
  id_status SERIAL PRIMARY KEY,
  nome_status VARCHAR(30) UNIQUE NOT NULL,
  data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
 );

-- Pedido
CREATE TABLE Pedido (
  id_pedido SERIAL PRIMARY KEY,
  id_cliente INT NOT NULL,
  id_entregador INT,
  id_forma_pagamento INT NOT NULL,
  id_status INT NOT NULL,
  observacao TEXT,
  data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
  FOREIGN KEY (id_entregador) REFERENCES Entregador(id_entregador),
  FOREIGN KEY (id_forma_pagamento) REFERENCES Forma_pagamento(id_forma_pagamento),
  FOREIGN KEY (id_status) REFERENCES Status_pedido(id_status)
  );

-- Item_pedido
CREATE TABLE Item_pedido (
  id_item SERIAL PRIMARY KEY,
  id_pedido INT NOT NULL,
  id_produto INT NOT NULL,
  quantidade INT NOT NULL,
  
  FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
  FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
  );

-- Item_pedido_adicional
CREATE TABLE Item_pedido_adicional (
  id_item_pedido INT NOT NULL,
  id_adicional INT NOT NULL,
  quantidade INT NOT NULL,
  
  PRIMARY KEY (id_item_pedido, id_adicional),
  
  FOREIGN KEY (id_item_pedido) REFERENCES Item_pedido(id_item),
  FOREIGN KEY (id_adicional) REFERENCES Adicional(id_adicional)
 );

-- Historico_status_pedido
CREATE TABLE Historico_status_pedido (
  id_historico SERIAL PRIMARY KEY,
  id_pedido INT NOT NULL,
  id_status INT NOT NULL,
  data_status TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
  FOREIGN KEY (id_status) REFERENCES Status_pedido(id_status)
 );

-- Tabelas de log

-- Log_preco
CREATE TABLE Log_preco_produto (
	id_log SERIAL PRIMARY KEY,
	id_produto INT NOT NULL,
	preco_antigo DECIMAL(5,2) NOT NULL,
	preco_novo DECIMAL(5,2) NOT NULL,
	data_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

	FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

-- Log_custo
CREATE TABLE Log_custo_produto (
	id_log SERIAL PRIMARY KEY,
	id_produto INT NOT NULL,
	custo_antigo DECIMAL(5,2) NOT NULL,
	custo_novo DECIMAL(5,2) NOT NULL,
	data_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

	FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);