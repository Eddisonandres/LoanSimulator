
-- >> Procedure to update the ID of the tables << --
create or replace procedure UPDATE_TAB_ID(
    -- parameters
    p_table_name_in IN TAB_ID.TABLE_NAME%type
) IS
    -- variables
    v_last_id tab_id.NUMBER_ID%TYPE := 0;
BEGIN
    -- get the last id related to the table
    select number_id into v_last_id
    from TAB_ID
    where TABLE_NAME = p_table_name_in;
    -- update the id if it is found it
    if v_last_id is not null then
        update TAB_ID set NUMBER_ID = v_last_id + 1 
        where TABLE_NAME = p_table_name_in;
    end if;
EXCEPTION
    when NO_DATA_FOUND then
        RAISE_APPLICATION_ERROR(-20001, 'The table does not exist');
    when OTHERS then
        DBMS_OUTPUT.PUT_LINE('Exception handled: ' || SQLERRM);
        RAISE;
END;