# Dashboard Specifications

## Smart Fertilizer Recommendation System

This document provides detailed specifications for all dashboards in the Smart Fertilizer Recommendation System.

---

## Dashboard Overview

### Purpose
Provide real-time, actionable insights to different stakeholders through interactive, role-based dashboards.

### Design Principles
- **Simple & Intuitive:** Easy to understand at a glance
- **Interactive:** Drill-down capabilities for detailed analysis
- **Real-Time:** Live data updates for operational dashboards
- **Mobile-Friendly:** Responsive design for tablet/phone access
- **Role-Based:** Customized views for different user types

### Dashboard Access Matrix

| Dashboard | Lab Admin | Agronomist | Farmer | Policy Maker |
|-----------|-----------|------------|--------|--------------|
| Executive Overview | ✅ | ✅ | ❌ | ✅ |
| Soil Health Monitoring | ✅ | ✅ | ✅ (Own data) | ✅ |
| Regional Analysis | ✅ | ✅ | ❌ | ✅ |
| Operational Performance | ✅ | ✅ | ❌ | ❌ |
| Fertilizer Analytics | ✅ | ✅ | ❌ | ✅ |
| Farmer Engagement | ✅ | ✅ | ❌ | ✅ |
| System Audit | ✅ | ❌ | ❌ | ❌ |

---

## Dashboard 1: Executive Overview

### Purpose
High-level snapshot of system performance and soil health for decision-makers.

### Target Audience
- Lab Administrators
- Policy Makers
- Senior Agronomists

### Layout

```
┌─────────────────────────────────────────────────────────────┐
│  SMART FERTILIZER SYSTEM - EXECUTIVE OVERVIEW               │
│  Last Updated: [Real-time timestamp]                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │  Tests   │  │  Farmers │  │  Average │  │  Critical│  │
│  │  This    │  │  Active  │  │  Defic.  │  │  Issues  │  │
│  │  Month   │  │  This    │  │  Rate    │  │  Pending │  │
│  │          │  │  Month   │  │          │  │          │  │
│  │   850    │  │   342    │  │   35%    │  │    12    │  │
│  │  +15%↑   │  │  +8%↑    │  │  -5%↓    │  │   HIGH   │  │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘  │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐  │
│  │  Soil Health Trend (Last 12 Months)                 │  │
│  │  [Line Chart: Avg N, P, K levels over time]         │  │
│  │                                                      │  │
│  └─────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌────────────────────┐  ┌────────────────────────────┐  │
│  │  Top 5 Regions by  │  │  Nutrient Deficiency Mix   │  │
│  │  Test Volume       │  │  [Pie Chart]               │  │
│  │  [Bar Chart]       │  │  - Nitrogen: 45%           │  │
│  │                    │  │  - Phosphorus: 30%         │  │
│  │                    │  │  - Potassium: 25%          │  │
│  └────────────────────┘  └────────────────────────────┘  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Key Metrics (KPI Cards)

**1. Tests This Month**
```sql
SELECT COUNT(*) as test_count,
       ROUND(((COUNT(*) - prev_month.cnt) / prev_month.cnt) * 100, 1) as pct_change
FROM soil_test
WHERE test_date >= TRUNC(SYSDATE, 'MM')
CROSS JOIN (
  SELECT COUNT(*) as cnt 
  FROM soil_test 
  WHERE test_date >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -1)
    AND test_date < TRUNC(SYSDATE, 'MM')
) prev_month;
```

**2. Active Farmers This Month**
```sql
SELECT COUNT(DISTINCT farmer_id) as active_farmers
FROM soil_test
WHERE test_date >= TRUNC(SYSDATE, 'MM');
```

**3. Average Deficiency Rate**
```sql
SELECT ROUND(
  (SUM(CASE WHEN nitrogen < 20 OR phosphorus < 15 OR potassium < 20 
       THEN 1 ELSE 0 END) / COUNT(*)) * 100, 1
) as deficiency_rate
FROM soil_test
WHERE test_date >= TRUNC(SYSDATE, 'MM');
```

**4. Critical Issues Pending**
```sql
SELECT COUNT(*) as critical_count
FROM soil_test s
LEFT JOIN recommendation r ON s.soil_id = r.soil_id
WHERE s.test_date >= SYSDATE - 7
  AND (s.nitrogen < 10 OR s.phosphorus < 10 OR s.potassium < 10)
  AND r.rec_id IS NULL;  -- No recommendation yet
