-- Denormalized plays table
CREATE TABLE arcade.plays_wide (
    played_at DateTime64(3) NOT NULL,
    player_id UInt64,
    player_first_name LowCardinality(String),
    player_last_name LowCardinality(String),
    player_country FixedString(2),
    game_id UInt64,
    game_title LowCardinality(String),
    genre LowCardinality(String),
    arcade_id UInt64,
    arcade_name LowCardinality(String),
    arcade_city LowCardinality(String),
    arcade_country FixedString(2),
    score UInt32,
    duration_seconds UInt16
) ENGINE = MergeTree() PARTITION BY toYYYYMM(played_at)
ORDER BY (game_id, played_at, player_id);