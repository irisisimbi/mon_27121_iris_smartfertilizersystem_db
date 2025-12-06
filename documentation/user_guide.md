# User Guide

## Smart Fertilizer Recommendation System

This guide provides step-by-step instructions for using the Smart Fertilizer Recommendation System.

---

## Getting Started

### System Requirements
- Access to Oracle Database
- SQL Developer or SQL*Plus installed
- Valid user credentials (for lab users)
- Internet connection (optional for remote access)

### First Time Login

**For Lab Users:**
1. Open SQL Developer
2. Create a new database connection
3. Enter your credentials provided by the system administrator
4. Test connection and connect

---

## For Farmers

### Registering Your Farm

To register your farm in the system, contact your local agricultural laboratory. They will need:

- **Farm Name** - Your farm or business name
- **Location** - Your farm's geographic location (city, district, or coordinates)

**Example:**
```sql
-- The lab will execute this for you:
INSERT INTO farmer (farm_name, location)
VALUES ('Green Valley Farm', 'Kigali, Rwanda');
```

### Submitting Soil Samples

**Step 1: Collect Soil Sample**
- Collect soil from multiple spots in your field
- Mix thoroughly in a clean container
- Take approximately 500g of soil
- Place in a sealed bag with your farm name

**Step 2: Deliver to Laboratory**
- Bring sample to authorized agricultural lab
- Provide your farm name and location
- Lab will conduct N-P-K analysis

**Step 3: Receive Results**
- Lab will test your soil for:
  - **Nitrogen (N)** - for leaf and stem growth
  - **Phosphorus (P)** - for root development
  - **Potassium (K)** - for overall plant health
- Results typically ready within 24-48 hours

**Step 4: Get Recommendations**
- Lab will provide fertilizer recommendations
- Recommendations include:
  - Fertilizer type needed
  - Application amount
  - Application instructions

### Viewing Your Test History

To see all your previous soil tests, ask the lab to run:

```sql
SELECT s.test_date, s.nitrogen, s.phosphorus, s.potassium,
       r.recommendation_text
FROM soil_test s
LEFT JOIN recommendation r ON s.soil_id = r.soil_id
JOIN farmer f ON s.farmer_id = f.farmer_id
WHERE f.farm_name = 'Your Farm Name'
ORDER BY s.test_date DESC;
```

---

## For Lab Users

### Daily Operations

#### 1. Adding a New Farmer

```sql
-- Insert new farmer
INSERT INTO farmer (farm_name, location)
VALUES ('Happy Harvest Farm', 'Musanze, Rwanda');

-- Verify insertion
SELECT * FROM farmer WHERE farm_name = 'Happy Harvest Farm';
```

#### 2. Recording a Soil Test

```sql
-- Insert soil test results
INSERT INTO soil_test (farmer_id, lab_user_id, nitrogen, phosphorus, potassium)
VALUES (
  1,      -- farmer_id (get from farmer table)
  1,      -- your lab_user_id
  15.5,   -- nitrogen level
  22.3,   -- phosphorus level
  18.7    -- potassium level
);

-- The system will automatically:
-- - Assign a unique soil_id
-- - Set test_date to today's date
-- - Log the operation in audit_log
```

#### 3. Generating Fertilizer Recommendations

**Option A: Using Stored Procedure (Automated)**
```sql
-- Execute recommendation procedure
EXECUTE recommend_fertilizer(soil_id => 1);

-- View the generated recommendation
SELECT * FROM recommendation WHERE soil_id = 1;
```

**Option B: Manual Recommendation Entry**
```sql
-- Insert manual recommendation
INSERT INTO recommendation (soil_id, fertilizer_id, recommendation_text)
VALUES (
  1,    -- soil_id
  2,    -- fertilizer_id (from fertilizer table)
  'Apply 50kg of NPK 15-15-15 per hectare. Split application: 25kg at planting, 25kg after 4 weeks.'
);
```

#### 4. Approving Recommendations

```sql
-- Update recommendation with approval
UPDATE recommendation
SET approved_by = 1  -- your user_id
WHERE rec_id = 1;
```

### Managing Fertilizer Catalog

#### Adding New Fertilizer

```sql
INSERT INTO fertilizer (fertilizer_name, nutrient_type, recommended_amount)
VALUES ('NPK 20-10-10', 'Nitrogen', 50);
```

#### Viewing Available Fertilizers

```sql
SELECT * FROM fertilizer
ORDER BY nutrient_type, fertilizer_name;
```

#### Updating Fertilizer Information

```sql
UPDATE fertilizer
SET recommended_amount = 60
WHERE fertilizer_name = 'NPK 20-10-10';
```

### Managing Holidays

```sql
-- Add a holiday (no soil tests on this date)
INSERT INTO holiday (holiday_date, description)
VALUES (DATE '2025-12-25', 'Christmas Day');

-- View all holidays
SELECT * FROM holiday
ORDER BY holiday_date;
```

---

## For Administrators

### User Management

#### Creating New Lab User

```sql
-- Add new lab user
INSERT INTO lab_user (username, role)
VALUES ('john.doe', 'Lab Technician');

-- Verify creation
SELECT * FROM lab_user WHERE username = 'john.doe';
```

