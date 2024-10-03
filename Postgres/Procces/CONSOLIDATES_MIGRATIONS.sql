CREATE OR REPLACE PROCEDURE load_data_from_csv(p_file_path TEXT)
LANGUAGE plpgsql AS
$$
BEGIN
    -- Crear una tabla temporal para cargar los datos del CSV
    CREATE TEMP TABLE temp_data (
        game_id INTEGER,
        title TEXT,
        company_id INTEGER,
        release_year INTEGER,
        price NUMERIC(10,2),
        average_rating NUMERIC(3,2),
        rating_id INTEGER,
        nickname VARCHAR(30),
        score NUMERIC(3,2)
    );

    -- Cargar datos en la tabla temporal
    EXECUTE FORMAT('COPY temp_data FROM %L WITH (FORMAT CSV, HEADER TRUE)', p_file_path);

    -- Insertar en Videogames
    INSERT INTO Videogames (game_id, title, company_id, release_year, price, average_rating)
    SELECT DISTINCT game_id, title, company_id, release_year, price, average_rating
    FROM temp_data
    WHERE game_id IS NOT NULL
    ON CONFLICT (game_id) DO NOTHING; -- Ignorar si ya existe

    -- Insertar en Ratings
    INSERT INTO Ratings (rating_id, nickname, game_id, score)
    SELECT rating_id, nickname, game_id, score
    FROM temp_data
    WHERE rating_id IS NOT NULL 
      AND game_id IS NOT NULL 
      AND game_id IN (SELECT game_id FROM Videogames); -- Asegurar que exista el game_id

    -- Eliminar la tabla temporal
    DROP TABLE temp_data;
END;
$$;
CREATE OR REPLACE FUNCTION get_game_ranking(top_n INTEGER)
RETURNS TABLE (
    game_title VARCHAR(200),
    company_name VARCHAR(100),
    score NUMERIC(3,2),
    classification VARCHAR(4)
) AS $$
DECLARE
    total_games INTEGER;
    mid_point INTEGER;
BEGIN
    -- Verificar si el parámetro de entrada es válido
    IF top_n <= 0 THEN
        RAISE EXCEPTION 'El valor ingresado como parámetro no es válido. Debe ser mayor que cero.';
    END IF;

    -- Obtener el número total de juegos en el ranking
    SELECT COUNT(*) INTO total_games FROM (
        SELECT DISTINCT ON (v.game_id) v.game_id
        FROM Videogames v
        JOIN Ratings r ON v.game_id = r.game_id
    ) AS unique_games;

    -- Ajustar top_n si es mayor que el número total de juegos
    IF top_n > total_games THEN
        top_n := total_games;
    END IF;

    -- Calcular el punto medio para la clasificación
    mid_point := CEIL(top_n::NUMERIC / 2);

    -- Retornar el ranking de juegos
    RETURN QUERY
    WITH ranked_games AS (
        SELECT 
            v.title,
            c.company_name,
            COALESCE(AVG(r.score), 0) AS avg_score,
            ROW_NUMBER() OVER (ORDER BY COALESCE(AVG(r.score), 0) DESC) AS rank
        FROM Videogames v
        LEFT JOIN Ratings r ON v.game_id = r.game_id
        JOIN Companies c ON v.company_id = c.company_id
        GROUP BY v.game_id, v.title, c.company_name
    )
    SELECT 
        rg.title::VARCHAR(200) AS game_title,
        rg.company_name::VARCHAR(100),
        rg.avg_score::NUMERIC(3,2) AS score,
        (CASE 
            WHEN rg.rank <= mid_point THEN 'GOTY'
            ELSE 'AAA'
        END)::VARCHAR(4) AS classification
    FROM ranked_games rg
    WHERE rg.rank <= top_n
    ORDER BY rg.avg_score DESC, rg.title;
END;
$$ LANGUAGE plpgsql;