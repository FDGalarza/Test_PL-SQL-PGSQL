-- Programar un job para ejecutar el procedimiento cada minuto
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
        job_name        => 'UPDATE_RATING_JOB',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN practical_test.process_ratings_queue; END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval => 'FREQ=MINUTELY;INTERVAL=1',
        enabled         => TRUE
    );
END;