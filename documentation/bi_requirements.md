# Business Intelligence Requirements

## Smart Fertilizer Recommendation System

This document outlines the business intelligence and analytics requirements for the Smart Fertilizer Recommendation System.

---

## Executive Summary

The Smart Fertilizer Recommendation System generates valuable data about soil health, fertilizer usage patterns, and agricultural trends. Business Intelligence (BI) capabilities will transform this raw data into actionable insights for:

- **Agricultural Extension Officers** - Monitor soil health trends across regions
- **Lab Administrators** - Track system usage and operational efficiency
- **Agronomists** - Analyze fertilizer effectiveness and recommendation accuracy
- **Policy Makers** - Understand agricultural needs for resource planning
- **Farmers** - View historical trends and improvement tracking

---

## Business Questions

### Strategic Questions

1. **What are the overall soil health trends in our service area?**
   - Which regions have the most nutrient deficiencies?
   - How is soil health changing over time?
   - What percentage of soil tests indicate deficiencies?

2. **How effective are our fertilizer recommendations?**
   - What is the recommendation acceptance rate?
   - Are farmers seeing improved soil health after following recommendations?
   - Which fertilizers are most frequently recommended?

3. **What are the system usage patterns?**
   - How many soil tests are conducted monthly/yearly?
   - Which lab users are most active?
   - What is the trend in farmer adoption?

4. **Where should we focus our agricultural support?**
   - Which locations need the most intervention?
   - What are the most common nutrient deficiencies by region?
   - Are there seasonal patterns in soil health?

### Operational Questions

5. **What is the average turnaround time for recommendations?**
   - Time between soil test and recommendation generation
   - Which lab users are most efficient?
   - Are there bottlenecks in the process?

6. **How many farmers are returning for follow-up tests?**
   - What is the repeat testing rate?
   - How long between initial and follow-up tests?
   - Are recommendations being implemented?

7. **What is the distribution of nutrient deficiencies?**
   - Percentage of tests showing Nitrogen deficiency
   - Percentage of tests showing Phosphorus deficiency
   - Percentage of tests showing Potassium deficiency
   - Percentage showing multiple deficiencies

8. **What is the fertilizer recommendation mix?**
   - Most recommended fertilizer types
   - Average recommended amounts
   - Cost implications for farmers

### Tactical Questions

9. **Which farmers need immediate follow-up?**
   - Farmers with severe deficiencies
   - Farmers who haven't tested in >6 months
   - High-risk soil conditions

10. **What are the system error and failure rates?**
    - Failed operations in audit log
    - Common error types
    - System reliability metrics

---

## Data Requirements

### Primary Data Sources

#### 1. SOIL_TEST Table
**Required Fields:**
- soil_id
- farmer_id
- lab_user_id
- nitrogen, phosphorus, potassium (nutrient levels)
- test_date

**Analytics Use:**
- Nutrient trend analysis
- Deficiency identification
- Geographic distribution
- Temporal patterns

#### 2. RECOMMENDATION Table
**Required Fields:**
- rec_id
- soil_id
- fertilizer_id
- recommendation_text
- rec_date
- approved_by

**Analytics Use:**
- Recommendation patterns
- Fertilizer usage statistics
- Approval workflow metrics
- Effectiveness tracking

#### 3. FARMER Table
**Required Fields:**
- farmer_id
- farm_name
- location

**Analytics Use:**
- Geographic analysis
- Farmer engagement metrics
- Regional comparisons

#### 4. FERTILIZER Table
**Required Fields:**
- fertilizer_id
- fertilizer_name
- nutrient_type
- recommended_amount

**Analytics Use:**
- Product popularity
- Cost analysis
- Inventory planning

#### 5. AUDIT_LOG Table
**Required Fields:**
- audit_id
- username
- operation
- object_type
- attempt_time
- status

**Analytics Use:**
- System performance monitoring
- User activity tracking
- Error analysis
- Compliance reporting

### Derived Data Requirements

**Calculated Fields Needed:**
1. **Deficiency Indicators**
   - `is_nitrogen_deficient`: CASE WHEN nitrogen < 20 THEN 1 ELSE 0 END
   - `is_phosphorus_deficient`: CASE WHEN phosphorus < 15 THEN 1 ELSE 0 END
   - `is_potassium_deficient`: CASE WHEN potassium < 20 THEN 1 ELSE 0 END

2. **Time Metrics**
   - `days_since_test`: SYSDATE - test_date
   - `recommendation_turnaround`: rec_date - test_date
   - `months_between_tests`: Months between consecutive tests for same farmer

