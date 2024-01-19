CREATE OR REPLACE PROCEDURE prc_trataexcecao  (pn_cliente_id IN clientes.cliente_id%TYPE,
                                               pn_produto_id IN produtos.produto_id%TYPE,
                                               pn_quantidade IN itens_pedido.quantidade%TYPE,
                                               pn_cod_erro   OUT NUMBER,
                                               pv_msg_erro   OUT VARCHAR2) IS

/*
 CodeGroup
 Procedure...: prc_trataexcecao
 Sistema.....: Pedidos
 Módulo......: Pedidos

 Objetivo: Tratar colunas do pedido 

 Parametros: pn_cliente_id --> Codigo do cliente
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

   LC_NOME_ROTINA       VARCHAR2(50):= '[trataExcecao] ';
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
   
   -- Poderia colocar uma verificacao de estoque, para ver sem tem
   

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
      pn_cod_erro := SQLCODE;
      pv_msg_erro := LC_NOME_ROTINA || 'Erro Fatal - '|| SQLERRM;
END prc_trataexcecao;
/
