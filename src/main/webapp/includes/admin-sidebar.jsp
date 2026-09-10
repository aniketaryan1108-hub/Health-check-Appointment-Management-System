<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String currentPage = request.getRequestURI();
%>
<div class="sidebar">
    <div class="sidebar-brand">
        <i class="fas fa-hospital fa-2x"></i>
        <h4>MediCare Admin</h4>
        <small><%= session.getAttribute("userName") %></small>
    </div>
    <a href="admin-dashboard.jsp" class="<%= currentPage.contains("admin-dashboard") ? "active" : "" %>">
        <i class="fas fa-tachometer-alt"></i> Dashboard
    </a>
    <a href="admin-patients.jsp" class="<%= currentPage.contains("admin-patients") ? "active" : "" %>">
        <i class="fas fa-users"></i> Patients
    </a>
    <a href="admin-doctors.jsp" class="<%= currentPage.contains("admin-doctor") ? "active" : "" %>">
        <i class="fas fa-user-md"></i> Doctors
    </a>
    <a href="admin-appointments.jsp" class="<%= currentPage.contains("admin-appointments") ? "active" : "" %>">
        <i class="fas fa-calendar-check"></i> Appointments
    </a>
    <a href="admin-payments.jsp" class="<%= currentPage.contains("admin-payments") ? "active" : "" %>">
        <i class="fas fa-rupee-sign"></i> Payments
    </a>
    <a href="home.jsp"><i class="fas fa-home"></i> Public Home</a>
    <a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
</div>
