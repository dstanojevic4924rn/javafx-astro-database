package rs.raf.login.model;

import rs.raf.login.util.PasswordUtil;
import java.io.*;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;

public class UserDao {

    private static final String USERS_FILE = "users.txt";
    private static final Map<String, UserData> users = new HashMap<>();
    private static int nextId = 1;
    private static boolean loaded = false;

    // Inner class to hold user data including researcher assignment
    private static class UserData {
        String password;
        int researcherId;

        UserData(String password) {
            this.password = password;
            this.researcherId = -1; // -1 means no researcher assigned
        }

        UserData(String password, int researcherId) {
            this.password = password;
            this.researcherId = researcherId;
        }
    }

    private static void loadUsers() {
        if (loaded) return;
        File file = new File(USERS_FILE);
        if (file.exists()) {
            try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    line = line.trim();
                    if (line.isEmpty() || line.startsWith("#")) continue;
                    // Format: username:password:researcherId
                    String[] parts = line.split(":", 3);
                    if (parts.length >= 2) {
                        String username = parts[0];
                        String password = parts[1];
                        int researcherId = -1;
                        if (parts.length == 3) {
                            try {
                                researcherId = Integer.parseInt(parts[2]);
                            } catch (NumberFormatException e) {
                                researcherId = -1;
                            }
                        }
                        users.put(username, new UserData(password, researcherId));
                    }
                }
            } catch (IOException e) {
                System.err.println("Greška pri učitavanju korisnika: " + e.getMessage());
            }
        }
        // Ensure default external user exists
        if (!users.containsKey("eksterni")) {
            users.put("eksterni", new UserData("eksterni123"));
        }
        loaded = true;
    }

    private static void saveUsers() {
        try (PrintWriter writer = new PrintWriter(new FileWriter(USERS_FILE))) {
            writer.println("# Korisnici - format: username:password:researcherId");
            writer.println("# researcherId = -1 means no researcher assigned");
            for (Map.Entry<String, UserData> entry : users.entrySet()) {
                UserData data = entry.getValue();
                writer.println(entry.getKey() + ":" + data.password + ":" + data.researcherId);
            }
        } catch (IOException e) {
            System.err.println("Greška pri čuvanju korisnika: " + e.getMessage());
        }
    }

    public static boolean createUser(Connection conn, String username, String email, String password) {
        loadUsers();
        if (users.containsKey(username)) {
            return false; // već postoji
        }
        String hashed = PasswordUtil.hashPassword(password);
        users.put(username, new UserData(password));
        saveUsers();
        return true;
    }

    public static User authenticate(Connection conn, String login, String password) {
        if (conn == null) {
            System.err.println("Database connection is null. Cannot authenticate.");
            return null;
        }

        loadUsers();
        UserData data = users.get(login);
        if (data != null && data.password.equals(password)) {
            User user = new User(nextId++, login, login + "@raf.rs", true);
            // Restore researcher assignment if exists
            if (data.researcherId > 0) {
                user.setResearcherId(data.researcherId);
            }
            return user;
        }
        return null;
    }

    public static String getPasswordForUser(String username) {
        loadUsers();
        UserData data = users.get(username);
        return data != null ? data.password : null;
    }

    public static int getResearcherIdForUser(String username) {
        loadUsers();
        UserData data = users.get(username);
        return data != null ? data.researcherId : -1;
    }

    /**
     * Assigns a researcher to a user.
     * Returns true if successful, false if researcher is already taken by another user.
     */
    public static boolean assignResearcher(String username, int researcherId) {
        loadUsers();

        // Check if researcher is already assigned to another user
        for (Map.Entry<String, UserData> entry : users.entrySet()) {
            if (!entry.getKey().equals(username) && entry.getValue().researcherId == researcherId) {
                System.err.println("Researcher " + researcherId + " is already assigned to user: " + entry.getKey());
                return false; // Researcher already taken
            }
        }

        UserData data = users.get(username);
        if (data == null) {
            return false;
        }

        data.researcherId = researcherId;
        saveUsers();
        return true;
    }

    public static boolean deleteUser(String username) {
        loadUsers();
        if (!users.containsKey(username)) {
            return false;
        }
        users.remove(username);
        saveUsers();
        return true;
    }

    public static boolean changePassword(String username, String newPassword) {
        loadUsers();
        if (!users.containsKey(username)) {
            return false;
        }
        String hashed = PasswordUtil.hashPassword(newPassword);
        users.get(username).password = newPassword;
        saveUsers();
        return true;
    }

    public static boolean changeUsername(String oldUsername, String newUsername) {
        loadUsers();
        if (!users.containsKey(oldUsername) || users.containsKey(newUsername)) {
            return false;
        }
        UserData data = users.get(oldUsername);
        users.remove(oldUsername);
        users.put(newUsername, data);
        saveUsers();
        return true;
    }

    /**
     * Checks if a researcher is available (not assigned to any user).
     */
    public static boolean isResearcherAvailable(int researcherId) {
        loadUsers();
        for (UserData data : users.values()) {
            if (data.researcherId == researcherId) {
                return false;
            }
        }
        return true;
    }

    /**
     * Gets the username that has a specific researcher assigned.
     * Returns null if researcher is not assigned.
     */
    public static String getUserForResearcher(int researcherId) {
        loadUsers();
        for (Map.Entry<String, UserData> entry : users.entrySet()) {
            if (entry.getValue().researcherId == researcherId) {
                return entry.getKey();
            }
        }
        return null;
    }
}
