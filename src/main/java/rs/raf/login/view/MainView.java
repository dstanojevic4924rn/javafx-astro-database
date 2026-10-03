package rs.raf.login.view;

import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.*;
import javafx.stage.Stage;
import rs.raf.login.controller.MainController;
import rs.raf.login.model.User;

public class MainView extends Stage {

    private final User user;
    private final Label lblWelcome = new Label();

    private final ListView<String> labsList = new ListView<>();
    private final Label lblLabs = new Label("Laboratorije (kliknite da vidite istraživače):");

    private final TableView<String[]> researchersTable = new TableView<>();
    private final Label lblResearchers = new Label("Istraživači u laboratoriji:");

    private final Button btSelectResearcher = new Button("Postani ovaj istraživač");
    private final Label lblSelectedResearcher = new Label();

    private final Button btShowStats = new Button("Prikaži statistiku");
    private final VBox statsBox = new VBox(5);
    private final ScrollPane statsScroll = new ScrollPane(statsBox);

    private final Button btChangePass = new Button("Promeni lozinku");
    private final Button btChangeUser = new Button("Promeni korisničko ime");
    private final Button btDelete = new Button("Obriši nalog");
    private final Button btLogout = new Button("Odjavi se");
    private final Label lblMessage = new Label();

    public MainView(User user) {
        this.user = user;

        lblWelcome.setText("Dobrodošli, " + user.getUsername() + "!");
        lblWelcome.setStyle("-fx-font-size: 16px; -fx-font-weight: bold;");

        labsList.setPrefHeight(200);
        labsList.setPrefWidth(350);
        lblLabs.setStyle("-fx-font-weight: bold;");

        researchersTable.setPrefHeight(200);
        researchersTable.setPlaceholder(new Label("Izaberite laboratoriju"));
        lblResearchers.setStyle("-fx-font-weight: bold;");

        btSelectResearcher.setDisable(true);

        lblSelectedResearcher.setStyle("-fx-font-size: 14px; -fx-font-weight: bold;");
        if (user.hasResearcher()) {
            lblSelectedResearcher.setText("Trenutni istraživač ID: " + user.getResearcherId());
        } else {
            lblSelectedResearcher.setText("Niste izabrali istraživača");
        }

        btShowStats.setDisable(true);

        statsScroll.setPrefHeight(250);
        statsScroll.setPrefWidth(750);
        statsScroll.setFitToWidth(true);
        statsBox.setPadding(new Insets(10));
        statsBox.setStyle("-fx-background-color: #f5f5f5;");

        VBox labsBox = new VBox(5, lblLabs, labsList);
        labsBox.setPadding(new Insets(10));
        labsBox.setPrefWidth(380);

        VBox researchersBox = new VBox(5, lblResearchers, researchersTable, btSelectResearcher, lblSelectedResearcher, btShowStats);
        researchersBox.setPadding(new Insets(10));
        researchersBox.setPrefWidth(380);

        HBox centerBox = new HBox(15, labsBox, researchersBox);
        centerBox.setAlignment(Pos.CENTER);

        HBox accountBox = new HBox(10, btChangePass, btChangeUser, btDelete, btLogout);
        accountBox.setAlignment(Pos.CENTER);
        accountBox.setPadding(new Insets(10));

        Label lblStatsTitle = new Label("Statistika istraživača:");
        lblStatsTitle.setStyle("-fx-font-weight: bold; -fx-font-size: 14px;");

        VBox root = new VBox(15, lblWelcome, centerBox, lblStatsTitle, statsScroll, accountBox, lblMessage);
        root.setAlignment(Pos.CENTER);
        root.setPadding(new Insets(20));

        Scene scene = new Scene(root, 850, 750);
        setTitle("LoginUI - Astro Laboratorije");
        setScene(scene);

        MainController controller = new MainController(this, user, lblMessage);

        labsList.setOnMouseClicked(e -> {
            String selected = labsList.getSelectionModel().getSelectedItem();
            if (selected != null) {
                controller.showResearchersForLab(selected);
            }
        });

        btSelectResearcher.setOnAction(e -> controller.selectResearcher());
        btShowStats.setOnAction(e -> controller.showStatistics());
        btChangePass.setOnAction(e -> controller.showChangePassword());
        btChangeUser.setOnAction(e -> controller.showChangeUsername());
        btDelete.setOnAction(e -> controller.showDeleteAccount());
        btLogout.setOnAction(e -> controller.logout());
    }

    public User getUser() { return user; }
    public ListView<String> getLabsList() { return labsList; }
    public TableView<String[]> getResearchersTable() { return researchersTable; }
    public Label getLblResearchers() { return lblResearchers; }
    public Button getBtSelectResearcher() { return btSelectResearcher; }
    public Label getLblSelectedResearcher() { return lblSelectedResearcher; }
    public Button getBtShowStats() { return btShowStats; }
    public VBox getStatsBox() { return statsBox; }
    public Label getLblMessage() { return lblMessage; }
}
