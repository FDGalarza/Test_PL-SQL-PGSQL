-- Create trigger to update average_rating in Videogames table
CREATE OR REPLACE TRIGGER trg_update_average_rating
AFTER INSERT OR UPDATE OR DELETE ON Ratings
FOR EACH ROW
BEGIN
    -- En lugar de actualizar directamente, insertamos en la cola
    INSERT INTO ratings_update_queue (game_id)
    VALUES (:new.game_id);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        NULL; -- Ignorar si ya existe
END;
/