#### Viewing All Lab Users

```sql
SELECT user_id, username, role
FROM lab_user
ORDER BY username;
```

#### Updating User Role

```sql
UPDATE lab_user
SET role = 'Senior Agronomist'
WHERE username = 'john.doe';
```

### System Monitoring

#### View Recent Operations

```sql
-- Last 20 operations
SELECT username, operation, object_type, attempt_time, status
FROM audit_log
ORDER BY attempt_time DESC
FETCH FIRST 20 ROWS ONLY;
```

#### Check Failed Operations

```sql
-- View failed operations
SELECT username, operation, object_type, message, attempt_time
FROM audit_log
WHERE status = 'FAILURE'
ORDER BY attempt_time DESC;
```

#### Monitor System Activity by User

```sql
-- Operations by specific user
SELECT operation, COUNT(*) as operation_count
FROM audit_log
WHERE username = 'john.doe'
  AND attempt_time >= SYSDATE - 7  -- Last 7 days
GROUP BY operation
ORDER BY operation_count DESC;
```

### Database Maintenance

#### View Database Statistics

```sql
-- Count records in each table
SELECT 'FARMER' as table_name, COUNT(*) as row_count FROM farmer
UNION ALL
SELECT 'LAB_USER', COUNT(*) FROM lab_user
UNION ALL
SELECT 'SOIL_TEST', COUNT(*) FROM soil_test
UNION ALL
SELECT 'FERTILIZER', COUNT(*) FROM fertilizer
UNION ALL
SELECT 'RECOMMENDATION', COUNT(*) FROM recommendation
UNION ALL
SELECT 'AUDIT_LOG', COUNT(*) FROM audit_log
UNION ALL
SELECT 'HOLIDAY', COUNT(*) FROM holiday;
```

#### Archive Old Audit Logs

```sql
-- Create archive table (run once)
CREATE TABLE audit_log_archive AS
SELECT * FROM audit_log WHERE 1=0;

-- Archive logs older than 1 year
INSERT INTO audit_log_archive
SELECT * FROM audit_log
WHERE attempt_time < ADD_MONTHS(SYSTIMESTAMP, -12);

-- Delete archived logs from main table
DELETE FROM audit_log
WHERE attempt_time < ADD_MONTHS(SYSTIMESTAMP, -12);

COMMIT;
```

---

## Understanding Results

### Nutrient Level Interpretation

#### Nitrogen (N)
| Level | Range | Status | Action |
|-------|-------|--------|--------|
| Low | < 20 | Deficient | Apply nitrogen-rich fertilizer |
| Moderate | 20-40 | Adequate | Monitor, may need maintenance |
| High | > 40 | Sufficient | No nitrogen needed |

#### Phosphorus (P)
| Level | Range | Status | Action |
|-------|-------|--------|--------|
| Low | < 15 | Deficient | Apply phosphorus-rich fertilizer |
| Moderate | 15-30 | Adequate | Monitor, may need maintenance |
| High | > 30 | Sufficient | No phosphorus needed |

#### Potassium (K)
| Level | Range | Status | Action |
|-------|-------|--------|--------|
| Low | < 20 | Deficient | Apply potassium-rich fertilizer |
| Moderate | 20-35 | Adequate | Monitor, may need maintenance |
| High | > 35 | Sufficient | No potassium needed |

### Sample Recommendations

**Example 1: Nitrogen Deficiency**
```
Soil Test Results:
- Nitrogen: 12 (Low)
- Phosphorus: 25 (Adequate)
- Potassium: 28 (Adequate)

Recommendation:
Apply Nitrogen-rich fertilizer (Urea 46-0-0)
Amount: 40kg per hectare
Application: Split into 2 doses - at planting and 4 weeks later
```

**Example 2: Multiple Deficiencies**
```
Soil Test Results:
- Nitrogen: 15 (Low)
- Phosphorus: 10 (Low)
- Potassium: 18 (Low)

Recommendation:
Apply balanced NPK fertilizer (15-15-15)
Amount: 60kg per hectare
Application: Single application at planting time
Follow-up test in 3 months recommended
```

**Example 3: Fertile Soil**
```
Soil Test Results:
- Nitrogen: 45 (High)
- Phosphorus: 32 (High)
- Potassium: 38 (High)

Recommendation:
Soil is fertile - no fertilizer needed at this time
Maintain good agricultural practices
Retest in 6 months to monitor nutrient levels
```

---

## Common Tasks

### Task 1: Find Farmer's Most Recent Test

```sql
SELECT f.farm_name, f.location,
       s.test_date, s.nitrogen, s.phosphorus, s.potassium,
       r.recommendation_text
FROM farmer f
JOIN soil_test s ON f.farmer_id = s.farmer_id
LEFT JOIN recommendation r ON s.soil_id = r.soil_id
WHERE f.farmer_id = 1  -- Replace with actual farmer_id
ORDER BY s.test_date DESC
FETCH FIRST 1 ROW ONLY;
```

### Task 2: Generate Monthly Report

