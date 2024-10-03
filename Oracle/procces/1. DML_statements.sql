-- Semilla tabla companies
INSERT INTO Companies (company_id, company_name, created_at, updated_at, created_by, updated_by) 
VALUES (null,'From Software', SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA'); 
INSERT INTO Companies (company_id, company_name, created_at, updated_at, created_by, updated_by) 
VALUES (null,'StudioMDHR', SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA'); 
INSERT INTO Companies (company_id, company_name, created_at, updated_at, created_by, updated_by) 
VALUES (null,'Konami', SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA');
INSERT INTO Companies (company_id, company_name, created_at, updated_at, created_by, updated_by) 
VALUES (null,'Koei Tecmo', SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA');
INSERT INTO Companies (company_id, company_name, created_at, updated_at, created_by, updated_by) 
VALUES (null,'Extremely OK Games', SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA');
INSERT INTO Companies (company_id, company_name, created_at, updated_at, created_by, updated_by) 
VALUES (null,'Rare', SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA');
INSERT INTO Companies (company_id, company_name, created_at, updated_at, created_by, updated_by) 
VALUES (null,'Team17', SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA');
INSERT INTO Companies (company_id, company_name, created_at, updated_at, created_by, updated_by) 
VALUES (null,'Ska Studios', SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA');
INSERT INTO Companies (company_id, company_name, created_at, updated_at, created_by, updated_by) 
VALUES (null,'Direct2Drive', SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA');
INSERT INTO Companies (company_id, company_name, created_at, updated_at, created_by, updated_by) 
VALUES (null,'Team Cherry', SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA');
INSERT INTO Companies (company_id, company_name, created_at, updated_at, created_by, updated_by) 
VALUES (null,'Nintendo', SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA');
INSERT INTO Companies (company_id, company_name, created_at, updated_at, created_by, updated_by) 
VALUES (null,'Capcom', SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA');

--semilla table videogames
INSERT INTO Videogames (game_id, title, company_id, release_year, price, average_rating, created_at, updated_at, created_by, updated_by)
 VALUES( null, 'Dark Souls', 1, 2011, 39.99, 0, SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA'); 
 INSERT INTO Videogames (game_id, title, company_id, release_year, price, average_rating, created_at, updated_at, created_by, updated_by)
 VALUES( null, 'Sekiro: Shadows Die Twice', 9, 2019, 59.99, 0, SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA'); 
 INSERT INTO Videogames (game_id, title, company_id, release_year, price, average_rating, created_at, updated_at, created_by, updated_by)
 VALUES( null, 'Bloodborne', 1, 2015, 19.99, 0, SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA'); 
 INSERT INTO Videogames (game_id, title, company_id, release_year, price, average_rating, created_at, updated_at, created_by, updated_by)
 VALUES( null, Q'[Demon's Souls]', 1, 2009, 39.99, 0, SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA'); 
 INSERT INTO Videogames (game_id, title, company_id, release_year, price, average_rating, created_at, updated_at, created_by, updated_by)
 VALUES( null, 'Cuphead', 2, 2017, 19.99, 0, SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA'); 
 INSERT INTO Videogames (game_id, title, company_id, release_year, price, average_rating, created_at, updated_at, created_by, updated_by)
 VALUES( null, 'Contra', 3, 1987, 6.99, 0, SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA'); 
 INSERT INTO Videogames (game_id, title, company_id, release_year, price, average_rating, created_at, updated_at, created_by, updated_by)
 VALUES( null, 'Nioh', 4, 2017, 19.99, 0, SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA'); 
 INSERT INTO Videogames (game_id, title, company_id, release_year, price, average_rating, created_at, updated_at, created_by, updated_by)
 VALUES( null, 'Celeste', 5, 2018, 7.99, 0, SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA'); 
 INSERT INTO Videogames (game_id, title, company_id, release_year, price, average_rating, created_at, updated_at, created_by, updated_by)
 VALUES( null, 'Battletoads', 6, 1999, 5.99, 0, SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA'); 
 INSERT INTO Videogames (game_id, title, company_id, release_year, price, average_rating, created_at, updated_at, created_by, updated_by)
 VALUES( null, 'Battletoads', 7, 2019, 24.99, 0, SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA'); 
 INSERT INTO Videogames (game_id, title, company_id, release_year, price, average_rating, created_at, updated_at, created_by, updated_by)
 VALUES( null, 'Teenage Mutant Ninja Turtles', 3, 1989, 12.99, 0, SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA'); 
 INSERT INTO Videogames (game_id, title, company_id, release_year, price, average_rating, created_at, updated_at, created_by, updated_by)
 VALUES( null, 'Ninja Gaiden Black', 4, 2005, 25.99, 0, SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA'); 
 INSERT INTO Videogames (game_id, title, company_id, release_year, price, average_rating, created_at, updated_at, created_by, updated_by)
 VALUES( null, q'[Ghosts'n Goblins]', 12, 1985, 6.99, 0, SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA'); 
 INSERT INTO Videogames (game_id, title, company_id, release_year, price, average_rating, created_at, updated_at, created_by, updated_by)
 VALUES( null, 'Salt and Sanctuary', 8, 2016, 17.99, 0, SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA'); 
 INSERT INTO Videogames (game_id, title, company_id, release_year, price, average_rating, created_at, updated_at, created_by, updated_by)
 VALUES( null, 'Dark Souls III', 1, 2016, 59.99, 0, SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA'); 
 INSERT INTO Videogames (game_id, title, company_id, release_year, price, average_rating, created_at, updated_at, created_by, updated_by)
 VALUES( null, 'Super Meat Boy', 9, 2010, 5.99, 0, SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA'); 
 INSERT INTO Videogames (game_id, title, company_id, release_year, price, average_rating, created_at, updated_at, created_by, updated_by)
 VALUES( null, 'Dark Souls II', 1, 2014, 39.99, 0, SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA'); 
 INSERT INTO Videogames (game_id, title, company_id, release_year, price, average_rating, created_at, updated_at, created_by, updated_by)
 VALUES( null, 'DHollow Knight', 10, 2017, 14.99, 0, SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA'); 
 INSERT INTO Videogames (game_id, title, company_id, release_year, price, average_rating, created_at, updated_at, created_by, updated_by)
 VALUES( null, 'Super Mario Maker 2', 11, 2019, 59.99, 0, SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA'); 
  INSERT INTO Videogames (game_id, title, company_id, release_year, price, average_rating, created_at, updated_at, created_by, updated_by)
 VALUES( null, 'Elden Ring', 1, 2022, 69.99, 0, SYSDATE, SYSDATE, 'FGALARZA', 'FGALARZA');
 
COMMIT;