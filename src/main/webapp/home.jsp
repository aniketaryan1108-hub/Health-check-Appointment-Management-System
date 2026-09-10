<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.healthcare.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Health Check Appointment Management System | MediCare Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <jsp:include page="includes/public-header.jsp"/>

    <% if ("logout".equals(request.getParameter("msg"))) { %>
    
    <div class="container mt-3"><div class="alert alert-info mb-0">You have been logged out successfully.</div></div>
    <% } %>

    <section id="home" class="hero">
        <div class="container">
            <div class="row align-items-center">
                
                
                <div class="col-lg-8">
                    <span class="badge bg-light text-primary mb-3">Health Check Appointment Management System</span>
                    <h1>Welcome to MediCare Health Hospital</h1>
                    <p class="mb-4">Your trusted partner for preventive health checkups, specialist consultations, and compassionate care. Book appointments online in minutes.</p>
                    <a href="signup.jsp" class="btn btn-light btn-lg me-2 mb-2"><i class="fas fa-calendar-plus me-2"></i>Book Appointment</a>
                    <a href="login.jsp" class="btn btn-outline-light btn-lg mb-2"><i class="fas fa-sign-in-alt me-2"></i>Login</a>
                </div>
            </div>
        </div>
    </section>

    <section id="about" class="py-5">
        <div class="container">
            <div class="section-title">
                <h2>About MediCare Hospital</h2>
                <p>Excellence in healthcare since 1998</p>
            </div>
            <div class="row align-items-center g-4">
                <div class="col-lg-6">
                    <p class="lead">MediCare Health Hospital is a multi-specialty facility dedicated to preventive medicine and patient-centered care.</p>
                    <p class="text-muted">We combine modern diagnostic technology with experienced medical professionals to deliver accurate health assessments. Our online appointment system helps patients save time and access the right specialist quickly.</p>
                    <ul class="list-unstyled">
                        <li class="mb-2"><i class="fas fa-check-circle text-primary me-2"></i>NABH-aligned quality standards</li>
                        <li class="mb-2"><i class="fas fa-check-circle text-primary me-2"></i>Digital appointment &amp; records</li>
                        <li class="mb-2"><i class="fas fa-check-circle text-primary me-2"></i>Affordable consultation fees</li>
                    </ul>
                </div>
                <div class="col-lg-6">
                    
                    <div class="service-card">
                        <div class="row text-center g-3">
                            <div class="col-4"><h3 class="text-primary mb-0">50+</h3><small class="text-muted">Doctors</small></div>
                            
                            <div class="col-4"><h3 class="text-primary mb-0">10K+</h3><small class="text-muted">Patients</small></div>
                            <div class="col-4"><h3 class="text-primary mb-0">25+</h3><small class="text-muted">Departments</small></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section id="services" class="py-5 bg-white">
        <div class="container">
            <div class="section-title">
                <h2>Our Services</h2>
                <p>Comprehensive health checkup departments</p>
            </div>
            <div class="row g-4">
                <div class="col-md-6 col-lg-4">
                    <div class="service-card h-100">
                        <div class="service-icon"><i class="fas fa-stethoscope"></i></div>
                        <h5>General Checkup</h5>
                        <p class="text-muted small mb-0">Routine physical exams, vitals, and preventive health screening.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4">
                    <div class="service-card h-100">
                        <div class="service-icon"><i class="fas fa-vial"></i></div>
                        <h5>Blood Test</h5>
                        <p class="text-muted small mb-0">Complete blood count, sugar, lipid profile, and lab diagnostics.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4">
                    <div class="service-card h-100">
                        <div class="service-icon"><i class="fas fa-heartbeat"></i></div>
                        <h5>Heart Checkup</h5>
                        <p class="text-muted small mb-0">ECG, cardiac screening, and cardiology consultation.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4">
                    <div class="service-card h-100">
                        <div class="service-icon"><i class="fas fa-tooth"></i></div>
                        <h5>Dental Care</h5>
                        <p class="text-muted small mb-0">Dental hygiene, cleaning, and oral health treatment.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4">
                    <div class="service-card h-100">
                        <div class="service-icon"><i class="fas fa-eye"></i></div>
                        <h5>Eye Care</h5>
                        <p class="text-muted small mb-0">Vision tests and ophthalmology consultations.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4">
                    <div class="service-card h-100">
                        <div class="service-icon"><i class="fas fa-ambulance"></i></div>
                        <h5>Emergency Care</h5>
                        <p class="text-muted small mb-0">24/7 emergency response and critical care unit.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section id="appointment" class="py-5">
        <div class="container">
            <div class="section-title">
                <h2>Book an Appointment</h2>
                <p>Register as a patient and schedule your health checkup online</p>
            </div>
            <div class="row justify-content-center">
                <div class="col-lg-8 text-center">
                    <div class="service-card">
                        <p class="mb-4">Create your patient account, choose a department and doctor, and submit your appointment request. Admin will confirm your booking.</p>
                        <a href="signup.jsp" class="btn btn-hospital btn-lg me-2"><i class="fas fa-user-plus me-2"></i>Patient Signup</a>
                        <a href="login.jsp" class="btn btn-outline-primary btn-lg"><i class="fas fa-sign-in-alt me-2"></i>Patient Login</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section id="doctors" class="py-5 bg-white">
        <div class="container">
            <div class="section-title">
                <h2>Our Doctors</h2>
                <p>Expert specialists with years of experience</p>
            </div>
            <div class="row g-4">
                <%
                try (Connection con = DBConnection.getConnection();
                     PreparedStatement pst = con.prepareStatement(
                         "SELECT doctor_name, specialization, department, experience, "
                         + "available_days, available_time, consultation_fee, status "
                         + "FROM doctors ORDER BY department, doctor_name");
                     ResultSet rs = pst.executeQuery()) {
                    while (rs.next()) {
                        String docStatus = rs.getString("status");
                %>
                <div class="col-md-6 col-lg-3">
                    <div class="doctor-card h-100">
                        <div class="service-icon"><i class="fas fa-user-md"></i></div>
                        <h5><%= rs.getString("doctor_name") %></h5>
                        <p class="text-muted small mb-1"><%= rs.getString("specialization") %></p>
                        <p class="small mb-1"><i class="fas fa-briefcase me-1"></i><%= rs.getInt("experience") %> years experience</p>
                        <p class="small mb-1"><i class="fas fa-building me-1"></i><%= rs.getString("department") %></p>
                        <p class="small mb-1"><i class="fas fa-calendar me-1"></i><%= rs.getString("available_days") %></p>
                        <p class="small mb-2"><i class="fas fa-clock me-1"></i><%= rs.getString("available_time") %></p>
                        <p class="small mb-2"><strong>Fee:</strong> Rs. <%= rs.getDouble("consultation_fee") %></p>
                        <span class="badge <%= "Available".equalsIgnoreCase(docStatus) ? "bg-success" : "bg-secondary" %>"><%= docStatus %></span>
                    </div>
                </div>
                <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                %>
                <div class="col-12"><div class="alert alert-warning">Unable to load doctors. Please run database/healthcheck_schema.sql</div></div>
                <% } %>
            </div>
        </div>
    </section>

    <section id="contact" class="py-5">
        <div class="container">
            <div class="section-title">
                <h2>Contact Us</h2>
                <p>We are here to help you</p>
            </div>
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="service-card">
                        
                        <div class="row g-4">
                            <div class="col-md-6">
                                <h6><i class="fas fa-map-marker-alt text-primary me-2"></i>Address</h6>
                                <p class="text-muted mb-0">MediCare Hospital, Main Block, City Center, India - 400001</p>
                            </div>
                            <div class="col-md-6">
                                <h6><i class="fas fa-phone text-primary me-2"></i>Phone</h6>
                                <p class="text-muted mb-0">+91 98765 43210 | Emergency: 108</p>
                            </div>
                            <div class="col-md-6">
                                <h6><i class="fas fa-envelope text-primary me-2"></i>Email</h6>
                                <p class="text-muted mb-0">info@medicare.com | support@medicare.com</p>
                            </div>
                            <div class="col-md-6">
                                <h6><i class="fas fa-clock text-primary me-2"></i>Hours</h6>
                                <p class="text-muted mb-0">Mon - Sat: 8:00 AM - 8:00 PM | Sun: 9:00 AM - 2:00 PM</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <footer class="site-footer">
        <div class="container">
            <div class="row g-4">
                <div class="col-md-4 text-center text-md-start">
                    <h5><i class="fas fa-hospital-alt me-2"></i>MediCare Health Hospital</h5>
                    <p class="small mb-0">Health Check Appointment Management System</p>
                </div>
                <div class="col-md-4 text-center">
                    <h6>Quick Links</h6>
                    <a href="home.jsp#services" class="d-block small">Services</a>
                    <a href="signup.jsp" class="d-block small">Appointment</a>
                    <a href="login.jsp" class="d-block small">Login</a>
                </div>
                <div class="col-md-4 text-center text-md-end">
                    <p class="small mb-0">&copy; 2026 MediCare Health Hospital. All rights reserved.</p>
                
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/app.js"></script>
</body>
</html>
