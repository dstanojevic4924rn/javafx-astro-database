-- CREATE DATABASE astro;
USE astro;

SET FOREIGN_KEY_CHECKS = 0;
SET NAMES utf8mb4;

DROP TABLE IF EXISTS researcher;
DROP TABLE IF EXISTS designer;
DROP TABLE IF EXISTS executer;
DROP TABLE IF EXISTS analyst;
DROP TABLE IF EXISTS theory;
DROP TABLE IF EXISTS theory_designer;
DROP TABLE IF EXISTS research_lab;
DROP TABLE IF EXISTS observatory;
DROP TABLE IF EXISTS resources;
DROP TABLE IF EXISTS resource_type;
DROP TABLE IF EXISTS observatory_resource;
DROP TABLE IF EXISTS tools;
DROP TABLE IF EXISTS tool_type;
DROP TABLE IF EXISTS sesion; -- session is a reserved word
DROP TABLE IF EXISTS execution;
DROP TABLE IF EXISTS experiment;
DROP TABLE IF EXISTS designer_experiment;
DROP TABLE IF EXISTS analyst_experiment;

CREATE TABLE research_lab(
	lab_id INT NOT NULL,
    name_ VARCHAR(20),
    location VARCHAR(50),
    capacity INT,
    CONSTRAINT lab_pk PRIMARY KEY (lab_id)
);

CREATE TABLE observatory(
	obs_id INT NOT NULL,
    name_ VARCHAR(20),
    location VARCHAR(50),
    capacity INT,
    CONSTRAINT obs_pk PRIMARY KEY (obs_id)
);

CREATE TABLE resources(
	res_id INT NOT NULL,
    title VARCHAR(20),
    description_ VARCHAR(50),
	stat VARCHAR(15),
    last_repair_date DATE,
    quantum_efficiency INT,
    res_type INT,
    CONSTRAINT res_pk PRIMARY KEY (res_id),
    CONSTRAINT type_fk FOREIGN KEY (res_type) REFERENCES resource_type(type_id)
);

CREATE TABLE resource_type(
	type_id INT NOT NULL,
    title VARCHAR(20),
    description_ VARCHAR(100),
    analysis VARCHAR(15),
    CONSTRAINT type_PK PRIMARY KEY (type_id)
);

CREATE TABLE observatory_resource(
	obs_id INT NOT NULL,
    res_id INT NOT NULL,
    CONSTRAINT observatory_resource_PK PRIMARY KEY (obs_id, res_id),
    CONSTRAINT or_obs_FK FOREIGN KEY (obs_id) REFERENCES observatory(obs_id),
    CONSTRAINT or_res_FK FOREIGN KEY (res_id) REFERENCES resources(res_id)
);

CREATE TABLE tools(
	tool_id INT NOT NULL,
    place_of_prod VARCHAR(40),
    lab_id INT NOT NULL,
    tool_type INT NOT NULL,
    CONSTRAINT tool_PK PRIMARY KEY (tool_id),
    FOREIGN KEY (lab_id) REFERENCES research_lab(lab_id),
    FOREIGN KEY (tool_type) REFERENCES tool_type(type_id)
);

CREATE TABLE tool_type(
	type_id INT NOT NULL,
    title VARCHAR(20),
    description_ VARCHAR(40),
    CONSTRAINT type_PK PRIMARY KEY (type_id)
);

CREATE TABLE researcher (
	researcher_id INT NOT NULL,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    dob DATE NOT NULL,
    qualifications VARCHAR(200),
    ablities VARCHAR(200),
    CONSTRAINT researcher_pk PRIMARY KEY (researcher_id)
);

CREATE TABLE designer (
	designer_id INT NOT NULL,
    method VARCHAR(50),
    average_rating DECIMAL(2,1),
    field VARCHAR(50),
    obs_id INT NOT NULL,
    CONSTRAINT designer_pk PRIMARY KEY (designer_id),
    FOREIGN KEY (designer_id) REFERENCES researcher(researcher_id)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (obs_id) REFERENCES observatory(obs_id)
);

CREATE TABLE executer (
	executer_id INT NOT NULL,
    title VARCHAR(15),
    expertise VARCHAR(50),
    work_hours INT,
    exe_id INT NOT NULL,
    CONSTRAINT executer_pk PRIMARY KEY (executer_id),
    FOREIGN KEY (executer_id) REFERENCES researcher(researcher_id)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (exe_id) REFERENCES execution(exe_id)
);

	CREATE TABLE analyst (
		anal_id INT NOT NULL,
		analyst_role VARCHAR(20),
		av_proc_time INT,
		lab_id INT NOT NULL,
		CONSTRAINT anal_pk PRIMARY KEY (anal_id),
		FOREIGN KEY (lab_id) REFERENCES research_lab(lab_id),
		FOREIGN KEY (anal_id) REFERENCES researcher(researcher_id)
			ON UPDATE CASCADE
			ON DELETE CASCADE
	);

CREATE TABLE theory(
	theory_id INT NOT NULL,
    name_ VARCHAR(10),
    description_ VARCHAR(40),
    CONSTRAINT theory_pk PRIMARY KEY (theory_id)
);

CREATE TABLE theory_designer (
	theory_id INT NOT NULL,
    designer_id INT NOT NULL,
    CONSTRAINT theory_designer_PK PRIMARY KEY (theory_id, designer_id),
    CONSTRAINT td_theory_FK FOREIGN KEY (theory_id) REFERENCES theory(theory_id),
    CONSTRAINT td_designer_FK FOREIGN KEY (designer_id) REFERENCES designer(designer_id)
);

CREATE TABLE sesion(
	session_id INT NOT NULL AUTO_INCREMENT,
    date_start DATE,
    time_start TIME,
    date_end DATE,
    time_end TIME,
    phase_ INT,
    obs_id INT,
    lab_id INT,
    CONSTRAINT date_time_PK PRIMARY KEY (session_id),
    FOREIGN KEY (obs_id) REFERENCES observatory(obs_id),
    FOREIGN KEY (lab_id) REFERENCES research_lab(lab_id)
);

