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