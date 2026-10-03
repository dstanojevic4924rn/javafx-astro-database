package rs.raf.login.controller;

import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.text.Font;
import javafx.scene.text.FontWeight;
import javafx.stage.Stage;
import rs.raf.login.Config;
import rs.raf.login.model.AstroDao;
import rs.raf.login.model.User;
import rs.raf.login.model.UserDao;
import rs.raf.login.view.LoginView;
import rs.raf.login.view.MainView;

import java.util.List;

public class MainController {

    private final MainView mainView;
    private User user;
    private final Label messageLabel;

    public MainController(MainView mainView, User user, Label messageLabel) {
        this.mainView = mainView;
        this.user = user;
        this.messageLabel = messageLabel;
        loadLabs();

        // If user has a persisted researcher, show it and enable stats
        if (user.hasResearcher()) {
            String[] researcher = AstroDao.getResearcherById(Config.getConnection(), user.getResearcherId());
            if (researcher != null) {
                mainView.getLblSelectedResearcher().setText(
                        "Trenutni istraživač: " + researcher[1] + " " + researcher[2] + " (ID: " + user.getResearcherId() + ")"
                );
                mainView.getBtShowStats().setDisable(false);
            }
        }
    }

    private void loadLabs() {
        List<String[]> labs = AstroDao.getAllResearchLabs(Config.getConnection());
        for (String[] lab : labs) {
            String display = lab[0] + " - " + lab[1] + " (" + lab[2] + ") [" + lab[3] + "]";
            mainView.getLabsList().getItems().add(display);
        }
        messageLabel.setText("Učitano " + labs.size() + " laboratorija. Kliknite na laboratoriju da vidite istraživače.");
    }

    public void showResearchersForLab(String labDisplay) {
        int labId = Integer.parseInt(labDisplay.split(" - ")[0]);
        String labName = labDisplay.split(" - ")[1].split(" ")[0];

        TableView<String[]> table = mainView.getResearchersTable();
        table.getColumns().clear();
        table.getItems().clear();

        String[] columns = {"ID", "Ime", "Prezime", "Datum Rođenja", "Kvalifikacije", "Sposobnosti"};
        for (int i = 0; i < columns.length; i++) {
            final int colIndex = i;
            TableColumn<String[], String> col = new TableColumn<>(columns[i]);
            col.setCellValueFactory(cellData -> {
                String[] row = cellData.getValue();
                return new javafx.beans.property.SimpleStringProperty(
                        colIndex < row.length ? row[colIndex] : ""
                );
            });
            table.getColumns().add(col);
        }

        List<String[]> researchers = AstroDao.getResearchersByLab(Config.getConnection(), labId);
        table.getItems().addAll(researchers);

        mainView.getLblResearchers().setText("Istraživači u laboratoriji " + labName + ":");

        if (researchers.isEmpty()) {
            messageLabel.setText("Laboratorija " + labName + " nema dodeljenih istraživača.");
            mainView.getBtSelectResearcher().setDisable(true);
        } else {
            messageLabel.setText("Prikazano " + researchers.size() + " istraživača u laboratoriji "+ labName +". Izaberite istraživača i kliknite 'Postani ovaj istraživač'.");
            mainView.getBtSelectResearcher().setDisable(false);
        }
    }

    public void selectResearcher() {
        TableView<String[]> table = mainView.getResearchersTable();
        String[] selected = table.getSelectionModel().getSelectedItem();
        if (selected == null) {
            messageLabel.setStyle("-fx-text-fill: red;");
            messageLabel.setText("Prvo izaberite istraživača iz tabele!");
            return;
        }

        int researcherId = Integer.parseInt(selected[0]);
        String firstName = selected[1];
        String lastName = selected[2];

        // Check if user already has this researcher
        if (user.hasResearcher() && user.getResearcherId() == researcherId) {
            messageLabel.setStyle("-fx-text-fill: orange;");
            messageLabel.setText("Već ste izabrali ovog istraživača!");
            return;
        }

        // Check if researcher is already taken by another user
        if (!UserDao.isResearcherAvailable(researcherId)) {
            String otherUser = UserDao.getUserForResearcher(researcherId);
            messageLabel.setStyle("-fx-text-fill: red;");
            if (otherUser != null && !otherUser.equals(user.getUsername())) {
                messageLabel.setText("Istraživač " + firstName + " " + lastName + " je već dodeljen korisniku: " + otherUser);
            } else {
                messageLabel.setText("Istraživač " + firstName + " " + lastName + " je već zauzet!");
            }
            return;
        }

        // If user already has a different researcher, release it first
        if (user.hasResearcher() && user.getResearcherId() != researcherId) {
            // Release old researcher (set to -1 for this user)
            UserDao.assignResearcher(user.getUsername(), -1);
        }

        // Assign new researcher
        boolean assigned = UserDao.assignResearcher(user.getUsername(), researcherId);
        if (!assigned) {
            messageLabel.setStyle("-fx-text-fill: red;");
            messageLabel.setText("Greška pri dodeli istraživača. Pokušajte ponovo.");
            return;
        }

        user.setResearcherId(researcherId);
        mainView.getLblSelectedResearcher().setText("Trenutni istraživač: " + firstName + " " + lastName + " (ID: " + researcherId + ")");
        mainView.getBtShowStats().setDisable(false);
        messageLabel.setStyle("-fx-text-fill: green;");
        messageLabel.setText("Uspešno ste postali istraživač: " + firstName + " " + lastName + "! Kliknite 'Prikaži statistiku' za detalje.");
    }

