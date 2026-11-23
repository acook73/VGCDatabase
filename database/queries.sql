-- ============================================================
-- QUERY 1: PLAYER TOURNAMENT HISTORY
-- Find a player's tournament appearances and placements.
-- Requirements: WHERE, ORDER BY, INNER JOIN
-- ============================================================

.print '========================================'
.print 'QUERY 1: PLAYER TOURNAMENT HISTORY'
.print '========================================'

SELECT
    p.player_name,
    t.tournament_name,
    t.game,
    t.format,
    te.placement,
    tm.team_id
FROM Player AS p
INNER JOIN TournamentEntry AS te
    ON p.player_id = te.player_id
INNER JOIN Tournament AS t
    ON te.tournament_id = t.tournament_id
INNER JOIN Team AS tm
    ON te.team_id = tm.team_id
WHERE p.player_name = 'Wolfe Glick'
ORDER BY t.start_date DESC;

-- ============================================================
-- QUERY 2: TEAMS USING A POKEMON
-- Find every team that included a specified Pokémon.
-- Requirement: INNER JOIN
-- ============================================================

.print '========================================'
.print 'QUERY 2: TEAMS USING A POKEMON'
.print '========================================'

SELECT
    pokemon.pokemon_name,
    p.player_name,
    t.tournament_name,
    tm.team_id
FROM Pokemon AS pokemon
INNER JOIN TeamPokemon AS tp
    ON pokemon.pokemon_id = tp.pokemon_id
INNER JOIN Team AS tm
    ON tp.team_id = tm.team_id
INNER JOIN Player AS p
    ON tm.player_id = p.player_id
INNER JOIN TournamentEntry AS te
    ON tm.team_id = te.team_id
INNER JOIN Tournament AS t
    ON te.tournament_id = t.tournament_id
WHERE pokemon.pokemon_name = 'Xerneas'
ORDER BY t.start_date, p.player_name;

-- ============================================================
-- QUERY 3: TEAM DETAILS
-- Display the Pokémon and configurations for a specified team.
-- Requirement: LEFT JOIN
-- ============================================================
.print '========================================'
.print 'QUERY 3: TEAM DETAILS'
.print '========================================'

SELECT
    p.player_name,
    tm.team_id,
    tp.slot,
    pokemon.pokemon_name,
    tp.ability,
    tp.held_item,
    tp.tera_type,
    tp.move1,
    tp.move2,
    tp.move3,
    tp.move4
FROM Team AS tm
INNER JOIN Player AS p
    ON tm.player_id = p.player_id
LEFT JOIN TeamPokemon AS tp
    ON tm.team_id = tp.team_id
LEFT JOIN Pokemon AS pokemon
    ON tp.pokemon_id = pokemon.pokemon_id
WHERE tm.team_id = 9
ORDER BY tp.slot;

-- ============================================================
-- QUERY 4: TOURNAMENT STANDINGS
-- Display the standings for a specified tournament.
-- Requirement: JOIN across three or more tables
-- ============================================================
.print '========================================'
.print 'QUERY 4: TOURNAMENT STANDINGS'
.print '========================================'

SELECT
    t.tournament_name,
    t.game,
    t.format,
    p.player_name,
    p.player_country,
    tm.team_id,
    te.placement
FROM Tournament AS t
INNER JOIN TournamentEntry AS te
    ON t.tournament_id = te.tournament_id
INNER JOIN Player AS p
    ON te.player_id = p.player_id
INNER JOIN Team AS tm
    ON te.team_id = tm.team_id
WHERE t.tournament_id = 2
ORDER BY te.placement;

-- ============================================================
-- QUERY 5: POPULAR POKEMON
-- Find Pokémon used by at least three distinct players.
-- Requirement: GROUP BY and HAVING
-- ============================================================
.print '========================================'
.print 'QUERY 5: POPULAR POKEMON'
.print '========================================'

SELECT
    pokemon.pokemon_name,
    COUNT(DISTINCT tm.player_id) AS player_count
FROM Pokemon AS pokemon
INNER JOIN TeamPokemon AS tp
    ON pokemon.pokemon_id = tp.pokemon_id
INNER JOIN Team AS tm
    ON tp.team_id = tm.team_id
GROUP BY pokemon.pokemon_id, pokemon.pokemon_name
HAVING COUNT(DISTINCT tm.player_id) >= 3
ORDER BY player_count DESC;

