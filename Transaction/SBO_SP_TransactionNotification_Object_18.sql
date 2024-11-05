ALTER PROCEDURE SBO_SP_TransactionNotification_Object_18

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
SWV_OPCH__var0 INTEGER;
SWV_OPCH__var1 INTEGER;
temp_var_0 integer;
temp_var_1 integer;
    

BEGIN

/**************************************************************************
* Objeto    : Compras
* Documento : NF de Entrada
**************************************************************************/

--VERIFICA SE O Nº NF  REPETIDO--    

IF  :object_type = '18'  and (:transaction_type = 'A' OR :transaction_type = 'U') then
      select  "Serial", "CardCode" INTO v_NRef,v_CodCliente FROM OPCH 
      WHERE "DocEntry" = :list_of_cols_val_tab_del;      
      Select count(*) INTO SWV_OPCH__var0 FROM OPCH WHERE "Serial"  = :v_NRef
      AND "CardCode"  = :v_CodCliente
      AND "DocEntry"  != :list_of_cols_val_tab_del
      AND ("CANCELED" = 'N');
      IF(Select count(*) FROM OPCH
      WHERE "Serial"  = :v_NRef
      AND "CardCode"  = :v_CodCliente
      AND ("CANCELED" = 'N')
      AND "DocEntry"  != :list_of_cols_val_tab_del) > 0 then
       
         error := 8117;
         error_message := 'Número de NF ' || :v_NRef || ' já existe para o cliente ' || :v_CodCliente || '';
      end if;
    SWV_OPCH__var0 = 0;
   end if;

--Trava não permitir nota sem utilização

IF :object_type = '18' AND ( :transaction_type = 'A' or :transaction_type = 'U') THEN
	SELECT
		(SELECT COUNT(*)
			FROM PCH1 T0  
			WHERE T0."DocEntry" = :list_of_cols_val_tab_del 
			and T0."Usage" is null) INTO cnt FROM DUMMY;
	IF :cnt > 0 THEN
		error := '010';
		error_message := 'Favor preencher Utilização.';
	END IF;
cnt = 0;
END IF;

--Trava não permitir nota sem Preço

IF :object_type = '18' AND ( :transaction_type = 'A' or :transaction_type = 'U') THEN
	SELECT
		(SELECT COUNT(*)
			FROM PCH1 T0  
			WHERE T0."DocEntry" = :list_of_cols_val_tab_del 
			and coalesce("Price",0) = 0) INTO cnt FROM DUMMY;
	IF :cnt > 0 THEN
		error := '011';
		error_message := 'Favor preencher Preço.';
	END IF;
cnt = 0;
END IF;

--Obriga Preenchimento da chave de acesso com 44 caracteres em modelos NF-e e CT-e

IF :object_type = '18' AND :transaction_type IN ('A','U') THEN 
    SELECT 
    (SELECT COUNT(*) 
    FROM OPCH 
    WHERE "DocEntry" = :list_of_cols_val_tab_del AND "Model" IN ('39','44')) INTO temp_var_0 FROM DUMMY;
    IF :temp_var_0 > 0 THEN 
        SELECT 
        (SELECT COUNT(*) 
        FROM OPCH 
        WHERE "DocEntry" = :list_of_cols_val_tab_del AND
         LENGTH(coalesce("U_chaveacesso",'')) NOT IN (44)) INTO temp_var_1 FROM DUMMY;
        IF :temp_var_1 > 0 THEN 
            error := 18;
            error_message := 'Obrigatório preenchimento da chave de acesso com 44 caracteres quando o modelo for NF-e ou CT-e!';
        END IF;
    END IF;
END IF;
	
END