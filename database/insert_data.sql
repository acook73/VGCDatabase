
-- ============================================================
-- insert_data.sql
-- Pokémon VGC Database
-- Tournament: 2025 Europe International Championships
-- Division: Masters
-- Regulation Set G
--
-- Run schema.sql first.
-- SQLite foreign-key enforcement must be enabled on this
-- connection before running these inserts.
-- ============================================================

PRAGMA foreign_keys = ON;


-- ============================================================
-- 1. TOURNAMENT
-- ============================================================

INSERT INTO Tournament (
    tournament_id,
    tournament_name,
    location,
    start_date,
    end_date,
    division,
    game,
    format
)
VALUES (
    1,
    '2025 Europe International Championships',
    'London, United Kingdom',
    '2025-02-21',
    '2025-02-23',
    'Masters',
    'Pokémon Scarlet and Violet',
    'Regulation G'
);


-- ============================================================
-- 2. PLAYERS
-- Country names are stored in full for readability.
-- ============================================================

INSERT INTO Player (
    player_id,
    player_name,
    player_country
)
VALUES
    (1, 'Wolfe Glick', 'United States'),
    (2, 'Dylan Yeomans', 'United Kingdom'),
    (3, 'Yosuke Takayanagi', 'Japan'),
    (4, 'Taran Birdee', 'United Kingdom'),
    (5, 'Gavin Michaels', 'United States'),
    (6, 'Joseph Ugarte', 'United States'),
    (7, 'Grant Laird', 'United States'),
    (8, 'Théotime Massaut', 'France');


-- ============================================================
-- 3. TEAMS
-- One team per player for this tournament.
-- ============================================================

INSERT INTO Team (
    team_id,
    player_id,
    format
)
VALUES
    (1, 1, 'VGC Regulation Set G'),
    (2, 2, 'VGC Regulation Set G'),
    (3, 3, 'VGC Regulation Set G'),
    (4, 4, 'VGC Regulation Set G'),
    (5, 5, 'VGC Regulation Set G'),
    (6, 6, 'VGC Regulation Set G'),
    (7, 7, 'VGC Regulation Set G'),
    (8, 8, 'VGC Regulation Set G');


-- ============================================================
-- 4. POKEMON
-- Each species/form is entered once and reused across teams.
-- Different battle forms have separate pokemon_id values.
-- ============================================================

INSERT INTO Pokemon (
    pokemon_id,
    pokedex_number,
    pokemon_name,
    pokemon_type1,
    pokemon_type2
)
VALUES
    (1,  591, 'Amoonguss',                 'Grass',    'Poison'),
    (2,  727, 'Incineroar',                'Fire',     'Dark'),
    (3,  985, 'Scream Tail',               'Fairy',    'Psychic'),
    (4, 1007, 'Koraidon',                  'Fighting', 'Dragon'),
    (5,  987, 'Flutter Mane',              'Ghost',    'Fairy'),
    (6,  576, 'Gothitelle',                'Psychic',  NULL),
    (7,  981, 'Farigiraf',                 'Normal',   'Psychic'),
    (8, 1008, 'Miraidon',                  'Electric', 'Dragon'),
    (9,  990, 'Iron Treads',               'Ground',   'Steel'),
    (10, 892, 'Urshifu (Single Strike)',   'Fighting', 'Dark'),
    (11, 992, 'Iron Hands',                'Fighting', 'Electric'),
    (12,1004, 'Chi-Yu',                    'Dark',     'Fire'),
    (13, 898, 'Calyrex (Ice Rider)',       'Psychic',  'Ice'),
    (14,1017, 'Ogerpon (Cornerstone)',     'Grass',    'Rock'),
    (15, 892, 'Urshifu (Rapid Strike)',    'Fighting', 'Water'),
    (16,1017, 'Ogerpon (Hearthflame)',     'Grass',    'Fire'),
    (17, 547, 'Whimsicott',                'Grass',    'Fairy'),
    (18,1002, 'Chien-Pao',                 'Dark',     'Ice'),
    (19, 382, 'Kyogre',                    'Water',    NULL),
    (20, 641, 'Tornadus (Incarnate)',      'Flying',   NULL),
    (21, 637, 'Volcarona',                 'Bug',      'Fire'),
    (22, 861, 'Grimmsnarl',                'Dark',     'Fairy'),
    (23, 132, 'Ditto',                     'Normal',   NULL),
    (24, 244, 'Entei',                     'Fire',     NULL),
    (25, 898, 'Calyrex (Shadow Rider)',    'Psychic',  'Ghost'),
    (26,  35, 'Clefairy',                  'Fairy',    NULL),
    (27, 279, 'Pelipper',                  'Water',    'Flying'),
    (28, 812, 'Rillaboom',                 'Grass',    NULL);


