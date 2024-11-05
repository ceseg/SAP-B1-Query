CREATE PROCEDURE SBO_SP_TransactionNotification_Object_22

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
* Documento : Pedido de Compras
**************************************************************************/

--Trava não permitir pedidos sem utilização

IF :object_type = '22' AND ( :transaction_type = 'A' or :transaction_type = 'U') THEN
	SELECT
		(SELECT COUNT(*)
			FROM POR1 T0  
			WHERE T0."DocEntry" = :list_of_cols_val_tab_del 
			and T0."Usage" is null) INTO cnt FROM DUMMY;
	IF :cnt > 0 THEN
		error := '010';
		error_message := 'Favor preencher Utilização.';
	END IF;
cnt = 0;
END IF;

--Trava não permitir pedidos sem Preço

IF :object_type = '22' AND ( :transaction_type = 'A' or :transaction_type = 'U') THEN
	SELECT
		(SELECT COUNT(*)
			FROM POR1 T0  
			WHERE T0."DocEntry" = :list_of_cols_val_tab_del 
			and coalesce("Price",0) = 0) INTO cnt FROM DUMMY;
	IF :cnt > 0 THEN
		error := '011';
		error_message := 'Favor preencher Preço.';
	END IF;
cnt = 0;
END IF;

--Bloqueia compra de item que será descontinuado--

IF :object_type = '22' AND :transaction_type IN ('A','U') THEN 
    SELECT 
    (SELECT COUNT(T1."U_RM_Descontinuado") 
    FROM POR1 T0 
        INNER JOIN OITM T1 ON T0."ItemCode" = T1."ItemCode" 
    WHERE T0."DocEntry" = :list_of_cols_val_tab_del 
    AND T1."U_RM_Descontinuado" = 'S') INTO temp_var_0 FROM DUMMY;
    IF :temp_var_0 > 0 THEN 
        error := 7650;
        error_message := 'O item será descontinuado!';
    END IF;
temp_var_0 = 0;
END IF;




	
END