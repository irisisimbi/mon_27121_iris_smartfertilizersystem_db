-- 30_triggers_and_audit.sql

-- Helper: check whether operation is allowed (returns TRUE if allowed)
CREATE OR REPLACE FUNCTION is_operation_allowed(p_date IN DATE) RETURN BOOLEAN IS
  v_day VARCHAR2(3);
  v_count NUMBER;
BEGIN
  -- get short day name in English (MON, TUE, ...)
  v_day := RTRIM(TO_CHAR(p_date, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH'));

  -- If weekday (MON-FRI) -> deny (return FALSE). Weekend (SAT,SUN) -> allow.
  IF v_day IN ('MON','TUE','WED','THU','FRI') THEN
    RETURN FALSE;
  END IF;

  -- Holiday check
  SELECT COUNT(*) INTO v_count FROM holiday WHERE TRUNC(holiday_date) = TRUNC(p_date);
  IF v_count > 0 THEN
    RETURN FALSE;
  END IF;

  RETURN TRUE;
EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE;
END;
/

-- Trigger for soil_test table
CREATE OR REPLACE TRIGGER trg_restrict_dml_on_soil_test
  BEFORE INSERT OR UPDATE OR DELETE ON soil_test
  FOR EACH ROW
DECLARE
  v_allowed BOOLEAN;
  v_target_id NUMBER;
BEGIN
  v_allowed := is_operation_allowed(SYSDATE);
  IF NOT v_allowed THEN
    -- Record the denied attempt in audit_log
    v_target_id := NVL(:NEW.soil_id, :OLD.soil_id);
    INSERT INTO audit_log(username, operation, object_type, object_id, status, message)
      VALUES (USER, ORA_SYSEVENT, 'SOIL_TEST', v_target_id, 'DENIED', 'Operation blocked by weekday/holiday rule');
    RAISE_APPLICATION_ERROR(-20001, 'DML denied: operations not allowed on weekdays or declared holidays.');
  ELSE
    -- Log allowed operations
    v_target_id := NVL(:NEW.soil_id, :OLD.soil_id);
    INSERT INTO audit_log(username, operation, object_type, object_id, status, message)
      VALUES (USER, ORA_SYSEVENT, 'SOIL_TEST', v_target_id, 'ALLOWED', 'Operation allowed');
  END IF;
END;
/
