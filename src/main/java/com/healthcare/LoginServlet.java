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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect("login.jsp?error=invalid");
            return;
        }

        if (role == null || role.trim().isEmpty()) {
            response.sendRedirect("login.jsp?error=role");
            return;
        }

        email = email.trim().toLowerCase();
        String hashed = PasswordUtil.hash(password);

        try (Connection con = DBConnection.getConnection()) {
            HttpSession session = request.getSession(true);
            session.setMaxInactiveInterval(60 * 60);

            if ("ADMIN".equalsIgnoreCase(role)) {
                loginAdmin(con, session, email, hashed, response);
            } else if ("DOCTOR".equalsIgnoreCase(role)) {
                loginDoctor(con, session, email, hashed, response);
            } else if ("PATIENT".equalsIgnoreCase(role)) {
                loginPatient(con, session, email, hashed, response);
            } else {
                response.sendRedirect("login.jsp?error=role");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect("login.jsp?error=server");
        }
    }

    private void loginAdmin(Connection con, HttpSession session, String email,
            String hashed, HttpServletResponse response) throws Exception {

        String sql = "SELECT admin_id, username, full_name FROM admin WHERE (LOWER(email)=? OR LOWER(username)=?) AND password=?";
        try (PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, email);
            pst.setString(2, email);
            pst.setString(3, hashed);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    session.setAttribute("role", "ADMIN");
                    session.setAttribute("userId", rs.getInt("admin_id"));
                    session.setAttribute("userName", rs.getString("full_name"));
                    session.setAttribute("email", email);
                    response.sendRedirect("admin-dashboard.jsp");
                    return;
                }
            }
        }
        response.sendRedirect("login.jsp?error=invalid&role=ADMIN");
    }

    private void loginDoctor(Connection con, HttpSession session, String email,
            String hashed, HttpServletResponse response) throws Exception {

        String sql = "SELECT doctor_id, doctor_name, specialization FROM doctors WHERE LOWER(email)=? AND password=?";
        try (PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, email);
            pst.setString(2, hashed);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    session.setAttribute("role", "DOCTOR");
                    session.setAttribute("userId", rs.getInt("doctor_id"));
                    session.setAttribute("userName", rs.getString("doctor_name"));
                    session.setAttribute("specialization", rs.getString("specialization"));
                    session.setAttribute("email", email);
                    response.sendRedirect("doctor-dashboard.jsp");
                    return;
                }
            }
        }
        response.sendRedirect("login.jsp?error=invalid&role=DOCTOR");
    }

    private void loginPatient(Connection con, HttpSession session, String email,
            String hashed, HttpServletResponse response) throws Exception {

        String sql = "SELECT patient_id, full_name, phone FROM patients WHERE LOWER(email)=? AND password=?";
        try (PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, email);
            pst.setString(2, hashed);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    session.setAttribute("role", "PATIENT");
                    session.setAttribute("userId", rs.getInt("patient_id"));
                    session.setAttribute("userName", rs.getString("full_name"));
                    session.setAttribute("phone", rs.getString("phone"));
                    session.setAttribute("email", email);
                    response.sendRedirect("patient-dashboard.jsp");
                    return;
                }
            }
        }
        response.sendRedirect("login.jsp?error=invalid&role=PATIENT");
    }
}
