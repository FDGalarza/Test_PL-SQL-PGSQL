create or replace PACKAGE practical_test 
IS
---------------------------------------------------------------------
--Contiene procedimientos y fundiones para dar solución a la prueba--
---------------------------------------------------------------------

  --genera el nickName aleatorio
  FUNCTION generate_nickname RETURN VARCHAR2;
  
  --genera la puntuación random
  FUNCTION generate_score RETURN NUMBER;
  
  --genera identificador video juego random
  FUNCTION get_random_game_id RETURN NUMBER;
  
  --inserta calificación
   PROCEDURE insert_rating(
                              p_nickname IN VARCHAR2,
                              p_game_id IN NUMBER,
                              p_score IN NUMBER
                          );
  
  --procedimiento para el proceso de cola
  PROCEDURE process_ratings_queue;
  
  --genera calificaciones
  FUNCTION generate_ratings(
                                p_count IN NUMBER DEFAULT 0,
                                p_game_id IN NUMBER DEFAULT NULL
                            ) RETURN rating_tab PIPELINED;
  
  --Crea la calificacion
  PROCEDURE bulk_insert_ratings (
                                    p_count IN NUMBER DEFAULT 1000000,
                                    p_game_id IN NUMBER DEFAULT NULL,
                                    p_error_code OUT NUMBER,
                                    p_error_message OUT VARCHAR2
                                );
                                
  --actualiza puntajes
  PROCEDURE update_ratings (
                                p_error_code OUT NUMBER,
                                p_error_message OUT VARCHAR2
                            );
                            
  --genera CSV para migar los datos
  PROCEDURE export_videogames_ratings_to_csv(
                                                p_error_code OUT NUMBER,
                                                p_error_message OUT VARCHAR2
                                            );
   

