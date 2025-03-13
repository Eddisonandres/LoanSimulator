-- >> Procedure to insert a payment frequency << --
CREATE OR REPLACE PROCEDURE INSERT_PAYMENT_FREQUENCY (
    p_description IN PAYMENT_FREQUENCIES.DESCRIPTION%TYPE
) IS
    v_id NUMBER;
    v_exists NUMBER := 0;
    v_table_name TAB_ID.TABLE_NAME%TYPE := 'PAYMENT_FREQUENCIES';
BEGIN
    -- Ensure description is provided
    IF p_description IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Payment frequency description cannot be NULL');
    END IF;

    -- Check if the payment frequency already exists
    SELECT CASE WHEN EXISTS (
        SELECT 1 FROM PAYMENT_FREQUENCIES WHERE UPPER(DESCRIPTION) = UPPER(p_description)
    ) THEN 1 ELSE 0 END INTO v_exists FROM DUAL;

    IF v_exists = 0 THEN
        -- Generate a new frequency ID
        UPDATE_TAB_ID(v_table_name);
        v_id := FC_ID_TABLE(v_table_name);

        -- Insert new payment frequency
        INSERT INTO PAYMENT_FREQUENCIES (FREQUENCY_ID, DESCRIPTION)
        VALUES (v_id, UPPER(p_description));

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Payment frequency inserted successfully');
    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'The payment frequency already exists');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Exception handled: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;