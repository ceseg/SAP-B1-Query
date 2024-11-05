CREATE PROCEDURE SBO_SP_TransactionNotification_Object_111

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
* Objeto    : Administração
**************************************************************************/

--Trava não permitir criar exercício fiscal, com subperíodos diferente de mensal.

IF :object_type = '111' AND :transaction_type = 'A' THEN 
    SELECT 
    (SELECT COUNT(*) 
    FROM OACP 
    WHERE "SubType" <> 'M') INTO temp_var_0 FROM DUMMY;
    IF :temp_var_0 > 0 THEN 
        error := '0001';
        error_message := 'Período deve ser mensal na criação do exercício.';
    END IF;
temp_var_0 = 0;    
END IF;
	
END