Alter PROCEDURE SBO_SP_TransactionNotification
(
	in object_type nvarchar(20), 				-- SBO Object Type
	in transaction_type nchar(1),			-- [A]dd, [U]pdate, [D]elete, [C]ancel, C[L]ose
	in num_of_cols_in_key int,
	in list_of_key_cols_tab_del nvarchar(255),
	in list_of_cols_val_tab_del nvarchar(255)
)
LANGUAGE SQLSCRIPT 
SQL SECURITY INVOKER 
AS
-- Return values

error  int;				-- Result (0 for no error)
error_message nvarchar (200); 		-- Error string to be displayed
begin

error := 0;
error_message := N'Ok';

--------------------------------------------------------------------------------------------------------------------------------

--	ADD	YOUR	CODE	HERE

--------------------------------------------------------------------------------------------------------------------------------

/**************************************************************************
* Chamadas transactions Add-ons Lago Consultoria
**************************************************************************/

-- AddOn B1Plus - Início
call LG_TransactionNotification (object_type,transaction_type,num_of_cols_in_key,list_of_key_cols_tab_del,list_of_cols_val_tab_del,:error,:error_message);
-- AddOn B1Plus - Fim

-- AddOn B1PlusFiscal- Bloqueio Fiscal - InÌcio
call LGO_BloqueioFiscal_proc (object_type,transaction_type,num_of_cols_in_key,list_of_key_cols_tab_del,list_of_cols_val_tab_del,:error,:error_message);
-- AddOn B1PlusFiscal- Bloqueio Fiscal -  Fim

-- AddOn B1PlusNFE- Início
call LG_NFeTransactionNotification (object_type,transaction_type,num_of_cols_in_key,list_of_key_cols_tab_del,list_of_cols_val_tab_del,:error,:error_message);
-- AddOn B1PlusNFE - Fim

-- AddOn B1Plus Logística- Início
call LGO_B1PlusLogTransactionNotification (object_type,transaction_type,num_of_cols_in_key,list_of_key_cols_tab_del,list_of_cols_val_tab_del,:error,:error_message);
-- AddOn B1Plus Logística - Fim

