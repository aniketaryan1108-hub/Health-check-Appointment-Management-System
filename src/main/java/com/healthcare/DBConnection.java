package com.healthcare;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {

    private static final String DEFAULT_URL =
            "jdbc:mysql://localhost:3306/healthcheckdb?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASSWORD = "aniket@2001";

    private static String url = DEFAULT_URL;
    private static String user = DEFAULT_USER;
    private static String password = DEFAULT_PASSWORD;

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            loadProperties();
        } catch (ClassNotFoundException ex) {
            throw new RuntimeException("MySQL JDBC driver not found. Add mysql-connector-j.jar to WEB-INF/lib", ex);
        }
    }

    private static void loadProperties() {
        try (InputStream in = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in == null) {
                return;
            }
            Properties props = new Properties();
            props.load(in);
            if (props.getProperty("db.url") != null) {
                url = props.getProperty("db.url");
            }
            if (props.getProperty("db.user") != null) {
                user = props.getProperty("db.user");
            }
            if (props.getProperty("db.password") != null) {
                password = props.getProperty("db.password");
            }
        } catch (Exception ex) {
            System.err.println("Using default DB settings: " + ex.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, user, password);
    }
}
