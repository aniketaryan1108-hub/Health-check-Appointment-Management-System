# Database Design — Health Check Appointment Management System

## ER Overview

```
admin (1) ── manages ──> doctors, patients, appointments

patients (1) ──< books >── (*) appointments (*) ──> (1) doctors

appointments (1) ── may have ──> (1) payments
```

## Tables

### 1. admin
| Column | Type | Description |
|--------|------|-------------|
| admin_id | INT PK AI | Primary key |
| username | VARCHAR(50) UNIQUE | Login username |
| email | VARCHAR(100) UNIQUE | Admin email |
| password | VARCHAR(255) | SHA-256 hashed password |
| full_name | VARCHAR(100) | Display name |

### 2. doctors
| Column | Type | Description |
|--------|------|-------------|
| doctor_id | INT PK AI | Primary key |
| doctor_code | VARCHAR(20) UNIQUE | Doctor ID (e.g. DOC001) |
| doctor_name | VARCHAR(100) | Full name |
| specialization | VARCHAR(100) | Specialty |
| qualification | VARCHAR(100) | Degrees |
| experience | INT | Years of experience |
| phone | VARCHAR(20) | Contact |
| email | VARCHAR(100) UNIQUE | Login email |
| password | VARCHAR(255) | SHA-256 hash |
| department | VARCHAR(100) | Department/service |
| available_days | VARCHAR(150) | e.g. Mon, Wed, Fri |
| available_time | VARCHAR(100) | e.g. 09:00 AM - 01:00 PM |
| consultation_fee | DECIMAL(10,2) | Fee in Rs. |
| status | VARCHAR(20) | Available / Not Available |

### 3. patients
| Column | Type | Description |
|--------|------|-------------|
| patient_id | INT PK AI | Primary key |
| full_name | VARCHAR(100) | Patient name |
| age | INT | Age |
| gender | VARCHAR(20) | Male/Female/Other |
| date_of_birth | DATE | DOB |
| phone | VARCHAR(20) | Mobile |
| email | VARCHAR(100) UNIQUE | Login email |
| address | TEXT | Full address |
| password | VARCHAR(255) | SHA-256 hash |
| created_at | TIMESTAMP | Registration date |

### 4. appointments
| Column | Type | Description |
|--------|------|-------------|
| appointment_id | INT PK AI | Primary key |
| patient_id | INT FK | References patients |
| doctor_id | INT FK | References doctors |
| patient_name | VARCHAR(100) | Name at booking |
| phone | VARCHAR(20) | Contact |
| email | VARCHAR(100) | Email |
| department | VARCHAR(100) | Selected department |
| appointment_date | DATE | Visit date |
| appointment_time | TIME | Visit time |
| symptoms | TEXT | Problem/symptoms |
| status | VARCHAR(20) | Pending/Approved/Rejected/Completed |
| consultation_fee | DECIMAL(10,2) | Fee snapshot |
| hospital_location | VARCHAR(255) | Shown when approved |
| created_at | TIMESTAMP | Booking time |

### 5. payments
| Column | Type | Description |
|--------|------|-------------|
| payment_id | INT PK AI | Primary key |
| appointment_id | INT FK | References appointments |
| patient_id | INT FK | References patients |
| amount | DECIMAL(10,2) | Charge amount |
| charge_type | VARCHAR(50) | Consultation / Admission |
| status | VARCHAR(20) | Pending / Paid |
| payment_date | TIMESTAMP | Record date |

## Relationships
- `appointments.patient_id` → `patients.patient_id` (ON DELETE CASCADE)
- `appointments.doctor_id` → `doctors.doctor_id` (ON DELETE CASCADE)
- `payments.appointment_id` → `appointments.appointment_id` (ON DELETE CASCADE)
- `payments.patient_id` → `patients.patient_id` (ON DELETE CASCADE)

## Setup
Run `healthcheck_schema.sql` in MySQL to create database and sample data.