    public void showStatistics() {
        if (!user.hasResearcher()) {
            messageLabel.setStyle("-fx-text-fill: red;");
            messageLabel.setText("Prvo izaberite istraživača!");
            return;
        }

        VBox statsBox = mainView.getStatsBox();
        statsBox.getChildren().clear();

        int researcherId = user.getResearcherId();
        String[] researcher = AstroDao.getResearcherById(Config.getConnection(), researcherId);

        if (researcher == null) {
            statsBox.getChildren().add(new Label("Istraživač nije pronađen u bazi."));
            return;
        }

        Label lblBasic = createSectionLabel("Osnovni podaci");
        statsBox.getChildren().add(lblBasic);
        statsBox.getChildren().add(createInfoRow("ID:", researcher[0]));
        statsBox.getChildren().add(createInfoRow("Ime:", researcher[1]));
        statsBox.getChildren().add(createInfoRow("Prezime:", researcher[2]));
        statsBox.getChildren().add(createInfoRow("Datum rođenja:", researcher[3]));
        statsBox.getChildren().add(createInfoRow("Kvalifikacije:", researcher[4]));
        statsBox.getChildren().add(createInfoRow("Sposobnosti:", researcher[5]));

        String[] designerInfo = AstroDao.getDesignerInfo(Config.getConnection(), researcherId);
        if (designerInfo != null) {
            statsBox.getChildren().add(new Label(" "));
            Label lblDesigner = createSectionLabel("Podaci o dizajneru");
            statsBox.getChildren().add(lblDesigner);
            statsBox.getChildren().add(createInfoRow("Metoda:", designerInfo[0]));
            statsBox.getChildren().add(createInfoRow("Prosečna ocena:", designerInfo[1]));
            statsBox.getChildren().add(createInfoRow("Oblast:", designerInfo[2]));
            statsBox.getChildren().add(createInfoRow("Opservatorija:", designerInfo[3]));
        }

        String[] analystInfo = AstroDao.getAnalystInfo(Config.getConnection(), researcherId);
        if (analystInfo != null) {
            statsBox.getChildren().add(new Label(" "));
            Label lblAnalyst = createSectionLabel("Podaci o analitičaru");
            statsBox.getChildren().add(lblAnalyst);
            statsBox.getChildren().add(createInfoRow("Uloga:", analystInfo[0]));
            statsBox.getChildren().add(createInfoRow("Prosečno vreme obrade:", analystInfo[1] + " min"));
            statsBox.getChildren().add(createInfoRow("Laboratorija:", analystInfo[2]));
        }

        String[] executerInfo = AstroDao.getExecuterInfo(Config.getConnection(), researcherId);
        if (executerInfo != null) {
            statsBox.getChildren().add(new Label(" "));
            Label lblExecuter = createSectionLabel("Podaci o izvršiocu");
            statsBox.getChildren().add(lblExecuter);
            statsBox.getChildren().add(createInfoRow("Titula:", executerInfo[0]));
            statsBox.getChildren().add(createInfoRow("Ekspertiza:", executerInfo[1]));
            statsBox.getChildren().add(createInfoRow("Radni sati:", executerInfo[2]));
            statsBox.getChildren().add(createInfoRow("Status izvršenja:", executerInfo[3]));
        }

        List<String[]> designedExperiments = AstroDao.getExperimentsByDesigner(Config.getConnection(), researcherId);
        if (!designedExperiments.isEmpty()) {
            statsBox.getChildren().add(new Label(" "));
            Label lblDesExp = createSectionLabel("Eksperimenti koje je dizajnirao (" + designedExperiments.size() + ")");
            statsBox.getChildren().add(lblDesExp);
            for (String[] exp : designedExperiments) {
                String status = exp[3].equals("true") ? (exp[4].equals("true") ? "✅ Završen" : "⏳ U toku") : "❌ Nevalidan";
                statsBox.getChildren().add(createInfoRow("• " + exp[1] + ":", status + " (" + exp[5] + ")"));
            }
        }

        List<String[]> analyzedExperiments = AstroDao.getExperimentsByAnalyst(Config.getConnection(), researcherId);
        if (!analyzedExperiments.isEmpty()) {
            statsBox.getChildren().add(new Label(" "));
            Label lblAnaExp = createSectionLabel("Eksperimenti koje je analizirao (" + analyzedExperiments.size() + ")");
            statsBox.getChildren().add(lblAnaExp);
            for (String[] exp : analyzedExperiments) {
                String status = exp[3].equals("true") ? (exp[4].equals("true") ? "✅ Završen" : "⏳ U toku") : "❌ Nevalidan";
                statsBox.getChildren().add(createInfoRow("• " + exp[1] + ":", status + " (" + exp[5] + ")"));
            }
        }

        List<String[]> theories = AstroDao.getTheoriesByDesigner(Config.getConnection(), researcherId);
        if (!theories.isEmpty()) {
            statsBox.getChildren().add(new Label(" "));
            Label lblTheories = createSectionLabel("Teorije povezane sa istraživačem (" + theories.size() + ")");
            statsBox.getChildren().add(lblTheories);
            for (String[] theory : theories) {
                statsBox.getChildren().add(createInfoRow("• " + theory[1] + ":", theory[2]));
            }
        }

        List<String[]> sessions = AstroDao.getSessionsByDesigner(Config.getConnection(), researcherId);
        if (!sessions.isEmpty()) {
            statsBox.getChildren().add(new Label(" "));
            Label lblSessions = createSectionLabel("Sesije (" + sessions.size() + ")");
            statsBox.getChildren().add(lblSessions);
            for (String[] session : sessions) {
                String phase = session[5] != null && !session[5].equals("null") ? "Faza " + session[5] : "Bez faze";
                String dates = session[1] + " " + session[2];
                if (session[3] != null) {
                    dates += " - " + session[3] + " " + session[4];
                }
                statsBox.getChildren().add(createInfoRow("• " + phase + ":", dates + " | Lab: " + session[6] + " | Obs: " + session[7]));
            }
        }

        // Summary
        statsBox.getChildren().add(new Label(" "));
        Label lblSummary = createSectionLabel("Rezime");
        statsBox.getChildren().add(lblSummary);
        statsBox.getChildren().add(createInfoRow("Ukupno eksperimenata (dizajner):", String.valueOf(designedExperiments.size())));
        statsBox.getChildren().add(createInfoRow("Ukupno eksperimenata (analitičar):", String.valueOf(analyzedExperiments.size())));
        statsBox.getChildren().add(createInfoRow("Ukupno teorija:", String.valueOf(theories.size())));
        statsBox.getChildren().add(createInfoRow("Ukupno sesija:", String.valueOf(sessions.size())));

        messageLabel.setStyle("-fx-text-fill: green;");
        messageLabel.setText("Statistika prikazana za istraživača: " + researcher[1] + " " + researcher[2]);
    }

