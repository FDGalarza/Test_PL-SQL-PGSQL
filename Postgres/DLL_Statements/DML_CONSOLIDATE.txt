CREATE TABLE Videogames (
    game_id NUMBER PRIMARY KEY,
    title VARCHAR2(200) NOT NULL,
    company_id NUMBER NOT NULL,
    release_year NUMBER(4) NOT NULL,
    price NUMBER(10,2) NOT NULL,
    average_rating NUMBER(3,2) DEFAULT 0 CHECK (average_rating BETWEEN 0 AND 5),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    created_by VARCHAR2(30) DEFAULT USER NOT NULL,
    updated_by VARCHAR2(30) DEFAULT USER NOT NULL,
    CONSTRAINT fk_videogames_company FOREIGN KEY (company_id) REFERENCES Companies(company_id)
);

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

-- Create Audits table
CREATE TABLE Audits (
    audit_id NUMBER PRIMARY KEY,
    table_name VARCHAR2(30) NOT NULL,
    column_name VARCHAR2(30) NOT NULL,
    action VARCHAR2(6) NOT NULL CHECK (action IN ('INSERT', 'UPDATE', 'DELETE')),
    old_value VARCHAR2(4000),
    new_value VARCHAR2(4000),
    audit_date TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    audit_user VARCHAR2(30) DEFAULT USER NOT NULL
);