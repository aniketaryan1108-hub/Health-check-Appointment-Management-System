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
    <title>Doctors | Admin | MediCare Health Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="dashboard-layout">
    <jsp:include page="includes/admin-sidebar.jsp"/>
    <div class="dashboard-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            
            <div>
                <h2 class="mb-0"><i class="fas fa-user-md me-2"></i>Doctors</h2>
                <p class="text-muted mb-0">Manage hospital doctors</p>
            </div>
            <a href="admin-doctor-form.jsp" class="btn btn-hospital"><i class="fas fa-plus me-2"></i>Add Doctor</a>
        </div>

        <% if ("added".equals(msg)) { %>
            
            <div class="alert alert-success">Doctor added successfully.</div>
        <% } else if ("updated".equals(msg)) { %>
            <div class="alert alert-success">Doctor updated successfully.</div>
        <% } else if ("deleted".equals(msg)) { %>
            <div class="alert alert-info">Doctor deleted.</div>
        <% } else if ("delete".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger">Could not delete doctor. They may have linked appointments.</div>
        <% } %>

        <div class="table-card">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Code</th>
                            <th>Name</th>
                            <th>Department</th>
                            <th>Specialization</th>
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
                                 "SELECT doctor_id, doctor_code, doctor_name, department, specialization, "
                                 + "consultation_fee, status FROM doctors ORDER BY doctor_id")) {
                            while (rs.next()) {
                                int docId = rs.getInt("doctor_id");
                        %>
                        <tr>
                            <td><%= docId %></td>
                            <td><%= rs.getString("doctor_code") %></td>
                            <td><%= rs.getString("doctor_name") %></td>
                            <td><%= rs.getString("department") %></td>
                            <td><%= rs.getString("specialization") %></td>
                            <td>Rs. <%= rs.getDouble("consultation_fee") %></td>
                            <td><span class="badge <%= "Available".equalsIgnoreCase(rs.getString("status")) ? "bg-success" : "bg-secondary" %>"><%= rs.getString("status") %></span></td>
                            <td>
                                <a href="admin-doctor-form.jsp?id=<%= docId %>" class="btn btn-sm btn-outline-primary"><i class="fas fa-edit"></i> Edit</a>
                                <a href="deleteDoctor?id=<%= docId %>" class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('Delete this doctor?');"><i class="fas fa-trash"></i> Delete</a>
                            </td>
                        </tr>
                        <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        %>
                        <tr><td colspan="8" class="text-center text-danger">Error loading doctors.</td></tr>
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
