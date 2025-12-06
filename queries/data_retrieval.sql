------------------------------------------------------------
-- data_retrieval.sql
-- Basic SELECT queries for Smart Fertilizer System
-- Author: Isimbi Mushimire Iris
------------------------------------------------------------

-- Retrieve all farmers
SELECT * FROM FARMERS ORDER BY FARMER_ID;

-- Retrieve the first 10 soil tests
SELECT * FROM SOIL_TEST WHERE ROWNUM <= 10;

-- Retrieve all fertilizers
SELECT * FROM FERTILIZER ORDER BY FERTILIZER_ID;

-- Retrieve all recommendations
SELECT * FROM RECOMMENDATION ORDER BY REC_ID;

-- Farmer with their soil test + recommendation + fertilizer
SELECT 
    f.farmer_id,
    f.first_name,
    f.last_name,
    s.soil_id,
    s.nitrogen,
    s.phosphorus,
    s.potassium,
    r.rec_id,
    fert.fert_name,
    fert.npk_ratio
FROM FARMERS f
JOIN SOIL_TEST s ON f.farmer_id = s.farmer_id
LEFT JOIN RECOMMENDATION r ON s.soil_id = r.soil_id
LEFT JOIN FERTILIZER fert ON r.fertilizer_id = fert.fertilizer_id
ORDER BY f.farmer_id;

-- Show top 5 fertilizers with current stock levels
SELECT fertilIZEr_id, fert_name, stock FROM FERTILIZER 
WHERE ROWNUM <= 5;

-- Show farmers who have more than 2 soil tests
SELECT farmer_id, COUNT(*) AS test_count
FROM SOIL_TEST
GROUP BY farmer_id
HAVING COUNT(*) > 2
ORDER BY test_count DESC;

-- Show soil tests performed by each lab user
SELECT l.lab_id, l.full_name, COUNT(s.soil_id) AS tests_done
FROM LAB_USER l
LEFT JOIN SOIL_TEST s ON l.lab_id = s.lab_id
GROUP BY l.lab_id, l.full_name
ORDER BY tests_done DESC;

-- Retrieve the last 10 recommendations made
SELECT *
FROM (
      SELECT * FROM RECOMMENDATION ORDER BY RECOMMENDED_AT DESC
     )
WHERE ROWNUM <= 10;

------------------------------------------------------------
-- END OF FILE
------------------------------------------------------------