-- ============================================================
-- 5. TEAM POKEMON
-- slot records the roster order from the supplied team lists.
-- Moves are stored in the same order as the source.
-- ============================================================

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
VALUES

    -- --------------------------------------------------------
    -- Team 1: Wolfe Glick
    -- --------------------------------------------------------

    (1,  1, 1, 'Regenerator', 'Mental Herb', 'Dark',
        'Protect', 'Rage Powder', 'Spore', 'Sludge Bomb'),

    (1,  2, 2, 'Intimidate', 'Safety Goggles', 'Bug',
        'Fake Out', 'Parting Shot', 'Flare Blitz', 'Protect'),

    (1,  3, 3, 'Protosynthesis', 'Booster Energy', 'Dark',
        'Protect', 'Encore', 'Disable', 'Perish Song'),

    (1,  4, 4, 'Orichalcum Pulse', 'Life Orb', 'Fire',
        'Protect', 'Flare Blitz', 'Close Combat', 'Flame Charge'),

    (1,  5, 5, 'Protosynthesis', 'Focus Sash', 'Normal',
        'Protect', 'Icy Wind', 'Moonblast', 'Shadow Ball'),

    (1,  6, 6, 'Shadow Tag', 'Leftovers', 'Water',
        'Protect', 'Psychic', 'Fake Out', 'Taunt'),


    -- --------------------------------------------------------
    -- Team 2: Dylan Yeomans
    -- --------------------------------------------------------

    (2,  7, 1, 'Armor Tail', 'Electric Seed', 'Water',
        'Psychic', 'Roar', 'Trick Room', 'Helping Hand'),

    (2,  8, 2, 'Hadron Engine', 'Choice Specs', 'Fairy',
        'Electro Drift', 'Volt Switch', 'Draco Meteor', 'Dazzling Gleam'),

    (2,  9, 3, 'Quark Drive', 'Choice Band', 'Ghost',
        'Iron Head', 'High Horsepower', 'Rock Slide', 'Steel Roller'),

    (2, 10, 4, 'Unseen Fist', 'Focus Sash', 'Dark',
        'Detect', 'Wicked Blow', 'Sucker Punch', 'Close Combat'),

    (2,  2, 5, 'Intimidate', 'Rocky Helmet', 'Ghost',
        'Flare Blitz', 'Knock Off', 'U-turn', 'Fake Out'),

    (2, 11, 6, 'Quark Drive', 'Assault Vest', 'Poison',
        'Drain Punch', 'Low Kick', 'Heavy Slam', 'Fake Out'),


    -- --------------------------------------------------------
    -- Team 3: Yosuke Takayanagi
    -- --------------------------------------------------------

    (3, 12, 1, 'Beads of Ruin', 'Choice Scarf', 'Ghost',
        'Heat Wave', 'Overheat', 'Dark Pulse', 'Snarl'),

    (3,  5, 2, 'Protosynthesis', 'Booster Energy', 'Fairy',
        'Moonblast', 'Dazzling Gleam', 'Icy Wind', 'Protect'),

    (3, 13, 3, 'As One', 'Clear Amulet', 'Water',
        'Glacial Lance', 'High Horsepower', 'Trick Room', 'Protect'),

    (3, 14, 4, 'Sturdy', 'Cornerstone Mask', 'Rock',
        'Ivy Cudgel', 'Power Whip', 'Follow Me', 'Spiky Shield'),

    (3,  1, 5, 'Regenerator', 'Rocky Helmet', 'Water',
        'Clear Smog', 'Pollen Puff', 'Rage Powder', 'Spore'),

    (3, 15, 6, 'Unseen Fist', 'Focus Sash', 'Stellar',
        'Surging Strikes', 'Close Combat', 'Taunt', 'Detect'),


    -- --------------------------------------------------------
    -- Team 4: Taran Birdee
    -- --------------------------------------------------------

    (4, 16, 1, 'Mold Breaker', 'Hearthflame Mask', 'Fire',
        'Ivy Cudgel', 'Wood Hammer', 'Follow Me', 'Spiky Shield'),

    (4,  8, 2, 'Hadron Engine', 'Choice Specs', 'Fairy',
        'Dazzling Gleam', 'Draco Meteor', 'Electro Drift', 'Volt Switch'),

    (4, 17, 3, 'Prankster', 'Covert Cloak', 'Dark',
        'Tailwind', 'Moonblast', 'Encore', 'Light Screen'),

    (4, 15, 4, 'Unseen Fist', 'Mystic Water', 'Water',
        'Surging Strikes', 'Aqua Jet', 'Taunt', 'Detect'),

    (4, 11, 5, 'Quark Drive', 'Assault Vest', 'Water',
        'Fake Out', 'Low Kick', 'Drain Punch', 'Heavy Slam'),

    (4,  7, 6, 'Armor Tail', 'Electric Seed', 'Water',
        'Trick Room', 'Helping Hand', 'Psychic', 'Foul Play'),


    -- --------------------------------------------------------
    -- Team 5: Gavin Michaels
    -- --------------------------------------------------------

    (5, 15, 1, 'Unseen Fist', 'Choice Scarf', 'Water',
        'Surging Strikes', 'Close Combat', 'Aqua Jet', 'U-turn'),

    (5, 11, 2, 'Quark Drive', 'Assault Vest', 'Grass',
        'Fake Out', 'Drain Punch', 'Wild Charge', 'Low Kick'),

    (5, 18, 3, 'Sword of Ruin', 'Focus Sash', 'Stellar',
        'Icicle Crash', 'Sucker Punch', 'Sacred Sword', 'Protect'),

    (5,  1, 4, 'Regenerator', 'Rocky Helmet', 'Dark',
        'Spore', 'Rage Powder', 'Clear Smog', 'Pollen Puff'),

    (5, 19, 5, 'Drizzle', 'Mystic Water', 'Grass',
        'Water Spout', 'Origin Pulse', 'Protect', 'Ice Beam'),

    (5, 20, 6, 'Prankster', 'Covert Cloak', 'Dark',
        'Bleakwind Storm', 'Rain Dance', 'Tailwind', 'Taunt'),


    -- --------------------------------------------------------
    -- Team 6: Joseph Ugarte
    -- Ditto has only one move supplied in the source data.
    -- --------------------------------------------------------

    (6, 15, 1, 'Unseen Fist', 'Mystic Water', 'Poison',
        'Surging Strikes', 'Close Combat', 'Swords Dance', 'Detect'),

    (6, 11, 2, 'Quark Drive', 'Assault Vest', 'Water',
        'Drain Punch', 'Wild Charge', 'Volt Switch', 'Fake Out'),

    (6, 21, 3, 'Flame Body', 'Sitrus Berry', 'Grass',
        'Fiery Dance', 'Quiver Dance', 'Giga Drain', 'Protect'),

    (6,  8, 4, 'Hadron Engine', 'Choice Specs', 'Fairy',
        'Electro Drift', 'Draco Meteor', 'Dazzling Gleam', 'Volt Switch'),

    (6, 22, 5, 'Prankster', 'Light Clay', 'Ghost',
        'Foul Play', 'Thunder Wave', 'Light Screen', 'Reflect'),

    (6, 23, 6, 'Imposter', 'Focus Sash', 'Normal',
        'Transform', NULL, NULL, NULL),


    -- --------------------------------------------------------
    -- Team 7: Grant Laird
    -- --------------------------------------------------------

    (7, 11, 1, 'Quark Drive', 'Assault Vest', 'Poison',
        'Fake Out', 'Wild Charge', 'Drain Punch', 'Low Kick'),

    (7,  7, 2, 'Armor Tail', 'Electric Seed', 'Dark',
        'Foul Play', 'Psychic', 'Helping Hand', 'Trick Room'),

    (7, 15, 3, 'Unseen Fist', 'Choice Band', 'Grass',
        'Surging Strikes', 'Close Combat', 'Aqua Jet', 'U-turn'),

    (7, 22, 4, 'Prankster', 'Light Clay', 'Ghost',
        'Foul Play', 'Reflect', 'Light Screen', 'Thunder Wave'),

    (7, 24, 5, 'Inner Focus', 'Life Orb', 'Normal',
        'Sacred Fire', 'Extreme Speed', 'Stomping Tantrum', 'Protect'),

    (7,  8, 6, 'Hadron Engine', 'Choice Specs', 'Fairy',
        'Electro Drift', 'Draco Meteor', 'Volt Switch', 'Dazzling Gleam'),


    -- --------------------------------------------------------
    -- Team 8: Théotime Massaut
    -- --------------------------------------------------------

    (8, 26, 1, 'Friend Guard', 'Eviolite', 'Grass',
        'Follow Me', 'Helping Hand', 'Life Dew', 'Protect'),

    (8, 27, 2, 'Drizzle', 'Focus Sash', 'Ghost',
        'Weather Ball', 'Hurricane', 'Wide Guard', 'Protect'),

    (8, 28, 3, 'Grassy Surge', 'Assault Vest', 'Water',
        'Wood Hammer', 'Grassy Glide', 'U-turn', 'Fake Out'),

    (8, 25, 4, 'As One', 'Covert Cloak', 'Fairy',
        'Astral Barrage', 'Draining Kiss', 'Calm Mind', 'Protect'),

    (8, 15, 5, 'Unseen Fist', 'Mystic Water', 'Water',
        'Surging Strikes', 'Close Combat', 'Taunt', 'Protect'),

    (8,  2, 6, 'Intimidate', 'Safety Goggles', 'Water',
        'Will-O-Wisp', 'Knock Off', 'Parting Shot', 'Fake Out');


