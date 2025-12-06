# System Architecture

## Smart Fertilizer Recommendation System

This document describes the overall system architecture, data flow, and technical design of the Smart Fertilizer Recommendation System.

---

## System Overview

The Smart Fertilizer Recommendation System is a database-driven application that provides intelligent fertilizer recommendations based on soil nutrient analysis. The system follows a three-tier architecture pattern:

1. **Data Layer** - Oracle Database with PL/SQL logic
2. **Business Logic Layer** - Stored procedures, functions, triggers, and packages
3. **Presentation Layer** - SQL Developer interface (with potential for future web/mobile interfaces)

### Key Components

- **Soil Testing Module** - Captures and stores soil nutrient data
- **Recommendation Engine** - Analyzes nutrients and generates fertilizer recommendations
- **Audit System** - Tracks all system operations for compliance
- **User Management** - Manages lab users and their roles
- **Farmer Management** - Maintains farmer and farm information

---

## Architecture Layers

### 1. Database Layer

**Purpose:** Persistent data storage and data integrity enforcement

**Components:**
- 7 normalized tables (farmer, lab_user, soil_test, fertilizer, recommendation, audit_log, holiday)
- Primary key constraints for uniqueness
- Foreign key constraints for referential integrity
- Check constraints for data validation
- Identity columns for auto-generated IDs

**Responsibilities:**
- Store all system data
- Enforce data integrity rules
- Maintain referential relationships
- Generate unique identifiers

### 2. Business Logic Layer

**Purpose:** Implement business rules and automate processes

**Components:**
- **Stored Procedures** - Complex operations like generating recommendations
- **Functions** - Reusable calculations and validations
- **Triggers** - Automatic logging and data validation
- **Packages** - Grouped related procedures and functions

**Responsibilities:**
- Calculate nutrient deficiencies
- Generate fertilizer recommendations
- Validate business rules
- Automate audit logging
- Prevent operations on holidays

### 3. Presentation Layer (Current)

**Purpose:** User interface for data entry and retrieval

**Components:**
- SQL Developer or SQL*Plus
- Direct SQL queries
- Procedure execution

**Future Enhancement:**
- Web-based interface
- Mobile application
- REST API for third-party integration

---

## Database Architecture

### Schema Design Principles

1. **Normalization**: Tables are normalized to 3NF to eliminate redundancy
2. **Referential Integrity**: Foreign keys maintain relationships between tables
3. **Data Validation**: Check constraints ensure data quality
4. **Audit Trail**: Separate audit_log table tracks all operations
5. **Identity Columns**: Auto-generated IDs prevent manual ID management

### Table Structure

```
┌─────────────────┐         ┌─────────────────┐
│    FARMER       │         │   LAB_USER      │
├─────────────────┤         ├─────────────────┤
│ farmer_id (PK)  │         │ user_id (PK)    │
│ farm_name       │         │ username        │
│ location        │         │ role            │
└────────┬────────┘         └────────┬────────┘
         │                           │
         │ (1:M)              (1:M)  │
         │                           │
         └───────────┬───────────────┘
                     │
              ┌──────▼──────────┐
              │   SOIL_TEST     │
              ├─────────────────┤
              │ soil_id (PK)    │
              │ farmer_id (FK)  │
              │ lab_user_id(FK) │
              │ nitrogen        │
              │ phosphorus      │
              │ potassium       │
              │ test_date       │
              └────────┬────────┘
                       │
                       │ (1:M)
                       │
              ┌────────▼────────────┐
              │  RECOMMENDATION     │
              ├─────────────────────┤
              │ rec_id (PK)         │
              │ soil_id (FK)        │
              │ fertilizer_id (FK)  │
              │ recommendation_text │
              │ rec_date            │
              │ approved_by         │
              └──────────┬──────────┘
                         │
                         │ (M:1)
                         │
              ┌──────────▼──────────┐
              │   FERTILIZER        │
              ├─────────────────────┤
              │ fertilizer_id (PK)  │
              │ fertilizer_name     │
              │ nutrient_type       │
              │ recommended_amount  │
              └─────────────────────┘

┌─────────────────┐         ┌─────────────────┐
│   AUDIT_LOG     │         │    HOLIDAY      │
├─────────────────┤         ├─────────────────┤
│ audit_id (PK)   │         │ holiday_id (PK) │
│ username        │         │ holiday_date    │
│ operation       │         │ description     │
│ object_type     │         └─────────────────┘
│ object_id       │
│ attempt_time    │
│ status          │
│ message         │
└─────────────────┘
```

