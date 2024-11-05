CREATE view "SBOPRODRM"."RM_StatusPedidoCompras"
AS
SELECT 
	"NumeroPedido"
   ,MAX("NumeroNotaFiscal") as "NumeroNotaFiscal"
   ,MAX("NotaEntrega")as "NotaEntrega"
   ,MAX("NotaPedido")as "NotaPedido"
   ,MAX("PedidoEntrega")as "PedidoEntrega"
   ,COUNT(DISTINCT "TargetType")as "QtdTarget"
   ,Max ("ViaMobile")as "ViaMobile"
   ,Max("StPedido")as "StPedido"
   ,Max("Cancelado")as "Cancelado"
   ,Max("DataLib")as "DataLib"
   ,Max("DocStatus")as "DocStatus"
   ,MAX("Código")as "Codigo"
   ,max("Nome")as "Nome"
   ,max("Cidade")as "Cidade"
   ,max("Total")as "Total"
   ,max("Vendedor")as "Vendedor"
   ,max("DtPedido")as "DtPedido"
   ,max("DtEntrega") as "DtEntrega"
   ,MAX("CondPag")as "CondPag"
   ,MAX("Utilização")as "Utilização"
   ,MAX("NParcelas") as "NParcelas"
   ,TAB1."Dias" as "Dias"
FROM (SELECT
		T0."DocEntry" AS "NumeroPedido"
	   ,COALESCE(T4."DocEntry", T3."DocEntry") AS "NumeroNotaFiscal"
	   ,T4."DocEntry" AS "NotaEntrega"
	   ,T3."DocEntry" AS "NotaPedido"
	   ,T2."DocEntry" AS "PedidoEntrega"
	   ,T1."TargetType" 
	   ,IFNULL(T0."U_LGO_ViaMobile",'N') AS "ViaMobile"
	   ,T0."U_RM_StPedido" AS "StPedido"
	   ,T0."CANCELED" AS "Cancelado"
	   ,T0."U_LGO_DataLib" AS "DataLib"
	      ,CASE 
						WHEN T0."CANCELED" = 'Y' THEN 'Cancelado'
						WHEN COALESCE(T4."DocEntry", T3."DocEntry") IS NOT NULL THEN 'Faturado'
						WHEN T2."DocEntry"  IS NOT NULL AND T1."TargetType" > 1 AND COALESCE(T4."DocEntry", T3."DocEntry") IS NULL and O."DocStatus" = 'C' THEN 'Em Cancelamento'
						WHEN T2."DocEntry"  IS NOT NULL AND T1."TargetType" > 1 AND COALESCE(T4."DocEntry", T3."DocEntry") IS NULL and O."DocStatus" = 'O' THEN 'Em Processamento'
						WHEN T2."DocEntry"  IS NOT NULL AND T1."TargetType" = 1 AND COALESCE(T4."DocEntry", T3."DocEntry") IS NULL THEN 'Processado'
						ELSE
						 'Digitado'
					  END AS "DocStatus" 
	,T5."CardCode" AS "Código"
	,T5."CardName" as "Nome"
	,T0."U_RM_Cidade" as "Cidade"
	,T0."DocTotal" as "Total"
	,T9."SlpName" as "Vendedor"
	,T0."DocDate" as "DtPedido"
	,T0."DocDueDate" as "DtEntrega"
	,B."PymntGroup" AS "CondPag"
	,T8."Usage" as "Utilização"
	,b."InstNum" as "NParcelas"
	,c."InstDays" as "Dias"
	FROM  "OPOR" T0 
		INNER JOIN "POR1" T1 
		ON T1."DocEntry" = T0."DocEntry"
	LEFT JOIN "PDN1" T2 
		ON (T2."BaseType" = T1."ObjType"
		AND T2."BaseEntry" = T1."DocEntry"
		AND T2."BaseLine" = T1."LineNum")
	LEFT JOIN "PCH1" T3 
		ON (T3."BaseType" = T1."ObjType"
		AND T3."BaseEntry" = T1."DocEntry"
		AND T3."BaseLine" = T1."LineNum")
	LEFT JOIN "PCH1" T4  
		ON (T4."BaseType" = T2."ObjType"
		AND T4."BaseEntry" = T2."DocEntry"
		AND T4."BaseLine" = T2."LineNum")
	left JOIN "OCRD"  T5 
	ON T5."CardCode" = T0."CardCode"
	left join "OSLP" T9  on T9."SlpCode" = T0."SlpCode"
	left JOIN "OCTG" B 
	ON B."GroupNum" = T0."GroupNum"
	LEFT JOIN "OUSG" T8 ON T1."Usage" = T8."ID"
	left join "ODLN" O on O."DocEntry" = T2."DocEntry"
	left join "CTG1" C on c."CTGCode" = b."GroupNum"
) "TAB1"
GROUP BY "NumeroPedido",TAB1."Dias"