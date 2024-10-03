-- Create trigger for Companies auto-incrementing ID
CREATE OR REPLACE TRIGGER trg_companies_id
BEFORE INSERT ON Companies
FOR EACH ROW
BEGIN
    SELECT seq_id_Ratings.NEXTVAL
    INTO :new.company_id
    FROM dual;
END;
/