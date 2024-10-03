CREATE OR REPLACE TYPE rating_obj AS OBJECT (
    nickname VARCHAR2(30),
    game_id NUMBER,
    score NUMBER(3,2)
);