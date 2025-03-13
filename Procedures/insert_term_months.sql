-- >> Procedure to insert the term months to the loans << --
CREATE OR REPLACE PROCEDURE INSERT_TERM_MONTHS (
    p_term_length IN TERM_MONTHS.TERM_LENGTH%TYPE,
    p_description IN TERM_MONTHS.DESCRIPTION%TYPE DEFAULT NULL
) IS
    v_id NUMBER;
    v_exists NUMBER := 0;
    v_table_name TAB_ID.TABLE_NAME%TYPE := 'TERM_MONTHS';
BEGIN
    -- Ensure the term length is provided
    IF p_term_length IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Term length cannot be NULL');
    END IF;

    -- Check if the term length already exists
    SELECT CASE WHEN EXISTS (
        SELECT 1 FROM TERM_MONTHS WHERE TERM_LENGTH = p_term_length
    ) THEN 1 ELSE 0 END INTO v_exists FROM DUAL;

    IF v_exists = 0 THEN
        -- Generate a new term ID
        UPDATE_TAB_ID(v_table_name);
        v_id := FC_ID_TABLE(v_table_name);

        -- Insert new term month record
        INSERT INTO TERM_MONTHS (TERM_ID, TERM_LENGTH, DESCRIPTION)
        VALUES (v_id, p_term_length, p_description);

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Term length inserted successfully');
    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'The term length already exists');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Exception handled: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;