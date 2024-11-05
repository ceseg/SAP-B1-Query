create PROCEDURE SBO_SP_TransactionNotification_Object_17

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
item_pr nvarchar(20);
--NRef nvarchar(200);
--CodCliente nvarchar(200);
v_NRef NVARCHAR(254);
v_CodCliente NVARCHAR(254);
SWV_ORDR__var0 INTEGER;
ItemCode NVARCHAR(20);
temp_var_0 NVARCHAR(20);

BEGIN

/* Trava não permitir itens repetidos nos pedidos*/

IF  :object_type = '17'  and (:transaction_type = 'A' OR :transaction_type = 'U') then 
    SELECT 
    (SELECT TOP 1 T0."SWW"
    FROM rdr1 T0 
    WHERE T0."DocEntry" = :list_of_cols_val_tab_del 
    AND IFNULL((SELECT COUNT(*) 
        FROM rdr1 A 
        WHERE A."DocEntry" = :list_of_cols_val_tab_del AND
         A."ItemCode" = T0."ItemCode"), 0) > 1) INTO ItemCode FROM DUMMY;
    SELECT :ItemCode INTO temp_var_0 FROM DUMMY;
    IF :temp_var_0 IS NOT NULL THEN 
        error := 30000;
        error_message := 'O Item código - ' || CAST(:ItemCode AS nvarchar(20)) || ' está duplicado, impossível continuar';
    END IF;
END IF;

--Trava não permitir gravar pedidos com número referencia repetido para mesmo cliente

IF  :object_type = '17'  and (:transaction_type = 'A' OR :transaction_type = 'U') then
      select   Case
      When Coalesce("NumAtCard",'') =  '' Then 'A'
      else "NumAtCard"
      End, "CardCode" INTO v_NRef,v_CodCliente FROM ORDR WHERE "DocEntry" = :list_of_cols_val_tab_del;      
   /* AND CardName not like 'SENDAS%'*/

      Select count(*) INTO SWV_ORDR__var0 FROM ORDR WHERE "NumAtCard"  = :v_NRef
      AND "CardCode"  = :v_CodCliente
      AND "DocEntry"  != :list_of_cols_val_tab_del
      AND ("CANCELED" != 'Y');
      
      IF(Select count(*) FROM ORDR
      WHERE "NumAtCard"  = :v_NRef
      AND "CardCode"  = :v_CodCliente
      AND "DocEntry"  != :list_of_cols_val_tab_del
      AND ("CANCELED" != 'Y')) > 0 then
       
         error := 4117;
         error_message := 'Número de referencia ' || :v_NRef || ' já existe para este cliente ' || :v_CodCliente || '';
      end if;
   end if;

	
--Trava não permitir preço abaixo Lista Funcionarios nos pedidos

IF :object_type = '17' AND ( :transaction_type = 'A' or :transaction_type = 'U') THEN
	SELECT
		(Select TOP 1 (T1."U_RM_CodRef") 
		from RDR1 T1  
		INNER JOIN ORDR T0 
			ON T0."DocEntry" = T1."DocEntry" 
		where (select t3."Price" from ITM1 t3 
		where T3."ItemCode" = T1."ItemCode" 
			and t3."PriceList" = 15) > t1."Price"
			AND T0."CardCode" NOT LIKE 'SD%' 
			AND T0."CardCode" NOT LIKE 'CB%' 
			AND T1."Usage" <> '47' 
			AND T1."Usage" <> '55' 
			AND	T1."Usage" <> '64'
		    and T0."DocEntry" = :list_of_cols_val_tab_del)INTO item_pr FROM DUMMY;

IF :item_pr is not NULL and (:item_pr <> '') THEN
		error := '45644';
		error_message := 'Item Cód. ' || :item_pr || ' está com preço abaixo da tabela permitida';
	END IF;
END IF;

--Trava não permitir pedidos sem utilização

IF :object_type = '17' AND ( :transaction_type = 'A' or :transaction_type = 'U') THEN
	SELECT
		(SELECT COUNT(*)
			FROM RDR1 T0  
			WHERE T0."DocEntry" = :list_of_cols_val_tab_del 
			and T0."Usage" is null) INTO cnt FROM DUMMY;
	IF :cnt > 0 THEN
		error := '45644';
		error_message := 'Favor preencher Utilização.';
	END IF;
END IF;


--Trava não permitir pedidos sem Código Imposto

