alter PROCEDURE SBO_SP_TransactionNotification_Object_202

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
* Objeto    : Produção 
  Documento : Ordem de produção
**************************************************************************/

--- Preenchimento de Lote automatico na Ordem de produção para produtos acabados e Discos --

If :object_type= '202' And :transaction_type='U' Then

update T1 set "U_LGO_LoteProd" = 
	Case 
		when T0."U_LG_FamProd" <> 'SA' -- Regras para formação do lote de Produto acabado (familia+sequencial) exemplo AA00001
			then 
				(select 
				          CONCAT(
				          T0."U_LG_FamProd",
												(select 
												          right(CONCAT('0000'
																			,IFNULL(substring(max(T1."U_LGO_LoteProd"),3,5),0)
																	+1)
															,5)
												 from OWOR T1
												 left join OITM T0 on T1."ItemCode" = T0."ItemCode"
												 where substring(T1."U_LGO_LoteProd",1,2) =
																			(select T0."U_LG_FamProd"
																			 from OITM T0
																			 left join OWOR T1 on T0."ItemCode" = t1."ItemCode"
																			 where T1."DocEntry" = :list_of_cols_val_tab_del)
															     ) 
											     ) 
								
			 from OWOR T1
			 left join OITM T0 on T1."ItemCode" = T0."ItemCode"
			 where T1."Type" = 'S'
			 and T1."Status" = 'R'
			 and IFNULL(T1."U_LGO_LoteProd",'') = ''
			 and T1."DocEntry" = :list_of_cols_val_tab_del
			 )

	
		when T0."U_LG_FamProd" = 'SA' -- Regras para formação do lote de Discos (Ano+Semana+sequencial)
			then 
				(select (
									case													-- Ano representado por letras. Até o Z
											when YEAR (CURRENT_DATE) = 2017 or YEAR (CURRENT_DATE) = 2040 then 'A' 
											when YEAR (CURRENT_DATE) = 2018 or YEAR (CURRENT_DATE) = 2041 then 'B' 
											when YEAR (CURRENT_DATE) = 2019 or YEAR (CURRENT_DATE) = 2042 then 'C' 
											when YEAR (CURRENT_DATE) = 2020 or YEAR (CURRENT_DATE) = 2043 then 'D' 
											when YEAR (CURRENT_DATE) = 2021 or YEAR (CURRENT_DATE) = 2044 then 'E' 
											when YEAR (CURRENT_DATE) = 2022 or YEAR (CURRENT_DATE) = 2045 then 'F' 
											when YEAR (CURRENT_DATE) = 2023 or YEAR (CURRENT_DATE) = 2046 then 'G' 
											when YEAR (CURRENT_DATE) = 2024 or YEAR (CURRENT_DATE) = 2047 then 'H' 
											when YEAR (CURRENT_DATE) = 2025 or YEAR (CURRENT_DATE) = 2048 then 'I' 
											when YEAR (CURRENT_DATE) = 2026 or YEAR (CURRENT_DATE) = 2049 then 'J' 
											when YEAR (CURRENT_DATE) = 2027 or YEAR (CURRENT_DATE) = 2050 then 'L' 
											when YEAR (CURRENT_DATE) = 2028 or YEAR (CURRENT_DATE) = 2051 then 'M' 
											when YEAR (CURRENT_DATE) = 2029 or YEAR (CURRENT_DATE) = 2052 then 'N' 
											when YEAR (CURRENT_DATE) = 2030 or YEAR (CURRENT_DATE) = 2053 then 'O' 
											when YEAR (CURRENT_DATE) = 2031 or YEAR (CURRENT_DATE) = 2054 then 'P' 
											when YEAR (CURRENT_DATE) = 2032 or YEAR (CURRENT_DATE) = 2055 then 'Q' 
											when YEAR (CURRENT_DATE) = 2033 or YEAR (CURRENT_DATE) = 2056 then 'R' 
											when YEAR (CURRENT_DATE) = 2034 or YEAR (CURRENT_DATE) = 2057 then 'S' 
											when YEAR (CURRENT_DATE) = 2035 or YEAR (CURRENT_DATE) = 2058 then 'T' 
											when YEAR (CURRENT_DATE) = 2036 or YEAR (CURRENT_DATE) = 2059 then 'U' 
											when YEAR (CURRENT_DATE) = 2037 or YEAR (CURRENT_DATE) = 2060 then 'Z' 
											when YEAR (CURRENT_DATE) = 2038 or YEAR (CURRENT_DATE) = 2061 then 'X' 
											when YEAR (CURRENT_DATE) = 2039 or YEAR (CURRENT_DATE) = 2062 then 'Z' 
									end
								)||
											(Select WEEK (CURRENT_DATE)FROM DUMMY)				
								 ||	
								 			(select right(
								 							Concat(	
								 									'000',IFNULL
								 												(substring(	
								 															max(
								 																"U_LGO_LoteProd"),4,4),'0')
								 									+1),
								 						4) 
								from OWOR 
								where substring("U_LGO_LoteProd",1,3) =
													(select
																case											
																		when YEAR (CURRENT_DATE) = 2017 or YEAR (CURRENT_DATE) = 2040 then 'A' 
																		when YEAR (CURRENT_DATE) = 2018 or YEAR (CURRENT_DATE) = 2041 then 'B' 
																		when YEAR (CURRENT_DATE) = 2019 or YEAR (CURRENT_DATE) = 2042 then 'C' 
																		when YEAR (CURRENT_DATE) = 2020 or YEAR (CURRENT_DATE) = 2043 then 'D' 
																		when YEAR (CURRENT_DATE) = 2021 or YEAR (CURRENT_DATE) = 2044 then 'E' 
																		when YEAR (CURRENT_DATE) = 2022 or YEAR (CURRENT_DATE) = 2045 then 'F' 
																		when YEAR (CURRENT_DATE) = 2023 or YEAR (CURRENT_DATE) = 2046 then 'G' 
																		when YEAR (CURRENT_DATE) = 2024 or YEAR (CURRENT_DATE) = 2047 then 'H' 
																		when YEAR (CURRENT_DATE) = 2025 or YEAR (CURRENT_DATE) = 2048 then 'I' 
																		when YEAR (CURRENT_DATE) = 2026 or YEAR (CURRENT_DATE) = 2049 then 'J' 
																		when YEAR (CURRENT_DATE) = 2027 or YEAR (CURRENT_DATE) = 2050 then 'L' 
																		when YEAR (CURRENT_DATE) = 2028 or YEAR (CURRENT_DATE) = 2051 then 'M' 
																		when YEAR (CURRENT_DATE) = 2029 or YEAR (CURRENT_DATE) = 2052 then 'N' 
																		when YEAR (CURRENT_DATE) = 2030 or YEAR (CURRENT_DATE) = 2053 then 'O' 
																		when YEAR (CURRENT_DATE) = 2031 or YEAR (CURRENT_DATE) = 2054 then 'P' 
																		when YEAR (CURRENT_DATE) = 2032 or YEAR (CURRENT_DATE) = 2055 then 'Q' 
																		when YEAR (CURRENT_DATE) = 2033 or YEAR (CURRENT_DATE) = 2056 then 'R' 
																		when YEAR (CURRENT_DATE) = 2034 or YEAR (CURRENT_DATE) = 2057 then 'S' 
																		when YEAR (CURRENT_DATE) = 2035 or YEAR (CURRENT_DATE) = 2058 then 'T' 
																		when YEAR (CURRENT_DATE) = 2036 or YEAR (CURRENT_DATE) = 2059 then 'U' 
																		when YEAR (CURRENT_DATE) = 2037 or YEAR (CURRENT_DATE) = 2060 then 'Z' 
																		when YEAR (CURRENT_DATE) = 2038 or YEAR (CURRENT_DATE) = 2061 then 'X' 
																		when YEAR (CURRENT_DATE) = 2039 or YEAR (CURRENT_DATE) = 2062 then 'Z'
																end
																		|| '' ||
													 						  (Select WEEK (CURRENT_DATE)FROM DUMMY)	
																					from OWOR T1
																					left join OITM T0 on T0."ItemCode" = T1."ItemCode"
																					where T1."DocEntry" = :list_of_cols_val_tab_del
																			   )
													)
													--where t1.Docnum = '8519'))) -- número OP
				from OITM T0
				left join OWOR T1 on T0."ItemCode" = T1."ItemCode" where T1."DocEntry" = :list_of_cols_val_tab_del
			   )
				--*/'0'
   end

