-- Top 10 games by total playtime in the last 30 days (wide scan + aggregate)
SELECT g.title AS game_title,
    SUM(pf.duration_seconds) AS total_playtime_seconds
FROM plays_fact pf
    JOIN games g ON pf.game_id = g.game_id
WHERE pf.played_at >= NOW() - INTERVAL '30 days'
GROUP BY g.game_id,
    g.title
ORDER BY total_playtime_seconds DESC
LIMIT 10;
-- ClickHouse equivalent query on denormalized plays_wide table
SELECT game_title,
    sum(duration_seconds) AS total_seconds
FROM plays_wide
WHERE played_at >= now() - INTERVAL 30 DAY
GROUP BY game_title
ORDER BY total_seconds DESC
LIMIT 10;