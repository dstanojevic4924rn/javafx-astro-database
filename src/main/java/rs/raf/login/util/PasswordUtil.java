package rs.raf.login.util;

import org.mindrot.jbcrypt.BCrypt;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class PasswordUtil {

    private static final String PASSWORD_FILE = "passwords.txt";

    //prima tekst i hešira ga u šifru
    public static String hashPassword(String plainText) {
        String hashed = BCrypt.hashpw(plainText, BCrypt.gensalt());
        savePasswordToFile(plainText, hashed);
        return hashed;
    }

    //čuva lozinku u tekstualni fajl
    private static void savePasswordToFile(String plainText, String hashed) {
        try (PrintWriter writer = new PrintWriter(new FileWriter(PASSWORD_FILE, true))) {
            String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            writer.println("[" + timestamp + "] Plain: " + plainText + " | Hashed: " + hashed);
        } catch (IOException e) {
            System.err.println("Greška pri čuvanju lozinke u fajl: " + e.getMessage());
        }
    }

    //proverava heširanu šifru
    public static boolean checkPassword(String plainText, String hashed) {
        return BCrypt.checkpw(plainText, hashed);
    }
}