-- ============================================================
-- 6. TOURNAMENT ENTRIES
-- Swiss records only; these are not top-cut match records.
-- ============================================================

INSERT INTO TournamentEntry (
    tournament_id,
    player_id,
    team_id,
    placement,
    wins,
    losses,
    ties
)
VALUES
    (1, 1, 1, 1, 10, 2, 0),
    (1, 2, 2, 2, 10, 2, 0),
    (1, 3, 3, 3, 10, 2, 0),
    (1, 4, 4, 4, 10, 2, 0),
    (1, 5, 5, 5, 11, 1, 0),
    (1, 6, 6, 6, 10, 2, 0),
    (1, 7, 7, 7, 10, 2, 0),
    (1, 8, 8, 8, 10, 2, 0);

-- ============================================================
-- 7. TOURNAMENT: 2016 POKÉMON WORLD CHAMPIONSHIPS
-- ============================================================

INSERT INTO Tournament (
    tournament_id,
    tournament_name,
    location,
    start_date,
    end_date,
    division,
    game,
    format
)
VALUES (
    2,
    '2016 Pokémon World Championships',
    'San Francisco, California, United States',
    '2016-08-19',
    '2016-08-21',
    'Masters',
    'Pokémon Omega Ruby and Alpha Sapphire',
    'VGC 2016'
);

-- ============================================================
-- 8. PLAYERS: 2016 WORLD CHAMPIONSHIPS
-- ============================================================

INSERT INTO Player (
    player_id,
    player_name,
    player_country
)
VALUES
    (9, 'Jonathan Evans', 'United States'),
    (10, 'Markus Hamann', 'Germany'),
    (11, 'Eduardo Cunha', 'Portugal'),
    (12, 'Aaron Traylor', 'United States'),
    (13, 'Justin Carris', 'United States'),
    (14, 'Barry Anderson', 'United Kingdom'),
    (15, 'Baris Akcos', 'Germany'),
    (16, 'Sebastian Escalante', 'Argentina'),
    (17, 'Giovanni Costa', 'United States'),
    (18, 'Michael Lanzano', 'United States'),
    (19, 'Edward Cheung', 'Hong Kong'),
    (20, 'Jamie Boyt', 'United Kingdom'),
    (21, 'Blake Hopper', 'United States'),
    (22, 'Sam Pandelis', 'Australia'),
    (23, 'Matthias Suchodolski', 'Germany');

-- ============================================================
-- 9. TEAMS: 2016 WORLD CHAMPIONSHIPS
-- ============================================================

INSERT INTO Team (
    team_id,
    player_id,
    format
)
VALUES
    (9,  1,  'VGC 2016'),
    (10, 9, 'VGC 2016'),
    (11, 10, 'VGC 2016'),
    (12, 11, 'VGC 2016'),
    (13, 12, 'VGC 2016'),
    (14, 13, 'VGC 2016'),
    (15, 14, 'VGC 2016'),
    (16, 15, 'VGC 2016'),
    (17, 16, 'VGC 2016'),
    (18, 17, 'VGC 2016'),
    (19, 18, 'VGC 2016'),
    (20, 19, 'VGC 2016'),
    (21, 20, 'VGC 2016'),
    (22, 21, 'VGC 2016'),
    (23, 22, 'VGC 2016'),
    (24, 23, 'VGC 2016');

    -- ============================================================
-- 10. POKEMON: ADDITIONAL SPECIES AND FORMS
-- ============================================================