---

## Data Flow

### 1. Soil Test Submission Flow

```
[Farmer] → [Lab User] → [Soil Test Entry]
                              ↓
                    ┌─────────────────┐
                    │  Insert Trigger │
                    │   (Audit Log)   │
                    └─────────────────┘
                              ↓
                    ┌─────────────────┐
                    │  SOIL_TEST      │
                    │  Table          │
                    └─────────────────┘
```

**Steps:**
1. Farmer brings soil sample to lab
2. Lab user enters test results (N, P, K values)
3. INSERT trigger automatically logs the operation to AUDIT_LOG
4. Data stored in SOIL_TEST table
5. test_date defaults to current date if not provided

### 2. Recommendation Generation Flow

```
[Soil Test Data] → [Recommendation Procedure]
                              ↓
                    ┌─────────────────┐
                    │ Analyze Nutrients│
                    │ N, P, K Levels  │
                    └─────────────────┘
                              ↓
                    ┌─────────────────┐
                    │ Query FERTILIZER│
                    │ Table           │
                    └─────────────────┘
                              ↓
                    ┌─────────────────┐
                    │ Generate        │
                    │ Recommendation  │
                    └─────────────────┘
                              ↓
                    ┌─────────────────┐
                    │ Insert into     │
                    │ RECOMMENDATION  │
                    └─────────────────┘
                              ↓
                    ┌─────────────────┐
                    │  Audit Trigger  │
                    │  Logs Action    │
                    └─────────────────┘
```

**Steps:**
1. Procedure receives soil_id as parameter
2. Retrieves N, P, K values from SOIL_TEST
3. Compares values against optimal thresholds
4. Queries FERTILIZER table for appropriate products
5. Generates recommendation text
6. Inserts record into RECOMMENDATION table
7. Trigger logs the recommendation to AUDIT_LOG

### 3. Audit Logging Flow

```
[Any Database Operation] → [Trigger Fires]
                                  ↓
                        ┌─────────────────┐
                        │ Capture Details:│
                        │ - Username      │
                        │ - Operation     │
                        │ - Object        │
                        │ - Timestamp     │
                        └─────────────────┘
                                  ↓
                        ┌─────────────────┐
                        │ Insert into     │
                        │ AUDIT_LOG       │
                        └─────────────────┘
```

**Logged Information:**
- Who performed the operation (username)
- What operation was performed (INSERT, UPDATE, DELETE)
- Which object was affected (table name, record ID)
- When it happened (timestamp with timezone)
- Result (SUCCESS or FAILURE)

---

## ER Diagram

### Entity Relationships

**One-to-Many Relationships:**
- FARMER (1) → SOIL_TEST (M)
- LAB_USER (1) → SOIL_TEST (M)
- SOIL_TEST (1) → RECOMMENDATION (M)
- FERTILIZER (1) → RECOMMENDATION (M)

**Independent Entities:**
- AUDIT_LOG (no foreign keys - references all tables)
- HOLIDAY (no foreign keys - used for business logic)

### Cardinality Rules

1. Each FARMER can have multiple SOIL_TESTS
2. Each LAB_USER can process multiple SOIL_TESTS
3. Each SOIL_TEST must have one FARMER and one LAB_USER
4. Each SOIL_TEST can have multiple RECOMMENDATIONS (over time)
5. Each RECOMMENDATION must reference one SOIL_TEST
6. Each RECOMMENDATION may reference one FERTILIZER (or none if soil is fertile)

---

## Technology Stack

