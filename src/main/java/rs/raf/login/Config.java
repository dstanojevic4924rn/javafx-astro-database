package rs.raf.login;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class Config {
    private static Properties properties;
    private static Connection connection;

    private static String pendingHost;
    private static String pendingPort;
    private static String pendingDb;
    private static String pendingUser;
    private static String pendingPassword;

    public static void connect(String host, String port, String db, String user, String password) {
        pendingHost = host;
        pendingPort = port;
        pendingDb = db;
        pendingUser = user;
        pendingPassword = password;

        System.out.println(" Connection parameters stored (lazy connection mode)");
    }

    private static void establishConnection() {
        if (connection != null) {
            try {
                if (!connection.isClosed()) {
                    return;
                }
            } catch (SQLException e) {
                // Connection is closed, proceed to reconnect
            }
        }

        if (pendingHost == null || pendingDb == null) {
            throw new RuntimeException("Cannot establish connection: No connection parameters stored. Call connect() first.");
        }

        // 🔴 CHANGED: Added URL parameters for better compatibility
        String url = "jdbc:mysql://" + pendingHost + ":" + pendingPort + "/" + pendingDb + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
        try {
            // 🔴 CHANGED: Added explicit driver loading
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(url, pendingUser, pendingPassword);
            System.out.println("Database connected successfully to: " + pendingDb);
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Connection failed: " + e.getMessage());
            throw new RuntimeException("Cannot connect to database. Check if MySQL is running on " + pendingHost + ":" + pendingPort, e);
        }
    }

    // 🔴 CHANGED: Added null check before closing
    public static void disconnect() {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("Database disconnected");
            } catch (SQLException e) {
                System.err.println("Error closing connection: " + e.getMessage());
            }
        }
    }

    public static void loadProperties(String cfgFile) {
        properties = new Properties();
        try (FileInputStream fileInputStream = new FileInputStream(cfgFile)) {
            properties.load(fileInputStream);
            System.out.println("✅ Loaded config from: " + cfgFile);
        } catch (IOException e) {
            throw new RuntimeException("Cannot load config file: " + cfgFile, e);
        }
    }

    public static String getPropertyValue(String property, String defaultValue) {
        return properties.getProperty(property, defaultValue);
    }

    public static boolean isConnected() {
        try {
            return connection != null && !connection.isClosed();
        } catch (SQLException e) {
            return false;
        }
    }

    public static Connection getConnection() {
        if (connection == null) {
            establishConnection();
        } else {
            try {
                if (connection.isClosed()) {
                    establishConnection();
                }
            } catch (SQLException e) {
                establishConnection();
            }
        }
        return connection;
    }

    private Config() { }
}