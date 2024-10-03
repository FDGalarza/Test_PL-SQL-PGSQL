CREATE OR REPLACE PACKAGE practical_test 
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
  -----------------------------------------------------------------------
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
      process_ratings_queue();
  
      RETURN;
  EXCEPTION
      WHEN OTHERS THEN
          -- Log the error and re-raise
          DBMS_OUTPUT.PUT_LINE('Error in generate_ratings: ' || SQLERRM);
          RAISE;
  END;

END;