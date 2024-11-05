SELECT	x."ItemCode",x."Serial",x."DocDate",x."ItemName",x."ItmsGrpNam",x."BuyUnitMsr",	x."Quantity",x."Price",x."LineTotal",
	x."PIS",x."COFINS",	x."ICMS",x."IPI" FROM (SELECT a."ItemCode",a."ItemName",b."Quantity",b."Price",b."LineTotal", b."DocDate" 
	,o."Serial",a."BuyUnitMsr",t."ItmsGrpNam",
		(SELECT i."TaxSum" FROM PCH4 i INNER JOIN OSTT T2 ON
	           i."staType" = T2."AbsId" WHERE o."DocEntry" = i."DocEntry" AND i."LineNum" = b."LineNum" AND T2."Name" IN ('PIS')) AS "PIS",
	    (SELECT i."TaxSum" FROM PCH4 i INNER JOIN OSTT T2 ON
	           i."staType" = T2."AbsId" WHERE o."DocEntry" = i."DocEntry" AND i."LineNum" = b."LineNum" AND T2."Name" IN ('COFINS')) AS "COFINS",
	    (SELECT i."TaxSum" FROM PCH4 i INNER JOIN OSTT T2 ON
	           i."staType" = T2."AbsId" WHERE o."DocEntry" = i."DocEntry" AND i."LineNum" = b."LineNum" AND T2."Name" IN ('ICMS')) AS "ICMS",
	    (SELECT i."TaxSum" FROM PCH4 i INNER JOIN OSTT T2 ON
	           i."staType" = T2."AbsId" WHERE o."DocEntry" = i."DocEntry" AND i."LineNum" = b."LineNum" AND T2."Name" IN ('IPI')) AS "IPI"
	FROM oitm a 
	INNER JOIN PCH1 b ON a."ItemCode" = b."ItemCode"
	INNER JOIN OPCH o ON o."DocEntry" = b."DocEntry"
	INNER JOIN OITB t ON a."ItmsGrpCod" = t."ItmsGrpCod"
	WHERE
	 o.CANCELED = 'N'
		AND b."DocDate" = (	SELECT	MAX(q."DocDate") FROM PCH1 q WHERE	q."ItemCode" = a."ItemCode")) AS x
WHERE	x."Price" =  (	SELECT		MAX(z."Price")	FROM	oitm y	INNER JOIN PCH1 z ON	y."ItemCode" = z."ItemCode"
	WHERE	z."DocDate" =       (SELECT	MAX(r."DocDate") FROM PCH1 r	WHERE	r."ItemCode" = y."ItemCode")  AND y."ItemCode" = 'CP565EB.0006');