package rs.raf.login.model;

public class User {
    private final int id;
    private final String username;
    private final String email;
    private final boolean external;
    private int researcherId = -1; // -1 nije selektovan istrazivac

    public User(int id, String username, String email) {
        this(id, username, email, false);
    }

    public User(int id, String username, String email, boolean external) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.external = external;
    }

    public int getId() { return id; }
    public String getUsername() { return username; }
    public String getEmail() { return email; }
    public boolean isExternal() { return external; }

    public int getResearcherId() { return researcherId; }
    public void setResearcherId(int researcherId) { this.researcherId = researcherId; }
    public boolean hasResearcher() { return researcherId > 0; }
}
