-- Create trigger for auditing Ratings table
CREATE OR REPLACE TRIGGER trg_audit_ratings
AFTER INSERT OR UPDATE OR DELETE ON Ratings
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

    IF INSERTING OR UPDATING THEN
        INSERT INTO Audits (table_name, column_name, action, old_value, new_value)
        VALUES ('RATINGS', 'SCORE', v_action, TO_CHAR(:old.score), TO_CHAR(:new.score));
    ELSIF DELETING THEN
        INSERT INTO Audits (table_name, column_name, action, old_value, new_value)
        VALUES ('RATINGS', 'SCORE', v_action, TO_CHAR(:old.score), NULL);
    END IF;
END;
/