    private Label createSectionLabel(String text) {
        Label label = new Label(text);
        label.setFont(Font.font("System", FontWeight.BOLD, 14));
        label.setStyle("-fx-text-fill: #333; -fx-padding: 5 0 2 0;");
        return label;
    }

    private HBox createInfoRow(String label, String value) {
        Label lbl = new Label(label);
        lbl.setFont(Font.font("System", FontWeight.BOLD, 12));
        lbl.setPrefWidth(200);
        Label val = new Label(value);
        val.setWrapText(true);
        val.setPrefWidth(500);
        HBox row = new HBox(10, lbl, val);
        row.setAlignment(Pos.CENTER_LEFT);
        return row;
    }

    public void showChangePassword() {
        Stage dialog = new Stage();
        dialog.setTitle("Promena lozinke");

        PasswordField pfOld = new PasswordField();
        PasswordField pfNew = new PasswordField();
        PasswordField pfConfirm = new PasswordField();
        Label lblMsg = new Label();

        GridPane grid = new GridPane();
        grid.setPadding(new Insets(20));
        grid.setVgap(10);
        grid.setHgap(10);
        grid.setAlignment(Pos.CENTER);
        grid.addRow(0, new Label("Stara lozinka:"), pfOld);
        grid.addRow(1, new Label("Nova lozinka:"), pfNew);
        grid.addRow(2, new Label("Potvrdi novu:"), pfConfirm);

        Button btSave = new Button("Sačuvaj");
        Button btCancel = new Button("Otkaži");

        VBox root = new VBox(15, grid, btSave, btCancel, lblMsg);
        root.setAlignment(Pos.CENTER);
        root.setPadding(new Insets(20));

        dialog.setScene(new Scene(root, 350, 280));

        btSave.setOnAction(e -> {
            String oldPass = pfOld.getText();
            String newPass = pfNew.getText();
            String confirm = pfConfirm.getText();

            if (oldPass.isEmpty() || newPass.isEmpty() || confirm.isEmpty()) {
                lblMsg.setText("Sva polja su obavezna.");
                return;
            }
            String stored = UserDao.getPasswordForUser(user.getUsername());
            if (stored == null || !stored.equals(oldPass)) {
                lblMsg.setText("Stara lozinka nije tačna.");
                return;
            }
            if (!newPass.equals(confirm)) {
                lblMsg.setText("Nove lozinke se ne poklapaju.");
                return;
            }
            if (newPass.length() < 3) {
                lblMsg.setText("Lozinka mora imati bar 3 karaktera.");
                return;
            }
            boolean ok = UserDao.changePassword(user.getUsername(), newPass);
            if (ok) {
                lblMsg.setStyle("-fx-text-fill: green;");
                lblMsg.setText("Lozinka uspešno promenjena!");
                pfOld.clear();
                pfNew.clear();
                pfConfirm.clear();
            } else {
                lblMsg.setStyle("-fx-text-fill: red;");
                lblMsg.setText("Greška pri promeni lozinke.");
            }
        });

        btCancel.setOnAction(e -> dialog.close());
        dialog.show();
    }

