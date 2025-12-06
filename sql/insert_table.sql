-- 11_insert_sample_data.sql

-- Fertilizers
INSERT INTO fertilizer (fertilizer_name, nutrient_type, recommended_amount) VALUES ('Urea', 'Nitrogen', 50);
INSERT INTO fertilizer (fertilizer_name, nutrient_type, recommended_amount) VALUES ('DAP', 'Phosphorus', 40);
INSERT INTO fertilizer (fertilizer_name, nutrient_type, recommended_amount) VALUES ('Muriate of Potash', 'Potassium', 30);
INSERT INTO fertilizer (fertilizer_name, nutrient_type, recommended_amount) VALUES ('NPK 20-10-10', 'Nitrogen', 45);

-- Farmers
INSERT INTO farmer (farm_name, location) VALUES ('Green Valley Farm', 'Gitarama');
INSERT INTO farmer (farm_name, location) VALUES ('Sunrise Fields', 'Kigali');

-- Lab Users
INSERT INTO lab_user (username, role) VALUES ('lab_jean', 'Lab Technician');
INSERT INTO lab_user (username, role) VALUES ('agro_anne', 'Agronomist');

-- Holidays (for next month — change dates to actual upcoming month dates)
INSERT INTO holiday (holiday_date, description) VALUES (DATE '2025-12-25', 'Christmas'); -- example

-- Sample soil tests
INSERT INTO soil_test (farmer_id, lab_user_id, nitrogen, phosphorus, potassium, test_date)
 VALUES (1, 1, 8, 15, 18, DATE '2025-11-20');

INSERT INTO soil_test (farmer_id, lab_user_id, nitrogen, phosphorus, potassium, test_date)
 VALUES (2, 1, 12, 7, 20, DATE '2025-11-19');

INSERT INTO soil_test (farmer_id, lab_user_id, nitrogen, phosphorus, potassium, test_date)
 VALUES (1, 2, 22, 25, 30, DATE '2025-11-17');

COMMIT;
