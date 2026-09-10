<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="sidebar">
    <div class="sidebar-brand">
        <i class="fas fa-stethoscope fa-2x"></i>
        <h4>Doctor Portal</h4>
        <small>Dr. <%= session.getAttribute("userName") %></small>
    </div>
    <a href="doctor-dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
    <a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
</div>
