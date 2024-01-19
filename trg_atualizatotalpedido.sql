CREATE OR REPLACE TRIGGER trg_atualizatotalpedido
  AFTER INSERT /*OR UPDATE*/ ON ITENS_PEDIDO
  FOR EACH ROW
/*
Objetivo: Trigger na tabela ITENS_PEDIDO total a capa do pedido
Controle de Versao:
|----------------------------------------------------------------------------------------------------------
| Versao          | Autor        |   Change   | Descricao
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
| a-180124 1200   | ACarlos      | Vendas     | Atualizar total de pedidos apos inclusao de um novo item
-----------------------------------------------------------------------------------------------------------
*/

DECLARE
  ln_total NUMBER;

BEGIN
  IF  INSERTING  THEN
      BEGIN
         ln_total := 0;
         
         FOR c_itp IN (SELECT nvl(ip.quantidade,0) * pr.preco ln_total_item
                          FROM itens_pedido ip , produtos pr
                         WHERE ip.pedido_id  = :NEW.pedido_id
                           AND ip.produto_id = :NEW.produto_id
                           AND ip.produto_id = pr.produto_id) 
         LOOP
           ln_total := ln_total + c_itp.ln_total_item;
           
         END LOOP;

         UPDATE pedidos p
            SET p.total_pedido = ln_total 
          WHERE p.pedido_id = :NEW.pedido_id;

        EXCEPTION WHEN OTHERS THEN
           NULL;
      END;

  END IF;
END trg_atualizatotalpedido;
/
