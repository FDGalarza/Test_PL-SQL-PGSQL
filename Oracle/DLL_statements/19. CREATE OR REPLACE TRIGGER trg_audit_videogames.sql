-- Create trigger for auditing Videogames table
CREATE OR REPLACE TRIGGER trg_audit_videogames
AFTER INSERT OR UPDATE OR DELETE ON Videogames
FOR EACH ROW
DECLARE
    v_action VARCHAR2(6);
BEGIN
    IF INSERTING THEN
        v_action := 'INSERT';
    ELSIF UPDATING THEN
        v_action := 'UPDATE';
    ELSIF DELETING THEN
        v_action := 'DELETE';
    END IF;
    
    IF INSERTING THEN
        INSERT INTO Audits (table_name, column_name, action, old_value, new_value)
        VALUES ('VIDEOGAMES', '', v_action, :old.title, :new.title);
    ELSIF UPDATING THEN
        INSERT INTO Audits (table_name, column_name, action, old_value, new_value)
        VALUES ('VIDEOGAMES', 'TITLE', v_action, :old.title, :new.title);
        
        INSERT INTO Audits (table_name, column_name, action, old_value, new_value)
        VALUES ('VIDEOGAMES', 'PRICE', v_action, TO_CHAR(:old.price), TO_CHAR(:new.price));
        
        INSERT INTO Audits (table_name, column_name, action, old_value, new_value)
        VALUES ('VIDEOGAMES', 'AVERAGE_RATING', v_action, TO_CHAR(:old.average_rating), TO_CHAR(:new.average_rating));
    ELSIF DELETING THEN
        INSERT INTO Audits (table_name, column_name, action, old_value, new_value)
        VALUES ('VIDEOGAMES', '', v_action, '', NULL);
    END IF;
END;
/