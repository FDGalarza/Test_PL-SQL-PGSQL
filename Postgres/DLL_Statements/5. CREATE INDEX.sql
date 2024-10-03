CREATE INDEX idx_videogames_company_id ON Videogames(company_id);
CREATE INDEX idx_videogames_release_year ON Videogames(release_year);
CREATE INDEX idx_videogames_title ON Videogames(title);
CREATE INDEX idx_ratings_game_id ON Ratings(game_id);
CREATE INDEX idx_ratings_nickname ON Ratings(nickname);
CREATE INDEX idx_ratings_score ON Ratings(score);