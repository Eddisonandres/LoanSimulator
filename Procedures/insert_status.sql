-- >> Insert status << --
create or replace procedure INSERT_STATUS (
    -- parameters
    p_status_id IN STATUS_TAB.STATUS_ID%TYPE,
    P_status_type IN STATUS_TAB.STATUS_TYPE%TYPE,
    P_status_name IN STATUS_TAB.STATUS_NAME%TYPE
) IS 
    -- variable
    v_custom_exception EXCEPTION;
    v_status_exists EXCEPTION;
    v_count NUMBER;
    v_lenght_id NUMBER;
BEGIN
    -- validate the length of the variable status_id
    select data_length into v_lenght_id
    from USER_TAB_COLUMNS
    where table_name = 'STATUS_TAB' and column_name = 'STATUS_ID';

    if length(p_status_id) = v_lenght_id and P_status_type is not null and P_status_name is not null then
        -- validate if the status already exists
        select count(*) into v_count 
        from STATUS_TAB where status_id = UPPER(p_status_id);

        if v_count > 0 then
            RAISE v_status_exists;
        else
            -- if the status does not exist intert it
            insert into STATUS_TAB (STATUS_ID, STATUS_TYPE, STATUS_NAME) 
                values (UPPER(p_status_id), UPPER(P_status_type), UPPER(P_status_name));
            commit;
        end if;
    else
        RAISE v_custom_exception;
    end if;
EXCEPTION
    WHEN v_custom_exception then
        DBMS_OUTPUT.PUT_LINE('Variable null or not valid');
        RAISE;
    WHEN v_status_exists then
        DBMS_OUTPUT.PUT_LINE('ID already exists in the table');
        RAISE;
    WHEN OTHERS then
        DBMS_OUTPUT.PUT_LINE('Exception handled: ' || SQLERRM);
        RAISE;
    RAISE;
END;