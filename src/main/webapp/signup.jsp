<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Signup | MediCare Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="login-page">
    
    <div class="login-card" style="max-width:560px;">
        <h3 class="text-center text-primary mb-3"><i class="fas fa-user-plus me-2"></i>Patient Registration</h3>
        <% String error = request.getParameter("error");
        if ("exists".equals(error)) { %><div class="alert alert-danger py-2">Email already registered.</div><% }
        else if ("password".equals(error)) { %><div class="alert alert-danger py-2">Passwords do not match.</div><% }
        else if ("weak".equals(error)) { %><div class="alert alert-danger py-2">Password must be at least 6 characters.</div><% }
        else if ("required".equals(error)) { %><div class="alert alert-danger py-2">Please fill all required fields.</div><% } %>
        <form action="signup" method="post">
            <div class="row g-2">
                
                <div class="col-md-12"><input type="text" name="fullName" class="form-control" placeholder="Full Name" required></div>
                <div class="col-md-4"><input type="number" name="age" class="form-control" placeholder="Age" min="1" required></div>
                <div class="col-md-8">
                    <select name="gender" class="form-select" required>
                        <option value="">Gender</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
                <div class="col-md-6"><input type="date" name="dob" class="form-control" required></div>
                <div class="col-md-6"><input type="tel" name="phone" class="form-control" placeholder="Phone Number" required></div>
                <div class="col-md-12"><input type="email" name="email" class="form-control" placeholder="Email" required></div>
                <div class="col-md-12"><textarea name="address" class="form-control" placeholder="Address" rows="2" required></textarea></div>
                <div class="col-md-6"><input type="password" name="password" class="form-control" placeholder="Password" required></div>
                
                <div class="col-md-6"><input type="password" name="confirmPassword" class="form-control" placeholder="Confirm Password" required></div>
            </div>
            <button type="submit" class="btn btn-hospital w-100 mt-3">Register</button>
        </form>
        <p class="text-center mt-3 mb-0"><a href="login.jsp">Already registered? Login</a></p>
    </div>
</body>
</html>

