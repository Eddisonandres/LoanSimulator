-- >> Procedure to insert a Product << --
CREATE OR REPLACE PROCEDURE INSERT_PRODUCT (
    -- parameters
    p_product_name IN PRODUCTS.PRODUCT_NAME%TYPE
) IS
    -- variables
    v_id NUMBER;
    v_exists NUMBER := 0;
    v_table_name TAB_ID.TABLE_NAME%TYPE := 'PRODUCTS';
BEGIN
    -- Ensure product name is provided
    IF p_product_name IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Product name cannot be NULL');
    END IF;

    -- Check if the product name already exists
    SELECT CASE WHEN EXISTS (
        SELECT 1 FROM PRODUCTS WHERE UPPER(PRODUCT_NAME) = UPPER(p_product_name)
    ) THEN 1 ELSE 0 END INTO v_exists FROM DUAL;

    IF v_exists = 0 THEN
        -- Generate a new product ID
        UPDATE_TAB_ID(v_table_name);
        v_id := FC_ID_TABLE(v_table_name);

        -- Insert new product
        INSERT INTO PRODUCTS (PRODUCT_ID, PRODUCT_NAME)
        VALUES (v_id, UPPER(p_product_name));

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Product inserted successfully');
    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'The product already exists');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Exception handled: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;