```

### Visualizations

**1. Soil Health Trend (Line Chart)**
- **X-Axis:** Month (last 12 months)
- **Y-Axis:** Average nutrient level
- **Lines:** 3 lines for N, P, K
- **Colors:** Green (Nitrogen), Orange (Phosphorus), Blue (Potassium)

**2. Top 5 Regions by Test Volume (Bar Chart)**
- **X-Axis:** Location
- **Y-Axis:** Number of tests
- **Interactive:** Click to drill down to region details

**3. Nutrient Deficiency Mix (Pie Chart)**
- Shows distribution of deficiencies
- Interactive segments

### Refresh Rate
- **Real-time** (updates every 5 minutes)

### Filters
- Date range selector (default: current month)
- Region filter (multi-select)

---

## Dashboard 2: Soil Health Monitoring

### Purpose
Detailed monitoring of soil nutrient levels and health indicators.

### Target Audience
- Agronomists
- Lab Technicians
- Farmers (limited to own data)

### Layout

```
┌─────────────────────────────────────────────────────────────┐
│  SOIL HEALTH MONITORING DASHBOARD                           │
├─────────────────────────────────────────────────────────────┤
│  Filters: [Date Range▼] [Location▼] [Farmer▼]             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐  │
│  │  Nutrient Level Distribution                        │  │
│  │  [Box Plot showing N, P, K distributions]           │  │
│  │  - Shows min, Q1, median, Q3, max for each         │  │
│  │  - Outliers marked                                  │  │
│  └─────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌────────────────────┐  ┌────────────────────────────┐  │
│  │  Nitrogen Status   │  │  Phosphorus Status         │  │
│  │  [Gauge Chart]     │  │  [Gauge Chart]             │  │
│  │  Current: 22.5     │  │  Current: 18.3             │  │
│  │  Status: Moderate  │  │  Status: Moderate          │  │
│  └────────────────────┘  └────────────────────────────┘  │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐  │
│  │  Deficiency Heat Map by Location                    │  │
│  │  [Geographic Heat Map]                              │  │
│  │  - Red: High deficiency (>50% of tests)            │  │
│  │  - Yellow: Moderate (25-50%)                       │  │
│  │  - Green: Low (<25%)                               │  │
│  └─────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐  │
│  │  Recent Test Results Table                          │  │
│  │  [Sortable, Filterable Data Grid]                  │  │
│  │  Farm | Date | N | P | K | Status | Actions        │  │
│  └─────────────────────────────────────────────────────┘  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Key Visualizations

**1. Nutrient Level Distribution (Box Plot)**
```sql
-- Data for box plot
SELECT 
  'Nitrogen' as nutrient,
  MIN(nitrogen) as min_val,
  PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY nitrogen) as q1,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY nitrogen) as median,
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY nitrogen) as q3,
  MAX(nitrogen) as max_val
FROM soil_test
WHERE test_date >= ADD_MONTHS(SYSDATE, -3)
UNION ALL
SELECT 'Phosphorus', MIN(phosphorus), 
  PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY phosphorus),
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY phosphorus),
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY phosphorus),
  MAX(phosphorus)
FROM soil_test
WHERE test_date >= ADD_MONTHS(SYSDATE, -3)
UNION ALL
SELECT 'Potassium', MIN(potassium),
  PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY potassium),
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY potassium),
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY potassium),
  MAX(potassium)
FROM soil_test
WHERE test_date >= ADD_MONTHS(SYSDATE, -3);
```

**2. Nutrient Status Gauges**
- Shows current average levels
- Color-coded zones:
  - Red (0-15): Critical
  - Yellow (15-25): Moderate
  - Green (25+): Good

