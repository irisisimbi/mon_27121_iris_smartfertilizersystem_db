------------------------------------------------------------
-- analytics_queries.sql
-- Advanced Analytics for Smart Fertilizer System
-- Author: Isimbi Mushimire Iris
------------------------------------------------------------

-- 1. Average nutrient levels across all soil tests
SELECT 
    ROUND(AVG(nitrogen), 2) AS avg_nitrogen,
    ROUND(AVG(phosphorus), 2) AS avg_phosphorus,
    ROUND(AVG(potassium), 2) AS avg_potassium
FROM SOIL_TEST;

-- 2. Most frequently recommended fertilizer
SELECT 
    fertilizer_id,
    COUNT(*) AS recommendation_count
FROM RECOMMENDATION
GROUP BY fertilizer_id
ORDER BY recommendation_count DESC;

-- 3. Top 10 farmers with the highest number of soil tests
SELECT 
    f.farmer_id,
    f.first_name,
    f.last_name,
    COUNT(s.soil_id) AS total_tests
FROM FARMERS f
JOIN SOIL_TEST s ON f.farmer_id = s.farmer_id
GROUP BY f.farmer_id, f.first_name, f.last_name
ORDER BY total_tests DESC
FETCH FIRST 10 ROWS ONLY;

-- 4. Fertilizer stock usage based on recommendation frequency
SELECT 
    fert.fert_name,
    fert.stock,
    COUNT(r.rec_id) AS usage_count
FROM FERTILIZER fert
LEFT JOIN RECOMMENDATION r ON fert.fertilizer_id = r.fertilizer_id
GROUP BY fert.fert_name, fert.stock
ORDER BY usage_count DESC;

-- 5. Nutrient deficiency classification
SELECT 
    soil_id,
    farmer_id,
    nitrogen,
    phosphorus,
    potassium,
    CASE
        WHEN nitrogen < 20 THEN 'Low Nitrogen'
        WHEN phosphorus < 15 THEN 'Low Phosphorus'
        WHEN potassium < 10 THEN 'Low Potassium'
        ELSE 'Healthy Soil'
    END AS soil_status
FROM SOIL_TEST
ORDER BY soil_id;

-- 6. Daily recommendation frequency (requires timestamps)
SELECT 
    TRUNC(recommended_at) AS date,
    COUNT(*) AS total_recommendations
FROM RECOMMENDATION
GROUP BY TRUNC(recommended_at)
ORDER BY date;

-- 7. Top fertilizers by nutrient score (using your function)
SELECT 
    fert.fert_name,
    nutrient_score(fert.npk_ratio) AS score
FROM FERTILIZER fert
ORDER BY score DESC;

-- 8. High-risk soils (very low NPK)
SELECT *
FROM SOIL_TEST
WHERE nitrogen < 10 AND phosphorus < 8 AND potassium < 6;

------------------------------------------------------------
-- END OF FILE
------------------------------------------------------------
