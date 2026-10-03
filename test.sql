CREATE DATABASE test_db;
USE test_db;

CREATE TABLE greetings (
	id INT PRIMARY KEY,
	message VARCHAR(255)
    );

INSERT INTO greetings (id, message)
VALUES (1, 'Hello World');

SELECT message FROM greetings

