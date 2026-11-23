const express = require("express");
const cors = require("cors");
const db = require("./db");

const app = express();
const PORT = 3001;

app.use(cors());
app.use(express.json());

// Test endpoint
app.get("/api/health", (req, res) => {
  res.json({ status: "Backend is running!" });
});

// Get all players
app.get("/api/players", (req, res) => {
  try {
    const players = db.prepare(`
      SELECT *
      FROM Player
      ORDER BY player_name;
    `).all();

    res.json(players);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get all tournaments
app.get("/api/tournaments", (req, res) => {
  try {
    const tournaments = db.prepare(`
      SELECT *
      FROM Tournament
      ORDER BY start_date DESC;
    `).all();

    res.json(tournaments);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get standings for a tournament
app.get("/api/tournaments/:id/standings", (req, res) => {
  try {
    const tournamentId = Number(req.params.id);

    if (!Number.isInteger(tournamentId)) {
      return res.status(400).json({ error: "Invalid tournament ID" });
    }

    const standings = db.prepare(`
      SELECT
        p.player_id,
        p.player_name,
        p.player_country,
        te.placement,
        te.wins,
        te.losses,
        te.ties,
        GROUP_CONCAT(pk.pokemon_name, ', ') AS team
      FROM TournamentEntry AS te
      JOIN Player AS p
        ON te.player_id = p.player_id
      LEFT JOIN TeamPokemon AS tp
        ON te.team_id = tp.team_id
      LEFT JOIN Pokemon AS pk
        ON tp.pokemon_id = pk.pokemon_id
      WHERE te.tournament_id = ?
      GROUP BY
        p.player_id,
        p.player_name,
        p.player_country,
        te.placement,
        te.wins,
        te.losses,
        te.ties
      ORDER BY te.placement IS NULL, te.placement;
    `).all(tournamentId);

    res.json(standings);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get all teams and their Pokémon for a player
app.get("/api/players/:id/teams", (req, res) => {
  try {
    const playerId = Number(req.params.id);

    if (!Number.isInteger(playerId)) {
      return res.status(400).json({ error: "Invalid player ID" });
    }

    const teams = db.prepare(`
      SELECT
        t.team_id,
        t.format,
        tr.tournament_id,
        tr.tournament_name,
        tr.start_date,
        te.placement,

        tp.slot,
        pk.pokemon_id,
        pk.pokedex_number,
        pk.pokemon_name,
        pk.pokemon_type1,
        pk.pokemon_type2,

        tp.ability,
        tp.held_item,
        tp.tera_type,
        tp.move1,
        tp.move2,
        tp.move3,
        tp.move4

      FROM Team AS t
      JOIN TeamPokemon AS tp
        ON t.team_id = tp.team_id
      JOIN Pokemon AS pk
        ON tp.pokemon_id = pk.pokemon_id
      LEFT JOIN TournamentEntry AS te
        ON t.team_id = te.team_id
      LEFT JOIN Tournament AS tr
        ON te.tournament_id = tr.tournament_id

      WHERE t.player_id = ?
      ORDER BY tr.start_date DESC, t.team_id, tp.slot;
    `).all(playerId);

    res.json(teams);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get Pokémon usage statistics for a tournament
app.get("/api/tournaments/:id/usage", (req, res) => {
  try {
    const tournamentId = Number(req.params.id);

    if (!Number.isInteger(tournamentId)) {
      return res.status(400).json({ error: "Invalid tournament ID" });
    }

    const usage = db.prepare(`
      SELECT
        p.pokemon_id,
        p.pokemon_name,
        COUNT(DISTINCT te.team_id) AS usage_count,
        (
          SELECT COUNT(*)
          FROM TournamentEntry
          WHERE tournament_id = ?
        ) AS total_teams
      FROM TournamentEntry AS te
      JOIN TeamPokemon AS tp
        ON te.team_id = tp.team_id
      JOIN Pokemon AS p
        ON tp.pokemon_id = p.pokemon_id
      WHERE te.tournament_id = ?
      GROUP BY p.pokemon_id, p.pokemon_name
      ORDER BY usage_count DESC, p.pokemon_name;
    `).all(tournamentId, tournamentId);

    res.json(usage);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get overview statistics
app.get("/api/overview", (req, res) => {
  try {
    const counts = db.prepare(`
      SELECT
        (SELECT COUNT(*) FROM Player) AS players,
        (SELECT COUNT(*) FROM Tournament) AS tournaments,
        (SELECT COUNT(*) FROM Team) AS teams,
        (SELECT COUNT(*) FROM Pokemon) AS pokemon;
    `).get();

    const tournamentCounts = db.prepare(`
      SELECT
        t.tournament_id,
        COUNT(DISTINCT te.player_id) AS player_count
      FROM Tournament AS t
      LEFT JOIN TournamentEntry AS te
        ON t.tournament_id = te.tournament_id
      GROUP BY t.tournament_id;
    `).all();

    const pokemonUsage = db.prepare(`
      SELECT
        p.pokemon_id,
        p.pokemon_name,
        COUNT(DISTINCT tp.team_id) AS usage_count
      FROM Pokemon AS p
      JOIN TeamPokemon AS tp
        ON p.pokemon_id = tp.pokemon_id
      JOIN TournamentEntry AS te
        ON tp.team_id = te.team_id
      GROUP BY p.pokemon_id, p.pokemon_name
      ORDER BY usage_count DESC, p.pokemon_name
      LIMIT 5;
    `).all();

    res.json({
      counts,
      tournamentCounts,
      pokemonUsage
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Add a new player
app.post("/api/players", (req, res) => {
  try {
    const { name, country } = req.body;

    if (!name?.trim() || !country?.trim()) {
      return res.status(400).json({
        error: "Player name and country are required."
      });
    }

    const playerName = name.trim();
    const playerCountry = country.trim();

    const existing = db.prepare(`
      SELECT player_id
      FROM Player
      WHERE LOWER(player_name) = LOWER(?)
    `).get(playerName);

    if (existing) {
      return res.status(409).json({
        error: "A player with that name already exists."
      });
    }

    const result = db.prepare(`
      INSERT INTO Player (player_name, player_country)
      VALUES (?, ?)
    `).run(playerName, playerCountry);

    const player = db.prepare(`
      SELECT *
      FROM Player
      WHERE player_id = ?
    `).get(result.lastInsertRowid);

    res.status(201).json(player);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Add a new tournament
app.post("/api/tournaments", (req, res) => {
  try {
    const {
      name,
      location,
      startDate,
      endDate,
      division,
      game,
      format
    } = req.body;

    if (
      !name?.trim() ||
      !location?.trim() ||
      !startDate ||
      !endDate ||
      !division?.trim() ||
      !game?.trim() ||
      !format?.trim()
    ) {
      return res.status(400).json({
        error: "All tournament fields are required."
      });
    }

    // Validate YYYY-MM-DD dates
    const validDate = date => {
      if (!/^\d{4}-\d{2}-\d{2}$/.test(date)) return false;

      const parsed = new Date(`${date}T00:00:00Z`);
      return !Number.isNaN(parsed.getTime()) &&
        parsed.toISOString().slice(0, 10) === date;
    };

    if (!validDate(startDate) || !validDate(endDate)) {
      return res.status(400).json({
        error: "Dates must be valid and use YYYY-MM-DD format."
      });
    }

    if (endDate < startDate) {
      return res.status(400).json({
        error: "End date cannot be before start date."
      });
    }

    const result = db.prepare(`
      INSERT INTO Tournament (
        tournament_name,
        location,
        start_date,
        end_date,
        division,
        game,
        format
      )
      VALUES (?, ?, ?, ?, ?, ?, ?)
    `).run(
      name.trim(),
      location.trim(),
      startDate,
      endDate,
      division.trim(),
      game.trim(),
      format.trim()
    );

    const tournament = db.prepare(`
      SELECT *
      FROM Tournament
      WHERE tournament_id = ?
    `).get(result.lastInsertRowid);

    res.status(201).json(tournament);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Register an existing or new team for a tournament
app.post("/api/teams", (req, res) => {
  try {
    const { playerId, tournamentId, teamId, pokemon } = req.body;

    if (
      !Number.isInteger(playerId) ||
      !Number.isInteger(tournamentId)
    ) {
      return res.status(400).json({
        error: "A valid player and tournament are required."
      });
    }

    const tournament = db.prepare(`
      SELECT format
      FROM Tournament
      WHERE tournament_id = ?
    `).get(tournamentId);

    if (!tournament) {
      return res.status(404).json({
        error: "Tournament not found."
      });
    }

    const player = db.prepare(`
      SELECT player_id
      FROM Player
      WHERE player_id = ?
    `).get(playerId);

    if (!player) {
      return res.status(404).json({
        error: "Player not found."
      });
    }

    const existingEntry = db.prepare(`
      SELECT player_id
      FROM TournamentEntry
      WHERE tournament_id = ? AND player_id = ?
    `).get(tournamentId, playerId);

    if (existingEntry) {
      return res.status(409).json({
        error: "This player already has a team registered for this tournament."
      });
    }

    // Determine whether this is an existing or new team.
    const useExistingTeam = teamId !== undefined && teamId !== null;

    if (useExistingTeam && !Number.isInteger(teamId)) {
      return res.status(400).json({
        error: "Invalid team ID."
      });
    }

    if (!useExistingTeam) {
      if (!Array.isArray(pokemon) || pokemon.length !== 6) {
        return res.status(400).json({
          error: "A new team must contain exactly six Pokémon."
        });
      }

      for (const p of pokemon) {
        if (
          !Number.isInteger(p.pokemonId) ||
          !p.ability?.trim() ||
          !p.move1?.trim()
        ) {
          return res.status(400).json({
            error: "Each Pokémon requires a species, ability, and at least one move."
          });
        }
      }
    }

    const registerTeam = db.transaction(() => {
      let registeredTeamId;

      if (useExistingTeam) {
        const existingTeam = db.prepare(`
          SELECT team_id, format
          FROM Team
          WHERE team_id = ? AND player_id = ?
        `).get(teamId, playerId);

        if (!existingTeam) {
          throw new Error("This team does not belong to the selected player.");
        }

        if (existingTeam.format !== tournament.format) {
          throw new Error("This team's format does not match the tournament format.");
        }

        registeredTeamId = existingTeam.team_id;
      } else {
        const teamResult = db.prepare(`
          INSERT INTO Team (player_id, format)
          VALUES (?, ?)
        `).run(playerId, tournament.format);

        registeredTeamId = Number(teamResult.lastInsertRowid);

        const insertPokemon = db.prepare(`
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
          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `);

        pokemon.forEach((p, index) => {
          insertPokemon.run(
            registeredTeamId,
            p.pokemonId,
            index + 1,
            p.ability.trim(),
            p.heldItem?.trim() || null,
            p.teraType?.trim() || null,
            p.move1.trim(),
            p.move2?.trim() || null,
            p.move3?.trim() || null,
            p.move4?.trim() || null
          );
        });
      }

      db.prepare(`
        INSERT INTO TournamentEntry (
          tournament_id,
          player_id,
          team_id
        )
        VALUES (?, ?, ?)
      `).run(tournamentId, playerId, registeredTeamId);

      return registeredTeamId;
    });

    const registeredTeamId = registerTeam();

    res.status(201).json({
      message: "Team successfully registered.",
      teamId: registeredTeamId,
      reusedTeam: useExistingTeam
    });
  } catch (error) {
    const status = error.message.includes("does not belong") ||
      error.message.includes("format does not match")
      ? 400
      : 500;

    res.status(status).json({ error: error.message });
  }
});

// Get all Pokémon
app.get("/api/pokemon", (req, res) => {
  try {
    const pokemon = db.prepare(`
      SELECT
        pokemon_id,
        pokedex_number,
        pokemon_name,
        pokemon_type1,
        pokemon_type2
      FROM Pokemon
      ORDER BY pokedex_number;
    `).all();

    res.json(pokemon);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Delete a player and all associated records
app.delete("/api/players/:id", (req, res) => {
  try {
    const playerId = Number(req.params.id);

    if (!Number.isInteger(playerId)) {
      return res.status(400).json({ error: "Invalid player ID." });
    }

    const deletePlayer = db.transaction(() => {
      // Remove tournament registrations
      db.prepare(`
        DELETE FROM TournamentEntry
        WHERE player_id = ?
      `).run(playerId);

      // Remove Pokémon from all of the player's teams
      db.prepare(`
        DELETE FROM TeamPokemon
        WHERE team_id IN (
          SELECT team_id
          FROM Team
          WHERE player_id = ?
        )
      `).run(playerId);

      // Remove the player's teams
      db.prepare(`
        DELETE FROM Team
        WHERE player_id = ?
      `).run(playerId);

      // Remove the player
      const result = db.prepare(`
        DELETE FROM Player
        WHERE player_id = ?
      `).run(playerId);

      return result.changes;
    });

    const deleted = deletePlayer();

    if (!deleted) {
      return res.status(404).json({ error: "Player not found." });
    }

    res.json({ message: "Player successfully deleted." });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Delete a tournament
app.delete("/api/tournaments/:id", (req, res) => {
  try {
    const tournamentId = Number(req.params.id);

    if (!Number.isInteger(tournamentId)) {
      return res.status(400).json({
        error: "Invalid tournament ID."
      });
    }

    const result = db.prepare(`
      DELETE FROM Tournament
      WHERE tournament_id = ?
    `).run(tournamentId);

    if (!result.changes) {
      return res.status(404).json({
        error: "Tournament not found."
      });
    }

    res.json({ message: "Tournament successfully deleted." });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Delete a player's registration from a tournament
app.delete("/api/tournaments/:tournamentId/entries/:playerId", (req, res) => {
  try {
    const tournamentId = Number(req.params.tournamentId);
    const playerId = Number(req.params.playerId);

    if (
      !Number.isInteger(tournamentId) ||
      !Number.isInteger(playerId)
    ) {
      return res.status(400).json({
        error: "Invalid tournament or player ID."
      });
    }

    const result = db.prepare(`
      DELETE FROM TournamentEntry
      WHERE tournament_id = ? AND player_id = ?
    `).run(tournamentId, playerId);

    if (!result.changes) {
      return res.status(404).json({
        error: "Registration not found."
      });
    }

    res.json({ message: "Registration successfully deleted." });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Delete a team and its associated records
app.delete("/api/teams/:id", (req, res) => {
  try {
    const teamId = Number(req.params.id);

    if (!Number.isInteger(teamId)) {
      return res.status(400).json({
        error: "Invalid team ID."
      });
    }

    const deleteTeam = db.transaction(() => {
      // Remove tournament registrations using this team
      db.prepare(`
        DELETE FROM TournamentEntry
        WHERE team_id = ?
      `).run(teamId);

      // Remove the team's Pokémon
      db.prepare(`
        DELETE FROM TeamPokemon
        WHERE team_id = ?
      `).run(teamId);

      // Remove the team
      const result = db.prepare(`
        DELETE FROM Team
        WHERE team_id = ?
      `).run(teamId);

      return result.changes;
    });

    const deleted = deleteTeam();

    if (!deleted) {
      return res.status(404).json({
        error: "Team not found."
      });
    }

    res.json({ message: "Team successfully deleted." });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});