CREATE PROCEDURE SBO_SP_TransactionNotification_Object_24

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
* Objeto    : Bancos
  Documento : Boleto
**************************************************************************/

--- Preenchimento do juros do dia no documento de boleto

IF :object_type = '24' AND :transaction_type = ('A') THEN 
    UPDATE B SET B."U_RM_JurosDia" = round(((B."BoeSum" * 0.06) / 30), 2) 
    FROM ORCT A 
        inner JOIN OBOE B ON A."DocEntry" = B."PmntNum"
    WHERE A."DocEntry" = :list_of_cols_val_tab_del;
END IF;

--- Preenchimento da data vencimento original

IF :object_type = '24' AND :transaction_type = ('A') THEN 
    UPDATE T0 SET T0."U_RM_DtOriginal" = T0."DocDueDate" 
    FROM ORCT T0 
        inner JOIN OBOE B ON T0."DocEntry" = B."PmntNum"
    WHERE T0."DocEntry" = :list_of_cols_val_tab_del;
END IF;


	
END;
