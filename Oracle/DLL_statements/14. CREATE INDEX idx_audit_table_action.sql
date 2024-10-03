-- Create index on Audit table_name and action
CREATE INDEX idx_audit_table_action ON Audits(table_name, action);