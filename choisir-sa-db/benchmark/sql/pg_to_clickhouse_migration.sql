-- In ClickHouse: fill plays_wide by joining PostgreSQL tables via table function
INSERT INTO plays_wide
SELECT f.played_at,
    toUInt64(f.player_id) AS player_id,
    p.first_name AS player_first_name,
    p.last_name AS player_last_name,
    p.country_code AS player_country,
    toUInt64(f.game_id) AS game_id,
    g.title AS game_title,
    g.genre AS genre,
    toUInt64(f.arcade_id) AS arcade_id,
    a.name AS arcade_name,
    a.city AS arcade_city,
    a.country_code AS arcade_country,
    toUInt32(f.score) AS score,
    toUInt16(f.duration_seconds) AS duration_seconds
FROM postgresql(
        'postgres:5432',
        'postgres',
        'plays_fact',
        'postgres',
        'secretpw'
    ) AS f
    INNER JOIN postgresql(
        'postgres:5432',
        'postgres',
        'players',
        'postgres',
        'secretpw'
    ) AS p ON p.player_id = f.player_id
    INNER JOIN postgresql(
        'postgres:5432',
        'postgres',
        'games',
        'postgres',
        'secretpw'
    ) AS g ON g.game_id = f.game_id
    INNER JOIN postgresql(
        'postgres:5432',
        'postgres',
        'arcades',
        'postgres',
        'secretpw'
    ) AS a ON a.arcade_id = f.arcade_id;