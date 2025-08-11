--liquibase formatted sql

--changeset imdb:001-create-directors-table
CREATE TABLE directors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL
);
--rollback DROP TABLE directors;

--changeset imdb:002-create-actors-table
CREATE TABLE actors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    gender CHAR(1)
);
--rollback DROP TABLE actors;

--changeset imdb:003-create-movies-table
CREATE TABLE movies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(500) NOT NULL,
    year INT,
    rank FLOAT
);
--rollback DROP TABLE movies;

--changeset imdb:004-create-directors-genres-table
CREATE TABLE directors_genres (
    director_id INT NOT NULL,
    genre VARCHAR(100) NOT NULL,
    prob FLOAT,
    PRIMARY KEY (director_id, genre),
    FOREIGN KEY (director_id) REFERENCES directors(id) ON DELETE CASCADE
);
--rollback DROP TABLE directors_genres;

--changeset imdb:005-create-movies-directors-table
CREATE TABLE movies_directors (
    director_id INT NOT NULL,
    movie_id INT NOT NULL,
    PRIMARY KEY (director_id, movie_id),
    FOREIGN KEY (director_id) REFERENCES directors(id) ON DELETE CASCADE,
    FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE
);
--rollback DROP TABLE movies_directors;

--changeset imdb:006-create-movies-genres-table
CREATE TABLE movies_genres (
    movie_id INT NOT NULL,
    genre VARCHAR(100) NOT NULL,
    PRIMARY KEY (movie_id, genre),
    FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE
);
--rollback DROP TABLE movies_genres;

--changeset imdb:007-create-roles-table
CREATE TABLE roles (
    actor_id INT NOT NULL,
    movie_id INT NOT NULL,
    role VARCHAR(500),
    PRIMARY KEY (actor_id, movie_id, role),
    FOREIGN KEY (actor_id) REFERENCES actors(id) ON DELETE CASCADE,
    FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE
);
--rollback DROP TABLE roles;
