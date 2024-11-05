;WITH ResumoVendas AS (
	SELECT r."ItemCode" "Cod. Produto",
	r."U_RM_CodRef" "Cod. Ref" ,
	r."Dscription" "Descrição",
	sum(r."Quantity") "Qtde Pedido",
	sum(r."LineTotal") "Total Item"
	FROM RDR1 r 
	WHERE YEAR(r."DocDate") >='2024'
	GROUP BY r."ItemCode",r."U_RM_CodRef",r."Dscription" ),
PercFaturamento AS (
	SELECT 
	"Cod. Produto",
	"Cod. Ref",
	"Descrição",
	"Qtde Pedido",
	"Total Item",
	sum("Qtde Pedido") over() AS "Total Acumulado",
	"Qtde Pedido" / sum("Qtde Pedido") over() * 100 AS "Percentual"
	FROM ResumoVendas),
CurvaABC AS (
	SELECT 
	"Cod. Produto",
	"Cod. Ref",
	"Descrição",
	"Qtde Pedido",
	"Total Item",
	"Total Acumulado",
	"Percentual",
	sum("Percentual") over(ORDER BY "Qtde Pedido" DESC) AS "Percentual Acumulado"
	FROM PercFaturamento)
SELECT 
	"Cod. Produto",
	"Cod. Ref",
	"Descrição",
	"Qtde Pedido",
	"Total Item",
	CONCAT(ROUND("Percentual", 6), '%') AS "Percentual",
	CONCAT(ROUND("Percentual Acumulado", 6), '%') AS "Percentual Acumulado",
	CASE WHEN "Percentual Acumulado" <= 80 THEN 'A'
	WHEN "Percentual Acumulado" <= 95 then   'B'
	ELSE 'C'
	END AS "Curva"
	FROM CurvaABC
