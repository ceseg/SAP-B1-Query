CREATE PROCEDURE SBO_SP_TransactionNotification_Object_15

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
* Objeto    : Vendas
* Documento : Entrega
**************************************************************************/	
-- Update com a informação do Peso Bruto, 10% sobre o peso liquido. Update Autorizado para atender os requisitos empresariais do cliente.
-- Clayton Borges 03/10/2017
-- Update com o peso líquido, para pedidos parciais o peso não estava de acordo com os itens no documento.

IF :object_type = '15' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	
	UPDATE DLN12 SET "NetWeight" = 
        (SELECT round((SUM(T0."Quantity" * T1."SWeight1")), 2) 
        FROM DLN1 T0 
            LEFT OUTER JOIN OITM T1 ON T0."ItemCode" = T1."ItemCode" 
        WHERE T0."DocEntry" = :list_of_cols_val_tab_del) 
    WHERE "DocEntry" = :list_of_cols_val_tab_del;
END IF;

-- Update com o peso Bruto, conforme regra da Ramos.

IF :object_type = '15' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN
UPDATE DLN12 SET "GrsWeight" = 
        (SELECT round((SUM(T0."Quantity" * T1."SWeight1") * (1 + 0.10)), 2) 
        FROM DLN1 T0 
            LEFT OUTER JOIN OITM T1 ON T0."ItemCode" = T1."ItemCode" 
        WHERE T0."Usage" <> '47' AND T0."DocEntry" = :list_of_cols_val_tab_del) 
    WHERE "DocEntry" = :list_of_cols_val_tab_del;
END IF;


-- Select the return values
select :error, :error_message FROM dummy;
	
END;	