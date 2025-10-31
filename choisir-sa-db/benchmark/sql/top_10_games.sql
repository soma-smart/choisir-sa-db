-- Top 10 games by total playtime in the last 30 days (wide scan + aggregate)
SELECT game_title,
    sum(duration_seconds) AS total_seconds
FROM arcade.plays_wide
WHERE played_at >= now() - INTERVAL 30 DAY
GROUP BY game_title
ORDER BY total_seconds DESC
LIMIT 10;