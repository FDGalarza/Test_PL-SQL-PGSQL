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