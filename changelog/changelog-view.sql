--liquibase formatted sql

--changeset imdb:201-create-movie-details-view
CREATE VIEW v_movie_details AS
SELECT
    m.id,
    m.movie_name,
    m.movie_year,
    m.movie_rank,
    GROUP_CONCAT(
        DISTINCT mg.genre
        ORDER BY mg.genre
        SEPARATOR ', '
    )                              AS genres,
    COUNT(DISTINCT r.actor_id)     AS actor_count,
    COUNT(DISTINCT md.director_id) AS director_count
FROM movies AS m
LEFT JOIN movies_genres AS mg ON m.id = mg.movie_id
LEFT JOIN roles AS r ON m.id = r.movie_id
LEFT JOIN movies_directors AS md ON m.id = md.movie_id
GROUP BY m.id, m.movie_name, m.movie_year, m.movie_rank;
--rollback DROP VIEW v_movie_details;

--changeset imdb:202-create-director-stats-view
CREATE VIEW v_director_stats AS
SELECT
    d.id,
    CONCAT(d.first_name, ' ', d.last_name) AS full_name,
    COUNT(DISTINCT md.movie_id)            AS movie_count,
    GROUP_CONCAT(
        DISTINCT dg.genre
        ORDER BY dg.genre
        SEPARATOR ', '
    )                                      AS preferred_genres,
    AVG(m.movie_rank)                      AS avg_movie_rank
FROM directors AS d
LEFT JOIN movies_directors AS md ON d.id = md.director_id
LEFT JOIN directors_genres AS dg ON d.id = dg.director_id
LEFT JOIN movies AS m ON md.movie_id = m.id
GROUP BY d.id, d.first_name, d.last_name;
--rollback DROP VIEW v_director_stats;

--changeset imdb:203-create-actor-stats-view
CREATE VIEW v_actor_stats AS
SELECT
    a.id,
    a.gender,
    CONCAT(a.first_name, ' ', a.last_name) AS full_name,
    COUNT(DISTINCT r.movie_id)             AS movie_count,
    COUNT(DISTINCT r.role)                 AS unique_roles_count,
    AVG(m.movie_rank)                      AS avg_movie_rank
FROM actors AS a
LEFT JOIN roles AS r ON a.id = r.actor_id
LEFT JOIN movies AS m ON r.movie_id = m.id
GROUP BY a.id, a.first_name, a.last_name, a.gender;
--rollback DROP VIEW v_actor_stats;

--changeset imdb:204-create-genre-stats-view
CREATE VIEW v_genre_stats AS
SELECT
    mg.genre,
    COUNT(DISTINCT mg.movie_id) AS movie_count,
    AVG(m.movie_rank)           AS avg_movie_rank,
    MAX(m.movie_rank)           AS best_movie_rank,
    MIN(m.movie_year)           AS earliest_year,
    MAX(m.movie_year)           AS latest_year
FROM movies_genres AS mg
INNER JOIN movies AS m ON mg.movie_id = m.id
WHERE m.movie_rank IS NOT NULL
GROUP BY mg.genre
ORDER BY avg_movie_rank DESC;
--rollback DROP VIEW v_genre_stats;