INSERT INTO Pokemon (
    pokemon_id,
    pokedex_number,
    pokemon_name,
    pokemon_type1,
    pokemon_type2
)
VALUES
    (29, 384, 'Rayquaza (Mega)',       'Dragon',   'Flying'),
    (30, 382, 'Kyogre (Primal)',       'Water',    NULL),
    (31,  94, 'Gengar (Mega)',        'Ghost',    'Poison'),
    (32, 237, 'Hitmontop',             'Fighting', NULL),
    (33,  26, 'Raichu',                'Electric', NULL),
    (34, 437, 'Bronzong',              'Steel',    'Psychic'),
    (35, 383, 'Groudon (Primal)',      'Ground',   'Fire'),
    (36, 310, 'Manectric (Mega)',      'Electric', NULL),
    (37, 663, 'Talonflame',             'Fire',     'Flying'),
    (38, 716, 'Xerneas',                'Fairy',    NULL),
    (39, 115, 'Kangaskhan (Mega)',     'Normal',   NULL),
    (40, 642, 'Thundurus',              'Electric', 'Flying'),
    (41, 373, 'Salamence (Mega)',      'Dragon',   'Flying'),
    (42, 235, 'Smeargle',               'Normal',   NULL),
    (43, 488, 'Cresselia',              'Psychic',  NULL),
    (44, 392, 'Infernape',              'Fire',     'Fighting'),
    (45, 560, 'Scrafty',                'Dark',     'Fighting'),
    (46, 130, 'Gyarados',               'Water',    'Flying'),
    (47,  59, 'Arcanine',               'Fire',     NULL),
    (48, 212, 'Scizor',                 'Bug',      'Steel'),
    (49, 717, 'Yveltal',                'Dark',     'Flying'),
    (50, 169, 'Crobat',                 'Poison',   'Flying'),
    (51, 645, 'Landorus (Therian)',     'Ground',   'Flying'),
    (52, 598, 'Ferrothorn',             'Grass',    'Steel');

    -- ============================================================
