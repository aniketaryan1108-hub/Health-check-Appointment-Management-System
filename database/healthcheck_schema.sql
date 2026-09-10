-- Health Check Appointment Management System
-- Database: healthcheckdb

CREATE DATABASE IF NOT EXISTS healthcheckdb;
USE healthcheckdb;

DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS doctors;
DROP TABLE IF EXISTS admin;

CREATE TABLE admin (
    admin_id      INT PRIMARY KEY AUTO_INCREMENT,
    username      VARCHAR(50)  NOT NULL UNIQUE,
    email         VARCHAR(100) NOT NULL UNIQUE,
    password      VARCHAR(255) NOT NULL,
    full_name     VARCHAR(100) NOT NULL
);

CREATE TABLE doctors (
    doctor_id         INT PRIMARY KEY AUTO_INCREMENT,
    doctor_code       VARCHAR(20)  NOT NULL UNIQUE,
    doctor_name       VARCHAR(100) NOT NULL,
    specialization    VARCHAR(100) NOT NULL,
    qualification     VARCHAR(100),
    experience        INT DEFAULT 0,
    phone             VARCHAR(20),
    email             VARCHAR(100) NOT NULL UNIQUE,
    password          VARCHAR(255) NOT NULL,
    department        VARCHAR(100) NOT NULL,
    available_days    VARCHAR(150) NOT NULL,
    available_time    VARCHAR(100) NOT NULL,
    consultation_fee  DECIMAL(10,2) DEFAULT 500.00,
    status            VARCHAR(20)  DEFAULT 'Available'
);

CREATE TABLE patients (
    patient_id    INT PRIMARY KEY AUTO_INCREMENT,
    full_name     VARCHAR(100) NOT NULL,
    age           INT NOT NULL,
    gender        VARCHAR(20) NOT NULL,
    date_of_birth DATE NOT NULL,
    phone         VARCHAR(20) NOT NULL,
    email         VARCHAR(100) NOT NULL UNIQUE,
    address       TEXT NOT NULL,
    password      VARCHAR(255) NOT NULL,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE appointments (
    appointment_id    INT PRIMARY KEY AUTO_INCREMENT,
    patient_id        INT NOT NULL,
    doctor_id         INT NOT NULL,
    patient_name      VARCHAR(100) NOT NULL,
    phone             VARCHAR(20) NOT NULL,
    email             VARCHAR(100) NOT NULL,
    department        VARCHAR(100) NOT NULL,
    appointment_date  DATE NOT NULL,
    appointment_time  TIME NOT NULL,
    symptoms          TEXT,
    status            VARCHAR(20) DEFAULT 'Pending',
    consultation_fee  DECIMAL(10,2),
    hospital_location VARCHAR(255) DEFAULT 'MediCare Hospital, Main Block, City Center',
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE
);

CREATE TABLE payments (
    payment_id      INT PRIMARY KEY AUTO_INCREMENT,
    appointment_id    INT NOT NULL,
    patient_id        INT NOT NULL,
    amount            DECIMAL(10,2) NOT NULL,
    charge_type       VARCHAR(50) DEFAULT 'Consultation',
    status            VARCHAR(20) DEFAULT 'Pending',
    payment_date      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE
);

-- Default admin (login: admin@medicare.com / admin123)
INSERT INTO admin (username, email, password, full_name) VALUES
('admin', 'admin@medicare.com',
 '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9',
 'Hospital Administrator');

-- Sample doctors (login email / password: doctor123)
INSERT INTO doctors (doctor_code, doctor_name, specialization, qualification, experience,
    phone, email, password, department, available_days, available_time, consultation_fee, status) VALUES
('DOC001', 'Dr. Rajesh Kumar', 'Cardiology', 'MBBS, MD', 12, '9876500001', 'rajesh@medicare.com',
 'f348d5628621f3d8f59c8cabda0f8eb0aa7e0514a90be7571020b1336f26c113',
 'Heart Checkup', 'Mon, Wed, Fri', '09:00 AM - 01:00 PM', 800.00, 'Available'),
('DOC002', 'Dr. Priya Sharma', 'General Medicine', 'MBBS', 8, '9876500002', 'priya@medicare.com',
 'f348d5628621f3d8f59c8cabda0f8eb0aa7e0514a90be7571020b1336f26c113',
 'General Checkup', 'Mon - Sat', '10:00 AM - 04:00 PM', 500.00, 'Available'),
('DOC003', 'Dr. Amit Patel', 'Dental Care', 'BDS, MDS', 10, '9876500003', 'amit@medicare.com',
 'f348d5628621f3d8f59c8cabda0f8eb0aa7e0514a90be7571020b1336f26c113',
 'Dental Care', 'Tue, Thu, Sat', '11:00 AM - 05:00 PM', 600.00, 'Available'),
('DOC004', 'Dr. Sneha Reddy', 'Ophthalmology', 'MBBS, MS', 7, '9876500004', 'sneha@medicare.com',
 'f348d5628621f3d8f59c8cabda0f8eb0aa7e0514a90be7571020b1336f26c113',
 'Eye Care', 'Mon, Tue, Thu', '09:30 AM - 02:30 PM', 550.00, 'Available'),
('DOC005', 'Dr. Pankaj Karn', 'Surgeon', 'MBBS, MS (Surgery)', 15, '9876500005', 'pankaj@medicare.com',
 'f348d5628621f3d8f59c8cabda0f8eb0aa7e0514a90be7571020b1336f26c113',
 'General Surgery', 'Mon - Fri', '10:00 AM - 03:00 PM', 1200.00, 'Available');
