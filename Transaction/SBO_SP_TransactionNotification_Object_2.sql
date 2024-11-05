Alter PROCEDURE SBO_SP_TransactionNotification_Object_2

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
* Objeto    : Cadastro de PN
**************************************************************************/

-------VERIFICA SE O USO PRINCIPAL NÃO ESTA VAZIO------------------------------------------

IF :object_type= '2' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	
		SELECT Count(*) INTO cnt FROM OCRD 
				WHERE "CardCode" = :list_of_cols_val_tab_del 
				AND   "validFor" = 'Y' 
				AND "MainUsage" is null;	
			 IF :cnt > 0 THEN
          		error := 218;
				error_message := 'Favor preencher o campo uso principal';
			END IF;	
cnt = 0;
END IF;	

--------- VERIFICA SE O TELEFONE NÃO ESTA VAZIO----------------------------------------

IF :object_type= '2' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	
		SELECT Count(*) INTO cnt FROM OCRD 
										WHERE "CardCode" = :list_of_cols_val_tab_del 
										AND   "validFor" = 'Y' 
										AND COALESCE("Phone1",'') = '' ;	
						IF :cnt > 0 THEN
          						error := 2001;
								error_message := 'Telefone não pode ser nulo!';
						END IF;	
cnt = 0;
END IF;	

--------- VERIFICA SE O DDD NÃO ESTA VAZIO----------------------------------------

IF :object_type= '2' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	
		SELECT Count(*) INTO cnt FROM OCRD 
										WHERE "CardCode" = :list_of_cols_val_tab_del 
										AND   "validFor" = 'Y' 
										AND COALESCE("Phone2",'') = '' ;	
						IF :cnt > 0 THEN
          						error := 2007;
								error_message := 'DDD não pode ser nulo!';
						END IF;	
cnt = 0;
END IF;	

--------- VERIFICA SE O E-MAIL NÃO ESTA VAZIO-----------------------------------------------

IF :object_type= '2' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	
		SELECT Count(*) INTO cnt FROM OCRD 
										WHERE "CardCode" = :list_of_cols_val_tab_del 
										AND   "validFor" = 'Y' 
										AND COALESCE("E_Mail",'') = '' ;	
						IF :cnt > 0 THEN
          						error := 2007;
								error_message := 'O E-mail na Aba Geral não pode ser nulo';
						END IF;	
cnt = 0;
END IF;


----------VERIFICA SE O RAZÃO SOCIAL NÃO ESTA VAZIO------------------------------------------  

IF :object_type= '2' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	
		SELECT Count(*) INTO cnt FROM OCRD 
										WHERE "CardCode" = :list_of_cols_val_tab_del 
										AND   "validFor" = 'Y' 
										AND COALESCE("CardName",'') = '' ;	
						IF :cnt > 0 THEN
          						error := 208;
								error_message := 'PREENCHER RAZÃO SOCIAL, NÃO PODE SER NULO!';
						END IF;	
cnt = 0;
END IF;	

--------- VERIFICA SE POSSUI ENDEREÇO DE ENTREGA CADASTRADO------------------------------

IF :object_type= '2' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN		
		SELECT Count(*) INTO cnt FROM CRD1 A 
											LEFT JOIN OCRD B on A."CardCode" = B."CardCode"
											WHERE B."CardCode" = :list_of_cols_val_tab_del
											--AND   B."validFor" = 'Y' 
											AND A."AdresType" = 'S';																
						IF :cnt = 0 THEN
          						error := 210;
								error_message := 'FAVOR CADASTRAR ENDEREÇO DE ENTREGA!';
						END IF;									
cnt = 0;
END IF;	  

---------- VERIFICA SE POSSUI ENDEREÇO DE COBRANÇA CADASTRADO------------------------------

IF :object_type= '2' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN			
		SELECT Count(*) INTO cnt  FROM CRD1 A 
										LEFT JOIN OCRD B on A."CardCode" = B."CardCode"
										WHERE B."CardCode" = :list_of_cols_val_tab_del
										--AND   B."validFor" = 'Y' 
										AND A."AdresType" = 'B';					
						
						IF :cnt = 0 THEN
          						error := 211;
								error_message := 'FAVOR CADASTRAR ENDEREÇO DE COBRANÇA!';
						END IF;					
