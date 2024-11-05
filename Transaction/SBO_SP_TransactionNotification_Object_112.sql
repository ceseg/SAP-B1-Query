alter PROCEDURE SBO_SP_TransactionNotification_Object_112

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
* Documento : Pedido/notas de Compras Esboço
**************************************************************************/

--Trava não permitir pedidos sem utilização

IF :object_type = '112' AND ( :transaction_type = 'A' or :transaction_type = 'U') THEN
	SELECT
		(SELECT COUNT(*)
			FROM DRF1 T0  
			WHERE T0."DocEntry" = :list_of_cols_val_tab_del AND "ObjType" = '22'
			and T0."Usage" is null) INTO cnt FROM DUMMY;
	IF :cnt > 0 THEN
		error := '0100';
		error_message := 'Favor preencher Utilização.';
	END IF;
cnt = 0;
END IF;

--Trava não permitir pedidos sem Preço

IF :object_type = '112' AND ( :transaction_type = 'A' or :transaction_type = 'U') THEN
	SELECT
		(SELECT COUNT(*)
			FROM DRF1 T0  
			WHERE T0."DocEntry" = :list_of_cols_val_tab_del AND "ObjType" = '22'
			and coalesce("Price",0) = 0) INTO cnt FROM DUMMY;
	IF :cnt > 0 THEN
		error := '0101';
		error_message := 'Favor preencher Preço.';
	END IF;
cnt = 0;
END IF;

--VERIFICA SE O MODELO NF ENTRADA NÃO ESTA VAZIO (ESBOÇO)--

IF :object_type = '112' AND ( :transaction_type = 'A' or :transaction_type = 'U') THEN
	SELECT
		(SELECT COUNT(*)
			FROM ODRF T0  
			WHERE T0."DocEntry" = :list_of_cols_val_tab_del 
			AND "ObjType" = '18'
			and "Model" = '0') INTO cnt FROM DUMMY;
	IF :cnt > 0 THEN
		error := '864';
		error_message := 'Favor preencher o Modelo da NF.';
	END IF;
cnt = 0;
END IF;
	
END