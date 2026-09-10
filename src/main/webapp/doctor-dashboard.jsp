<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.healthcare.DBConnection" %>
<%
if (session.getAttribute("role") == null || !"DOCTOR".equals(session.getAttribute("role"))) {
    response.sendRedirect("login.jsp");
    return;
}
int doctorId = (Integer) session.getAttribute("userId");
String msg = request.getParameter("msg");
String docCode = "", docPhone = "", docEmail = "", docDept = "", docDays = "", docTime = "";
int docExp = 0;
double docFee = 0;
try (Connection con0 = DBConnection.getConnection();
     PreparedStatement ps0 = con0.prepareStatement("SELECT * FROM doctors WHERE doctor_id=?")) {
    ps0.setInt(1, doctorId);
    try (ResultSet rs0 = ps0.executeQuery()) {
        if (rs0.next()) {
            docCode = rs0.getString("doctor_code");
            docPhone = rs0.getString("phone") != null ? rs0.getString("phone") : "";
            docEmail = rs0.getString("email");
            docDept = rs0.getString("department");
            docDays = rs0.getString("available_days");
            docTime = rs0.getString("available_time");
            docExp = rs0.getInt("experience");
            docFee = rs0.getDouble("consultation_fee");
        }
    }
} catch (Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard | MediCare Health Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="dashboard-layout">
    <jsp:include page="includes/doctor-sidebar.jsp"/>
    <div class="dashboard-content">
        <h2 class="mb-1">Dr. <%= session.getAttribute("userName") %></h2>
        <p class="text-muted mb-4">
            <%= session.getAttribute("specialization") != null ? session.getAttribute("specialization") : "Doctor" %>
            — MediCare Health Hospital
        </p>

        <% if ("completed".equals(msg)) { %>
            <div class="alert alert-success">Appointment marked as completed.</div>
        <% } else if ("approved".equals(msg)) { %>
            <div class="alert alert-success">Appointment accepted successfully.</div>
        <% } else if ("rejected".equals(msg)) { %>
            <div class="alert alert-info">Appointment rejected.</div>
        <% } else if ("notallowed".equals(request.getParameter("error"))) { %>
            <div class="alert alert-warning">This action is not allowed.</div>
        <% } %>

        
        <div class="profile-card mb-4">
            
            <div class="row align-items-center">
                <div class="col-auto">
                    <div class="avatar"><i class="fas fa-user-md"></i></div>
                </div>
                <div class="col">
                    <h4 class="mb-1">Dr. <%= session.getAttribute("userName") %></h4>
                    <p class="text-muted mb-1"><%= session.getAttribute("specialization") %> | ID: <%= docCode %></p>
                    <p class="small mb-0"><i class="fas fa-envelope me-1"></i><%= docEmail %> &nbsp; <i class="fas fa-phone me-1"></i><%= docPhone %></p>
                    <p class="small mb-0"><i class="fas fa-building me-1"></i><%= docDept %> | <%= docExp %> yrs exp | Fee: Rs.<%= docFee %></p>
                    <p class="small mb-0"><i class="fas fa-calendar me-1"></i><%= docDays %> | <%= docTime %></p>
                </div>
            </div>
        </div>

        <h4 class="mb-3"><i class="fas fa-inbox me-2"></i>Pending Patient Requests (Accept / Reject)</h4>
        <div class="table-card mb-4">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr><th>ID</th><th>Patient</th><th>Phone</th><th>Date</th><th>Time</th><th>Symptoms</th><th>Action</th></tr>
                    </thead>
                    <tbody>
                        <%
                        try (Connection conP = DBConnection.getConnection();
                             PreparedStatement pstP = conP.prepareStatement(
                                 "SELECT appointment_id, patient_name, phone, appointment_date, appointment_time, symptoms "
                                 + "FROM appointments WHERE doctor_id=? AND status='Pending' ORDER BY appointment_date")) {
                            pstP.setInt(1, doctorId);
                            try (ResultSet rsP = pstP.executeQuery()) {
                                boolean hasPending = false;
                                while (rsP.next()) {
                                    hasPending = true;
                                    int apptId = rsP.getInt("appointment_id");
                        %>
                        <tr>
                            <td><%= apptId %></td>
                            <td><%= rsP.getString("patient_name") %></td>
                            <td><%= rsP.getString("phone") %></td>
                            <td><%= rsP.getDate("appointment_date") %></td>
                            <td><%= rsP.getTime("appointment_time") %></td>
                            <td><%= rsP.getString("symptoms") != null ? rsP.getString("symptoms") : "-" %></td>
                            <td>
                                <a href="appointmentAction?action=approve&amp;id=<%= apptId %>" class="btn btn-sm btn-success">Accept</a>
                                <a href="appointmentAction?action=reject&amp;id=<%= apptId %>" class="btn btn-sm btn-danger"
                                   onclick="return confirm('Reject this appointment?');">Reject</a>
                            </td>
                        </tr>
                        <%      }
                                if (!hasPending) { %>
                        <tr><td colspan="7" class="text-center text-muted py-3">No pending requests.</td></tr>
                        <%      }
                            }
                        } catch (Exception ex) { ex.printStackTrace(); } %>
                    </tbody>
                </table>
            
            </div>
        </div>

        <h4 class="mb-3"><i class="fas fa-calendar-day me-2"></i>Today's Appointments</h4>
        <div class="table-card mb-4">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Patient</th>
                            <th>Phone</th>
                            <th>Department</th>
                            <th>Time</th>
                            <th>Symptoms</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        try (Connection con = DBConnection.getConnection();
                             PreparedStatement pst = con.prepareStatement(
                                 "SELECT appointment_id, patient_name, phone, department, appointment_time, symptoms, status "
                                 + "FROM appointments WHERE doctor_id=? AND appointment_date=CURDATE() "
                                 + "ORDER BY appointment_time")) {
                            pst.setInt(1, doctorId);
                            try (ResultSet rs = pst.executeQuery()) {
                                boolean hasRows = false;
                                while (rs.next()) {
                                    hasRows = true;
                                    int apptId = rs.getInt("appointment_id");
                                    String status = rs.getString("status");
                                    String badgeClass = "badge-pending";
                                    if ("Approved".equalsIgnoreCase(status)) badgeClass = "badge-approved";
                                    else if ("Completed".equalsIgnoreCase(status)) badgeClass = "badge-completed";
                        %>
                        <tr>
                            <td><%= apptId %></td>
                            <td><%= rs.getString("patient_name") %></td>
                            <td><%= rs.getString("phone") %></td>
                            <td><%= rs.getString("department") %></td>
                            <td><%= rs.getTime("appointment_time") %></td>
                            <td><%= rs.getString("symptoms") != null ? rs.getString("symptoms") : "—" %></td>
                            <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                            <td>
                                <% if ("Pending".equalsIgnoreCase(status)) { %>
                                <a href="appointmentAction?action=approve&amp;id=<%= apptId %>" class="btn btn-sm btn-success">Accept</a>
                                <a href="appointmentAction?action=reject&amp;id=<%= apptId %>" class="btn btn-sm btn-danger">Reject</a>
                                <% } else if ("Approved".equalsIgnoreCase(status)) { %>
                                <a href="appointmentAction?action=complete&amp;id=<%= apptId %>" class="btn btn-sm btn-hospital">Complete</a>
                                <% } else { %>
                                <span class="text-muted small">-</span>
                                <% } %>
                            </td>
                        </tr>
                        <%
                                }
                                if (!hasRows) {
                        %>
                        <tr><td colspan="8" class="text-center text-muted py-4">No appointments scheduled for today.</td></tr>
                        <%      }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        %>
                        <tr><td colspan="8" class="text-center text-danger">Error loading appointments.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <h4 class="mb-3"><i class="fas fa-check-circle me-2"></i>Approved Appointments (All Dates)</h4>
        <div class="table-card">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Patient</th>
                            <th>Department</th>
                            <th>Date</th>
                            <th>Time</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        try (Connection con = DBConnection.getConnection();
                             PreparedStatement pst = con.prepareStatement(
                                 "SELECT appointment_id, patient_name, department, appointment_date, appointment_time, status "
                                 + "FROM appointments WHERE doctor_id=? AND status='Approved' "
                                 + "ORDER BY appointment_date, appointment_time")) {
                            pst.setInt(1, doctorId);
                            try (ResultSet rs = pst.executeQuery()) {
                                boolean hasRows = false;
                                while (rs.next()) {
                                    hasRows = true;
                                    int apptId = rs.getInt("appointment_id");
                        %>
                        <tr>
                            <td><%= apptId %></td>
                            <td><%= rs.getString("patient_name") %></td>
                            <td><%= rs.getString("department") %></td>
                            <td><%= rs.getDate("appointment_date") %></td>
                            <td><%= rs.getTime("appointment_time") %></td>
                            <td><span class="badge badge-approved">Approved</span></td>
                            <td>
                                <a href="appointmentAction?action=complete&amp;id=<%= apptId %>" class="btn btn-sm btn-hospital">Complete</a>
                            </td>
                        </tr>
                        <%
                                }
                                if (!hasRows) {
                        %>
                        <tr><td colspan="7" class="text-center text-muted py-4">No approved appointments.</td></tr>
                        <%      }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        %>
                        <tr><td colspan="7" class="text-center text-danger">Error loading appointments.</td></tr>
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
