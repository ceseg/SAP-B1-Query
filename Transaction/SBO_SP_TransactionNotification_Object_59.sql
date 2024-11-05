CREATE PROCEDURE SBO_SP_TransactionNotification_Object_59

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
* Objeto    : Entrada de Mercadorias
**************************************************************************/

IF :object_type = '59' AND :transaction_type IN ('A') THEN 
    SELECT 
    (SELECT COUNT(*) 
    FROM OIGN A 
        LEFT OUTER JOIN IGN1 B ON A."DocEntry" = B."DocEntry" 
        LEFT OUTER JOIN OWOR C ON B."BaseRef" = C."DocEntry" 
    WHERE C."U_RM_Terceiros" = 'Y' AND A."DocEntry" = :list_of_cols_val_tab_del) INTO temp_var_0 FROM DUMMY;
    IF :temp_var_0 > 0 THEN 
        error := '8000';
        error_message := 'Impossível adicionar uma Entrada de Produdo acabado para ordem de produção de Terceiros';
    END IF;
    temp_var_0 = 0;
END IF;

-- Trava a entrada de mercadorias sem preço

IF :object_type = '59' AND :transaction_type IN ('A','U') THEN 
    SELECT 
    (SELECT COUNT(*) 
    FROM OIGN A 
        LEFT OUTER JOIN IGN1 B ON A."DocEntry" = B."DocEntry" 
    WHERE ifnull(B."Price", 0) = 0 AND A."DocEntry" = :list_of_cols_val_tab_del) INTO temp_var_0 FROM DUMMY;
    IF :temp_var_0 > 0 THEN 
        error := '8000';
        error_message := 'É obrigatório o preço unitário do produto';
    END IF;
    temp_var_0 = 0;
END IF;

	
END
