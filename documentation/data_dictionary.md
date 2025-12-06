# Data Dictionary

## Smart Fertilizer Recommendation System

This document provides comprehensive details about all database tables, columns, data types, constraints, and their purposes.

---

## FARMER Table

Stores information about farmers who submit soil samples for testing.

| Column Name | Data Type | Constraints | Purpose |
|------------|-----------|-------------|---------|
| FARMER_ID | NUMBER | PK, IDENTITY, NOT NULL | Unique identifier for each farmer (auto-generated) |
| FARM_NAME | VARCHAR2(100) | NOT NULL | Name of the farm or farmer |
| LOCATION | VARCHAR2(100) | NULL | Geographic location of the farm |

**Primary Key:** FARMER_ID  
**Foreign Keys:** None  
**Indexes:** Primary key index on FARMER_ID

**Business Rules:**
- Each farmer must have a farm name
- Farmer IDs are automatically generated
- Location is optional but recommended for regional analysis

---

## LAB_USER Table

Stores information about laboratory users who process soil tests and generate recommendations.

| Column Name | Data Type | Constraints | Purpose |
|------------|-----------|-------------|---------|
| USER_ID | NUMBER | PK, IDENTITY, NOT NULL | Unique identifier for each lab user (auto-generated) |
| USERNAME | VARCHAR2(50) | UNIQUE, NOT NULL | Login username for the lab user |
| ROLE | VARCHAR2(30) | NULL | User role (e.g., Lab Technician, Agronomist, Admin) |

**Primary Key:** USER_ID  
**Unique Constraints:** USERNAME  
**Foreign Keys:** None  
**Indexes:** Primary key index on USER_ID, Unique index on USERNAME

**Business Rules:**
- Each user must have a unique username
- User IDs are automatically generated
- Role defines user permissions and responsibilities

---

## SOIL_TEST Table

Stores soil sample test results with nutrient levels (N, P, K).

| Column Name | Data Type | Constraints | Purpose |
|------------|-----------|-------------|---------|
| SOIL_ID | NUMBER | PK, IDENTITY, NOT NULL | Unique identifier for each soil test (auto-generated) |
| FARMER_ID | NUMBER | FK, NOT NULL | References the farmer who submitted the sample |
| LAB_USER_ID | NUMBER | FK, NOT NULL | References the lab user who processed the test |
| NITROGEN | NUMBER | CHECK (>= 0), NULL | Nitrogen content level in the soil |
| PHOSPHORUS | NUMBER | CHECK (>= 0), NULL | Phosphorus content level in the soil |
| POTASSIUM | NUMBER | CHECK (>= 0), NULL | Potassium content level in the soil |
| TEST_DATE | DATE | DEFAULT SYSDATE | Date when the soil test was conducted |

**Primary Key:** SOIL_ID  
**Foreign Keys:** 
- FARMER_ID → FARMER(FARMER_ID)
- LAB_USER_ID → LAB_USER(USER_ID)

**Check Constraints:**
- NITROGEN >= 0
- PHOSPHORUS >= 0
- POTASSIUM >= 0

**Business Rules:**
- All nutrient levels must be non-negative
- Test date defaults to current date if not specified
- Each test must be associated with a farmer and lab user
- Nutrient values represent concentration or percentage levels

---

## FERTILIZER Table

Stores information about available fertilizer types and their characteristics.

| Column Name | Data Type | Constraints | Purpose |
|------------|-----------|-------------|---------|
| FERTILIZER_ID | NUMBER | PK, IDENTITY, NOT NULL | Unique identifier for each fertilizer (auto-generated) |
| FERTILIZER_NAME | VARCHAR2(50) | UNIQUE, NOT NULL | Name of the fertilizer product |
| NUTRIENT_TYPE | VARCHAR2(20) | NOT NULL | Primary nutrient type (e.g., Nitrogen, Phosphorus, Potassium) |
| RECOMMENDED_AMOUNT | NUMBER | NULL | Recommended application amount (units depend on product) |

**Primary Key:** FERTILIZER_ID  
**Unique Constraints:** FERTILIZER_NAME  
**Foreign Keys:** None  
**Indexes:** Primary key index on FERTILIZER_ID, Unique index on FERTILIZER_NAME

**Business Rules:**
- Each fertilizer must have a unique name
- Nutrient type identifies the primary nutrient the fertilizer provides
- Recommended amount is optional and may vary based on soil conditions

---

## RECOMMENDATION Table

Stores fertilizer recommendations generated for each soil test.

| Column Name | Data Type | Constraints | Purpose |
|------------|-----------|-------------|---------|
| REC_ID | NUMBER | PK, IDENTITY, NOT NULL | Unique identifier for each recommendation (auto-generated) |
| SOIL_ID | NUMBER | FK, NOT NULL | References the soil test this recommendation is for |
| FERTILIZER_ID | NUMBER | FK, NULL | References the recommended fertilizer (if applicable) |
| RECOMMENDATION_TEXT | VARCHAR2(4000) | NULL | Detailed recommendation text and instructions |
| REC_DATE | DATE | DEFAULT SYSDATE | Date when the recommendation was generated |
| APPROVED_BY | NUMBER | NULL | User ID of the person who approved the recommendation |

