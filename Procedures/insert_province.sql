-- >> Procedure to create a province << --
CREATE OR REPLACE PROCEDURE INSERT_PROVINCE (
    p_province_name  IN PROVINCES.PROVINCE_NAME%TYPE,
    p_country_id  IN PROVINCES.PROVINCE_ID%TYPE
) IS
    v_id NUMBER;
    v_exists NUMBER := 0;
    v_table_name TAB_ID.TABLE_NAME%TYPE := 'PROVINCES';
BEGIN
    -- Validate if the parameter is null
    IF p_province_name IS NULL or p_country_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Country id and province name and status cannot be NULL');
    END IF;

    -- Validate if the country already exists
    SELECT CASE WHEN EXISTS (
        SELECT 1 FROM PROVINCES WHERE UPPER(PROVINCE_NAME) = UPPER(p_province_name)
    ) THEN 1 ELSE 0 END INTO v_exists FROM DUAL;

    -- it is inserted if does not exist
    IF v_exists = 0 THEN
        UPDATE_TAB_ID(v_table_name);
        v_id := FC_ID_TABLE(v_table_name);

        INSERT INTO PROVINCES (PROVINCE_ID, PROVINCE_NAME, COUNTRY_ID) 
        VALUES (v_id, UPPER(p_province_name), p_country_id);

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Province inserted successfully');
    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'The Province already exists');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Exception handled: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;