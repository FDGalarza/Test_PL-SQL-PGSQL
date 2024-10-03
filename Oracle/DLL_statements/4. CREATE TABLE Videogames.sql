-- Create Videogames table
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