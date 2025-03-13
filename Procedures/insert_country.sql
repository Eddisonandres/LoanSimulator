-- >> Procedure to create a country << --
CREATE OR REPLACE PROCEDURE INSERT_COUNTRY (
    p_country_name  IN COUNTRIES.COUNTRY_NAME%TYPE
) IS
    v_id NUMBER;
    v_exists NUMBER := 0;
    v_table_name TAB_ID.TABLE_NAME%TYPE := 'COUNTRIES';
BEGIN
    -- Validate if the parameter is null
    IF p_country_name IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Country name and status cannot be NULL');
    END IF;

    -- Validate if the country already exists
    SELECT CASE WHEN EXISTS (
        SELECT 1 FROM COUNTRIES WHERE UPPER(COUNTRY_NAME) = UPPER(p_country_name)
    ) THEN 1 ELSE 0 END INTO v_exists FROM DUAL;

    -- it is inserted if does not exist
    IF v_exists = 0 THEN
        UPDATE_TAB_ID(v_table_name);
        v_id := FC_ID_TABLE(v_table_name);

        INSERT INTO COUNTRIES (COUNTRY_ID, COUNTRY_NAME) 
        VALUES (v_id, UPPER(p_country_name));

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Country inserted successfully');
    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'The country already exists');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Exception handled: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;