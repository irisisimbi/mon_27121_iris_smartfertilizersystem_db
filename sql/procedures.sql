---------------------------------------------------------
-- PROCEDURES.SQL — SMART FERTILIZER RECOMMENDATION SYSTEM
---------------------------------------------------------

-- PROCEDURE 1: Insert Farmer
CREATE OR REPLACE PROCEDURE add_farmer (
    p_full_name   IN VARCHAR2,
    p_email       IN VARCHAR2,
    p_phone       IN VARCHAR2,
    p_address     IN VARCHAR2
) AS
BEGIN
    INSERT INTO FARMERS (FULL_NAME, EMAIL, PHONE_NUMBER, ADDRESS)
    VALUES (p_full_name, p_email, p_phone, p_address);
END;
/
---------------------------------------------------------

-- PROCEDURE 2: Insert Soil Test Data
CREATE OR REPLACE PROCEDURE add_soil_test (
    p_farmer_id IN NUMBER,
    p_nitrogen  IN NUMBER,
    p_phosphorus IN NUMBER,
    p_potassium IN NUMBER
) AS
BEGIN
    INSERT INTO SOIL_TESTS (FARMER_ID, NITROGEN, PHOSPHORUS, POTASSIUM, TEST_DATE)
    VALUES (p_farmer_id, p_nitrogen, p_phosphorus, p_potassium, SYSDATE);
END;
/
---------------------------------------------------------

-- PROCEDURE 3: Generate Fertilizer Recommendation
CREATE OR REPLACE PROCEDURE generate_recommendation (
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

    IF v_n < 50 THEN
        v_msg := 'Use Nitrogen-rich fertilizer';
    ELSIF v_p < 40 THEN
        v_msg := 'Use Phosphorus-rich fertilizer';
    ELSIF v_k < 45 THEN
        v_msg := 'Use Potassium-rich fertilizer';
    ELSE
        v_msg := 'Soil is fertile, no fertilizer needed';
    END IF;

    INSERT INTO FERTILIZER_RECOMMENDATIONS (TEST_ID, RECOMMENDATION, CREATED_ON)
    VALUES (p_test_id, v_msg, SYSDATE);
END;
/
---------------------------------------------------------

-- PROCEDURE 4: View Recommendations for a Farmer
CREATE OR REPLACE PROCEDURE get_recommendations (
    p_farmer_id IN NUMBER
) AS
BEGIN
    SELECT r.RECOMMENDATION, r.CREATED_ON
    FROM FERTILIZER_RECOMMENDATIONS r
    JOIN SOIL_TESTS s ON r.TEST_ID = s.TEST_ID
    WHERE s.FARMER_ID = p_farmer_id;
END;
/
---------------------------------------------------------

-- PROCEDURE 5: Insert Public Holiday
CREATE OR REPLACE PROCEDURE add_holiday (
    p_date IN DATE,
    p_desc IN VARCHAR2
) AS
BEGIN
    INSERT INTO PUBLIC_HOLIDAYS (HOLIDAY_DATE, DESCRIPTION)
    VALUES (p_date, p_desc);
END;
/
---------------------------------------------------------
