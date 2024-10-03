-- Create Companies table
CREATE TABLE Companies (
    company_id NUMBER PRIMARY KEY,
    company_name VARCHAR2(100) NOT NULL,
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    created_by VARCHAR2(30) DEFAULT USER NOT NULL,
    updated_by VARCHAR2(30) DEFAULT USER NOT NULL
);

CREATE SEQUENCE SQ_companies
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Create trigger for Companies auto-incrementing ID
CREATE OR REPLACE TRIGGER trg_companies_id
BEFORE INSERT ON Companies
FOR EACH ROW
BEGIN
    SELECT SQ_companies.NEXTVAL
    INTO :new.company_id
    FROM dual;
END;
/


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

CREATE SEQUENCE seq_id_Videogames
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
    
-- Create index on Videogames title
CREATE INDEX idx_videogames_title ON Videogames(title);

-- Create trigger for Videogames auto-incrementing ID
CREATE OR REPLACE TRIGGER trg_videogames_id
BEFORE INSERT ON Videogames
FOR EACH ROW
BEGIN
    SELECT seq_id_Videogames.NEXTVAL
    INTO :new.game_id
    FROM dual;
END;
/-- Create Ratings table
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

-- Create index on Ratings game_id
CREATE INDEX idx_ratings_game_id ON Ratings(game_id);


CREATE SEQUENCE seq_id_Ratings
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
    
-- Create trigger for Companies auto-incrementing ID
CREATE OR REPLACE TRIGGER trg_companies_id
BEFORE INSERT ON Companies
FOR EACH ROW
BEGIN
    SELECT seq_id_Ratings.NEXTVAL
    INTO :new.company_id
    FROM dual;
END;
/

-- Create trigger for Ratings auto-incrementing ID
CREATE OR REPLACE TRIGGER trg_ratings_id
BEFORE INSERT ON Ratings
FOR EACH ROW
BEGIN
    SELECT seq_id_Ratings.NEXTVAL
    INTO :new.rating_id
    FROM dual;
END;
/

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

-- Create index on Audit table_name and action
CREATE INDEX idx_audit_table_action ON Audits(table_name, action);

CREATE SEQUENCE seq_id_Audits
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
    
-- Create trigger for Audit auto-incrementing ID
CREATE OR REPLACE TRIGGER trg_audit_id
BEFORE INSERT ON Audits
FOR EACH ROW
BEGIN
    SELECT seq_id_Audits.NEXTVAL
    INTO :new.audit_id
    FROM dual;
END;
/

-- Create trigger to update average_rating in Videogames table
CREATE OR REPLACE TRIGGER trg_update_average_rating
AFTER INSERT OR UPDATE OR DELETE ON Ratings
FOR EACH ROW
DECLARE
    v_avg_rating NUMBER(3,2);
BEGIN
    -- Calculate new average rating
    SELECT NVL(AVG(score), 0)
    INTO v_avg_rating
    FROM Ratings
    WHERE game_id = :new.game_id;

    -- Update Videogames table
    UPDATE Videogames
    SET average_rating = v_avg_rating,
        updated_at = SYSTIMESTAMP,
        updated_by = USER
    WHERE game_id = :new.game_id;
END;
/

-- Create trigger for auditing Companies table
CREATE OR REPLACE TRIGGER trg_audit_companies
AFTER INSERT OR UPDATE OR DELETE ON Companies
FOR EACH ROW
DECLARE
    v_action VARCHAR2(6);
BEGIN
    IF INSERTING THEN
        v_action := 'INSERT';
    ELSIF UPDATING THEN
        v_action := 'UPDATE';
    ELSIF DELETING THEN
        v_action := 'DELETE';
    END IF;

    IF INSERTING OR UPDATING THEN
        INSERT INTO Audits (table_name, column_name, action, old_value, new_value)
        VALUES ('COMPANIES', 'COMPANY_NAME', v_action, :old.company_name, :new.company_name);
    ELSIF DELETING THEN
        INSERT INTO Audits (table_name, column_name, action, old_value, new_value)
        VALUES ('COMPANIES', 'COMPANY_NAME', v_action, :old.company_name, NULL);
    END IF;
END;
/

-- Create trigger for auditing Videogames table
-- Create trigger for auditing Videogames table
CREATE OR REPLACE TRIGGER trg_audit_videogames
AFTER INSERT OR UPDATE OR DELETE ON Videogames
FOR EACH ROW
DECLARE
    v_action VARCHAR2(6);
BEGIN
    IF INSERTING THEN
        v_action := 'INSERT';
    ELSIF UPDATING THEN
        v_action := 'UPDATE';
    ELSIF DELETING THEN
        v_action := 'DELETE';
    END IF;
    
    IF INSERTING THEN
        INSERT INTO Audits (table_name, column_name, action, old_value, new_value)
        VALUES ('VIDEOGAMES', '', v_action, :old.title, :new.title);
    ELSIF UPDATING THEN
        INSERT INTO Audits (table_name, column_name, action, old_value, new_value)
        VALUES ('VIDEOGAMES', 'TITLE', v_action, :old.title, :new.title);
        
        INSERT INTO Audits (table_name, column_name, action, old_value, new_value)
        VALUES ('VIDEOGAMES', 'PRICE', v_action, TO_CHAR(:old.price), TO_CHAR(:new.price));
        
        INSERT INTO Audits (table_name, column_name, action, old_value, new_value)
        VALUES ('VIDEOGAMES', 'AVERAGE_RATING', v_action, TO_CHAR(:old.average_rating), TO_CHAR(:new.average_rating));
    ELSIF DELETING THEN
        INSERT INTO Audits (table_name, column_name, action, old_value, new_value)
        VALUES ('VIDEOGAMES', '', v_action, '', NULL);
    END IF;
END;
/

-- Create trigger for auditing Ratings table
CREATE OR REPLACE TRIGGER trg_audit_ratings
AFTER INSERT OR UPDATE OR DELETE ON Ratings
FOR EACH ROW
DECLARE
    v_action VARCHAR2(6);
BEGIN
    IF INSERTING THEN
        v_action := 'INSERT';
    ELSIF UPDATING THEN
        v_action := 'UPDATE';
    ELSIF DELETING THEN
        v_action := 'DELETE';
    END IF;

    IF INSERTING OR UPDATING THEN
        INSERT INTO Audits (table_name, column_name, action, old_value, new_value)
        VALUES ('RATINGS', 'SCORE', v_action, TO_CHAR(:old.score), TO_CHAR(:new.score));
    ELSIF DELETING THEN
        INSERT INTO Audits (table_name, column_name, action, old_value, new_value)
        VALUES ('RATINGS', 'SCORE', v_action, TO_CHAR(:old.score), NULL);
    END IF;
END;
/

-- Create a queue table for grade updates
CREATE TABLE ratings_update_queue (
    game_id NUMBER
);

/**
* Para crear el directorio donde se exportara el archivo CSV
* se parte desde el supuesto que el directorio C:\app ya existe 
**/
CREATE OR REPLACE DIRECTORY my_dir AS 'C:\app';