**3. Deficiency Heat Map**
```sql
-- Deficiency rate by location
SELECT 
  f.location,
  COUNT(*) as total_tests,
  ROUND((SUM(CASE WHEN s.nitrogen < 20 OR s.phosphorus < 15 OR s.potassium < 20 
              THEN 1 ELSE 0 END) / COUNT(*)) * 100, 1) as deficiency_rate
FROM soil_test s
JOIN farmer f ON s.farmer_id = f.farmer_id
WHERE s.test_date >= ADD_MONTHS(SYSDATE, -6)
GROUP BY f.location
HAVING COUNT(*) >= 5  -- At least 5 tests for statistical relevance
ORDER BY deficiency_rate DESC;
```

**4. Recent Test Results Table**
```sql
SELECT 
  f.farm_name,
  s.test_date,
  s.nitrogen,
  s.phosphorus,
  s.potassium,
  CASE 
    WHEN s.nitrogen < 20 OR s.phosphorus < 15 OR s.potassium < 20 
      THEN 'Deficient'
    ELSE 'Adequate'
  END as status
FROM soil_test s
JOIN farmer f ON s.farmer_id = f.farmer_id
ORDER BY s.test_date DESC
FETCH FIRST 50 ROWS ONLY;
```

### Interactive Features
- Click on location in heat map to see detailed test results
- Click on table row to view full recommendation
- Export table data to Excel/PDF

### Refresh Rate
- **Every 15 minutes**

---

## Dashboard 3: Regional Analysis

### Purpose
Compare soil health metrics across different geographic regions.

### Target Audience
- Policy Makers
- Agricultural Planners
- Extension Officers

### Layout

```
┌─────────────────────────────────────────────────────────────┐
│  REGIONAL SOIL HEALTH ANALYSIS                              │
├─────────────────────────────────────────────────────────────┤
│  Select Regions to Compare: [Multi-select dropdown]        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐  │
│  │  Regional Test Volume Comparison                    │  │
│  │  [Horizontal Bar Chart]                             │  │
│  │  Kigali     ████████████████████ 450               │  │
│  │  Musanze    ███████████ 220                        │  │
│  │  Rubavu     ████████ 150                           │  │
│  └─────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐  │
│  │  Average Nutrient Levels by Region                  │  │
│  │  [Grouped Column Chart]                             │  │
│  │  - N, P, K levels side-by-side for each region     │  │
│  └─────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌────────────────────┐  ┌────────────────────────────┐  │
│  │  Deficiency Rates  │  │  Most Common Fertilizer    │  │
│  │  [Stacked Bar]     │  │  [Table by Region]         │  │
│  │  by Region         │  │                            │  │
│  └────────────────────┘  └────────────────────────────┘  │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐  │
│  │  Regional Performance Scorecard                     │  │
│  │  [Data Table]                                       │  │
│  │  Region | Tests | Avg N | Avg P | Avg K | Score    │  │
│  └─────────────────────────────────────────────────────┘  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Key Queries

**Regional Comparison Summary**
```sql
SELECT 
  f.location,
  COUNT(DISTINCT s.farmer_id) as unique_farmers,
  COUNT(*) as total_tests,
  ROUND(AVG(s.nitrogen), 2) as avg_nitrogen,
  ROUND(AVG(s.phosphorus), 2) as avg_phosphorus,
  ROUND(AVG(s.potassium), 2) as avg_potassium,
  ROUND((SUM(CASE WHEN s.nitrogen < 20 THEN 1 ELSE 0 END) / COUNT(*)) * 100, 1) as n_deficiency_pct,
  ROUND((SUM(CASE WHEN s.phosphorus < 15 THEN 1 ELSE 0 END) / COUNT(*)) * 100, 1) as p_deficiency_pct,
  ROUND((SUM(CASE WHEN s.potassium < 20 THEN 1 ELSE 0 END) / COUNT(*)) * 100, 1) as k_deficiency_pct
FROM soil_test s
JOIN farmer f ON s.farmer_id = f.farmer_id
WHERE s.test_date >= ADD_MONTHS(SYSDATE, -12)
GROUP BY f.location
ORDER BY total_tests DESC;
```

**Most Recommended Fertilizer by Region**
```sql
SELECT 
  f.location,
  fert.fertilizer_name,
  COUNT(*) as recommendation_count
