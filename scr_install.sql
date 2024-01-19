/*
 CodeGroup
 Script......: scr_install.sql
 Sistema.....: Pedidos
 Modulo......: Script de install

 Objetivo:

  Controle de Versao :
   ---------------------------------------------------------------------------------------------------
  | Versao        | Autor     | Projeto                                              | Descricao      |
  `---------------------------------------------------------------------------------------------------
  | a-180124-1000 | ACarlos   | Pedidos CodGroup                                     | Criacao        |
  `---------------------------------------------------------------------------------------------------
*/

set define off;
SELECT TO_CHAR(SYSDATE,'DD/MM/RRRR HH24:MI:SS') Inicio FROM dual;
show user
SELECT INSTANCE_NAME FROM V$INSTANCE;

--VERSION


--Tabelas
prompt scr_create_tables.sql
@@scr_create_tables.sql

-- Sequence

-- Packages

-- Procedures
prompt prc_trataexcecao.sql
@@prc_trataexcecao.sql

prompt prc_pedidocompra.sql
@@prc_pedidocompra.sql

-- Triggers 
prompt trg_atualizatotalpedido.sql
@@trg_atualizatotalpedido.sql

-- Functions
prompt fnc_totalpedido.sql
@@fnc_totalpedido.sql

-- Grants
--GRANT EXECUTE ON prc_trataexcecao TO owner;
--GRANT EXECUTE ON prc_pedidocompra TO owner;
--GRANT EXECUTE ON fnc_totalpedido TO owner;

--CREATE OR REPLACE SYNONYM prc_trataexcecao  FOR owner;
--CREATE OR REPLACE SYNONYM prc_pedidocompra  FOR owner;
--CREATE OR REPLACE SYNONYM fnc_totalpedido   FOR owner;

COMMIT;

SELECT TO_CHAR(SYSDATE,'DD/MM/RRRR HH24:MI:SS') Fim FROM dual;
