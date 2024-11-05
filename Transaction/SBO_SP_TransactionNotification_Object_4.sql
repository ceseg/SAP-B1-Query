ALTER PROCEDURE SBO_SP_TransactionNotification_Object_4

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
v_if_exists INTEGER := 0;
v_if_exists2 INTEGER := 0;
v_if_exists3 INTEGER := 0;
v_if_exists4 INTEGER := 0;
v_if_exists5 INTEGER := 0;
temp_var_0 integer;

BEGIN

/**************************************************************************
* Objeto    : Cadastro de Itens
**************************************************************************/

--indisponivel mobile ---

if :object_type = '4' and (:transaction_type = 'A' OR  :transaction_type = 'U') Then
	UPDATE T0 SET T0."U_LGO_Mobile" = 'N'
	FROM OITM T0  
	where T0."validFor" = 'N' 
	AND T0."SellItem" = 'Y' 
	AND T0."ItmsGrpCod" = '100'
	AND	T0."ItemCode" =  :list_of_cols_val_tab_del;
end if;

--Disponivel mobile ---

if :object_type = '4' and (:transaction_type = 'A' OR  :transaction_type = 'U') Then
	UPDATE T0 SET T0."U_LGO_Mobile" = 'S'
	FROM OITM T0  
	where T0."validFor" = 'Y' 
	AND T0."SellItem" = 'Y' 
	AND T0."ItmsGrpCod" = '100'
	AND T0."ItemCode" =  :list_of_cols_val_tab_del;
end if;


----------INSERE DATA CRIAÇÃO/REVISÃO NA OITM---

IF (:object_type = '4' AND (:transaction_type = 'A' OR :transaction_type = 'U')) THEN
	UPDATE T0 SET T0."U_RM_Revisao" = CURRENT_TIMESTAMP
		FROM "OITM" T0 
		WHERE T0."ItemCode" = :list_of_cols_val_tab_del;
END IF;

--Bloquear Alvaro de Atualizar Item

if :object_type = '4' and :transaction_type in('U') then
      SELECT   COUNT(T0."ItemCode") INTO v_if_exists from OITM T0
      JOIN OUSR T1 
      ON T1."USERID" = T0."UserSign2" 
      Where T0."UserSign2" IN('28') 
      AND T0."ItemCode" = :list_of_cols_val_tab_del;
      If :v_if_exists > 0 then

         error := 1004;
         error_message := N'Você não está autorizado a atualizar o item';
      end if;
end if;


-- Bloquear codigo referencia repetido.

IF :object_type = '4' AND :transaction_type IN ('A','U') THEN 
    SELECT 
    (SELECT COUNT(T0."SWW") 
    FROM OITM T0 
    GROUP BY T0.SWW HAVING COUNT(T0."SWW") > 1) INTO temp_var_0 FROM DUMMY;
    IF :temp_var_0 > 0 THEN 
        error := '7655';
        error_message := 'Código de referência já cadastrado.';
    END IF;
temp_var_0 = 0;
END IF;

-- Validação do código do Item

IF :object_type = '4' AND :transaction_type IN ('A','U') THEN 
    SELECT 
    (SELECT COUNT(*) 
    FROM OITM 
    WHERE length("ItemCode") <> 12 
    AND ifnull("AssetClass", '') = '' 
    AND "ItemCode" = :list_of_cols_val_tab_del) INTO temp_var_0 FROM DUMMY;
    IF :temp_var_0 > 0 THEN 
        error := 4006;
        error_message := 'O código do item não pode ser maior ou menor que 12 caracteres';
    END IF;
END IF;


-------- Validações do cadastro do item PA campo confirmação de lote checkout.

if :object_type = '4' and (:transaction_type = 'A' OR  :transaction_type = 'U') Then
 
       select count("U_LGO_ConfirmarLote")into cnt from OITM 
       			where "ItemCode" like 'PA%' 
       			and "SellItem" = 'Y' 
       			and "U_LGO_ConfirmarLote" = 'N' 
       			AND "QryGroup7" = 'N'
 				and "ItemCode" =  :list_of_cols_val_tab_del; 
	   
       if :cnt > 0 Then
       
             error := '7155';
             error_message := 'Mudar o campo Confirmação de lote checkout para Sim.';
       end if;
cnt = 0;       
end if;

-------- Validações do cadastro do item.

If :object_type = '4' and (:transaction_type = 'A' OR :transaction_type = 'U') then

      SELECT   COUNT(T0."ItemCode") INTO v_if_exists 
      From OITM T0 
      Where T0."ItemCode" = :list_of_cols_val_tab_del 
      and T0."DfltWH" Is Null 
      and T0."frozenFor" = 'N';
      if :v_if_exists > 0 then      
         error := 4001;
         error_message := 'É necessário definir um depósito padrão para o item';
      Else 
         SELECT   COUNT(T0."ItemCode") INTO v_if_exists2 
         From OITM T0 
         Where T0."ItemCode" = :list_of_cols_val_tab_del
         And T0."ProductSrc" < 0 
         and T0."frozenFor" = 'N';
         If :v_if_exists2 > 0 then    
            error := 4002;
            error_message := 'Fonte do produto precisa ser preenchido';
         Else 
            SELECT   COUNT(T0."ItemCode") INTO v_if_exists3 
            From OITM T0 
            Where T0."ItemCode" = :list_of_cols_val_tab_del
            and T0."NCMCode" = '-1' 
            and T0."frozenFor" = 'N'
            and T0."ItemClass" != 1;
            if :v_if_exists3 > 0 then
               error := 4003;
               error_message := 'Falta preencher o NCM';
            Else 
               SELECT   COUNT(T0."ItemCode") INTO v_if_exists4 
               From OITM T0 
               Where T0."ItemCode" = :list_of_cols_val_tab_del
               and T0."OSvcCode" = '-1' 
               and T0."frozenFor" = 'N' 
               and T0."SellItem" = 'Y'
               and T0."ItemClass" = 1;
               if :v_if_exists4 > 0 then         
                  error := 4004;
                  error_message := 'Código do Serviço precisar ser preenchido';
               Else 
                  SELECT   COUNT(T0."DocEntry") INTO v_if_exists5 
                  From OITM T0 
                  Where T0."ItemCode" = :list_of_cols_val_tab_del
                  And (T0."BuyUnitMsr" is null or T0."SalUnitMsr" is null or T0."InvntryUom" is null)
                  And (T0."InvntItem" = 'Y' or T0."SellItem" = 'Y' or T0."PrchseItem" = 'Y');
                  If :v_if_exists5 > 0 then
                     error := 4005;
                     error_message := 'Unidades de medida (Compra/Venda/Estoque) precisam ser preenchidas';
                  end if;
               end if;
            end if;
         end if;
      end if;
end if;




	
END