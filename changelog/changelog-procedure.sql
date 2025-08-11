--liquibase formatted sql

--changeset imdb:301-create-get-movie-cast-procedure
CREATE PROCEDURE GET_MOVIE_CAST (IN movie_id_param INT)
BEGIN
SELECT
    a.id,
    a.gender,
    r.role,
    CONCAT(a.first_name, ' ', a.last_name) AS actor_name
FROM actors AS a
INNER JOIN roles AS r ON a.id = r.actor_id
WHERE r.movie_id = movie_id_param
ORDER BY a.last_name, a.first_name;
END;
--rollback DROP PROCEDURE IF EXISTS GetMovieCast;

--changeset imdb:302-create-get-director-movies-procedure
CREATE PROCEDURE GET_DIRECTOR_MOVIES (IN director_id_param INT)
BEGIN
SELECT
    m.id,
    m.movie_name,
    m.movie_year,
    m.movie_rank
FROM movies AS m
INNER JOIN movies_directors AS md ON m.id = md.movie_id
WHERE md.director_id = director_id_param
ORDER BY m.movie_year DESC, m.movie_rank DESC;
END;
--rollback DROP PROCEDURE IF EXISTS GetDirectorMovies;

--changeset imdb:303-create-search-movies-by-genre-procedure
CREATE PROCEDURE SEARCH_MOVIES_BY_GENRE (IN genre_param VARCHAR(100))
BEGIN
SELECT
    m.id,
    m.movie_name,
    m.movie_year,
    m.movie_rank
FROM movies AS m
INNER JOIN movies_genres AS mg ON m.id = mg.movie_id
WHERE mg.genre = genre_param
ORDER BY m.movie_rank DESC, m.movie_year DESC;
END;
--rollback DROP PROCEDURE IF EXISTS SearchMoviesByGenre;

--changeset imdb:304-create-get-actor-filmography-procedure
CREATE PROCEDURE GET_ACTOR_FILMOGRAPHY (IN actor_id_param INT)
BEGIN
SELECT
    m.id,
    m.movie_name,
    m.movie_year,
    m.movie_rank,
    r.role
FROM movies AS m
INNER JOIN roles AS r ON m.id = r.movie_id
WHERE r.actor_id = actor_id_param
ORDER BY m.movie_year DESC, m.movie_rank DESC;
END;
--rollback DROP PROCEDURE IF EXISTS GetActorFilmography;
