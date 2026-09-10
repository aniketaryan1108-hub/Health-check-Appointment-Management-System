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

@WebServlet("/updateDoctor")
public class UpdateDoctorServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String doctorIdStr = request.getParameter("doctorId");
        if (isBlank(doctorIdStr)) {
            response.sendRedirect("admin-doctors.jsp");
            return;
        }

        int doctorId = Integer.parseInt(doctorIdStr);
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

        int experience = parseInt(experienceStr, 0);
        double fee = parseDouble(feeStr, 500);

        try (Connection con = DBConnection.getConnection()) {
            StringBuilder sql = new StringBuilder(
                    "UPDATE doctors SET doctor_code=?, doctor_name=?, specialization=?, qualification=?, "
                            + "experience=?, phone=?, email=?, department=?, available_days=?, "
                            + "available_time=?, consultation_fee=?, status=?");

            boolean updatePassword = password != null && !password.trim().isEmpty();
            if (updatePassword) {
                sql.append(", password=?");
            }
            sql.append(" WHERE doctor_id=?");

            try (PreparedStatement pst = con.prepareStatement(sql.toString())) {
                int i = 1;
                pst.setString(i++, doctorCode.trim().toUpperCase());
                pst.setString(i++, doctorName.trim());
                pst.setString(i++, specialization.trim());
                pst.setString(i++, qualification != null ? qualification.trim() : "");
                pst.setInt(i++, experience);
                pst.setString(i++, phone != null ? phone.trim() : "");
                pst.setString(i++, email.trim().toLowerCase());
                pst.setString(i++, department.trim());
                pst.setString(i++, availableDays.trim());
                pst.setString(i++, availableTime.trim());
                pst.setDouble(i++, fee);
                pst.setString(i++, status);
                if (updatePassword) {
                    pst.setString(i++, PasswordUtil.hash(password));
                }
                pst.setInt(i, doctorId);
                pst.executeUpdate();
            }

            response.sendRedirect("admin-doctors.jsp?msg=updated");

        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect("admin-doctor-form.jsp?id=" + doctorId + "&error=server");
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
