package rs.raf.login;

import javafx.application.Application;
import javafx.stage.Stage;
import rs.raf.login.view.LoginView;

public class App extends Application {
    @Override
    public void start(Stage primaryStage) {
        new LoginView().show();
    }
}