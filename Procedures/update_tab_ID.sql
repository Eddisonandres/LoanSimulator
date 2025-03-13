-- >> Procedure to update the ID of the tables << --
create or replace procedure UPDATE_TAB_ID(
    table_name_in IN TAB_ID.TABLE_NAME%type
) IS
    last_id tab_id.NUMBER_ID%TYPE := 0;
BEGIN
    select number_id into last_id
    from TAB_ID
    where TABLE_NAME = table_name_in;
    
    if last_id is not null then
        update TAB_ID set NUMBER_ID = last_id + 1 
        where TABLE_NAME = table_name_in;
    end if;
EXCEPTION
    when NO_DATA_FOUND then
        DBMS_OUTPUT.PUT_LINE('Exception handled: ' || SQLERRM);
        RAISE;
    when OTHERS then
        DBMS_OUTPUT.PUT_LINE('Exception handled: ' || SQLERRM);
        RAISE;
END;