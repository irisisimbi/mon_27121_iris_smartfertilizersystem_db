------------------------------------------------------------
-- audit_queries.sql
-- Audit Log Monitoring for Smart Fertilizer System
-- Author: Isimbi Mushimire Iris
------------------------------------------------------------

-- View full audit log
SELECT *
FROM AUDIT_LOG
ORDER BY log_timestamp DESC;

-- Check all changes made by a specific user (LAB user or DB user)
SELECT *
FROM AUDIT_LOG
WHERE username = USER
ORDER BY log_timestamp DESC;

-- Check all DELETE operations
SELECT *
FROM AUDIT_LOG
WHERE action = 'DELETE'
ORDER BY log_timestamp DESC;

-- Check UPDATE actions only
SELECT *
FROM AUDIT_LOG
WHERE action = 'UPDATE'
ORDER BY log_timestamp DESC;

-- Check audit logs for a specific table
SELECT *
FROM AUDIT_LOG
WHERE table_name = 'SOIL_TEST'
ORDER BY log_timestamp DESC;

-- Count actions by type
SELECT action, COUNT(*) AS total
FROM AUDIT_LOG
GROUP BY action;

-- Most modified table
SELECT table_name, COUNT(*) AS modifications
FROM AUDIT_LOG
GROUP BY table_name
ORDER BY modifications DESC;

-- Recent 20 audit events
SELECT *
FROM (
      SELECT * FROM AUDIT_LOG ORDER BY log_timestamp DESC
     )
WHERE ROWNUM <= 20;

------------------------------------------------------------
-- END OF FILE
------------------------------------------------------------
