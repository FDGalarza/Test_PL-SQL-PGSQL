-- Create Ratings table
CREATE TABLE Ratings (
    rating_id NUMBER PRIMARY KEY,
    nickname VARCHAR2(30) NOT NULL,
    game_id NUMBER NOT NULL,
    score NUMBER(3,2) NOT NULL CHECK (score BETWEEN 0 AND 5),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    created_by VARCHAR2(30) DEFAULT USER NOT NULL,
    updated_by VARCHAR2(30) DEFAULT USER NOT NULL,
    CONSTRAINT fk_ratings_game FOREIGN KEY (game_id) REFERENCES Videogames(game_id)
);