-- Function to extract the payment frequency by id
create or replace FUNCTION FC_PAYMENT_FREQUENCY_VALUE(
    -- parameters
    p_payment_frequency_id IN PAYMENT_FREQUENCIES.FREQUENCY_ID%TYPE
)
    RETURN NUMBER
IS
    -- variables
    v_payment_frequency_value NUMBER;
BEGIN
    -- get the frequency months value by the id
    select frequency_months into v_payment_frequency_value
    from PAYMENT_FREQUENCIES
    where frequency_id = p_payment_frequency_id;
    -- return the frequency months value
    return v_payment_frequency_value;
EXCEPTION
    when NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Frequency months not found');
    when OTHERS then
        DBMS_OUTPUT.PUT_LINE('Exception handled: ' || SQLERRM);
END;