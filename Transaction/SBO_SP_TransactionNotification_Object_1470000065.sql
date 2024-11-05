alter PROCEDURE SBO_SP_TransactionNotification_Object_1470000065

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
* Objeto    : Estoque
* Documento : Contagem estoque
**************************************************************************/
	
--Trava não permitir gravar contagem inventário sem motivo desvio

IF :object_type = '1470000065' AND :transaction_type IN ('A','U') THEN 

    SELECT count(*) INTO cnt FROM OINC T0  
    INNER JOIN INC1 T1 
    ON T0."DocEntry" = T1."DocEntry" 
    WHERE  IFNULL(T1."U_RM_Motivo",'')='' 
    AND  T1."Counted" = 'Y' 
    AND  T1."Difference" > 0 
    AND  T0."DocNum" = :list_of_cols_val_tab_del;
    IF :cnt > 0 THEN 
        error := '7100';
        error_message := 'Definir motivo do desvio.';
    END IF;
cnt = 0;    
END IF;

end