3. **Aggregate Metrics**
   - `avg_nitrogen_level`: Average nitrogen across all tests
   - `deficiency_rate`: Percentage of tests with deficiencies
   - `test_count_by_farmer`: Number of tests per farmer

4. **Geographic Aggregations**
   - `tests_by_location`: Count of tests grouped by location
   - `avg_nutrients_by_region`: Average N-P-K by location

---

## Reporting Requirements

### 1. Monthly Soil Health Summary Report

**Purpose:** Provide monthly overview of soil testing activities and results

**Required Metrics:**
- Total soil tests conducted
- Total unique farmers tested
- Average nutrient levels (N, P, K)
- Deficiency rates by nutrient
- Most common recommendations
- Geographic distribution of tests

**Format:** PDF and Excel export

**Frequency:** Monthly (generated on 1st of each month)

**Recipients:** Lab administrators, agronomists, extension officers

**Sample Query:**
```sql
SELECT 
  TO_CHAR(test_date, 'YYYY-MM') as test_month,
  COUNT(*) as total_tests,
  COUNT(DISTINCT farmer_id) as unique_farmers,
  ROUND(AVG(nitrogen), 2) as avg_nitrogen,
  ROUND(AVG(phosphorus), 2) as avg_phosphorus,
  ROUND(AVG(potassium), 2) as avg_potassium,
  SUM(CASE WHEN nitrogen < 20 THEN 1 ELSE 0 END) as nitrogen_deficient_count
FROM soil_test
WHERE test_date >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -1)
  AND test_date < TRUNC(SYSDATE, 'MM')
GROUP BY TO_CHAR(test_date, 'YYYY-MM');
```

### 2. Regional Soil Health Comparison Report

**Purpose:** Compare soil health across different geographic regions

**Required Metrics:**
- Test counts by location
- Average nutrient levels by location
- Deficiency rates by location
- Most recommended fertilizers by region

**Format:** Interactive dashboard with drill-down capability

**Frequency:** Quarterly

**Recipients:** Policy makers, agricultural planners

### 3. Farmer Test History Report

**Purpose:** Individual farmer's soil testing history and trends

**Required Metrics:**
- All test dates and results
- Nutrient level trends over time
- Recommendations received
- Time between tests

**Format:** PDF export per farmer

**Frequency:** On-demand

**Recipients:** Individual farmers, extension officers

### 4. Fertilizer Usage Analytics Report

**Purpose:** Analyze fertilizer recommendation patterns

**Required Metrics:**
- Top 10 most recommended fertilizers
- Recommendation counts by fertilizer type
- Average recommended amounts
- Seasonal patterns in recommendations

**Format:** Excel with pivot tables

**Frequency:** Quarterly

**Recipients:** Fertilizer suppliers, agronomists

### 5. System Usage and Performance Report

**Purpose:** Monitor system adoption and operational efficiency

**Required Metrics:**
- Total system users (lab users)
- Tests processed per user
- Average turnaround time for recommendations
- Error rates from audit log
- Peak usage times

**Format:** Dashboard with real-time updates

**Frequency:** Real-time/Daily

**Recipients:** System administrators, IT staff

### 6. Audit and Compliance Report

**Purpose:** Track all system activities for compliance and security

**Required Metrics:**
- All operations by user
- Failed operations and error messages
- Data modification history
- Access patterns

**Format:** Detailed audit trail export

**Frequency:** Monthly (retained for 7 years)

**Recipients:** Compliance officers, auditors

---

## Analytics Requirements

### 1. Trend Analysis

**Nutrient Level Trends Over Time:**
```sql
-- Track how average nutrient levels change month-over-month
SELECT 
  TO_CHAR(test_date, 'YYYY-MM') as month,
  AVG(nitrogen) as avg_n,
  AVG(phosphorus) as avg_p,
  AVG(potassium) as avg_k,
  COUNT(*) as test_count
FROM soil_test
WHERE test_date >= ADD_MONTHS(SYSDATE, -12)
GROUP BY TO_CHAR(test_date, 'YYYY-MM')
ORDER BY month;
```

**Regional Trend Comparison:**
```sql
-- Compare nutrient trends across regions
SELECT 
  f.location,
  TO_CHAR(s.test_date, 'YYYY-Q') as quarter,
  AVG(s.nitrogen) as avg_nitrogen
FROM soil_test s
JOIN farmer f ON s.farmer_id = f.farmer_id
WHERE s.test_date >= ADD_MONTHS(SYSDATE, -24)
GROUP BY f.location, TO_CHAR(s.test_date, 'YYYY-Q')
ORDER BY location, quarter;
```

### 2. Predictive Analytics

**Soil Degradation Risk:**
- Identify farmers with declining nutrient levels
- Predict which locations may need intervention
- Forecast fertilizer demand

