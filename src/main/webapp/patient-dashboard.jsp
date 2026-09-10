<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.healthcare.DBConnection" %>
<%
if (session.getAttribute("role") == null || !"PATIENT".equals(session.getAttribute("role"))) {
    response.sendRedirect("login.jsp");
    return;
}
int patientId = (Integer) session.getAttribute("userId");
String fullName = "";
String email = "";
String phone = "";
int age = 0;
String gender = "";
String address = "";
try (Connection con = DBConnection.getConnection();
     PreparedStatement pst = con.prepareStatement(
         "SELECT full_name, email, phone, age, gender, address FROM patients WHERE patient_id=?")) {
    pst.setInt(1, patientId);
    try (ResultSet rs = pst.executeQuery()) {
        if (rs.next()) {
            fullName = rs.getString("full_name");
            email = rs.getString("email");
            phone = rs.getString("phone");
            age = rs.getInt("age");
            gender = rs.getString("gender");
            address = rs.getString("address");
        }
    }
} catch (Exception e) {
    e.printStackTrace();
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard | MediCare Health Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="dashboard-layout">
    <jsp:include page="includes/patient-sidebar.jsp"/>
    <div class="dashboard-content">
        <h2 class="mb-1">Welcome, <%= session.getAttribute("userName") %></h2>
        <p class="text-muted mb-4">Manage your appointments and health checkups</p>
        <div class="row g-4">
            <div class="col-lg-5">
                <div class="profile-card">
                    <div class="d-flex align-items-center gap-3 mb-3">
                        <div class="avatar"><i class="fas fa-user"></i></div>
                        <div>
                            <h4 class="mb-0"><%= fullName %></h4>
                            <span class="text-muted">Patient ID: <%= patientId %></span>
                        </div>
                    </div>
                    <hr>
                    <p class="mb-1"><i class="fas fa-envelope me-2 text-primary"></i><%= email %></p>
                    <p class="mb-1"><i class="fas fa-phone me-2 text-primary"></i><%= phone %></p>
                    <p class="mb-1"><i class="fas fa-birthday-cake me-2 text-primary"></i>Age: <%= age %> | <%= gender %></p>
                    <p class="mb-0"><i class="fas fa-map-marker-alt me-2 text-primary"></i><%= address %></p>
                </div>
            </div>
            <div class="col-lg-7">
                <div class="row g-3">
                    <div class="col-md-6">
                        <a href="patient-book.jsp" class="text-decoration-none">
                            <div class="service-card text-center">
                                <div class="service-icon mx-auto"><i class="fas fa-calendar-plus"></i></div>
                                <h5>Book Appointment</h5>
                                <p class="text-muted small mb-0">Schedule a new health checkup</p>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-6">
                        <a href="patient-status.jsp" class="text-decoration-none">
                            <div class="service-card text-center">
                                <div class="service-icon mx-auto"><i class="fas fa-clipboard-list"></i></div>
                                <h5>Appointment Status</h5>
                                <p class="text-muted small mb-0">Track pending and approved visits</p>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-6">
                        <a href="patient-doctors.jsp" class="text-decoration-none">
                            <div class="service-card text-center">
                                <div class="service-icon mx-auto"><i class="fas fa-user-md"></i></div>
                                <h5>Doctor Availability</h5>
                                <p class="text-muted small mb-0">View doctor schedules and fees</p>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-6">
                        <a href="home.jsp" class="text-decoration-none">
                            <div class="service-card text-center">
                                <div class="service-icon mx-auto"><i class="fas fa-hospital"></i></div>
                                <h5>Hospital Home</h5>
                                <p class="text-muted small mb-0">Browse services and contact info</p>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <h4 class="mt-5 mb-3"><i class="fas fa-history me-2"></i>Appointment History</h4>
        
        <div class="table-card">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr><th>ID</th><th>Doctor</th><th>Department</th><th>Date</th><th>Time</th><th>Fee</th><th>Status</th></tr>
                    </thead>
                    <tbody>
                        <%
                        try (Connection con2 = DBConnection.getConnection();
                             PreparedStatement pst2 = con2.prepareStatement(
                                 "SELECT a.appointment_id, a.department, a.appointment_date, a.appointment_time, "
                                 + "a.status, a.consultation_fee, d.doctor_name FROM appointments a "
                                 + "JOIN doctors d ON a.doctor_id = d.doctor_id WHERE a.patient_id=? "
                                 + "ORDER BY a.appointment_id DESC LIMIT 10")) {
                            pst2.setInt(1, patientId);
                            try (ResultSet rs2 = pst2.executeQuery()) {
                                boolean found = false;
                                while (rs2.next()) {
                                    found = true;
                                    String st = rs2.getString("status");
                                    String bc = "badge-pending";
                                    if ("Approved".equalsIgnoreCase(st)) bc = "badge-approved";
                                    else if ("Rejected".equalsIgnoreCase(st)) bc = "badge-rejected";
                                    else if ("Completed".equalsIgnoreCase(st)) bc = "badge-completed";
                        %>
                        <tr>
                            <td><%= rs2.getInt("appointment_id") %></td>
                            <td><%= rs2.getString("doctor_name") %></td>
                            <td><%= rs2.getString("department") %></td>
                            <td><%= rs2.getDate("appointment_date") %></td>
                            <td><%= rs2.getTime("appointment_time") %></td>
                            <td>Rs. <%= rs2.getDouble("consultation_fee") %></td>
                            <td><span class="badge <%= bc %>"><%= st %></span></td>
                        </tr>
                        <%      }
                                if (!found) { %>
                        <tr><td colspan="7" class="text-center text-muted py-3">No appointments yet. <a href="patient-book.jsp">Book now</a></td></tr>
                        <%      }
                            }
                        } catch (Exception ex) { ex.printStackTrace(); } %>
                    </tbody>
                </table>
            </div>
            <a href="patient-status.jsp" class="btn btn-outline-primary btn-sm mt-3">View full details</a>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/app.js"></script>
</body>
</html>
