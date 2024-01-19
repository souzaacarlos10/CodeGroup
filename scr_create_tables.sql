/*
 CodeGroup
 Script......: scr_create_table.sql
 Sistema.....: CoudGroup
 Modulo......: Pedidos de Vendas

 Objetivo:

 Controle de Versão:
 -------------------------------------------------------------------------------------------
| Versão        | Autor    | Projeto                               | Descrição              |
|------------------------------------------------------------------|-------------------------
| a-180124-1200 | ACarlos  | Vendas                                | Criação do Script      |
|------------------------------------------------------------------|-------------------------
*/
-- Table Produtos
-- ----------------------------------------------------- 
CREATE TABLE produtos (
                        produto_id NUMBER PRIMARY KEY,
                        nome       VARCHAR2(50),
                        preco      NUMBER
                      );

COMMENT ON TABLE produtos is 'Tabela de produtos ';
-- Add comments to the columns 
COMMENT ON COLUMN produtos.produto_id IS 'Codigo do Produto';
COMMENT ON COLUMN produtos.nome       IS 'Nome do Produto';
COMMENT ON COLUMN produtos.preco      IS 'Preco do Produto';

--grant select, insert, update, delete on produtos to owner;

-- ----------------------------------------------------- 
-- Table Clientes 
-- ----------------------------------------------------- 
CREATE TABLE clientes (
                        cliente_id NUMBER PRIMARY KEY,
                        nome       VARCHAR2(50),
                        email      VARCHAR2(50)
                      );

COMMENT ON TABLE clientes is 'Tabela de clientes ';
-- Add comments to the columns 
COMMENT ON COLUMN clientes.cliente_id IS 'Codigo do cliente';
COMMENT ON COLUMN clientes.nome       IS 'Nome do cliente';
COMMENT ON COLUMN clientes.email      IS 'Email do cliente';
--grant select, insert, update, delete on clientes to owner;

-- ----------------------------------------------------- 
-- Table Pedidos 
-- ----------------------------------------------------- 
CREATE TABLE pedidos ( 
                       pedido_id    NUMBER PRIMARY KEY,
                       cliente_id   NUMBER,
                       data_pedido  DATE,
                       total_pedido NUMBER,
       FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
                     );
COMMENT ON TABLE pedidos is 'Tabela de Pedidos';
-- Add comments to the columns 
COMMENT ON COLUMN pedidos.pedido_id    IS 'Codigo do Pedido';
COMMENT ON COLUMN pedidos.cliente_id   IS 'Codigo do Pedido';
COMMENT ON COLUMN pedidos.data_pedido  IS 'Data do Pedido';
COMMENT ON COLUMN pedidos.total_pedido IS 'Total do Pedido';

--grant select, insert, update, delete on pedidos to owner;

-- ----------------------------------------------------- 
-- Table Itens Pedido
-- ----------------------------------------------------- 
CREATE TABLE itens_pedido (
                           item_id       NUMBER PRIMARY KEY,
                           pedido_id     NUMBER,
                           produto_id    NUMBER,
                           quantidade    NUMBER,
    FOREIGN KEY (pedido_id)  REFERENCES pedidos(pedido_id),
    FOREIGN KEY (produto_id) REFERENCES produtos(produto_id)
                          );
                          
COMMENT ON TABLE itens_pedido is 'Tabela de Itens Pedidos';
-- Add comments to the columns 
COMMENT ON COLUMN itens_pedido.item_id    IS 'Codigo do Item do Pedido Sequencia';
COMMENT ON COLUMN itens_pedido.pedido_id  IS 'Codigo do Pedido';
COMMENT ON COLUMN itens_pedido.produto_id IS 'Codigo do Produto';
COMMENT ON COLUMN itens_pedido.quantidade IS 'Quantidade Pedida';

--grant select, insert, update, delete on itens_pedido to owner;