from OWOR T1
left join OITM T0 on T1."ItemCode" = T0."ItemCode"
where T1."Type" = 'S'
and T1."Status" = 'R'
and IFNULL(T1."U_LGO_LoteProd",'') = '' 
and T1."DocEntry" = :list_of_cols_val_tab_del;
	
	
END IF;
--Atualiza campo Revestimento na OP.

IF :object_type= '202' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN 
    UPDATE T1 SET "U_RM_Revestimento" = T0."U_RM_Revestimento"
    FROM OWOR T1 
        LEFT OUTER JOIN OITM T0 ON T1."ItemCode" = T0."ItemCode" 
    WHERE T1."DocEntry" = :list_of_cols_val_tab_del;
END IF;


--Atualiza campo Setor na OP.

IF :object_type= '202' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN
    UPDATE T1 SET "U_RM_Setor" = T0."U_RM_Setor" 
    FROM OWOR T1 
        LEFT OUTER JOIN OITM T0 ON T1."ItemCode" = T0."ItemCode"
    WHERE T1."DocEntry" = :list_of_cols_val_tab_del;
END IF;

--Trava não permitir gerar OP com estrutura diferente de Liberada.

IF :object_type= '202' AND (:transaction_type = 'A' OR  :transaction_type = 'U')THEN
    SELECT 
    (SELECT COUNT(*) 
    FROM OWOR T0 
        INNER JOIN OITT T2 ON T0."ItemCode" = T2."Code"
    WHERE T2."U_RM_StatusEst" <> 'L' AND T0."DocEntry" = :list_of_cols_val_tab_del) INTO temp_var_0 FROM DUMMY;
    IF :temp_var_0 > 0 THEN 
        error := -8001;
        error_message := 'Verificar Status da Estrutura';
    END IF;
