package com.healthcare;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/bookAppointment")
public class AppointmentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"PATIENT".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int patientId = (Integer) session.getAttribute("userId");
        String patientName = request.getParameter("patientName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String department = request.getParameter("department");
        String doctorIdStr = request.getParameter("doctorId");
        String appointmentDate = request.getParameter("appointmentDate");
        String appointmentTime = request.getParameter("appointmentTime");
        String symptoms = request.getParameter("symptoms");

        if (isBlank(patientName) || isBlank(phone) || isBlank(email) || isBlank(department)
                || isBlank(doctorIdStr) || isBlank(appointmentDate) || isBlank(appointmentTime)) {
            response.sendRedirect("patient-book.jsp?error=required");
            return;
        }

        int doctorId;
        try {
            doctorId = Integer.parseInt(doctorIdStr);
        } catch (NumberFormatException ex) {
            response.sendRedirect("patient-book.jsp?error=doctor");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            String doctorSql = "SELECT consultation_fee, status FROM doctors WHERE doctor_id=?";
            double fee = 0;
            String status = "Not Available";

            try (PreparedStatement doctorPst = con.prepareStatement(doctorSql)) {
                doctorPst.setInt(1, doctorId);
                try (ResultSet rs = doctorPst.executeQuery()) {
                    if (!rs.next()) {
                        response.sendRedirect("patient-book.jsp?error=doctor");
                        return;
                    }
                    fee = rs.getDouble("consultation_fee");
                    status = rs.getString("status");
                }
            }

            if (!"Available".equalsIgnoreCase(status)) {
                response.sendRedirect("patient-book.jsp?error=unavailable");
                return;
            }

            String sql = "INSERT INTO appointments (patient_id, doctor_id, patient_name, phone, email, "
                    + "department, appointment_date, appointment_time, symptoms, status, consultation_fee) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'Pending', ?)";

            try (PreparedStatement pst = con.prepareStatement(sql)) {
                pst.setInt(1, patientId);
                pst.setInt(2, doctorId);
                pst.setString(3, patientName.trim());
                pst.setString(4, phone.trim());
                pst.setString(5, email.trim().toLowerCase());
                pst.setString(6, department);
                pst.setString(7, appointmentDate);
                pst.setString(8, appointmentTime);
                pst.setString(9, symptoms != null ? symptoms.trim() : "");
                pst.setDouble(10, fee);
                pst.executeUpdate();
            }

            response.sendRedirect("patient-status.jsp?msg=booked");

        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect("patient-book.jsp?error=server");
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
