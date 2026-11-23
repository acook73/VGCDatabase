
-- ============================================================
-- TRANSACTION: REGISTER A NEW PLAYER AND TEAM
-- Demonstrates a multi-step transaction with ROLLBACK.
-- ============================================================

BEGIN TRANSACTION;

-- Step 1: Add a new player.
INSERT INTO Player (
    player_id,
    player_name,
    player_country
)
VALUES (
    24,
    'Transaction Test Player',
    'United States'
);

-- Step 2: Create a team for the new player.
INSERT INTO Team (
    team_id,
    player_id,
    format
)
VALUES (
    25,
    24,
    'VGC Regulation Set G'
);

-- Step 3: Add six Pokemon to the team.
-- Pokemon IDs are retrieved by name to avoid relying on
-- the IDs assigned to the expanded Pokemon catalogue.

WITH roster(
    pokemon_name, slot, ability, held_item, tera_type,
    move1, move2, move3, move4
) AS (
    VALUES
    ('Charizard', 1, 'Blaze', 'Charcoal', 'Fire',
        'Heat Wave', 'Air Slash', 'Protect', 'Overheat'),
    ('Venusaur', 2, 'Chlorophyll', 'Miracle Seed', 'Grass',
        'Leaf Storm', 'Sludge Bomb', 'Sleep Powder', 'Protect'),
    ('Blastoise', 3, 'Torrent', 'Mystic Water', 'Water',
        'Water Spout', 'Ice Beam', 'Fake Out', 'Protect'),
    ('Pikachu', 4, 'Lightning Rod', 'Light Ball', 'Electric',
        'Thunderbolt', 'Volt Tackle', 'Fake Out', 'Protect'),
    ('Arcanine', 5, 'Intimidate', 'Safety Goggles', 'Grass',
        'Flare Blitz', 'Extreme Speed', 'Snarl', 'Protect'),
    ('Gyarados', 6, 'Intimidate', 'Clear Amulet', 'Flying',
        'Waterfall', 'Tera Blast', 'Dragon Dance', 'Protect')
)
INSERT INTO TeamPokemon (
    team_id,
    pokemon_id,
    slot,
    ability,
    held_item,
    tera_type,
    move1,
    move2,
    move3,
    move4
)
SELECT
    25,
    p.pokemon_id,
    r.slot,
    r.ability,
    r.held_item,
    r.tera_type,
    r.move1,
    r.move2,
    r.move3,
    r.move4
FROM roster AS r
INNER JOIN Pokemon AS p
    ON r.pokemon_name = p.pokemon_name;

-- Step 4: Register the player and team for the tournament.
INSERT INTO TournamentEntry (
    tournament_id,
    player_id,
    team_id,
    placement,
    wins,
    losses,
    ties
)
VALUES (
    1,
    24,
    25,
    NULL,
    NULL,
    NULL,
    NULL
);

-- Step 5: Display the newly registered player and team.
SELECT
    p.player_name,
    t.tournament_name,
    tm.team_id,
    COUNT(tp.pokemon_id) AS pokemon_count
FROM TournamentEntry AS te
INNER JOIN Player AS p ON te.player_id = p.player_id
INNER JOIN Tournament AS t ON te.tournament_id = t.tournament_id
INNER JOIN Team AS tm ON te.team_id = tm.team_id
LEFT JOIN TeamPokemon AS tp ON tm.team_id = tp.team_id
WHERE p.player_id = 24
GROUP BY p.player_name, t.tournament_name, tm.team_id;

-- Step 6: Undo the transaction so the database
-- remains unchanged when the script is run again.
ROLLBACK;
