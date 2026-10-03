package rs.raf.login.controller;

import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.control.Label;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import rs.raf.login.Config;
import rs.raf.login.model.UserDao;
import rs.raf.login.view.RegisterView;

public class RegisterController implements EventHandler<ActionEvent> {

    private final RegisterView registerView;
    private final TextField usernameField;
    private final TextField emailField;
    private final PasswordField passwordField;
    private final PasswordField confirmField;
    private final Label messageLabel;

    public RegisterController(RegisterView registerView, TextField usernameField,
                              TextField emailField, PasswordField passwordField,
                              PasswordField confirmField, Label messageLabel) {
        this.registerView = registerView;
        this.usernameField = usernameField;
        this.emailField = emailField;
        this.passwordField = passwordField;
        this.confirmField = confirmField;
        this.messageLabel = messageLabel;
    }

    @Override
    public void handle(ActionEvent event) {
        String username = usernameField.getText().trim();
        String email = emailField.getText().trim();
        String password = passwordField.getText();
        String confirm = confirmField.getText();

        if (username.isEmpty() || email.isEmpty() || password.isEmpty() || confirm.isEmpty()) {
            messageLabel.setText("Sva polja su obavezna.");
            return;
        }
        if (!password.equals(confirm)) {
            messageLabel.setText("Lozinke se ne poklapaju.");
            return;
        }
        if (!email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            messageLabel.setText("Neispravan format email adrese.");
            return;
        }
        boolean success = UserDao.createUser(Config.getConnection(), username, email, password);
        if (success) {
            messageLabel.setStyle("-fx-text-fill: green;");
            messageLabel.setText("Registracija uspešna! Možete se prijaviti.");
            usernameField.clear();
            emailField.clear();
            passwordField.clear();
            confirmField.clear();
        } else {
            messageLabel.setStyle("-fx-text-fill: red;");
            messageLabel.setText("Korisničko ime već postoji.");
        }
    }
}
