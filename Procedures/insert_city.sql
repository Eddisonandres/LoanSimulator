-- >> Procedure to create a city << --
CREATE OR REPLACE PROCEDURE INSERT_CITY (
    -- parameters
    p_city_name  IN CITIES.CITY_NAME%TYPE,
    p_province_id  IN CITIES.PROVINCE_ID%TYPE
) IS
    -- variables
    v_id NUMBER;
    v_exists NUMBER := 0;
    v_table_name TAB_ID.TABLE_NAME%TYPE := 'CITIES';
BEGIN
    -- Validate if the parameter is null
    IF p_city_name IS NULL or p_province_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Country id and province name and status cannot be NULL');
    END IF;

    -- Validate if the country already exists
    SELECT CASE WHEN EXISTS (
        SELECT 1 FROM CITIES WHERE UPPER(CITY_NAME) = UPPER(p_city_name) and 
        PROVINCE_ID = p_province_id
    ) THEN 1 ELSE 0 END INTO v_exists FROM DUAL;

    -- it is inserted if does not exist
    IF v_exists = 0 THEN
        UPDATE_TAB_ID(v_table_name);
        v_id := FC_ID_TABLE(v_table_name);

        INSERT INTO CITIES (CITY_ID, CITY_NAME, PROVINCE_ID) 
        VALUES (v_id, UPPER(p_city_name), p_province_id);

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('City inserted successfully');
    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'The City already exists');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Exception handled: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;