**Recommendation Needed:**
```sql
-- Farmers due for testing (>6 months since last test)
SELECT 
  f.farmer_id,
  f.farm_name,
  f.location,
  MAX(s.test_date) as last_test_date,
  TRUNC(SYSDATE - MAX(s.test_date)) as days_since_test
FROM farmer f
JOIN soil_test s ON f.farmer_id = s.farmer_id
GROUP BY f.farmer_id, f.farm_name, f.location
HAVING MAX(s.test_date) < ADD_MONTHS(SYSDATE, -6)
ORDER BY days_since_test DESC;
```

### 3. Comparative Analysis

**Before/After Recommendation Effectiveness:**
```sql
-- Compare soil tests before and after recommendations
WITH test_pairs AS (
  SELECT 
    s1.farmer_id,
    s1.soil_id as first_test,
    s1.nitrogen as n_before,
    s1.test_date as date_before,
    s2.soil_id as second_test,
    s2.nitrogen as n_after,
    s2.test_date as date_after,
    s2.test_date - s1.test_date as days_between
  FROM soil_test s1
  JOIN soil_test s2 ON s1.farmer_id = s2.farmer_id
  WHERE s2.test_date > s1.test_date
    AND s2.test_date <= s1.test_date + 180  -- Within 6 months
)
SELECT 
  farmer_id,
  AVG(n_after - n_before) as avg_nitrogen_change,
  AVG(days_between) as avg_days_between_tests
FROM test_pairs
GROUP BY farmer_id;
```

### 4. Statistical Analysis

**Deficiency Distribution:**
```sql
-- Statistical distribution of nutrient levels
SELECT 
  'Nitrogen' as nutrient,
  MIN(nitrogen) as min_level,
  PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY nitrogen) as q1,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY nitrogen) as median,
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY nitrogen) as q3,
  MAX(nitrogen) as max_level,
  STDDEV(nitrogen) as std_dev
FROM soil_test
UNION ALL
SELECT 
  'Phosphorus',
  MIN(phosphorus), 
  PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY phosphorus),
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY phosphorus),
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY phosphorus),
  MAX(phosphorus),
  STDDEV(phosphorus)
FROM soil_test
UNION ALL
SELECT 
  'Potassium',
  MIN(potassium),
  PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY potassium),
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY potassium),
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY potassium),
  MAX(potassium),
  STDDEV(potassium)
FROM soil_test;
```

### 5. Segmentation Analysis

**Farmer Segmentation:**
- **High-Risk Farms:** Multiple severe deficiencies
- **Moderate-Risk Farms:** Single nutrient deficiency
- **Low-Risk Farms:** Balanced nutrients
- **Inactive Farms:** No recent tests

```sql
-- Segment farmers by soil health status
SELECT 
  f.farmer_id,
  f.farm_name,
  f.location,
  s.nitrogen,
  s.phosphorus,
  s.potassium,
  CASE 
    WHEN s.nitrogen < 20 AND s.phosphorus < 15 AND s.potassium < 20 
      THEN 'High Risk - Multiple Deficiencies'
    WHEN s.nitrogen < 20 OR s.phosphorus < 15 OR s.potassium < 20 
      THEN 'Moderate Risk - Single Deficiency'
    ELSE 'Low Risk - Balanced Nutrients'
  END as risk_category
FROM farmer f
JOIN soil_test s ON f.farmer_id = s.farmer_id
WHERE s.test_date = (
  SELECT MAX(test_date) 
  FROM soil_test 
  WHERE farmer_id = f.farmer_id
);
```

---

## KPI Requirements

### Key Performance Indicators (KPIs)

#### 1. Soil Health KPIs

**1.1 Average Nutrient Deficiency Rate**
- **Formula:** (Tests with deficiencies / Total tests) × 100
- **Target:** < 40%
- **Measured:** Monthly
- **Purpose:** Track overall soil health improvement

**1.2 Critical Deficiency Rate**
- **Formula:** (Tests with N<10 OR P<10 OR K<10) / Total tests × 100
- **Target:** < 10%
- **Measured:** Monthly
- **Purpose:** Identify urgent intervention needs

#### 2. Operational KPIs

**2.1 Average Recommendation Turnaround Time**
- **Formula:** AVG(rec_date - test_date) in days
- **Target:** < 2 days
- **Measured:** Daily
- **Purpose:** Ensure timely service delivery

**2.2 System Uptime**
- **Formula:** (Successful operations / Total operations) × 100
- **Target:** > 99%
- **Measured:** Real-time
- **Purpose:** Monitor system reliability