-- 11. TEAM POKEMON: 2016 WORLD CHAMPIONSHIPS
-- ============================================================

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
VALUES

    -- Team 9: Wolfe Glick

    (9, 29, 1, 'Air Lock', 'Focus Sash', NULL,
        'Dragon Ascent', 'Protect', 'Swords Dance', 'Extreme Speed'),

    (9, 30, 2, 'Drizzle', 'Blue Orb', NULL,
        'Origin Pulse', 'Ice Beam', 'Water Spout', 'Protect'),

    (9, 31, 3, 'Levitate', 'Gengarite', NULL,
        'Protect', 'Taunt', 'Sludge Bomb', 'Will-O-Wisp'),

    (9, 32, 4, 'Intimidate', 'Eject Button', NULL,
        'Wide Guard', 'Fake Out', 'Close Combat', 'Feint'),

    (9, 33, 5, 'Lightning Rod', 'Assault Vest', NULL,
        'Fake Out', 'Volt Switch', 'Endeavor', 'Nuzzle'),

    (9, 34, 6, 'Levitate', 'Lum Berry', NULL,
        'Safeguard', 'Gyro Ball', 'Skill Swap', 'Trick Room'),


    -- Team 10: Jonathan Evans

    (10, 31, 1, 'Levitate', 'Gengarite', NULL,
        'Sludge Bomb', 'Will-O-Wisp', 'Hidden Power [Water]', 'Protect'),

    (10, 30, 2, 'Primordial Sea', 'Blue Orb', NULL,
        'Origin Pulse', 'Ice Beam', 'Thunder', 'Protect'),

    (10, 34, 3, 'Levitate', 'Lum Berry', NULL,
        'Gyro Ball', 'Trick Room', 'Skill Swap', 'Safeguard'),

    (10, 35, 4, 'Drought', 'Red Orb', NULL,
        'Eruption', 'Precipice Blades', 'Fire Punch', 'Protect'),

    (10, 36, 5, 'Lightning Rod', 'Manectite', NULL,
        'Volt Switch', 'Thunder', 'Hidden Power [Water]', 'Protect'),

    (10, 37, 6, 'Gale Wings', 'Chesto Berry', NULL,
        'Brave Bird', 'Taunt', 'Tailwind', 'Will-O-Wisp'),


    -- Team 11: Markus Hamann

    (11, 29, 1, 'Air Lock', 'Focus Sash', NULL,
        'Dragon Ascent', 'Protect', 'Swords Dance', 'Extreme Speed'),

    (11, 30, 2, 'Drizzle', 'Blue Orb', NULL,
        'Origin Pulse', 'Ice Beam', 'Water Spout', 'Protect'),

    (11, 31, 3, 'Levitate', 'Gengarite', NULL,
        'Protect', 'Taunt', 'Sludge Bomb', 'Will-O-Wisp'),

    (11, 32, 4, 'Intimidate', 'Eject Button', NULL,
        'Wide Guard', 'Fake Out', 'Close Combat', 'Feint'),

    (11, 33, 5, 'Lightning Rod', 'Assault Vest', NULL,
        'Fake Out', 'Volt Switch', 'Endeavor', 'Nuzzle'),

    (11, 34, 6, 'Levitate', 'Lum Berry', NULL,
        'Safeguard', 'Gyro Ball', 'Skill Swap', 'Trick Room'),


    -- Team 12: Eduardo Cunha

    (12, 38, 1, 'Fairy Aura', 'Power Herb', NULL,
        'Moonblast', 'Dazzling Gleam', 'Geomancy', 'Protect'),

    (12, 39, 2, 'Inner Focus', 'Kangaskhanite', NULL,
        'Fake Out', 'Sucker Punch', 'Safeguard', 'Double-Edge'),

    (12, 35, 3, 'Drought', 'Red Orb', NULL,
        'Precipice Blades', 'Protect', 'Fire Punch', 'Substitute'),

    (12, 34, 4, 'Heatproof', 'Mental Herb', NULL,
        'Gyro Ball', 'Trick Room', 'Gravity', 'Hypnosis'),

    (12, 32, 5, 'Intimidate', 'Fist Plate', NULL,
        'Fake Out', 'Wide Guard', 'Close Combat', 'Feint'),

    (12, 40, 6, 'Prankster', 'Sitrus Berry', NULL,
        'Thunderbolt', 'Taunt', 'Thunder Wave', 'Protect'),


    -- Team 13: Aaron Traylor

    (13, 43, 1, 'Levitate', 'Sitrus Berry', NULL,
        'Psychic', 'Icy Wind', 'Skill Swap', 'Trick Room'),

    (13, 38, 2, 'Fairy Aura', 'Power Herb', NULL,
        'Protect', 'Geomancy', 'Moonblast', 'Dazzling Gleam'),

    (13, 35, 3, 'Drought', 'Red Orb', NULL,
        'Protect', 'Swords Dance', 'Precipice Blades', 'Fire Punch'),

    (13, 42, 4, 'Moody', 'Focus Sash', NULL,
        'Spiky Shield', 'Crafty Shield', 'Wide Guard', 'Dark Void'),

    (13, 41, 5, 'Intimidate', 'Salamencite', NULL,
        'Protect', 'Tailwind', 'Double-Edge', 'Hyper Voice'),

    (13, 34, 6, 'Heatproof', 'Lum Berry', NULL,
        'Trick Room', 'Gravity', 'Hypnosis', 'Gyro Ball'),


    -- Team 14: Justin Carris

    (14, 44, 1, 'Blaze', 'Focus Sash', NULL,
        'Fake Out', 'Close Combat', 'Overheat', 'Quick Guard'),

    (14, 38, 2, 'Fairy Aura', 'Power Herb', NULL,
        'Dazzling Gleam', 'Moonblast', 'Geomancy', 'Protect'),

    (14, 1, 3, 'Regenerator', 'Lum Berry', NULL,
        'Grass Knot', 'Rage Powder', 'Spore', 'Protect'),

    (14, 41, 4, 'Intimidate', 'Salamencite', NULL,
        'Hyper Voice', 'Double-Edge', 'Protect', 'Draco Meteor'),

    (14, 30, 5, 'Drizzle', 'Blue Orb', NULL,
        'Ice Beam', 'Water Spout', 'Scald', 'Protect'),

    (14, 34, 6, 'Levitate', 'Mental Herb', NULL,
        'Gyro Ball', 'Safeguard', 'Trick Room', 'Skill Swap'),


    -- Team 15: Barry Anderson

    (15, 42, 1, 'Own Tempo', 'Choice Scarf', NULL,
        'Dark Void', 'Fake Out', 'Transform', 'Switcheroo'),

    (15, 45, 2, 'Intimidate', 'Lum Berry', NULL,
        'Knock Off', 'Low Kick', 'Fake Out', 'Quick Guard'),

    (15, 29, 3, 'Air Lock', 'Focus Sash', NULL,
        'Dragon Ascent', 'Extreme Speed', 'Swords Dance', 'Protect'),

    (15, 38, 4, 'Fairy Aura', 'Power Herb', NULL,
        'Moonblast', 'Dazzling Gleam', 'Geomancy', 'Protect'),

    (15, 21, 5, 'Flame Body', 'Red Card', NULL,
        'Overheat', 'Whirlwind', 'Rage Powder', 'Protect'),

    (15, 40, 6, 'Prankster', 'Sitrus Berry', NULL,
        'Thunderbolt', 'Taunt', 'Thunder Wave', 'Protect'),


    -- Team 16: Baris Akcos

    (16, 29, 1, 'Air Lock', 'Focus Sash', NULL,
        'Dragon Ascent', 'Protect', 'Swords Dance', 'Extreme Speed'),

    (16, 30, 2, 'Drizzle', 'Blue Orb', NULL,
        'Origin Pulse', 'Ice Beam', 'Water Spout', 'Protect'),

    (16, 31, 3, 'Levitate', 'Gengarite', NULL,
        'Protect', 'Taunt', 'Sludge Bomb', 'Will-O-Wisp'),

    (16, 32, 4, 'Intimidate', 'Eject Button', NULL,
        'Wide Guard', 'Fake Out', 'Close Combat', 'Feint'),

    (16, 33, 5, 'Lightning Rod', 'Assault Vest', NULL,
        'Fake Out', 'Volt Switch', 'Endeavor', 'Nuzzle'),

    (16, 34, 6, 'Levitate', 'Lum Berry', NULL,
        'Safeguard', 'Gyro Ball', 'Skill Swap', 'Trick Room'),


    -- Team 17: Sebastian Escalante

    (17, 39, 1, 'Inner Focus', 'Kangaskhanite', NULL,
        'Fake Out', 'Power-Up Punch', 'Return', 'Sucker Punch'),

    (17, 1, 2, 'Effect Spore', 'Mental Herb', NULL,
        'Grass Knot', 'Spore', 'Rage Powder', 'Protect'),

    (17, 38, 3, 'Fairy Aura', 'Power Herb', NULL,
        'Geomancy', 'Dazzling Gleam', 'Moonblast', 'Protect'),

    (17, 42, 4, 'Moody', 'Focus Sash', NULL,
        'Fake Out', 'Dark Void', 'Follow Me', 'Spiky Shield'),

    (17, 37, 5, 'Gale Wings', 'Life Orb', NULL,
        'Brave Bird', 'Flare Blitz', 'Tailwind', 'Quick Guard'),

    (17, 35, 6, 'Drought', 'Red Orb', NULL,
        'Precipice Blades', 'Fire Punch', 'Rock Tomb', 'Protect'),


    -- Team 18: Giovanni Costa

    (18, 17, 1, 'Prankster', 'Focus Sash', NULL,
        'Encore', 'Tailwind', 'Safeguard', 'Moonblast'),

    (18, 39, 2, 'Inner Focus', 'Kangaskhanite', NULL,
        'Fake Out', 'Sucker Punch', 'Power-Up Punch', 'Double-Edge'),

    (18, 35, 3, 'Drought', 'Red Orb', NULL,
        'Eruption', 'Overheat', 'Earth Power', 'Protect'),

    (18, 43, 4, 'Levitate', 'Sitrus Berry', NULL,
        'Skill Swap', 'Safeguard', 'Trick Room', 'Icy Wind'),

    (18, 30, 5, 'Drizzle', 'Blue Orb', NULL,
        'Water Spout', 'Thunder', 'Ice Beam', 'Protect'),

    (18, 31, 6, 'Levitate', 'Gengarite', NULL,
        'Icy Wind', 'Sludge Bomb', 'Disable', 'Protect'),


    -- Team 19: Michael Lanzano

    (19, 39, 1, 'Inner Focus', 'Kangaskhanite', NULL,
        'Fake Out', 'Sucker Punch', 'Power-Up Punch', 'Double-Edge'),

    (19, 42, 2, 'Moody', 'Chesto Berry', NULL,
        'Spiky Shield', 'Dark Void', 'Wide Guard', 'Crafty Shield'),

    (19, 34, 3, 'Heatproof', 'Lum Berry', NULL,
        'Gyro Ball', 'Hypnosis', 'Gravity', 'Trick Room'),

    (19, 41, 4, 'Intimidate', 'Salamencite', NULL,
        'Protect', 'Hyper Voice', 'Tailwind', 'Double-Edge'),

    (19, 35, 5, 'Drought', 'Red Orb', NULL,
        'Protect', 'Fire Punch', 'Earth Power', 'Precipice Blades'),

    (19, 38, 6, 'Fairy Aura', 'Power Herb', NULL,
        'Protect', 'Moonblast', 'Geomancy', 'Dazzling Gleam'),


    -- Team 20: Edward Cheung

    (20, 30, 1, 'Drizzle', 'Blue Orb', NULL,
        'Origin Pulse', 'Thunder', 'Ice Beam', 'Protect'),

    (20, 42, 2, 'Moody', 'Focus Sash', NULL,
        'Dark Void', 'Fake Out', 'Transform', 'Spiky Shield'),

    (20, 41, 3, 'Intimidate', 'Salamencite', NULL,
        'Hyper Voice', 'Double-Edge', 'Tailwind', 'Protect'),

    (20, 43, 4, 'Levitate', 'Sitrus Berry', NULL,
        'Psychic', 'Icy Wind', 'Thunder Wave', 'Trick Room'),

    (20, 39, 5, 'Scrappy', 'Kangaskhanite', NULL,
        'Double-Edge', 'Low Kick', 'Sucker Punch', 'Fake Out'),

    (20, 35, 6, 'Drought', 'Red Orb', NULL,
        'Eruption', 'Earth Power', 'Precipice Blades', 'Protect'),


    -- Team 21: Jamie Boyt

    (21, 17, 1, 'Prankster', 'Focus Sash', NULL,
        'Moonblast', 'Tailwind', 'Safeguard', 'Encore'),

    (21, 29, 2, 'Air Lock', 'Assault Vest', NULL,
        'Dragon Ascent', 'Extreme Speed', 'Waterfall', 'Icy Wind'),

    (21, 46, 3, 'Intimidate', 'Sitrus Berry', NULL,
        'Waterfall', 'Icy Wind', 'Thunder Wave', 'Roar'),

    (21, 38, 4, 'Fairy Aura', 'Power Herb', NULL,
        'Moonblast', 'Dazzling Gleam', 'Geomancy', 'Protect'),

    (21, 45, 5, 'Intimidate', 'Lum Berry', NULL,
        'Knock Off', 'Low Kick', 'Fake Out', 'Quick Guard'),

    (21, 47, 6, 'Intimidate', 'Life Orb', NULL,
        'Flare Blitz', 'Extreme Speed', 'Helping Hand', 'Roar'),


    -- Team 22: Blake Hopper

    (22, 35, 1, 'Drought', 'Red Orb', NULL,
        'Earth Power', 'Overheat', 'Eruption', 'Protect'),

    (22, 29, 2, 'Air Lock', 'Assault Vest', NULL,
        'Dragon Ascent', 'Waterfall', 'Extreme Speed', 'Draco Meteor'),

    (22, 40, 3, 'Prankster', 'Sitrus Berry', NULL,
        'Thunderbolt', 'Thunder Wave', 'Taunt', 'Protect'),

    (22, 39, 4, 'Inner Focus', 'Kangaskhanite', NULL,
        'Frustration', 'Power-Up Punch', 'Sucker Punch', 'Fake Out'),

    (22, 48, 5, 'Technician', 'Life Orb', NULL,
        'Bullet Punch', 'Knock Off', 'Swords Dance', 'Protect'),

    (22, 43, 6, 'Levitate', 'Lum Berry', NULL,
        'Psychic', 'Icy Wind', 'Skill Swap', 'Trick Room'),


    -- Team 23: Sam Pandelis

    (23, 40, 1, 'Prankster', 'Focus Sash', NULL,
        'Thunderbolt', 'Taunt', 'Thunder Wave', 'Protect'),

    (23, 49, 2, 'Dark Aura', 'Life Orb', NULL,
        'Knock Off', 'Foul Play', 'Sucker Punch', 'Protect'),

    (23, 39, 3, 'Scrappy', 'Kangaskhanite', NULL,
        'Fake Out', 'Double-Edge', 'Sucker Punch', 'Power-Up Punch'),

    (23, 35, 4, 'Drought', 'Red Orb', NULL,
        'Eruption', 'Hidden Power', 'Earth Power', 'Protect'),

    (23, 50, 5, 'Inner Focus', 'Lum Berry', NULL,
        'Tailwind', 'Haze', 'Quick Guard', 'Super Fang'),

    (23, 42, 6, 'Moody', 'Choice Scarf', NULL,
        'Feint', 'Dark Void', 'Transform', 'Taunt'),


    -- Team 24: Matthias Suchodolski

    (24, 30, 1, 'Drizzle', 'Blue Orb', NULL,
        'Water Spout', 'Origin Pulse', 'Ice Beam', 'Protect'),

    (24, 51, 2, 'Intimidate', 'Life Orb', NULL,
        'Earthquake', 'Rock Slide', 'U-turn', 'Protect'),

    (24, 39, 3, 'Inner Focus', 'Kangaskhanite', NULL,
        'Fake Out', 'Double-Edge', 'Sucker Punch', 'Power-Up Punch'),

    (24, 29, 4, 'Air Lock', 'Focus Sash', NULL,
        'Dragon Ascent', 'Extreme Speed', 'Overheat', 'Protect'),

    (24, 40, 5, 'Prankster', 'Sitrus Berry', NULL,
        'Thunderbolt', 'Swagger', 'Taunt', 'Thunder Wave'),

    (24, 52, 6, 'Iron Barbs', 'Leftovers', NULL,
        'Power Whip', 'Gyro Ball', 'Leech Seed', 'Protect');