IF :object_type= '17' AND (:transaction_type = 'A' 	OR :transaction_type = 'U')THEN
	SELECT	 COUNT(*) INTO cnt 
		FROM RDR1 T0
		WHERE IFNULL(T0."TaxCode",'') = ''
		AND T0."DocEntry" = :list_of_cols_val_tab_del;

IF :cnt > 0 THEN 
 error := '48554';
 error_message := 'Favor preencher Código Imposto.';
 
END IF;			
cnt = 0;
END IF;


--Trava não permitir pedidos sem Desconto 3,65 Suframa

IF :object_type = '17' AND ( :transaction_type = 'A' or :transaction_type = 'U') THEN
	SELECT
		(SELECT COUNT(*)
			FROM ORDR T0
			inner join OCRD b 
				on T0."CardCode" = b."CardCode"
			INNER JOIN CRD7 a 
				on a."CardCode" = b."CardCode"
		WHERE IFNULL(a."TaxId8",'') <> '' 
			and b."CardType" = 'C'
			AND b."State1" <> 'EX' 
			AND b."State2" <> 'EX'
			AND b."U_LGO_Grupo_Fiscal" = 01
			AND b."CardCode" <> 'SD000197'		
			and T0."DocEntry" = :list_of_cols_val_tab_del 
			and Coalesce(T0."DiscPrcnt",0)=0) INTO cnt FROM DUMMY;
	IF :cnt > 0 THEN
		error := '45645';
		error_message := 'Favor preencher Desconto 3,65%.';
	END IF;
END IF;


----Insere numero do pedido nas linhas

IF (:object_type = '17' AND (:transaction_type = 'A' OR :transaction_type = 'U')) THEN
	UPDATE T0 SET T0."U_LG_xPed" = T1."NumAtCard"
		FROM "RDR1" T0  INNER JOIN "ORDR" T1 ON T0."DocEntry" = T1."DocEntry"
		where T1."NumAtCard" IS NOT NULL 
	AND T1."DocEntry" = :list_of_cols_val_tab_del;
END IF;

--Preencher o nome do vendedor em campo de usuário no pedido de vendas. Será utilizado na tela de geração de Picking

IF (:object_type = '17' AND (:transaction_type = 'A' OR :transaction_type = 'U')) THEN
	Update A set A."U_RM_Vendedor" = B."SlpName"
		from "ORDR" A
		left join "OSLP" B on A."SlpCode" = B."SlpCode"
	where A."DocEntry" =  :list_of_cols_val_tab_del; 
END IF;


--Preencher o nome do Fantasia em campo de usuário no pedido de vendas. 

IF (:object_type = '17' AND (:transaction_type = 'A' OR :transaction_type = 'U')) THEN
Update A set A."U_RM_NomeFantasia" = B."CardFName"
from "ORDR" A
left join "OCRD" B on A."CardCode" = B."CardCode"
where A."DocEntry" =  :list_of_cols_val_tab_del;
END IF;

--Preencher a cidade e estado em campo de usuário no pedido de vendas. Será utilizado na tela de geração de Picking

IF (:object_type = '17' AND (:transaction_type = 'A' OR :transaction_type = 'U')) THEN 
    UPDATE B SET B."U_RM_Cidade" = (A."City" || '-' || A."State") 
    	FROM "CRD1" A 
        INNER JOIN "ORDR" B ON B."CardCode" = A."CardCode"
    WHERE B."DocEntry" = :list_of_cols_val_tab_del;
END IF;

--Preencher o Cod. referencia no campo de usuário na linha do pedido de vendas. Apenas pedido do mobile

IF (:object_type = '17' AND (:transaction_type = 'A' OR :transaction_type = 'U')) THEN 
	UPDATE T0 SET T0."U_RM_CodRef" = T2."SWW"
		FROM "RDR1" T0  
		INNER JOIN "ORDR" T1 ON T0."DocEntry" = T1."DocEntry"
		INNER JOIN "OITM" T2 ON T0."ItemCode" = T2."ItemCode"
	where T1."U_LGO_ViaMobile" IS NOT NULL AND T1."DocEntry" = :list_of_cols_val_tab_del;
END IF;

-- Update em campo de usuário com o numero do pedido para ser utilizado no processo de assistende de criação de documento 

IF (:object_type = '17' AND (:transaction_type = 'A' OR :transaction_type = 'U')) THEN 
	Update T0 set T0."U_RM_NumPV" = T0."DocNum" 
	from "ORDR" T0
	where T0."DocEntry" = :list_of_cols_val_tab_del;
END IF;




-- Select the return values
select :error, :error_message FROM dummy;
	
END;