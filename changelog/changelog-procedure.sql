--liquibase formatted sql

--changeset imdb:301-create-get-movie-cast-procedure
CREATE PROCEDURE GetMovieCast(IN movie_id_param INT)
BEGIN
    SELECT 
        a.id,
        CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
        a.gender,
        r.role
    FROM actors a
    JOIN roles r ON a.id = r.actor_id
    WHERE r.movie_id = movie_id_param
    ORDER BY a.last_name, a.first_name;
END;
--rollback DROP PROCEDURE IF EXISTS GetMovieCast;

--changeset imdb:302-create-get-director-movies-procedure
CREATE PROCEDURE GetDirectorMovies(IN director_id_param INT)
BEGIN
    SELECT 
        m.id,
        m.name,
        m.year,
        m.rank
    FROM movies m
    JOIN movies_directors md ON m.id = md.movie_id
    WHERE md.director_id = director_id_param
    ORDER BY m.year DESC, m.rank DESC;
END;
--rollback DROP PROCEDURE IF EXISTS GetDirectorMovies;

--changeset imdb:303-create-search-movies-by-genre-procedure
CREATE PROCEDURE SearchMoviesByGenre(IN genre_param VARCHAR(100))
BEGIN
    SELECT 
        m.id,
        m.name,
        m.year,
        m.rank
    FROM movies m
    JOIN movies_genres mg ON m.id = mg.movie_id
    WHERE mg.genre = genre_param
    ORDER BY m.rank DESC, m.year DESC;
END;
--rollback DROP PROCEDURE IF EXISTS SearchMoviesByGenre;

--changeset imdb:304-create-get-actor-filmography-procedure
CREATE PROCEDURE GetActorFilmography(IN actor_id_param INT)
BEGIN
    SELECT 
        m.id,
        m.name,
        m.year,
        m.rank,
        r.role
    FROM movies m
    JOIN roles r ON m.id = r.movie_id
    WHERE r.actor_id = actor_id_param
    ORDER BY m.year DESC, m.rank DESC;
END;
--rollback DROP PROCEDURE IF EXISTS GetActorFilmography;
