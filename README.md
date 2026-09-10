# Health Check Appointment Management System

**College Major Project** — A complete hospital appointment booking web application.

## Technology Stack

| Layer | Technology |
|-------|------------|
| Frontend | HTML5, CSS3, JavaScript, Bootstrap 5, Font Awesome |
| Backend | Java Servlet 4.0, JSP |
| Database | MySQL |
| Server | Apache Tomcat 9 |

## Features Checklist

- [x] Professional hospital home page (hero, services, doctors, contact, footer)
- [x] Role-based login (Admin, Doctor, Patient)
- [x] Patient signup with validation
- [x] Patient dashboard with profile & appointment history
- [x] Book appointment (Pending until admin approves)
- [x] Doctor availability page
- [x] Admin dashboard with statistics
- [x] Admin: approve/reject appointments, manage doctors, view payments
- [x] Doctor dashboard with today's & approved appointments
- [x] Mark appointment as completed
- [x] SHA-256 password hashing
- [x] Responsive white & blue hospital theme

## Project Structure

```
HealthCheckAppointmentManagmentSystem/
├── database/
│   ├── healthcheck_schema.sql      # Run this in MySQL
│   └── DATABASE_DESIGN.md          # ER & table documentation
├── src/main/java/com/healthcare/   # Backend servlets
├── src/main/webapp/                # Frontend JSP pages
│   ├── index.jsp                   # Login (entry)
│   ├── home.jsp                    # Public website
│   ├── signup.jsp
│   ├── patient-*.jsp               # Patient modules
│   ├── admin-*.jsp                 # Admin modules
│   ├── doctor-dashboard.jsp
│   ├── css/style.css
│   ├── js/app.js
│   └── WEB-INF/web.xml
├── build.bat                       # Compile backend
├── HOW_TO_RUN.txt
└── COMPLETE_WORKFLOW.md
```

## Quick Start

### 1. Database
```sql
source database/healthcheck_schema.sql
```

### 2. Configure
Edit `src/main/webapp/WEB-INF/classes/db.properties`:
```properties
db.user=root
db.password=YOUR_MYSQL_PASSWORD
```

### 3. Build & Run
- Run `build.bat` OR Eclipse: **Project → Clean → Build**
- Deploy on **Tomcat 9** in Eclipse
- Open: **http://localhost:8080/HealthCheckAppointmentManagmentSystem/**

## Demo Accounts

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@medicare.com | admin123 |
| Doctor | priya@medicare.com | doctor123 |
| Patient | Register at signup.jsp | — |

## Application Flow

1. **Patient** signs up → logs in → books appointment → status **Pending**
2. **Admin** approves → status **Approved** + payment record created
3. **Doctor** views appointments → marks **Completed**
4. **Patient** views status with doctor, date, time, fee, hospital location

## Pages Map

| Page | User |
|------|------|
| home.jsp | Public |
| index.jsp | All (login) |
| signup.jsp | Patient |
| patient-dashboard.jsp | Patient |
| patient-book.jsp | Patient |
| patient-status.jsp | Patient |
| patient-doctors.jsp | Patient |
| admin-dashboard.jsp | Admin |
| admin-appointments.jsp | Admin |
| admin-doctors.jsp | Admin |
| doctor-dashboard.jsp | Doctor |

## Author

Health Check Appointment Management System — MediCare Health Hospital