```sql
-- Summary of tests performed this month
SELECT 
  COUNT(*) as total_tests,
  AVG(nitrogen) as avg_nitrogen,
  AVG(phosphorus) as avg_phosphorus,
  AVG(potassium) as avg_potassium,
  COUNT(DISTINCT farmer_id) as unique_farmers
FROM soil_test
WHERE test_date >= TRUNC(SYSDATE, 'MM');  -- Current month
```

### Task 3: Find Most Common Fertilizer Recommendations

```sql
SELECT f.fertilizer_name, f.nutrient_type,
       COUNT(*) as recommendation_count
FROM recommendation r
JOIN fertilizer f ON r.fertilizer_id = f.fertilizer_id
WHERE r.rec_date >= ADD_MONTHS(SYSDATE, -3)  -- Last 3 months
GROUP BY f.fertilizer_name, f.nutrient_type
ORDER BY recommendation_count DESC;
```

### Task 4: Search Farmers by Location

```sql
SELECT farmer_id, farm_name, location
FROM farmer
WHERE UPPER(location) LIKE '%KIGALI%'
ORDER BY farm_name;
```

---

## Troubleshooting

### Problem: Cannot Insert Soil Test

**Error:** "ORA-02291: integrity constraint violated - parent key not found"

**Solution:** 
- Verify farmer_id exists in farmer table
- Verify lab_user_id exists in lab_user table

```sql
-- Check if farmer exists
SELECT * FROM farmer WHERE farmer_id = 1;

-- Check if lab user exists
SELECT * FROM lab_user WHERE user_id = 1;
```

### Problem: Negative Nutrient Values

**Error:** "ORA-02290: check constraint violated"

**Solution:** 
- Nutrient values must be >= 0
- Check your test results
- Re-enter with correct values

### Problem: Duplicate Username

**Error:** "ORA-00001: unique constraint violated"

**Solution:**
- Username already exists
- Choose a different username
- Or update the existing user

```sql
-- Check if username exists
SELECT * FROM lab_user WHERE username = 'john.doe';
```

### Problem: Cannot Delete Farmer

**Error:** "ORA-02292: integrity constraint violated - child record found"

**Solution:**
- Farmer has existing soil tests
- Cannot delete farmer with test history
- Consider marking farmer as inactive instead (add status column)

---

## FAQ

### Q1: How often should I test my soil?
**A:** Test your soil at least once per growing season. More frequent testing (every 3-6 months) is recommended if:
- Starting a new crop
- After applying fertilizer
- Experiencing crop problems
- Changing farming practices

### Q2: How long are test results valid?
**A:** Soil nutrient levels can change within 3-6 months depending on:
- Crop planted
- Fertilizer applied
- Rainfall and irrigation
- Farming practices

### Q3: Can I get recommendations for specific crops?
**A:** Currently, the system provides general fertilizer recommendations based on N-P-K levels. Future versions will include crop-specific recommendations.

### Q4: What if my soil needs multiple nutrients?
**A:** The system will recommend a balanced fertilizer (NPK) that addresses all deficiencies. Always follow the recommended application amounts.

### Q5: How do I interpret my test results?
**A:** Refer to the [Nutrient Level Interpretation](#nutrient-level-interpretation) section above for detailed guidance on each nutrient.

### Q6: Can I access my test history?
**A:** Yes, contact your lab to retrieve your complete test history. They can generate a report showing all your past tests and recommendations.

### Q7: What if I'm tested on a holiday?
**A:** The system prevents soil test entries on registered holidays. Contact the lab to schedule your test on a working day.

### Q8: Who approves the recommendations?
**A:** Recommendations are approved by qualified agronomists or senior lab technicians. The approved_by field tracks who validated each recommendation.

---

## Best Practices

### For Farmers
1. ✅ Test soil before each planting season
2. ✅ Collect samples from multiple field locations
3. ✅ Keep records of past recommendations and results
4. ✅ Follow fertilizer application instructions carefully
5. ✅ Monitor crop response to fertilizer applications

### For Lab Users
1. ✅ Double-check all entered values before saving
2. ✅ Always verify farmer information is correct
3. ✅ Approve recommendations only after thorough review
4. ✅ Document any unusual test results
5. ✅ Follow up with farmers on recommendation effectiveness

### For Administrators
1. ✅ Review audit logs regularly
2. ✅ Monitor system performance
3. ✅ Keep fertilizer catalog updated
4. ✅ Maintain holiday calendar
5. ✅ Archive old data periodically

---

## Getting Help

### Technical Support
- Check the [Troubleshooting](#troubleshooting) section
- Review audit logs for error messages
- Contact your database administrator

### Training Resources
- System architecture documentation
- Sample queries and procedures
- Video tutorials (coming soon)

### Contact Information
For assistance, please contact:
- **System Administrator:** [admin@yoursystem.com]
- **Technical Support:** [support@yoursystem.com]
- **Training:** [training@yoursystem.com]

---

**User Guide Version:** 1.0  
**Last Updated:** December 2025  
**Maintained By:** Isimbi Mushimire Iris (ID: 27121)