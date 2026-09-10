package com.healthcare;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/doctor")
public class DoctorServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String doctorName = request.getParameter("doctorName");
        String doctorCode = request.getParameter("doctorCode");
        String specialization = request.getParameter("specialization");
        String qualification = request.getParameter("qualification");
        String experienceStr = request.getParameter("experience");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String department = request.getParameter("department");
        String availableDays = request.getParameter("availableDays");
        String availableTime = request.getParameter("availableTime");
        String feeStr = request.getParameter("consultationFee");
        String status = request.getParameter("status");

        if (isBlank(doctorName) || isBlank(doctorCode) || isBlank(specialization)
                || isBlank(email) || isBlank(password) || isBlank(department)
                || isBlank(availableDays) || isBlank(availableTime)) {
            response.sendRedirect("admin-doctor-form.jsp?error=required");
            return;
        }

        int experience = parseInt(experienceStr, 0);
        double fee = parseDouble(feeStr, 500);
        if (status == null || status.trim().isEmpty()) {
            status = "Available";
        }

        try (Connection con = DBConnection.getConnection()) {
            String sql = "INSERT INTO doctors (doctor_code, doctor_name, specialization, qualification, "
                    + "experience, phone, email, password, department, available_days, available_time, "
                    + "consultation_fee, status) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";

            try (PreparedStatement pst = con.prepareStatement(sql)) {
                pst.setString(1, doctorCode.trim().toUpperCase());
                pst.setString(2, doctorName.trim());
                pst.setString(3, specialization.trim());
                pst.setString(4, qualification != null ? qualification.trim() : "");
                pst.setInt(5, experience);
                pst.setString(6, phone != null ? phone.trim() : "");
                pst.setString(7, email.trim().toLowerCase());
                pst.setString(8, PasswordUtil.hash(password));
                pst.setString(9, department.trim());
                pst.setString(10, availableDays.trim());
                pst.setString(11, availableTime.trim());
                pst.setDouble(12, fee);
                pst.setString(13, status);
                pst.executeUpdate();
            }

            response.sendRedirect("admin-doctors.jsp?msg=added");

        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect("admin-doctor-form.jsp?error=server");
        }
    }

    private int parseInt(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (Exception ex) {
            return defaultValue;
        }
    }

    private double parseDouble(String value, double defaultValue) {
        try {
            return Double.parseDouble(value);
        } catch (Exception ex) {
            return defaultValue;
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
