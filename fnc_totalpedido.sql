CREATE OR REPLACE FUNCTION fnc_totalpedido (pn_pedido_id   pedidos.pedido_id%TYPE)
                  RETURN NUMBER IS
  ln_total_pedido NUMBER;
/*
 CodeGroup
 Script......: fnc_total_pedido.sql
 Sistema.....: CoudGroup
 Modulo......: Pedidos de Vendas

 Objetivo: Funcao para retornar o total dos pedidos pelo id do pedido.

 Controle de Versão:
 -------------------------------------------------------------------------------------------
| Versão        | Autor    | Projeto                               | Descrição              |
|------------------------------------------------------------------|-------------------------
| a-180124-1200 | ACarlos  | Pedidos                               | Criação do Script      |
|------------------------------------------------------------------|-------------------------
*/

BEGIN
  -- Sumariza pedido
  SELECT NVL(Sum(p.total_pedido),0)
    INTO ln_total_pedido
    FROM pedidos p
   WHERE p.pedido_id = pn_pedido_id;

  RETURN ln_total_pedido;

EXCEPTION
    WHEN OTHERS THEN
       ln_total_pedido := 0;
       RETURN ln_total_pedido;
END fnc_totalpedido;
/
