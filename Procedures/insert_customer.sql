-- >> Procedure to insert a customer << --
CREATE OR REPLACE PROCEDURE INSERT_CUSTOMER (
    -- parameters
    p_firstname  IN CUSTOMERS.CUSTOMER_FIRSTNAME%TYPE,
    p_lastname  IN CUSTOMERS.CUSTOMER_LASTNAME%TYPE,
    p_birthday IN CUSTOMERS.DATE_OF_BIRTH%TYPE,
    p_residence_city IN CUSTOMERS.RESIDENCE_CITY_ID%TYPE,
    p_email IN CUSTOMERS.EMAIL%TYPE,
    p_phone IN CUSTOMERS.PHONE_NUMBER%TYPE,
    p_address IN CUSTOMERS.ADDRESS%TYPE,
    p_occupation IN CUSTOMERS.OCCUPATION%TYPE,
    p_income IN CUSTOMERS.INCOME%TYPE,
    p_marital_status_id IN CUSTOMERS.MARITAL_STATUS_ID%TYPE,
    p_gender_id IN CUSTOMERS.GENDER_ID%TYPE
) IS
    -- variables
    v_id NUMBER;
    v_exists NUMBER := 0;
    v_table_name TAB_ID.TABLE_NAME%TYPE := 'CUSTOMERS';
BEGIN
    -- Check if mandatory fields are NULL
    IF p_firstname IS NULL OR p_lastname IS NULL OR p_email IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Customer first name, last name and email cannot be NULL');
    END IF;

    -- Validate email format
    IF NOT REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
        RAISE_APPLICATION_ERROR(-20003, 'Invalid email format');
    END IF;

    -- Check if the email already exists
    SELECT CASE WHEN EXISTS (
        SELECT 1 FROM CUSTOMERS WHERE UPPER(EMAIL) = UPPER(p_email)
    ) THEN 1 ELSE 0 END INTO v_exists FROM DUAL;

    IF v_exists = 0 THEN
        UPDATE_TAB_ID(v_table_name);
        v_id := FC_ID_TABLE(v_table_name);

        -- Insert new customer record
        INSERT INTO CUSTOMERS (CUSTOMER_ID, CUSTOMER_FIRSTNAME, CUSTOMER_LASTNAME,
            DATE_OF_BIRTH, RESIDENCE_CITY_ID, EMAIL, PHONE_NUMBER, ADDRESS,
            OCCUPATION, INCOME, MARITAL_STATUS_ID, GENDER_ID) 
        VALUES (v_id, UPPER(p_firstname), UPPER(p_lastname), 
            p_birthday, p_residence_city, LOWER(p_email),
            p_phone, p_address, p_occupation, p_income, p_marital_status_id,
            p_gender_id);

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Customer inserted successfully');
    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'The customer email already exists');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Exception handled: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;