END;
/
CREATE OR REPLACE PACKAGE BODY practical_test IS

  FUNCTION generate_nickname RETURN VARCHAR2 IS
      v_nickname VARCHAR2(30);
      v_length NUMBER;
  BEGIN
      v_length := DBMS_RANDOM.VALUE(5, 30);
      v_nickname := '';
      FOR i IN 1..v_length LOOP
          IF DBMS_RANDOM.VALUE(0, 1) < 0.7 THEN
              -- 70% chance of being a letter
              v_nickname := v_nickname || CHR(TRUNC(DBMS_RANDOM.VALUE(65, 91)));
          ELSE
              -- 30% chance of being a number
              v_nickname := v_nickname || TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(0, 10)));
          END IF;
      END LOOP;
      RETURN v_nickname;
  END;
  -----------------------------------------------
  --
  ----------------------------------------------
  FUNCTION generate_score RETURN NUMBER 
  IS
  
  BEGIN
      RETURN ROUND(DBMS_RANDOM.VALUE(0, 5), 2);
  END;
  -------------------------------------------------------------
  --
  -------------------------------------------------------------
  FUNCTION get_random_game_id RETURN NUMBER 
  IS
    v_game_id NUMBER;
  BEGIN
      SELECT game_id INTO v_game_id
      FROM (SELECT game_id FROM Videogames ORDER BY DBMS_RANDOM.VALUE)
      WHERE ROWNUM = 1;
      
      RETURN v_game_id;
  END;
  --------------------------------------------------------------------------
  --
  --------------------------------------------------------------------------
  PROCEDURE insert_rating(
                              p_nickname IN VARCHAR2,
                              p_game_id IN NUMBER,
                              p_score IN NUMBER
                          ) AS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
      INSERT INTO Ratings (nickname, game_id, score)
      VALUES (p_nickname, p_game_id, p_score);
      COMMIT;
  EXCEPTION
      WHEN OTHERS THEN
          ROLLBACK;
          RAISE;
  END;
  -----------------------------------------------------------------------------
  ----
  -----------------------------------------------------------------------------
  PROCEDURE process_ratings_queue AS
  
  PRAGMA AUTONOMOUS_TRANSACTION;
  
  BEGIN
      FOR rec IN (SELECT DISTINCT game_id FROM ratings_update_queue) LOOP
          UPDATE Videogames v
          SET average_rating = (SELECT NVL(AVG(score), 0)
                                FROM Ratings r
                                WHERE r.game_id = v.game_id),
              updated_at = SYSTIMESTAMP,
              updated_by = USER
          WHERE v.game_id = rec.game_id;
      END LOOP;
  
      -- Limpiar la cola
      DELETE FROM ratings_update_queue;
      COMMIT;
  EXCEPTION
      WHEN OTHERS THEN
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('Error en process_ratings_queue: ' || SQLERRM);
  END;
  -----------------------------------------------------------------------------
  --
  -------------------------------------------------------------------------------
  FUNCTION generate_ratings(
                                p_count IN NUMBER DEFAULT 0,
                                p_game_id IN NUMBER DEFAULT NULL
                            ) RETURN rating_tab PIPELINED IS
    v_game_id NUMBER;
    v_nickname VARCHAR2(30);
    v_score NUMBER(3,2);
  BEGIN
      -- Check if the count is valid
      IF p_count <= 0 THEN
          RETURN;
      END IF;
  
      -- Determine the game_id to use
      IF p_game_id IS NULL THEN
          v_game_id := get_random_game_id();
      ELSE
          v_game_id := p_game_id;
      END IF;
  
      -- Generate the ratings
      FOR i IN 1..p_count LOOP
          v_nickname := generate_nickname();
          v_score := generate_score();
  
          -- Insert the rating using the autonomous procedure
          insert_rating(v_nickname, v_game_id, v_score);
  
          -- Pipe the row to the output
          PIPE ROW(rating_obj(v_nickname, v_game_id, v_score));
      END LOOP;
  
      -- Process the ratings queue after generating all ratings
      --process_ratings_queue();
  
      RETURN;
  EXCEPTION
      WHEN OTHERS THEN
          -- Log the error and re-raise
          DBMS_OUTPUT.PUT_LINE('Error in generate_ratings: ' || SQLERRM);
          RAISE;
  END;
  ------------------------------------------------------------------------------
  --
  ------------------------------------------------------------------------------
  PROCEDURE bulk_insert_ratings (
                                    p_count IN NUMBER DEFAULT 1000000,
                                    p_game_id IN NUMBER DEFAULT NULL,
                                    p_error_code OUT NUMBER,
                                    p_error_message OUT VARCHAR2
                                )
  IS
      TYPE rating_table_type IS TABLE OF rating_obj;
      l_ratings rating_table_type;
      l_batch_size CONSTANT PLS_INTEGER := 10000; -- Tamaño del lote para la inserción masiva
      l_total_inserted PLS_INTEGER := 0;
  BEGIN
      p_error_code := 0;
      p_error_message := NULL;
  
      -- Generar calificaciones usando la función de tabla canalizada
      SELECT rating_obj(nickname, game_id, score)
      BULK COLLECT INTO l_ratings
      FROM TABLE(generate_ratings(p_count, p_game_id));
  
      -- Insertar los registros en lotes
      WHILE l_total_inserted < l_ratings.COUNT LOOP
          FORALL i IN l_total_inserted + 1 .. LEAST(l_total_inserted + l_batch_size, l_ratings.COUNT)
              INSERT INTO Ratings (nickname, game_id, score)
              VALUES (l_ratings(i).nickname, l_ratings(i).game_id, l_ratings(i).score);
  
          l_total_inserted := l_total_inserted + l_batch_size;
          COMMIT; -- Commit después de cada lote
      END LOOP;
      
      -- Procesar la cola de actualizaciones de promedios
      process_ratings_queue();
  
      DBMS_OUTPUT.PUT_LINE('Se insertaron exitosamente ' || l_ratings.COUNT || ' registros.');
  
  EXCEPTION
      WHEN OTHERS THEN
          p_error_code := SQLCODE;
          p_error_message := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('Error: ' || p_error_code || ' - ' || p_error_message);
          ROLLBACK;
  END bulk_insert_ratings;
  ------------------------------------------------------------------------------
  --
  ------------------------------------------------------------------------------
  PROCEDURE update_ratings (
                                p_error_code OUT NUMBER,
                                p_error_message OUT VARCHAR2
                            ) AS
      CURSOR c_ratings IS
          SELECT game_id, AVG(score) AS average_score
          FROM Ratings
          GROUP BY game_id;
  
      v_average_score NUMBER(3,2);
  BEGIN
      -- Abrir el cursor
      FOR rec IN c_ratings LOOP
          -- Actualizar la tabla Videogames con la nueva puntuación
          UPDATE Videogames
          SET average_rating = rec.average_score,
              updated_at = SYSTIMESTAMP,
              updated_by = USER
          WHERE game_id = rec.game_id;
      END LOOP;
  
      -- Si todo sale bien, retornar código y mensaje de error nulos
      p_error_code := 0;
      p_error_message := NULL;
  
  EXCEPTION
      WHEN OTHERS THEN
          -- Capturar el error y retornar código y mensaje
          p_error_code := SQLCODE;
          p_error_message := SQLERRM;
  END;
  -----------------------------------------------------------------------------
  --
  -----------------------------------------------------------------------------
  PROCEDURE export_videogames_ratings_to_csv(
                                                p_error_code OUT NUMBER,
                                                p_error_message OUT VARCHAR2
                                             )
    IS
        v_file UTL_FILE.FILE_TYPE;
        v_directory VARCHAR2(100) := 'c:/app/'; -- ruta para exportar archivo
        v_filename VARCHAR2(100) := 'videogames_ratings_export.csv';
        v_data VARCHAR2(4000);
    
        CURSOR c_data IS
            SELECT 
                v.game_id,
                v.title,
                v.company_id,
                v.release_year,
                v.price,
                v.average_rating,
                r.rating_id,
                r.nickname,
                r.score
            FROM 
                Videogames v
            LEFT JOIN 
                Ratings r ON v.game_id = r.game_id
            ORDER BY 
                v.game_id, r.rating_id;
    
    BEGIN
        -- Abrir el archivo
        v_file := UTL_FILE.FOPEN(v_directory, v_filename, 'W', 32767);
    
        -- Escribir el encabezado
        UTL_FILE.PUT_LINE(v_file, 'Game ID,Title,Company ID,Release Year,Price,Average Rating,Rating ID,Nickname,Score');
    
        -- Escribir los datos
        FOR rec IN c_data LOOP
            v_data := rec.game_id || ',' ||
                      '"' || REPLACE(rec.title, '"', '""') || '"' || ',' ||
                      rec.company_id || ',' ||
                      rec.release_year || ',' ||
                      TO_CHAR(rec.price, 'FM999999990.00') || ',' ||
                      TO_CHAR(rec.average_rating, 'FM9.00') || ',' ||
                      NVL(TO_CHAR(rec.rating_id), '') || ',' ||
                      '"' || NVL(REPLACE(rec.nickname, '"', '""'), '') || '"' || ',' ||
                      NVL(TO_CHAR(rec.score, 'FM9.00'), '');
    
            UTL_FILE.PUT_LINE(v_file, v_data);
        END LOOP;
    
        -- Cerrar el archivo
        UTL_FILE.FCLOSE(v_file);
    
        DBMS_OUTPUT.PUT_LINE('Archivo CSV generado exitosamente: ' || v_filename);
        p_error_code := 0;
        p_error_message := '';
    EXCEPTION
        WHEN OTHERS THEN
            IF UTL_FILE.IS_OPEN(v_file) THEN
                UTL_FILE.FCLOSE(v_file);
            END IF;
            p_error_code := SQLCODE;
            p_error_message := SQLERRM;
            RAISE_APPLICATION_ERROR(-20001, 'Error al generar el archivo CSV: ' || SQLERRM);
    END;

END;