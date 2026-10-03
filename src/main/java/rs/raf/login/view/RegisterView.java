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
import rs.raf.login.controller.RegisterController;

public class RegisterView extends Stage {

    private final TextField tfUsername = new TextField();
    private final TextField tfEmail = new TextField();
    private final PasswordField pfPassword = new PasswordField();
    private final PasswordField pfConfirm = new PasswordField();
    private final Button btRegister = new Button("Kreiraj nalog");
    private final Button btBack = new Button("Nazad na prijavu");
    private final Label lblMessage = new Label();

    public RegisterView() {
        GridPane grid = new GridPane();
        grid.setPadding(new Insets(20));
        grid.setVgap(10);
        grid.setHgap(10);
        grid.setAlignment(Pos.CENTER);
        grid.addRow(0, new Label("Korisničko ime:"), tfUsername);
        grid.addRow(1, new Label("Email:"), tfEmail);
        grid.addRow(2, new Label("Lozinka:"), pfPassword);
        grid.addRow(3, new Label("Potvrdi lozinku:"), pfConfirm);
        grid.add(btRegister, 1, 4);
        grid.add(btBack, 1, 5);

        VBox root = new VBox(15, grid, lblMessage);
        root.setAlignment(Pos.CENTER);
        Scene scene = new Scene(root, 450, 350);
        setTitle("LoginUI - Registracija");
        setScene(scene);

        RegisterController controller = new RegisterController(this, tfUsername, tfEmail,
                pfPassword, pfConfirm, lblMessage);
        btRegister.setOnAction(controller);
        btBack.setOnAction(e -> {
            close();
            new LoginView().show();
        });
    }
}