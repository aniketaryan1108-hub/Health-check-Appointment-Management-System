<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.healthcare.DBConnection" %>
<%
if (session.getAttribute("role") == null || !"PATIENT".equals(session.getAttribute("role"))) {
    response.sendRedirect("login.jsp");
    return;
}
int patientId = (Integer) session.getAttribute("userId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointment Status | MediCare Health Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="dashboard-layout">
    <jsp:include page="includes/patient-sidebar.jsp"/>
    
    <div class="dashboard-content">
        <h2 class="mb-1"><i class="fas fa-clipboard-list me-2"></i>My Appointments</h2>
        <p class="text-muted mb-4">Track status of your booked appointments</p>

        <% if ("booked".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Appointment submitted successfully. Status: <strong>Pending</strong> â€” waiting for admin approval.</div>
        <% } %>

        <%
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(
                 "SELECT a.appointment_id, a.department, a.appointment_date, a.appointment_time, "
                 + "a.status, a.consultation_fee, a.symptoms, a.hospital_location, d.doctor_name "
                 + "FROM appointments a JOIN doctors d ON a.doctor_id = d.doctor_id "
                 + "WHERE a.patient_id=? ORDER BY a.appointment_date DESC, a.appointment_time DESC")) {
            pst.setInt(1, patientId);
            try (ResultSet rs = pst.executeQuery()) {
                boolean hasRows = false;
                while (rs.next()) {
                    hasRows = true;
                    String status = rs.getString("status");
                    String badgeClass = "badge-pending";
                    if ("Approved".equalsIgnoreCase(status)) badgeClass = "badge-approved";
                    else if ("Rejected".equalsIgnoreCase(status)) badgeClass = "badge-rejected";
                    else if ("Completed".equalsIgnoreCase(status)) badgeClass = "badge-completed";
        %>
        <div class="table-card mb-3">
            
            <div class="d-flex justify-content-between align-items-start flex-wrap gap-2 mb-2">
                <h5 class="mb-0">Appointment #<%= rs.getInt("appointment_id") %></h5>
                <span class="badge <%= badgeClass %> fs-6"><%= status %></span>
            </div>
            <div class="row g-2">
                <div class="col-md-6"><strong>Doctor:</strong> <%= rs.getString("doctor_name") %></div>
                <div class="col-md-6"><strong>Department:</strong> <%= rs.getString("department") %></div>
                <div class="col-md-6"><strong>Date:</strong> <%= rs.getDate("appointment_date") %></div>
                
                
                <div class="col-md-6"><strong>Time:</strong> <%= rs.getTime("appointment_time") %></div>
                <div class="col-md-6"><strong>Fee:</strong> Rs. <%= rs.getDouble("consultation_fee") %></div>
                <% if (rs.getString("symptoms") != null && !rs.getString("symptoms").isEmpty()) { %>
                <div class="col-12"><strong>Symptoms:</strong> <%= rs.getString("symptoms") %></div>
                <% } %>
                <% if ("Approved".equalsIgnoreCase(status) || "Completed".equalsIgnoreCase(status)) { %>
                <div class="col-12 mt-2 p-3 bg-light rounded">
                    <strong><i class="fas fa-map-marker-alt text-primary me-1"></i>Hospital Location:</strong>
                    <%= rs.getString("hospital_location") != null ? rs.getString("hospital_location") : "MediCare Hospital, Main Block, City Center" %>
                </div>
                <% } %>
            </div>
        </div>
        <%
                }
                if (!hasRows) {
        %>
        <div class="table-card text-center py-5 text-muted">
            <i class="fas fa-calendar-times fa-3x mb-3"></i>
            <p>No appointments yet.</p>
            <a href="patient-book.jsp" class="btn btn-hospital">Book Appointment</a>
        </div>
        <%      }
            }
        } catch (Exception e) {
            e.printStackTrace();
        %>
        
        <div class="alert alert-danger">Cannot load appointments. Check MySQL connection and run healthcheck_schema.sql</div>
        <% } %>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

