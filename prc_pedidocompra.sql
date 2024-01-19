CREATE OR REPLACE PROCEDURE prc_pedidocompra (pn_pedido_id  IN pedidos.pedido_id%TYPE,
                                              pn_cliente_id IN clientes.cliente_id%TYPE,
                                              pn_produto_id IN produtos.produto_id%TYPE,
                                              pn_quantidade IN itens_pedido.quantidade%TYPE,
                                              pn_cod_erro   OUT NUMBER,
                                              pv_msg_erro   OUT VARCHAR2) IS

/*
 CodeGroup
 Procedure...: prc_pedidocompra
 Sistema.....: Pedidos
 Módulo......: Pedidos

 Objetivo: Criar ou alterar pedidos 

 Parametros: pn_pedido_id  --> Codigo do pedido se existir
             pn_cliente_id --> Codigo do cliente
             pn_produto_id --> Codigo do produto
             pn_quantidade --> Quantidade incluida ou alterada
             pn_cod_erro   --> Codigo de erro retorno
             pv_msg_erro   --> Mensagem de erro retorno

 Controle de Versao:
 ----------------------------------------------------------------------------------------------------------------
 | Versão        | Autor    | Projeto  | Descricao
 -----------------------------------------------------------------------------------------------------------------
 | a-190124-1000 | ACarlos  | Pedidos  | Criação
 -----------------------------------------------------------------------------------------------------------------
*/

   e_erro               EXCEPTION ;

   lr_clientes          clientes%ROWTYPE;
   lr_produtos          produtos%ROWTYPE;
   lr_itens_pedido      itens_pedido%ROWTYPE;

   ln_pedido_id         NUMBER := 0;
   ln_total_item        NUMBER := 0;
   ln_total             NUMBER := 0;
   ln_item_id           NUMBER := 0;
   lv_inclui_item       VARCHAR2(1) := 'N';
   lv_inclusao          VARCHAR2(1) := 'N';
   lv_alteracao         VARCHAR2(1) := 'N';

   LC_NOME_ROTINA       VARCHAR2(50):= '[incluiPedido] ';
