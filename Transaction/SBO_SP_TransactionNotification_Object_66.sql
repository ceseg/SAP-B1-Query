CREATE PROCEDURE SBO_SP_TransactionNotification_Object_66

(
	IN object_type nvarchar(20), 
	IN transaction_type nchar(1),
	IN num_of_cols_in_key int,
	IN list_of_key_cols_tab_del nvarchar(255),
	IN list_of_cols_val_tab_del nvarchar(255),
	INOUT error INT, 
	INOUT error_message NVARCHAR(200)
)
LANGUAGE SQLSCRIPT 
SQL SECURITY INVOKER 
AS

cnt INT; 
aux INT;


BEGIN

/**************************************************************************
* Objeto    : Estrutura de Produtos
**************************************************************************/

----------INSERE DATA CRIAÇÃO/REVISÃO NA OITT---

IF (:object_type = '66' AND (:transaction_type = 'A' OR :transaction_type = 'U')) THEN
	UPDATE T0 SET T0."U_RM_Revisao" = CURRENT_TIMESTAMP
		FROM "OITT" T0 
		WHERE T0."Code" = :list_of_cols_val_tab_del;
END IF;



	
END
