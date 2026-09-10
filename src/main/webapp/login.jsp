<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | Health Check Appointment Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="login-page">
    
    
    <div class="login-card">
        <div class="login-logo"><i class="fas fa-hospital"></i></div>
        <h3 class="text-center text-primary mb-1">MediCare Hospital</h3>
        <p class="text-center text-muted mb-4">Health Check Appointment Management System</p>

        <% String error = request.getParameter("error");
           String msg = request.getParameter("msg");
           String roleParam = request.getParameter("role");
           if ("registered".equals(msg)) { %>
            <div class="alert alert-success py-2">Registration successful! Please login as <strong>Patient</strong>.</div>
        <% } else if ("logout".equals(msg)) { %>
            
            <div class="alert alert-info py-2">You have been logged out successfully.</div>
        <% } else if ("role".equals(error)) { %>
            
            <div class="alert alert-warning py-2"><strong>Please select your role</strong> (Admin, Doctor, or Patient) before login.</div>
        <% } else if ("invalid".equals(error)) { %>
            <div class="alert alert-danger py-2">Invalid email or password for selected role. Please try again.</div>
        <% } else if ("server".equals(error)) { %>
            <div class="alert alert-danger py-2">Server error. Check database connection.</div>
        <% } %>

        <form action="login" method="post" id="loginForm">
            <div class="mb-3">
                <label class="form-label">Email / User ID</label>
                <input type="text" name="email" class="form-control" placeholder="Enter email" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Password</label>
                <input type="password" name="password" class="form-control" placeholder="Enter password" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Select Role <span class="text-danger">*</span></label>
                <select name="role" id="roleSelect" class="form-select" required>
                    <option value="">-- Select Role --</option>
                    <option value="PATIENT" <%= "PATIENT".equals(roleParam) ? "selected" : "" %>>Patient</option>
                    <option value="DOCTOR" <%= "DOCTOR".equals(roleParam) ? "selected" : "" %>>Doctor</option>
                    <option value="ADMIN" <%= "ADMIN".equals(roleParam) ? "selected" : "" %>>Admin</option>
                </select>
                <small class="text-muted">Admin and Doctor must use hospital account email.</small>
            </div>
            <button type="submit" class="btn btn-hospital w-100 mb-3"><i class="fas fa-sign-in-alt me-2"></i>Login</button>
        </form>

        <div class="text-center">
            <p class="mb-1"><a href="signup.jsp">New patient? Sign up here</a></p>
            <p class="mb-2"><a href="forgot-password.jsp">Forgot password?</a></p>
            <p class="mb-0"><a href="home.jsp"><i class="fas fa-home me-1"></i>Back to Hospital Home Page</a></p>
        </div>

        <hr>
        <small class="text-muted d-block text-center">
            <strong>Demo logins (select matching role):</strong><br>
            Admin: <code>admin@medicare.com</code> / admin123<br>
            Doctor: <code>priya@medicare.com</code> / doctor123<br>
            Surgeon: <code>pankaj@medicare.com</code> / doctor123
        </small>
    </div>
    <script>
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            var role = document.getElementById('roleSelect').value;
            if (!role) {
                e.preventDefault();
                alert('Please select Admin, Doctor, or Patient role before login.');
            }
        });
    </script>
</body>
</html>
