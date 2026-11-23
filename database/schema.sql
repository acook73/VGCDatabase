
-- ============================================================
-- schema.sql
-- Pokémon VGC Database
-- DBMS: SQLite
-- ============================================================

-- Enable foreign-key enforcement for this SQLite connection.
PRAGMA foreign_keys = ON;

-- Drop the view and tables so the schema can be recreated.
-- Drop dependent tables before the tables they reference.
DROP VIEW IF EXISTS vw_tournament_standings;
DROP VIEW IF EXISTS vw_player_teams;

DROP TABLE IF EXISTS Match;
DROP TABLE IF EXISTS TournamentEntry;
DROP TABLE IF EXISTS TeamPokemon;
DROP TABLE IF EXISTS Tournament;
DROP TABLE IF EXISTS Team;
DROP TABLE IF EXISTS Player;
DROP TABLE IF EXISTS Pokemon;


-- ============================================================
-- 1. POKEMON
-- Stores species or competitive variants, not individual
-- Pokémon caught by a player.
-- pokemon_id is the PK because a Pokédex number can repeat.
-- ============================================================

CREATE TABLE Pokemon (
    pokemon_id INTEGER PRIMARY KEY,
    pokedex_number INTEGER NOT NULL,
    pokemon_name TEXT NOT NULL,
    pokemon_type1 TEXT NOT NULL DEFAULT 'Normal',
    pokemon_type2 TEXT,
    -- Pokédex numbers must be positive.
    CHECK (pokedex_number > 0)
);


-- ============================================================
-- 2. PLAYER
-- Stores players who own teams and enter tournaments.
-- ============================================================

CREATE TABLE Player (
    player_id INTEGER PRIMARY KEY,
    player_name TEXT NOT NULL UNIQUE,
    player_country TEXT NOT NULL
);


-- ============================================================
-- 3. TEAM
-- Each team belongs to exactly one player.
-- A player may own multiple teams.
-- ============================================================

CREATE TABLE Team (
    team_id INTEGER PRIMARY KEY,
    player_id INTEGER NOT NULL,
    format TEXT NOT NULL,

    FOREIGN KEY (player_id)
        REFERENCES Player(player_id),

    -- This composite UNIQUE constraint allows TournamentEntry
    -- to verify that a selected team belongs to its player.
    UNIQUE (team_id, player_id)
);


-- ============================================================
-- 4. TEAM POKEMON
-- An associative entity connecting Team and Pokemon.
-- Its attributes describe how a Pokémon is configured on a team.
-- Each team can have up to six entries, one per slot.
-- ============================================================

CREATE TABLE TeamPokemon (
    team_id INTEGER NOT NULL,
    pokemon_id INTEGER NOT NULL,
    slot INTEGER NOT NULL,
    ability TEXT NOT NULL,
    held_item TEXT,
    tera_type TEXT,
    move1 TEXT NOT NULL,
    move2 TEXT,
    move3 TEXT,
    move4 TEXT,

    FOREIGN KEY (team_id)
        REFERENCES Team(team_id)
        ON DELETE CASCADE,

    FOREIGN KEY (pokemon_id)
        REFERENCES Pokemon(pokemon_id),

    -- Slots must be between 1 and 6.
    CHECK (slot BETWEEN 1 AND 6),

    -- Each slot on a team can be occupied only once.
    UNIQUE (team_id, slot),

    -- Moves must be filled in order: move4 cannot exist without
    -- move3, and move3 cannot exist without move2.
    CHECK (move2 IS NOT NULL OR
           (move3 IS NULL AND move4 IS NULL)),

    CHECK (move3 IS NOT NULL OR move4 IS NULL)
);


-- ============================================================
-- 5. TOURNAMENT
-- Stores tournament information.
-- The winner is derived from TournamentEntry.placement = 1,
-- rather than storing the winner redundantly here.
-- Dates use ISO format: YYYY-MM-DD.
-- ============================================================

