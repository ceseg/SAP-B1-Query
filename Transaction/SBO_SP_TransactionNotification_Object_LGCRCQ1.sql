alter PROCEDURE SBO_SP_TransactionNotification_Object_LGCRCQ1

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
* Objeto    : QUALIDADE
  Documento : Ficha de Analise
**************************************************************************/

------ Valida��o de campos obrIgat�rios Ficha de qualidade

IF :object_type = 'LGCRCQ1' AND :transaction_type IN ('U') THEN 

 SELECT 
    (SELECT COUNT(*) 
    FROM "@LGCRCQ1" T0
        INNER JOIN OPDN T1 ON T0."U_NumDoc" = T1."DocNum" 
    WHERE (coalesce(T0."U_DataIns", '') = '') AND
         "Code" = :list_of_cols_val_tab_del) INTO temp_var_0 FROM DUMMY;
    IF :temp_var_0 > 0 THEN 
        error := 100;
        error_message := 'O campo Data de inspe��o � obrigat�rio';
    END IF;
temp_var_0 = 0;    
END IF;

IF :object_type = 'LGCRCQ1' AND :transaction_type IN ('U') THEN 
 SELECT 
    (SELECT COUNT(*) 
    FROM "@LGCRCQ1" T0
        INNER JOIN OPDN T1 ON T0."U_NumDoc" = T1."DocNum" 
    WHERE (coalesce(T0."U_DataEmi", '') = '') AND
         "Code" = :list_of_cols_val_tab_del) INTO temp_var_0 FROM DUMMY;
    IF :temp_var_0 > 0 THEN 
        error := 101;
        error_message := 'O campo Data de Emiss�o � obrigat�rio';
    END IF;
temp_var_0 = 0;    
END IF;

IF :object_type = 'LGCRCQ1' AND :transaction_type IN ('U') THEN 
 SELECT 
    (SELECT COUNT(*) 
    FROM "@LGCRCQ1" T0
        INNER JOIN OPDN T1 ON T0."U_NumDoc" = T1."DocNum" 
    WHERE (coalesce(T0."U_Aprovador", '') = '') AND
         "Code" = :list_of_cols_val_tab_del) INTO temp_var_0 FROM DUMMY;
    IF :temp_var_0 > 0 THEN 
        error := 102;
        error_message := 'O campo Aprovador � obrigat�rio';
    END IF;
temp_var_0 = 0;    
END IF;

IF :object_type = 'LGCRCQ1' AND :transaction_type IN ('U') THEN 
 SELECT 
    (SELECT COUNT(*) 
    FROM "@LGCRCQ1" T0
        INNER JOIN OPDN T1 ON T0."U_NumDoc" = T1."DocNum" 
    WHERE (coalesce(T0."U_FormAnal", '') = '') AND
         "Code" = :list_of_cols_val_tab_del) INTO temp_var_0 FROM DUMMY;
    IF :temp_var_0 > 0 THEN 
        error := 103;
        error_message := 'O campo Forma an�lise � obrigat�rio';
    END IF;
temp_var_0 = 0;    
END IF;

IF :object_type = 'LGCRCQ1' AND :transaction_type IN ('U') THEN 
 SELECT 
    (SELECT COUNT(*) 
    FROM "@LGCRCQ1" T0
        INNER JOIN OPDN T1 ON T0."U_NumDoc" = T1."DocNum" 
    WHERE (coalesce(T0."U_StatusL", '') = '') AND
         "Code" = :list_of_cols_val_tab_del) INTO temp_var_0 FROM DUMMY;
    IF :temp_var_0 > 0 THEN 
        error := 104;
        error_message := 'O campo Status da Ficha � obrigat�rio';
    END IF;
temp_var_0 = 0;    
END IF;
      

END