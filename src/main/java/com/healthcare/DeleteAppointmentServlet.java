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

@WebServlet("/deleteAppointment")
public class DeleteAppointmentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect("admin-appointments.jsp");
            return;
        }

        try (Connection con = DBConnection.getConnection();
                PreparedStatement pst = con.prepareStatement("DELETE FROM appointments WHERE appointment_id=?")) {
            pst.setInt(1, Integer.parseInt(idStr));
            pst.executeUpdate();
            response.sendRedirect("admin-appointments.jsp?msg=deleted");
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect("admin-appointments.jsp?error=delete");
        }
    }
}