### Database Management System
- **Oracle Database** 11g or higher
- Features used:
  - Identity columns (auto-increment)
  - Check constraints
  - Foreign key constraints
  - Triggers
  - Stored procedures and functions
  - Packages

### Programming Language
- **PL/SQL** - Oracle's procedural extension for SQL
- Used for:
  - Business logic implementation
  - Data validation
  - Automatic operations via triggers
  - Complex calculations

### Development Tools
- **SQL Developer** - Primary IDE for development
- **SQL*Plus** - Command-line interface (alternative)

### Future Technologies (Potential)
- **REST API** - For web/mobile integration
- **Java/Python** - Application layer
- **React/Angular** - Web interface
- **Android/iOS** - Mobile applications

---

## Security Architecture

### Authentication & Authorization

**Current Implementation:**
- LAB_USER table stores user information
- USERNAME must be unique
- ROLE field defines user permissions

**Audit Trail:**
- All operations logged to AUDIT_LOG
- Captures username, operation, timestamp
- Cannot be modified or deleted (enforced by triggers)

**Data Validation:**
- Check constraints prevent negative nutrient values
- Foreign keys prevent orphaned records
- NOT NULL constraints ensure required data

### Access Control (Recommended)

**Future Enhancements:**
1. Password encryption in LAB_USER table
2. Role-based access control (RBAC)
3. Procedure-level permissions
4. Row-level security for multi-tenant scenarios

### Compliance & Auditing

- Complete audit trail for regulatory compliance
- Timestamp with timezone for global operations
- Operation status tracking (SUCCESS/FAILURE)
- Detailed error messages for troubleshooting

---

## Performance Considerations

### Indexing Strategy

**Automatic Indexes:**
- Primary keys (automatically indexed)
- Unique constraints (automatically indexed)

**Recommended Additional Indexes:**
```sql
CREATE INDEX idx_soil_farmer ON soil_test(farmer_id);
CREATE INDEX idx_soil_date ON soil_test(test_date);
CREATE INDEX idx_rec_soil ON recommendation(soil_id);
CREATE INDEX idx_audit_time ON audit_log(attempt_time);
```

### Query Optimization

1. Use foreign key indexes for JOIN operations
2. Index frequently queried columns (dates, usernames)
3. Use bind variables in procedures
4. Limit result sets with WHERE clauses

### Scalability

**Current Capacity:**
- Supports thousands of farmers
- Handles multiple concurrent soil tests
- Unlimited audit history

**Future Scaling:**
- Partition AUDIT_LOG by date for large volumes
- Archive old soil tests (> 5 years)
- Implement connection pooling for web interface

---

## Integration Points

### Current State
- Standalone database system
- Manual data entry via SQL Developer
- Direct procedure execution

### Future Integration

**External Systems:**
- Laboratory equipment (automatic data import)
- Weather services (environmental factors)
- GIS systems (location-based analysis)
- E-commerce (fertilizer ordering)

**APIs to Develop:**
- POST /soil-test - Submit new test
- GET /recommendations/:soil_id - Get recommendations
- GET /farmers/:id/history - Farmer's test history
- GET /analytics/nutrient-trends - Analytics data

---

## Disaster Recovery

### Backup Strategy

**Recommended Approach:**
1. Daily full database backups
2. Transaction log backups (hourly)
3. Archive audit logs separately
4. Store backups off-site

### Recovery Procedures

1. **Point-in-Time Recovery** - Restore to specific timestamp
2. **Table Recovery** - Restore individual tables
3. **Audit Log Protection** - Separate backup for compliance

---

## System Maintenance

### Regular Tasks

**Daily:**
- Monitor audit log for errors
- Check system performance metrics

**Weekly:**
- Review recommendation accuracy
- Analyze nutrient trend reports

**Monthly:**
- Archive old audit logs
- Update fertilizer catalog
- Review user access permissions

**Annually:**
- Database health check
- Performance tuning
- Security audit

---

**Document Version:** 1.0  
**Last Updated:** December 2025  
**Maintained By:** Isimbi Mushimire Iris (ID: 27121)