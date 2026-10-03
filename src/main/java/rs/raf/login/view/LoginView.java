package rs.raf.login.view;

import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import rs.raf.login.controller.LoginController;

public class LoginView extends Stage {

    private final TextField tfLogin = new TextField();
    private final PasswordField pfPassword = new PasswordField();
    private final Button btLogin = new Button("Prijavi se");
    private final Button btRegister = new Button("Registracija");
    private final Label lblMessage = new Label();

    public LoginView() {
        GridPane grid = new GridPane();
        grid.setPadding(new Insets(20));
        grid.setVgap(10);
        grid.setHgap(10);
        grid.setAlignment(Pos.CENTER);
        grid.addRow(0, new Label("Korisničko ime / Email:"), tfLogin);
        grid.addRow(1, new Label("Lozinka:"), pfPassword);
        grid.add(btLogin, 1, 2);
        grid.add(btRegister, 1, 3);

        VBox root = new VBox(15, grid, lblMessage);
        root.setAlignment(Pos.CENTER);
        Scene scene = new Scene(root, 400, 280);
        setTitle("LoginUI - Prijava");
        setScene(scene);

        LoginController controller = new LoginController(this, tfLogin, pfPassword, lblMessage);
        btLogin.setOnAction(controller);
        btRegister.setOnAction(e -> {
            close();
            new RegisterView().show();
        });
    }
}
