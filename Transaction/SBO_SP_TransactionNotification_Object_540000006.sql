CREATE PROCEDURE SBO_SP_TransactionNotification_Object_540000006

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
* Objeto    : Compras
* Documento : Oferta de Compras
**************************************************************************/

--Insere Grupo Fiscal do PN na Oferta de Compra---

IF :object_type = '540000006' AND :transaction_type IN ('A','U') THEN 
    UPDATE T0 SET T0."U_RM_Grupo_Fiscal" = T2."Name" 
    FROM OPQT T0 
        INNER JOIN OCRD T1 ON T1."CardCode" = T0."CardCode" 
        INNER JOIN "@LGOCGROUPFISC" T2 ON T1."U_LGO_Grupo_Fiscal" = T2."Code" 
    WHERE T0."DocEntry" = :list_of_cols_val_tab_del;
END IF;


	
END