-- Create trigger for Ratings auto-incrementing ID
CREATE OR REPLACE TRIGGER trg_ratings_id
BEFORE INSERT ON Ratings
FOR EACH ROW
BEGIN
    SELECT seq_id_Ratings.NEXTVAL
    INTO :new.rating_id
    FROM dual;
END;
/