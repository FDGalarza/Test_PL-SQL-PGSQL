-- Create trigger for Videogames auto-incrementing ID
CREATE OR REPLACE TRIGGER trg_videogames_id
BEFORE INSERT ON Videogames
FOR EACH ROW
BEGIN
    SELECT seq_id_Videogames.NEXTVAL
    INTO :new.game_id
    FROM dual;
END;
/