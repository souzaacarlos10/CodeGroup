prompt Importing table PEDIDOS...
set feedback off
set define off
insert into PEDIDOS (PEDIDO_ID, CLIENTE_ID, DATA_PEDIDO, TOTAL_PEDIDO)
values (1, 1, to_date('18-01-2024 16:55:28', 'dd-mm-yyyy hh24:mi:ss'), 3);

prompt Done.
