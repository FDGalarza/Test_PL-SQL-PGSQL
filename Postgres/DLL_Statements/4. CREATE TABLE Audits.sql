-- Create Audits table
CREATE TABLE Audits (
    audit_id SERIAL PRIMARY KEY,
    table_name VARCHAR(30) NOT NULL,
    column_name VARCHAR(30) NOT NULL,
    action VARCHAR(6) NOT NULL CHECK (action IN ('INSERT', 'UPDATE', 'DELETE')),
    old_value TEXT,
    new_value TEXT,
    audit_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    audit_user VARCHAR(30) DEFAULT CURRENT_USER NOT NULL
);