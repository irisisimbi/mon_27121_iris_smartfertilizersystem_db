-- 20_plsql_functions_procedures.sql

-- 1) Assess nutrient level
CREATE OR REPLACE FUNCTION assess_nutrient_level(p_value NUMBER)
RETURN VARCHAR2 IS
BEGIN
  IF p_value IS NULL THEN
    RETURN 'UNKNOWN';
  ELSIF p_value < 10 THEN
    RETURN 'LOW';
  ELSIF p_value BETWEEN 10 AND 20 THEN
    RETURN 'ADEQUATE';
  ELSE
    RETURN 'HIGH';
  END IF;
END;
/

-- 2) Get fertilizer ID for nutrient
CREATE OR REPLACE FUNCTION get_fertilizer_for_nutrient(p_nutrient VARCHAR2)
RETURN NUMBER IS
  v_id NUMBER;
BEGIN
  SELECT fertilizer_id INTO v_id FROM fertilizer
  WHERE nutrient_type = INITCAP(p_nutrient) AND ROWNUM = 1;
  RETURN v_id;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
END;
/

-- 3) Generate recommendation for a single soil_id
CREATE OR REPLACE PROCEDURE generate_recommendation_for_soil(p_soil_id IN NUMBER) IS
  v_nit NUMBER; v_phos NUMBER; v_pot NUMBER;
  v_nit_status VARCHAR2(20);
  v_phos_status VARCHAR2(20);
  v_pot_status VARCHAR2(20);
  v_fid NUMBER;
  v_text VARCHAR2(4000);
BEGIN
  SELECT nitrogen, phosphorus, potassium INTO v_nit, v_phos, v_pot
  FROM soil_test WHERE soil_id = p_soil_id;

  v_nit_status := assess_nutrient_level(v_nit);
  v_phos_status := assess_nutrient_level(v_phos);
  v_pot_status := assess_nutrient_level(v_pot);

  IF v_nit_status = 'LOW' THEN
    v_fid := get_fertilizer_for_nutrient('Nitrogen');
    v_text := 'Use Nitrogen-rich fertilizer';
  ELSIF v_phos_status = 'LOW' THEN
    v_fid := get_fertilizer_for_nutrient('Phosphorus');
    v_text := 'Use Phosphorus-rich fertilizer';
  ELSIF v_pot_status = 'LOW' THEN
    v_fid := get_fertilizer_for_nutrient('Potassium');
    v_text := 'Use Potassium-rich fertilizer';
  ELSE
    v_fid := NULL;
    v_text := 'Soil is fertile, no fertilizer needed';
  END IF;

  INSERT INTO recommendation (soil_id, fertilizer_id, recommendation_text, rec_date)
    VALUES (p_soil_id, v_fid, v_text, SYSDATE);

  INSERT INTO audit_log(username, operation, object_type, object_id, status, message)
    VALUES (USER, 'RECOMMEND', 'SOIL_TEST', p_soil_id, 'ALLOWED', v_text);

  COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    INSERT INTO audit_log(username, operation, object_type, object_id, status, message)
      VALUES (USER, 'RECOMMEND', 'SOIL_TEST', p_soil_id, 'ERROR', 'Soil record not found');
    ROLLBACK;
  WHEN OTHERS THEN
    INSERT INTO audit_log(username, operation, object_type, object_id, status, message)
      VALUES (USER, 'RECOMMEND', 'SOIL_TEST', p_soil_id, 'ERROR', SQLERRM);
    ROLLBACK;
    RAISE;
END;
/

-- 4) Bulk generate recommendations for a date range using cursor
CREATE OR REPLACE PROCEDURE bulk_generate_recommendations(p_from_date IN DATE, p_to_date IN DATE) IS
  CURSOR c IS SELECT soil_id FROM soil_test WHERE test_date BETWEEN p_from_date AND p_to_date;
BEGIN
  FOR r IN c LOOP
    generate_recommendation_for_soil(r.soil_id);
  END LOOP;
END;
/
