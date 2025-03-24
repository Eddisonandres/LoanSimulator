-- Function to get the rate value from an ID in the table product_interest_rates
create or replace FUNCTION FC_RATE_VALUE(
    p_rate_id IN PRODUCT_INTEREST_RATES.RATE_ID%TYPE
)
    RETURN NUMBER
IS
    v_rate_value NUMBER;
BEGIN
    select interest_rate into v_rate_value
    from PRODUCT_INTEREST_RATES
    where rate_id = p_rate_id;

    return v_rate_value;
EXCEPTION
    when NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Interest rate not found');
    when OTHERS then
        DBMS_OUTPUT.PUT_LINE('Exception handled: ' || SQLERRM);
END;