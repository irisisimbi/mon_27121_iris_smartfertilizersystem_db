# Smart Fertilizer Recommendation System

**Category:** Agriculture  
**Student Name:** Isimbi Mushimire Iris  
**Student ID:** 27121

---

## Table of Contents
- [Project Overview](#project-overview)
- [Problem Statement](#problem-statement)
- [Key Objectives](#key-objectives)
- [Innovation & Improvements](#innovation--improvements)
- [Repository Structure](#repository-structure)
- [Quick Start Instructions](#quick-start-instructions)
- [Documentation](#documentation)
- [Screenshots](#screenshots)
- [Database Objects](#database-objects)
- [Business Intelligence](#business-intelligence)

---

## Project Overview

The **Smart Fertilizer Recommendation System** is a comprehensive **PL/SQL-based application** designed to help farmers make informed, data-driven decisions about fertilizer use. The system analyzes soil nutrient content focusing on three essential macronutrients for crop growth:

- **Nitrogen (N)** - Essential for leaf and stem growth
- **Phosphorus (P)** - Critical for root development and flowering
- **Potassium (K)** - Important for overall plant health and disease resistance

This intelligent system provides automated fertilizer recommendations based on real-time soil test results, eliminating guesswork and optimizing agricultural productivity.

### Key Features:
- Automated soil nutrient analysis
- Real-time fertilizer recommendations
- Audit logging for all operations
- Analytics and reporting capabilities
- Scalable architecture for future enhancements

---

## Problem Statement

Farmers face significant challenges in determining the correct fertilizer type and amount for their crops. Incorrect fertilization leads to reduced crop yields, wasted resources, increased costs, and environmental damage from soil nutrient imbalances. This system addresses these challenges by automating fertilizer recommendations based on scientific soil analysis, ensuring optimal crop productivity while minimizing waste and environmental impact.

---

## Key Objectives

1. **Analyze Soil Composition:** Evaluate soil nutrient content (N, P, K) based on laboratory test results
2. **Provide Intelligent Recommendations:** Generate precise fertilizer suggestions tailored to soil conditions
3. **Automate Decision-Making:** Eliminate manual calculations and reduce human error
4. **Optimize Resource Usage:** Minimize fertilizer waste and reduce agricultural costs
5. **Enable Data-Driven Insights:** Provide analytics for long-term soil health monitoring
6. **Ensure Scalability:** Design system to accommodate additional nutrients and crop types

---

## Innovation & Improvements

Unlike traditional methods relying on farmer experience or manual calculations, this system introduces:

- **Automated Intelligence:** AI-driven recommendations reduce errors and save valuable time
- **Resource Optimization:** Precise calculations ensure correct fertilizer type and quantity
- **Enhanced Productivity:** Maintains balanced soil nutrients for maximum crop yields
- **Audit Trail:** Complete logging of all recommendations for compliance and analysis
- **Business Intelligence:** Advanced analytics and KPI tracking for agricultural insights
- **Scalable Design:** Modular architecture easily expandable to include more nutrients, crops, and features

---

## Repository Structure

```
mon_27121_iris_smartfertilizersystem_db/
│
├── README.md
│
├── database/
│   ├── scripts/
│   │   ├── create_tables.sql
│   │   ├── insert_sample_data.sql
│   │   ├── soil_test_procedures.sql
│   │   ├── fertilizer_recommendation_logic.sql
│   │   ├── triggers.sql
│   │   ├── packages.sql
│   │   └── views.sql
│   │
│   ├── documentation/
│   │   ├── data_dictionary.md
│   │   ├── schema_design.md
│   │   ├── architecture_overview.md
│   │   └── design_decisions.md
│   │
│   └── readme_database.md
│
├── queries/
│   ├── data_retrieval.sql
│   ├── analytics_queries.sql
│   └── audit_queries.sql
│
├── reports/
│   ├── test_results/
│   │   ├── procedure_test_log.md
│   │   ├── trigger_test_log.md
│   │   └── data_validation_log.md
│   │
│   ├── error_logs/
│   │   └── debug_notes.md
│   │
│   └── performance_notes.md
│
├── bi/
│   ├── bi_requirements.md
│   ├── kpi_definitions.md
│   ├── powerbi_model_description.md
│   ├── dashboards.md
│   └── relationships_diagram.png
│
├── screenshots/
│   ├── diagrams/
│   │   ├── erd.png
│   │   ├── schema_diagram.png
│   │   └── flowchart.png
│   │
│   ├── sql_developer/
│   │   ├── table_view.png
│   │   ├── constraints_view.png
│   │   ├── sql_tab.png
│   │   └── procedure_output.png
│   │
│   └── test_outputs/
│       ├── insert_results.png
│       ├── procedure_run.png
│       └── trigger_results.png
│
└── .gitignore

---

## Quick Start Instructions

### Prerequisites
- Oracle Database 11g or higher
- SQL Developer or SQL*Plus
- Basic understanding of PL/SQL

### Setup Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/irisisimbi/mon_27121_iris_smartfertilizersystem_db.git
   cd smart-fertilizer-system
   ```

2. **Set Up Oracle Database**
   - Open Oracle SQL Developer
   - Connect to your database instance
   - Ensure you have CREATE privileges

3. **Execute Database Scripts** (in order)
   ```sql
   -- Navigate to database/scripts/ directory
   
   -- Step 1: Create tables
   @create_tables.sql  
   
   -- Step 2: Insert sample data
   @insert_data.sql
   
   -- Step 3: Create procedures
   @procedures.sql
   
   -- Step 4: Create functions
   @functions.sql
   
   -- Step 5: Create triggers
   @triggers.sql
   
   -- Step 6: Create packages
   @packages.sql
   ```

4. **Verify Installation**
   ```sql
   -- Check tables
   SELECT table_name FROM user_tables;
   
   -- Check procedures
   SELECT object_name FROM user_procedures;
   
   -- Test recommendation system
   EXEC recommend_fertilizer(soil_id => 1);
   ```

5. **Run Sample Queries**
   - Navigate to `queries/` directory
   - Execute analytical queries to explore the data

---

## Documentation

### Database Documentation
- **[Data Dictionary](documentation/data_dictionary.md)** - Complete table and column definitions
- **[Architecture](documentation/architecture.md)** - System design and data flow

### User Documentation
- **[User Guide](documentation/user_guide.md)** - How to use the system
- **[Technical Specifications](documentation/technical_specifications.md)** - Detailed technical documentation

### Query Scripts

**Data retrival**
**[Data retrival](/queries/data_retrieval.sql)**

**Analytics Queries**
**[Analytics queries](/queries/analytics_queries.sql)**

Audit Queries
**[Audit queries](/queries/audit_queries.sql)**


---

## Screenshots

### Database Creation
![Database Creation](./screenshots/photo2.png)

### Tablespace Configuration
![Tablespace Configuration](./screenshots/photo3.png)

### Alter Table
![Alter Table](./screenshots/photo4.png)


### Logical Model Design
![ER Diagram](./screenshots/er1_diagram.png)![ER Diagram](./screenshots/er2_diagram.png)



### Business Process Model

![Database Structure Lucidchart](./screenshots/Lucidchart.png)


### Procedures and Triggers

![Procedures in Editor](./screenshots/procedure_soil_test.png)

![Procedures in Editor](./screenshots/update_stock.png)

![Triggers in Editor](./screenshots/trigger_emp_restrict.png)

![Triggers in Editor](./screenshots/trigger_emp_comp.png)


### Test Results

![Test Execution](./screenshots/test_allowed.png)

![Test Execution](./screenshots/count_test_by_farmer_procedure.png)

![Test Execution](./screenshots/test_soil.png)


### Recommendations

![Recommendation Output](./screenshots/recommendation_procedure.png)

![Recommendation Output](./screenshots/recommendation_log.png)



View all test results: **[Test Results Gallery]**

![Test Execution](./screenshots/test1.png)

![Test Execution](./screenshots/test2.png)

![Test Execution](./screenshots/test3.png)

![Test Execution](./screenshots/test4.png)

![Test Execution](./screenshots/test5.png)

![Test Execution](./screenshots/test6.png)

![Test Execution](./screenshots/test7.png)

![Test Execution](./screenshots/test8.png)

![Test Execution](./screenshots/test9.png)

![Test Execution](./screenshots/test10.png)

### Selections

![Selection](./screenshots/selection.png)

![Selection](./screenshots/selection1.png)

### Audit Logs

![Audit Log Entries](./screenshots/audit_attemps.png)

![Audit Log Entries](./screenshots/log_audit.png)

### OEM Monitoring

![OEM Dashboard](./screenshots/dashboard.png)

![Dashboard](./screenshots/dashboard2_1.png)
![Dashboard](./screenshots/dashboard2_2.png)



---

## Database Objects

### Tables
- **SOIL_SAMPLES** - Stores soil test data with nutrient levels
- **FERTILIZER_RECOMMENDATIONS** - Stores generated recommendations
- **AUDIT_LOG** - Tracks all system operations
- **FARMERS** - Farmer information and contact details
- **CROPS** - Crop types and nutrient requirements

Full table definitions: **[Create Tables](sql/create_tables.sql)**

![Farmer Table](./screenshots/farmer.png)

![Lab User Table](./screenshots/lab_user.png)

![Soil Test Table](./screenshots/soil_test.png)

![Fertilizer Table](./screenshots/fertilizer.png)

![Recommendation Table](./screenshots/recommandation.png)


### Procedures
- `RECOMMEND_FERTILIZER` - Main recommendation engine
- `UPDATE_SOIL_STATUS` - Updates soil sample status
- `GENERATE_REPORT` - Creates comprehensive reports

Full procedure documentation:**[Procedures](sql/procedures.sql)**
                          
### Functions
- `CALCULATE_NUTRIENT_DEFICIT` - Calculates nutrient shortfall
- `GET_FERTILIZER_TYPE` - Determines optimal fertilizer type
- `VALIDATE_NUTRIENT_LEVELS` - Validates input data

Full function documentation: **[Functions](sql/functions.sql)**

![Function](./screenshots/function1.png)

![Function](./screenshots/function2.png)

![Function](./screenshots/check_restrictions.png)

### Triggers
- `TRG_AUDIT_SOIL_INSERT` - Logs soil sample insertions
- `TRG_AUDIT_RECOMMENDATION` - Logs recommendations
- `TRG_UPDATE_TIMESTAMP` - Maintains last modified timestamps

Full trigger documentation: **[Triggers](sql/triggers.sql)**
 
 ### Attempts
 ![Public attempt allowed](./screenshots/public_test.png)

 ![Public attempt denied](./screenshots/publicholiday_denied.png)

![ Test Denied](./screenshots/denied_test.png)

![ Test Allowed](./screenshots/test_allowed.png)


### Packages
- `PKG_FERTILIZER_ANALYTICS` - Advanced analytics package
- `PKG_SOIL_MANAGEMENT` - Soil data management utilities

Full package documentation: **[Packages](sql/packages.sql)**

![Packages](./screenshots/package1.png)

![Packages](./screenshots/package2.png)

---

## Business Intelligence

### BI Requirements
Comprehensive business intelligence requirements and analysis needs.

**[View BI Requirements](documentation/bi_requirements.md)**

### Dashboards
Dashboard specifications for agricultural insights and monitoring.

**[View Dashboard Specifications](documentation/dashboards.md)**

### Key Performance Indicators (KPIs)
- Average nutrient deficiency rates
- Fertilizer recommendation accuracy
- Cost savings per recommendation
- Crop yield improvements
- System usage metrics

---

## Contributing

If you'd like to contribute to this project:
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

---

## License

This project is developed as part of an academic assignment for PL/SQL Database Programming.

---

## Contact

**Isimbi Mushimire Iris**  
Student ID: 27121  
Email: [isimbiiris@gmail.com]

---

## Acknowledgments

- Oracle Database Documentation
- Agricultural Soil Science Research
- Database Design Best Practices

---

**Last Updated:** December 2025

