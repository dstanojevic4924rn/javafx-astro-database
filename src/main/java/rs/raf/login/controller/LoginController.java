package rs.raf.login.controller;

import javafx.application.Platform;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.control.Alert;
import javafx.scene.control.ButtonType;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import rs.raf.login.Config;
import rs.raf.login.model.User;
import rs.raf.login.model.UserDao;
import rs.raf.login.view.LoginView;
import rs.raf.login.view.MainView;
import rs.raf.login.view.RegisterView;

public class LoginController implements EventHandler<ActionEvent> {

    private final LoginView loginView;
    private final TextField loginField;
    private final TextField passwordField;
    private final Label messageLabel;

    public LoginController(LoginView loginView, TextField loginField,
                           TextField passwordField, Label messageLabel) {
        this.loginView = loginView;
        this.loginField = loginField;
        this.passwordField = passwordField;
        this.messageLabel = messageLabel;
    }

    @Override
    public void handle(ActionEvent event) {
        String login = loginField.getText().trim();
        String password = passwordField.getText();
        if (login.isEmpty() || password.isEmpty()) {
            messageLabel.setText("Unesite korisničko ime/email i lozinku.");
            return;
        }
        User user = UserDao.authenticate(Config.getConnection(), login, password);
        if (user == null) {
            messageLabel.setText("Pogrešni podaci ili korisnik ne postoji.");
            return;
        }
        loginView.close();
        new MainView(user).show();
    }
}