CREATE TABLE Tournament (
    tournament_id INTEGER PRIMARY KEY,
    tournament_name TEXT NOT NULL,
    location TEXT NOT NULL,
    start_date TEXT NOT NULL,
    end_date TEXT NOT NULL,
    division TEXT NOT NULL,
    game TEXT NOT NULL,
    format TEXT NOT NULL,

    CHECK (date(start_date) IS NOT NULL),
    CHECK (date(end_date) IS NOT NULL),
    CHECK (date(end_date) >= date(start_date))
);


-- ============================================================
-- 6. TOURNAMENT ENTRY
-- Connects a player, tournament, and the team they used.
-- The composite PK allows only one entry per player per event.
-- ============================================================

CREATE TABLE TournamentEntry (
    tournament_id INTEGER NOT NULL,
    player_id INTEGER NOT NULL,
    team_id INTEGER NOT NULL,
    placement INTEGER,
    -- Note that wins, losses, and ties are only for Swiss, not for the final bracket
    wins INTEGER,
    losses INTEGER,
    ties INTEGER,

    PRIMARY KEY (tournament_id, player_id),

    FOREIGN KEY (tournament_id)
        REFERENCES Tournament(tournament_id)
        ON DELETE CASCADE,

    FOREIGN KEY (player_id)
        REFERENCES Player(player_id),

    -- Ensures the player actually owns the team they entered.
    FOREIGN KEY (team_id, player_id)
        REFERENCES Team(team_id, player_id),

    -- Placement must be positive when it is provided.
    CHECK (placement IS NULL OR placement > 0),

    -- Wins, Losses, and Ties must all be either null or greater than 0
    CHECK (wins IS NULL OR wins >= 0),
    CHECK (losses IS NULL OR losses >= 0),
    CHECK (ties IS NULL OR ties >= 0)
);

-- ============================================================
-- VIEW: TOURNAMENT STANDINGS
-- Combines tournament, player, team, and entry information.
-- Useful for reports that show players and their placements.
-- ============================================================

CREATE VIEW vw_tournament_standings AS
SELECT
    t.tournament_id,
    t.tournament_name,
    t.start_date,
    p.player_id,
    p.player_name,
    p.player_country,
    tm.team_id,
    te.placement
FROM TournamentEntry AS te
JOIN Tournament AS t
    ON te.tournament_id = t.tournament_id
JOIN Player AS p
    ON te.player_id = p.player_id
JOIN Team AS tm
    ON te.team_id = tm.team_id;

  


-- ============================================================
-- VIEW: PLAYER TEAMS
-- Displays each player's team with Pokémon in slots 1-6.
-- ============================================================

CREATE VIEW vw_player_teams AS
SELECT
    p.player_id AS "Player ID",
    p.player_name AS "Player Name",
    p.player_country AS "Player Country",
    tm.team_id AS "Team ID",
    tm.format AS "Format",

    MAX(CASE WHEN tp.slot = 1 THEN pokemon.pokemon_name END) AS "Pokemon Name 1",
    MAX(CASE WHEN tp.slot = 2 THEN pokemon.pokemon_name END) AS "Pokemon Name 2",
    MAX(CASE WHEN tp.slot = 3 THEN pokemon.pokemon_name END) AS "Pokemon Name 3",
    MAX(CASE WHEN tp.slot = 4 THEN pokemon.pokemon_name END) AS "Pokemon Name 4",
    MAX(CASE WHEN tp.slot = 5 THEN pokemon.pokemon_name END) AS "Pokemon Name 5",
    MAX(CASE WHEN tp.slot = 6 THEN pokemon.pokemon_name END) AS "Pokemon Name 6"

FROM Player AS p
JOIN Team AS tm
    ON p.player_id = tm.player_id
LEFT JOIN TeamPokemon AS tp
    ON tm.team_id = tp.team_id
LEFT JOIN Pokemon AS pokemon
    ON tp.pokemon_id = pokemon.pokemon_id

GROUP BY
    p.player_id,
    p.player_name,
    p.player_country,
    tm.team_id,
    tm.format;




-- ============================================================
-- INDEX: PLAYER TOURNAMENT HISTORY
-- Helps queries that search TournamentEntry by player_id.
-- This is an explicitly created index, not an automatic PK index.
-- ============================================================

CREATE INDEX idx_tournamententry_player
ON TournamentEntry(player_id);
