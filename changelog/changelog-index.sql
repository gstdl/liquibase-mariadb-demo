--liquibase formatted sql

--changeset imdb:101-create-directors-name-index
CREATE INDEX idx_directors_name ON directors (first_name, last_name);
--rollback DROP INDEX idx_directors_name ON directors;

--changeset imdb:102-create-actors-name-index
CREATE INDEX idx_actors_name ON actors (first_name, last_name);
--rollback DROP INDEX idx_actors_name ON actors;

--changeset imdb:103-create-movies-name-index
CREATE INDEX idx_movies_name ON movies (name);
--rollback DROP INDEX idx_movies_name ON movies;

--changeset imdb:104-create-movies-year-index
CREATE INDEX idx_movies_year ON movies (year);
--rollback DROP INDEX idx_movies_year ON movies;

--changeset imdb:105-create-movies-rank-index
CREATE INDEX idx_movies_rank ON movies (movie_rank);
--rollback DROP INDEX idx_movies_rank ON movies;

--changeset imdb:106-create-directors-genres-genre-index
CREATE INDEX idx_directors_genres_genre ON directors_genres (genre);
--rollback DROP INDEX idx_directors_genres_genre ON directors_genres;

--changeset imdb:107-create-movies-genres-genre-index
CREATE INDEX idx_movies_genres_genre ON movies_genres (genre);
--rollback DROP INDEX idx_movies_genres_genre ON movies_genres;

--changeset imdb:108-create-roles-role-index
CREATE INDEX idx_roles_role ON roles (role);
--rollback DROP INDEX idx_roles_role ON roles;
