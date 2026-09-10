<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.healthcare.DBConnection" %>
<%
if (session.getAttribute("role") == null || !"ADMIN".equals(session.getAttribute("role"))) {
    response.sendRedirect("login.jsp");
    return;
}
String idParam = request.getParameter("id");
boolean editMode = idParam != null && !idParam.trim().isEmpty();
int doctorId = 0;
String doctorName = "", doctorCode = "", specialization = "", qualification = "";
int experience = 0;
String phone = "", email = "", department = "", availableDays = "", availableTime = "";
double consultationFee = 500;
String status = "Available";

if (editMode) {
    try {
        doctorId = Integer.parseInt(idParam);
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement("SELECT * FROM doctors WHERE doctor_id=?")) {
            pst.setInt(1, doctorId);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    doctorName = rs.getString("doctor_name");
                    doctorCode = rs.getString("doctor_code");
                    specialization = rs.getString("specialization");
                    qualification = rs.getString("qualification") != null ? rs.getString("qualification") : "";
                    experience = rs.getInt("experience");
                    phone = rs.getString("phone") != null ? rs.getString("phone") : "";
                    email = rs.getString("email");
                    department = rs.getString("department");
                    availableDays = rs.getString("available_days");
                    availableTime = rs.getString("available_time");
                    consultationFee = rs.getDouble("consultation_fee");
                    status = rs.getString("status");
                } else {
                    response.sendRedirect("admin-doctors.jsp");
                    return;
                }
            }
        }
    } catch (Exception e) {
        response.sendRedirect("admin-doctors.jsp");
        return;
    }
}
String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= editMode ? "Edit" : "Add" %> Doctor | MediCare Health Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="dashboard-layout">
    <jsp:include page="includes/admin-sidebar.jsp"/>
    
    <div class="dashboard-content">
        <h2 class="mb-1"><i class="fas fa-user-md me-2"></i><%= editMode ? "Edit Doctor" : "Add Doctor" %></h2>
        <p class="text-muted mb-4"><%= editMode ? "Update doctor details" : "Register a new doctor" %></p>

        <% if ("required".equals(error)) { %>
            <div class="alert alert-danger">Please fill all required fields.</div>
        <% } else if ("server".equals(error)) { %>
            <div class="alert alert-danger">Server error. Please try again.</div>
        <% } %>

        <div class="table-card">
            <form action="<%= editMode ? "updateDoctor" : "doctor" %>" method="post">
                <% if (editMode) { %>
                    <input type="hidden" name="doctorId" value="<%= doctorId %>">
                <% } %>
                <div class="row g-3">
                    
                    <div class="col-md-6">
                        <label class="form-label">Doctor Name *</label>
                        <input type="text" name="doctorName" class="form-control" value="<%= doctorName %>" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Doctor Code *</label>
                        <input type="text" name="doctorCode" class="form-control" value="<%= doctorCode %>" placeholder="DOC005" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Specialization *</label>
                        <input type="text" name="specialization" class="form-control" value="<%= specialization %>" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Qualification</label>
                        <input type="text" name="qualification" class="form-control" value="<%= qualification %>">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Experience (years)</label>
                        <input type="number" name="experience" class="form-control" value="<%= experience %>" min="0">
                    </div>
                    
                    <div class="col-md-4">
                        <label class="form-label">Phone</label>
                        <input type="tel" name="phone" class="form-control" value="<%= phone %>">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Email *</label>
                        <input type="email" name="email" class="form-control" value="<%= email %>" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Password <%= editMode ? "(leave blank to keep)" : "*" %></label>
                        <input type="password" name="password" class="form-control" <%= editMode ? "" : "required" %>>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Department *</label>
                        <input type="text" name="department" class="form-control" value="<%= department %>" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Available Days *</label>
                        <input type="text" name="availableDays" class="form-control" value="<%= availableDays %>" placeholder="Mon, Wed, Fri" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Available Time *</label>
                        <input type="text" name="availableTime" class="form-control" value="<%= availableTime %>" placeholder="09:00 AM - 01:00 PM" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Consultation Fee (Rs.)</label>
                        <input type="number" name="consultationFee" class="form-control" value="<%= consultationFee %>" min="0" step="0.01">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Status</label>
                        <select name="status" class="form-select">
                            <option value="Available" <%= "Available".equals(status) ? "selected" : "" %>>Available</option>
                            <option value="Not Available" <%= "Not Available".equals(status) ? "selected" : "" %>>Not Available</option>
                        </select>
                    </div>
                    <div class="col-12">
                        <button type="submit" class="btn btn-hospital"><i class="fas fa-save me-2"></i><%= editMode ? "Update Doctor" : "Add Doctor" %></button>
                        <a href="admin-doctors.jsp" class="btn btn-outline-secondary ms-2">Cancel</a>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/app.js"></script>
</body>
</html>