BEGIN
   pn_cod_erro := 0;

   -- Verifica Cliente
   BEGIN
     SELECT *
       INTO lr_clientes
       FROM clientes c
      WHERE c.cliente_id = pn_cliente_id;

   EXCEPTION
       WHEN NO_DATA_FOUND THEN
            pn_cod_erro := -1 ;
            pv_msg_erro := 'Cliente nao encontrado!';
            RAISE e_erro ;
   END;

   -- Verifica Produto
   BEGIN
     SELECT *
       INTO lr_produtos
       FROM produtos p
      WHERE p.produto_id = pn_produto_id;

   EXCEPTION
       WHEN NO_DATA_FOUND THEN
            pn_cod_erro := -1 ;
            pv_msg_erro := 'Produto nao encontrado!';
            RAISE e_erro ;
   END;

   -- Verifica Quantidade Produto
   IF pn_quantidade IS NULL OR
      pn_quantidade < 1 THEN
      pn_cod_erro := -2 ;
      pv_msg_erro := 'Quantidade sem valor ou negativa!';
      RAISE e_erro ;
   END IF;

   -- Verifica se o pedido ja existe
   BEGIN
     SELECT pe.pedido_id
       INTO ln_pedido_id
       FROM pedidos pe
      WHERE pe.pedido_id = pn_pedido_id;

     --> Se ja existe Ativa Alteracao
     lv_alteracao := 'S';

   EXCEPTION
       WHEN NO_DATA_FOUND THEN
            --> Se nao existe Ativa Inclusao
            lv_inclusao := 'S';
   END;

   -- Processa Inclusao
   IF lv_inclusao = 'S' THEN
   -- Localiza proximo numero de pedido/ Poderia se uma sequence
       BEGIN
         SELECT MAX(pe.pedido_id)
           INTO ln_pedido_id
           FROM pedidos pe;

         ln_pedido_id := NVL(ln_pedido_id,0) + 1;

       EXCEPTION
           WHEN NO_DATA_FOUND THEN
                ln_pedido_id := 1;
       END;

       -- Inseri Pedido
       BEGIN
         INSERT INTO pedidos (pedido_id,
                              cliente_id,
                              data_pedido,
                              total_pedido
                              ) VALUES
                             (ln_pedido_id,
                              pn_cliente_id,
                              SYSDATE,
                              pn_quantidade);

       EXCEPTION
           WHEN DUP_VAL_ON_INDEX THEN
                pn_cod_erro := SQLCODE ;
                pv_msg_erro := 'Pedido ja existe!';
                RAISE e_erro ;
           WHEN OTHERS THEN
                pn_cod_erro := SQLCODE ;
                pv_msg_erro := 'Pedido com problemas na inclusao!';
                RAISE e_erro ;
       END;

       -- Inseri Item do Pedido
       BEGIN
         ln_item_id := 1;

         INSERT INTO itens_pedido (item_id,
                                   pedido_id,
                                   produto_id,
                                   quantidade
                                  ) VALUES
                                  (ln_item_id,
                                   ln_pedido_id,
                                   pn_produto_id,
                                   pn_quantidade);

       EXCEPTION
           WHEN DUP_VAL_ON_INDEX THEN
                pn_cod_erro := SQLCODE ;
                pv_msg_erro := 'Item Pedido ja existe!';
                RAISE e_erro ;
           WHEN OTHERS THEN
                pn_cod_erro := SQLCODE;
                pv_msg_erro := 'Item Pedido com problemas na inclusao!';
                RAISE e_erro ;
       END;
   END IF;

   IF  lv_alteracao = 'S' THEN
       -- Localiza produto no pedido e altera a quantidade
       BEGIN
         SELECT *
           INTO lr_itens_pedido
           FROM itens_pedido ip
          WHERE ip.pedido_id  = ln_pedido_id
            AND ip.produto_id = pn_produto_id;

         -- Altera item ja existente
         UPDATE itens_pedido ip
            SET ip.quantidade = pn_quantidade
          WHERE ip.pedido_id  = ln_pedido_id
            AND ip.produto_id = pn_produto_id;

       EXCEPTION
           WHEN NO_DATA_FOUND  THEN
                lv_inclui_item := 'S' ;
       END ;

       IF  lv_inclui_item = 'S' THEN
           BEGIN
             SELECT MAX(ip.item_id)
               INTO ln_item_id
               FROM itens_pedido ip
              WHERE ip.pedido_id = ln_pedido_id;

             ln_item_id := NVL(ln_item_id,0) + 1;

           EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    ln_item_id := 1;
           END;

           -- Inseri Item do Pedido
           BEGIN

             INSERT INTO itens_pedido (item_id,
                                       pedido_id,
                                       produto_id,
                                       quantidade
                                      ) VALUES
                                      (ln_item_id,
                                       ln_pedido_id,
                                       pn_produto_id,
                                       pn_quantidade);

           EXCEPTION
               WHEN DUP_VAL_ON_INDEX THEN
                    pn_cod_erro := SQLCODE ;
                    pv_msg_erro := 'Item Pedido ja existe!';
                    RAISE e_erro ;
               WHEN OTHERS THEN
                    pn_cod_erro := SQLCODE ;
                    pv_msg_erro := 'Item Pedido com problemas na inclusao!';
                    RAISE e_erro ;
           END;
        END IF;

       -- Altera Pedido Capa
       BEGIN
         ln_total := 0;

         FOR c_itp IN (SELECT nvl(ip.quantidade,0) * pr.preco ln_total_item
                          FROM itens_pedido ip , produtos pr
                         WHERE ip.pedido_id  = ln_pedido_id
                           AND ip.produto_id = pr.produto_id)
         LOOP
           ln_total := ln_total + c_itp.ln_total_item;

         END LOOP;

         UPDATE pedidos p
            SET p.cliente_id   = pn_cliente_id,
                p.data_pedido  = SYSDATE,
                p.total_pedido = ln_total
          WHERE p.pedido_id = ln_pedido_id;

       EXCEPTION
           WHEN OTHERS THEN
                pn_cod_erro := SQLCODE ;
                pv_msg_erro := 'Pedido com problemas na alteracao!';
                RAISE e_erro ;
       END;


   END IF;

   IF pn_cod_erro <> 0 THEN
      ROLLBACK;
      RAISE e_erro;
   ELSE
      COMMIT;
   END IF;

   -- Execucao com sucesso
   pn_cod_erro := 0;
   pv_msg_erro := 'Produto processado com sucesso';


EXCEPTION
   WHEN e_erro THEN
      pv_msg_erro := pv_msg_erro || ' - ' || LC_NOME_ROTINA || ' - Codigo Erro : ' || pn_cod_erro || ' - Erro - '|| SQLERRM;

   WHEN OTHERS THEN
      -- Execucao com erro
      pv_msg_erro := LC_NOME_ROTINA || 'Erro Fatal - '|| SQLERRM;
END prc_pedidocompra;
/
