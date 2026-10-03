LoginUI: Astronomy Research Lab Client
LoginUI is a JavaFX desktop application that sits in front of an astronomy research database hosted in MySQL. After logging in or registering, a user browses research labs and their affiliated researchers, claims one researcher identity as their own, and the application assembles a statistics panel from that researcher's roles, experiments, theories, and work sessions. It was written as the practical component of a university databases course, so the SQL side (an 18-table schema, views, and stored procedures) is a first-class part of the project rather than a hidden backing store.

Key Features and Architecture
The application follows a classic MVC layout under rs.raf.login: view contains JavaFX Stage subclasses (LoginView, RegisterView, MainView), controller contains one controller per view, and model holds the User data class plus two DAO classes.
Startup is managed by a singleton Launcher with an explicit lifecycle: setUp loads connection parameters from a properties file passed as the first program argument, work starts the JavaFX runtime, and clean closes the JDBC connection on shutdown.
Config wraps configuration and connection handling in lazy mode: credentials are read from database.cfg, and the actual DriverManager connection is deferred until the first query, with automatic re-establishment if the connection was closed. The JDBC URL sets useSSL=false, serverTimezone=UTC, and allowPublicKeyRetrieval=true for compatibility with MySQL 8 defaults.
Data access is split by persistence type. AstroDao issues parameterized queries against the MySQL schema (labs, researchers per lab, designer/analyst/executer details, experiments, theories, sessions). UserDao manages application accounts in a plain text file users.txt with the format username:password:researcherId, seeding a default external account (eksterni) on first run.
PasswordUtil hashes passwords with BCrypt (jbcrypt) during registration and password change, and appends a timestamped record of each hash operation to passwords.txt as a local audit trail. Note that users.txt itself stores the original plaintext, which is fine for a course project but would need a real credential store before any real deployment.
The main screen implements researcher assignment as an exclusive one-to-one mapping between application users and researchers in the database. A researcher can only be claimed by one user; switching releases the previous claim, and the assignment survives restarts because it is written back to users.txt.
The statistics panel composes data across the researcher subtype tables: basic profile fields, then optional sections for the designer role (method, average rating, field, observatory), the analyst role (role, average processing time, lab), and the executer role (title, expertise, work hours, execution status), followed by designed experiments, analyzed experiments, linked theories, session history, and a summary count block.
Account management is built in: change password (with old-password verification), change username (with password confirmation), delete account (with a confirmation dialog), and logout, all returning to the login view as appropriate.
The database schema (in script.sql) models the domain with a supertype/subtype pattern: researcher as the parent and designer, analyst, and executer as specialized roles, joined to research_lab, observatory, resources, tools, theory, experiment, execution, and sesion (intentionally spelled that way since session is reserved), plus junction tables such as designer_experiment, analyst_experiment, theory_designer, and observatory_resource. The script drops and recreates all 18 tables and inserts roughly 2,150 seed rows.
queries.sql complements the schema with three reporting views (designer_experiment_summary, analyst_experiment_summary, v_high_performance_observatories) and six stored procedures (update_execution, schedule_experiment, update_session, add_tool, add_resource, delete_researcher). The remaining SQL files are ad-hoc analysis queries from development.
The UI text is in Serbian, matching the course context; class comments and commit-style markers mix Serbian and English.
Technologies Used
Java 11, set via maven.compiler.source and maven.compiler.target in pom.xml.
JavaFX 17.0.2 (org.openjfx:javafx-controls) for the entire user interface.
MySQL Connector/J 8.0.33 (mysql: mysql-connector-java) for JDBC access, with explicit loading of com.mysql.cj.jdbc.Driver.
jBCrypt 0.4 (org.mindrot:jbcrypt) for password hashing.
Maven as the build tool, with the javafx-maven-plugin 0.0.8 declared in the build section.
MySQL 8.x as the database server (schema astro).
How to Build and Run
Install the prerequisites: JDK 11 or newer, Maven 3.6 or newer, and a running MySQL 8 server.
Create and seed the database (this creates the astro schema, all 18 tables, and the seed data):

text
mysql -u root -p < script.sql
Optionally load the views and stored procedures:

text
mysql -u root -p astro < queries.sql
Edit database.cfg in the project root to match your MySQL instance:

text
host=localhost
port=3306
db=astro
user=root
password=your_password
Build the project:

text
mvn clean package
Run the application with the config file path as the first program argument. The easiest way is the exec plugin, which is not declared in the POM, so invoke it with full coordinates:

text
mvn org.codehaus.mojo:exec-maven-plugin:3.1.0:java -Dexec.mainClass=rs.raf.login.Main -Dexec.args=database.cfg
Alternatively, run it as plain Java by materializing the dependency classpath first:

text
mvn dependency:build-classpath -Dmdep.outputFile=target/cp.txt
java -cp target/classes:$(cat target/cp.txt) rs.raf.login.Main database.cfg
Log in with the default seeded account eksterni / eksterni123, or create a new account through the registration screen. Note that users.txt and passwords.txt are read and written in the working directory at runtime.