END IF;

-- Atualiza campo de usuário quando o Item é Industrializado por terceiros

IF :object_type = '202' AND :transaction_type IN ('A') THEN 
    UPDATE A SET A."U_RM_Terceiros" = 'Y' 
    FROM "OWOR" A 
    LEFT JOIN "OITM" B 
        ON A."ItemCode" = B."ItemCode"
    WHERE B."U_RM_Terceiros" = 'Y' 
    AND A."DocEntry" = :list_of_cols_val_tab_del;
END IF;




-- No momento de encerrar OP, verifica se existe apontamento de horas - Chamado 44288 

IF :object_type = '202' and :transaction_type in ('U') THEN-- Update 

			IF (
					(
						Select Count(*) from 
    									(Select 
        									T0."DocEntry",
        									Count(Distinct T1."U_Posicao"
        					 					 ) "Apontar",
        												(
       				 										Select Count(Distinct T3."U_Posicao"
       													) 
       													from "@LGDRPTPRO" T2
       				 									Inner Join "@LGLDRPTPRO" T3 on T3."DocEntry" = T2."DocEntry"
       										 			Where T2."U_DocNumOP" = T0."DocEntry" and Coalesce(T3."U_QtdReal",0
     			  																							) <> 0 
        								) "Apontado"
       	   						from OWOR T0
       	  						Inner Join "@LGLCROT" T1 on T1."Code" = T0."U_LG_Roteiro"
           						Where T0."Status" = 'L' 
		   						and T0."DocEntry" = :list_of_cols_val_tab_del
           						Group By T0."DocEntry"										   
    				) T4 
    			Where "Apontar" <> "Apontado"
   			 ) > 0)
   			  THEN 
    		  error := '20207';
			  error_message := 'Falta apontamento. Favor verificar.';
	END IF;

END IF;


--Verifica se existe Apontamento de horas para essa OP 

IF :object_type = '202' and :transaction_type in ('U') THEN

  				IF not exists(select Count(*)
                     				from "@LGDRPTPRO"
                    				where "U_DocNumOP" = :list_of_cols_val_tab_del           
                			  )
    					THEN
    
       				 	 error := '20210';
					     error_message := 'Inconsistência: Não existe apontamento de horas para essa OP!';
    
				END IF;
END IF;


END;