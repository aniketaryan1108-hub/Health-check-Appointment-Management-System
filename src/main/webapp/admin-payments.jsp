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
    <title>Payments | Admin | MediCare Health Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="dashboard-layout">
    <jsp:include page="includes/admin-sidebar.jsp"/>
    <div class="dashboard-content">
        <h2 class="mb-1"><i class="fas fa-rupee-sign me-2"></i>Payments</h2>
        <p class="text-muted mb-4">Consultation charges generated on appointment approval</p>

        <div class="table-card">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Payment ID</th>
                            <th>Appointment ID</th>
                            <th>Patient</th>
                            <th>Amount (Rs.)</th>
                            <th>Charge Type</th>
                            <th>Status</th>
                            <th>Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        try (Connection con = DBConnection.getConnection();
                             Statement st = con.createStatement();
                             ResultSet rs = st.executeQuery(
                                 "SELECT p.payment_id, p.appointment_id, p.amount, p.charge_type, p.status, "
                                 + "p.payment_date, pt.full_name "
                                 + "FROM payments p JOIN patients pt ON p.patient_id = pt.patient_id "
                                 + "ORDER BY p.payment_id DESC")) {
                            boolean hasRows = false;
                            while (rs.next()) {
                                hasRows = true;
                                String payStatus = rs.getString("status");
                        %>
                        <tr>
                            <td><%= rs.getInt("payment_id") %></td>
                            <td><%= rs.getInt("appointment_id") %></td>
                            <td><%= rs.getString("full_name") %></td>
                            <td><%= rs.getDouble("amount") %></td>
                            <td><%= rs.getString("charge_type") %></td>
                            <td><span class="badge <%= "Pending".equalsIgnoreCase(payStatus) ? "badge-pending" : "badge-approved" %>"><%= payStatus %></span></td>
                            <td><%= rs.getTimestamp("payment_date") %></td>
                        </tr>
                        <%
                            }
                            if (!hasRows) {
                        %>
                        <tr><td colspan="7" class="text-center text-muted py-4">No payment records yet.</td></tr>
                        <%  }
                        } catch (Exception e) {
                            e.printStackTrace();
                        %>
                        <tr><td colspan="7" class="text-center text-danger">Error loading payments.</td></tr>
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
