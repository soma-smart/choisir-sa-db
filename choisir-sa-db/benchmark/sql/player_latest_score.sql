-- Find a player's latest score for a given game (selective, index-friendly)
-- Requires: CREATE INDEX ON plays_fact (player_id, game_id, played_at DESC)
SELECT f.score,
    f.played_at
FROM plays_fact AS f
WHERE f.player_id = $1
    AND f.game_id = $2
ORDER BY f.played_at DESC
LIMIT 1;
-- ClickHouse equivalent query on denormalized plays_wide table
SELECT score,
    played_at
FROM plays_wide
WHERE player_id = { player_id :UInt64 }
    AND game_id = { game_id :UInt64 }
ORDER BY played_at DESC
LIMIT 1;