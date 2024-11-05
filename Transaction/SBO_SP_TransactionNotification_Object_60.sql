CREATE PROCEDURE SBO_SP_TransactionNotification_Object_60

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
* Objeto    : Estoque
* Documento : Saída de Mercadorias/ Insumos
**************************************************************************/

-- Trava a Saída de Mercadorias quando a Ordem de produção foi criada para terceiros

IF :object_type = '60' AND :transaction_type IN ('A') THEN 
    SELECT 
    (SELECT COUNT(*) 
    FROM OIGE A 
        LEFT OUTER JOIN IGE1 B ON A."DocEntry" = B."DocEntry" 
        LEFT OUTER JOIN OWOR C ON B."BaseRef" = C."DocEntry" 
    WHERE C."U_RM_Terceiros" = 'Y' AND A."DocEntry" = :list_of_cols_val_tab_del) INTO temp_var_0 FROM DUMMY;
    IF :temp_var_0 > 0 THEN 
        error := '8000';
        error_message := 'Impossivel Adicionar Saída de Insumos para ordem de produção de Terceiros';
    END IF;
END IF;


	
END