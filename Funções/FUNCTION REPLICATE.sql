CREATE FUNCTION REPLICATE(input NVARCHAR(1000), count INT)
RETURNS output NVARCHAR(1000)
LANGUAGE SQLSCRIPT AS
BEGIN
    DECLARE i INT = 1;
    output := '';
    FOR i IN 1 .. count DO
        output := output || input;
    END FOR;
END;