**2.3 Tests Per Lab User**
- **Formula:** Total tests / Number of active lab users
- **Target:** > 50 tests/user/month
- **Measured:** Monthly
- **Purpose:** Track user productivity

#### 3. Adoption KPIs

**3.1 Active Farmers Rate**
- **Formula:** Farmers with tests in last 6 months / Total farmers × 100
- **Target:** > 70%
- **Measured:** Monthly
- **Purpose:** Track farmer engagement

**3.2 Repeat Testing Rate**
- **Formula:** Farmers with 2+ tests / Total farmers × 100
- **Target:** > 50%
- **Measured:** Quarterly
- **Purpose:** Measure recommendation implementation

**3.3 New Farmer Acquisition Rate**
- **Formula:** New farmers this month / Total farmers last month × 100
- **Target:** > 5% growth monthly
- **Measured:** Monthly
- **Purpose:** Track system expansion

#### 4. Quality KPIs

**4.1 Recommendation Approval Rate**
- **Formula:** Recommendations with approved_by / Total recommendations × 100
- **Target:** 100%
- **Measured:** Weekly
- **Purpose:** Ensure quality control

**4.2 Data Completeness Rate**
- **Formula:** Complete records / Total records × 100
- **Target:** > 95%
- **Measured:** Daily
- **Purpose:** Ensure data quality

---

## Stakeholder Requirements

### 1. Lab Administrators

**Needs:**
- Real-time system usage dashboard
- User productivity metrics
- Error and failure monitoring
- Capacity planning data

**Delivery:**
- Live dashboard updated hourly
- Weekly email summary
- Alerts for system issues

### 2. Agronomists

**Needs:**
- Nutrient trend analysis
- Recommendation effectiveness data
- Regional soil health comparisons
- Fertilizer usage patterns

**Delivery:**
- Monthly analytical reports
- Interactive dashboards
- On-demand custom queries

### 3. Farmers

**Needs:**
- Personal test history
- Nutrient trend charts
- Clear recommendations
- Comparison to regional averages

**Delivery:**
- Printed test result reports
- Simple visualizations
- SMS alerts for recommendations

### 4. Policy Makers

**Needs:**
- High-level soil health trends
- Geographic distribution of issues
- Resource allocation insights
- Long-term agricultural planning data

**Delivery:**
- Quarterly executive summaries
- Annual comprehensive reports
- Interactive regional maps

### 5. IT/Database Administrators

**Needs:**
- System performance metrics
- Database growth projections
- Error logs and debugging info
- Security and audit trails

**Delivery:**
- Real-time monitoring dashboards
- Automated alerts
- Detailed audit logs

---

## Technical Requirements

### Data Warehouse Considerations

**For advanced BI, consider:**
1. **OLAP Cube** for multidimensional analysis
2. **Data Mart** for aggregated historical data
3. **ETL Process** for data transformation

### BI Tool Integration

**Recommended Tools:**
- **Oracle APEX** - Built-in Oracle dashboard solution
- **Tableau** - Advanced visualization
- **Power BI** - Microsoft ecosystem integration
- **Oracle Analytics Cloud** - Cloud-based solution

### Real-Time vs. Batch Processing

**Real-Time Analytics (Live Dashboard):**
- Current day's test counts
- Active users
- System status
- Recent errors

**Batch Processing (Scheduled Reports):**
- Historical trend analysis
- Complex aggregations
- Statistical calculations
- Large dataset queries

### Data Refresh Frequency

| Data Type | Refresh Rate | Method |
|-----------|-------------|--------|
| Operational Metrics | Real-time | Materialized view with refresh on commit |
| Daily Summaries | Nightly | Scheduled job at 2 AM |
| Monthly Reports | Monthly | Scheduled job on 1st of month |
| Audit Data | Real-time | Trigger-based insert |

---

## Implementation Priority

### Phase 1 (Immediate - Months 1-3)
1. ✅ Basic reporting queries
2. ✅ Monthly summary report
3. ✅ Audit log monitoring
4. ✅ Core KPI tracking

### Phase 2 (Short-term - Months 4-6)
1. Interactive dashboards
2. Regional comparison reports
3. Trend analysis views
4. Automated email reports

### Phase 3 (Medium-term - Months 7-12)
1. Predictive analytics
2. Advanced segmentation
3. Mobile dashboard access
4. API for third-party BI tools

### Phase 4 (Long-term - Year 2+)
1. Machine learning for recommendations
2. Real-time alerting system
3. Integration with weather data
4. Crop yield correlation analysis

---

**BI Requirements Version:** 1.0  
**Last Updated:** December 2025  
**Maintained By:** Isimbi Mushimire Iris (ID: 27121)