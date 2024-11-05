Create PROCEDURE SBO_SP_TransactionNotification_Object_14

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
SWV_ORIN__var0 INTEGER;
    

BEGIN

/**************************************************************************
* Objeto    : Vendas
* Documento : Devolução NF de Saída
**************************************************************************/

IF  :object_type = '14'  and (:transaction_type = 'A' OR :transaction_type = 'U') then
      select  "Serial", "CardCode" INTO v_NRef,v_CodCliente FROM ORIN WHERE "DocEntry" = :list_of_cols_val_tab_del and "SeqCode" = '-2';      
      Select count(*) INTO SWV_ORIN__var0 FROM ORIN WHERE "Serial"  = :v_NRef
      AND "CardCode"  = :v_CodCliente
      AND "DocEntry"  != :list_of_cols_val_tab_del
      AND "SeqCode" = '-2'
      AND ("InvntSttus" <> 'C');
      IF(Select count(*) FROM ORIN
      WHERE "Serial"  = :v_NRef
      AND "CardCode"  = :v_CodCliente
      AND ("InvntSttus" <> 'C')
      AND "DocEntry"  != :list_of_cols_val_tab_del) > 0 then
       
         error := 4117;
         error_message := 'Número de NF ' || :v_NRef || ' já existe para o cliente ' || :v_CodCliente || '';
      end if;
   end if;


	
END