-- ============================================================
-- 12. TOURNAMENT ENTRIES: 2016 WORLD CHAMPIONSHIPS
-- Swiss records are unknown and therefore left NULL.
-- ============================================================

INSERT INTO TournamentEntry (
    tournament_id,
    player_id,
    team_id,
    placement,
    wins,
    losses,
    ties
)
VALUES
    (2,  1,  9,  1, NULL, NULL, NULL),
    (2,  9, 10,  2, NULL, NULL, NULL),
    (2, 10, 11,  3, NULL, NULL, NULL),
    (2, 11, 12,  4, NULL, NULL, NULL),
    (2, 12, 13,  5, NULL, NULL, NULL),
    (2, 13, 14,  6, NULL, NULL, NULL),
    (2, 14, 15,  7, NULL, NULL, NULL),
    (2, 15, 16,  8, NULL, NULL, NULL),
    (2, 16, 17,  9, NULL, NULL, NULL),
    (2, 17, 18, 10, NULL, NULL, NULL),
    (2, 18, 19, 11, NULL, NULL, NULL),
    (2, 19, 20, 12, NULL, NULL, NULL),
    (2, 20, 21, 13, NULL, NULL, NULL),
    (2, 21, 22, 14, NULL, NULL, NULL),
    (2, 22, 23, 15, NULL, NULL, NULL),
    (2, 23, 24, 16, NULL, NULL, NULL);

