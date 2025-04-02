
-- >> Procedure to create the amortization schedule < --
CREATE OR REPLACE PROCEDURE CREATE_AMORTIZATION_SCHEDULE_TEMP (
    -- parameters
    p_application_id IN AMORTIZATION_SCHEDULE_TEMP.APPLICATION_ID%TYPE,
    p_loan_amount IN LOAN_APPLICATION.LOAN_AMOUNT%TYPE,
    p_rate IN NUMBER,
    p_term_months IN NUMBER,
    p_payment_frequency IN NUMBER,
    p_start_date IN LOAN_APPLICATION.START_DATE%TYPE
) IS
    -- variables
    v_interest_rate_payment NUMBER := 0;
    v_rate NUMBER := p_rate;
    v_number_of_payments NUMBER := 0;
    v_payment NUMBER(10,4) := 0;
    v_balance NUMBER(10,4) := 0;
    v_principal NUMBER(10,4) := 0;
    v_interest NUMBER(10,4) := 0;
    v_number_of_payments_year NUMBER:= 0;
    v_date_payment DATE;
    V_MONTHS_YEAR NUMBER := 12;
BEGIN
    -- validate the payment frequency
    if nvl(p_payment_frequency,0) <= 0 or nvl(p_loan_amount,0) <= 0 or nvl(p_payment_frequency,0) <=0 or nvl(p_application_id,0) <=0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Application ID, Product ID, Term ID, Interest Rate, and Effective Date cannot be NULL');
    end if;
    -- number of payments = term months / payment frequency
    v_number_of_payments := p_term_months / p_payment_frequency;
    -- number of payments in a year = months in a year (12) / frequency of payments
    v_number_of_payments_year := V_MONTHS_YEAR / p_payment_frequency;
    -- interest reate per payment = interest rate year / number of payments in a year
    v_interest_rate_payment := v_rate / v_number_of_payments_year;
    -- formula to calculate the payment value
    v_payment := (p_loan_amount * v_interest_rate_payment)/(1 - power(1 + v_interest_rate_payment, -1*v_number_of_payments));
    dbms_output.put_line('payment: ' || v_payment || ' loan: '|| p_loan_amount || ' interest: ' || v_interest_rate_payment || ' rate before: '||v_rate);
    -- update the balance with the loan amount
    v_balance := p_loan_amount;
    -- update the date with the start date
    v_date_payment := p_start_date;
    -- create each payment
    for i in 1..v_number_of_payments
    loop
        -- calculate the interest value
        v_interest := v_balance * v_interest_rate_payment;
        -- calculate the principal value
        v_principal := v_payment - v_interest;
        -- calculate the loan balance
        v_balance := v_balance - v_principal;
        -- insert the installment
        insert into AMORTIZATION_SCHEDULE_TEMP (
            APPLICATION_ID, 
            NUMBER_INSTALLMENT, 
            TOTAL_INSTALLMENT,
            PRINCIPAL,
            INTEREST,
            REMAINING_BALANCE,
            INSTALLMENT_DATE
        ) values (
            p_application_id,
            i,
            v_payment,
            v_principal,
            v_interest,
            v_balance,
            v_date_payment
        );
        -- claculate the next installment date
        v_date_payment := add_months(v_date_payment,p_payment_frequency);
    end loop;
EXCEPTION
    when others then 
        DBMS_OUTPUT.PUT_LINE('Exception handled: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;