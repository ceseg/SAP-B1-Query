CREATE PROCEDURE SBO_SP_TransactionNotification_Object_13

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
temp_var_0 integer;


BEGIN

/**************************************************************************
* Objeto    : Vendas
* Documento : NF de Saída
**************************************************************************/

IF :object_type = '13' AND :transaction_type IN ('A','U') THEN 
    SELECT 
    (SELECT COUNT(*) 
    FROM OINV T0 
        LEFT OUTER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry" 
        LEFT OUTER JOIN ODLN T2 ON T1."BaseEntry" = T2."DocEntry" 
    WHERE T2."U_LG_DocBillReleased" = 'N' AND T2."U_RM_Parcial" = 'N' AND
     T0."DocEntry" = :list_of_cols_val_tab_del) INTO temp_var_0 FROM DUMMY;
    IF :temp_var_0 > 0 THEN 
        error := '100';
        error_message := 'Não é permitido criar Nota Fiscal de Saída quando a Entrega não estiver liberado para Faturamento';
    END IF;
  temp_var_0 = 0;
END IF;


	
END