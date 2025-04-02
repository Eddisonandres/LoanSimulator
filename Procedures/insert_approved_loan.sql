-- >> Procedure to insert the approved loan << --
create or replace procedure INSERT_APPROVED_LOAN(
    -- parameters
    p_loan_application_id IN APPROVED_LOANS.LOAN_ID%type
) IS
    -- variables
    v_start_date date;
    v_term_months_value number;
    v_end_date date;
    v_count number;
    v_id number;
    v_table_name TAB_ID.TABLE_NAME%TYPE := 'APPROVED_LOANS';
BEGIN
    -- check if the loan already exists
    select count(*) into v_count
    from APPROVED_LOANS
    where application_id = p_loan_application_id;

    if v_count > 0 then
        RAISE_APPLICATION_ERROR(-20001, 'The loan already exists');
    end if;
    -- get the start date and the term length to calculate the end date
    BEGIN
        select start_date,tm.term_length 
        into v_start_date,v_term_months_value
        from LOAN_APPLICATION la
        inner join TERM_MONTHS tm
        on la.term_months_id = tm.term_id and tm.term_status = 'GA'
        where la.application_status = 'LP' and
        la.application_id = p_loan_application_id;
    EXCEPTION
        WHEN NO_DATA_FOUND then
            RAISE_APPLICATION_ERROR(-20001, 'Loan Application not found');
    END;
    -- update the id of the table
    UPDATE_TAB_ID(v_table_name);
    -- get the new id
    v_id := FC_ID_TABLE(v_table_name);
    -- calculate the end date
    v_end_date := add_months(v_start_date, v_term_months_value);
    -- insert data in the table approved loans
    insert into APPROVED_LOANS (
        loan_id,application_id,date_created,customer_id,
        product_id,rate_id,term_months_id,approved_amount,
        start_date,end_date
    )
        select v_id,application_id,sysdate,customer_id,
        product_id,rate_id,term_months_id,
        loan_amount,start_date,v_end_date
        from LOAN_APPLICATION
        where application_id = p_loan_application_id and
        application_status = 'LP';
    -- insert data into the amortization schedule
    insert into AMORTIZATION_SCHEDULE (
        loan_id,
        number_installment,
        total_installment,
        principal,
        interest,
        remaining_balance,
        installment_date
    )
    select v_id,
        number_installment,
        total_installment,
        principal,
        interest,
        remaining_balance,
        installment_date
    from AMORTIZATION_SCHEDULE_TEMP
    where application_id = p_loan_application_id;
    -- update the loan application status to approved
    UPDATE_LOAN_APPLCATION(
        p_loan_application_id=>p_loan_application_id,
        p_product_id => null,
        p_loan_amount => null,
        p_payment_frequency_id => null,
        p_term_months_id => null,
        p_start_date => null,
        p_status=>'LA',
        p_observations => null
    );
    -- delete the amortization schedule temp
    delete from AMORTIZATION_SCHEDULE_TEMP 
    where application_id = p_loan_application_id;
    EXCEPTION when OTHERS then
        DBMS_OUTPUT.PUT_LINE('Exception handled: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;