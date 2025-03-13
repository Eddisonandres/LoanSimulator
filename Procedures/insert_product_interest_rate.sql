-- >> Procedure to insert a rate to the loans << --
CREATE OR REPLACE PROCEDURE INSERT_PRODUCT_INTEREST_RATE (
    p_product_id IN PRODUCT_INTEREST_RATES.PRODUCT_ID%TYPE,
    p_term_id IN PRODUCT_INTEREST_RATES.TERM_ID%TYPE,
    p_interest_rate IN PRODUCT_INTEREST_RATES.INTEREST_RATE%TYPE,
    p_date_effective IN PRODUCT_INTEREST_RATES.DATE_EFFECTIVE%TYPE
) IS
    v_id NUMBER;
    v_exists NUMBER := 0;
    v_table_name TAB_ID.TABLE_NAME%TYPE := 'PRODUCT_INTEREST_RATES';
BEGIN
    -- Ensure all required parameters are provided
    IF p_product_id IS NULL OR p_term_id IS NULL OR p_interest_rate IS NULL OR p_date_effective IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Product ID, Term ID, Interest Rate, and Effective Date cannot be NULL');
    END IF;

    -- Validate that the interest rate is positive
    IF p_interest_rate <= 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Interest rate must be greater than zero');
    END IF;

    -- Check if the same product-term combination already has an interest rate
    SELECT CASE WHEN EXISTS (
        SELECT 1 FROM PRODUCT_INTEREST_RATES 
        WHERE PRODUCT_ID = p_product_id AND TERM_ID = p_term_id AND DATE_EFFECTIVE = p_date_effective
    ) THEN 1 ELSE 0 END INTO v_exists FROM DUAL;

    IF v_exists = 0 THEN
        -- Generate a new RATE_ID
        UPDATE_TAB_ID(v_table_name);
        v_id := FC_ID_TABLE(v_table_name);

        -- Insert new interest rate
        INSERT INTO PRODUCT_INTEREST_RATES (RATE_ID, PRODUCT_ID, TERM_ID, INTEREST_RATE, DATE_EFFECTIVE)
        VALUES (v_id, p_product_id, p_term_id, p_interest_rate, p_date_effective);

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Interest rate inserted successfully');
    ELSE
        RAISE_APPLICATION_ERROR(-20003, 'An interest rate for this product and term already exists for the given date');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Exception handled: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;