CREATE TABLE execution(
	exe_id INT NOT NULL,
    exe_date DATE NOT NULL,
    stat VARCHAR(30),
    CONSTRAINT exe_pk PRIMARY KEY (exe_id),
    FOREIGN KEY (exe_id) REFERENCES observatory(obs_id)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE experiment(
	ex_id INT NOT NULL,
    title VARCHAR(30),
    desc_ VARCHAR(50),
    valid BOOLEAN,
    done BOOLEAN,
    obs_id INT NOT NULL,
    CONSTRAINT ex_pk PRIMARY KEY (ex_id),
    FOREIGN KEY (obs_id) REFERENCES execution(exe_id)
);

CREATE TABLE designer_experiment(
	designer_id INT NOT NULL,
    ex_id INT NOT NULL,
    CONSTRAINT designer_experiment_PK PRIMARY KEY (designer_id, ex_id),
    CONSTRAINT de_designer_FK FOREIGN KEY (designer_id) REFERENCES designer(designer_id),
    CONSTRAINT de_experiment_FK FOREIGN KEY (ex_id) REFERENCES experiment(ex_id)
);

CREATE TABLE analyst_experiment(
	anal_id INT NOT NULL,
    ex_id INT NOT NULL,
    CONSTRAINT analyst_experiment_PK PRIMARY KEY (anal_id, ex_id),
    CONSTRAINT ae_anal_FK FOREIGN KEY (anal_id) REFERENCES analyst(anal_id),
    CONSTRAINT ae_ex_FK FOREIGN KEY (ex_id) REFERENCES experiment(ex_id)
);

SET FOREIGN_KEY_CHECKS = 1;

-- koriscen gemini da se generisu upiti
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (1, 'BioGen Core', 'Boston, USA', 25);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (2, 'Quantum Hub', 'Zurich, Switzerland', 15);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (3, 'Cyber Shield', 'Belgrade, Serbia', 40);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (4, 'Nano Tech', 'Tokyo, Japan', 10);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (5, 'Green Energy', 'Berlin, Germany', 30);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (6, 'Deep Mind', 'London, UK', 50);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (7, 'Oceanic Lab', 'Sydney, Australia', 20);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (8, 'Aero Dynamics', 'Toulouse, France', 35);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (9, 'Genomics Unit', 'Seoul, South Korea', 45);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (10, 'Robo Works', 'Pittsburgh, USA', 12);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (11, 'Chem Reaction', 'Mumbai, India', 28);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (12, 'Arctic Study', 'Tromso, Norway', 8);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (13, 'Fusion Power', 'Oxford, UK', 60);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (14, 'Med Tech', 'Singapore, Singapore', 22);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (15, 'Climate Watch', 'Stockholm, Sweden', 18);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (16, 'Neural Net', 'San Francisco, USA', 55);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (17, 'Optic Lab', 'Jena, Germany', 14);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (18, 'Space Bio', 'Houston, USA', 20);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (19, 'Silicon Lab', 'Hsinchu, Taiwan', 100);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (20, 'Hydro Research', 'Amsterdam, Netherlands', 16);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (21, 'Solar Cells', 'Madrid, Spain', 24);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (22, 'Virus Control', 'Toronto, Canada', 33);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (23, 'Smart City', 'Vienna, Austria', 19);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (24, 'Data Mining', 'Seattle, USA', 48);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (25, 'Laser Ops', 'Prague, Czech Republic', 11);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (26, 'Bio Sphere', 'Manaus, Brazil', 40);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (27, 'Micro Chip', 'Shanghai, China', 75);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (28, 'Wind Power', 'Copenhagen, Denmark', 21);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (29, 'Soil Science', 'Nairobi, Kenya', 15);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (30, 'Deep Sea', 'San Diego, USA', 12);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (31, 'Food Safety', 'Parma, Italy', 30);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (32, 'Pure Math', 'Cambridge, UK', 20);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (33, 'Pharma Lab', 'Basel, Switzerland', 65);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (34, 'Urban Flow', 'Barcelona, Spain', 22);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (35, 'Textile Tech', 'Ghent, Belgium', 14);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (36, 'Wave Dynamics', 'Lisbon, Portugal', 17);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (37, 'Mineral Lab', 'Perth, Australia', 35);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (38, 'A.I. Ethics', 'Montreal, Canada', 25);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (39, 'Eco Systems', 'Helsinki, Finland', 18);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (40, 'Rocket Fuel', 'Cape Canaveral, USA', 45);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (41, 'Gravity Lab', 'Pisa, Italy', 10);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (42, 'Heart Tech', 'Cleveland, USA', 30);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (43, 'Cloud Comp', 'Dublin, Ireland', 80);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (44, 'Voice Tech', 'Edinburgh, UK', 15);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (45, 'Proto Lab', 'Shenzhen, China', 120);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (46, 'Secure Base', 'Brussels, Belgium', 20);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (47, 'Fusion Gen', 'Kyoto, Japan', 35);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (48, 'Plant Gene', 'Cape Town, South Africa', 28);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (49, 'Heat Flow', 'Reykjavik, Iceland', 12);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (50, 'Logic Lab', 'Athens, Greece', 20);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (51, 'Atom Split', 'Geneva, Switzerland', 55);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (52, 'Pulse Tech', 'Lyon, France', 18);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (53, 'Code Base', 'Austin, USA', 45);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (54, 'Flora Research', 'Bogota, Colombia', 14);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (55, 'Mars Colony', 'Pasadena, USA', 30);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (56, 'Seismic Unit', 'Mexico City, Mexico', 12);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (57, 'Audio Lab', 'Munich, Germany', 25);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (58, 'Magnet Core', 'Tallahassee, USA', 10);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (59, 'Solaris Lab', 'Riyadh, Saudi Arabia', 40);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (60, 'Fossil Study', 'Alberta, Canada', 22);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (61, 'Ice Core', 'Nuuk, Greenland', 6);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (62, 'Cellular Lab', 'Osaka, Japan', 32);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (63, 'Network Lab', 'Oslo, Norway', 20);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (64, 'Thermal Unit', 'Budapest, Hungary', 15);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (65, 'Drone Works', 'Dubai, UAE', 50);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (66, 'Genome Path', 'Bangkok, Thailand', 28);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (67, 'Radio Lab', 'Warsaw, Poland', 12);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (68, 'Plasma Tech', 'Daejeon, South Korea', 44);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (69, 'Heavy Metal', 'Essen, Germany', 30);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (70, 'Light Wave', 'Bordeaux, France', 16);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (71, 'Crypto Lab', 'Zug, Switzerland', 10);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (72, 'Soil Bio', 'Ames, USA', 25);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (73, 'Volcano Unit', 'Catania, Italy', 8);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (74, 'Urban Design', 'Singapore, Singapore', 40);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (75, 'Aero Space', 'Bremen, Germany', 60);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (76, 'Quantum Bits', 'Vancouver, Canada', 14);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (77, 'Nano Bio', 'Marseille, France', 22);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (78, 'Power Grid', 'Denver, USA', 35);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (79, 'Timber Tech', 'Uppsala, Sweden', 18);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (80, 'Plastic Lab', 'Leiden, Netherlands', 20);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (81, 'Wind Tunnel', 'Derby, UK', 12);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (82, 'Brain Scan', 'Baltimore, USA', 50);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (83, 'Fish Science', 'Bergen, Norway', 15);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (84, 'Static Lab', 'Graz, Austria', 10);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (85, 'Viral Lab', 'Wuhan, China', 100);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (86, 'Space X-Ray', 'Leicester, UK', 14);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (87, 'Solid State', 'Kyoto, Japan', 30);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (88, 'Mars Dust', 'Tucson, USA', 25);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (89, 'Laser Tech', 'Bristol, UK', 20);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (90, 'Deep Ice', 'McMurdo, Antarctica', 5);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (91, 'Steam Power', 'Manchester, UK', 18);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (92, 'Silicon Way', 'San Jose, USA', 90);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (93, 'Forest Lab', 'Manaus, Brazil', 45);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (94, 'Heart Lab', 'Cape Town, SA', 25);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (95, 'River Flow', 'Lyon, France', 12);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (96, 'Mining Tech', 'Johannesburg, SA', 40);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (97, 'Satellite Lab', 'Surrey, UK', 30);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (98, 'Fungi Study', 'Portland, USA', 15);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (99, 'Glacier Lab', 'Interlaken, Switzerland', 10);
INSERT INTO research_lab (lab_id, name_, location, capacity) VALUES (100, 'End Lab', 'Point Nemo, Pacific', 4);

INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (1, 'Apex Point', 'Mauna Kea, Hawaii', 12);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (2, 'Star Watch', 'Atacama Desert, Chile', 25);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (3, 'Solar Eye', 'Teide, Spain', 15);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (4, 'Galaxy View', 'Sutherland, South Africa', 20);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (5, 'Deep Space', 'Mount Stromlo, Australia', 18);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (6, 'Luna Base', 'San Pedro de Atacama, Chile', 30);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (7, 'Orion Hub', 'Kitt Peak, Arizona', 22);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (8, 'Cosmos Scan', 'La Palma, Canary Islands', 14);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (9, 'Nova Center', 'Pic du Midi, France', 10);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (10, 'Zenith Lab', 'Jungfraujoch, Switzerland', 8);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (11, 'Radio Dish', 'Arecibo, Puerto Rico', 50);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (12, 'Gamma Ray', 'Namibia High Plateau', 12);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (13, 'Polar Scope', 'Antarctica Station', 6);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (14, 'Infrared 1', 'Palomar Mountain, USA', 28);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (15, 'Sky Map', 'Roque de los Muchachos, Spain', 20);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (16, 'Titan View', 'Mount Graham, Arizona', 15);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (17, 'Nebula Lab', 'Mount Wilson, California', 12);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (18, 'Pulse Watch', 'Parkes, Australia', 40);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (19, 'Dark Matter', 'Gran Sasso, Italy', 25);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (20, 'Stellar Arc', 'Calar Alto, Spain', 18);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (21, 'Comet Track', 'Mount Abu, India', 14);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (22, 'Event Horizon', 'Green Bank, West Virginia', 35);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (23, 'Alpha Centauri', 'Cerro Tololo, Chile', 20);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (24, 'Meteor Station', 'Ennerdale, UK', 10);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (25, 'Andromeda', 'Okayama, Japan', 15);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (26, 'Black Hole', 'Shanghai, China', 30);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (27, 'Quasar Point', 'Mullard Radio, UK', 22);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (28, 'Milky Way', 'Mount Locke, Texas', 16);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (29, 'Supernova', 'La Silla, Chile', 24);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (30, 'Voyager Unit', 'Pasadena, California', 45);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (31, 'Pioneer Hub', 'Goldstone, USA', 12);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (32, 'Spectrum Lab', 'Tautenburg, Germany', 18);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (33, 'Halo Scope', 'Skinakas, Greece', 8);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (34, 'Red Giant', 'Mauna Loa, Hawaii', 20);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (35, 'White Dwarf', 'Ventspils, Latvia', 10);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (36, 'Gravity Eye', 'Hanford, Washington', 50);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (37, 'Photon Base', 'Livingston, Louisiana', 50);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (38, 'Astro Tech', 'Moscow, Russia', 25);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (39, 'Night Sky', 'Lick Observatory, USA', 15);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (40, 'Exoplanet', 'Keck, Hawaii', 30);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (41, 'Cluster View', 'Mount Hopkins, Arizona', 20);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (42, 'Mars Watch', 'Flagstaff, Arizona', 18);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (43, 'Saturn Ring', 'Siding Spring, Australia', 22);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (44, 'Venus Scan', 'Pic du Midi, France', 12);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (45, 'Jupiter Core', 'Catania, Italy', 14);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (46, 'Ice Giant', 'Urumqi, China', 10);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (47, 'Void Search', 'Socorro, New Mexico', 40);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (48, 'Signal Hub', 'Bialystok, Poland', 15);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (49, 'Flare Watch', 'Crimea, Ukraine', 20);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (50, 'Final Frontier', 'Global Space Network', 100);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (51, 'Sky Peak', 'Inverness, Scotland', 12);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (52, 'Star Light', 'Bergen, Norway', 10);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (53, 'Dark Void', 'Ouarzazate, Morocco', 30);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (54, 'Moon Gate', 'Almaty, Kazakhstan', 18);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (55, 'Cosmic Ray', 'Ooty, India', 25);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (56, 'Lens Master', 'Tokyo, Japan', 15);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (57, 'Orbit View', 'Sao Paulo, Brazil', 22);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (58, 'Solar Flare', 'Nice, France', 14);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (59, 'Astro Hub', 'Copenhagen, Denmark', 20);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (60, 'Stellar Net', 'Austin, USA', 35);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (61, 'Wave Point', 'Tromso, Norway', 8);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (62, 'Deep Sky', 'Tucson, USA', 40);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (63, 'Far Point', 'Cape Town, South Africa', 30);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (64, 'Sky Eye', 'Seoul, South Korea', 20);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (65, 'Nova Watch', 'Cordoba, Argentina', 15);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (66, 'Star Dust', 'Mendoza, Argentina', 18);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (67, 'Orion Wing', 'Boulder, USA', 25);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (68, 'Plasma View', 'Heidelberg, Germany', 12);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (69, 'Nebula Way', 'Utrecht, Netherlands', 10);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (70, 'Galaxy Gate', 'Prague, Czech Republic', 16);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (71, 'Zenith Hub', 'Milan, Italy', 20);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (72, 'Pulsar Lab', 'Jodrell Bank, UK', 60);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (73, 'Gamma View', 'Bonn, Germany', 14);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (74, 'X-Ray Scope', 'Chandra, Space', 5);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (75, 'Deep Void', 'Atacama, Chile', 45);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (76, 'Sun Watch', 'Big Bear, USA', 15);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (77, 'Earth View', 'ISS Orbit', 10);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (78, 'Sky Master', 'Vancouver, Canada', 22);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (79, 'Planetary', 'Kyoto, Japan', 18);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (80, 'Star Base', 'Huntsville, USA', 30);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (81, 'Blue Giant', 'Oslo, Norway', 12);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (82, 'Red Dwarf', 'Reykjavik, Iceland', 8);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (83, 'Comet Eye', 'Nanjing, China', 25);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (84, 'Stellar Lab', 'Moscow, Russia', 20);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (85, 'Astro Guard', 'New Delhi, India', 15);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (86, 'Space Scan', 'Bangkok, Thailand', 12);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (87, 'Void Eye', 'Santiago, Chile', 30);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (88, 'Nova Point', 'Lyon, France', 14);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (89, 'Cosmos Hub', 'Toronto, Canada', 28);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (90, 'Sky Lab', 'Stockholm, Sweden', 18);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (91, 'Orbital 1', 'Baykonur, Kazakhstan', 40);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (92, 'Dark Sky', 'Galloway, Scotland', 10);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (93, 'Horizon Point', 'Dubai, UAE', 25);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (94, 'Star Path', 'Helsinki, Finland', 15);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (95, 'Zenith View', 'Auckland, NZ', 20);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (96, 'Deep Galaxy', 'Perth, Australia', 35);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (97, 'Alpha Hub', 'Lisbon, Portugal', 12);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (98, 'Solar Station', 'Valencia, Spain', 20);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (99, 'Meteor Hub', 'Dublin, Ireland', 15);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (100, 'End Watch', 'Tasmania, Australia', 10);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (101, 'Horizon Echo', 'Atacama, Chile', 25);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (102, 'Star Gate', 'Mauna Kea, Hawaii', 15);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (103, 'Solar Flare', 'Teide, Spain', 10);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (104, 'Deep Void', 'Sutherland, South Africa', 30);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (105, 'Lunar Eye', 'San Pedro, Chile', 20);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (106, 'Nova Peak', 'Pic du Midi, France', 12);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (107, 'Galaxy Hub', 'Kitt Peak, Arizona', 40);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (108, 'Cosmos Scan', 'La Palma, Spain', 18);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (109, 'Orion Sight', 'Mount Stromlo, Australia', 22);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (110, 'Zenith Base', 'Jungfraujoch, Switzerland', 8);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (111, 'Radio Pulse', 'Arecibo, Puerto Rico', 55);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (112, 'Gamma Watch', 'Namibia Plateau', 14);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (113, 'Polar Scope', 'Antarctica Station', 6);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (114, 'Infrared Core', 'Palomar, California', 25);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (115, 'Sky Mapper', 'Roque de Muchachos', 20);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (116, 'Titan View', 'Mount Graham, Arizona', 15);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (117, 'Nebula Lab', 'Mount Wilson, USA', 10);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (118, 'Pulsar Dish', 'Parkes, Australia', 45);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (119, 'Dark Matter', 'Gran Sasso, Italy', 30);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (120, 'Stellar Arc', 'Calar Alto, Spain', 16);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (121, 'Comet Track', 'Mount Abu, India', 12);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (122, 'Event Horizon', 'Green Bank, USA', 35);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (123, 'Alpha Unit', 'Cerro Tololo, Chile', 20);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (124, 'Meteor Base', 'Exmoor, UK', 10);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (125, 'Andromeda Eye', 'Okayama, Japan', 15);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (126, 'Black Hole', 'Shanghai, China', 28);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (127, 'Quasar Point', 'Cambridge, UK', 14);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (128, 'Milky Way', 'Mount Locke, Texas', 18);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (129, 'Supernova', 'La Silla, Chile', 22);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (130, 'Voyager Hub', 'Pasadena, USA', 50);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (131, 'Pioneer Dish', 'Goldstone, USA', 12);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (132, 'Spectrum Hub', 'Tautenburg, Germany', 15);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (133, 'Halo Scope', 'Crete, Greece', 10);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (134, 'Red Giant', 'Mauna Loa, Hawaii', 18);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (135, 'White Dwarf', 'Ventspils, Latvia', 8);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (136, 'Gravity Eye', 'Hanford, USA', 40);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (137, 'Photon Base', 'Livingston, USA', 40);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (138, 'Astro Guard', 'Moscow, Russia', 25);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (139, 'Night Sky', 'Lick, USA', 14);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (140, 'Exo Scout', 'Keck, Hawaii', 30);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (141, 'Cluster Watch', 'Mount Hopkins, USA', 20);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (142, 'Mars Watch', 'Flagstaff, Arizona', 15);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (143, 'Saturn Ring', 'Siding Spring, AUS', 22);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (144, 'Venus Scan', 'Pic du Midi, FR', 12);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (145, 'Jupiter Core', 'Catania, Italy', 14);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (146, 'Ice Giant', 'Urumqi, China', 10);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (147, 'Void Search', 'Socorro, New Mexico', 45);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (148, 'Signal Hub', 'Torun, Poland', 15);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (149, 'Flare Watch', 'Crimea, Ukraine', 20);
INSERT INTO observatory (obs_id, name_, location, capacity) VALUES (150, 'Final Point', 'Tasmania, Australia', 10);

INSERT INTO tool_type (type_id, title, description_) VALUES (1, 'Drilling', 'Tools for making holes');
INSERT INTO tool_type (type_id, title, description_) VALUES (2, 'Cutting', 'Industrial cutting equipment');
INSERT INTO tool_type (type_id, title, description_) VALUES (3, 'Measuring', 'Precision measurement tools');
INSERT INTO tool_type (type_id, title, description_) VALUES (4, 'Welding', 'Metal joining equipment');
INSERT INTO tool_type (type_id, title, description_) VALUES (5, 'Grinding', 'Surface finishing tools');
INSERT INTO tool_type (type_id, title, description_) VALUES (6, 'Fastening', 'Nailers and screwdrivers');
INSERT INTO tool_type (type_id, title, description_) VALUES (7, 'Milling', 'Complex shaping tools');
INSERT INTO tool_type (type_id, title, description_) VALUES (8, 'Polishing', 'Fine surface treatment');
INSERT INTO tool_type (type_id, title, description_) VALUES (9, 'Soldering', 'Electronics assembly tools');
INSERT INTO tool_type (type_id, title, description_) VALUES (10, 'Scanning', '3D laser scanning tools');
INSERT INTO tool_type (type_id, title, description_) VALUES (11, 'Forging', 'High temperature metal tools');
INSERT INTO tool_type (type_id, title, description_) VALUES (12, 'Etching', 'Chemical surface marking');
INSERT INTO tool_type (type_id, title, description_) VALUES (13, 'Compression', 'Pneumatic force tools');
INSERT INTO tool_type (type_id, title, description_) VALUES (14, 'Extraction', 'Material removal tools');
INSERT INTO tool_type (type_id, title, description_) VALUES (15, 'Bending', 'Sheet metal forming');
INSERT INTO tool_type (type_id, title, description_) VALUES (16, 'Coating', 'Paint and spray tools');
INSERT INTO tool_type (type_id, title, description_) VALUES (17, 'Lifting', 'Heavy tool positioning');
INSERT INTO tool_type (type_id, title, description_) VALUES (18, 'Cooling', 'Thermal regulation tools');
INSERT INTO tool_type (type_id, title, description_) VALUES (19, 'Sanding', 'Wood finishing tools');
INSERT INTO tool_type (type_id, title, description_) VALUES (20, 'Testing', 'Quality control devices');

-- resource_type
INSERT INTO resource_type (type_id, title, description_, analysis) VALUES (1, 'Camera', 'Camera imaging device for celestial bodies', 'Photo');
INSERT INTO resource_type (type_id, title, description_, analysis) VALUES (2, 'Telescope', 'Optical instrument for observing distant stars', 'Photo');
INSERT INTO resource_type (type_id, title, description_, analysis) VALUES (3, 'Spectrograph', 'Splits light into spectra for analysis', 'Photo');
INSERT INTO resource_type (type_id, title, description_, analysis) VALUES (4, 'Deep-Space Antenna', 'High-gain antenna for deep-space communication', 'Radio');
INSERT INTO resource_type (type_id, title, description_, analysis) VALUES (5, 'Radio Telescope', 'Detects radio waves from astronomical sources', 'Radio');

-- resources
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (1, 'Grating Spec', 'Fiber-fed spectrograph, multi-object mode', 'offline', '2011-01-31', 39);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (2, 'Dish Array', 'VLBI-capable 25m dish, broadband backend', 'offline', '2011-04-21', 94);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (3, 'Reflector', 'Primary mirror 2.5m, alt-az mount', 'maintenance', '2019-05-19', 38);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (4, 'Reflector 2', 'Schmidt-Cassegrain 350mm, compact design', 'maintenance', '2011-04-30', 45);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (5, 'Schmidt', 'Primary mirror 2.5m, alt-az mount', 'offline', '2023-02-18', 80);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (6, 'IR Camera', 'High-resolution CCD sensor, cooled to -40C', 'offline', '2012-12-26', 67);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (7, 'DSA-23', '3-element array, 34m dishes combined', 'operational', '2022-10-21', 69);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (8, 'Horn Antenn', 'Dish array 6x12m, L-band receiver', 'offline', '2022-10-24', 54);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (9, 'Echelle Spec', 'UV spectrograph, 100-320nm wavelength range', 'offline', '2011-05-30', 37);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (10, 'Horn Antenn 2', '64-element phased array, beamforming enabled', 'offline', '2021-12-04', 84);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (11, 'Fiber Spec', 'UV spectrograph, 100-320nm wavelength range', 'maintenance', '2018-02-10', 68);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (12, 'Refractor', 'Achromatic lens 150mm, equatorial mount', 'operational', '2022-11-19', 68);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (13, 'Phased Array', 'VLBI-capable 25m dish, broadband backend', 'offline', '2020-01-25', 66);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (14, 'Dish Array 2', 'Dish array 6x12m, L-band receiver', 'offline', '2019-05-19', 51);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (15, 'Grating Spec 2', 'Fiber-fed spectrograph, multi-object mode', 'maintenance', '2010-11-18', 39);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (16, 'Log-Periodic', 'VLBI-capable 25m dish, broadband backend', 'maintenance', '2025-08-05', 74);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (17, 'Phased Array 2', 'Log-periodic antenna, 100MHz-10GHz range', 'maintenance', '2011-07-18', 41);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (18, 'Fiber Spec 2', 'Cross-dispersed echelle, R=80000', 'operational', '2026-05-26', 69);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (19, 'Phased Array 3', 'VLBI-capable 25m dish, broadband backend', 'offline', '2018-08-27', 74);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (20, 'WideField Cam', 'Ultraviolet camera for hot star observation', 'operational', '2023-09-14', 44);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (21, 'DSA-14', '23m high-gain dish, Ka-band uplink', 'maintenance', '2012-11-25', 61);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (22, 'Parabolic Ant', '2.4m diameter, lightweight parabolic reflector', 'operational', '2013-09-24', 87);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (23, 'DSN Array', 'High-gain antenna, S and X dual-band', 'operational', '2019-08-28', 65);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (24, 'HGA Dish', '2.4m diameter, lightweight parabolic reflector', 'operational', '2013-05-21', 40);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (25, 'Refractor 2', 'Achromatic lens 150mm, equatorial mount', 'offline', '2015-03-27', 31);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (26, 'DSN Array 2', '23m high-gain dish, Ka-band uplink', 'maintenance', '2016-04-28', 30);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (27, 'Dobsonian', 'Schmidt-Cassegrain 350mm, compact design', 'maintenance', '2023-09-05', 70);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (28, 'Schmidt 2', 'Schmidt-Cassegrain 350mm, compact design', 'offline', '2025-03-02', 36);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (29, 'DSN Array 3', '2.4m diameter, lightweight parabolic reflector', 'maintenance', '2018-12-13', 80);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (30, 'WideField Cam 2', 'Wide-field mosaic camera, 4-panel array', 'operational', '2014-04-11', 38);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (31, 'Dobsonian 2', 'Achromatic lens 150mm, equatorial mount', 'operational', '2017-08-17', 36);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (32, 'CCD Imager', 'Full-sky monitoring camera, fish-eye lens', 'operational', '2022-01-13', 42);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (33, 'UV Spectr', 'Cross-dispersed echelle, R=80000', 'operational', '2014-08-31', 78);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (34, 'Cassegrain', 'Ritchey-Chretien 1m, f/8 focal ratio', 'offline', '2018-03-03', 90);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (35, 'CCD Imager 2', 'Wide-field mosaic camera, 4-panel array', 'maintenance', '2020-10-10', 91);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (36, 'Echelle Spec 2', 'Transmission grating 600 l/mm, visual range', 'operational', '2017-09-07', 63);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (37, 'DSA-23 2', '3-element array, 34m dishes combined', 'operational', '2014-08-09', 97);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (38, 'Grating Spec 3', 'UV spectrograph, 100-320nm wavelength range', 'operational', '2021-11-05', 68);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (39, 'UV Camera', 'Full-sky monitoring camera, fish-eye lens', 'maintenance', '2013-09-30', 75);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (40, 'Schmidt 3', 'Schmidt-Cassegrain 350mm, compact design', 'offline', '2017-05-24', 58);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (41, 'Horn Antenn 3', 'Corrugated horn antenna, 1.4 GHz', 'maintenance', '2015-02-01', 55);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (42, 'Phased Array 4', 'VLBI-capable 25m dish, broadband backend', 'offline', '2010-08-26', 33);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (43, 'Fiber Spec 3', 'Integral field unit, 100-fiber bundle', 'operational', '2025-07-14', 74);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (44, 'HGA Dish 2', 'High-gain antenna, S and X dual-band', 'operational', '2014-12-12', 43);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (45, 'Dobsonian 3', 'Achromatic lens 150mm, equatorial mount', 'maintenance', '2014-08-02', 91);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (46, 'Log-Periodic 2', 'Dish array 6x12m, L-band receiver', 'maintenance', '2024-08-24', 74);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (47, 'CCD Imager 3', 'Wide-field mosaic camera, 4-panel array', 'offline', '2014-06-21', 91);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (48, 'Dobsonian 4', 'Ritchey-Chretien 1m, f/8 focal ratio', 'operational', '2026-03-11', 80);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (49, 'Parabolic Ant 2', '14m parabolic dish, X-band communication', 'offline', '2013-07-25', 51);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (50, 'Reflector 3', 'Achromatic lens 150mm, equatorial mount', 'offline', '2020-06-09', 48);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (51, 'Log-Periodic 3', '64-element phased array, beamforming enabled', 'offline', '2017-11-10', 49);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (52, 'Log-Periodic 4', 'Corrugated horn antenna, 1.4 GHz', 'operational', '2010-04-27', 43);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (53, 'Horn Antenn 4', '64-element phased array, beamforming enabled', 'operational', '2014-09-25', 33);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (54, 'Grating Spec 4', 'Integral field unit, 100-fiber bundle', 'offline', '2015-05-25', 71);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (55, 'UV Spectr 2', 'Fiber-fed spectrograph, multi-object mode', 'operational', '2011-05-14', 75);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (56, 'DSN Array 4', '3-element array, 34m dishes combined', 'maintenance', '2021-04-02', 46);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (57, 'Horn Antenn 5', 'Log-periodic antenna, 100MHz-10GHz range', 'offline', '2010-06-03', 86);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (58, 'Schmidt 4', 'Primary mirror 2.5m, alt-az mount', 'operational', '2013-11-12', 48);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (59, 'DSN Array 5', '14m parabolic dish, X-band communication', 'offline', '2011-05-21', 71);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (60, 'Log-Periodic 5', 'Log-periodic antenna, 100MHz-10GHz range', 'maintenance', '2012-05-19', 37);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (61, 'Refractor 3', 'Ritchey-Chretien 1m, f/8 focal ratio', 'operational', '2012-03-11', 94);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (62, 'DSN Array 6', '14m parabolic dish, X-band communication', 'operational', '2019-12-11', 71);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (63, 'Log-Periodic 6', 'Log-periodic antenna, 100MHz-10GHz range', 'offline', '2014-06-22', 65);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (64, 'DSN Array 7', '3-element array, 34m dishes combined', 'maintenance', '2021-05-22', 61);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (65, 'VLBI Dish', 'Log-periodic antenna, 100MHz-10GHz range', 'operational', '2020-01-15', 47);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (66, 'DSA-14 2', '2.4m diameter, lightweight parabolic reflector', 'maintenance', '2017-02-01', 39);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (67, 'Dobsonian 5', 'Primary mirror 2.5m, alt-az mount', 'operational', '2025-01-06', 68);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (68, 'IR Camera 2', 'Ultraviolet camera for hot star observation', 'operational', '2015-09-05', 47);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (69, 'DSA-23 3', '14m parabolic dish, X-band communication', 'maintenance', '2020-12-05', 50);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (70, 'Refractor 4', 'Manual Dobsonian 450mm, truss design', 'offline', '2019-01-22', 73);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (71, 'DSA-23 4', 'High-gain antenna, S and X dual-band', 'maintenance', '2012-01-26', 76);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (72, 'UV Camera 2', 'Full-sky monitoring camera, fish-eye lens', 'maintenance', '2019-11-18', 32);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (73, 'HGA Dish 3', '3-element array, 34m dishes combined', 'offline', '2016-08-17', 95);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (74, 'CCD Imager 4', 'Infrared imaging for thermal celestial bodies', 'operational', '2011-11-20', 63);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (75, 'Echelle Spec 3', 'Transmission grating 600 l/mm, visual range', 'maintenance', '2012-11-27', 84);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (76, 'Fiber Spec 4', 'Transmission grating 600 l/mm, visual range', 'offline', '2021-07-19', 93);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (77, 'Echelle Spec 4', 'Integral field unit, 100-fiber bundle', 'operational', '2025-06-08', 53);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (78, 'DSA-14 3', 'High-gain antenna, S and X dual-band', 'operational', '2024-03-25', 41);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (79, 'Echelle Spec 5', 'UV spectrograph, 100-320nm wavelength range', 'operational', '2011-06-30', 63);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (80, 'WideField Cam 3', 'High-resolution CCD sensor, cooled to -40C', 'maintenance', '2022-05-28', 83);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (81, 'UV Spectr 3', 'Transmission grating 600 l/mm, visual range', 'operational', '2021-10-26', 60);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (82, 'IR Camera 3', 'Ultraviolet camera for hot star observation', 'operational', '2014-01-23', 55);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (83, 'IFU Spectr', 'UV spectrograph, 100-320nm wavelength range', 'operational', '2016-07-03', 87);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (84, 'Horn Antenn 6', 'VLBI-capable 25m dish, broadband backend', 'maintenance', '2010-05-29', 62);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (85, 'CCD Imager 5', 'High-resolution CCD sensor, cooled to -40C', 'offline', '2021-05-05', 54);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (86, 'Phased Array 5', 'Corrugated horn antenna, 1.4 GHz', 'maintenance', '2012-05-20', 85);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (87, 'DSN Array 8', '2.4m diameter, lightweight parabolic reflector', 'offline', '2016-11-26', 57);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (88, 'Cassegrain 2', 'Achromatic lens 150mm, equatorial mount', 'offline', '2026-05-07', 47);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (89, 'HGA Dish 4', '14m parabolic dish, X-band communication', 'operational', '2010-04-27', 39);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (90, 'Fiber Spec 5', 'Transmission grating 600 l/mm, visual range', 'operational', '2011-11-24', 78);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (91, 'VLBI Dish 2', 'Log-periodic antenna, 100MHz-10GHz range', 'operational', '2025-07-15', 67);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (92, 'WideField Cam 4', 'Infrared imaging for thermal celestial bodies', 'operational', '2016-01-13', 87);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (93, 'UV Camera 3', 'Ultraviolet camera for hot star observation', 'maintenance', '2022-04-09', 71);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (94, 'Reflector 4', 'Ritchey-Chretien 1m, f/8 focal ratio', 'operational', '2017-12-31', 53);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (95, 'UV Camera 4', 'Wide-field mosaic camera, 4-panel array', 'operational', '2020-08-24', 65);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (96, 'Horn Antenn 7', 'Corrugated horn antenna, 1.4 GHz', 'offline', '2010-02-10', 41);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (97, 'Echelle Spec 6', 'Transmission grating 600 l/mm, visual range', 'maintenance', '2023-03-01', 35);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (98, 'DSA-14 4', 'High-gain antenna, S and X dual-band', 'maintenance', '2024-02-15', 59);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (99, 'AllSky Cam', 'Full-sky monitoring camera, fish-eye lens', 'operational', '2024-09-30', 79);
INSERT INTO resources (res_id, title, description_, stat, last_repair_date, quantum_efficiency) VALUES (100, 'Fiber Spec 6', 'Transmission grating 600 l/mm, visual range', 'maintenance', '2026-03-30', 48);

INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (1, 'Berlin, Germany', 1, 1);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (2, 'Tokyo, Japan', 1, 2);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (3, 'Seoul, South Korea', 1, 3);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (4, 'Detroit, USA', 1, 4);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (5, 'Shanghai, China', 1, 5);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (6, 'Milan, Italy', 1, 6);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (7, 'Paris, France', 1, 7);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (8, 'Belo Horizonte, Brazil', 1, 8);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (9, 'Hsinchu, Taiwan', 1, 9);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (10, 'Zurich, Switzerland', 1, 10);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (11, 'Stockholm, Sweden', 1, 11);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (12, 'Vienna, Austria', 1, 12);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (13, 'Toronto, Canada', 1, 13);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (14, 'Sydney, Australia', 1, 14);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (15, 'Mumbai, India', 1, 15);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (16, 'Barcelona, Spain', 1, 16);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (17, 'Oslo, Norway', 1, 17);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (18, 'Helsinki, Finland', 1, 18);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (19, 'Prague, Czech Republic', 1, 19);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (20, 'Brussels, Belgium', 1, 20);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (21, 'Berlin, Germany', 1, 1);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (22, 'Tokyo, Japan', 1, 2);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (23, 'Seoul, South Korea', 1, 3);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (24, 'Detroit, USA', 1, 4);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (25, 'Shanghai, China', 1, 5);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (26, 'Milan, Italy', 1, 6);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (27, 'Paris, France', 1, 7);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (28, 'Belo Horizonte, Brazil', 1, 8);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (29, 'Hsinchu, Taiwan', 1, 9);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (30, 'Zurich, Switzerland', 1, 10);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (31, 'Stockholm, Sweden', 1, 11);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (32, 'Vienna, Austria', 1, 12);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (33, 'Toronto, Canada', 1, 13);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (34, 'Sydney, Australia', 1, 14);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (35, 'Mumbai, India', 1, 15);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (36, 'Barcelona, Spain', 1, 16);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (37, 'Oslo, Norway', 1, 17);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (38, 'Helsinki, Finland', 1, 18);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (39, 'Prague, Czech Republic', 1, 19);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (40, 'Brussels, Belgium', 1, 20);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (41, 'Berlin, Germany', 1, 1);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (42, 'Tokyo, Japan', 1, 2);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (43, 'Seoul, South Korea', 1, 3);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (44, 'Detroit, USA', 1, 4);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (45, 'Shanghai, China', 1, 5);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (46, 'Milan, Italy', 1, 6);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (47, 'Paris, France', 1, 7);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (48, 'Belo Horizonte, Brazil', 1, 8);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (49, 'Hsinchu, Taiwan', 1, 9);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (50, 'Zurich, Switzerland', 1, 10);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (51, 'Stockholm, Sweden', 1, 11);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (52, 'Vienna, Austria', 1, 12);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (53, 'Toronto, Canada', 1, 13);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (54, 'Sydney, Australia', 1, 14);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (55, 'Mumbai, India', 1, 15);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (56, 'Barcelona, Spain', 1, 16);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (57, 'Oslo, Norway', 1, 17);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (58, 'Helsinki, Finland', 1, 18);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (59, 'Prague, Czech Republic', 1, 19);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (60, 'Brussels, Belgium', 1, 20);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (61, 'Berlin, Germany', 1, 1);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (62, 'Tokyo, Japan', 1, 2);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (63, 'Seoul, South Korea', 1, 3);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (64, 'Detroit, USA', 1, 4);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (65, 'Shanghai, China', 1, 5);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (66, 'Milan, Italy', 1, 6);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (67, 'Paris, France', 1, 7);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (68, 'Belo Horizonte, Brazil', 1, 8);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (69, 'Hsinchu, Taiwan', 1, 9);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (70, 'Zurich, Switzerland', 1, 10);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (71, 'Stockholm, Sweden', 1, 11);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (72, 'Vienna, Austria', 1, 12);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (73, 'Toronto, Canada', 1, 13);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (74, 'Sydney, Australia', 1, 14);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (75, 'Mumbai, India', 1, 15);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (76, 'Barcelona, Spain', 1, 16);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (77, 'Oslo, Norway', 1, 17);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (78, 'Helsinki, Finland', 1, 18);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (79, 'Prague, Czech Republic', 1, 19);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (80, 'Brussels, Belgium', 1, 20);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (81, 'Berlin, Germany', 1, 1);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (82, 'Tokyo, Japan', 1, 2);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (83, 'Seoul, South Korea', 1, 3);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (84, 'Detroit, USA', 1, 4);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (85, 'Shanghai, China', 1, 5);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (86, 'Milan, Italy', 1, 6);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (87, 'Paris, France', 1, 7);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (88, 'Belo Horizonte, Brazil', 1, 8);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (89, 'Hsinchu, Taiwan', 1, 9);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (90, 'Zurich, Switzerland', 1, 10);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (91, 'Stockholm, Sweden', 1, 11);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (92, 'Vienna, Austria', 1, 12);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (93, 'Toronto, Canada', 1, 13);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (94, 'Sydney, Australia', 1, 14);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (95, 'Mumbai, India', 1, 15);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (96, 'Barcelona, Spain', 1, 16);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (97, 'Oslo, Norway', 1, 17);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (98, 'Helsinki, Finland', 1, 18);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (99, 'Prague, Czech Republic', 1, 19);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (100, 'Brussels, Belgium', 1, 20);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (101, 'Berlin, Germany', 1, 1);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (102, 'Tokyo, Japan', 1, 2);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (103, 'Seoul, South Korea', 1, 3);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (104, 'Detroit, USA', 1, 4);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (105, 'Shanghai, China', 1, 5);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (106, 'Milan, Italy', 1, 6);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (107, 'Paris, France', 1, 7);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (108, 'Belo Horizonte, Brazil', 1, 8);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (109, 'Hsinchu, Taiwan', 1, 9);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (110, 'Zurich, Switzerland', 1, 10);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (111, 'Stockholm, Sweden', 1, 11);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (112, 'Vienna, Austria', 1, 12);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (113, 'Toronto, Canada', 1, 13);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (114, 'Sydney, Australia', 1, 14);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (115, 'Mumbai, India', 1, 15);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (116, 'Barcelona, Spain', 1, 16);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (117, 'Oslo, Norway', 1, 17);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (118, 'Helsinki, Finland', 1, 18);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (119, 'Prague, Czech Republic', 1, 19);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (120, 'Brussels, Belgium', 1, 20);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (121, 'Berlin, Germany', 1, 1);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (122, 'Tokyo, Japan', 1, 2);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (123, 'Seoul, South Korea', 1, 3);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (124, 'Detroit, USA', 1, 4);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (125, 'Shanghai, China', 1, 5);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (126, 'Milan, Italy', 1, 6);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (127, 'Paris, France', 1, 7);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (128, 'Belo Horizonte, Brazil', 1, 8);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (129, 'Hsinchu, Taiwan', 1, 9);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (130, 'Zurich, Switzerland', 1, 10);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (131, 'Stockholm, Sweden', 1, 11);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (132, 'Vienna, Austria', 1, 12);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (133, 'Toronto, Canada', 1, 13);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (134, 'Sydney, Australia', 1, 14);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (135, 'Mumbai, India', 1, 15);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (136, 'Barcelona, Spain', 1, 16);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (137, 'Oslo, Norway', 1, 17);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (138, 'Helsinki, Finland', 1, 18);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (139, 'Prague, Czech Republic', 1, 19);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (140, 'Brussels, Belgium', 1, 20);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (141, 'Berlin, Germany', 1, 1);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (142, 'Tokyo, Japan', 1, 2);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (143, 'Seoul, South Korea', 1, 3);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (144, 'Detroit, USA', 1, 4);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (145, 'Shanghai, China', 1, 5);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (146, 'Milan, Italy', 1, 6);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (147, 'Paris, France', 1, 7);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (148, 'Belo Horizonte, Brazil', 1, 8);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (149, 'Hsinchu, Taiwan', 1, 9);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (150, 'Zurich, Switzerland', 1, 10);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (151, 'Stockholm, Sweden', 1, 11);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (152, 'Vienna, Austria', 1, 12);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (153, 'Toronto, Canada', 1, 13);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (154, 'Sydney, Australia', 1, 14);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (155, 'Mumbai, India', 1, 15);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (156, 'Barcelona, Spain', 1, 16);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (157, 'Oslo, Norway', 1, 17);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (158, 'Helsinki, Finland', 1, 18);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (159, 'Prague, Czech Republic', 1, 19);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (160, 'Brussels, Belgium', 1, 20);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (161, 'Berlin, Germany', 1, 1);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (162, 'Tokyo, Japan', 1, 2);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (163, 'Seoul, South Korea', 1, 3);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (164, 'Detroit, USA', 1, 4);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (165, 'Shanghai, China', 1, 5);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (166, 'Milan, Italy', 1, 6);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (167, 'Paris, France', 1, 7);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (168, 'Belo Horizonte, Brazil', 1, 8);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (169, 'Hsinchu, Taiwan', 1, 9);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (170, 'Zurich, Switzerland', 1, 10);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (171, 'Stockholm, Sweden', 1, 11);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (172, 'Vienna, Austria', 1, 12);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (173, 'Toronto, Canada', 1, 13);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (174, 'Sydney, Australia', 1, 14);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (175, 'Mumbai, India', 1, 15);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (176, 'Barcelona, Spain', 1, 16);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (177, 'Oslo, Norway', 1, 17);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (178, 'Helsinki, Finland', 1, 18);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (179, 'Prague, Czech Republic', 1, 19);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (180, 'Brussels, Belgium', 1, 20);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (181, 'Berlin, Germany', 1, 1);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (182, 'Tokyo, Japan', 1, 2);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (183, 'Seoul, South Korea', 1, 3);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (184, 'Detroit, USA', 1, 4);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (185, 'Shanghai, China', 1, 5);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (186, 'Milan, Italy', 1, 6);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (187, 'Paris, France', 1, 7);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (188, 'Belo Horizonte, Brazil', 1, 8);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (189, 'Hsinchu, Taiwan', 1, 9);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (190, 'Zurich, Switzerland', 1, 10);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (191, 'Stockholm, Sweden', 1, 11);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (192, 'Vienna, Austria', 1, 12);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (193, 'Toronto, Canada', 1, 13);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (194, 'Sydney, Australia', 1, 14);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (195, 'Mumbai, India', 1, 15);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (196, 'Barcelona, Spain', 1, 16);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (197, 'Oslo, Norway', 1, 17);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (198, 'Helsinki, Finland', 1, 18);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (199, 'Prague, Czech Republic', 1, 19);
INSERT INTO tools (tool_id, place_of_prod, lab_id, tool_type) VALUES (200, 'Brussels, Belgium', 1, 20);

-- Blok 1 (ID 1-20)
INSERT INTO observatory_resource (obs_id, res_id) VALUES (1, 1);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (1, 2);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (1, 3);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (1, 4);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (2, 2);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (2, 3);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (2, 4);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (2, 5);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (2, 6);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (3, 3);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (3, 4);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (3, 5);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (3, 6);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (4, 4);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (4, 5);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (4, 6);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (4, 7);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (4, 8);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (5, 5);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (5, 6);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (5, 7);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (5, 8);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (6, 6);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (6, 7);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (6, 8);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (6, 9);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (6, 10);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (7, 7);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (7, 8);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (7, 9);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (7, 10);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (8, 8);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (8, 9);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (8, 10);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (8, 11);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (8, 12);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (9, 9);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (9, 10);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (9, 11);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (9, 12);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (10, 10);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (10, 11);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (10, 12);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (10, 13);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (10, 14);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (11, 11);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (11, 12);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (11, 13);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (11, 14);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (12, 12);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (12, 13);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (12, 14);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (12, 15);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (12, 16);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (13, 13);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (13, 14);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (13, 15);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (13, 16);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (14, 14);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (14, 15);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (14, 16);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (14, 17);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (14, 18);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (15, 15);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (15, 16);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (15, 17);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (15, 18);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (16, 16);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (16, 17);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (16, 18);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (16, 19);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (16, 20);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (17, 17);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (17, 18);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (17, 19);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (17, 20);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (18, 18);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (18, 19);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (18, 20);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (18, 21);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (18, 22);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (19, 19);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (19, 20);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (19, 21);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (19, 22);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (20, 20);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (20, 21);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (20, 22);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (20, 23);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (20, 24);

-- Blok 2 (ID 21-40)
INSERT INTO observatory_resource (obs_id, res_id) VALUES (21, 21);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (21, 22);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (21, 23);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (21, 24);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (22, 22);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (22, 23);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (22, 24);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (22, 25);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (22, 26);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (23, 23);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (23, 24);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (23, 25);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (23, 26);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (24, 24);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (24, 25);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (24, 26);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (24, 27);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (24, 28);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (25, 25);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (25, 26);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (25, 27);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (25, 28);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (26, 26);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (26, 27);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (26, 28);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (26, 29);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (26, 30);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (27, 27);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (27, 28);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (27, 29);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (27, 30);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (28, 28);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (28, 29);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (28, 30);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (28, 31);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (28, 32);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (29, 29);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (29, 30);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (29, 31);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (29, 32);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (30, 30);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (30, 31);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (30, 32);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (30, 33);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (30, 34);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (31, 31);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (31, 32);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (31, 33);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (31, 34);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (32, 32);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (32, 33);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (32, 34);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (32, 35);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (32, 36);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (33, 33);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (33, 34);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (33, 35);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (33, 36);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (34, 34);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (34, 35);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (34, 36);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (34, 37);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (34, 38);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (35, 35);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (35, 36);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (35, 37);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (35, 38);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (36, 36);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (36, 37);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (36, 38);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (36, 39);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (36, 40);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (37, 37);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (37, 38);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (37, 39);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (37, 40);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (38, 38);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (38, 39);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (38, 40);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (38, 41);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (38, 42);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (39, 39);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (39, 40);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (39, 41);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (39, 42);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (40, 40);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (40, 41);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (40, 42);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (40, 43);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (40, 44);

-- Blok 3 (ID 41-60)
INSERT INTO observatory_resource (obs_id, res_id) VALUES (41, 41);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (41, 42);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (41, 43);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (41, 44);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (42, 42);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (42, 43);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (42, 44);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (42, 45);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (42, 46);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (43, 43);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (43, 44);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (43, 45);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (43, 46);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (44, 44);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (44, 45);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (44, 46);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (44, 47);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (44, 48);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (45, 45);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (45, 46);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (45, 47);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (45, 48);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (46, 46);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (46, 47);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (46, 48);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (46, 49);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (46, 50);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (47, 47);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (47, 48);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (47, 49);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (47, 50);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (48, 48);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (48, 49);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (48, 50);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (48, 51);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (48, 52);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (49, 49);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (49, 50);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (49, 51);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (49, 52);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (50, 50);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (50, 51);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (50, 52);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (50, 53);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (50, 54);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (51, 51);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (51, 52);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (51, 53);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (51, 54);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (52, 52);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (52, 53);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (52, 54);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (52, 55);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (52, 56);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (53, 53);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (53, 54);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (53, 55);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (53, 56);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (54, 54);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (54, 55);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (54, 56);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (54, 57);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (54, 58);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (55, 55);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (55, 56);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (55, 57);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (55, 58);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (56, 56);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (56, 57);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (56, 58);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (56, 59);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (56, 60);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (57, 57);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (57, 58);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (57, 59);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (57, 60);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (58, 58);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (58, 59);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (58, 60);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (58, 61);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (58, 62);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (59, 59);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (59, 60);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (59, 61);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (59, 62);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (60, 60);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (60, 61);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (60, 62);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (60, 63);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (60, 64);

-- Blok 4 (ID 61-80)
INSERT INTO observatory_resource (obs_id, res_id) VALUES (61, 61);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (61, 62);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (61, 63);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (61, 64);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (62, 62);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (62, 63);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (62, 64);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (62, 65);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (62, 66);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (63, 63);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (63, 64);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (63, 65);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (63, 66);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (64, 64);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (64, 65);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (64, 66);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (64, 67);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (64, 68);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (65, 65);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (65, 66);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (65, 67);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (65, 68);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (66, 66);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (66, 67);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (66, 68);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (66, 69);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (66, 70);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (77, 77);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (67, 68);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (67, 69);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (67, 70);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (68, 68);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (68, 69);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (68, 70);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (68, 71);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (68, 72);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (69, 69);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (69, 70);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (69, 71);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (69, 72);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (70, 70);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (70, 71);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (70, 72);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (70, 73);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (70, 74);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (71, 71);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (71, 72);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (71, 73);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (71, 74);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (72, 72);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (72, 73);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (72, 74);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (72, 75);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (72, 76);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (73, 73);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (73, 74);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (73, 75);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (73, 76);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (74, 74);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (74, 75);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (74, 76);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (74, 77);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (74, 78);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (75, 75);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (75, 76);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (75, 77);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (75, 78);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (76, 76);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (76, 77);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (76, 78);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (76, 79);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (76, 80);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (77, 67);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (77, 78);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (77, 79);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (77, 80);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (78, 78);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (78, 79);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (78, 80);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (78, 81);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (78, 82);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (79, 79);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (79, 80);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (79, 81);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (79, 82);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (80, 80);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (80, 81);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (80, 82);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (80, 83);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (80, 84);

-- Blok 5 (ID 81-100)
INSERT INTO observatory_resource (obs_id, res_id) VALUES (81, 81);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (81, 82);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (81, 83);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (81, 84);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (82, 82);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (82, 83);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (82, 84);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (82, 85);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (82, 86);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (83, 83);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (83, 84);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (83, 85);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (83, 86);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (84, 84);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (84, 85);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (84, 86);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (84, 87);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (84, 88);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (85, 85);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (85, 86);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (85, 87);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (85, 88);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (86, 86);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (86, 87);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (86, 88);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (86, 89);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (86, 90);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (87, 87);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (87, 88);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (87, 89);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (87, 90);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (88, 88);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (88, 89);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (88, 90);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (88, 91);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (88, 92);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (89, 89);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (89, 90);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (89, 91);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (89, 92);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (90, 90);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (90, 91);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (90, 92);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (90, 93);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (90, 94);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (91, 91);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (91, 92);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (91, 93);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (91, 94);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (92, 92);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (92, 93);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (92, 94);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (92, 95);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (92, 96);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (93, 93);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (93, 94);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (93, 95);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (93, 96);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (94, 94);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (94, 95);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (94, 96);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (94, 97);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (94, 98);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (95, 95);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (95, 96);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (95, 97);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (95, 98);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (96, 96);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (96, 97);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (96, 98);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (96, 99);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (96, 100);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (97, 97);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (97, 98);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (97, 99);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (97, 100);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (98, 98);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (98, 99);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (98, 100);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (98, 1);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (98, 2);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (99, 99);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (99, 100);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (99, 1);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (99, 2);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (100, 100);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (100, 1);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (100, 2);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (100, 3);
INSERT INTO observatory_resource (obs_id, res_id) VALUES (100, 4);

INSERT INTO researcher VALUES (1, 'Liam', 'Smith', '1985-05-12', 'Radio Astronomy', 'Spectral Analysis');
INSERT INTO researcher VALUES (2, 'Olivia', 'Johnson', '1990-08-24', 'Planetary Science', 'Rover Navigation');
INSERT INTO researcher VALUES (3, 'Noah', 'Williams', '1978-03-15', 'Astrophysics', 'Stellar Evolution');
INSERT INTO researcher VALUES (4, 'Emma', 'Brown', '1992-11-02', 'Cosmology', 'Dark Matter Research');
INSERT INTO researcher VALUES (5, 'Oliver', 'Jones', '1988-07-30', 'Astrometry', 'Star Mapping');
INSERT INTO researcher VALUES (6, 'Charlotte', 'Garcia', '1983-01-20', 'Solar Physics', 'Flare Monitoring');
INSERT INTO researcher VALUES (7, 'Elijah', 'Miller', '1975-09-10', 'Exoplanetology', 'Transit Photometry');
INSERT INTO researcher VALUES (8, 'Amelia', 'Davis', '1995-12-05', 'Galactic Astronomy', 'Spiral Arm Dynamics');
INSERT INTO researcher VALUES (9, 'James', 'Rodriguez', '1980-04-18', 'Astrobiology', 'Extremophile Study');
INSERT INTO researcher VALUES (10, 'Sophia', 'Martinez', '1987-06-22', 'Observational Astro', 'Telescope Calibration');
INSERT INTO researcher VALUES (11, 'William', 'Hernandez', '1982-10-14', 'Theoretical Astro', 'Numerical Modeling');
INSERT INTO researcher VALUES (12, 'Isabella', 'Lopez', '1991-02-28', 'Infrared Astronomy', 'Dust Cloud Imaging');
INSERT INTO researcher VALUES (13, 'Benjamin', 'Gonzalez', '1979-11-11', 'X-Ray Astronomy', 'Black Hole Accretion');
INSERT INTO researcher VALUES (14, 'Mia', 'Wilson', '1986-08-09', 'Celestial Mechanics', 'Orbit Calculation');
INSERT INTO researcher VALUES (15, 'Lucas', 'Anderson', '1984-05-05', 'Gamma-Ray Astro', 'Burst Detection');
INSERT INTO researcher VALUES (16, 'Evelyn', 'Thomas', '1993-03-17', 'Computational Astro', 'Big Data Mining');
INSERT INTO researcher VALUES (17, 'Henry', 'Taylor', '1977-12-25', 'Metric Astronomy', 'Parallax Measurement');
INSERT INTO researcher VALUES (18, 'Harper', 'Moore', '1989-01-12', 'Stellar Astronomy', 'Binary Star Systems');
INSERT INTO researcher VALUES (19, 'Theodore', 'Jackson', '1981-07-19', 'Gravitational Astro', 'Wave Detection');
INSERT INTO researcher VALUES (20, 'Luna', 'Martin', '1994-09-30', 'Heliophysics', 'Solar Wind Analysis');
INSERT INTO researcher VALUES (21, 'Jack', 'Lee', '1986-04-22', 'Astrochemistry', 'Molecular Clouds');
INSERT INTO researcher VALUES (22, 'Avery', 'Perez', '1989-11-15', 'Lunar Science', 'Crater Analysis');
INSERT INTO researcher VALUES (23, 'Levi', 'Thompson', '1976-02-09', 'Plasma Astro', 'Magnetic Fields');
INSERT INTO researcher VALUES (24, 'Mila', 'White', '1991-06-18', 'High-Energy Astro', 'Neutrino Detection');
INSERT INTO researcher VALUES (25, 'Alexander', 'Harris', '1984-01-25', 'Optical Astronomy', 'Adaptive Optics');
INSERT INTO researcher VALUES (26, 'Scarlett', 'Sanchez', '1982-08-14', 'Meteoritics', 'Isotope Analysis');
INSERT INTO researcher VALUES (27, 'Jackson', 'Clark', '1979-05-03', 'Astro-informatics', 'Neural Networks');
INSERT INTO researcher VALUES (28, 'Eleanor', 'Ramirez', '1993-12-27', 'Submillimeter Astro', 'Antenna Array Ops');
INSERT INTO researcher VALUES (29, 'Mateo', 'Lewis', '1980-10-10', 'Planetary Geology', 'Seismic Processing');
INSERT INTO researcher VALUES (30, 'Madison', 'Robinson', '1987-03-14', 'Deep Space Comm', 'Signal Decoding');
INSERT INTO researcher VALUES (31, 'Daniel', 'Walker', '1981-09-01', 'Space Weather', 'Ionosphere Research');
INSERT INTO researcher VALUES (32, 'Layla', 'Young', '1990-07-11', 'Extragalactic Astro', 'Redshift Surveys');
INSERT INTO researcher VALUES (33, 'Michael', 'Allen', '1978-04-05', 'Relativistic Astro', 'Lensing Analysis');
INSERT INTO researcher VALUES (34, 'Penelope', 'King', '1992-02-19', 'Small Bodies Sci', 'Asteroid Tracking');
INSERT INTO researcher VALUES (35, 'Wyatt', 'Wright', '1985-11-23', 'Astro-statistics', 'Bayesian Inference');
INSERT INTO researcher VALUES (36, 'Aria', 'Scott', '1983-08-30', 'Planetary Atmos', 'Gas Chromatography');
INSERT INTO researcher VALUES (37, 'Sebastian', 'Torres', '1977-06-15', 'Ultraviolet Astro', 'Hot Star Spectra');
INSERT INTO researcher VALUES (38, 'Chloe', 'Nguyen', '1994-01-02', 'Archeoastronomy', 'Site Alignment');
INSERT INTO researcher VALUES (39, 'Carter', 'Hill', '1980-05-25', 'Multi-messenger', 'Coincidence Search');
INSERT INTO researcher VALUES (40, 'Grace', 'Flores', '1988-10-09', 'Supernova Sci', 'Light Curve Prep');
INSERT INTO researcher VALUES (41, 'Jayden', 'Green', '1982-03-28', 'Solar Dynamics', 'Helio-seismology');
INSERT INTO researcher VALUES (42, 'Ellie', 'Adams', '1991-09-14', 'Dark Energy', 'Expansion Mapping');
INSERT INTO researcher VALUES (43, 'John', 'Nelson', '1979-12-04', 'Stellar Pops', 'Metallicity Grad');
INSERT INTO researcher VALUES (44, 'Nora', 'Baker', '1986-07-22', 'Cosmic Dust', 'Polarimetry');
INSERT INTO researcher VALUES (45, 'Owen', 'Hall', '1983-11-17', 'Pulsar Timing', 'Clock Stability');
INSERT INTO researcher VALUES (46, 'Hazel', 'Rivera', '1992-04-10', 'Galaxy Clusters', 'Intra-cluster Med');
INSERT INTO researcher VALUES (47, 'Dylan', 'Campbell', '1975-01-30', 'Nucleosynthesis', 'Heavy Element Path');
INSERT INTO researcher VALUES (48, 'Lily', 'Mitchell', '1994-08-08', 'Orbital Dynamics', 'N-body Simulation');
INSERT INTO researcher VALUES (49, 'Luke', 'Carter', '1981-05-19', 'Astro-imaging', 'CCD Processing');
INSERT INTO researcher VALUES (50, 'Aurora', 'Roberts', '1987-10-31', 'Radio Interfero', 'Baseline Fringe');
INSERT INTO researcher VALUES (51, 'Gabriel', 'Gomez', '1985-05-12', 'Radio Astronomy', 'Spectral Analysis');
INSERT INTO researcher VALUES (52, 'Violet', 'Phillips', '1990-08-24', 'Planetary Science', 'Rover Navigation');
INSERT INTO researcher VALUES (53, 'Anthony', 'Evans', '1978-03-15', 'Astrophysics', 'Stellar Evolution');
INSERT INTO researcher VALUES (54, 'Nova', 'Turner', '1992-11-02', 'Cosmology', 'Dark Matter Research');
INSERT INTO researcher VALUES (55, 'Isaac', 'Diaz', '1988-07-30', 'Astrometry', 'Star Mapping');
INSERT INTO researcher VALUES (56, 'Emilia', 'Parker', '1983-01-20', 'Solar Physics', 'Flare Monitoring');
INSERT INTO researcher VALUES (57, 'Grayson', 'Cruz', '1975-09-10', 'Exoplanetology', 'Transit Photometry');
INSERT INTO researcher VALUES (58, 'Zoe', 'Edwards', '1995-12-05', 'Galactic Astronomy', 'Spiral Arm Dynamics');
INSERT INTO researcher VALUES (59, 'Julian', 'Collins', '1980-04-18', 'Astrobiology', 'Extremophile Study');
INSERT INTO researcher VALUES (60, 'Stella', 'Reyes', '1987-06-22', 'Observational Astro', 'Telescope Calibration');
INSERT INTO researcher VALUES (61, 'Christopher', 'Stewart', '1982-10-14', 'Theoretical Astro', 'Numerical Modeling');
INSERT INTO researcher VALUES (62, 'Victoria', 'Morris', '1991-02-28', 'Infrared Astronomy', 'Dust Cloud Imaging');
INSERT INTO researcher VALUES (63, 'Joshua', 'Morales', '1979-11-11', 'X-Ray Astronomy', 'Black Hole Accretion');
INSERT INTO researcher VALUES (64, 'Maya', 'Murphy', '1986-08-09', 'Celestial Mechanics', 'Orbit Calculation');
INSERT INTO researcher VALUES (65, 'Andrew', 'Cook', '1984-05-05', 'Gamma-Ray Astro', 'Burst Detection');
INSERT INTO researcher VALUES (66, 'Natalie', 'Rogers', '1993-03-17', 'Computational Astro', 'Big Data Mining');
INSERT INTO researcher VALUES (67, 'Lincoln', 'Gutierrez', '1977-12-25', 'Metric Astronomy', 'Parallax Measurement');
INSERT INTO researcher VALUES (68, 'Leilani', 'Ortiz', '1989-01-12', 'Stellar Astronomy', 'Binary Star Systems');
INSERT INTO researcher VALUES (69, 'Mateo', 'Morgan', '1981-07-19', 'Gravitational Astro', 'Wave Detection');
INSERT INTO researcher VALUES (70, 'Savannah', 'Cooper', '1994-09-30', 'Heliophysics', 'Solar Wind Analysis');
INSERT INTO researcher VALUES (71, 'Ryan', 'Peterson', '1986-04-22', 'Astrochemistry', 'Molecular Clouds');
INSERT INTO researcher VALUES (72, 'Willow', 'Bailey', '1989-11-15', 'Lunar Science', 'Crater Analysis');
INSERT INTO researcher VALUES (73, 'Nathan', 'Reed', '1976-02-09', 'Plasma Astro', 'Magnetic Fields');
INSERT INTO researcher VALUES (74, 'Pippa', 'Kelly', '1991-06-18', 'High-Energy Astro', 'Neutrino Detection');
INSERT INTO researcher VALUES (75, 'Adrian', 'Howard', '1984-01-25', 'Optical Astronomy', 'Adaptive Optics');
INSERT INTO researcher VALUES (76, 'Lucy', 'Ramos', '1982-08-14', 'Meteoritics', 'Isotope Analysis');
INSERT INTO researcher VALUES (77, 'Christian', 'Kim', '1979-05-03', 'Astro-informatics', 'Neural Networks');
INSERT INTO researcher VALUES (78, 'Audrey', 'Cox', '1993-12-27', 'Submillimeter Astro', 'Antenna Array Ops');
INSERT INTO researcher VALUES (79, 'Maverick', 'Ward', '1980-10-10', 'Planetary Geology', 'Seismic Processing');
INSERT INTO researcher VALUES (80, 'Alice', 'Richardson', '1987-03-14', 'Deep Space Comm', 'Signal Decoding');
INSERT INTO researcher VALUES (81, 'Colton', 'Watson', '1981-09-01', 'Space Weather', 'Ionosphere Research');
INSERT INTO researcher VALUES (82, 'Cora', 'Brooks', '1990-07-11', 'Extragalactic Astro', 'Redshift Surveys');
INSERT INTO researcher VALUES (83, 'Elias', 'Chavez', '1978-04-05', 'Relativistic Astro', 'Lensing Analysis');
INSERT INTO researcher VALUES (84, 'Genesis', 'Wood', '1992-02-19', 'Small Bodies Sci', 'Asteroid Tracking');
INSERT INTO researcher VALUES (85, 'Aaron', 'James', '1985-11-23', 'Astro-statistics', 'Bayesian Inference');
INSERT INTO researcher VALUES (86, 'Ruby', 'Bennett', '1983-08-30', 'Planetary Atmos', 'Gas Chromatography');
INSERT INTO researcher VALUES (87, 'Hunter', 'Gray', '1977-06-15', 'Ultraviolet Astro', 'Hot Star Spectra');
INSERT INTO researcher VALUES (88, 'Sophie', 'Mendoza', '1994-01-02', 'Archeoastronomy', 'Site Alignment');
INSERT INTO researcher VALUES (89, 'Josiah', 'Ruiz', '1980-05-25', 'Multi-messenger', 'Coincidence Search');
INSERT INTO researcher VALUES (90, 'Sadie', 'Hughes', '1988-10-09', 'Supernova Sci', 'Light Curve Prep');
INSERT INTO researcher VALUES (91, 'Charles', 'Price', '1982-03-28', 'Solar Dynamics', 'Helio-seismology');
INSERT INTO researcher VALUES (92, 'Natalia', 'Alvarez', '1991-09-14', 'Dark Energy', 'Expansion Mapping');
INSERT INTO researcher VALUES (93, 'Caleb', 'Castillo', '1979-12-04', 'Stellar Pops', 'Metallicity Grad');
INSERT INTO researcher VALUES (94, 'Quinn', 'Sanders', '1986-07-22', 'Cosmic Dust', 'Polarimetry');
INSERT INTO researcher VALUES (95, 'Robert', 'Patel', '1983-11-17', 'Pulsar Timing', 'Clock Stability');
INSERT INTO researcher VALUES (96, 'Ivy', 'Myers', '1992-04-10', 'Galaxy Clusters', 'Intra-cluster Med');
INSERT INTO researcher VALUES (97, 'Miles', 'Long', '1975-01-30', 'Nucleosynthesis', 'Heavy Element Path');
INSERT INTO researcher VALUES (98, 'Serenity', 'Ross', '1994-08-08', 'Orbital Dynamics', 'N-body Simulation');
INSERT INTO researcher VALUES (99, 'Jordan', 'Foster', '1981-05-19', 'Astro-imaging', 'CCD Processing');
INSERT INTO researcher VALUES (100, 'Jade', 'Jimenez', '1987-10-31', 'Radio Interfero', 'Baseline Fringe');
INSERT INTO researcher VALUES (101, 'Silas', 'Powell', '1985-05-12', 'Radio Astronomy', 'Spectral Analysis');
INSERT INTO researcher VALUES (102, 'Autumn', 'Jenkins', '1990-08-24', 'Planetary Science', 'Rover Navigation');
INSERT INTO researcher VALUES (103, 'Tristan', 'Perry', '1978-03-15', 'Astrophysics', 'Stellar Evolution');
INSERT INTO researcher VALUES (104, 'Adeline', 'Russell', '1992-11-02', 'Cosmology', 'Dark Matter Research');
INSERT INTO researcher VALUES (105, 'Austin', 'Sullivan', '1988-07-30', 'Astrometry', 'Star Mapping');
INSERT INTO researcher VALUES (106, 'Clara', 'Bell', '1983-01-20', 'Solar Physics', 'Flare Monitoring');
INSERT INTO researcher VALUES (107, 'Brooks', 'Coleman', '1975-09-10', 'Exoplanetology', 'Transit Photometry');
INSERT INTO researcher VALUES (108, 'Hadley', 'Butler', '1995-12-05', 'Galactic Astronomy', 'Spiral Arm Dynamics');
INSERT INTO researcher VALUES (109, 'Xavier', 'Henderson', '1980-04-18', 'Astrobiology', 'Extremophile Study');
INSERT INTO researcher VALUES (110, 'Gianna', 'Barnes', '1987-06-22', 'Observational Astro', 'Telescope Calibration');
INSERT INTO researcher VALUES (111, 'Kai', 'Gonzales', '1982-10-14', 'Theoretical Astro', 'Numerical Modeling');
INSERT INTO researcher VALUES (112, 'Valentina', 'Fisher', '1991-02-28', 'Infrared Astronomy', 'Dust Cloud Imaging');
INSERT INTO researcher VALUES (113, 'Dominic', 'Vasquez', '1979-11-11', 'X-Ray Astronomy', 'Black Hole Accretion');
INSERT INTO researcher VALUES (114, 'Isla', 'Simmons', '1986-08-09', 'Celestial Mechanics', 'Orbit Calculation');
INSERT INTO researcher VALUES (115, 'Parker', 'Romero', '1984-05-05', 'Gamma-Ray Astro', 'Burst Detection');
INSERT INTO researcher VALUES (116, 'Rose', 'Jordan', '1993-03-17', 'Computational Astro', 'Big Data Mining');
INSERT INTO researcher VALUES (117, 'Everett', 'Patterson', '1977-12-25', 'Metric Astronomy', 'Parallax Measurement');
INSERT INTO researcher VALUES (118, 'Iris', 'Alexander', '1989-01-12', 'Stellar Astronomy', 'Binary Star Systems');
INSERT INTO researcher VALUES (119, 'Cole', 'Hamilton', '1981-07-19', 'Gravitational Astro', 'Wave Detection');
INSERT INTO researcher VALUES (120, 'Piper', 'Graham', '1994-09-30', 'Heliophysics', 'Solar Wind Analysis');
INSERT INTO researcher VALUES (121, 'Arthur', 'Reynolds', '1986-04-22', 'Astrochemistry', 'Molecular Clouds');
INSERT INTO researcher VALUES (122, 'Lydia', 'Griffin', '1989-11-15', 'Lunar Science', 'Crater Analysis');
INSERT INTO researcher VALUES (123, 'Max', 'Wallace', '1976-02-09', 'Plasma Astro', 'Magnetic Fields');
INSERT INTO researcher VALUES (124, 'Brielle', 'Moreno', '1991-06-18', 'High-Energy Astro', 'Neutrino Detection');
INSERT INTO researcher VALUES (125, 'Roman', 'West', '1984-01-25', 'Optical Astronomy', 'Adaptive Optics');
INSERT INTO researcher VALUES (126, 'Nicole', 'Bryant', '1982-08-14', 'Meteoritics', 'Isotope Analysis');
INSERT INTO researcher VALUES (127, 'Beau', 'Herrera', '1979-05-03', 'Astro-informatics', 'Neural Networks');
INSERT INTO researcher VALUES (128, 'Alaina', 'Gibson', '1993-12-27', 'Submillimeter Astro', 'Antenna Array Ops');
INSERT INTO researcher VALUES (129, 'Waylon', 'Porter', '1980-10-10', 'Planetary Geology', 'Seismic Processing');
INSERT INTO researcher VALUES (130, 'June', 'Ellis', '1987-03-14', 'Deep Space Comm', 'Signal Decoding');
INSERT INTO researcher VALUES (131, 'Beckett', 'Douglas', '1981-09-01', 'Space Weather', 'Ionosphere Research');
INSERT INTO researcher VALUES (132, 'Finley', 'Hunt', '1990-07-11', 'Extragalactic Astro', 'Redshift Surveys');
INSERT INTO researcher VALUES (133, 'Felix', 'Harrison', '1978-04-05', 'Relativistic Astro', 'Lensing Analysis');
INSERT INTO researcher VALUES (134, 'Leona', 'Peralta', '1992-02-19', 'Small Bodies Sci', 'Asteroid Tracking');
INSERT INTO researcher VALUES (135, 'Gavin', 'Aguilar', '1985-11-23', 'Astro-statistics', 'Bayesian Inference');
INSERT INTO researcher VALUES (136, 'Esme', 'Guzman', '1983-08-30', 'Planetary Atmos', 'Gas Chromatography');
INSERT INTO researcher VALUES (137, 'Milo', 'Hansen', '1977-06-15', 'Ultraviolet Astro', 'Hot Star Spectra');
INSERT INTO researcher VALUES (138, 'Mabel', 'Lane', '1994-01-02', 'Archeoastronomy', 'Site Alignment');
INSERT INTO researcher VALUES (139, 'Hugo', 'Garza', '1980-05-25', 'Multi-messenger', 'Coincidence Search');
INSERT INTO researcher VALUES (140, 'Olive', 'Harvey', '1988-10-09', 'Supernova Sci', 'Light Curve Prep');
INSERT INTO researcher VALUES (141, 'Zane', 'Morrison', '1982-03-28', 'Solar Dynamics', 'Helio-seismology');
INSERT INTO researcher VALUES (142, 'Rylee', 'Burton', '1991-09-14', 'Dark Energy', 'Expansion Mapping');
INSERT INTO researcher VALUES (143, 'Grant', 'Stanley', '1979-12-04', 'Stellar Pops', 'Metallicity Grad');
INSERT INTO researcher VALUES (144, 'Sloane', 'Bush', '1986-07-22', 'Cosmic Dust', 'Polarimetry');
INSERT INTO researcher VALUES (145, 'Preston', 'Fox', '1983-11-17', 'Pulsar Timing', 'Clock Stability');
INSERT INTO researcher VALUES (146, 'Elsie', 'Hopkins', '1992-04-10', 'Galaxy Clusters', 'Intra-cluster Med');
INSERT INTO researcher VALUES (147, 'Marcus', 'Maguire', '1975-01-30', 'Nucleosynthesis', 'Heavy Element Path');
INSERT INTO researcher VALUES (148, 'Vera', 'Wheeler', '1994-08-08', 'Orbital Dynamics', 'N-body Simulation');
INSERT INTO researcher VALUES (149, 'Oscar', 'Davidson', '1981-05-19', 'Astro-imaging', 'CCD Processing');
INSERT INTO researcher VALUES (150, 'Nala', 'Lawson', '1987-10-31', 'Radio Interfero', 'Baseline Fringe');
INSERT INTO researcher VALUES (151, 'Tobias', 'Barker', '1985-05-12', 'Radio Astronomy', 'Spectral Analysis');
INSERT INTO researcher VALUES (152, 'Genevieve', 'Holt', '1990-08-24', 'Planetary Science', 'Rover Navigation');
INSERT INTO researcher VALUES (153, 'Killian', 'Frost', '1978-03-15', 'Astrophysics', 'Stellar Evolution');
INSERT INTO researcher VALUES (154, 'Adelaide', 'Vance', '1992-11-02', 'Cosmology', 'Dark Matter Research');
INSERT INTO researcher VALUES (155, 'Gideon', 'Blair', '1988-07-30', 'Astrometry', 'Star Mapping');
INSERT INTO researcher VALUES (156, 'Clementine', 'Flynn', '1983-01-20', 'Solar Physics', 'Flare Monitoring');
INSERT INTO researcher VALUES (157, 'Alaric', 'Nash', '1975-09-10', 'Exoplanetology', 'Transit Photometry');
INSERT INTO researcher VALUES (158, 'Florence', 'Hale', '1995-12-05', 'Galactic Astronomy', 'Spiral Arm Dynamics');
INSERT INTO researcher VALUES (159, 'Phineas', 'Lowe', '1980-04-18', 'Astrobiology', 'Extremophile Study');
INSERT INTO researcher VALUES (160, 'Emmeline', 'Oaks', '1987-06-22', 'Observational Astro', 'Telescope Calibration');
INSERT INTO researcher VALUES (161, 'Barnaby', 'Rhodes', '1982-10-14', 'Theoretical Astro', 'Numerical Modeling');
INSERT INTO researcher VALUES (162, 'Beatrix', 'Sparks', '1991-02-28', 'Infrared Astronomy', 'Dust Cloud Imaging');
INSERT INTO researcher VALUES (163, 'Cyrus', 'Manning', '1979-11-11', 'X-Ray Astronomy', 'Black Hole Accretion');
INSERT INTO researcher VALUES (164, 'Theodora', 'Wade', '1986-08-09', 'Celestial Mechanics', 'Orbit Calculation');
INSERT INTO researcher VALUES (165, 'Soren', 'Bates', '1984-05-05', 'Gamma-Ray Astro', 'Burst Detection');
INSERT INTO researcher VALUES (166, 'Evangeline', 'Gould', '1993-03-17', 'Computational Astro', 'Big Data Mining');
INSERT INTO researcher VALUES (167, 'Desmond', 'Sutton', '1977-12-25', 'Metric Astronomy', 'Parallax Measurement');
INSERT INTO researcher VALUES (168, 'Cordelia', 'Heath', '1989-01-12', 'Stellar Astronomy', 'Binary Star Systems');
INSERT INTO researcher VALUES (169, 'Quentin', 'Pike', '1981-07-19', 'Gravitational Astro', 'Wave Detection');
INSERT INTO researcher VALUES (170, 'Margot', 'Cross', '1994-09-30', 'Heliophysics', 'Solar Wind Analysis');
INSERT INTO researcher VALUES (171, 'Atticus', 'Moon', '1986-04-22', 'Astrochemistry', 'Molecular Clouds');
INSERT INTO researcher VALUES (172, 'Ophelia', 'Day', '1989-11-15', 'Lunar Science', 'Crater Analysis');
INSERT INTO researcher VALUES (173, 'Cassius', 'Winter', '1976-02-09', 'Plasma Astro', 'Magnetic Fields');
INSERT INTO researcher VALUES (174, 'Helena', 'Swift', '1991-06-18', 'High-Energy Astro', 'Neutrino Detection');
INSERT INTO researcher VALUES (175, 'Franklin', 'Chase', '1984-01-25', 'Optical Astronomy', 'Adaptive Optics');
INSERT INTO researcher VALUES (176, 'Penelope', 'Lane', '1982-08-14', 'Meteoritics', 'Isotope Analysis');
INSERT INTO researcher VALUES (177, 'Jasper', 'Hicks', '1979-05-03', 'Astro-informatics', 'Neural Networks');
INSERT INTO researcher VALUES (178, 'Felicity', 'Banks', '1993-12-27', 'Submillimeter Astro', 'Antenna Array Ops');
INSERT INTO researcher VALUES (179, 'Byron', 'Knox', '1980-10-10', 'Planetary Geology', 'Seismic Processing');
INSERT INTO researcher VALUES (180, 'Imogen', 'Glass', '1987-03-14', 'Deep Space Comm', 'Signal Decoding');
INSERT INTO researcher VALUES (181, 'Sterling', 'Bond', '1981-09-01', 'Space Weather', 'Ionosphere Research');
INSERT INTO researcher VALUES (182, 'Matilda', 'Orr', '1990-07-11', 'Extragalactic Astro', 'Redshift Surveys');
INSERT INTO researcher VALUES (183, 'Leopold', 'Small', '1978-04-05', 'Relativistic Astro', 'Lensing Analysis');
INSERT INTO researcher VALUES (184, 'Aurelia', 'Hull', '1992-02-19', 'Small Bodies Sci', 'Asteroid Tracking');
INSERT INTO researcher VALUES (185, 'Dorian', 'Frey', '1985-11-23', 'Astro-statistics', 'Bayesian Inference');
INSERT INTO researcher VALUES (186, 'Clarissa', 'Kent', '1983-08-30', 'Planetary Atmos', 'Gas Chromatography');
INSERT INTO researcher VALUES (187, 'Xander', 'Clay', '1977-06-15', 'Ultraviolet Astro', 'Hot Star Spectra');
INSERT INTO researcher VALUES (188, 'Maisie', 'Voss', '1994-01-02', 'Archeoastronomy', 'Site Alignment');
INSERT INTO researcher VALUES (189, 'Thaddeus', 'Best', '1980-05-25', 'Multi-messenger', 'Coincidence Search');
INSERT INTO researcher VALUES (190, 'Eloise', 'Fry', '1988-10-09', 'Supernova Sci', 'Light Curve Prep');
INSERT INTO researcher VALUES (191, 'Mortimer', 'Rice', '1982-03-28', 'Solar Dynamics', 'Helio-seismology');
INSERT INTO researcher VALUES (192, 'Rowena', 'Lutz', '1991-09-14', 'Dark Energy', 'Expansion Mapping');
INSERT INTO researcher VALUES (193, 'Alistair', 'Case', '1979-12-04', 'Stellar Pops', 'Metallicity Grad');
INSERT INTO researcher VALUES (194, 'Cecilia', 'Barr', '1986-07-22', 'Cosmic Dust', 'Polarimetry');
INSERT INTO researcher VALUES (195, 'Benedict', 'Frye', '1983-11-17', 'Pulsar Timing', 'Clock Stability');
INSERT INTO researcher VALUES (196, 'Sylvia', 'Wall', '1992-04-10', 'Galaxy Clusters', 'Intra-cluster Med');
INSERT INTO researcher VALUES (197, 'Hugo', 'Todd', '1975-01-30', 'Nucleosynthesis', 'Heavy Element Path');
INSERT INTO researcher VALUES (198, 'Octavia', 'Mayer', '1994-08-08', 'Orbital Dynamics', 'N-body Simulation');
INSERT INTO researcher VALUES (199, 'Rupert', 'Dunn', '1981-05-19', 'Astro-imaging', 'CCD Processing');
INSERT INTO researcher VALUES (200, 'Lorelai', 'Pratt', '1987-10-31', 'Radio Interfero', 'Baseline Fringe');
INSERT INTO researcher VALUES (201, 'Wilfred', 'Page', '1985-05-12', 'Radio Astronomy', 'Spectral Analysis');
INSERT INTO researcher VALUES (202, 'Elowen', 'Short', '1990-08-24', 'Planetary Science', 'Rover Navigation');
INSERT INTO researcher VALUES (203, 'Conrad', 'Stone', '1978-03-15', 'Astrophysics', 'Stellar Evolution');
INSERT INTO researcher VALUES (204, 'Daphne', 'Howe', '1992-11-02', 'Cosmology', 'Dark Matter Research');
INSERT INTO researcher VALUES (205, 'Amos', 'Sloan', '1988-07-30', 'Astrometry', 'Star Mapping');
INSERT INTO researcher VALUES (206, 'Pearl', 'Olsen', '1983-01-20', 'Solar Physics', 'Flare Monitoring');
INSERT INTO researcher VALUES (207, 'Otto', 'Hurst', '1975-09-10', 'Exoplanetology', 'Transit Photometry');
INSERT INTO researcher VALUES (208, 'Tabitha', 'Noble', '1995-12-05', 'Galactic Astronomy', 'Spiral Arm Dynamics');
INSERT INTO researcher VALUES (209, 'Lucius', 'Bowers', '1980-04-18', 'Astrobiology', 'Extremophile Study');
INSERT INTO researcher VALUES (210, 'Rosalind', 'Stafford', '1987-06-22', 'Observational Astro', 'Telescope Calibration');
INSERT INTO researcher VALUES (211, 'Roland', 'Goodman', '1982-10-14', 'Theoretical Astro', 'Numerical Modeling');
INSERT INTO researcher VALUES (212, 'Miriam', 'Koch', '1991-02-28', 'Infrared Astronomy', 'Dust Cloud Imaging');
INSERT INTO researcher VALUES (213, 'Emmett', 'Buck', '1979-11-11', 'X-Ray Astronomy', 'Black Hole Accretion');
INSERT INTO researcher VALUES (214, 'Freya', 'Pitts', '1986-08-09', 'Celestial Mechanics', 'Orbit Calculation');
INSERT INTO researcher VALUES (215, 'Marshall', 'Strong', '1984-05-05', 'Gamma-Ray Astro', 'Burst Detection');
INSERT INTO researcher VALUES (216, 'Leona', 'Bright', '1993-03-17', 'Computational Astro', 'Big Data Mining');
INSERT INTO researcher VALUES (217, 'Solomon', 'Ayers', '1977-12-25', 'Metric Astronomy', 'Parallax Measurement');
INSERT INTO researcher VALUES (218, 'Celia', 'Lowery', '1989-01-12', 'Stellar Astronomy', 'Binary Star Systems');
INSERT INTO researcher VALUES (219, 'Frederick', 'Dotson', '1981-07-19', 'Gravitational Astro', 'Wave Detection');
INSERT INTO researcher VALUES (220, 'Veda', 'Carey', '1994-09-30', 'Heliophysics', 'Solar Wind Analysis');
INSERT INTO researcher VALUES (221, 'Albert', 'Hines', '1986-04-22', 'Astrochemistry', 'Molecular Clouds');
INSERT INTO researcher VALUES (222, 'Mabel', 'Branch', '1989-11-15', 'Lunar Science', 'Crater Analysis');
INSERT INTO researcher VALUES (223, 'Walter', 'Hardy', '1976-02-09', 'Plasma Astro', 'Magnetic Fields');
INSERT INTO researcher VALUES (224, 'Flora', 'Vaughan', '1991-06-18', 'High-Energy Astro', 'Neutrino Detection');
INSERT INTO researcher VALUES (225, 'Abner', 'Weeks', '1984-01-25', 'Optical Astronomy', 'Adaptive Optics');
INSERT INTO researcher VALUES (226, 'Hester', 'Nielsen', '1982-08-14', 'Meteoritics', 'Isotope Analysis');
INSERT INTO researcher VALUES (227, 'Silas', 'Moon', '1979-05-03', 'Astro-informatics', 'Neural Networks');
INSERT INTO researcher VALUES (228, 'Prudence', 'Atkins', '1993-12-27', 'Submillimeter Astro', 'Antenna Array Ops');
INSERT INTO researcher VALUES (229, 'Enoch', 'Wilkins', '1980-10-10', 'Planetary Geology', 'Seismic Processing');
INSERT INTO researcher VALUES (230, 'Dinah', 'Boyle', '1987-03-14', 'Deep Space Comm', 'Signal Decoding');
INSERT INTO researcher VALUES (231, 'Clarence', 'Sherman', '1981-09-01', 'Space Weather', 'Ionosphere Research');
INSERT INTO researcher VALUES (232, 'Eunice', 'Rowe', '1990-07-11', 'Extragalactic Astro', 'Redshift Surveys');
INSERT INTO researcher VALUES (233, 'Edwin', 'Truong', '1978-04-05', 'Relativistic Astro', 'Lensing Analysis');
INSERT INTO researcher VALUES (234, 'Ida', 'Hoover', '1992-02-19', 'Small Bodies Sci', 'Asteroid Tracking');
INSERT INTO researcher VALUES (235, 'Harvey', 'Farrell', '1985-11-23', 'Astro-statistics', 'Bayesian Inference');
INSERT INTO researcher VALUES (236, 'Alma', 'Larsen', '1983-08-30', 'Planetary Atmos', 'Gas Chromatography');
INSERT INTO researcher VALUES (237, 'Sidney', 'Frye', '1977-06-15', 'Ultraviolet Astro', 'Hot Star Spectra');
INSERT INTO researcher VALUES (238, 'Thelma', 'McBride', '1994-01-02', 'Archeoastronomy', 'Site Alignment');
INSERT INTO researcher VALUES (239, 'Morris', 'Gentry', '1980-05-25', 'Multi-messenger', 'Coincidence Search');
INSERT INTO researcher VALUES (240, 'Agnes', 'Odom', '1988-10-09', 'Supernova Sci', 'Light Curve Prep');
INSERT INTO researcher VALUES (241, 'Irvin', 'Morrow', '1982-03-28', 'Solar Dynamics', 'Helio-seismology');
INSERT INTO researcher VALUES (242, 'Bernice', 'Vogel', '1991-09-14', 'Dark Energy', 'Expansion Mapping');
INSERT INTO researcher VALUES (243, 'Cedric', 'Callahan', '1979-12-04', 'Stellar Pops', 'Metallicity Grad');
INSERT INTO researcher VALUES (244, 'Enid', 'Abbott', '1986-07-22', 'Cosmic Dust', 'Polarimetry');
INSERT INTO researcher VALUES (245, 'Leland', 'Graves', '1983-11-17', 'Pulsar Timing', 'Clock Stability');
INSERT INTO researcher VALUES (246, 'Sybil', 'Valentine', '1992-04-10', 'Galaxy Clusters', 'Intra-cluster Med');
INSERT INTO researcher VALUES (247, 'Gilbert', 'Holloway', '1975-01-30', 'Nucleosynthesis', 'Heavy Element Path');
INSERT INTO researcher VALUES (248, 'Myrtle', 'Decker', '1994-08-08', 'Orbital Dynamics', 'N-body Simulation');
INSERT INTO researcher VALUES (249, 'Herman', 'Yates', '1981-05-19', 'Astro-imaging', 'CCD Processing');
INSERT INTO researcher VALUES (250, 'Gladys', 'Galloway', '1987-10-31', 'Radio Interfero', 'Baseline Fringe');
INSERT INTO researcher VALUES (251, 'Bertram', 'Kirk', '1985-05-12', 'Radio Astronomy', 'Spectral Analysis');
INSERT INTO researcher VALUES (252, 'Lois', 'Livingston', '1990-08-24', 'Planetary Science', 'Rover Navigation');
INSERT INTO researcher VALUES (253, 'Clement', 'Sheppard', '1978-03-15', 'Astrophysics', 'Stellar Evolution');
INSERT INTO researcher VALUES (254, 'Ethel', 'Kemp', '1992-11-02', 'Cosmology', 'Dark Matter Research');
INSERT INTO researcher VALUES (255, 'Douglas', 'Villarreal', '1988-07-30', 'Astrometry', 'Star Mapping');
INSERT INTO researcher VALUES (256, 'Beryl', 'McCall', '1983-01-20', 'Solar Physics', 'Flare Monitoring');
INSERT INTO researcher VALUES (257, 'Leonard', 'Pollard', '1975-09-10', 'Exoplanetology', 'Transit Photometry');
INSERT INTO researcher VALUES (258, 'Doris', 'Russo', '1995-12-05', 'Galactic Astronomy', 'Spiral Arm Dynamics');
INSERT INTO researcher VALUES (259, 'Wallace', 'Sampson', '1980-04-18', 'Astrobiology', 'Extremophile Study');
INSERT INTO researcher VALUES (260, 'Muriel', 'Melton', '1987-06-22', 'Observational Astro', 'Telescope Calibration');
INSERT INTO researcher VALUES (261, 'Percival', 'Barron', '1982-10-14', 'Theoretical Astro', 'Numerical Modeling');
INSERT INTO researcher VALUES (262, 'Ada', 'Christian', '1991-02-28', 'Infrared Astronomy', 'Dust Cloud Imaging');
INSERT INTO researcher VALUES (263, 'Neville', 'Guy', '1979-11-11', 'X-Ray Astronomy', 'Black Hole Accretion');
INSERT INTO researcher VALUES (264, 'Verna', 'Macias', '1986-08-09', 'Celestial Mechanics', 'Orbit Calculation');
INSERT INTO researcher VALUES (265, 'Sewell', 'Humphrey', '1984-05-05', 'Gamma-Ray Astro', 'Burst Detection');
INSERT INTO researcher VALUES (266, 'Nora', 'Flowers', '1993-03-17', 'Computational Astro', 'Big Data Mining');
INSERT INTO researcher VALUES (267, 'Randolph', 'Ho', '1977-12-25', 'Metric Astronomy', 'Parallax Measurement');
INSERT INTO researcher VALUES (268, 'Effie', 'Hodge', '1989-01-12', 'Stellar Astronomy', 'Binary Star Systems');
INSERT INTO researcher VALUES (269, 'Basil', 'Acosta', '1981-07-19', 'Gravitational Astro', 'Wave Detection');
INSERT INTO researcher VALUES (270, 'Zelda', 'Shaffer', '1994-09-30', 'Heliophysics', 'Solar Wind Analysis');
INSERT INTO researcher VALUES (271, 'Clifford', 'Finley', '1986-04-22', 'Astrochemistry', 'Molecular Clouds');
INSERT INTO researcher VALUES (272, 'Esther', 'Combs', '1989-11-15', 'Lunar Science', 'Crater Analysis');
INSERT INTO researcher VALUES (273, 'Lionel', 'Blevins', '1976-02-09', 'Plasma Astro', 'Magnetic Fields');
INSERT INTO researcher VALUES (274, 'Gertrude', 'Lester', '1991-06-18', 'High-Energy Astro', 'Neutrino Detection');
INSERT INTO researcher VALUES (275, 'Cecil', 'Cheney', '1984-01-25', 'Optical Astronomy', 'Adaptive Optics');
INSERT INTO researcher VALUES (276, 'Mildred', 'Glover', '1982-08-14', 'Meteoritics', 'Isotope Analysis');
INSERT INTO researcher VALUES (277, 'Rufus', 'Horton', '1979-05-03', 'Astro-informatics', 'Neural Networks');
INSERT INTO researcher VALUES (278, 'Beulah', 'Orozco', '1993-12-27', 'Submillimeter Astro', 'Antenna Array Ops');
INSERT INTO researcher VALUES (279, 'Wilbur', 'Good', '1980-10-10', 'Planetary Geology', 'Seismic Processing');
INSERT INTO researcher VALUES (280, 'Winifred', 'Ingram', '1987-03-14', 'Deep Space Comm', 'Signal Decoding');
INSERT INTO researcher VALUES (281, 'Guy', 'Buckley', '1981-09-01', 'Space Weather', 'Ionosphere Research');
INSERT INTO researcher VALUES (282, 'Martha', 'Frost', '1990-07-11', 'Extragalactic Astro', 'Redshift Surveys');
INSERT INTO researcher VALUES (283, 'Ralph', 'Barker', '1978-04-05', 'Relativistic Astro', 'Lensing Analysis');
INSERT INTO researcher VALUES (284, 'Lillian', 'Vance', '1992-02-19', 'Small Bodies Sci', 'Asteroid Tracking');
INSERT INTO researcher VALUES (285, 'Norman', 'Blair', '1985-11-23', 'Astro-statistics', 'Bayesian Inference');
INSERT INTO researcher VALUES (286, 'Elsie', 'Flynn', '1983-08-30', 'Planetary Atmos', 'Gas Chromatography');
INSERT INTO researcher VALUES (287, 'Harold', 'Nash', '1977-06-15', 'Ultraviolet Astro', 'Hot Star Spectra');
INSERT INTO researcher VALUES (288, 'Edith', 'Hale', '1994-01-02', 'Archeoastronomy', 'Site Alignment');
INSERT INTO researcher VALUES (289, 'Victor', 'Lowe', '1980-05-25', 'Multi-messenger', 'Coincidence Search');
INSERT INTO researcher VALUES (290, 'Phyllis', 'Oaks', '1988-10-09', 'Supernova Sci', 'Light Curve Prep');
INSERT INTO researcher VALUES (291, 'Arthur', 'Rhodes', '1982-03-28', 'Solar Dynamics', 'Helio-seismology');
INSERT INTO researcher VALUES (292, 'Hazel', 'Sparks', '1991-09-14', 'Dark Energy', 'Expansion Mapping');
INSERT INTO researcher VALUES (293, 'Warren', 'Manning', '1979-12-04', 'Stellar Pops', 'Metallicity Grad');
INSERT INTO researcher VALUES (294, 'Maud', 'Wade', '1986-07-22', 'Cosmic Dust', 'Polarimetry');
INSERT INTO researcher VALUES (295, 'Leslie', 'Bates', '1983-11-17', 'Pulsar Timing', 'Clock Stability');
INSERT INTO researcher VALUES (296, 'Irene', 'Gould', '1992-04-10', 'Galaxy Clusters', 'Intra-cluster Med');
INSERT INTO researcher VALUES (297, 'Stanley', 'Sutton', '1975-01-30', 'Nucleosynthesis', 'Heavy Element Path');
INSERT INTO researcher VALUES (298, 'Louise', 'Heath', '1994-08-08', 'Orbital Dynamics', 'N-body Simulation');
INSERT INTO researcher VALUES (299, 'Clifford', 'Pike', '1981-05-19', 'Astro-imaging', 'CCD Processing');
INSERT INTO researcher VALUES (300, 'Rosemary', 'Cross', '1987-10-31', 'Radio Interfero', 'Baseline Fringe');

INSERT INTO designer VALUES (1, 'Spectral Imaging', 4.5, 'Radio', 1);
INSERT INTO designer VALUES (2, 'Rover Pathing', 3.8, 'Planetary', 2);
INSERT INTO designer VALUES (3, 'Stellar Models', 4.9, 'Astro', 3);
INSERT INTO designer VALUES (4, 'Dark Matter Sim', 4.2, 'Cosmology', 4);
INSERT INTO designer VALUES (5, 'Star Mapping', 3.5, 'Astrometry', 5);
INSERT INTO designer VALUES (6, 'Flare Analysis', 4.1, 'Solar', 6);
INSERT INTO designer VALUES (7, 'Transit Check', 4.7, 'Exoplanet', 7);
INSERT INTO designer VALUES (8, 'Spiral Dynamics', 3.9, 'Galactic', 8);
INSERT INTO designer VALUES (9, 'Extremophile Lab', 4.4, 'Astrobiology', 9);
INSERT INTO designer VALUES (10, 'Lens Calibration', 4.0, 'Observational', 10);
INSERT INTO designer VALUES (11, 'Wave Theory', 4.6, 'Gravitational', 11);
INSERT INTO designer VALUES (12, 'Isotope Trace', 3.7, 'Meteoritics', 12);
INSERT INTO designer VALUES (13, 'Orbit Design', 4.3, 'Celestial', 13);
INSERT INTO designer VALUES (14, 'Pulse Timing', 4.8, 'Pulsar', 14);
INSERT INTO designer VALUES (15, 'Dust Modeling', 3.6, 'Infrared', 15);
INSERT INTO designer VALUES (16, 'Signal Decoding', 4.1, 'Deep Space', 16);
INSERT INTO designer VALUES (17, 'Seismic Prep', 4.4, 'Geology', 17);
INSERT INTO designer VALUES (18, 'Antenna Array', 3.9, 'Submillimeter', 18);
INSERT INTO designer VALUES (19, 'CCD Logic', 4.0, 'Imaging', 19);
INSERT INTO designer VALUES (20, 'Neural Design', 4.9, 'Informatics', 20);
INSERT INTO designer VALUES (21, 'Chem-Molecular', 3.5, 'Astrochemistry', 21);
INSERT INTO designer VALUES (22, 'Lunar Carto', 4.2, 'Lunar Science', 22);
INSERT INTO designer VALUES (23, 'Plasma Field', 3.8, 'Plasma Astro', 23);
INSERT INTO designer VALUES (24, 'Neutrino Path', 4.5, 'High-Energy', 24);
INSERT INTO designer VALUES (25, 'Optic Fiber', 4.1, 'Optical', 25);
INSERT INTO designer VALUES (26, 'Isotope Ratio', 3.9, 'Meteoritics', 26);
INSERT INTO designer VALUES (27, 'Data Network', 4.7, 'Informatics', 27);
INSERT INTO designer VALUES (28, 'Array Control', 4.0, 'Submillimeter', 28);
INSERT INTO designer VALUES (29, 'Rock Seismic', 3.6, 'Geology', 29);
INSERT INTO designer VALUES (30, 'Deep Comm', 4.8, 'Deep Space', 30);
INSERT INTO designer VALUES (31, 'Ion-Weather', 4.3, 'Space Weather', 31);
INSERT INTO designer VALUES (32, 'Redshift Cal', 3.7, 'Extragalactic', 32);
INSERT INTO designer VALUES (33, 'Relativist Mod', 4.9, 'Relativity', 33);
INSERT INTO designer VALUES (34, 'NEO Tracking', 4.2, 'Small Bodies', 34);
INSERT INTO designer VALUES (35, 'Bayes Infer', 4.5, 'Statistics', 35);
INSERT INTO designer VALUES (36, 'Gas-Chromat', 4.0, 'Atmospheres', 36);
INSERT INTO designer VALUES (37, 'UV Spectral', 3.8, 'Ultraviolet', 37);
INSERT INTO designer VALUES (38, 'Site Align', 4.6, 'Archeoastro', 38);
INSERT INTO designer VALUES (39, 'Multi-Mess', 4.1, 'Physics', 39);
INSERT INTO designer VALUES (40, 'Curve Prep', 4.4, 'Supernova', 40);
INSERT INTO designer VALUES (41, 'Helio-Seism', 4.3, 'Solar Dyn', 41);
INSERT INTO designer VALUES (42, 'Expansion Mod', 4.7, 'Dark Energy', 42);
INSERT INTO designer VALUES (43, 'Metal Grad', 3.9, 'Stellar Pops', 43);
INSERT INTO designer VALUES (44, 'Polarimetry', 4.1, 'Cosmic Dust', 44);
INSERT INTO designer VALUES (45, 'Clock Stab', 4.8, 'Pulsar Timing', 45);
INSERT INTO designer VALUES (46, 'Cluster Med', 3.6, 'Galaxy Clust', 46);
INSERT INTO designer VALUES (47, 'Heavy Path', 4.5, 'Nucleosynth', 47);
INSERT INTO designer VALUES (48, 'N-body Sim', 4.0, 'Dynamics', 48);
INSERT INTO designer VALUES (49, 'CCD Image', 4.2, 'Astro-Imaging', 49);
INSERT INTO designer VALUES (50, 'Baseline Fringe', 3.8, 'Radio Interf', 50);
INSERT INTO designer VALUES (51, 'Radio Synth', 4.6, 'Radio', 1);
INSERT INTO designer VALUES (52, 'Mars Path', 4.1, 'Planetary', 2);
INSERT INTO designer VALUES (53, 'Star Evol', 4.4, 'Astrophysics', 3);
INSERT INTO designer VALUES (54, 'Dark Sim', 4.9, 'Cosmology', 4);
INSERT INTO designer VALUES (55, 'Map Logic', 3.7, 'Astrometry', 5);
INSERT INTO designer VALUES (56, 'Solar Mon', 4.2, 'Solar', 6);
INSERT INTO designer VALUES (57, 'Transit Met', 4.5, 'Exoplanet', 7);
INSERT INTO designer VALUES (58, 'Spiral Arm', 3.8, 'Galactic', 8);
INSERT INTO designer VALUES (59, 'Extremo Study', 4.0, 'Astrobiology', 9);
INSERT INTO designer VALUES (60, 'Tele Calib', 4.3, 'Observational', 10);
INSERT INTO designer VALUES (61, 'Math Mod', 4.7, 'Theoretical', 11);
INSERT INTO designer VALUES (62, 'Dust Img', 3.9, 'Infrared', 12);
INSERT INTO designer VALUES (63, 'X-Ray Acc', 4.1, 'X-Ray', 13);
INSERT INTO designer VALUES (64, 'Orbit Logic', 4.6, 'Celestial', 14);
INSERT INTO designer VALUES (65, 'Burst Det', 3.5, 'Gamma-Ray', 15);
INSERT INTO designer VALUES (66, 'Big Data', 4.8, 'Computational', 16);
INSERT INTO designer VALUES (67, 'Parallax Cal', 4.0, 'Metric', 17);
INSERT INTO designer VALUES (68, 'Binary Mod', 4.4, 'Stellar', 18);
INSERT INTO designer VALUES (69, 'Wave Logic', 4.3, 'Gravitational', 19);
INSERT INTO designer VALUES (70, 'Wind Anal', 3.7, 'Heliophysics', 20);
INSERT INTO designer VALUES (71, 'Chem Cloud', 4.2, 'Astrochem', 21);
INSERT INTO designer VALUES (72, 'Crater Map', 4.9, 'Lunar Science', 22);
INSERT INTO designer VALUES (73, 'Magnetic Mod', 4.5, 'Plasma', 23);
INSERT INTO designer VALUES (74, 'Neu Detect', 3.6, 'High-Energy', 24);
INSERT INTO designer VALUES (75, 'Optic Adapt', 4.1, 'Optical', 25);
INSERT INTO designer VALUES (76, 'Isotope Mod', 4.7, 'Meteoritics', 26);
INSERT INTO designer VALUES (77, 'Neural Sys', 3.9, 'Informatics', 27);
INSERT INTO designer VALUES (78, 'Antenna Op', 4.4, 'Submillimeter', 28);
INSERT INTO designer VALUES (79, 'Seismic Mod', 4.0, 'Planetary Geo', 29);
INSERT INTO designer VALUES (80, 'Signal Dec', 4.6, 'Deep Space', 30);
INSERT INTO designer VALUES (81, 'Ionosphere', 3.8, 'Space Weather', 31);
INSERT INTO designer VALUES (82, 'Redshift Mod', 4.3, 'Extragalactic', 32);
INSERT INTO designer VALUES (83, 'Lensing Mod', 4.5, 'Relativistic', 33);
INSERT INTO designer VALUES (84, 'Asteroid Mod', 4.1, 'Small Bodies', 34);
INSERT INTO designer VALUES (85, 'Stats Logic', 3.9, 'Statistics', 35);
INSERT INTO designer VALUES (86, 'Atmos Mod', 4.2, 'Planetary Atm', 36);
INSERT INTO designer VALUES (87, 'Star Spec', 4.7, 'Ultraviolet', 37);
INSERT INTO designer VALUES (88, 'Site Mod', 3.6, 'Archeoastro', 38);
INSERT INTO designer VALUES (89, 'Coincide Mod', 4.4, 'Multi-mess', 39);
INSERT INTO designer VALUES (90, 'Light Curve', 4.0, 'Supernova', 40);
INSERT INTO designer VALUES (91, 'Helio Mod', 4.8, 'Solar Dyn', 41);
INSERT INTO designer VALUES (92, 'Dark En Mod', 4.3, 'Dark Energy', 42);
INSERT INTO designer VALUES (93, 'Pop Mod', 4.1, 'Stellar Pops', 43);
INSERT INTO designer VALUES (94, 'Dust Mod', 4.6, 'Cosmic Dust', 44);
INSERT INTO designer VALUES (95, 'Time Logic', 3.7, 'Pulsar Timing', 45);
INSERT INTO designer VALUES (96, 'Cluster Logic', 4.2, 'Galaxy Clust', 46);
INSERT INTO designer VALUES (97, 'Elem Path', 4.5, 'Nucleosynth', 47);
INSERT INTO designer VALUES (98, 'Dynamics Mod', 4.9, 'Orbital Dyn', 48);
INSERT INTO designer VALUES (99, 'Imaging Mod', 3.8, 'Astro-imaging', 49);
INSERT INTO designer VALUES (100, 'Baseline Mod', 4.1, 'Radio Inter', 50);

INSERT INTO execution (exe_id, exe_date, stat) VALUES (1, '2024-04-11', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (2, '2018-12-29', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (3, '2020-10-01', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (4, '2023-10-25', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (5, '2017-08-17', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (6, '2024-11-18', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (7, '2025-01-26', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (8, '2024-10-29', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (9, '2026-02-01', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (10, '2020-03-20', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (11, '2018-01-11', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (12, '2022-01-24', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (13, '2017-03-19', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (14, '2022-05-07', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (15, '2017-08-16', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (16, '2024-07-11', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (17, '2018-07-28', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (18, '2018-12-17', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (19, '2019-12-08', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (20, '2019-08-30', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (21, '2017-11-03', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (22, '2022-02-24', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (23, '2024-02-06', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (24, '2025-07-10', 'started');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (25, '2024-05-10', 'started');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (26, '2018-05-30', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (27, '2023-01-31', 'started');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (28, '2020-10-28', 'started');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (29, '2017-10-19', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (30, '2022-12-18', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (31, '2024-08-29', 'started');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (32, '2023-01-26', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (33, '2018-09-29', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (34, '2018-08-18', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (35, '2020-02-16', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (36, '2023-05-11', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (37, '2023-02-28', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (38, '2019-08-08', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (39, '2017-08-19', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (40, '2023-07-03', 'started');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (41, '2018-06-15', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (42, '2019-07-19', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (43, '2026-03-29', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (44, '2022-10-16', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (45, '2016-05-23', 'started');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (46, '2024-01-15', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (47, '2016-01-06', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (48, '2022-01-06', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (49, '2019-02-18', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (50, '2025-11-30', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (51, '2020-10-10', 'started');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (52, '2017-06-08', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (53, '2019-09-17', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (54, '2021-02-22', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (55, '2016-09-15', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (56, '2023-01-06', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (57, '2021-03-27', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (58, '2024-09-08', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (59, '2025-08-16', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (60, '2018-10-31', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (61, '2025-11-20', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (62, '2024-04-11', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (63, '2017-09-16', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (64, '2016-09-27', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (65, '2020-03-17', 'started');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (66, '2018-03-10', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (67, '2016-10-30', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (68, '2025-01-01', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (69, '2025-05-01', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (70, '2020-02-13', 'started');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (71, '2022-06-01', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (72, '2017-05-31', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (73, '2025-05-24', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (74, '2020-10-01', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (75, '2022-06-10', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (76, '2023-09-11', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (77, '2022-07-15', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (78, '2024-02-11', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (79, '2025-10-07', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (80, '2017-09-06', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (81, '2023-03-02', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (82, '2019-09-05', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (83, '2024-07-30', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (84, '2026-05-16', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (85, '2020-08-03', 'started');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (86, '2017-03-28', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (87, '2024-03-04', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (88, '2019-07-19', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (89, '2020-06-10', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (90, '2025-01-24', 'started');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (91, '2023-04-21', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (92, '2022-03-26', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (93, '2022-10-15', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (94, '2023-01-25', 'started');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (95, '2020-08-01', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (96, '2018-01-19', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (97, '2026-02-25', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (98, '2016-11-07', 'started');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (99, '2023-07-12', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (100, '2023-05-16', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (101, '2020-02-01', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (102, '2020-01-31', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (103, '2022-11-16', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (104, '2016-08-05', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (105, '2018-02-19', 'started');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (106, '2016-03-02', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (107, '2024-08-21', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (108, '2025-02-09', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (109, '2016-04-19', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (110, '2016-03-18', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (111, '2026-03-15', 'started');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (112, '2022-10-12', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (113, '2017-05-03', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (114, '2023-10-13', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (115, '2016-04-28', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (116, '2025-04-19', 'started');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (117, '2025-05-30', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (118, '2023-04-15', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (119, '2017-11-06', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (120, '2022-12-17', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (121, '2020-12-18', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (122, '2023-01-24', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (123, '2023-09-16', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (124, '2024-02-25', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (125, '2023-05-04', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (126, '2019-11-29', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (127, '2022-03-13', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (128, '2019-04-21', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (129, '2022-10-31', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (130, '2025-10-03', 'started');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (131, '2019-11-08', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (132, '2017-02-23', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (133, '2019-02-13', 'completed successfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (134, '2016-06-03', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (135, '2024-07-25', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (136, '2019-03-12', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (137, '2016-06-07', 'started');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (138, '2023-09-12', 'started');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (139, '2022-04-25', 'started');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (140, '2020-09-28', 'started');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (141, '2023-12-11', 'planned');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (142, '2025-08-15', 'started');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (143, '2024-03-22', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (144, '2023-10-29', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (145, '2019-09-14', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (146, '2022-08-20', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (147, '2023-11-05', 'cancelled');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (148, '2025-06-24', 'started');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (149, '2025-04-10', 'completed unsuccessfully');
INSERT INTO execution (exe_id, exe_date, stat) VALUES (150, '2025-03-05', 'completed unsuccessfully');

INSERT INTO executer VALUES (101, 'Field Lead', 'Radio', 142, 88);
INSERT INTO executer VALUES (102, 'Technician', 'Planetary', 87, 12);
INSERT INTO executer VALUES (103, 'Senior Op', 'Physics', 12, 145);
INSERT INTO executer VALUES (104, 'Operator', 'Cosmo', 119, 34);
INSERT INTO executer VALUES (105, 'Site Manager', 'Astro', 54, 102);
INSERT INTO executer VALUES (106, 'Engineer', 'Solar', 131, 67);
INSERT INTO executer VALUES (107, 'Analyst Tech', 'Transit', 28, 149);
INSERT INTO executer VALUES (108, 'Field Expert', 'Spiral', 93, 21);
INSERT INTO executer VALUES (109, 'Lab Assistant', 'Biology', 110, 55);
INSERT INTO executer VALUES (110, 'Systems Op', 'Optical', 45, 118);
INSERT INTO executer VALUES (111, 'Unit Pilot', 'Rover', 122, 9);
INSERT INTO executer VALUES (112, 'Night Tech', 'Telescope', 67, 136);
INSERT INTO executer VALUES (113, 'HW Support', 'Antenna', 8, 42);
INSERT INTO executer VALUES (114, 'Safety Sp', 'Nuclear', 149, 73);
INSERT INTO executer VALUES (115, 'Collector', 'X-Ray', 33, 124);
INSERT INTO executer VALUES (116, 'Logistics', 'Space', 105, 19);
INSERT INTO executer VALUES (117, 'Coordinator', 'Gamma', 76, 81);
INSERT INTO executer VALUES (118, 'Observer', 'Visual', 21, 147);
INSERT INTO executer VALUES (119, 'Sensor Tech', 'Plasma', 114, 30);
INSERT INTO executer VALUES (120, 'Deployment', 'Satellite', 59, 112);
INSERT INTO executer VALUES (121, 'Cloud Tech', 'Chem', 138, 5);
INSERT INTO executer VALUES (122, 'Lunar Driller', 'Geo', 92, 107);
INSERT INTO executer VALUES (123, 'Plasma Op', 'Field', 44, 131);
INSERT INTO executer VALUES (124, 'High En Op', 'Neutrino', 127, 48);
INSERT INTO executer VALUES (125, 'Optic Tech', 'Glass', 15, 96);
INSERT INTO executer VALUES (126, 'Isotope Sp', 'Lab', 101, 23);
INSERT INTO executer VALUES (127, 'Net Admin', 'IT', 63, 115);
INSERT INTO executer VALUES (128, 'Array Tech', 'Radio', 111, 70);
INSERT INTO executer VALUES (129, 'Seismic Op', 'Geo', 82, 139);
INSERT INTO executer VALUES (130, 'Signal Tech', 'Comm', 4, 11);
INSERT INTO executer VALUES (131, 'Weather Sp', 'Ion', 129, 64);
INSERT INTO executer VALUES (132, 'Survey Tech', 'Galaxy', 72, 143);
INSERT INTO executer VALUES (133, 'Lens Op', 'Relativ', 98, 2);
INSERT INTO executer VALUES (134, 'Tracker', 'NEO', 31, 127);
INSERT INTO executer VALUES (135, 'Math Tech', 'Stats', 145, 85);
INSERT INTO executer VALUES (136, 'Atmos Op', 'Gas', 56, 39);
INSERT INTO executer VALUES (137, 'UV Op', 'Stars', 118, 100);
INSERT INTO executer VALUES (138, 'Field Archeo', 'Site', 89, 58);
INSERT INTO executer VALUES (139, 'Multi Op', 'Phys', 22, 134);
INSERT INTO executer VALUES (140, 'Curve Op', 'SN', 134, 17);
INSERT INTO executer VALUES (141, 'Dyn Tech', 'Solar', 60, 121);
INSERT INTO executer VALUES (142, 'Expansion Op', 'Dark', 107, 7);
INSERT INTO executer VALUES (143, 'Pop Tech', 'Stars', 41, 91);
INSERT INTO executer VALUES (144, 'Dust Op', 'Cosmic', 125, 43);
INSERT INTO executer VALUES (145, 'Time Op', 'Pulsar', 13, 119);
INSERT INTO executer VALUES (146, 'Cluster Op', 'Galaxy', 99, 66);
INSERT INTO executer VALUES (147, 'Path Tech', 'Nucl', 78, 142);
INSERT INTO executer VALUES (148, 'Orbit Op', 'Dyn', 141, 25);
INSERT INTO executer VALUES (149, 'Img Tech', 'CCD', 52, 108);
INSERT INTO executer VALUES (150, 'Baseline Op', 'Inter', 116, 51);
INSERT INTO executer VALUES (151, 'Junior Field', 'Radio', 37, 137);
INSERT INTO executer VALUES (152, 'Junior Field', 'Planetary', 121, 14);
INSERT INTO executer VALUES (153, 'Junior Field', 'Astro', 84, 125);
INSERT INTO executer VALUES (154, 'Junior Field', 'Cosmo', 9, 83);
INSERT INTO executer VALUES (155, 'Junior Field', 'Astrometry', 148, 47);
INSERT INTO executer VALUES (156, 'Junior Field', 'Solar', 66, 113);
INSERT INTO executer VALUES (157, 'Junior Field', 'Exoplanet', 103, 29);
INSERT INTO executer VALUES (158, 'Junior Field', 'Galactic', 49, 106);
INSERT INTO executer VALUES (159, 'Junior Field', 'Astrobiology', 137, 61);
INSERT INTO executer VALUES (160, 'Junior Field', 'Observ', 25, 144);
INSERT INTO executer VALUES (161, 'Junior Field', 'Theory', 113, 33);
INSERT INTO executer VALUES (162, 'Junior Field', 'Infrared', 70, 120);
INSERT INTO executer VALUES (163, 'Junior Field', 'X-Ray', 144, 4);
INSERT INTO executer VALUES (164, 'Junior Field', 'Celestial', 30, 95);
INSERT INTO executer VALUES (165, 'Junior Field', 'Gamma', 95, 132);
INSERT INTO executer VALUES (166, 'Junior Field', 'Comput', 58, 22);
INSERT INTO executer VALUES (167, 'Junior Field', 'Metric', 126, 77);
INSERT INTO executer VALUES (168, 'Junior Field', 'Stellar', 11, 150);
INSERT INTO executer VALUES (169, 'Junior Field', 'Gravit', 139, 38);
INSERT INTO executer VALUES (170, 'Junior Field', 'Helio', 81, 109);
INSERT INTO executer VALUES (171, 'Support', 'Astrochem', 47, 54);
INSERT INTO executer VALUES (172, 'Support', 'Lunar', 109, 128);
INSERT INTO executer VALUES (173, 'Support', 'Plasma', 23, 16);
INSERT INTO executer VALUES (174, 'Support', 'Energy', 117, 89);
INSERT INTO executer VALUES (175, 'Support', 'Optic', 62, 141);
INSERT INTO executer VALUES (176, 'Support', 'Meteo', 133, 40);
INSERT INTO executer VALUES (177, 'Support', 'IT', 91, 117);
INSERT INTO executer VALUES (178, 'Support', 'Array', 6, 26);
INSERT INTO executer VALUES (179, 'Support', 'Seismic', 146, 103);
INSERT INTO executer VALUES (180, 'Support', 'Signal', 55, 62);
INSERT INTO executer VALUES (181, 'Support', 'Weather', 100, 138);
INSERT INTO executer VALUES (182, 'Support', 'Survey', 39, 11);
INSERT INTO executer VALUES (183, 'Support', 'Lens', 124, 75);
INSERT INTO executer VALUES (184, 'Support', 'Asteroid', 17, 146);
INSERT INTO executer VALUES (185, 'Support', 'Math', 135, 59);
INSERT INTO executer VALUES (186, 'Support', 'Atmos', 73, 104);
INSERT INTO executer VALUES (187, 'Support', 'UV', 112, 45);
INSERT INTO executer VALUES (188, 'Support', 'Archeo', 88, 122);
INSERT INTO executer VALUES (189, 'Support', 'Phys', 29, 31);
INSERT INTO executer VALUES (190, 'Support', 'Light', 143, 80);
INSERT INTO executer VALUES (191, 'Support', 'Helio', 51, 133);
INSERT INTO executer VALUES (192, 'Support', 'Dark', 106, 15);
INSERT INTO executer VALUES (193, 'Support', 'Pop', 19, 111);
INSERT INTO executer VALUES (194, 'Support', 'Dust', 128, 63);
INSERT INTO executer VALUES (195, 'Support', 'Time', 77, 148);
INSERT INTO executer VALUES (196, 'Support', 'Cluster', 147, 49);
INSERT INTO executer VALUES (197, 'Support', 'Nucl', 43, 98);
INSERT INTO executer VALUES (198, 'Support', 'Orbit', 115, 20);
INSERT INTO executer VALUES (199, 'Support', 'CCD', 85, 135);
INSERT INTO executer VALUES (200, 'Support', 'Base', 3, 52);

INSERT INTO analyst VALUES (201, 'Data Miner', 45, 17);
INSERT INTO analyst VALUES (202, 'Stats Lead', 30, 43);
INSERT INTO analyst VALUES (203, 'Systems Anal', 55, 8);
INSERT INTO analyst VALUES (204, 'QC Expert', 25, 91);
INSERT INTO analyst VALUES (205, 'Modeler', 60, 34);
INSERT INTO analyst VALUES (206, 'Archive Spec', 40, 62);
INSERT INTO analyst VALUES (207, 'Signal Anal', 35, 5);
INSERT INTO analyst VALUES (208, 'Trend Anal', 50, 78);
INSERT INTO analyst VALUES (209, 'Bio-Stats', 48, 23);
INSERT INTO analyst VALUES (210, 'Image Anal', 42, 56);
INSERT INTO analyst VALUES (211, 'Code Auditor', 38, 14);
INSERT INTO analyst VALUES (212, 'Math Spec', 52, 87);
INSERT INTO analyst VALUES (213, 'DB Lead', 44, 31);
INSERT INTO analyst VALUES (214, 'Net Anal', 41, 69);
INSERT INTO analyst VALUES (215, 'Logic Anal', 39, 2);
INSERT INTO analyst VALUES (216, 'Graph Expert', 33, 48);
INSERT INTO analyst VALUES (217, 'Error Anal', 28, 95);
INSERT INTO analyst VALUES (218, 'Verifier', 47, 27);
INSERT INTO analyst VALUES (219, 'Pattern Search', 51, 73);
INSERT INTO analyst VALUES (220, 'Spectral Anal', 46, 11);
INSERT INTO analyst VALUES (221, 'Mol-Analyst', 40, 64);
INSERT INTO analyst VALUES (222, 'Lunar-Analyst', 38, 39);
INSERT INTO analyst VALUES (223, 'Plasma-Analyst', 44, 82);
INSERT INTO analyst VALUES (224, 'HighEn-Analyst', 35, 16);
INSERT INTO analyst VALUES (225, 'Optic-Analyst', 41, 55);
INSERT INTO analyst VALUES (226, 'Meteo-Analyst', 43, 7);
INSERT INTO analyst VALUES (227, 'Net-Analyst', 47, 93);
INSERT INTO analyst VALUES (228, 'Array-Analyst', 42, 42);
INSERT INTO analyst VALUES (229, 'Seismic-Analyst', 39, 28);
INSERT INTO analyst VALUES (230, 'Deep-Analyst', 45, 71);
INSERT INTO analyst VALUES (231, 'Weather-Analyst', 48, 19);
INSERT INTO analyst VALUES (232, 'Survey-Analyst', 41, 86);
INSERT INTO analyst VALUES (233, 'Lens-Analyst', 43, 37);
INSERT INTO analyst VALUES (234, 'NEO-Analyst', 40, 60);
INSERT INTO analyst VALUES (235, 'Math-Analyst', 37, 4);
INSERT INTO analyst VALUES (236, 'Atmos-Analyst', 44, 99);
INSERT INTO analyst VALUES (237, 'UV-Analyst', 42, 22);
INSERT INTO analyst VALUES (238, 'Archeo-Analyst', 46, 51);
INSERT INTO analyst VALUES (239, 'Multi-Analyst', 45, 13);
INSERT INTO analyst VALUES (240, 'Curve-Analyst', 39, 76);
INSERT INTO analyst VALUES (241, 'Helio-Analyst', 42, 33);
INSERT INTO analyst VALUES (242, 'Energy-Analyst', 44, 88);
INSERT INTO analyst VALUES (243, 'Pop-Analyst', 41, 45);
INSERT INTO analyst VALUES (244, 'Dust-Analyst', 43, 67);
INSERT INTO analyst VALUES (245, 'Time-Analyst', 40, 9);
INSERT INTO analyst VALUES (246, 'Cluster-Analyst', 42, 100);
INSERT INTO analyst VALUES (247, 'Path-Analyst', 44, 54);
INSERT INTO analyst VALUES (248, 'Orbit-Analyst', 41, 21);
INSERT INTO analyst VALUES (249, 'Img-Analyst', 43, 79);
INSERT INTO analyst VALUES (250, 'Inter-Analyst', 40, 36);
INSERT INTO analyst VALUES (251, 'Senior Data', 50, 12);
INSERT INTO analyst VALUES (252, 'Senior Data', 50, 58);
INSERT INTO analyst VALUES (253, 'Senior Data', 50, 83);
INSERT INTO analyst VALUES (254, 'Senior Data', 50, 29);
INSERT INTO analyst VALUES (255, 'Senior Data', 50, 47);
INSERT INTO analyst VALUES (256, 'Senior Data', 50, 3);
INSERT INTO analyst VALUES (257, 'Senior Data', 50, 92);
INSERT INTO analyst VALUES (258, 'Senior Data', 50, 66);
INSERT INTO analyst VALUES (259, 'Senior Data', 50, 18);
INSERT INTO analyst VALUES (260, 'Senior Data', 50, 74);
INSERT INTO analyst VALUES (261, 'Senior Data', 50, 41);
INSERT INTO analyst VALUES (262, 'Senior Data', 50, 97);
INSERT INTO analyst VALUES (263, 'Senior Data', 50, 25);
INSERT INTO analyst VALUES (264, 'Senior Data', 50, 53);
INSERT INTO analyst VALUES (265, 'Senior Data', 50, 6);
INSERT INTO analyst VALUES (266, 'Senior Data', 50, 85);
INSERT INTO analyst VALUES (267, 'Senior Data', 50, 32);
INSERT INTO analyst VALUES (268, 'Senior Data', 50, 70);
INSERT INTO analyst VALUES (269, 'Senior Data', 50, 15);
INSERT INTO analyst VALUES (270, 'Senior Data', 50, 89);
INSERT INTO analyst VALUES (271, 'QC Lead', 30, 44);
INSERT INTO analyst VALUES (272, 'QC Lead', 30, 61);
INSERT INTO analyst VALUES (273, 'QC Lead', 30, 10);
INSERT INTO analyst VALUES (274, 'QC Lead', 30, 96);
INSERT INTO analyst VALUES (275, 'QC Lead', 30, 38);
INSERT INTO analyst VALUES (276, 'QC Lead', 30, 77);
INSERT INTO analyst VALUES (277, 'QC Lead', 30, 20);
INSERT INTO analyst VALUES (278, 'QC Lead', 30, 49);
INSERT INTO analyst VALUES (279, 'QC Lead', 30, 84);
INSERT INTO analyst VALUES (280, 'QC Lead', 30, 26);
INSERT INTO analyst VALUES (281, 'QC Lead', 30, 63);
INSERT INTO analyst VALUES (282, 'QC Lead', 30, 1);
INSERT INTO analyst VALUES (283, 'QC Lead', 30, 90);
INSERT INTO analyst VALUES (284, 'QC Lead', 30, 46);
INSERT INTO analyst VALUES (285, 'QC Lead', 30, 72);
INSERT INTO analyst VALUES (286, 'QC Lead', 30, 35);
INSERT INTO analyst VALUES (287, 'QC Lead', 30, 57);
INSERT INTO analyst VALUES (288, 'QC Lead', 30, 98);
INSERT INTO analyst VALUES (289, 'QC Lead', 30, 24);
INSERT INTO analyst VALUES (290, 'QC Lead', 30, 81);
INSERT INTO analyst VALUES (291, 'Final Reviewer', 20, 40);
INSERT INTO analyst VALUES (292, 'Final Reviewer', 20, 68);
INSERT INTO analyst VALUES (293, 'Final Reviewer', 20, 50);
INSERT INTO analyst VALUES (294, 'Final Reviewer', 20, 30);
INSERT INTO analyst VALUES (295, 'Final Reviewer', 20, 75);
INSERT INTO analyst VALUES (296, 'Final Reviewer', 20, 94);
INSERT INTO analyst VALUES (297, 'Final Reviewer', 20, 59);
INSERT INTO analyst VALUES (298, 'Final Reviewer', 20, 16);
INSERT INTO analyst VALUES (299, 'Final Reviewer', 20, 52);
INSERT INTO analyst VALUES (300, 'Final Reviewer', 20, 80);

INSERT INTO theory VALUES (1, 'Relativ.', 'General and Special Relativity theory.');
INSERT INTO theory VALUES (2, 'Big Bang', 'The origin and expansion of universe.');
INSERT INTO theory VALUES (3, 'Quant.Mech', 'Physics of subatomic particles.');
INSERT INTO theory VALUES (4, 'Str.Theory', 'Matter made of 1D vibrating strings.');
INSERT INTO theory VALUES (5, 'Dark Mat.', 'Invisible mass holding galaxies.');
INSERT INTO theory VALUES (6, 'Dark En.', 'Force driving cosmic expansion.');
INSERT INTO theory VALUES (7, 'Inflation', 'Rapid expansion of early universe.');
INSERT INTO theory VALUES (8, 'Multivers.', 'Hypothesis of multiple universes.');
INSERT INTO theory VALUES (9, 'Black Hol.', 'Spacetime regions with high gravity.');
INSERT INTO theory VALUES (10, 'Entropy', 'Measure of disorder in a system.');
INSERT INTO theory VALUES (11, 'Supersym.', 'Particle physics symmetry model.');
INSERT INTO theory VALUES (12, 'Wormholes', 'Theoretical bridges through spacetime.');
INSERT INTO theory VALUES (13, 'Nebular', 'Formation of stars and solar systems.');
INSERT INTO theory VALUES (14, 'Redshift', 'Evidence for an expanding universe.');
INSERT INTO theory VALUES (15, 'Steady St', 'Matter is constantly being created.');
INSERT INTO theory VALUES (16, 'Anthropic', 'Universe fine-tuned for life.');
INSERT INTO theory VALUES (17, 'Cyc.Model', 'Universe in endless cycles of bang.');
INSERT INTO theory VALUES (18, 'Grav.Lens', 'Mass bending light from distant stars.');
INSERT INTO theory VALUES (19, 'Hawking R', 'Black holes emitting radiation.');
INSERT INTO theory VALUES (20, 'Kaluza-Kl', 'Theory of extra spatial dimensions.');

-- Povezivanje dizajnera sa teorijama (Tematski usklađeno)
INSERT INTO theory_designer (theory_id, designer_id) VALUES 
(14, 1), (2, 1),   -- Radio Astronomy -> Redshift, Big Bang
(5, 2), (13, 2),  -- Planetary -> Dark Matter, Nebular
(9, 3), (19, 3),  -- Astrophysics -> Black Holes, Hawking Rad
(5, 4), (6, 4),   -- Cosmology -> Dark Matter, Dark Energy
(13, 5), (20, 5), -- Astrometry -> Nebular, Kaluza-Klein
(10, 6), (1, 6),  -- Solar -> Entropy, Relativity
(5, 7), (18, 7),  -- Exoplanet -> Dark Matter, Grav. Lensing
(2, 8), (14, 8),  -- Galactic -> Big Bang, Redshift
(16, 9), (3, 9),  -- Astrobiology -> Anthropic, Quantum
(10, 10), (1, 10), -- Observational -> Entropy, Relativity
(1, 11), (18, 11), -- Gravitational -> Relativity, Grav. Lensing
(11, 12), (10, 12), -- Meteoritics -> Supersymmetry, Entropy
(13, 13), (17, 13), -- Celestial -> Nebular, Cyclic Model
(3, 14), (19, 14), -- Pulsar -> Quantum, Hawking Rad
(5, 15), (13, 15), -- Infrared -> Dark Matter, Nebular
(3, 16), (4, 16),  -- Deep Space -> Quantum, String Theory
(10, 17), (20, 17), -- Geology -> Entropy, Kaluza-Klein
(3, 18), (11, 18), -- Submillimeter -> Quantum, Supersymmetry
(1, 19), (18, 19), -- Imaging -> Relativity, Grav. Lensing
(3, 20), (4, 20),  -- Informatics -> Quantum, String Theory
(3, 21), (10, 21), -- Astrochemistry -> Quantum, Entropy
(13, 22), (16, 22), -- Lunar -> Nebular, Anthropic
(3, 23), (11, 23), -- Plasma -> Quantum, Supersymmetry
(3, 24), (11, 24), -- High-Energy -> Quantum, Supersymmetry
(1, 25), (18, 25), -- Optical -> Relativity, Grav. Lensing
(11, 26), (10, 26), -- Meteoritics -> Supersymmetry, Entropy
(3, 27), (4, 27),  -- Informatics -> Quantum, String Theory
(3, 28), (11, 28), -- Submillimeter -> Quantum, Supersymmetry
(10, 29), (17, 29), -- Geology -> Entropy, Cyclic Model
(1, 30), (8, 30),  -- Deep Space -> Relativity, Multiverse
(10, 31), (1, 31), -- Space Weather -> Entropy, Relativity
(14, 32), (2, 32), -- Extragalactic -> Redshift, Big Bang
(1, 33), (12, 33), -- Relativity -> Relativity, Wormholes
(13, 34), (5, 34), -- Small Bodies -> Nebular, Dark Matter
(3, 35), (10, 35), -- Statistics -> Quantum, Entropy
(10, 36), (16, 36), -- Atmospheres -> Entropy, Anthropic
(3, 37), (1, 37),  -- Ultraviolet -> Quantum, Relativity
(16, 38), (13, 38), -- Archeoastro -> Anthropic, Nebular
(3, 39), (11, 39), -- Physics -> Quantum, Supersymmetry
(1, 40), (14, 40), -- Supernova -> Relativity, Redshift
(10, 41), (1, 41), -- Solar Dyn -> Entropy, Relativity
(6, 42), (7, 42),  -- Dark Energy -> Dark Energy, Inflation
(13, 43), (15, 43), -- Stellar Pops -> Nebular, Steady State
(1, 44), (18, 44), -- Cosmic Dust -> Relativity, Grav. Lensing
(3, 45), (19, 45), -- Pulsar Timing -> Quantum, Hawking Rad
(5, 46), (18, 46), -- Galaxy Clust -> Dark Matter, Grav. Lensing
(10, 47), (3, 47), -- Nucleosynth -> Entropy, Quantum
(1, 48), (18, 48), -- Dynamics -> Relativity, Grav. Lensing
(1, 49), (10, 49), -- Astro-Imaging -> Relativity, Entropy
(14, 50), (2, 50), -- Radio Interf -> Redshift, Big Bang
(14, 51), (15, 51), -- Radio -> Redshift, Steady State
(13, 52), (5, 52),  -- Planetary -> Nebular, Dark Matter
(9, 53), (1, 53),   -- Astrophysics -> Black Holes, Relativity
(5, 54), (7, 54),   -- Cosmology -> Dark Matter, Inflation
(13, 55), (20, 55), -- Astrometry -> Nebular, Kaluza-Klein
(10, 56), (1, 56),  -- Solar -> Entropy, Relativity
(5, 57), (18, 57),  -- Exoplanet -> Dark Matter, Grav. Lensing
(2, 58), (14, 58),  -- Galactic -> Big Bang, Redshift
(16, 59), (3, 59),  -- Astrobiology -> Anthropic, Quantum
(1, 60), (10, 60),  -- Observational -> Relativity, Entropy
(3, 61), (4, 61),   -- Theoretical -> Quantum, String Theory
(5, 62), (13, 62),  -- Infrared -> Dark Matter, Nebular
(9, 63), (19, 63),  -- X-Ray -> Black Holes, Hawking Rad
(13, 64), (17, 64), -- Celestial -> Nebular, Cyclic Model
(3, 65), (11, 65),  -- Gamma-Ray -> Quantum, Supersymmetry
(3, 66), (4, 66),   -- Computational -> Quantum, String Theory
(1, 67), (18, 67),  -- Metric -> Relativity, Grav. Lensing
(13, 68), (15, 68), -- Stellar -> Nebular, Steady State
(1, 69), (12, 69),  -- Gravitational -> Relativity, Wormholes
(10, 70), (1, 70),  -- Heliophysics -> Entropy, Relativity
(3, 71), (10, 71),  -- Astrochem -> Quantum, Entropy
(13, 72), (16, 72), -- Lunar Science -> Nebular, Anthropic
(3, 73), (11, 73),  -- Plasma -> Quantum, Supersymmetry
(3, 74), (11, 74),  -- High-Energy -> Quantum, Supersymmetry
(1, 75), (18, 75),  -- Optical -> Relativity, Grav. Lensing
(11, 76), (10, 76), -- Meteoritics -> Supersymmetry, Entropy
(3, 77), (4, 77),   -- Informatics -> Quantum, String Theory
(3, 78), (11, 78),  -- Submillimeter -> Quantum, Supersymmetry
(10, 79), (17, 79), -- Planetary Geo -> Entropy, Cyclic Model
(1, 80), (8, 80),   -- Deep Space -> Relativity, Multiverse
(10, 81), (1, 81),  -- Space Weather -> Entropy, Relativity
(14, 82), (2, 82),  -- Extragalactic -> Redshift, Big Bang
(1, 83), (12, 83),  -- Relativistic -> Relativity, Wormholes
(13, 84), (5, 84),  -- Small Bodies -> Nebular, Dark Matter
(3, 85), (10, 85),  -- Statistics -> Quantum, Entropy
(10, 86), (16, 86), -- Planetary Atm -> Entropy, Anthropic
(3, 87), (1, 87),   -- Ultraviolet -> Quantum, Relativity
(16, 88), (13, 88), -- Archeoastro -> Anthropic, Nebular
(3, 89), (11, 89),  -- Multi-mess -> Quantum, Supersymmetry
(1, 90), (14, 90),  -- Supernova -> Relativity, Redshift
(10, 91), (1, 91),  -- Solar Dyn -> Entropy, Relativity
(6, 92), (7, 92),   -- Dark Energy -> Dark Energy, Inflation
(13, 93), (15, 93), -- Stellar Pops -> Nebular, Steady State
(1, 94), (18, 94),  -- Cosmic Dust -> Relativity, Grav. Lensing
(3, 95), (19, 95),  -- Pulsar Timing -> Quantum, Hawking Rad
(5, 96), (18, 96),  -- Galaxy Clust -> Dark Matter, Grav. Lensing
(10, 97), (3, 97),  -- Nucleosynth -> Entropy, Quantum
(1, 98), (18, 98),  -- Orbital Dyn -> Relativity, Grav. Lensing
(1, 99), (10, 99),  -- Astro-imaging -> Relativity, Entropy
(14, 100), (2, 100); -- Radio Inter -> Redshift, Big Bang

INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2022-08-06', '08:00:00', NULL, NULL, 2, 88, 2);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2016-05-28', '08:00:00', NULL, NULL, 2, 16, 88);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2021-09-25', '14:00:00', '2021-09-29', '14:00:00', NULL, 7, 23);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2019-04-11', '12:00:00', NULL, NULL, 2, 25, 42);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2016-08-23', '20:00:00', NULL, NULL, 1, 42, 32);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2025-01-11', '14:00:00', NULL, NULL, 1, 46, 35);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2021-06-08', '12:00:00', NULL, NULL, 2, 37, 58);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2019-02-02', '18:00:00', NULL, NULL, 1, 30, 56);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2022-04-11', '14:00:00', '2022-04-11', '16:00:00', NULL, 13, 84);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2023-11-14', '18:00:00', '2023-11-19', '18:00:00', NULL, 71, 93);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2021-12-31', '10:00:00', '2022-01-02', '10:00:00', NULL, 29, 74);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2017-04-10', '12:00:00', NULL, NULL, 1, 38, 20);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2017-09-07', '10:00:00', NULL, NULL, 1, 58, 34);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2024-07-06', '20:00:00', NULL, NULL, 1, 63, 57);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2019-12-20', '14:00:00', '2019-12-22', '02:00:00', NULL, 16, 94);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2024-07-12', '12:00:00', NULL, NULL, 2, 53, 33);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2024-09-01', '08:00:00', NULL, NULL, 2, 74, 54);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2025-01-28', '20:00:00', NULL, NULL, 1, 20, 11);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2019-06-13', '12:00:00', '2019-06-13', '14:00:00', NULL, 89, 4);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2017-08-23', '22:00:00', '2017-08-24', '22:00:00', NULL, 37, 12);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2024-03-11', '08:00:00', NULL, NULL, 1, 13, 59);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2020-03-23', '10:00:00', NULL, NULL, 1, 35, 45);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2022-05-10', '22:00:00', '2022-05-14', '22:00:00', NULL, 82, 55);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2022-10-03', '10:00:00', NULL, NULL, 1, 2, 61);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2025-10-25', '12:00:00', NULL, NULL, 2, 25, 71);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2020-03-08', '16:00:00', NULL, NULL, 2, 93, 6);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2022-08-10', '08:00:00', '2022-08-10', '20:00:00', NULL, 2, 47);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2016-03-24', '16:00:00', NULL, NULL, 1, 34, 16);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2017-06-27', '08:00:00', NULL, NULL, 2, 86, 43);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2025-01-29', '16:00:00', NULL, NULL, 2, 90, 16);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2017-05-21', '22:00:00', NULL, NULL, 2, 14, 30);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2024-12-27', '10:00:00', NULL, NULL, 1, 24, 31);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2019-12-19', '12:00:00', '2019-12-21', '12:00:00', NULL, 81, 27);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2019-07-23', '18:00:00', '2019-07-24', '02:00:00', NULL, 91, 43);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2025-01-12', '08:00:00', NULL, NULL, 2, 20, 48);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2025-02-15', '16:00:00', '2025-02-15', '20:00:00', NULL, 32, 47);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2022-02-22', '12:00:00', '2022-02-24', '12:00:00', NULL, 95, 70);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2016-03-16', '16:00:00', '2016-03-17', '04:00:00', NULL, 36, 55);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2020-09-12', '14:00:00', NULL, NULL, 1, 14, 63);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2021-11-16', '20:00:00', NULL, NULL, 1, 62, 50);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2018-05-19', '14:00:00', '2018-05-19', '18:00:00', NULL, 76, 62);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2017-11-02', '10:00:00', NULL, NULL, 2, 75, 79);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2016-01-18', '08:00:00', NULL, NULL, 1, 80, 5);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2017-06-23', '12:00:00', '2017-06-23', '16:00:00', NULL, 79, 29);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2016-09-07', '16:00:00', NULL, NULL, 1, 51, 49);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2022-07-02', '20:00:00', NULL, NULL, 1, 66, 9);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2016-01-14', '08:00:00', '2016-01-14', '20:00:00', NULL, 29, 10);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2021-01-01', '10:00:00', NULL, NULL, 1, 70, 95);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2022-08-06', '14:00:00', NULL, NULL, 2, 27, 17);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2020-11-15', '12:00:00', NULL, NULL, 2, 83, 12);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2026-04-13', '10:00:00', NULL, NULL, 2, 10, 97);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2021-08-18', '12:00:00', NULL, NULL, 1, 21, 37);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2024-03-23', '22:00:00', NULL, NULL, 1, 50, 51);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2024-01-09', '10:00:00', NULL, NULL, 2, 30, 7);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2022-11-09', '14:00:00', NULL, NULL, 1, 45, 15);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2017-07-05', '22:00:00', '2017-07-06', '02:00:00', NULL, 34, 13);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2017-12-07', '16:00:00', NULL, NULL, 1, 48, 19);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2023-04-22', '10:00:00', NULL, NULL, 1, 9, 73);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2018-09-12', '14:00:00', '2018-09-15', '14:00:00', NULL, 4, 4);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2020-09-20', '20:00:00', '2020-09-21', '20:00:00', NULL, 1, 2);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2016-10-23', '14:00:00', NULL, NULL, 2, 31, 39);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2019-08-20', '18:00:00', NULL, NULL, 2, 45, 36);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2018-02-13', '10:00:00', '2018-02-13', '10:00:00', NULL, 84, 24);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2016-06-05', '20:00:00', NULL, NULL, 1, 41, 39);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2019-07-15', '14:00:00', NULL, NULL, 1, 49, 77);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2023-06-08', '16:00:00', NULL, NULL, 1, 12, 8);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2019-01-03', '16:00:00', NULL, NULL, 1, 33, 5);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2022-06-22', '16:00:00', NULL, NULL, 1, 94, 10);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2024-02-20', '18:00:00', NULL, NULL, 1, 97, 50);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2017-10-14', '18:00:00', NULL, NULL, 2, 8, 14);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2017-08-05', '16:00:00', '2017-08-05', '20:00:00', NULL, 3, 3);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2018-03-22', '22:00:00', NULL, NULL, 1, 15, 7);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2016-04-21', '18:00:00', NULL, NULL, 1, 50, 40);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2017-08-01', '10:00:00', NULL, NULL, 2, 18, 68);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2016-03-14', '18:00:00', NULL, NULL, 2, 43, 72);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2025-12-23', '20:00:00', NULL, NULL, 1, 49, 60);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2022-01-13', '12:00:00', NULL, NULL, 1, 11, 98);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2016-03-29', '08:00:00', NULL, NULL, 1, 40, 100);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2018-05-17', '14:00:00', NULL, NULL, 2, 19, 27);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2022-12-17', '16:00:00', NULL, NULL, 1, 18, 13);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2023-03-26', '08:00:00', NULL, NULL, 2, 10, 35);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2017-04-11', '20:00:00', NULL, NULL, 1, 6, 8);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2023-10-04', '18:00:00', NULL, NULL, 2, 54, 40);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2020-10-01', '20:00:00', '2020-10-03', '20:00:00', NULL, 17, 67);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2018-12-12', '18:00:00', '2018-12-13', '02:00:00', NULL, 22, 90);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2025-01-24', '10:00:00', NULL, NULL, 2, 3, 44);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2021-12-15', '14:00:00', NULL, NULL, 1, 15, 69);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2016-05-16', '14:00:00', NULL, NULL, 2, 5, 65);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2019-08-28', '10:00:00', NULL, NULL, 2, 33, 15);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2025-10-29', '16:00:00', '2025-10-31', '04:00:00', NULL, 85, 29);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2018-09-22', '14:00:00', NULL, NULL, 2, 42, 52);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2023-06-17', '22:00:00', '2023-06-17', '22:00:00', NULL, 39, 58);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2022-10-01', '16:00:00', NULL, NULL, 1, 77, 19);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2024-09-16', '20:00:00', NULL, NULL, 1, 57, 53);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2024-04-09', '08:00:00', NULL, NULL, 2, 21, 30);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2021-07-17', '22:00:00', NULL, NULL, 2, 23, 91);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2024-11-26', '18:00:00', '2024-11-26', '22:00:00', NULL, 28, 96);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2022-10-13', '10:00:00', NULL, NULL, 2, 17, 54);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2020-06-19', '14:00:00', NULL, NULL, 1, 28, 85);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2022-08-17', '16:00:00', NULL, NULL, 2, 7, 34);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2024-04-30', '22:00:00', NULL, NULL, 2, 5, 82);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2022-09-04', '10:00:00', '2022-09-04', '10:00:00', NULL, 78, 9);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2016-07-13', '10:00:00', '2016-07-13', '12:00:00', NULL, 26, 22);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2025-09-02', '20:00:00', NULL, NULL, 1, 67, 48);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2020-09-30', '08:00:00', NULL, NULL, 1, 60, 1);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2017-05-12', '18:00:00', NULL, NULL, 1, 24, 14);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2018-04-14', '10:00:00', NULL, NULL, 1, 69, 39);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2020-10-26', '16:00:00', NULL, NULL, 1, 47, 89);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2025-05-25', '12:00:00', '2025-05-25', '16:00:00', NULL, 27, 46);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2017-12-26', '20:00:00', NULL, NULL, 1, 31, 11);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2019-06-22', '12:00:00', NULL, NULL, 2, 1, 1);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2020-04-30', '10:00:00', NULL, NULL, 1, 72, 45);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2019-01-06', '16:00:00', NULL, NULL, 2, 44, 26);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2025-07-08', '12:00:00', NULL, NULL, 2, 6, 17);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2024-02-28', '10:00:00', NULL, NULL, 1, 40, 44);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2024-05-24', '10:00:00', NULL, NULL, 2, 41, 25);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2021-04-23', '20:00:00', NULL, NULL, 1, 61, 25);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2025-12-17', '16:00:00', '2025-12-18', '10:00:00', NULL, 12, 57);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2018-06-09', '16:00:00', NULL, NULL, 2, 32, 92);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2018-10-30', '16:00:00', '2018-10-30', '18:00:00', NULL, 87, 86);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2021-02-24', '16:00:00', NULL, NULL, 1, 68, 53);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2018-02-18', '18:00:00', '2018-02-18', '20:00:00', NULL, 92, 36);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2024-12-28', '14:00:00', '2024-12-28', '20:00:00', NULL, 22, 78);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2022-10-01', '10:00:00', NULL, NULL, 1, 11, 26);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2022-03-26', '20:00:00', NULL, NULL, 1, 44, 87);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2022-06-04', '08:00:00', NULL, NULL, 2, 73, 49);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2024-02-17', '20:00:00', '2024-02-21', '20:00:00', NULL, 9, 37);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2016-12-03', '08:00:00', NULL, NULL, 2, 47, 41);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2016-12-28', '20:00:00', NULL, NULL, 2, 19, 6);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2017-03-12', '10:00:00', NULL, NULL, 1, 39, 75);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2018-03-10', '10:00:00', NULL, NULL, 1, 55, 20);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2019-05-08', '14:00:00', NULL, NULL, 1, 100, 46);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2017-08-23', '16:00:00', '2017-08-23', '20:00:00', NULL, 96, 33);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2017-12-10', '14:00:00', NULL, NULL, 1, 56, 28);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2022-11-29', '10:00:00', NULL, NULL, 2, 8, 83);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2016-04-12', '14:00:00', NULL, NULL, 2, 48, 59);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2020-07-14', '18:00:00', '2020-07-14', '18:00:00', NULL, 26, 38);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2020-12-19', '16:00:00', NULL, NULL, 2, 43, 18);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2022-01-30', '18:00:00', NULL, NULL, 1, 38, 66);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2019-11-26', '12:00:00', NULL, NULL, 1, 36, 3);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2023-11-19', '18:00:00', '2023-11-20', '18:00:00', NULL, 99, 60);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2023-07-20', '14:00:00', NULL, NULL, 1, 65, 21);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2025-02-03', '20:00:00', '2025-02-04', '14:00:00', NULL, 23, 18);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2017-11-01', '18:00:00', '2017-11-01', '20:00:00', NULL, 35, 76);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2024-03-02', '16:00:00', NULL, NULL, 1, 64, 99);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2016-03-08', '18:00:00', NULL, NULL, 1, 59, 64);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2017-06-09', '20:00:00', NULL, NULL, 1, 46, 56);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2016-10-06', '18:00:00', '2016-10-07', '18:00:00', NULL, 52, 81);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2019-04-14', '18:00:00', NULL, NULL, 1, 98, 28);
INSERT INTO sesion (date_start, time_start, date_end, time_end, phase_, obs_id, lab_id) VALUES ('2022-03-17', '18:00:00', '2022-03-21', '18:00:00', NULL, 4, 80);

INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (1, 'Solar Flare Analysis', 'Measuring radiation levels during flares', 150);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (2, 'Lunar Crater Mapping', 'High-res imaging of south pole craters', 149);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (3, 'Stellar Parallax', 'Calculating distance to nearby dwarfs', 148);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (4, 'Exoplanet Transit', 'Monitoring brightness dips in K-type stars', 147);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (5, 'Nebula Spectroscopy', 'Analyzing gas composition of Orion', 146);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (6, 'Dark Matter Survey', 'Gravitational lensing data collection', 145);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (7, 'Radio Jet Pulse', 'Observing synchrotron emission jets', 144);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (8, 'Comet Tail Tracking', 'Ionized gas velocity measurements', 143);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (9, 'Black Hole Shadow', 'Event horizon interferometry data', 142);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (10, 'Galaxy Rotation', 'Measuring redshift in spiral arms', 141);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (11, 'Meteor Shower Count', 'Automated optical detection of debris', 140);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (12, 'Binary Star Orbit', 'Astrometric tracking of Alpha Centauri', 139);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (13, 'Quasar Variability', 'Long-term flux monitoring in X-ray', 138);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (14, 'Cosmic Ray Flux', 'Detection of high-energy particles', 137);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (15, 'Tidal Disruption', 'Observation of star-eating black holes', 136);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (16, 'Protostar Birth', 'Infrared imaging of molecular clouds', 135);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (17, 'Asteroid Albedo', 'Reflectivity study of NEO objects', 134);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (18, 'Nova Light Curve', 'Brightness evolution of white dwarfs', 133);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (19, 'Zodiacal Light', 'Scattered light from interplanetary dust', 132);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (20, 'Magnetar Pulse', 'Extremely high magnetic field timing', 131);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (21, 'Supernova Remnant', 'Mapping shockwaves in Cassiopeia A', 130);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (22, 'Planetary Rings', 'Shadow occultation study of Saturn', 129);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (23, 'Gamma Ray Burst', 'Rapid response to high energy events', 128);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (24, 'Interstellar Medium', 'Density of gas between star clusters', 127);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (25, 'Solar Wind Impact', 'Monitoring ionospheric disturbance', 126);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (26, 'White Dwarf Cooling', 'Luminosity decay measurements', 125);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (27, 'Globular Cluster', 'Varying metallicity in M15 stars', 124);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (28, 'Brown Dwarf Hunt', 'Searching for sub-stellar companions', 123);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (29, 'Pulsar Wind Nebula', 'Relativistic particle flow imaging', 122);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (30, 'Deep Field Scan', 'Counting high-redshift galaxies', 121);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (31, 'Venus Atmosphere', 'UV absorption of sulfuric clouds', 120);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (32, 'Jupiter Auroras', 'X-ray emissions from jovian poles', 119);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (33, 'Mars Dust Storms', 'Opacity changes during global events', 118);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (34, 'Solar Corona', 'Measuring temperature of solar plasma', 117);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (35, 'Dark Energy Flow', 'Peculiar velocity of distant clusters', 116);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (36, 'Neutron Star Merger', 'Kilonova optical counterpart search', 115);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (37, 'Astrobiology Target', 'Searching for bio-signatures in Mars', 114);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (38, 'H-II Regions', 'Star formation in ionized hydrogen', 113);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (39, 'Gravitational Waves', 'Optical identification of LIGO sources', 112);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (40, 'Satellite Transit', 'Mitigating interference in telescope data', 111);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (41, 'Solar Cycle Drift', 'Sunspot migration tracking', 110);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (42, 'Titan Lakes', 'Radar mapping of liquid methane', 109);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (43, 'Open Cluster Age', 'Isochrone fitting for Pleiades', 108);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (44, 'Relativistic Jets', 'Doppler boosting in blazar flares', 107);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (45, 'Solar Neutrinos', 'Standard model consistency check', 106);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (46, 'Kuiper Belt Survey', 'Detection of slow-moving KBOs', 105);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (47, 'Microlensing Event', 'Planet detection via gravity lensing', 104);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (48, 'Heliosphere Edge', 'Interaction with interstellar wind', 103);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (49, 'Galactic Center', 'Tracking S2 star around Sgr A*', 102);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (50, 'Astro-informatics', 'Training AI for star classification', 101);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (51, 'Solar Flare Analysis', 'Measuring radiation levels during flares', 100);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (52, 'Lunar Crater Mapping', 'High-res imaging of south pole craters', 99);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (53, 'Stellar Parallax', 'Calculating distance to nearby dwarfs', 98);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (54, 'Exoplanet Transit', 'Monitoring brightness dips in K-type stars', 97);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (55, 'Nebula Spectroscopy', 'Analyzing gas composition of Orion', 96);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (56, 'Dark Matter Survey', 'Gravitational lensing data collection', 95);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (57, 'Radio Jet Pulse', 'Observing synchrotron emission jets', 94);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (58, 'Comet Tail Tracking', 'Ionized gas velocity measurements', 93);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (59, 'Black Hole Shadow', 'Event horizon interferometry data', 92);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (60, 'Galaxy Rotation', 'Measuring redshift in spiral arms', 91);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (61, 'Meteor Shower Count', 'Automated optical detection of debris', 90);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (62, 'Binary Star Orbit', 'Astrometric tracking of Alpha Centauri', 89);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (63, 'Quasar Variability', 'Long-term flux monitoring in X-ray', 88);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (64, 'Cosmic Ray Flux', 'Detection of high-energy particles', 87);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (65, 'Tidal Disruption', 'Observation of star-eating black holes', 86);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (66, 'Protostar Birth', 'Infrared imaging of molecular clouds', 85);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (67, 'Asteroid Albedo', 'Reflectivity study of NEO objects', 84);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (68, 'Nova Light Curve', 'Brightness evolution of white dwarfs', 83);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (69, 'Zodiacal Light', 'Scattered light from interplanetary dust', 82);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (70, 'Magnetar Pulse', 'Extremely high magnetic field timing', 81);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (71, 'Supernova Remnant', 'Mapping shockwaves in Cassiopeia A', 80);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (72, 'Planetary Rings', 'Shadow occultation study of Saturn', 79);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (73, 'Gamma Ray Burst', 'Rapid response to high energy events', 78);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (74, 'Interstellar Medium', 'Density of gas between star clusters', 77);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (75, 'Solar Wind Impact', 'Monitoring ionospheric disturbance', 76);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (76, 'White Dwarf Cooling', 'Luminosity decay measurements', 75);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (77, 'Globular Cluster', 'Varying metallicity in M15 stars', 74);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (78, 'Brown Dwarf Hunt', 'Searching for sub-stellar companions', 73);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (79, 'Pulsar Wind Nebula', 'Relativistic particle flow imaging', 72);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (80, 'Deep Field Scan', 'Counting high-redshift galaxies', 71);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (81, 'Venus Atmosphere', 'UV absorption of sulfuric clouds', 70);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (82, 'Jupiter Auroras', 'X-ray emissions from jovian poles', 69);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (83, 'Mars Dust Storms', 'Opacity changes during global events', 68);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (84, 'Solar Corona', 'Measuring temperature of solar plasma', 67);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (85, 'Dark Energy Flow', 'Peculiar velocity of distant clusters', 66);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (86, 'Neutron Star Merger', 'Kilonova optical counterpart search', 65);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (87, 'Astrobiology Target', 'Searching for bio-signatures in Mars', 64);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (88, 'H-II Regions', 'Star formation in ionized hydrogen', 63);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (89, 'Gravitational Waves', 'Optical identification of LIGO sources', 62);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (90, 'Satellite Transit', 'Mitigating interference in telescope data', 61);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (91, 'Solar Cycle Drift', 'Sunspot migration tracking', 60);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (92, 'Titan Lakes', 'Radar mapping of liquid methane', 59);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (93, 'Open Cluster Age', 'Isochrone fitting for Pleiades', 58);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (94, 'Relativistic Jets', 'Doppler boosting in blazar flares', 57);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (95, 'Solar Neutrinos', 'Standard model consistency check', 56);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (96, 'Kuiper Belt Survey', 'Detection of slow-moving KBOs', 55);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (97, 'Microlensing Event', 'Planet detection via gravity lensing', 54);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (98, 'Heliosphere Edge', 'Interaction with interstellar wind', 53);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (99, 'Galactic Center', 'Tracking S2 star around Sgr A*', 52);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (100, 'Astro-informatics', 'Training AI for star classification', 51);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (101, 'Solar Flare Analysis', 'Measuring radiation levels during flares', 50);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (102, 'Lunar Crater Mapping', 'High-res imaging of south pole craters', 49);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (103, 'Stellar Parallax', 'Calculating distance to nearby dwarfs', 48);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (104, 'Exoplanet Transit', 'Monitoring brightness dips in K-type stars', 47);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (105, 'Nebula Spectroscopy', 'Analyzing gas composition of Orion', 46);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (106, 'Dark Matter Survey', 'Gravitational lensing data collection', 45);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (107, 'Radio Jet Pulse', 'Observing synchrotron emission jets', 44);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (108, 'Comet Tail Tracking', 'Ionized gas velocity measurements', 43);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (109, 'Black Hole Shadow', 'Event horizon interferometry data', 42);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (110, 'Galaxy Rotation', 'Measuring redshift in spiral arms', 41);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (111, 'Meteor Shower Count', 'Automated optical detection of debris', 40);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (112, 'Binary Star Orbit', 'Astrometric tracking of Alpha Centauri', 39);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (113, 'Quasar Variability', 'Long-term flux monitoring in X-ray', 38);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (114, 'Cosmic Ray Flux', 'Detection of high-energy particles', 37);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (115, 'Tidal Disruption', 'Observation of star-eating black holes', 36);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (116, 'Protostar Birth', 'Infrared imaging of molecular clouds', 35);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (117, 'Asteroid Albedo', 'Reflectivity study of NEO objects', 34);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (118, 'Nova Light Curve', 'Brightness evolution of white dwarfs', 33);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (119, 'Zodiacal Light', 'Scattered light from interplanetary dust', 32);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (120, 'Magnetar Pulse', 'Extremely high magnetic field timing', 31);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (121, 'Supernova Remnant', 'Mapping shockwaves in Cassiopeia A', 30);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (122, 'Planetary Rings', 'Shadow occultation study of Saturn', 29);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (123, 'Gamma Ray Burst', 'Rapid response to high energy events', 28);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (124, 'Interstellar Medium', 'Density of gas between star clusters', 27);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (125, 'Solar Wind Impact', 'Monitoring ionospheric disturbance', 26);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (126, 'White Dwarf Cooling', 'Luminosity decay measurements', 25);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (127, 'Globular Cluster', 'Varying metallicity in M15 stars', 24);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (128, 'Brown Dwarf Hunt', 'Searching for sub-stellar companions', 23);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (129, 'Pulsar Wind Nebula', 'Relativistic particle flow imaging', 22);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (130, 'Deep Field Scan', 'Counting high-redshift galaxies', 21);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (131, 'Venus Atmosphere', 'UV absorption of sulfuric clouds', 20);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (132, 'Jupiter Auroras', 'X-ray emissions from jovian poles', 19);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (133, 'Mars Dust Storms', 'Opacity changes during global events', 18);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (134, 'Solar Corona', 'Measuring temperature of solar plasma', 17);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (135, 'Dark Energy Flow', 'Peculiar velocity of distant clusters', 16);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (136, 'Neutron Star Merger', 'Kilonova optical counterpart search', 15);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (137, 'Astrobiology Target', 'Searching for bio-signatures in Mars', 14);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (138, 'H-II Regions', 'Star formation in ionized hydrogen', 13);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (139, 'Gravitational Waves', 'Optical identification of LIGO sources', 12);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (140, 'Satellite Transit', 'Mitigating interference in telescope data', 11);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (141, 'Solar Cycle Drift', 'Sunspot migration tracking', 10);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (142, 'Titan Lakes', 'Radar mapping of liquid methane', 9);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (143, 'Open Cluster Age', 'Isochrone fitting for Pleiades', 8);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (144, 'Relativistic Jets', 'Doppler boosting in blazar flares', 7);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (145, 'Solar Neutrinos', 'Standard model consistency check', 6);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (146, 'Kuiper Belt Survey', 'Detection of slow-moving KBOs', 5);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (147, 'Microlensing Event', 'Planet detection via gravity lensing', 4);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (148, 'Heliosphere Edge', 'Interaction with interstellar wind', 3);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (149, 'Galactic Center', 'Tracking S2 star around Sgr A*', 2);
INSERT INTO experiment (ex_id, title, desc_, obs_id) VALUES (150, 'Astro-informatics', 'Training AI for star classification', 1);

-- Povezivanje eksperimenata 1-50 sa dizajnerima 1-50
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (11, 11), (12, 12), (13, 13), (14, 14), (15, 15);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (21, 21), (22, 22), (23, 23), (24, 24), (25, 25);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (26, 26), (27, 27), (28, 28), (29, 29), (30, 30);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (31, 31), (32, 32), (33, 33), (34, 34), (35, 35);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (36, 36), (37, 37), (38, 38), (39, 39), (40, 40);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (41, 41), (42, 42), (43, 43), (44, 44), (45, 45);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (46, 46), (47, 47), (48, 48), (49, 49), (50, 50);

-- Povezivanje eksperimenata 51-100 sa dizajnerima 51-100
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (51, 51), (52, 52), (53, 53), (54, 54), (55, 55);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (56, 56), (57, 57), (58, 58), (59, 59), (60, 60);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (61, 61), (62, 62), (63, 63), (64, 64), (65, 65);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (66, 66), (67, 67), (68, 68), (69, 69), (70, 70);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (71, 71), (72, 72), (73, 73), (74, 74), (75, 75);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (76, 76), (77, 77), (78, 78), (79, 79), (80, 80);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (81, 81), (82, 82), (83, 83), (84, 84), (85, 85);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (86, 86), (87, 87), (88, 88), (89, 89), (90, 90);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (91, 91), (92, 92), (93, 93), (94, 94), (95, 95);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (96, 96), (97, 97), (98, 98), (99, 99), (100, 100);

-- Povezivanje eksperimenata 101-150 (nasumično ponavljanje dizajnera 1-50)
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (1, 101), (2, 102), (3, 103), (4, 104), (5, 105);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (10, 106), (15, 107), (20, 108), (25, 109), (30, 110);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (5, 111), (12, 112), (18, 113), (24, 114), (33, 115);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (7, 116), (14, 117), (21, 118), (28, 119), (35, 120);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (2, 121), (9, 122), (16, 123), (23, 124), (31, 125);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (40, 126), (41, 127), (42, 128), (43, 129), (44, 130);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (45, 131), (46, 132), (47, 133), (48, 134), (49, 135);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (50, 136), (1, 137), (8, 138), (19, 139), (27, 140);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (36, 141), (37, 142), (38, 143), (39, 144), (3, 145);
INSERT INTO designer_experiment (designer_id, ex_id) VALUES (11, 146), (22, 147), (29, 148), (4, 149), (50, 150);

-- Eksperimenti 1-50 sa analitičarima 201-250
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (201, 1), (202, 2), (203, 3), (204, 4), (205, 5);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (206, 6), (207, 7), (208, 8), (209, 9), (210, 10);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (211, 11), (212, 12), (213, 13), (214, 14), (215, 15);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (216, 16), (217, 17), (218, 18), (219, 19), (220, 20);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (221, 21), (222, 22), (223, 22), (224, 24), (225, 25);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (226, 26), (227, 27), (228, 28), (229, 29), (230, 30);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (231, 31), (232, 32), (233, 33), (234, 34), (235, 35);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (236, 36), (237, 37), (238, 38), (239, 39), (240, 40);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (241, 41), (242, 42), (243, 43), (244, 44), (245, 45);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (246, 46), (247, 47), (248, 48), (249, 49), (250, 50);

-- Eksperimenti 51-100 sa analitičarima 251-300
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (251, 51), (252, 52), (253, 53), (254, 54), (255, 55);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (256, 56), (257, 57), (258, 58), (259, 59), (260, 60);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (261, 61), (262, 62), (263, 63), (264, 64), (265, 65);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (266, 66), (267, 67), (268, 68), (269, 69), (270, 70);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (271, 71), (272, 72), (273, 73), (274, 74), (275, 75);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (276, 76), (277, 77), (278, 78), (279, 79), (280, 80);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (281, 81), (282, 82), (283, 83), (284, 84), (285, 85);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (286, 86), (287, 87), (288, 88), (289, 89), (290, 90);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (291, 91), (292, 92), (293, 93), (294, 94), (295, 95);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (296, 96), (297, 97), (298, 98), (299, 99), (300, 100);

-- Eksperimenti 101-150 sa nasumičnim analitičarima (ponavljanje)
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (201, 101), (205, 102), (210, 103), (215, 104), (220, 105);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (225, 106), (230, 107), (235, 108), (240, 109), (245, 110);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (250, 111), (255, 112), (260, 113), (265, 114), (270, 115);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (275, 116), (280, 117), (285, 118), (290, 119), (295, 120);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (300, 121), (202, 122), (207, 123), (212, 124), (217, 125);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (222, 126), (227, 127), (232, 128), (237, 129), (242, 130);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (247, 131), (252, 132), (257, 133), (262, 134), (267, 135);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (272, 136), (277, 137), (282, 138), (287, 139), (292, 140);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (297, 141), (203, 142), (208, 143), (213, 144), (218, 145);
INSERT INTO analyst_experiment (anal_id, ex_id) VALUES (223, 146), (228, 147), (233, 148), (238, 149), (243, 150);

SET SQL_SAFE_UPDATES = 0;

UPDATE experiment SET valid = FALSE, done = FALSE;

UPDATE experiment 
SET valid = TRUE, done = TRUE 
WHERE ex_id IN (1, 3, 4, 7, 9, 10, 12, 14, 15, 16, 18, 20, 21, 23, 25, 26, 28, 30, 32, 33, 35, 36, 38, 39, 41, 42, 44, 45, 47, 49, 50, 51, 53, 54, 57, 59, 60, 62, 64, 65, 66, 68, 70, 71, 73, 75, 76, 78, 80, 82, 83, 85, 86, 88, 89, 91, 92, 94, 95, 97, 99, 100, 101, 103, 104, 107, 109, 110, 112, 114, 115, 116, 118, 120, 121, 123, 125, 126, 128, 130, 132, 133, 135, 136, 138, 139, 141, 142, 144, 145, 147, 149, 150);

UPDATE experiment 
SET valid = FALSE, done = TRUE 
WHERE ex_id IN (2, 6, 8, 11, 13, 17, 19, 22, 27, 29, 31, 34, 37, 40, 43, 46, 48, 52, 56, 58, 61, 63, 67, 69, 72, 77, 79, 81, 84, 87, 90, 93, 96, 98, 102, 106, 108, 111, 113, 117, 119, 122, 127, 129, 131, 134, 137, 140, 143, 146, 148);

UPDATE experiment 
SET valid = FALSE, done = FALSE 
WHERE ex_id IN (5, 24, 46, 55, 74, 93, 105, 124, 131, 143);

UPDATE resources SET res_type = 3 WHERE res_id = 1;   -- Grating Spec
UPDATE resources SET res_type = 5 WHERE res_id = 2;   -- Dish Array
UPDATE resources SET res_type = 2 WHERE res_id = 3;   -- Reflector
UPDATE resources SET res_type = 2 WHERE res_id = 4;   -- Reflector 2
UPDATE resources SET res_type = 2 WHERE res_id = 5;   -- Schmidt
UPDATE resources SET res_type = 1 WHERE res_id = 6;   -- IR Camera
UPDATE resources SET res_type = 4 WHERE res_id = 7;   -- DSA-23
UPDATE resources SET res_type = 5 WHERE res_id = 8;   -- Horn Antenn
UPDATE resources SET res_type = 3 WHERE res_id = 9;   -- Echelle Spec
UPDATE resources SET res_type = 5 WHERE res_id = 10;  -- Horn Antenn 2
UPDATE resources SET res_type = 3 WHERE res_id = 11;  -- Fiber Spec
UPDATE resources SET res_type = 2 WHERE res_id = 12;  -- Refractor
UPDATE resources SET res_type = 5 WHERE res_id = 13;  -- Phased Array
UPDATE resources SET res_type = 5 WHERE res_id = 14;  -- Dish Array 2
UPDATE resources SET res_type = 3 WHERE res_id = 15;  -- Grating Spec 2
UPDATE resources SET res_type = 5 WHERE res_id = 16;  -- Log-Periodic
UPDATE resources SET res_type = 5 WHERE res_id = 17;  -- Phased Array 2
UPDATE resources SET res_type = 3 WHERE res_id = 18;  -- Fiber Spec 2
UPDATE resources SET res_type = 5 WHERE res_id = 19;  -- Phased Array 3
UPDATE resources SET res_type = 1 WHERE res_id = 20;  -- WideField Cam
UPDATE resources SET res_type = 4 WHERE res_id = 21;  -- DSA-14
UPDATE resources SET res_type = 4 WHERE res_id = 22;  -- Parabolic Ant
UPDATE resources SET res_type = 4 WHERE res_id = 23;  -- DSN Array
UPDATE resources SET res_type = 4 WHERE res_id = 24;  -- HGA Dish
UPDATE resources SET res_type = 2 WHERE res_id = 25;  -- Refractor 2
UPDATE resources SET res_type = 4 WHERE res_id = 26;  -- DSN Array 2
UPDATE resources SET res_type = 2 WHERE res_id = 27;  -- Dobsonian
UPDATE resources SET res_type = 2 WHERE res_id = 28;  -- Schmidt 2
UPDATE resources SET res_type = 4 WHERE res_id = 29;  -- DSN Array 3
UPDATE resources SET res_type = 1 WHERE res_id = 30;  -- WideField Cam 2
UPDATE resources SET res_type = 2 WHERE res_id = 31;  -- Dobsonian 2
UPDATE resources SET res_type = 1 WHERE res_id = 32;  -- CCD Imager
UPDATE resources SET res_type = 3 WHERE res_id = 33;  -- UV Spectr
UPDATE resources SET res_type = 2 WHERE res_id = 34;  -- Cassegrain
UPDATE resources SET res_type = 1 WHERE res_id = 35;  -- CCD Imager 2
UPDATE resources SET res_type = 3 WHERE res_id = 36;  -- Echelle Spec 2
UPDATE resources SET res_type = 4 WHERE res_id = 37;  -- DSA-23 2
UPDATE resources SET res_type = 3 WHERE res_id = 38;  -- Grating Spec 3
UPDATE resources SET res_type = 1 WHERE res_id = 39;  -- UV Camera
UPDATE resources SET res_type = 2 WHERE res_id = 40;  -- Schmidt 3
UPDATE resources SET res_type = 5 WHERE res_id = 41;  -- Horn Antenn 3
UPDATE resources SET res_type = 5 WHERE res_id = 42;  -- Phased Array 4
UPDATE resources SET res_type = 3 WHERE res_id = 43;  -- Fiber Spec 3
UPDATE resources SET res_type = 4 WHERE res_id = 44;  -- HGA Dish 2
UPDATE resources SET res_type = 2 WHERE res_id = 45;  -- Dobsonian 3
UPDATE resources SET res_type = 5 WHERE res_id = 46;  -- Log-Periodic 2
UPDATE resources SET res_type = 1 WHERE res_id = 47;  -- CCD Imager 3
UPDATE resources SET res_type = 2 WHERE res_id = 48;  -- Dobsonian 4
UPDATE resources SET res_type = 4 WHERE res_id = 49;  -- Parabolic Ant 2
UPDATE resources SET res_type = 2 WHERE res_id = 50;  -- Reflector 3
UPDATE resources SET res_type = 5 WHERE res_id = 51;  -- Log-Periodic 3
UPDATE resources SET res_type = 5 WHERE res_id = 52;  -- Log-Periodic 4
UPDATE resources SET res_type = 5 WHERE res_id = 53;  -- Horn Antenn 4
UPDATE resources SET res_type = 3 WHERE res_id = 54;  -- Grating Spec 4
UPDATE resources SET res_type = 3 WHERE res_id = 55;  -- UV Spectr 2
UPDATE resources SET res_type = 4 WHERE res_id = 56;  -- DSN Array 4
UPDATE resources SET res_type = 5 WHERE res_id = 57;  -- Horn Antenn 5
UPDATE resources SET res_type = 2 WHERE res_id = 58;  -- Schmidt 4
UPDATE resources SET res_type = 4 WHERE res_id = 59;  -- DSN Array 5
UPDATE resources SET res_type = 5 WHERE res_id = 60;  -- Log-Periodic 5
UPDATE resources SET res_type = 2 WHERE res_id = 61;  -- Refractor 3
UPDATE resources SET res_type = 4 WHERE res_id = 62;  -- DSN Array 6
UPDATE resources SET res_type = 5 WHERE res_id = 63;  -- Log-Periodic 6
UPDATE resources SET res_type = 4 WHERE res_id = 64;  -- DSN Array 7
UPDATE resources SET res_type = 5 WHERE res_id = 65;  -- VLBI Dish
UPDATE resources SET res_type = 4 WHERE res_id = 66;  -- DSA-14 2
UPDATE resources SET res_type = 2 WHERE res_id = 67;  -- Dobsonian 5
UPDATE resources SET res_type = 1 WHERE res_id = 68;  -- IR Camera 2
UPDATE resources SET res_type = 4 WHERE res_id = 69;  -- DSA-23 3
UPDATE resources SET res_type = 2 WHERE res_id = 70;  -- Refractor 4
UPDATE resources SET res_type = 4 WHERE res_id = 71;  -- DSA-23 4
UPDATE resources SET res_type = 1 WHERE res_id = 72;  -- UV Camera 2
UPDATE resources SET res_type = 4 WHERE res_id = 73;  -- HGA Dish 3
UPDATE resources SET res_type = 1 WHERE res_id = 74;  -- CCD Imager 4
UPDATE resources SET res_type = 3 WHERE res_id = 75;  -- Echelle Spec 3
UPDATE resources SET res_type = 3 WHERE res_id = 76;  -- Fiber Spec 4
UPDATE resources SET res_type = 3 WHERE res_id = 77;  -- Echelle Spec 4
UPDATE resources SET res_type = 4 WHERE res_id = 78;  -- DSA-14 3
UPDATE resources SET res_type = 3 WHERE res_id = 79;  -- Echelle Spec 5
UPDATE resources SET res_type = 1 WHERE res_id = 80;  -- WideField Cam 3
UPDATE resources SET res_type = 3 WHERE res_id = 81;  -- UV Spectr 3
UPDATE resources SET res_type = 1 WHERE res_id = 82;  -- IR Camera 3
UPDATE resources SET res_type = 3 WHERE res_id = 83;  -- IFU Spectr
UPDATE resources SET res_type = 5 WHERE res_id = 84;  -- Horn Antenn 6
UPDATE resources SET res_type = 1 WHERE res_id = 85;  -- CCD Imager 5
UPDATE resources SET res_type = 5 WHERE res_id = 86;  -- Phased Array 5
UPDATE resources SET res_type = 4 WHERE res_id = 87;  -- DSN Array 8
UPDATE resources SET res_type = 2 WHERE res_id = 88;  -- Cassegrain 2
UPDATE resources SET res_type = 4 WHERE res_id = 89;  -- HGA Dish 4
UPDATE resources SET res_type = 3 WHERE res_id = 90;  -- Fiber Spec 5
UPDATE resources SET res_type = 5 WHERE res_id = 91;  -- VLBI Dish 2
UPDATE resources SET res_type = 1 WHERE res_id = 92;  -- WideField Cam 4
UPDATE resources SET res_type = 1 WHERE res_id = 93;  -- UV Camera 3
UPDATE resources SET res_type = 2 WHERE res_id = 94;  -- Reflector 4
UPDATE resources SET res_type = 1 WHERE res_id = 95;  -- UV Camera 4
UPDATE resources SET res_type = 5 WHERE res_id = 96;  -- Horn Antenn 7
UPDATE resources SET res_type = 3 WHERE res_id = 97;  -- Echelle Spec 6
UPDATE resources SET res_type = 4 WHERE res_id = 98;  -- DSA-14 4
UPDATE resources SET res_type = 1 WHERE res_id = 99;  -- AllSky Cam
UPDATE resources SET res_type = 3 WHERE res_id = 100; -- Fiber Spec 6

UPDATE tools SET lab_id = 1 WHERE tool_id IN (1, 2);
UPDATE tools SET lab_id = 2 WHERE tool_id IN (3, 4);
UPDATE tools SET lab_id = 3 WHERE tool_id IN (5, 6);
UPDATE tools SET lab_id = 4 WHERE tool_id IN (7, 8);
UPDATE tools SET lab_id = 5 WHERE tool_id IN (9, 10);
UPDATE tools SET lab_id = 6 WHERE tool_id IN (11, 12);
UPDATE tools SET lab_id = 7 WHERE tool_id IN (13, 14);
UPDATE tools SET lab_id = 8 WHERE tool_id IN (15, 16);
UPDATE tools SET lab_id = 9 WHERE tool_id IN (17, 18);
UPDATE tools SET lab_id = 10 WHERE tool_id IN (19, 20);
UPDATE tools SET lab_id = 11 WHERE tool_id IN (21, 22);
UPDATE tools SET lab_id = 12 WHERE tool_id IN (23, 24);
UPDATE tools SET lab_id = 13 WHERE tool_id IN (25, 26);
UPDATE tools SET lab_id = 14 WHERE tool_id IN (27, 28);
UPDATE tools SET lab_id = 15 WHERE tool_id IN (29, 30);
UPDATE tools SET lab_id = 16 WHERE tool_id IN (31, 32);
UPDATE tools SET lab_id = 17 WHERE tool_id IN (33, 34);
UPDATE tools SET lab_id = 18 WHERE tool_id IN (35, 36);
UPDATE tools SET lab_id = 19 WHERE tool_id IN (37, 38);
UPDATE tools SET lab_id = 20 WHERE tool_id IN (39, 40);
UPDATE tools SET lab_id = 21 WHERE tool_id IN (41, 42);
UPDATE tools SET lab_id = 22 WHERE tool_id IN (43, 44);
UPDATE tools SET lab_id = 23 WHERE tool_id IN (45, 46);
UPDATE tools SET lab_id = 24 WHERE tool_id IN (47, 48);
UPDATE tools SET lab_id = 25 WHERE tool_id IN (49, 50);
UPDATE tools SET lab_id = 26 WHERE tool_id IN (51, 52);
UPDATE tools SET lab_id = 27 WHERE tool_id IN (53, 54);
UPDATE tools SET lab_id = 28 WHERE tool_id IN (55, 56);
UPDATE tools SET lab_id = 29 WHERE tool_id IN (57, 58);
UPDATE tools SET lab_id = 30 WHERE tool_id IN (59, 60);
UPDATE tools SET lab_id = 31 WHERE tool_id IN (61, 62);
UPDATE tools SET lab_id = 32 WHERE tool_id IN (63, 64);
UPDATE tools SET lab_id = 33 WHERE tool_id IN (65, 66);
UPDATE tools SET lab_id = 34 WHERE tool_id IN (67, 68);
UPDATE tools SET lab_id = 35 WHERE tool_id IN (69, 70);
UPDATE tools SET lab_id = 36 WHERE tool_id IN (71, 72);
UPDATE tools SET lab_id = 37 WHERE tool_id IN (73, 74);
UPDATE tools SET lab_id = 38 WHERE tool_id IN (75, 76);
UPDATE tools SET lab_id = 39 WHERE tool_id IN (77, 78);
UPDATE tools SET lab_id = 40 WHERE tool_id IN (79, 80);
UPDATE tools SET lab_id = 41 WHERE tool_id IN (81, 82);
UPDATE tools SET lab_id = 42 WHERE tool_id IN (83, 84);
UPDATE tools SET lab_id = 43 WHERE tool_id IN (85, 86);
UPDATE tools SET lab_id = 44 WHERE tool_id IN (87, 88);
UPDATE tools SET lab_id = 45 WHERE tool_id IN (89, 90);
UPDATE tools SET lab_id = 46 WHERE tool_id IN (91, 92);
UPDATE tools SET lab_id = 47 WHERE tool_id IN (93, 94);
UPDATE tools SET lab_id = 48 WHERE tool_id IN (95, 96);
UPDATE tools SET lab_id = 49 WHERE tool_id IN (97, 98);
UPDATE tools SET lab_id = 50 WHERE tool_id IN (99, 100);
UPDATE tools SET lab_id = 51 WHERE tool_id IN (101, 102);
UPDATE tools SET lab_id = 52 WHERE tool_id IN (103, 104);
UPDATE tools SET lab_id = 53 WHERE tool_id IN (105, 106);
UPDATE tools SET lab_id = 54 WHERE tool_id IN (107, 108);
UPDATE tools SET lab_id = 55 WHERE tool_id IN (109, 110);
UPDATE tools SET lab_id = 56 WHERE tool_id IN (111, 112);
UPDATE tools SET lab_id = 57 WHERE tool_id IN (113, 114);
UPDATE tools SET lab_id = 58 WHERE tool_id IN (115, 116);
UPDATE tools SET lab_id = 59 WHERE tool_id IN (117, 118);
UPDATE tools SET lab_id = 60 WHERE tool_id IN (119, 120);
UPDATE tools SET lab_id = 61 WHERE tool_id IN (121, 122);
UPDATE tools SET lab_id = 62 WHERE tool_id IN (123, 124);
UPDATE tools SET lab_id = 63 WHERE tool_id IN (125, 126);
UPDATE tools SET lab_id = 64 WHERE tool_id IN (127, 128);
UPDATE tools SET lab_id = 65 WHERE tool_id IN (129, 130);
UPDATE tools SET lab_id = 66 WHERE tool_id IN (131, 132);
UPDATE tools SET lab_id = 67 WHERE tool_id IN (133, 134);
UPDATE tools SET lab_id = 68 WHERE tool_id IN (135, 136);
UPDATE tools SET lab_id = 69 WHERE tool_id IN (137, 138);
UPDATE tools SET lab_id = 70 WHERE tool_id IN (139, 140);
UPDATE tools SET lab_id = 71 WHERE tool_id IN (141, 142);
UPDATE tools SET lab_id = 72 WHERE tool_id IN (143, 144);
UPDATE tools SET lab_id = 73 WHERE tool_id IN (145, 146);
UPDATE tools SET lab_id = 74 WHERE tool_id IN (147, 148);
UPDATE tools SET lab_id = 75 WHERE tool_id IN (149, 150);
UPDATE tools SET lab_id = 76 WHERE tool_id IN (151, 152);
UPDATE tools SET lab_id = 77 WHERE tool_id IN (153, 154);
UPDATE tools SET lab_id = 78 WHERE tool_id IN (155, 156);
UPDATE tools SET lab_id = 79 WHERE tool_id IN (157, 158);
UPDATE tools SET lab_id = 80 WHERE tool_id IN (159, 160);
UPDATE tools SET lab_id = 81 WHERE tool_id IN (161, 162);
UPDATE tools SET lab_id = 82 WHERE tool_id IN (163, 164);
UPDATE tools SET lab_id = 83 WHERE tool_id IN (165, 166);
UPDATE tools SET lab_id = 84 WHERE tool_id IN (167, 168);
UPDATE tools SET lab_id = 85 WHERE tool_id IN (169, 170);
UPDATE tools SET lab_id = 86 WHERE tool_id IN (171, 172);
UPDATE tools SET lab_id = 87 WHERE tool_id IN (173, 174);
UPDATE tools SET lab_id = 88 WHERE tool_id IN (175, 176);
UPDATE tools SET lab_id = 89 WHERE tool_id IN (177, 178);
UPDATE tools SET lab_id = 90 WHERE tool_id IN (179, 180);
UPDATE tools SET lab_id = 91 WHERE tool_id IN (181, 182);
UPDATE tools SET lab_id = 92 WHERE tool_id IN (183, 184);
UPDATE tools SET lab_id = 93 WHERE tool_id IN (185, 186);
UPDATE tools SET lab_id = 94 WHERE tool_id IN (187, 188);
UPDATE tools SET lab_id = 95 WHERE tool_id IN (189, 190);
UPDATE tools SET lab_id = 96 WHERE tool_id IN (191, 192);
UPDATE tools SET lab_id = 97 WHERE tool_id IN (193, 194);
UPDATE tools SET lab_id = 98 WHERE tool_id IN (195, 196);
UPDATE tools SET lab_id = 99 WHERE tool_id IN (197, 198);
UPDATE tools SET lab_id = 100 WHERE tool_id IN (199, 200);

SET SQL_SAFE_UPDATES = 1;