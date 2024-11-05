SELECT MAX(CASE	WHEN "adiantamento"."DocEntry" IS NOT NULL THEN o4."AcctName"
				WHEN "NE"."DocEntry" IS NOT NULL AND  "linha_recebimento"."DocEntry" IS NOT null THEN o2."AcctName"
				WHEN "NE"."DocEntry" IS NOT NULL AND "linha_recebimento"."DocEntry" IS NULL THEN o."AcctName"
				ELSE
				o3."AcctName"  
					END) "Conta",
		"linha_pagar"."SumApplied" AS "Valor",
		COALESCE ("NE"."Serial","LCM"."Number","pagar"."DocNum"  ) AS "Documento",
		"pagar"."CardCode" AS "Cód. Forn.",
		"pagar"."CardName" AS "Fornecedor",
		COALESCE ("NE"."DocDate" ,"LCM"."RefDate" ,"pagar"."DocDate" ) AS "Data",
		"pagar"."DocDueDate" AS "Vencimento"
FROM
	OVPM "pagar"
LEFT JOIN VPM2 "linha_pagar" ON	"linha_pagar"."DocNum" = "pagar"."DocEntry"
LEFT JOIN OPCH "NE" ON	"NE"."DocEntry" = "linha_pagar"."DocEntry"	AND "linha_pagar"."InvType" in ('18','30')
left JOIN PCH1 "linha_NE" ON	"linha_NE"."DocEntry" = "NE"."DocEntry"
LEFT JOIN OACT o ON	o."AcctCode" = "linha_NE"."AcctCode"
LEFT JOIN PDN1 "linha_recebimento" ON "linha_recebimento"."DocEntry" = "linha_NE"."BaseEntry"
LEFT JOIN OACT o2 ON o2."AcctCode" = "linha_recebimento"."AcctCode"
left JOIN odpo "adiantamento" ON "adiantamento"."DocEntry" = "linha_pagar"."baseAbs"
LEFT JOIN DPO1 "linha _adiantamento" ON "linha _adiantamento"."DocEntry" = "adiantamento"."DocEntry" 
left JOIN OACT o4 on o4."AcctCode"  = "linha _adiantamento"."AcctCode"
LEFT JOIN OJDT "LCM" ON "LCM"."TransId" = "linha_pagar"."DocTransId" AND "linha_pagar"."InvType" = ('30')
LEFT JOIN JDT1 "linha_LCM" ON "linha_LCM"."TransId" = "LCM"."TransId" 
left JOIN OACT o3 on o3."AcctCode"  = "linha_LCM"."Account"
WHERE
	"pagar"."Canceled" = 'N'
	--AND "pagar"."DocNum" = '36232'
	--AND "pagar"."CardCode" = 'FN002173'
	AND YEAR("pagar"."DocDate" ) >= '2022'
	GROUP BY "linha_pagar"."SumApplied",
	"NE"."Serial",
	"pagar"."CardCode",
		"pagar"."CardName" ,"NE"."DocDate" ,
		"pagar"."DocDueDate" ,"LCM"."Number"
		,"pagar"."DocNum" ,"LCM"."RefDate" ,"pagar"."DocDate"
		ORDER BY "pagar"."DocDueDate" desc
