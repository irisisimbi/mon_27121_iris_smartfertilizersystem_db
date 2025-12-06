---------------------------------------------------------
-- PACKAGES.SQL — SMART FERTILIZER RECOMMENDATION SYSTEM
---------------------------------------------------------

---------------- PACKAGE: Fertilizer Logic ----------------
CREATE OR REPLACE PACKAGE pkg_fertilizer AS
    FUNCTION analyze_soil (
        p_n IN NUMBER,
        p_p IN NUMBER,
        p_k IN NUMBER
    ) RETURN VARCHAR2;

    PROCEDURE recommend_by_test (
        p_test_id IN NUMBER
    );
END pkg_fertilizer;
/
---------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY pkg_fertilizer AS

    -- Function: Perform nutrient analysis
    FUNCTION analyze_soil (
        p_n IN NUMBER,
        p_p IN NUMBER,
        p_k IN NUMBER
    ) RETURN VARCHAR2 IS
    BEGIN
        IF p_n < 50 THEN
            RETURN 'Use Nitrogen-rich fertilizer';
        ELSIF p_p < 40 THEN
            RETURN 'Use Phosphorus-rich fertilizer';
        ELSIF p_k < 45 THEN
            RETURN 'Use Potassium-rich fertilizer';
        ELSE
            RETURN 'Soil is fertile, no fertilizer needed';
        END IF;
    END;

    -- Procedure: Generate recommendation using package logic
    PROCEDURE recommend_by_test (
        p_test_id IN NUMBER
    ) AS
        v_n NUMBER;
        v_p NUMBER;
        v_k NUMBER;
        v_msg VARCHAR2(200);
    BEGIN
        SELECT NITROGEN, PHOSPHORUS, POTASSIUM
        INTO v_n, v_p, v_k
        FROM SOIL_TESTS
        WHERE TEST_ID = p_test_id;

        v_msg := analyze_soil(v_n, v_p, v_k);

        INSERT INTO FERTILIZER_RECOMMENDATIONS (TEST_ID, RECOMMENDATION, CREATED_ON)
        VALUES (p_test_id, v_msg, SYSDATE);
    END;

END pkg_fertilizer;
/
---------------------------------------------------------

---------------- PACKAGE: Audit Management ----------------
CREATE OR REPLACE PACKAGE pkg_audit AS
    PROCEDURE record_event (
        p_action IN VARCHAR2,
        p_table  IN VARCHAR2,
        p_status IN VARCHAR2,
        p_remark IN VARCHAR2
    );
END pkg_audit;
/
---------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY pkg_audit AS

    PROCEDURE record_event (
        p_action IN VARCHAR2,
        p_table  IN VARCHAR2,
        p_status IN VARCHAR2,
        p_remark IN VARCHAR2
    ) AS
    BEGIN
        INSERT INTO AUDIT_LOG (ACTION_TYPE, TABLE_NAME, STATUS, REMARKS, USER_NAME)
        VALUES (p_action, p_table, p_status, p_remark, USER);
    END;

END pkg_audit;
/
---------------------------------------------------------
