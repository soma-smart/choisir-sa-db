-- Dimension: players
CREATE TABLE players (
    player_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name text NOT NULL,
    last_name text NOT NULL,
    country_code char(2) NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now()
);
-- Dimension: games
CREATE TABLE games (
    game_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title text NOT NULL,
    genre text NOT NULL,
    release_year smallint
);
-- Dimension: arcades (locations)
CREATE TABLE arcades (
    arcade_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name text NOT NULL,
    city text NOT NULL,
    country_code char(2) NOT NULL
);
-- Fact: plays_fact
CREATE TABLE plays_fact (
    play_id bigserial PRIMARY KEY,
    player_id bigint NOT NULL REFERENCES players(player_id),
    game_id bigint NOT NULL REFERENCES games(game_id),
    arcade_id bigint NOT NULL REFERENCES arcades(arcade_id),
    played_at timestamptz NOT NULL,
    score integer NOT NULL,
    duration_seconds integer NOT NULL CHECK (duration_seconds >= 0)
);
-- OLAP-friendly B-tree indexes to support selective lookups and order-by/limit
CREATE INDEX ON plays_fact (player_id, game_id, played_at DESC);
CREATE INDEX ON plays_fact (game_id, played_at);
CREATE INDEX ON plays_fact (played_at);