cnt = 0;
END IF;	  

----------- VERIFICA SE O ESTADO É NULO----------------------------------------------------

IF :object_type= '2' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN		
		SELECT Count(*) INTO cnt FROM CRD1 a 
									INNER JOIN OCRD b on a."CardCode" = b."CardCode" 
									WHERE b."frozenFor" = 'N' 
									AND b."validFor" = 'Y' 
									AND a."CardCode" = :list_of_cols_val_tab_del 
									--AND a."Address" = 'ENTREGA'
								    AND COALESCE(a."State",'')='';					
						IF :cnt > 0 THEN
          						error := 2105;
								error_message := 'Estado não pode ser nulo';
						END IF;	
cnt = 0;
END IF;

------------ VERIFICA MUNICIPIO INFORMADO ----------------------------------------	

IF :object_type= '2' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN		
		SELECT Count(*) INTO cnt FROM CRD1 a 
									INNER JOIN OCRD b on a."CardCode" = b."CardCode" 
									WHERE b."frozenFor" = 'N' 
									AND b."validFor" = 'Y' 
									AND a."CardCode" = :list_of_cols_val_tab_del 
									--AND a."Address" = 'ENTREGA'
								    AND COALESCE(a."County",'')='';					
						IF :cnt > 0 THEN
          						error := 215;
								error_message := 'Municipio não pode ser nulo';
						END IF;	
cnt = 0;
END IF;

---------- VERIFICA SE O PAÍS É NULO------------------------------------------------------

IF :object_type= '2' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN		
		SELECT Count(*) INTO cnt FROM CRD1 a 
									INNER JOIN OCRD b on a."CardCode" = b."CardCode" 
									WHERE b."frozenFor" = 'N' 
									AND b."validFor" = 'Y' 
									AND a."CardCode" = :list_of_cols_val_tab_del 
									--AND a."Address" = 'ENTREGA'
								    AND COALESCE(a."Country",'')='';					
						IF :cnt > 0 THEN
          						error := 815;
								error_message := 'País não pode ser nulo';
						END IF;	
cnt = 0;
END IF;

------------ VERIFICA SE O CEP É NULO-------------------------------------------

IF :object_type= '2' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN		
		SELECT Count(*) INTO cnt FROM CRD1 a 
									INNER JOIN OCRD b on a."CardCode" = b."CardCode" 
									WHERE b."frozenFor" = 'N' 
									AND b."validFor" = 'Y' 
									AND a."CardCode" = :list_of_cols_val_tab_del 
									--AND a."Address" = 'ENTREGA'
								    AND COALESCE(a."ZipCode",'')='';					
						IF :cnt > 0 THEN
          						error := 2215;
								error_message := 'CEP não pode ser nulo';
						END IF;	
cnt = 0;
END IF;

------------ VERIFICA SE CNPJ OU CPF ESTÁ PREENCHIDO----------------------------------------

IF :object_type = '2' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	 	
 SELECT 
    (SELECT COUNT(*) 
    FROM CRD7 a 
        INNER JOIN OCRD b 
        ON a."CardCode" = b."CardCode" 
    WHERE "frozenFor" = 'N' 
    AND "validFor" = 'Y' 
    AND a."CardCode" = :list_of_cols_val_tab_del 
    AND a."Address" = b."ShipToDef" 
    AND a."AddrType" = 'S' 
    AND b."CardType" = 'C' 
    AND ifnull(a."TaxId0", '') = ''
    AND ifnull(a."TaxId4", '') = '' 
    AND b."State1" <> 'EX' 
    AND b."State2" <> 'EX') INTO temp_var_0 FROM DUMMY;
    IF :temp_var_0 > 0 THEN 
        error := 2007;
        error_message := 'Favor preencher CNPJ ou CPF!';
    END IF;
    temp_var_0 = 0;
END IF;

---------- VERIFICA SE CONSUMIDOR FINAL INFORMADO ----------------------------------------

