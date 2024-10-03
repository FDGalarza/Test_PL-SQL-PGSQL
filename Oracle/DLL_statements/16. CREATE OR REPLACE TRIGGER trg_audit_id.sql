-- Create trigger for Audit auto-incrementing ID
CREATE OR REPLACE TRIGGER trg_audit_id
BEFORE INSERT ON Audits
FOR EACH ROW
BEGIN
    SELECT seq_id_Audits.NEXTVAL
    INTO :new.audit_id
    FROM dual;
END;
/