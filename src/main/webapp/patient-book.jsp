<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.healthcare.DBConnection" %>
<%
if (session.getAttribute("role") == null || !"PATIENT".equals(session.getAttribute("role"))) {
    response.sendRedirect("login.jsp");
    return;
}
int patientId = (Integer) session.getAttribute("userId");
String defaultName = (String) session.getAttribute("userName");
String defaultEmail = session.getAttribute("email") != null ? (String) session.getAttribute("email") : "";
String defaultPhone = session.getAttribute("phone") != null ? (String) session.getAttribute("phone") : "";
try (Connection con = DBConnection.getConnection();
     PreparedStatement pst = con.prepareStatement("SELECT full_name, email, phone FROM patients WHERE patient_id=?")) {
    pst.setInt(1, patientId);
    try (ResultSet rs = pst.executeQuery()) {
        if (rs.next()) {
            defaultName = rs.getString("full_name");
            defaultEmail = rs.getString("email");
            defaultPhone = rs.getString("phone");
        }
    }
} catch (Exception e) {
    e.printStackTrace();
}
String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment | MediCare Health Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="dashboard-layout">
    <jsp:include page="includes/patient-sidebar.jsp"/>
    
    <div class="dashboard-content">
        <h2 class="mb-1"><i class="fas fa-calendar-plus me-2"></i>Book Appointment</h2>
        <p class="text-muted mb-4">Select department and doctor, then choose date and time</p>

        <% if ("booked".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Appointment booked successfully! Awaiting admin approval.</div>
        <% } else if ("required".equals(error)) { %>
            <div class="alert alert-danger">Please fill all required fields.</div>
        <% } else if ("doctor".equals(error)) { %>
            <div class="alert alert-danger">Invalid doctor selected.</div>
        <% } else if ("unavailable".equals(error)) { %>
            <div class="alert alert-warning">Selected doctor is not available. Choose another doctor.</div>
        <% } else if ("server".equals(error)) { %>
            <div class="alert alert-danger">Server error. Please try again later.</div>
        <% } %>

        <div class="table-card">
            <form action="bookAppointment" method="post">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Patient Name</label>
                        <input type="text" name="patientName" class="form-control" value="<%= defaultName %>" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Phone</label>
                        <input type="tel" name="phone" class="form-control" value="<%= defaultPhone %>" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" class="form-control" value="<%= defaultEmail %>" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Department</label>
                        <select name="department" id="department" class="form-select" required>
                            <option value="">Select Department</option>
                            <%
                            try (Connection con = DBConnection.getConnection();
                                 Statement st = con.createStatement();
                                 ResultSet rs = st.executeQuery(
                                     "SELECT DISTINCT department FROM doctors ORDER BY department")) {
                                while (rs.next()) {
                                    String dept = rs.getString("department");
                            %>
                            <option value="<%= dept %>"><%= dept %></option>
                            <%  }
                            } catch (Exception e) { e.printStackTrace(); } %>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Doctor</label>
                        <select name="doctorId" id="doctorId" class="form-select" required>
                            <option value="">Select Doctor</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Appointment Date</label>
                        <input type="date" name="appointmentDate" class="form-control" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Appointment Time</label>
                        <input type="time" name="appointmentTime" class="form-control" required>
                    </div>
                    <div class="col-12">
                        <label class="form-label">Symptoms / Reason for Visit</label>
                        <textarea name="symptoms" class="form-control" rows="3" placeholder="Describe your symptoms or checkup reason"></textarea>
                    </div>
                    <div class="col-12">
                        <button type="submit" class="btn btn-hospital"><i class="fas fa-check me-2"></i>Submit Booking</button>
                        <a href="patient-dashboard.jsp" class="btn btn-outline-secondary ms-2">Cancel</a>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script>
    window.doctorsData = [
    <%
    boolean first = true;
    try (Connection con = DBConnection.getConnection();
         Statement st = con.createStatement();
         ResultSet rs = st.executeQuery(
             "SELECT doctor_id, doctor_name, department, specialization, consultation_fee, status FROM doctors")) {
        while (rs.next()) {
            if (!first) { %>,<% }
            first = false;
            String dName = rs.getString("doctor_name").replace("\\", "\\\\").replace("\"", "\\\"");
            String dDept = rs.getString("department").replace("\\", "\\\\").replace("\"", "\\\"");
            String dSpec = rs.getString("specialization").replace("\\", "\\\\").replace("\"", "\\\"");
            String dStatus = rs.getString("status");
    %>
    {id:<%= rs.getInt("doctor_id") %>,name:"<%= dName %>",department:"<%= dDept %>",specialization:"<%= dSpec %>",fee:<%= rs.getDouble("consultation_fee") %>,status:"<%= dStatus %>"}
    <%  }
    } catch (Exception e) { e.printStackTrace(); } %>
    ];
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/app.js"></script>
</body>
</html>
