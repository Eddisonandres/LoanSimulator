
-- Function to extract the term months by id
create or replace FUNCTION FC_TERM_MONTHS_VALUE(
    -- parameters
    p_term_months_id IN TERM_MONTHS.TERM_ID%TYPE
)
    RETURN NUMBER
IS
    -- variables
    v_term_months_value NUMBER;
BEGIN
    -- get the term length value by the id
    select term_length into v_term_months_value
    from TERM_MONTHS
    where term_id = p_term_months_id;
    -- return the term length value
    return v_term_months_value;
EXCEPTION
    when NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Term months not found');
    when OTHERS then
        DBMS_OUTPUT.PUT_LINE('Exception handled: ' || SQLERRM);
END;