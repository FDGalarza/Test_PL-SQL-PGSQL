-- Create Videogames table
CREATE TABLE Videogames (
    game_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    company_id INTEGER NOT NULL,
    release_year INTEGER NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    average_rating NUMERIC(3,2) DEFAULT 0 CHECK (average_rating BETWEEN 0 AND 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_by VARCHAR(30) DEFAULT CURRENT_USER NOT NULL,
    updated_by VARCHAR(30) DEFAULT CURRENT_USER NOT NULL,
    CONSTRAINT fk_videogames_company FOREIGN KEY (company_id) REFERENCES Companies(company_id)
);

