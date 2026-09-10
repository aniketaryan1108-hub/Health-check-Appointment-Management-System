<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.healthcare.DBConnection" %>
<%
if (session.getAttribute("role") == null || !"ADMIN".equals(session.getAttribute("role"))) {
    response.sendRedirect("login.jsp");
    return;
}
String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments | Admin | MediCare Health Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="dashboard-layout">
    <jsp:include page="includes/admin-sidebar.jsp"/>
    <div class="dashboard-content">
        <h2 class="mb-1"><i class="fas fa-calendar-check me-2"></i>Appointments</h2>
        <p class="text-muted mb-4">Approve or reject patient appointment requests</p>

        <% if ("approved".equals(msg)) { %>
            <div class="alert alert-success">Appointment approved. Payment record created.</div>
        <% } else if ("rejected".equals(msg)) { %>
            <div class="alert alert-info">Appointment rejected.</div>
        <% } %>

        <div class="table-card">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Patient</th>
                            <th>Doctor</th>
                            <th>Department</th>
                            <th>Date</th>
                            <th>Time</th>
                            <th>Phone</th>
                            <th>Fee</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        try (Connection con = DBConnection.getConnection();
                             Statement st = con.createStatement();
                             ResultSet rs = st.executeQuery(
                                 "SELECT a.appointment_id, a.patient_name, a.phone, a.department, "
                                 + "a.appointment_date, a.appointment_time, a.status, a.consultation_fee, d.doctor_name "
                                 + "FROM appointments a JOIN doctors d ON a.doctor_id = d.doctor_id "
                                 + "ORDER BY a.appointment_id DESC")) {
                            while (rs.next()) {
                                int apptId = rs.getInt("appointment_id");
                                String status = rs.getString("status");
                                String badgeClass = "badge-pending";
                                if ("Approved".equalsIgnoreCase(status)) badgeClass = "badge-approved";
                                else if ("Rejected".equalsIgnoreCase(status)) badgeClass = "badge-rejected";
                                else if ("Completed".equalsIgnoreCase(status)) badgeClass = "badge-completed";
                        %>
                        <tr>
                            <td><%= apptId %></td>
                            <td><%= rs.getString("patient_name") %></td>
                            <td><%= rs.getString("doctor_name") %></td>
                            <td><%= rs.getString("department") %></td>
                            <td><%= rs.getDate("appointment_date") %></td>
                            <td><%= rs.getTime("appointment_time") %></td>
                            <td><%= rs.getString("phone") %></td>
                            <td>Rs. <%= rs.getDouble("consultation_fee") %></td>
                            <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                            <td>
                                <% if ("Pending".equalsIgnoreCase(status)) { %>
                                <a href="appointmentAction?action=approve&amp;id=<%= apptId %>" class="btn btn-sm btn-success"><i class="fas fa-check"></i> Approve</a>
                                <a href="appointmentAction?action=reject&amp;id=<%= apptId %>" class="btn btn-sm btn-danger"
                                   onclick="return confirm('Reject this appointment?');"><i class="fas fa-times"></i> Reject</a>
                                <% } else { %>
                                <span class="text-muted small">—</span>
                                <% } %>
                            </td>
                        </tr>
                        <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        %>
                        <tr><td colspan="10" class="text-center text-danger">Error loading appointments.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/app.js"></script>
</body>
</html>