FROM recommendation r
JOIN soil_test s ON r.soil_id = s.soil_id
JOIN farmer f ON s.farmer_id = f.farmer_id
JOIN fertilizer fert ON r.fertilizer_id = fert.fertilizer_id
WHERE r.rec_date >= ADD_MONTHS(SYSDATE, -6)
GROUP BY f.location, fert.fertilizer_name
ORDER BY f.location, recommendation_count DESC;
```

### Refresh Rate
- **Daily** (updated at midnight)

---

## Dashboard 4: Operational Performance

### Purpose
Monitor system operations, user productivity, and service quality.

### Target Audience
- Lab Administrators
- System Managers

### Layout

```
┌─────────────────────────────────────────────────────────────┐
│  OPERATIONAL PERFORMANCE DASHBOARD                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │  Avg      │  │  Tests   │  │  Success │  │  Pending │  │
│  │  Turn-    │  │  Today   │  │  Rate    │  │  Recomm. │  │
│  │  around   │  │          │  │          │  │          │  │
│  │  1.2 days │  │    42    │  │  99.2%   │  │     8    │  │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘  │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐  │
│  │  Test Volume Trend (Last 30 Days)                   │  │
│  │  [Area Chart]                                       │  │
│  └─────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌────────────────────┐  ┌────────────────────────────┐  │
│  │  Lab User          │  │  Recent System Activity    │  │
│  │  Productivity      │  │  [Timeline]                │  │
│  │  [Bar Chart]       │  │  - Test submissions        │  │
│  │  Tests per user    │  │  - Recommendations         │  │
│  └────────────────────┘  └────────────────────────────┘  │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐  │
│  │  Error Log Summary                                  │  │
│  │  [Table: Recent errors from audit_log]             │  │
│  └─────────────────────────────────────────────────────┘  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Key Metrics

**Average Turnaround Time**
```sql
SELECT ROUND(AVG(r.rec_date - s.test_date), 1) as avg_turnaround_days
FROM recommendation r
JOIN soil_test s ON r.soil_id = s.soil_id
WHERE r.rec_date >= SYSDATE - 30;
```

**Lab User Productivity**
```sql
SELECT 
  lu.username,
  COUNT(*) as tests_processed,
  ROUND(AVG(s.test_date), 1) as avg_daily_tests
FROM soil_test s
JOIN lab_user lu ON s.lab_user_id = lu.user_id
WHERE s.test_date >= SYSDATE - 30
GROUP BY lu.username
ORDER BY tests_processed DESC;
```

**Success Rate**
```sql
SELECT 
  ROUND((SUM(CASE WHEN status = 'SUCCESS' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) as success_rate
FROM audit_log
WHERE attempt_time >= SYSTIMESTAMP - INTERVAL '7' DAY;
```

### Refresh Rate
- **Real-time** (updates every 5 minutes)

---

## Dashboard 5: Fertilizer Analytics

### Purpose
Analyze fertilizer recommendation patterns and effectiveness.

### Target Audience
- Agronomists
- Fertilizer Suppliers
- Agricultural Planners

### Layout

```
┌─────────────────────────────────────────────────────────────┐
│  FERTILIZER RECOMMENDATION ANALYTICS                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐  │
│  │  Top 10 Most Recommended Fertilizers                │  │
│  │  [Horizontal Bar Chart]                             │  │
│  │  NPK 15-15-15  ██████████████████ 342              │  │
│  │  Urea 46-0-0   ███████████ 198                     │  │
│  │  DAP 18-46-0   █████████ 156                       │  │
│  └─────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌────────────────────┐  ┌────────────────────────────┐  │
│  │  Recommendations   │  │  Fertilizer Type           │  │
│  │  by Nutrient Type  │  │  Distribution              │  │
│  │  [Pie Chart]       │  │  [Donut Chart]             │  │
│  └────────────────────┘  └────────────────────────────┘  │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐  │
│  │  Seasonal Recommendation Trends                     │  │
│  │  [Stacked Area Chart]                               │  │
│  │  - Shows N, P, K recommendations over months       │  │
│  └─────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐  │
│  │  Fertilizer Effectiveness Analysis                  │  │
│  │  [Before/After Comparison Table]                   │  │
│  └─────────────────────────────────────────────────────┘  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Key Queries

**Top Recommended Fertilizers**
```sql
SELECT 
  f.fertilizer_name,
  f.nutrient_type,
  COUNT(*) as recommendation_count,
  ROUND(AVG(f.recommended_amount), 2) as avg_amount
