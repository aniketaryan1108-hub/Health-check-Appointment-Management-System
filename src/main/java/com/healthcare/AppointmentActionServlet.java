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

@WebServlet("/appointmentAction")
public class AppointmentActionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        if (action == null || idStr == null) {
            redirectByRole(role, response);
            return;
        }

        int appointmentId;
        try {
            appointmentId = Integer.parseInt(idStr);
        } catch (NumberFormatException ex) {
            redirectByRole(role, response);
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            if ("ADMIN".equals(role)) {
                handleAdminAction(con, action, appointmentId, response);
            } else if ("DOCTOR".equals(role)) {
                int doctorId = (Integer) session.getAttribute("userId");
                handleDoctorAction(con, action, appointmentId, doctorId, response);
            } else {
                redirectByRole(role, response);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            redirectByRole(role, response);
        }
    }

    private void handleAdminAction(Connection con, String action, int appointmentId,
            HttpServletResponse response) throws Exception {

        if ("approve".equalsIgnoreCase(action)) {
            updateStatus(con, appointmentId, "Approved");
            createPaymentRecord(con, appointmentId);
            response.sendRedirect("admin-appointments.jsp?msg=approved");
        } else if ("reject".equalsIgnoreCase(action)) {
            updateStatus(con, appointmentId, "Rejected");
            response.sendRedirect("admin-appointments.jsp?msg=rejected");
        } else {
            response.sendRedirect("admin-appointments.jsp");
        }
    }

    private void handleDoctorAction(Connection con, String action, int appointmentId, int doctorId,
            HttpServletResponse response) throws Exception {

        if ("approve".equalsIgnoreCase(action)) {
            if (updateStatusForDoctor(con, appointmentId, doctorId, "Approved")) {
                createPaymentRecord(con, appointmentId);
                response.sendRedirect("doctor-dashboard.jsp?msg=approved");
            } else {
                response.sendRedirect("doctor-dashboard.jsp?error=notallowed");
            }
        } else if ("reject".equalsIgnoreCase(action)) {
            if (updateStatusForDoctor(con, appointmentId, doctorId, "Rejected")) {
                response.sendRedirect("doctor-dashboard.jsp?msg=rejected");
            } else {
                response.sendRedirect("doctor-dashboard.jsp?error=notallowed");
            }
        } else if ("complete".equalsIgnoreCase(action)) {
            completeAppointment(con, appointmentId, doctorId, response);
        } else {
            response.sendRedirect("doctor-dashboard.jsp");
        }
    }

    private boolean updateStatusForDoctor(Connection con, int appointmentId, int doctorId, String status)
            throws Exception {
        String sql = "UPDATE appointments SET status=? WHERE appointment_id=? AND doctor_id=? AND status='Pending'";
        try (PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, status);
            pst.setInt(2, appointmentId);
            pst.setInt(3, doctorId);
            return pst.executeUpdate() > 0;
        }
    }

    private void completeAppointment(Connection con, int appointmentId, int doctorId,
            HttpServletResponse response) throws Exception {

        String sql = "UPDATE appointments SET status='Completed' WHERE appointment_id=? AND doctor_id=? AND status='Approved'";
        try (PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, appointmentId);
            pst.setInt(2, doctorId);
            pst.executeUpdate();
        }
        response.sendRedirect("doctor-dashboard.jsp?msg=completed");
    }

    private void updateStatus(Connection con, int appointmentId, String status) throws Exception {
        String sql = "UPDATE appointments SET status=? WHERE appointment_id=?";
        try (PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, status);
            pst.setInt(2, appointmentId);
            pst.executeUpdate();
        }
    }

    private void createPaymentRecord(Connection con, int appointmentId) throws Exception {
        String selectSql = "SELECT patient_id, consultation_fee FROM appointments WHERE appointment_id=?";
        try (PreparedStatement selectPst = con.prepareStatement(selectSql)) {
            selectPst.setInt(1, appointmentId);
            try (ResultSet rs = selectPst.executeQuery()) {
                if (rs.next()) {
                    int patientId = rs.getInt("patient_id");
                    double amount = rs.getDouble("consultation_fee");

                    String insertSql = "INSERT INTO payments (appointment_id, patient_id, amount, charge_type, status) "
                            + "VALUES (?, ?, ?, 'Consultation', 'Pending')";
                    try (PreparedStatement insertPst = con.prepareStatement(insertSql)) {
                        insertPst.setInt(1, appointmentId);
                        insertPst.setInt(2, patientId);
                        insertPst.setDouble(3, amount);
                        insertPst.executeUpdate();
                    }
                }
            }
        }
    }

    private void redirectByRole(String role, HttpServletResponse response) throws IOException {
        if ("ADMIN".equals(role)) {
            response.sendRedirect("admin-dashboard.jsp");
        } else if ("DOCTOR".equals(role)) {
            response.sendRedirect("doctor-dashboard.jsp");
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}
