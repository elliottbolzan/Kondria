CREATE TABLE person
(id INTEGER NOT NULL PRIMARY KEY,
name VARCHAR(256) NOT NULL,
email VARCHAR(256) NOT NULL);

CREATE TABLE messages
(id INTEGER PRIMARY KEY,
timestamp TIMESTAMP NOT NULL,
message VARCHAR(256) NOT NULL,
recipient INTEGER NOT NULL REFERENCES person(id),
sender INTEGER NOT NULL REFERENCES person(id));

CREATE TABLE referrals
(id INTEGER NOT NULL PRIMARY KEY,
FOREIGN KEY (professional_id) REFERENCES professional(id),
timestamp TIMESTAMP NOT NULL,
status BOOLEAN NOT NULL,
recipient INTEGER NOT NULL REFERENCES person(id),
sender INTEGER NOT NULL REFERENCES person(id));

CREATE TABLE education
(id INTEGER NOT NULL PRIMARY KEY,
person_id INTEGER NOT NULL,
university_name VARCHAR(256) NOT NULL,
degree_type VARCHAR(256) NOT NULL,
FOREIGN KEY (person_id) REFERENCES person(id));

CREATE TABLE professional
(id INTEGER NOT NULL PRIMARY KEY,
person_id INTEGER NOT NULL,
company VARCHAR(256) NOT NULL,
startdate TIMESTAMP NOT NULL,
enddate TIMESTAMP,
position VARCHAR(256) NOT NULL,
FOREIGN KEY (person_id) REFERENCES person(id));