FROM recommendation r
JOIN fertilizer f ON r.fertilizer_id = f.fertilizer_id
WHERE r.rec_date >= ADD_MONTHS(SYSDATE, -6)
GROUP BY f.fertilizer_name, f.nutrient_type
ORDER BY recommendation_count DESC
FETCH FIRST 10 ROWS ONLY;
```

**Recommendations by Nutrient Type**
```sql
SELECT 
  f.nutrient_type,
  COUNT(*) as count,
  ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER()), 1) as percentage
FROM recommendation r
JOIN fertilizer f ON r.fertilizer_id = f.fertilizer_id
WHERE r.rec_date >= ADD_MONTHS(SYSDATE, -3)
GROUP BY f.nutrient_type;
```

### Refresh Rate
- **Daily**

---

## Dashboard 6: Farmer Engagement

### Purpose
Track farmer adoption, retention, and satisfaction.

### Target Audience
- Extension Officers
- Marketing Team
- Management

### Key Metrics

**Active vs. Inactive Farmers**
```sql
SELECT 
  SUM(CASE WHEN last_test_date >= ADD_MONTHS(SYSDATE, -6) 
      THEN 1 ELSE 0 END) as active_farmers,
  SUM(CASE WHEN last_test_date < ADD_MONTHS(SYSDATE, -6) 
      THEN 1 ELSE 0 END) as inactive_farmers
FROM (
  SELECT farmer_id, MAX(test_date) as last_test_date
  FROM soil_test
  GROUP BY farmer_id
);
```

**Repeat Testing Rate**
```sql
SELECT 
  ROUND((SUM(CASE WHEN test_count >= 2 THEN 1 ELSE 0 END) / COUNT(*)) * 100, 1) as repeat_rate
FROM (
  SELECT farmer_id, COUNT(*) as test_count
  FROM soil_test
  GROUP BY farmer_id
);
```

### Refresh Rate
- **Daily**

---

## Dashboard 7: System Audit & Compliance

### Purpose
Monitor all system activities for security and compliance.

### Target Audience
- System Administrators
- Compliance Officers
- Auditors

### Key Features

**Recent Operations Log**
```sql
SELECT 
  username,
  operation,
  object_type,
  attempt_time,
  status,
  message
FROM audit_log
ORDER BY attempt_time DESC
FETCH FIRST 100 ROWS ONLY;
```

**Failed Operations**
```sql
SELECT 
  username,
  operation,
  object_type,
  COUNT(*) as failure_count,
  MAX(attempt_time) as last_failure
FROM audit_log
WHERE status = 'FAILURE'
  AND attempt_time >= SYSTIMESTAMP - INTERVAL '7' DAY
GROUP BY username, operation, object_type
ORDER BY failure_count DESC;
```

### Refresh Rate
- **Real-time**

---

## Technical Implementation

### Recommended Technology Stack

**Option 1: Oracle APEX**
- Native Oracle integration
- Rapid development
- Built-in security
- Mobile-responsive

**Option 2: Tableau**
- Advanced visualizations
- Easy integration with Oracle
- Interactive dashboards
- Sharing capabilities

**Option 3: Power BI**
- Microsoft ecosystem
- Good Oracle connectivity
- Rich visualizations
- Cloud-based option

### Performance Optimization

**Materialized Views for Dashboards:**
```sql
-- Create MV for dashboard metrics
CREATE MATERIALIZED VIEW mv_dashboard_metrics
REFRESH FAST ON COMMIT
AS
SELECT 
  TRUNC(test_date, 'MM') as month,
  COUNT(*) as test_count,
  AVG(nitrogen) as avg_n,
  AVG(phosphorus) as avg_p,
  AVG(potassium) as avg_k
FROM soil_test
GROUP BY TRUNC(test_date, 'MM');
```

### Mobile Considerations

- Responsive design (works on tablets/phones)
- Touch-friendly controls
- Simplified views for small screens
- Offline capability for field work

---

**Dashboard Specifications Version:** 1.0  
**Last Updated:** December 2025  
**Maintained By:** Isimbi Mushimire Iris (ID: 27121)