-- ============================================================
-- 13. GEN 1 POKEMON
-- Add in all gen 1 Pokemon that don't already exist.
-- ============================================================

WITH gen1_missing(pokedex_number, pokemon_name, pokemon_type1, pokemon_type2) AS (
    VALUES
    (1, 'Bulbasaur', 'Grass', 'Poison'),
    (2, 'Ivysaur', 'Grass', 'Poison'),
    (3, 'Venusaur', 'Grass', 'Poison'),
    (4, 'Charmander', 'Fire', NULL),
    (5, 'Charmeleon', 'Fire', NULL),
    (6, 'Charizard', 'Fire', 'Flying'),
    (7, 'Squirtle', 'Water', NULL),
    (8, 'Wartortle', 'Water', NULL),
    (9, 'Blastoise', 'Water', NULL),
    (10, 'Caterpie', 'Bug', NULL),
    (11, 'Metapod', 'Bug', NULL),
    (12, 'Butterfree', 'Bug', 'Flying'),
    (13, 'Weedle', 'Bug', 'Poison'),
    (14, 'Kakuna', 'Bug', 'Poison'),
    (15, 'Beedrill', 'Bug', 'Poison'),
    (16, 'Pidgey', 'Normal', 'Flying'),
    (17, 'Pidgeotto', 'Normal', 'Flying'),
    (18, 'Pidgeot', 'Normal', 'Flying'),
    (19, 'Rattata', 'Normal', NULL),
    (20, 'Raticate', 'Normal', NULL),
    (21, 'Spearow', 'Normal', 'Flying'),
    (22, 'Fearow', 'Normal', 'Flying'),
    (23, 'Ekans', 'Poison', NULL),
    (24, 'Arbok', 'Poison', NULL),
    (25, 'Pikachu', 'Electric', NULL),
    (27, 'Sandshrew', 'Ground', NULL),
    (28, 'Sandslash', 'Ground', NULL),
    (29, 'Nidoran♀', 'Poison', NULL),
    (30, 'Nidorina', 'Poison', NULL),
    (31, 'Nidoqueen', 'Poison', 'Ground'),
    (32, 'Nidoran♂', 'Poison', NULL),
    (33, 'Nidorino', 'Poison', NULL),
    (34, 'Nidoking', 'Poison', 'Ground'),
    (36, 'Clefable', 'Fairy', NULL),
    (37, 'Vulpix', 'Fire', NULL),
    (38, 'Ninetales', 'Fire', NULL),
    (39, 'Jigglypuff', 'Normal', 'Fairy'),
    (40, 'Wigglytuff', 'Normal', 'Fairy'),
    (41, 'Zubat', 'Poison', 'Flying'),
    (42, 'Golbat', 'Poison', 'Flying'),
    (43, 'Oddish', 'Grass', 'Poison'),
    (44, 'Gloom', 'Grass', 'Poison'),
    (45, 'Vileplume', 'Grass', 'Poison'),
    (46, 'Paras', 'Bug', 'Grass'),
    (47, 'Parasect', 'Bug', 'Grass'),
    (48, 'Venonat', 'Bug', 'Poison'),
    (49, 'Venomoth', 'Bug', 'Poison'),
    (50, 'Diglett', 'Ground', NULL),
    (51, 'Dugtrio', 'Ground', NULL),
    (52, 'Meowth', 'Normal', NULL),
    (53, 'Persian', 'Normal', NULL),
    (54, 'Psyduck', 'Water', NULL),
    (55, 'Golduck', 'Water', NULL),
    (56, 'Mankey', 'Fighting', NULL),
    (57, 'Primeape', 'Fighting', NULL),
    (58, 'Growlithe', 'Fire', NULL),
    (60, 'Poliwag', 'Water', NULL),
    (61, 'Poliwhirl', 'Water', NULL),
    (62, 'Poliwrath', 'Water', 'Fighting'),
    (63, 'Abra', 'Psychic', NULL),
    (64, 'Kadabra', 'Psychic', NULL),
    (65, 'Alakazam', 'Psychic', NULL),
    (66, 'Machop', 'Fighting', NULL),
    (67, 'Machoke', 'Fighting', NULL),
    (68, 'Machamp', 'Fighting', NULL),
    (69, 'Bellsprout', 'Grass', 'Poison'),
    (70, 'Weepinbell', 'Grass', 'Poison'),
    (71, 'Victreebel', 'Grass', 'Poison'),
    (72, 'Tentacool', 'Water', 'Poison'),
    (73, 'Tentacruel', 'Water', 'Poison'),
    (74, 'Geodude', 'Rock', 'Ground'),
    (75, 'Graveler', 'Rock', 'Ground'),
    (76, 'Golem', 'Rock', 'Ground'),
    (77, 'Ponyta', 'Fire', NULL),
    (78, 'Rapidash', 'Fire', NULL),
    (79, 'Slowpoke', 'Water', 'Psychic'),
    (80, 'Slowbro', 'Water', 'Psychic'),
    (81, 'Magnemite', 'Electric', 'Steel'),
    (82, 'Magneton', 'Electric', 'Steel'),
    (83, 'Farfetch''d', 'Normal', 'Flying'),
    (84, 'Doduo', 'Normal', 'Flying'),
    (85, 'Dodrio', 'Normal', 'Flying'),
    (86, 'Seel', 'Water', NULL),
    (87, 'Dewgong', 'Water', 'Ice'),
    (88, 'Grimer', 'Poison', NULL),
    (89, 'Muk', 'Poison', NULL),
    (90, 'Shellder', 'Water', NULL),
    (91, 'Cloyster', 'Water', 'Ice'),
    (92, 'Gastly', 'Ghost', 'Poison'),
    (93, 'Haunter', 'Ghost', 'Poison'),
    (95, 'Onix', 'Rock', 'Ground'),
    (96, 'Drowzee', 'Psychic', NULL),
    (97, 'Hypno', 'Psychic', NULL),
    (98, 'Krabby', 'Water', NULL),
    (99, 'Kingler', 'Water', NULL),
    (100, 'Voltorb', 'Electric', NULL),
    (101, 'Electrode', 'Electric', NULL),
    (102, 'Exeggcute', 'Grass', 'Psychic'),
    (103, 'Exeggutor', 'Grass', 'Psychic'),
    (104, 'Cubone', 'Ground', NULL),
    (105, 'Marowak', 'Ground', NULL),
    (106, 'Hitmonlee', 'Fighting', NULL),
    (107, 'Hitmonchan', 'Fighting', NULL),
    (108, 'Lickitung', 'Normal', NULL),
    (109, 'Koffing', 'Poison', NULL),
    (110, 'Weezing', 'Poison', NULL),
    (111, 'Rhyhorn', 'Ground', 'Rock'),
    (112, 'Rhydon', 'Ground', 'Rock'),
    (113, 'Chansey', 'Normal', NULL),
    (114, 'Tangela', 'Grass', NULL),
    (116, 'Horsea', 'Water', NULL),
    (117, 'Seadra', 'Water', NULL),
    (118, 'Goldeen', 'Water', NULL),
    (119, 'Seaking', 'Water', NULL),
    (120, 'Staryu', 'Water', NULL),
    (121, 'Starmie', 'Water', 'Psychic'),
    (122, 'Mr. Mime', 'Psychic', 'Fairy'),
    (123, 'Scyther', 'Bug', 'Flying'),
    (124, 'Jynx', 'Ice', 'Psychic'),
    (125, 'Electabuzz', 'Electric', NULL),
    (126, 'Magmar', 'Fire', NULL),
    (127, 'Pinsir', 'Bug', NULL),
    (128, 'Tauros', 'Normal', NULL),
    (129, 'Magikarp', 'Water', NULL),
    (131, 'Lapras', 'Water', 'Ice'),
    (133, 'Eevee', 'Normal', NULL),
    (134, 'Vaporeon', 'Water', NULL),
    (135, 'Jolteon', 'Electric', NULL),
    (136, 'Flareon', 'Fire', NULL),
    (137, 'Porygon', 'Normal', NULL),
    (138, 'Omanyte', 'Rock', 'Water'),
    (139, 'Omastar', 'Rock', 'Water'),
    (140, 'Kabuto', 'Rock', 'Water'),
    (141, 'Kabutops', 'Rock', 'Water'),
    (142, 'Aerodactyl', 'Rock', 'Flying'),
    (143, 'Snorlax', 'Normal', NULL),
    (144, 'Articuno', 'Ice', 'Flying'),
    (145, 'Zapdos', 'Electric', 'Flying'),
    (146, 'Moltres', 'Fire', 'Flying'),
    (147, 'Dratini', 'Dragon', NULL),
    (148, 'Dragonair', 'Dragon', NULL),
    (149, 'Dragonite', 'Dragon', 'Flying'),
    (150, 'Mewtwo', 'Psychic', NULL),
    (151, 'Mew', 'Psychic', NULL)
),
numbered AS (
    SELECT
        52 + ROW_NUMBER() OVER (ORDER BY pokedex_number) AS pokemon_id,
        pokedex_number,
        pokemon_name,
        pokemon_type1,
        pokemon_type2
    FROM gen1_missing
)
INSERT INTO Pokemon (
    pokemon_id,
    pokedex_number,
    pokemon_name,
    pokemon_type1,
    pokemon_type2
)
SELECT
    pokemon_id,
    pokedex_number,
    pokemon_name,
    pokemon_type1,
    pokemon_type2
FROM numbered;

-- ============================================================
-- END OF INSERT SCRIPT
-- ============================================================
