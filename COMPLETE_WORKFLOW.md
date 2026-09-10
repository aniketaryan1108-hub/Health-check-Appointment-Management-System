# Complete Working Process — Health Check Appointment System

## Architecture

```
Browser (HTML/CSS/JS + JSP)
        |
        v
Apache Tomcat 9
        |
   Java Servlets  ------>  MySQL (healthcheckdb)
        |
   JSP Pages
```

---

## Full User Flow

### 1. Patient Registration & Login
```
signup.jsp  -->  POST /signup  -->  patients table
index.jsp   -->  POST /login   -->  session (role=PATIENT)  -->  patient-dashboard.jsp
```

### 2. Book Appointment
```
patient-book.jsp  -->  POST /bookAppointment  -->  appointments (status=Pending)
```

### 3. Admin Approval
```
admin-appointments.jsp  -->  GET /appointmentAction?action=approve&id=X
                         -->  status=Approved + payments record created
```

### 4. Doctor Completes Visit
```
doctor-dashboard.jsp  -->  GET /appointmentAction?action=complete&id=X
                       -->  status=Completed
```

### 5. Patient Views Status
```
patient-status.jsp  -->  shows Pending / Approved / Rejected / Completed
```

---

## File Map

### Frontend (src/main/webapp/)
| File | Role |
|------|------|
| index.jsp | Login entry |
| home.jsp | Public website |
| signup.jsp | Patient register |
| patient-dashboard.jsp | Patient home |
| patient-book.jsp | Book appointment |
| patient-status.jsp | View appointments |
| patient-doctors.jsp | Doctor availability |
| admin-dashboard.jsp | Admin stats |
| admin-patients.jsp | All patients |
| admin-doctors.jsp | Manage doctors |
| admin-doctor-form.jsp | Add/Edit doctor |
| admin-appointments.jsp | Approve/Reject |
| admin-payments.jsp | Payment records |
| doctor-dashboard.jsp | Doctor appointments |
| css/style.css | Hospital theme |
| js/app.js | Doctor filter by department |

### Backend (src/main/java/com/healthcare/)
| Servlet | URL | Method |
|---------|-----|--------|
| LoginServlet | /login | POST |
| SignupServlet | /signup | POST |
| LogoutServlet | /logout | GET |
| AppointmentServlet | /bookAppointment | POST |
| AppointmentActionServlet | /appointmentAction | GET |
| DoctorServlet | /doctor | POST |
| UpdateDoctorServlet | /updateDoctor | POST |
| DeleteDoctorServlet | /deleteDoctor | GET |
| DeleteAppointmentServlet | /deleteAppointment | GET |

### Database (database/healthcheck_schema.sql)
- admin, doctors, patients, appointments, payments

---

## Run Steps

1. **MySQL**: Run `database/healthcheck_schema.sql`
2. **Config**: Edit `WEB-INF/classes/db.properties` if password differs
3. **Build**: Double-click `build.bat` OR Eclipse Project → Clean → Build
4. **Deploy**: Eclipse → Tomcat 9 → Add project → Start
5. **Open**: `http://localhost:8080/HealthCheckAppointmentManagmentSystem/`

## Demo Accounts

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@medicare.com | admin123 |
| Doctor | priya@medicare.com | doctor123 |
| Patient | Register at signup.jsp | your password |
