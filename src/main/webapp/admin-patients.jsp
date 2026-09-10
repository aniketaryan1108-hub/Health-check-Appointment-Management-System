<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.healthcare.DBConnection" %>
<%
if (session.getAttribute("role") == null || !"ADMIN".equals(session.getAttribute("role"))) {
    response.sendRedirect("login.jsp");
    return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patients | Admin | MediCare Health Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="dashboard-layout">
    <jsp:include page="includes/admin-sidebar.jsp"/>
    <div class="dashboard-content">
        <h2 class="mb-1"><i class="fas fa-users me-2"></i>All Patients</h2>
        <p class="text-muted mb-4">Registered patients in the system</p>

        <div class="table-card">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Full Name</th>
                            <th>Age</th>
                            <th>Gender</th>
                            <th>Date of Birth</th>
                            <th>Phone</th>
                            <th>Email</th>
                            <th>Address</th>
                            <th>Registered</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        try (Connection con = DBConnection.getConnection();
                             Statement st = con.createStatement();
                             ResultSet rs = st.executeQuery(
                                 "SELECT patient_id, full_name, age, gender, date_of_birth, phone, email, address, created_at "
                                 + "FROM patients ORDER BY patient_id DESC")) {
                            boolean hasRows = false;
                            while (rs.next()) {
                                hasRows = true;
                        %>
                        <tr>
                            <td><%= rs.getInt("patient_id") %></td>
                            <td><%= rs.getString("full_name") %></td>
                            <td><%= rs.getInt("age") %></td>
                            <td><%= rs.getString("gender") %></td>
                            <td><%= rs.getDate("date_of_birth") %></td>
                            <td><%= rs.getString("phone") %></td>
                            <td><%= rs.getString("email") %></td>
                            <td><%= rs.getString("address") %></td>
                            <td><%= rs.getTimestamp("created_at") %></td>
                        </tr>
                        <%
                            }
                            if (!hasRows) {
                        %>
                        <tr><td colspan="9" class="text-center text-muted py-4">No patients registered yet.</td></tr>
                        <%  }
                        } catch (Exception e) {
                            e.printStackTrace();
                        %>
                        <tr><td colspan="9" class="text-center text-danger">Error loading patients.</td></tr>
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
