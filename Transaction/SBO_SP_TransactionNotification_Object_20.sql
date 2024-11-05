alter PROCEDURE SBO_SP_TransactionNotification_Object_20

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
v_NRef NVARCHAR(254);
v_CodCliente NVARCHAR(254);
SWV_OPDN__var0 INTEGER;
temp_var_0 integer;
    

BEGIN

/**************************************************************************
* Objeto    : Compras
* Documento : Recebimento de Mercadorias
**************************************************************************/

--VERIFICA SE O Nº NF  REPETIDO--    

IF  :object_type = '20'  and (:transaction_type = 'A' OR :transaction_type = 'U') then
      select  "Serial", "CardCode" INTO v_NRef,v_CodCliente FROM OPDN 
      WHERE "DocEntry" = :list_of_cols_val_tab_del;      
      Select count(*) INTO SWV_OPDN__var0 FROM OPDN WHERE "Serial"  = :v_NRef
      AND "CardCode"  = :v_CodCliente
      AND "DocEntry"  != :list_of_cols_val_tab_del
      AND ("CANCELED" = 'N');
      IF(Select count(*) FROM OPDN
      WHERE "Serial"  = :v_NRef
      AND "CardCode"  = :v_CodCliente
      AND ("CANCELED" = 'N')
      AND "DocEntry"  != :list_of_cols_val_tab_del) > 0 then
       
         error := 4117;
         error_message := 'Número de NF ' || :v_NRef || ' já existe para o cliente ' || :v_CodCliente || '';
      end if;
   end if;

--VERIFICA SE O Nº ref.fornec. NÃO ESTA VAZIO--

IF :object_type = '20' AND ( :transaction_type = 'A' or :transaction_type = 'U') THEN
	SELECT
		(SELECT COUNT(*)
			FROM OPDN T0  
			WHERE T0."DocEntry" = :list_of_cols_val_tab_del 
			and T0."NumAtCard" is null) INTO cnt FROM DUMMY;
	IF :cnt > 0 THEN
		error := '8822';
		error_message := 'Favor preencher Nº ref.fornecedor.';
	END IF;
cnt = 0;
END IF;

IF :object_type = '20' AND :transaction_type IN ('A','U') THEN 
    SELECT 
    (SELECT COUNT(*) 
    FROM OPDN A 
        LEFT OUTER JOIN PDN1 B ON A."DocEntry" = B."DocEntry" 
    WHERE B."Usage" = '37' AND A."DocEntry" = :list_of_cols_val_tab_del) INTO temp_var_0 FROM DUMMY;
    IF :temp_var_0 > 0 THEN 
        error := '9000';
        error_message := 'Não é permitido adicionar recebimento de mercadorias do processo de Ind. de Terceiros';
    END IF;
temp_var_0 = 0;
END IF;

	
END