**Primary Key:** REC_ID  
**Foreign Keys:** 
- SOIL_ID → SOIL_TEST(SOIL_ID)
- FERTILIZER_ID → FERTILIZER(FERTILIZER_ID)

**Business Rules:**
- Each recommendation must be linked to a soil test
- Fertilizer ID is optional (recommendation may be "no fertilizer needed")
- Recommendation text can contain detailed instructions up to 4000 characters
- Recommendation date defaults to current date
- Approved_by tracks accountability for recommendations

---

## AUDIT_LOG Table

Tracks all system operations for security, compliance, and troubleshooting.

| Column Name | Data Type | Constraints | Purpose |
|------------|-----------|-------------|---------|
| AUDIT_ID | NUMBER | PK, IDENTITY, NOT NULL | Unique identifier for each audit entry (auto-generated) |
| USERNAME | VARCHAR2(50) | NULL | Username of the person who performed the operation |
| OPERATION | VARCHAR2(20) | NULL | Type of operation (INSERT, UPDATE, DELETE, SELECT) |
| OBJECT_TYPE | VARCHAR2(30) | NULL | Type of object affected (TABLE, PROCEDURE, FUNCTION) |
| OBJECT_ID | NUMBER | NULL | ID of the specific record affected |
| ATTEMPT_TIME | TIMESTAMP WITH TIME ZONE | DEFAULT SYSTIMESTAMP | Exact timestamp of the operation (with timezone) |
| STATUS | VARCHAR2(20) | NULL | Status of the operation (SUCCESS, FAILURE, PENDING) |
| MESSAGE | VARCHAR2(4000) | NULL | Additional details or error messages |

**Primary Key:** AUDIT_ID  
**Foreign Keys:** None  
**Indexes:** Primary key index on AUDIT_ID

**Business Rules:**
- All system operations should be logged automatically via triggers
- Timestamp includes timezone information for accurate tracking
- Status tracks whether the operation succeeded or failed
- Message field can store error details or additional context

---

## HOLIDAY Table

Stores holiday dates when the system may operate differently or be unavailable.

| Column Name | Data Type | Constraints | Purpose |
|------------|-----------|-------------|---------|
| HOLIDAY_ID | NUMBER | PK, IDENTITY, NOT NULL | Unique identifier for each holiday (auto-generated) |
| HOLIDAY_DATE | DATE | UNIQUE, NOT NULL | Date of the holiday |
| DESCRIPTION | VARCHAR2(200) | NULL | Description of the holiday |

**Primary Key:** HOLIDAY_ID  
**Unique Constraints:** HOLIDAY_DATE  
**Foreign Keys:** None  
**Indexes:** Primary key index on HOLIDAY_ID, Unique index on HOLIDAY_DATE

**Business Rules:**
- Each holiday date must be unique
- System may restrict operations on holiday dates
- Used for business logic to prevent soil test submissions on holidays

---

## Table Relationships

### Entity Relationship Summary

```
FARMER (1) ----< (M) SOIL_TEST (M) >---- (1) LAB_USER
                        |
                        | (1)
                        |
                        v
                    (M) RECOMMENDATION (M) >---- (1) FERTILIZER
```

### Relationship Details

1. **FARMER → SOIL_TEST**
   - Type: One-to-Many
   - A farmer can submit multiple soil tests
   - Each soil test belongs to one farmer

2. **LAB_USER → SOIL_TEST**
   - Type: One-to-Many
   - A lab user can process multiple soil tests
   - Each soil test is processed by one lab user

3. **SOIL_TEST → RECOMMENDATION**
   - Type: One-to-Many
   - A soil test can have multiple recommendations (e.g., over time)
   - Each recommendation is based on one soil test

4. **FERTILIZER → RECOMMENDATION**
   - Type: One-to-Many
   - A fertilizer can be recommended multiple times
   - Each recommendation may reference one fertilizer (or none)

5. **AUDIT_LOG**
   - Independent table (no foreign keys)
   - Tracks operations across all tables

6. **HOLIDAY**
   - Independent table (no foreign keys)
   - Referenced by business logic to control operations

---

## Data Types Reference

| Data Type | Description | Usage in System |
|-----------|-------------|-----------------|
| NUMBER | Integer or decimal numbers | IDs, nutrient levels, amounts |
| VARCHAR2(n) | Variable-length character string | Names, descriptions, text |
| DATE | Date and time | Test dates, recommendation dates |
| TIMESTAMP WITH TIME ZONE | Precise timestamp with timezone | Audit logging |

---

## Naming Conventions

- **Table Names:** Singular, lowercase with underscores (e.g., soil_test)
- **Column Names:** Lowercase with underscores (e.g., farmer_id)
- **Primary Keys:** {table_name}_id (e.g., farmer_id)
- **Foreign Keys:** References parent table's primary key name
- **Constraints:** Prefixed with constraint type (fk_, pk_, ck_)

---

## Security Considerations

- Audit log captures all operations for compliance
- User authentication tracked via LAB_USER table
- Recommendations require approval tracking
- Sensitive data should be encrypted at application layer

---

**Last Updated:** December 2025  
**Version:** 1.0