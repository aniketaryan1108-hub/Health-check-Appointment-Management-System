<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.healthcare.DBConnection" %>
<%
if (session.getAttribute("role") == null || !"PATIENT".equals(session.getAttribute("role"))) {
    response.sendRedirect("login.jsp");
    return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Availability | MediCare Health Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="dashboard-layout">
    <jsp:include page="includes/patient-sidebar.jsp"/>
    <div class="dashboard-content">
        <h2 class="mb-1"><i class="fas fa-user-md me-2"></i>Doctor Availability</h2>
        <p class="text-muted mb-4">View schedules, departments, and consultation fees</p>

        
        <div class="table-card">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Code</th>
                            <th>Doctor</th>
                            <th>Department</th>
                            <th>Specialization</th>
                            <th>Available Days</th>
                            <th>Available Time</th>
                            <th>Fee (Rs.)</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        try (Connection con = DBConnection.getConnection();
                             Statement st = con.createStatement();
                             ResultSet rs = st.executeQuery(
                                 "SELECT doctor_code, doctor_name, department, specialization, "
                                 + "available_days, available_time, consultation_fee, status FROM doctors ORDER BY department")) {
                            while (rs.next()) {
                                String status = rs.getString("status");
                        %>
                        <tr>
                            <td><%= rs.getString("doctor_code") %></td>
                            <td><%= rs.getString("doctor_name") %></td>
                            <td><%= rs.getString("department") %></td>
                            <td><%= rs.getString("specialization") %></td>
                            <td><%= rs.getString("available_days") %></td>
                            <td><%= rs.getString("available_time") %></td>
                            <td><%= rs.getDouble("consultation_fee") %></td>
                            <td>
                                <span class="badge <%= "Available".equalsIgnoreCase(status) ? "bg-success" : "bg-secondary" %>">
                                    <%= status %>
                                </span>
                            </td>
                        </tr>
                        <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        %>
                        <tr><td colspan="8" class="text-center text-danger">Unable to load doctors.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <div class="mt-3">
                <a href="patient-book.jsp" class="btn btn-hospital"><i class="fas fa-calendar-plus me-2"></i>Book Appointment</a>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/app.js"></script>
</body>
</html>
