<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="sidebar">
    <div class="sidebar-brand">
        <i class="fas fa-user-injured fa-2x"></i>
        <h4>Patient Portal</h4>
        <small><%= session.getAttribute("userName") %></small>
    </div>
    <a href="patient-dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
    <a href="patient-book.jsp"><i class="fas fa-calendar-plus"></i> Book Appointment</a>
    <a href="patient-status.jsp"><i class="fas fa-clipboard-list"></i> Appointment Status</a>
    <a href="patient-status.jsp"><i class="fas fa-history"></i> Appointment History</a>
    <a href="patient-doctors.jsp"><i class="fas fa-user-md"></i> Doctor Availability</a>
    <a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
</div>