    public void showChangeUsername() {
        Stage dialog = new Stage();
        dialog.setTitle("Promena korisničkog imena");

        TextField tfNew = new TextField();
        PasswordField pfPass = new PasswordField();
        Label lblMsg = new Label();

        GridPane grid = new GridPane();
        grid.setPadding(new Insets(20));
        grid.setVgap(10);
        grid.setHgap(10);
        grid.setAlignment(Pos.CENTER);
        grid.addRow(0, new Label("Novo korisničko ime:"), tfNew);
        grid.addRow(1, new Label("Lozinka:"), pfPass);

        Button btSave = new Button("Sačuvaj");
        Button btCancel = new Button("Otkaži");

        VBox root = new VBox(15, grid, btSave, btCancel, lblMsg);
        root.setAlignment(Pos.CENTER);
        root.setPadding(new Insets(20));

        dialog.setScene(new Scene(root, 350, 220));

        btSave.setOnAction(e -> {
            String newUser = tfNew.getText().trim();
            String pass = pfPass.getText();

            if (newUser.isEmpty() || pass.isEmpty()) {
                lblMsg.setText("Sva polja su obavezna.");
                return;
            }
            String stored = UserDao.getPasswordForUser(user.getUsername());
            if (stored == null || !stored.equals(pass)) {
                lblMsg.setText("Pogrešna lozinka.");
                return;
            }
            boolean ok = UserDao.changeUsername(user.getUsername(), newUser);
            if (ok) {
                lblMsg.setStyle("-fx-text-fill: green;");
                lblMsg.setText("Korisničko ime promenjeno! Prijavite se ponovo.");
                btSave.setDisable(true);
                user = new User(user.getId(), newUser, newUser + "@raf.rs", true);
            } else {
                lblMsg.setStyle("-fx-text-fill: red;");
                lblMsg.setText("Korisničko ime već postoji.");
            }
        });

        btCancel.setOnAction(e -> dialog.close());
        dialog.show();
    }

    public void showDeleteAccount() {
        Alert confirm = new Alert(Alert.AlertType.CONFIRMATION,
                "Da li ste sigurni da želite da obrišete nalog \"" + user.getUsername() + "\"?\n\n"                + "Ova akcija se ne može poništiti!",
                ButtonType.YES, ButtonType.NO);
        confirm.setTitle("Brisanje naloga");
        confirm.setHeaderText("Potvrda brisanja");

        confirm.showAndWait().ifPresent(response -> {
            if (response == ButtonType.YES) {
                boolean ok = UserDao.deleteUser(user.getUsername());
                if (ok) {
                    Alert info = new Alert(Alert.AlertType.INFORMATION,
                            "Nalog \"" + user.getUsername() + "\" je obrisan.",                            ButtonType.OK);
                    info.showAndWait();
                    mainView.close();
                    new LoginView().show();
                } else {
                    messageLabel.setStyle("-fx-text-fill: red;");
                    messageLabel.setText("Greška pri brisanju naloga.");
                }
            }
        });
    }

    public void logout() {
        mainView.close();
        new LoginView().show();
    }
}
