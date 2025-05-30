-- Function to get the ID in the table
create or replace FUNCTION FC_ID_TABLE (
    -- parameters
    name_table IN TAB_ID.TABLE_NAME%TYPE
)
    RETURN NUMBER
IS
    -- variables
    id_result number;
BEGIN
    -- get the last id from the table name in the tab_id
    select NUMBER_ID into id_result
    from TAB_ID
    where TABLE_NAME = UPPER(name_table);
    RETURN id_result;
EXCEPTION
    when NO_DATA_FOUND then
        DBMS_OUTPUT.PUT_LINE('Table name not found');
    when OTHERS then
        DBMS_OUTPUT.PUT_LINE('Exception handled: ' || SQLERRM);
END;