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

@WebServlet("/signup")
public class SignupServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String ageStr = request.getParameter("age");
        String gender = request.getParameter("gender");
        String dob = request.getParameter("dob");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (isBlank(fullName) || isBlank(ageStr) || isBlank(gender) || isBlank(dob)
                || isBlank(phone) || isBlank(email) || isBlank(address)
                || isBlank(password) || isBlank(confirmPassword)) {
            response.sendRedirect("signup.jsp?error=required");
            return;
        }

        if (!password.equals(confirmPassword)) {
            response.sendRedirect("signup.jsp?error=password");
            return;
        }

        if (password.length() < 6) {
            response.sendRedirect("signup.jsp?error=weak");
            return;
        }

        int age;
        try {
            age = Integer.parseInt(ageStr);
        } catch (NumberFormatException ex) {
            response.sendRedirect("signup.jsp?error=age");
            return;
        }

        email = email.trim().toLowerCase();

        try (Connection con = DBConnection.getConnection()) {
            if (emailExists(con, email)) {
                response.sendRedirect("signup.jsp?error=exists");
                return;
            }

            String sql = "INSERT INTO patients (full_name, age, gender, date_of_birth, phone, email, address, password) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement pst = con.prepareStatement(sql)) {
                pst.setString(1, fullName.trim());
                pst.setInt(2, age);
                pst.setString(3, gender);
                pst.setString(4, dob);
                pst.setString(5, phone.trim());
                pst.setString(6, email);
                pst.setString(7, address.trim());
                pst.setString(8, PasswordUtil.hash(password));
                pst.executeUpdate();
            }

            response.sendRedirect("login.jsp?msg=registered");

        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect("signup.jsp?error=server");
        }
    }

    private boolean emailExists(Connection con, String email) throws Exception {
        String sql = "SELECT patient_id FROM patients WHERE email=?";
        try (PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, email);
            try (ResultSet rs = pst.executeQuery()) {
                return rs.next();
            }
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
