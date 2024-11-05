Begin
declare ano integer;
declare lote varchar(3);
SELECT 
CASE 
    WHEN YEAR(NOW()) = 2018 THEN 0 
    WHEN YEAR(NOW()) = 2019 THEN 1 
    WHEN YEAR(NOW()) = 2020 THEN 2 
    WHEN YEAR(NOW()) = 2021 THEN 3 
    WHEN YEAR(NOW()) = 2022 THEN 4
    WHEN YEAR(NOW()) = 2023 THEN 5
    WHEN YEAR(NOW()) = 2023 THEN 6 
END INTO ano FROM DUMMY;
SELECT ('L' || CHAR(:ano + 65) || '%') INTO lote FROM DUMMY;
SELECT 
    CASE 
        WHEN MAX("DistNumber") IS NULL THEN LEFT(:lote, 2) || '000000001' 
        ELSE LEFT(MAX("DistNumber"), 2) || RIGHT('00000000' || CAST(RIGHT(MAX("DistNumber"), 9) +1 AS varchar(12)), 9) 
    END 
FROM OBTN 
WHERE "DistNumber" LIKE :lote AND LENGTH("DistNumber") = '11';
End;