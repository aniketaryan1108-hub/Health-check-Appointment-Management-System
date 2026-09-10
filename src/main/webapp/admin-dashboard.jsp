<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.healthcare.DBConnection" %>
<%
if (session.getAttribute("role") == null || !"ADMIN".equals(session.getAttribute("role"))) {
    response.sendRedirect("login.jsp");
    return;
}
int patientCount = 0, doctorCount = 0, appointmentCount = 0;
int pendingCount = 0, approvedCount = 0, rejectedCount = 0, paymentCount = 0;
try (Connection con = DBConnection.getConnection()) {
    try (Statement st = con.createStatement()) {
        try (ResultSet rs = st.executeQuery("SELECT COUNT(*) AS c FROM patients")) {
            if (rs.next()) patientCount = rs.getInt("c");
        }
        try (ResultSet rs = st.executeQuery("SELECT COUNT(*) AS c FROM doctors")) {
            if (rs.next()) doctorCount = rs.getInt("c");
        }
        try (ResultSet rs = st.executeQuery("SELECT COUNT(*) AS c FROM appointments")) {
            if (rs.next()) appointmentCount = rs.getInt("c");
        }
        try (ResultSet rs = st.executeQuery("SELECT COUNT(*) AS c FROM appointments WHERE status='Pending'")) {
            if (rs.next()) pendingCount = rs.getInt("c");
        }
        try (ResultSet rs = st.executeQuery("SELECT COUNT(*) AS c FROM appointments WHERE status='Approved'")) {
            if (rs.next()) approvedCount = rs.getInt("c");
        }
        try (ResultSet rs = st.executeQuery("SELECT COUNT(*) AS c FROM appointments WHERE status='Rejected'")) {
            if (rs.next()) rejectedCount = rs.getInt("c");
        }
        try (ResultSet rs = st.executeQuery("SELECT COUNT(*) AS c FROM payments")) {
            if (rs.next()) paymentCount = rs.getInt("c");
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
    <title>Admin Dashboard | MediCare Health Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="dashboard-layout">
    <jsp:include page="includes/admin-sidebar.jsp"/>
    <div class="dashboard-content">
        <h2 class="mb-1">Admin Dashboard</h2>
        <p class="text-muted mb-4">Welcome, <%= session.getAttribute("userName") %> — MediCare Health Hospital</p>

        <div class="row g-4 mb-4">
            <div class="col-md-4 col-lg-2">
                <div class="stat-card">
                    <div class="stat-icon"><i class="fas fa-users"></i></div>
                    <h3><%= patientCount %></h3>
                    <p>Patients</p>
                </div>
            </div>
            <div class="col-md-4 col-lg-2">
                <div class="stat-card">
                    <div class="stat-icon"><i class="fas fa-user-md"></i></div>
                    <h3><%= doctorCount %></h3>
                    <p>Doctors</p>
                </div>
            </div>
            <div class="col-md-4 col-lg-2">
                <div class="stat-card">
                    
                    <div class="stat-icon"><i class="fas fa-calendar-check"></i></div>
                    <h3><%= appointmentCount %></h3>
                    <p>Appointments</p>
                </div>
            </div>
            <div class="col-md-4 col-lg-2">
                <div class="stat-card pending">
                    <div class="stat-icon"><i class="fas fa-hourglass-half"></i></div>
                    <h3><%= pendingCount %></h3>
                    <p>Pending</p>
                </div>
            </div>
            <div class="col-md-4 col-lg-2">
                <div class="stat-card approved">
                    <div class="stat-icon"><i class="fas fa-check-circle"></i></div>
                    <h3><%= approvedCount %></h3>
                    <p>Approved</p>
                </div>
            </div>
            <div class="col-md-4 col-lg-2">
                <div class="stat-card rejected">
                    <div class="stat-icon"><i class="fas fa-times-circle"></i></div>
                    <h3><%= rejectedCount %></h3>
                    <p>Rejected</p>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-icon"><i class="fas fa-rupee-sign"></i></div>
                    <h3><%= paymentCount %></h3>
                    <p>Payment Records</p>
                    <a href="admin-payments.jsp" class="btn btn-sm btn-outline-primary mt-2">View Payments</a>
                </div>
            </div>
            <div class="col-md-8">
                <div class="table-card">
                    <h5 class="mb-3">Quick Actions</h5>
                    <div class="d-flex flex-wrap gap-2">
                        <a href="admin-appointments.jsp" class="btn btn-hospital btn-sm"><i class="fas fa-calendar me-1"></i>Manage Appointments</a>
                        <a href="admin-doctor-form.jsp" class="btn btn-outline-primary btn-sm"><i class="fas fa-plus me-1"></i>Add Doctor</a>
                        <a href="admin-patients.jsp" class="btn btn-outline-primary btn-sm"><i class="fas fa-users me-1"></i>View Patients</a>
                        <a href="admin-doctors.jsp" class="btn btn-outline-primary btn-sm"><i class="fas fa-user-md me-1"></i>View Doctors</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/app.js"></script>
</body>
</html>
