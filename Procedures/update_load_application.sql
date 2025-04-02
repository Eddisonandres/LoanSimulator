-- >> Procedure to insert loan application << --
CREATE OR REPLACE PROCEDURE INSERT_LOAN_APPLICATION (
    -- parameters
    p_customer_id IN LOAN_APPLICATION.CUSTOMER_ID%TYPE,
    p_product_id IN LOAN_APPLICATION.PRODUCT_ID%TYPE,
    p_loan_amount IN LOAN_APPLICATION.LOAN_AMOUNT%TYPE,
    p_payment_frequency_id IN LOAN_APPLICATION.PAYMENT_FREQUENCY_ID%TYPE,
    p_term_months_id IN LOAN_APPLICATION.TERM_MONTHS_ID%TYPE,
    p_start_date IN LOAN_APPLICATION.START_DATE%TYPE,
    p_observations IN LOAN_APPLICATION.OBSERVATIONS%TYPE
) IS
    -- variables
    v_id NUMBER;
    v_table_name TAB_ID.TABLE_NAME%TYPE := 'LOAN_APPLICATION';
    v_rate_id number;
    v_rate number;
    v_term_months number;
    v_payment_frequency number;
    v_start_date date;
BEGIN
    -- validate if the main parameters are null
    if p_customer_id is null or p_product_id is null or p_loan_amount is null or 
        p_payment_frequency_id is null or p_term_months_id is null then
        RAISE_APPLICATION_ERROR(-20001, 'All loan fields must be provided');
    end if;
    -- add the current date when the start_date is null
    if p_start_date is null then
        v_start_date := sysdate;
    else
        v_start_date := p_start_date;
    end if;
    -- extract the rate id using the id product and the term months
    BEGIN
        select rate_id into v_rate_id
        from PRODUCT_INTEREST_RATES
        where product_id=p_product_id and term_id=p_term_months_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Interest rate not found');
    END;
    -- update the id of the table
    UPDATE_TAB_ID(v_table_name);
    -- get the new id
    v_id := FC_ID_TABLE(v_table_name);
    
    -- insert data in the table
    insert into LOAN_APPLICATION (
        APPLICATION_ID,
        CUSTOMER_ID,
        PRODUCT_ID,
        DATE_CREATED,
        LOAN_AMOUNT,
        PAYMENT_FREQUENCY_ID,
        TERM_MONTHS_ID,
        RATE_ID,
        START_DATE,
        OBSERVATIONS
    ) values (
        v_id,
        p_customer_id,
        p_product_id,
        sysdate,
        p_loan_amount,
        p_payment_frequency_id,
        p_term_months_id,
        v_rate_id,
        v_start_date,
        p_observations
    );
    -- extract the variables based on the ids
    v_rate := FC_RATE_VALUE(v_rate_id);
    v_term_months := FC_TERM_MONTHS_VALUE(p_term_months_id);
    v_payment_frequency := FC_PAYMENT_FREQUENCY_VALUE(p_payment_frequency_id);

    -- go to the procedure to create amortization schedule temp
    CREATE_AMORTIZATION_SCHEDULE_TEMP(
        P_APPLICATION_ID=>v_id,
        P_LOAN_AMOUNT=>p_loan_amount,
        P_RATE=>v_rate/*NUMBER*/,
        P_TERM_MONTHS=>v_term_months/*NUMBER*/,
        P_PAYMENT_FREQUENCY=>v_payment_frequency/*NUMBER*/,
        P_START_DATE=>v_start_date/*DATE*/
    );
    commit;
EXCEPTION
    when others then 
        DBMS_OUTPUT.PUT_LINE('Exception handled: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;