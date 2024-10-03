-- Create trigger for Companies auto-incrementing ID
CREATE OR REPLACE TRIGGER trg_companies_id
BEFORE INSERT ON Companies
FOR EACH ROW
BEGIN
    SELECT SQ_companies.NEXTVAL
    INTO :new.company_id
    FROM dual;
END;
/