-- ============================================================
-- QUERY 6: POKEMON USAGE STATISTICS
-- Calculate how frequently each Pokémon appears on a team.
-- Requirements: Aggregate functions
-- ============================================================
.print '========================================'
.print 'QUERY 6: POKEMON USAGE STATISTICS'
.print '========================================'

SELECT
    pokemon.pokemon_name,
    COUNT(DISTINCT tp.team_id) AS team_count,
    COUNT(DISTINCT tp.team_id) || '/' ||
        (SELECT COUNT(*) FROM Team) AS team_fraction,
    ROUND(
        100.0 * COUNT(DISTINCT tp.team_id) /
        (SELECT COUNT(*) FROM Team),
        2
    ) AS team_percentage
FROM Pokemon AS pokemon
LEFT JOIN TeamPokemon AS tp
    ON pokemon.pokemon_id = tp.pokemon_id
GROUP BY pokemon.pokemon_id, pokemon.pokemon_name
ORDER BY team_count DESC, pokemon.pokemon_name;

-- ============================================================
-- QUERY 7: ABOVE-AVERAGE TOURNAMENT PLACEMENT
-- Find players who placed better than their tournament's average.
-- Requirement: Subquery
-- ============================================================
.print '========================================'
.print 'QUERY 7: ABOVE-AVERAGE TOURNAMENT PLACEMENT'
.print '========================================'

SELECT
    t.tournament_name,
    p.player_name,
    te.placement
FROM TournamentEntry AS te
INNER JOIN Tournament AS t
    ON te.tournament_id = t.tournament_id
INNER JOIN Player AS p
    ON te.player_id = p.player_id
WHERE te.placement < (
    SELECT AVG(te2.placement)
    FROM TournamentEntry AS te2
    WHERE te2.tournament_id = te.tournament_id
)
ORDER BY t.start_date, te.placement;

-- ============================================================
-- QUERY 8: POKEMON USED IN EITHER TOURNAMENT
-- List Pokémon appearing in at least one of the two tournaments.
-- Requirement: Set operation (UNION)
-- ============================================================
.print '========================================'
.print 'QUERY 8: POKEMON USED IN ALL TOURNAMNETS'
.print '========================================'

SELECT pokemon.pokemon_name
FROM Pokemon AS pokemon
INNER JOIN TeamPokemon AS tp
    ON pokemon.pokemon_id = tp.pokemon_id
INNER JOIN Team AS tm
    ON tp.team_id = tm.team_id
INNER JOIN TournamentEntry AS te
    ON tm.team_id = te.team_id
WHERE te.tournament_id = 1

UNION

SELECT pokemon.pokemon_name
FROM Pokemon AS pokemon
INNER JOIN TeamPokemon AS tp
    ON pokemon.pokemon_id = tp.pokemon_id
INNER JOIN Team AS tm
    ON tp.team_id = tm.team_id
INNER JOIN TournamentEntry AS te
    ON tm.team_id = te.team_id
WHERE te.tournament_id = 2

ORDER BY pokemon_name;

-- ============================================================
-- QUERY 9: TOURNAMENT TEAM OVERVIEW
-- Display the teams and Pokémon used in a specific tournament,
-- ordered by tournament placement.
-- Requirement: Use a Deliverable 3 view
-- ============================================================
.print '========================================'
.print 'QUERY 9: TOURNAMENT TEAM OVERVIEW'
.print '========================================'

SELECT
    t.tournament_name,
    te.placement,
    v."Player Name",
    v."Player Country",
    v."Pokemon Name 1",
    v."Pokemon Name 2",
    v."Pokemon Name 3",
    v."Pokemon Name 4",
    v."Pokemon Name 5",
    v."Pokemon Name 6"
FROM vw_player_teams AS v
INNER JOIN TournamentEntry AS te
    ON v."Team ID" = te.team_id
INNER JOIN Tournament AS t
    ON te.tournament_id = t.tournament_id
WHERE t.tournament_id = 2
ORDER BY te.placement;

-- ============================================================
-- QUERY 10: UNUSED POKEMON
-- Find Pokémon that did not appear on any tournament team.
-- Requirement: LEFT JOIN with unmatched data
-- ============================================================
.print '========================================'
.print 'QUERY 10: UNUSED POKEMON'
.print '========================================'

SELECT
    pokemon.pokemon_name,
    tp.team_id
FROM Pokemon AS pokemon
LEFT JOIN TeamPokemon AS tp
    ON pokemon.pokemon_id = tp.pokemon_id
WHERE tp.team_id IS NULL
ORDER BY pokemon.pokemon_name;