IF :object_type= '2' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN		
		SELECT Count(*) INTO cnt FROM CRD7 a 
									INNER JOIN OCRD b on a."CardCode" = b."CardCode" 
									WHERE b."frozenFor" = 'N' 
									AND b."validFor" = 'Y' 
									AND a."CardCode" = :list_of_cols_val_tab_del 
									AND a."Address" = b."ShipToDef"
									AND (COALESCE(a."TaxId1",'Isento')='Isento' OR COALESCE(a."TaxId1",'')='' )
									AND b."State1" <> 'EX' 
									AND b."State2" <> 'EX'
									AND COALESCE(b."U_LGO_IndFinal",'')=''
									AND b."CardType" = 'C'
									AND b."DataSource" = 'I' ;					
						IF :cnt > 0 THEN
          						error := 214;
								error_message := 'Favor preencher o campo Consumidor final(NF-e)';
						END IF;	
cnt = 0;
END IF;

----------VERIFICA SE O CLIENTE É SUFRAMA------------------------------------------ 

IF :object_type= '2' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN		
		SELECT Count(*) INTO cnt FROM CRD7 a 
									INNER JOIN OCRD b on a."CardCode" = b."CardCode" 
									WHERE b."frozenFor" = 'N' 
									AND b."validFor" = 'Y' 
									AND a."CardCode" = :list_of_cols_val_tab_del 
									AND a."Address" = b."ShipToDef"
									AND (IFNULL(a."TaxId8",'')<>'' AND IFNULL(b."U_LGO_MotDesICMS",'')='' )
									AND b."State1" <> 'EX' 
									AND b."State2" <> 'EX'
									AND b."CardType" = 'C';	
						IF :cnt > 0 THEN
          						error := 2852;
								error_message := 'Favor preencher o campo Motivo da desoneração do ICMS';
						END IF;	
cnt = 0;
END IF;


----------Preencher Banco do parceiro de negócios------------------------------------------ 

IF :object_type= '2' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN	
		SELECT Count(*) INTO cnt FROM OCRD 
										WHERE "CardCode" = :list_of_cols_val_tab_del
										AND "CardType" = 'S' 
										AND   "validFor" = 'Y' 
										AND COALESCE("BankCountr",'') = '' ;	
						IF :cnt > 0 THEN
          						error := 8457;
								error_message := 'Favor preencher Banco do parceiro de negócios com "999" na aba Condições de Pagamento';
						END IF;	
cnt = 0;
END IF;	

-----------INSERE CPF NA OCRD------------------------------------------------------

IF (:object_type = '2' AND (:transaction_type = 'A' OR :transaction_type = 'U')) THEN
	UPDATE T0 SET T0."LicTradNum" = T1."TaxId4"
		FROM "OCRD" T0 
		INNER JOIN "CRD7" T1 
		ON T0."CardCode" = T1."CardCode"
		AND T0."ShipToDef" = T1."Address"
		WHERE T1."TaxId4" IS NOT NULL
	AND T0."CardCode" = :list_of_cols_val_tab_del;
END IF;

-----------INSERE CNPJ NA OCRD------------------------------------------------------

IF (:object_type = '2' AND (:transaction_type = 'A' OR :transaction_type = 'U')) THEN
	UPDATE T0 SET T0."LicTradNum" = T1."TaxId0"
		FROM "OCRD" T0 
		INNER JOIN "CRD7" T1 
		ON T0."CardCode" = T1."CardCode"
		AND T0."ShipToDef" = T1."Address"
		WHERE T1."TaxId0" IS NOT NULL
	AND T0."CardCode" = :list_of_cols_val_tab_del;
END IF;

----------INSERE DATA CRIAÇÃO/REVISÃO NA OCRD---

IF (:object_type = '2' AND (:transaction_type = 'A' OR :transaction_type = 'U')) THEN
	UPDATE T0 SET T0."U_RM_Revisao" = CURRENT_TIMESTAMP
		FROM "OCRD" T0 
		WHERE T0."CardCode" = :list_of_cols_val_tab_del;
END IF;




	
END