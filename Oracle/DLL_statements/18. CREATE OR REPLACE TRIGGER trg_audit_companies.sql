-- Create trigger for auditing Companies table
CREATE OR REPLACE TRIGGER trg_audit_companies
AFTER INSERT OR UPDATE OR DELETE ON Companies
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
        VALUES ('COMPANIES', 'COMPANY_NAME', v_action, :old.company_name, :new.company_name);
    ELSIF DELETING THEN
        INSERT INTO Audits (table_name, column_name, action, old_value, new_value)
        VALUES ('COMPANIES', 'COMPANY_NAME', v_action, :old.company_name, NULL);
    END IF;
END;
/