/**************************************************************************
* Chamadas transactions Ramos
**************************************************************************/
--* Objeto    : Item
IF :object_type= '4' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	
call SBO_SP_TRANSACTIONNOTIFICATION_OBJECT_4  (object_type,transaction_type,num_of_cols_in_key,list_of_key_cols_tab_del,list_of_cols_val_tab_del,:error,:error_message);
END IF;
--* Objeto    : Pedido Vendas
IF :object_type= '17' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	
call SBO_SP_TRANSACTIONNOTIFICATION_OBJECT_17  (object_type,transaction_type,num_of_cols_in_key,list_of_key_cols_tab_del,list_of_cols_val_tab_del,:error,:error_message);
END IF;
--* Objeto    : Entrega
IF :object_type= '15' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	
call SBO_SP_TRANSACTIONNOTIFICATION_OBJECT_15  (object_type,transaction_type,num_of_cols_in_key,list_of_key_cols_tab_del,list_of_cols_val_tab_del,:error,:error_message);
END IF;
--* Objeto    : Ordem de produção
IF :object_type= '202' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	
call SBO_SP_TRANSACTIONNOTIFICATION_OBJECT_202  (object_type,transaction_type,num_of_cols_in_key,list_of_key_cols_tab_del,list_of_cols_val_tab_del,:error,:error_message);
END IF;
--* Objeto    : Cadastro de PN
IF :object_type= '2' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	
call SBO_SP_TRANSACTIONNOTIFICATION_OBJECT_2  (object_type,transaction_type,num_of_cols_in_key,list_of_key_cols_tab_del,list_of_cols_val_tab_del,:error,:error_message);
END IF;
--* Objeto    : Estrutura de Produtos
IF :object_type= '66' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	
call SBO_SP_TRANSACTIONNOTIFICATION_OBJECT_66  (object_type,transaction_type,num_of_cols_in_key,list_of_key_cols_tab_del,list_of_cols_val_tab_del,:error,:error_message);
END IF;
--* Objeto    : Entrada de Mercadorias
IF :object_type= '59' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	
call SBO_SP_TRANSACTIONNOTIFICATION_OBJECT_59  (object_type,transaction_type,num_of_cols_in_key,list_of_key_cols_tab_del,list_of_cols_val_tab_del,:error,:error_message);
END IF;
--* Objeto    : Bancos
IF :object_type= '24' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	
call SBO_SP_TRANSACTIONNOTIFICATION_OBJECT_24  (object_type,transaction_type,num_of_cols_in_key,list_of_key_cols_tab_del,list_of_cols_val_tab_del,:error,:error_message);
END IF;
--* Objeto    : Estoque
IF :object_type= '1470000065' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	
call SBO_SP_TRANSACTIONNOTIFICATION_OBJECT_1470000065  (object_type,transaction_type,num_of_cols_in_key,list_of_key_cols_tab_del,list_of_cols_val_tab_del,:error,:error_message);
END IF;
--* Objeto    : Estoque
--* Documento : Saída de Mercadorias/ Insumos
IF :object_type= '60' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	
call SBO_SP_TRANSACTIONNOTIFICATION_OBJECT_60  (object_type,transaction_type,num_of_cols_in_key,list_of_key_cols_tab_del,list_of_cols_val_tab_del,:error,:error_message);
END IF;
--* Objeto    : Administração
IF :object_type= '111' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	
call SBO_SP_TRANSACTIONNOTIFICATION_OBJECT_111  (object_type,transaction_type,num_of_cols_in_key,list_of_key_cols_tab_del,list_of_cols_val_tab_del,:error,:error_message);
END IF;
--* Objeto    : QUALIDADE
--*Documento : Ficha de Analise
IF :object_type= 'LGCRCQ1' AND (:transaction_type = 'U')THEN	
call SBO_SP_TRANSACTIONNOTIFICATION_OBJECT_LGCRCQ1  (object_type,transaction_type,num_of_cols_in_key,list_of_key_cols_tab_del,list_of_cols_val_tab_del,:error,:error_message);
END IF;
--* Objeto    : Vendas
--* Documento : Devolução NF de Saída
IF :object_type= '14' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	
call SBO_SP_TRANSACTIONNOTIFICATION_OBJECT_14  (object_type,transaction_type,num_of_cols_in_key,list_of_key_cols_tab_del,list_of_cols_val_tab_del,:error,:error_message);
END IF;
--* Objeto    : Vendas
--* Documento : NF de Saída
IF :object_type= '13' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	
call SBO_SP_TRANSACTIONNOTIFICATION_OBJECT_13  (object_type,transaction_type,num_of_cols_in_key,list_of_key_cols_tab_del,list_of_cols_val_tab_del,:error,:error_message);
END IF;
--* Objeto    : Compras
--* Documento : Oferta de Compras
IF :object_type= '540000006' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	
call SBO_SP_TRANSACTIONNOTIFICATION_OBJECT_540000006  (object_type,transaction_type,num_of_cols_in_key,list_of_key_cols_tab_del,list_of_cols_val_tab_del,:error,:error_message);
END IF;
--* Objeto    : Compras
--* Documento : Pedido de Compras
IF :object_type= '22' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	
call SBO_SP_TRANSACTIONNOTIFICATION_OBJECT_22  (object_type,transaction_type,num_of_cols_in_key,list_of_key_cols_tab_del,list_of_cols_val_tab_del,:error,:error_message);
END IF;
--* Objeto    : Compras
--* Documento : Pedido de Compras Esboço
IF :object_type= '112' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	
call SBO_SP_TRANSACTIONNOTIFICATION_OBJECT_112  (object_type,transaction_type,num_of_cols_in_key,list_of_key_cols_tab_del,list_of_cols_val_tab_del,:error,:error_message);
END IF;
--* Objeto    : Compras
--* Documento : Recebimento de Mercadorias
IF :object_type= '20' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	
call SBO_SP_TRANSACTIONNOTIFICATION_OBJECT_20  (object_type,transaction_type,num_of_cols_in_key,list_of_key_cols_tab_del,list_of_cols_val_tab_del,:error,:error_message);
END IF;
--* Objeto    : Compras
--* Documento : NF de Entrada
IF :object_type= '18' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	
call SBO_SP_TRANSACTIONNOTIFICATION_OBJECT_18  (object_type,transaction_type,num_of_cols_in_key,list_of_key_cols_tab_del,list_of_cols_val_tab_del,:error,:error_message);
END IF;





-- Select the return values
select :error, :error_message FROM dummy;

end;