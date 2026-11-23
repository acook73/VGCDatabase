import { useEffect, useMemo, useState } from "react";

import "./App.css";

const dex = [
  "Incineroar", "Rillaboom", "Urshifu", "Calyrex",
  "Amoonguss", "Flutter Mane", "Xerneas", "Kyogre",
  "Groudon", "Rayquaza", "Gengar", "Raichu",
  "Charizard", "Venusaur", "Blastoise", "Pikachu",
  "Arcanine", "Gyarados"
];

const popularity = [
  ["Incineroar", 18, 75],
  ["Rillaboom", 15, 63],
  ["Urshifu", 13, 54],
  ["Calyrex", 11, 46],
  ["Amoonguss", 9, 38]
];

function Glyph({ children }) {
  return (
    <span className="glyph" aria-hidden="true">
      {children}
    </span>
  );
}

function Header({ title, desc }) {
  return (
    <header className="page-head">
      <div>
        <div className="kicker">POKÉMON VGC DATABASE</div>
        <h1>{title}</h1>
        <p>{desc}</p>
      </div>
    </header>
  );
}

function Panel({ title, desc, children, extra }) {
  return (
    <section className="panel">
      <div className="panel-head">
        <div>
          <h2>{title}</h2>
          {desc && <p>{desc}</p>}
        </div>
        {extra}
      </div>
      {children}
    </section>
  );
}

function Stat({ label, value, note, symbol }) {
  return (
    <div className="stat">
      <div className="stat-symbol">{symbol}</div>
      <div>
        <span>{label}</span>
        <strong>{value}</strong>
        <small>{note}</small>
      </div>
    </div>
  );
}

function Sidebar({ page, setPage }) {
  const links = [
    ["home", "Overview", "▦"],
    ["players", "Players", "♙"],
    ["events", "Tournaments", "♜"],
    ["entry", "Data Entry", "＋"]
  ];

  return (
    <aside className="sidebar">
      <div className="brand">
        <div className="brand-icon">◈</div>
        <div>
          <b>VGC DATABASE</b>
          <small>TOURNAMENT EXPLORER</small>
        </div>
      </div>

      <div className="nav-caption">WORKSPACE</div>

      {links.map(([id, label, icon]) => (
        <button
          key={id}
          className={`nav-link ${page === id ? "selected" : ""}`}
          onClick={() => setPage(id)}
        >
          <span>{icon}</span>
          {label}
          {page === id && <i />}
        </button>
      ))}
    </aside>
  );
}

function Dashboard({ events }) {
  const [overview, setOverview] = useState(null);
  const [overviewError, setOverviewError] = useState("");

  useEffect(() => {
    fetch("http://localhost:3001/api/overview")
      .then(response => {
        if (!response.ok) {
          throw new Error("Failed to fetch overview");
        }

        return response.json();
      })
      .then(data => setOverview(data))
      .catch(error => {
        console.error(error);
        setOverviewError("Could not load overview data.");
      });
  }, []);

  const tournamentPlayers = overview?.tournamentCounts || [];
  const pokemonUsage = overview?.pokemonUsage || [];
  const totalTeams = overview?.counts.teams || 0;

  return (
    <>
      <Header
        title="Overview"
        desc="A snapshot of the competitive Pokémon database."
      />

      <div className="stats">
        <Stat
          label="PLAYERS"
          value={overview?.counts.players ?? "—"}
          note="Competitors in database"
          symbol="♙"
        />
        <Stat
          label="TOURNAMENTS"
          value={overview?.counts.tournaments ?? "—"}
          note="Recorded events"
          symbol="♜"
        />
        <Stat
          label="TEAMS"
          value={overview?.counts.teams ?? "—"}
          note="Registered tournament teams"
          symbol="▦"
        />
        <Stat
          label="POKÉMON"
          value={overview?.counts.pokemon ?? "—"}
          note="Species and forms catalogued"
          symbol="◈"
        />
      </div>

      {overviewError && (
        <div className="empty">{overviewError}</div>
      )}

      <div className="two-col">
        <Panel
          title="Tournaments"
          desc="Events currently in the database"
          extra={
            <span className="tag">
              {overview?.counts.tournaments ?? "—"} EVENTS
            </span>
          }
        >
          {events.map(e => {
            const entrantData = tournamentPlayers.find(
              t => t.tournament_id === e.id
            );

            return (
              <div className="event-row" key={e.id}>
                <div className="event-symbol">♜</div>
                <div className="event-text">
                  <b>{e.name}</b>
                  <small>⌖ {e.location}</small>
                  <small>
                    ▦ {e.startDate} · {e.format}
                  </small>
                </div>
                <div className="event-total">
                  <b>{entrantData?.player_count ?? "—"}</b>
                  <small>players</small>
                </div>
              </div>
            );
          })}
        </Panel>

        <Panel
          title="Pokémon usage"
          desc="Most-used Pokémon across tournament teams"
          extra={<span className="tag">TOP 5</span>}
        >
          {pokemonUsage.map((pokemon, i) => {
            const percentage = totalTeams > 0
              ? (pokemon.usage_count / totalTeams) * 100
              : 0;

            return (
              <div className="usage" key={pokemon.pokemon_id}>
                <div>
                  <small>{String(i + 1).padStart(2, "0")}</small>
                  <b>{pokemon.pokemon_name}</b>
                  <span>{pokemon.usage_count} teams</span>
                </div>
                <div className="bar">
                  <i style={{ width: `${percentage}%` }} />
                </div>
              </div>
            );
          })}
        </Panel>
      </div>

      <div className="welcome">
        <div>
          <small>DATABASE PROJECT</small>
          <b>
            Explore tournament results, player teams, and Pokémon
            usage.
          </b>
          <p>
            Use the navigation to browse records or try the
            data-entry forms.
          </p>
        </div>
        <strong>
          VGC <em>/</em> DB
        </strong>
      </div>
    </>
  );
}

function Players({ players, setPlayers }) {
  const [term, setTerm] = useState("");
  const [active, setActive] = useState(1);
  const [teams, setTeams] = useState([]);
  const [loadingTeams, setLoadingTeams] = useState(false);
  const [teamError, setTeamError] = useState("");

  const matches = useMemo(
    () => players.filter(p =>
      (p.name + " " + p.country)
        .toLowerCase()
        .includes(term.toLowerCase())
    ),
    [players, term]
  );

  const chosen = players.find(p => p.id === active) || matches[0];

  useEffect(() => {
    if (!chosen) {
      setTeams([]);
      return;
    }

    setLoadingTeams(true);
    setTeamError("");

    fetch(`http://localhost:3001/api/players/${chosen.id}/teams`)
      .then(response => {
        if (!response.ok) {
          throw new Error("Failed to fetch player teams");
        }

        return response.json();
      })
      .then(data => setTeams(data))
      .catch(error => {
        console.error(error);
        setTeamError("Could not load this player's teams.");
      })
      .finally(() => setLoadingTeams(false));
  }, [chosen?.id]);

  const groupedTeams = useMemo(() => {
    const groups = new Map();

    teams.forEach(pokemon => {
      if (!groups.has(pokemon.team_id)) {
        groups.set(pokemon.team_id, {
          team_id: pokemon.team_id,
          format: pokemon.format,
          tournament_id: pokemon.tournament_id,
          tournament_name: pokemon.tournament_name,
          start_date: pokemon.start_date,
          placement: pokemon.placement,
          pokemon: []
        });
      }

      groups.get(pokemon.team_id).pokemon.push(pokemon);
    });

    return Array.from(groups.values());
  }, [teams]);

  return (
    <>
      <Header
        title="Players"
        desc="Search competitors and explore their tournament records and teams."
      />

      <div className="toolbar">
        <div className="search">
          <span>⌕</span>
          <input
            value={term}
            onChange={e => setTerm(e.target.value)}
            placeholder="Search by player or country..."
          />
        </div>
        <span className="count">{matches.length} PLAYERS</span>
      </div>

      <div className="players-layout">
        <Panel
          title="Competitors"
          desc="Select a player to inspect their record"
        >
          <div className="player-list">
            {matches.map(p => (
              <button
                key={p.id}
                className={chosen?.id === p.id ? "active" : ""}
                onClick={() => setActive(p.id)}
              >
                <span className="avatar">
                  {p.name.split(" ")
                    .map(x => x[0])
                    .slice(0, 2)
                    .join("")}
                </span>
                <span className="player-name">
                  <b>{p.name}</b>
                  <small>{p.country}</small>
                </span>
                <span className="rank">
                  #{p.id === 1 ? 1 : p.id}
                </span>
              </button>
            ))}

            {!matches.length && (
              <div className="empty">
                No players match that search.
              </div>
            )}
          </div>
        </Panel>

        <Panel
          title={chosen?.name || "Player profile"}
          desc="Player profile and tournament information"
        >
          {chosen && (
            <>
              <div className="profile-head">
                <span className="avatar large">
                  {chosen.name.split(" ")
                    .map(x => x[0])
                    .slice(0, 2)
                    .join("")}
                </span>

                <div className="profile-title">
                  <span className="tag">PLAYER PROFILE</span>
                  <h2>{chosen.name}</h2>
                  <small>{chosen.country}</small>
                </div>
              </div>

              <div className="mini-stats">
                <div>
                  <small>TOURNAMENTS</small>
                  <b>
                    {new Set(
                      groupedTeams
                        .filter(team => team.tournament_id !== null)
                        .map(team => team.tournament_id)
                    ).size}
                  </b>
                </div>
                <div>
                  <small>BEST PLACEMENT</small>
                  <b>
                    {groupedTeams.some(team => team.placement !== null)
                      ? `#${Math.min(
                        ...groupedTeams
                          .filter(team => team.placement !== null)
                          .map(team => team.placement)
                      )}`
                      : "—"}
                  </b>
                </div>
                <div>
                  <small>PLAYER ID</small>
                  <b>#{chosen.id}</b>
                </div>
              </div>

              <h3 className="subheading">Tournament history</h3>

              {groupedTeams
                .filter(team => team.tournament_id !== null)
                .filter((team, index, array) =>
                  array.findIndex(t =>
                    t.tournament_id === team.tournament_id
                  ) === index
                )
                .map(team => (
                  <div className="history" key={team.tournament_id}>
                    <span>#{team.placement ?? "—"}</span>
                    <div>
                      <b>{team.tournament_name}</b>
                      <small>{team.format}</small>
                    </div>
                    <small>{team.start_date?.slice(0, 4)}</small>
                  </div>
                ))}

              <div className="subheading-row">
                <h3 className="subheading">Team roster</h3>
                <span className="tag">{groupedTeams.length} TEAMS</span>
              </div>

              {loadingTeams && (
                <div className="empty">Loading teams...</div>
              )}

              {teamError && (
                <div className="empty">{teamError}</div>
              )}

              {!loadingTeams && !teamError && groupedTeams.length === 0 && (
                <div className="empty">
                  No teams recorded for this player.
                </div>
              )}

              {!loadingTeams && groupedTeams.map(team => (
                <div className="team-card" key={team.team_id}>
                  <div className="team-card-header">
                    <div>
                      <b>{team.tournament_name || "Unassigned team"}</b>
                      <small>{team.format}</small>
                    </div>
                    <span className="tag">
                      {team.placement
                        ? `#${team.placement}`
                        : "No placement"}
                    </span>
                  </div>

                  <div className="roster">
                    {team.pokemon.map(p => (
                      <div className="team-pokemon" key={p.slot}>
                        <small>SLOT {p.slot}</small>
                        <b>{p.pokemon_name}</b>
                        <div className="pokemon-types">
                          <span>{p.pokemon_type1}</span>
                          {p.pokemon_type2 && (
                            <span>{p.pokemon_type2}</span>
                          )}
                        </div>

                        <div className="pokemon-details">
                          <div>
                            <b>Ability</b>
                            <span>{p.ability}</span>
                          </div>
                          <div>
                            <b>Held Item</b>
                            <span>{p.held_item || "None recorded"}</span>
                          </div>
                          <div>
                            <b>Tera Type</b>
                            <span>{p.tera_type || "Not applicable"}</span>
                          </div>
                          <div>
                            <b>Moves</b>
                            <span>
                              {[p.move1, p.move2, p.move3, p.move4]
                                .filter(Boolean)
                                .join(" · ")}
                            </span>
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              ))}
            </>
          )}
        </Panel>
      </div>
    </>
  );
}

function Tournaments({ tournaments }) {
  const [id, setId] = useState(null);
  const [term, setTerm] = useState("");
  const [showCompare, setShowCompare] = useState(false);
  const [tournamentTerm, setTournamentTerm] = useState("");
  const [usage, setUsage] = useState([]);
  const [loadingUsage, setLoadingUsage] = useState(false);
  const [usageError, setUsageError] = useState("");

  const event = tournaments.find(e => e.id === id) || tournaments[0];

  const filteredTournaments = useMemo(
    () => tournaments.filter(t =>
      [
        t.name,
        t.location,
        t.format,
        t.startDate,
        t.endDate
      ]
        .join(" ")
        .toLowerCase()
        .includes(tournamentTerm.toLowerCase())
    ),
    [tournaments, tournamentTerm]
  );

  const [standings, setStandings] = useState([]);

  useEffect(() => {
    if (!event) return;

    fetch(`http://localhost:3001/api/tournaments/${event.id}/standings`)
      .then(response => {
        if (!response.ok) {
          throw new Error("Failed to fetch standings");
        }

        return response.json();
      })
      .then(data => setStandings(data))
      .catch(error => console.error(error));
  }, [event?.id]);

  useEffect(() => {
    if (!event) return;

    setLoadingUsage(true);
    setUsageError("");

    fetch(`http://localhost:3001/api/tournaments/${event.id}/usage`)
      .then(response => {
        if (!response.ok) {
          throw new Error("Failed to fetch Pokémon usage");
        }

        return response.json();
      })
      .then(data => setUsage(data))
      .catch(error => {
        console.error(error);
        setUsageError("Could not load Pokémon usage.");
      })
      .finally(() => setLoadingUsage(false));
  }, [event?.id]);

  const rows = standings.filter(r =>
    r.player_name.toLowerCase().includes(term.toLowerCase())
  );

  return (
    <>
      <Header
        title="Tournaments"
        desc="Browse events, results, and the teams competing at each event."
      />

      <div className="tournament-browser">
        <div className="toolbar">
          <div className="search">
            <span>⌕</span>
            <input
              value={tournamentTerm}
              onChange={e => setTournamentTerm(e.target.value)}
              placeholder="Search by title, location, date, or regulation..."
            />
          </div>

          <span className="count">
            {filteredTournaments.length} TOURNAMENTS
          </span>
        </div>

        <div className="tournament-list">
          {filteredTournaments.map(e => (
            <button
              key={e.id}
              className={e.id === event?.id ? "chosen" : ""}
              onClick={() => {
                setId(e.id);
                setTerm("");
              }}
            >
              <span className="tournament-date">
                {e.startDate}
              </span>

              <span className="tournament-info">
                <b>{e.name}</b>
                <small>{e.location}</small>
              </span>

              <span className="tournament-format">
                {e.format}
              </span>

              <span className="tournament-arrow">›</span>
            </button>
          ))}

          {!filteredTournaments.length && (
            <div className="empty">
              No tournaments match your search.
            </div>
          )}
        </div>
      </div>

      {event && (
        <>
          <Panel
            title={event.name}
            desc={event.game}
            extra={<span className="tag blue">{event.format}</span>}
          >
            <div className="facts">
              <span>⌖ {event.location}</span>
              <span>▦ {event.startDate} – {event.endDate}</span>
              <span>♙ {event.division} division</span>
            </div>
          </Panel>

          <div className="gap" />

          <Panel
            title="Final standings"
            desc="Recorded tournament placements"
            extra={
              <div className="search small-search">
                <span>⌕</span>
                <input
                  value={term}
                  onChange={e => setTerm(e.target.value)}
                  placeholder="Filter players..."
                />
              </div>
            }
          >
            <div className="table-scroll">
              <table>
                <thead>
                  <tr>
                    <th>PLACE</th>
                    <th>PLAYER</th>
                    <th>COUNTRY</th>
                    <th>TEAM</th>
                  </tr>
                </thead>
                <tbody>
                  {rows.map(r => (
                    <tr key={r.player_id}>
                      <td>
                        <span
                          className={`place ${
                            r.placement === 1 ? "gold" : ""
                          }`}
                        >
                          {r.placement ?? "—"}
                        </span>
                      </td>
                      <td><b>{r.player_name}</b></td>
                      <td>{r.player_country}</td>
                      <td>{r.team || "No team recorded"}</td>
                    </tr>
                  ))}
                </tbody>
              </table>

              {!rows.length && (
                <div className="empty">
                  No matching players.
                </div>
              )}
            </div>
          </Panel>

          <div className="gap" />

          <Panel
            title="Compare Pokémon usage"
            desc="Compare which Pokémon appeared across tournament teams."
            extra={
              <button
                className="secondary"
                onClick={() => setShowCompare(!showCompare)}
              >
                {showCompare
                  ? "Hide comparison"
                  : "Show comparison"} ›
              </button>
            }
          >
            {showCompare && (
              <div className="compare">
                {loadingUsage && (
                  <div className="empty">
                    Loading Pokémon usage...
                  </div>
                )}

                {usageError && (
                  <div className="empty">{usageError}</div>
                )}

                {!loadingUsage && !usageError && usage.length === 0 && (
                  <div className="empty">
                    No Pokémon usage data available.
                  </div>
                )}

                {!loadingUsage && !usageError && usage.length > 0 && (
                  <>
                    <b>Most-used Pokémon</b>

                    {usage.slice(0, 10).map(pokemon => {
                      const percentage = pokemon.total_teams > 0
                        ? (pokemon.usage_count / pokemon.total_teams) * 100
                        : 0;

                      return (
                        <div
                          className="usage-row"
                          key={pokemon.pokemon_id}
                        >
                          <div className="usage-info">
                            <span>{pokemon.pokemon_name}</span>
                            <small>
                              {pokemon.usage_count} / {pokemon.total_teams} teams
                              ({percentage.toFixed(1)}%)
                            </small>
                          </div>

                          <div className="bar">
                            <i style={{ width: `${percentage}%` }} />
                          </div>
                        </div>
                      );
                    })}
                  </>
                )}
              </div>
            )}
          </Panel>
        </>
      )}
    </>
  );
}

function DataEntry({ players, setPlayers, events, setEvents }) {
  const [tab, setTab] = useState("register");
  const [message, setMessage] = useState("");

  const [name, setName] = useState("");
  const [country, setCountry] = useState("");

  const [newEvent, setNewEvent] = useState({
    name: "",
    location: "",
    startDate: "",
    endDate: "",
    division: "Masters",
    format: "Regulation G",
    game: "Pokémon Scarlet and Violet"
  });

  const [playerId, setPlayerId] = useState("1");
  const [eventId, setEventId] = useState("1");

  const [teamMode, setTeamMode] = useState("existing");
  const [selectedTeamId, setSelectedTeamId] = useState("");

  const [pokemonCatalog, setPokemonCatalog] = useState([]);
  const [playerTeams, setPlayerTeams] = useState([]);
  const [loadingPokemon, setLoadingPokemon] = useState(true);
  const [loadingTeams, setLoadingTeams] = useState(false);
  const [registrationError, setRegistrationError] = useState("");

  const emptyPokemon = () => ({
    pokemonId: "",
    ability: "",
    heldItem: "",
    teraType: "",
    move1: "",
    move2: "",
    move3: "",
    move4: ""
  });

  const [team, setTeam] = useState(
    Array.from({ length: 6 }, emptyPokemon)
  );

  const [deleteType, setDeleteType] = useState("player");
  const [deletePlayerId, setDeletePlayerId] = useState("");
  const [deleteTournamentId, setDeleteTournamentId] = useState("");
  const [deleteRegistrationPlayerId, setDeleteRegistrationPlayerId] =
    useState("");
  const [deleteTeamId, setDeleteTeamId] = useState("");

  const [deleteEntries, setDeleteEntries] = useState([]);
  const [deleteTeams, setDeleteTeams] = useState([]);
  const [deleteLoading, setDeleteLoading] = useState(false);
  const [deleteError, setDeleteError] = useState("");

  const tabs = [
    ["register", "Register team"],
    ["player", "Add player"],
    ["event", "Add tournament"],
    ["delete", "Delete data"]
  ];

  useEffect(() => {
    fetch("http://localhost:3001/api/pokemon")
      .then(response => {
        if (!response.ok) {
          throw new Error("Failed to load Pokémon.");
        }

        return response.json();
      })
      .then(data => setPokemonCatalog(data))
      .catch(error => {
        console.error(error);
        setRegistrationError("Could not load the Pokémon catalog.");
      })
      .finally(() => setLoadingPokemon(false));
  }, []);

  useEffect(() => {
    if (!playerId) {
      setPlayerTeams([]);
      return;
    }

    setLoadingTeams(true);

    fetch(`http://localhost:3001/api/players/${playerId}/teams`)
      .then(response => {
        if (!response.ok) {
          throw new Error("Failed to load player teams.");
        }

        return response.json();
      })
      .then(data => {
        setPlayerTeams(data);
        setSelectedTeamId("");
      })
      .catch(error => {
        console.error(error);
        setRegistrationError("Could not load this player's teams.");
      })
      .finally(() => setLoadingTeams(false));
  }, [playerId]);

  // Load tournament registrations for deletion
  useEffect(() => {
    if (
      tab !== "delete" ||
      deleteType !== "registration" ||
      !deleteTournamentId
    ) {
      setDeleteEntries([]);
      return;
    }

    setDeleteLoading(true);
    setDeleteError("");

    fetch(
      `http://localhost:3001/api/tournaments/${deleteTournamentId}/standings`
    )
      .then(response => {
        if (!response.ok) {
          throw new Error("Failed to load registrations.");
        }

        return response.json();
      })
      .then(data => setDeleteEntries(data))
      .catch(error => setDeleteError(error.message))
      .finally(() => setDeleteLoading(false));
  }, [tab, deleteType, deleteTournamentId]);

  // Load a player's teams for deletion
  useEffect(() => {
    if (
      tab !== "delete" ||
      deleteType !== "team" ||
      !deletePlayerId
    ) {
      setDeleteTeams([]);
      return;
    }

    setDeleteLoading(true);
    setDeleteError("");

    fetch(`http://localhost:3001/api/players/${deletePlayerId}/teams`)
      .then(response => {
        if (!response.ok) {
          throw new Error("Failed to load teams.");
        }

        return response.json();
      })
      .then(data => {
        // Each team can appear multiple times in this endpoint.
        // Keep only one entry for each team ID.
        const uniqueTeams = [
          ...new Map(
            data.map(team => [team.team_id, team])
          ).values()
        ];

        setDeleteTeams(uniqueTeams);
        setDeleteTeamId("");
      })
      .catch(error => setDeleteError(error.message))
      .finally(() => setDeleteLoading(false));
  }, [tab, deleteType, deletePlayerId]);

  async function addPlayer(e) {
    e.preventDefault();
    setMessage("");

    try {
      const response = await fetch("http://localhost:3001/api/players", {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({
          name,
          country
        })
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || "Failed to add player.");
      }

      setPlayers(old => [
        ...old,
        {
          id: data.player_id,
          name: data.player_name,
          country: data.player_country,
          team: []
        }
      ]);

      setName("");
      setCountry("");
      setMessage(`${data.player_name} was successfully added.`);
    } catch (error) {
      setMessage(error.message);
    }
  }

  async function addEvent(e) {
    e.preventDefault();
    setMessage("");

    try {
      const response = await fetch("http://localhost:3001/api/tournaments", {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify(newEvent)
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || "Failed to add tournament.");
      }

      setEvents(old => [
        ...old,
        {
          id: data.tournament_id,
          name: data.tournament_name,
          location: data.location,
          startDate: data.start_date,
          endDate: data.end_date,
          division: data.division,
          game: data.game,
          format: data.format
        }
      ]);

      setNewEvent({
        name: "",
        location: "",
        startDate: "",
        endDate: "",
        division: "Masters",
        format: "Regulation G",
        game: "Pokémon Scarlet and Violet"
      });

      setMessage(`${data.tournament_name} was successfully added.`);
    } catch (error) {
      setMessage(error.message);
    }
  }

  async function register(e) {
    e.preventDefault();
    setMessage("");
    setRegistrationError("");

    const body = {
      playerId: Number(playerId),
      tournamentId: Number(eventId)
    };

    if (teamMode === "existing") {
      if (!selectedTeamId) {
        setRegistrationError("Please select a team.");
        return;
      }

      body.teamId = Number(selectedTeamId);
    } else {
      if (
        team.some(p =>
          !p.pokemonId ||
          !p.ability.trim() ||
          !p.move1.trim()
        )
      ) {
        setRegistrationError(
          "Each Pokémon needs a species, ability, and at least one move."
        );
        return;
      }

      body.pokemon = team.map(p => ({
        ...p,
        pokemonId: Number(p.pokemonId)
      }));
    }

    try {
      const response = await fetch("http://localhost:3001/api/teams", {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify(body)
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || "Failed to register team.");
      }

      setMessage(
        `Team #${data.teamId} was successfully registered!`
      );

      // Refresh the player's teams
      const teamsResponse = await fetch(
        `http://localhost:3001/api/players/${playerId}/teams`
      );

      if (teamsResponse.ok) {
        setPlayerTeams(await teamsResponse.json());
      }

      if (teamMode === "new") {
        setTeam(Array.from({ length: 6 }, emptyPokemon));
      }
    } catch (error) {
      setRegistrationError(error.message);
    }
  }

  async function deleteData(e) {
    e.preventDefault();
    setMessage("");
    setDeleteError("");

    let url = "";
    let description = "";
    let confirmation = "";

    if (deleteType === "player") {
      if (!deletePlayerId) {
        setDeleteError("Please select a player.");
        return;
      }

      url = `http://localhost:3001/api/players/${deletePlayerId}`;
      description = "Player";
      confirmation =
        "This will also delete all of this player's teams and tournament registrations. Continue?";
    } else if (deleteType === "tournament") {
      if (!deleteTournamentId) {
        setDeleteError("Please select a tournament.");
        return;
      }

      url = `http://localhost:3001/api/tournaments/${deleteTournamentId}`;
      description = "Tournament";
      confirmation =
        "This will also delete all registrations for this tournament. Continue?";
    } else if (deleteType === "registration") {
      if (!deleteTournamentId || !deleteRegistrationPlayerId) {
        setDeleteError("Please select a tournament and player.");
        return;
      }

      url =
        `http://localhost:3001/api/tournaments/${deleteTournamentId}/entries/${deleteRegistrationPlayerId}`;
      description = "Registration";
      confirmation =
        "Delete this player's registration from the tournament?";
    } else if (deleteType === "team") {
      if (!deleteTeamId) {
        setDeleteError("Please select a team.");
        return;
      }

      url = `http://localhost:3001/api/teams/${deleteTeamId}`;
      description = "Team";
      confirmation =
        "This will also remove every tournament registration using this team. Continue?";
    }

    if (!window.confirm(confirmation)) {
      return;
    }

    try {
      const response = await fetch(url, {
        method: "DELETE"
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(
          data.error || `Failed to delete ${description.toLowerCase()}.`
        );
      }

      if (deleteType === "player") {
        setPlayers(old =>
          old.filter(p => p.id !== Number(deletePlayerId))
        );
        setDeletePlayerId("");
      } else if (deleteType === "tournament") {
        setEvents(old =>
          old.filter(event => event.id !== Number(deleteTournamentId))
        );
        setDeleteTournamentId("");
      } else if (deleteType === "registration") {
        setDeleteEntries(old =>
          old.filter(
            p => p.player_id !== Number(deleteRegistrationPlayerId)
          )
        );
        setDeleteRegistrationPlayerId("");
      } else if (deleteType === "team") {
        setDeleteTeams(old =>
          old.filter(team => team.team_id !== Number(deleteTeamId))
        );
        setDeleteTeamId("");
      }

      setMessage(`${description} successfully deleted.`);
    } catch (error) {
      setDeleteError(error.message);
    }
  }

  return (
    <>
      <Header
        title="Data Entry"
        desc="Add records, register tournament teams, and maintain player information."
      />

      <div className="entry-notice">
        <span>＋</span>
        <div>
          <b>Manage database records</b>
          <p>
            Add tournament records, register teams, and manage existing database entries.
          </p>
        </div>
      </div>

      <div className="entry-layout">
        <div className="entry-tabs">
          {tabs.map(([key, label]) => (
            <button
              className={tab === key ? "active" : ""}
              key={key}
              onClick={() => {
                setTab(key);
                setMessage("");
              }}
            >
              {label}
              <span>›</span>
            </button>
          ))}
        </div>

        <Panel
          title={
            tab === "register"
              ? "Register a tournament team"
              : tab === "player"
                ? "Add a player"
                : tab === "event"
                  ? "Add a tournament"
                  : "Delete database records"
          }
          desc={
            tab === "register"
              ? "Choose a player and tournament, then select the six Pokémon on their roster."
              : tab === "player"
                ? "Create a competitor record."
                : tab === "event"
                  ? "Enter the basic details for a competitive event."
                  : "Select a type of record and choose what you want to delete."
          }
        >
          {message && <div className="success">{message}</div>}

          {tab === "register" && (
            <form onSubmit={register}>
              <div className="form-grid">
                <label>
                  Select player
                  <select
                    value={playerId}
                    onChange={e => setPlayerId(e.target.value)}
                    required
                  >
                    {players.map(p => (
                      <option key={p.id} value={p.id}>
                        {p.name}
                      </option>
                    ))}
                  </select>
                </label>

                <label>
                  Tournament
                  <select
                    value={eventId}
                    onChange={e => setEventId(e.target.value)}
                    required
                  >
                    {events.map(e => (
                      <option key={e.id} value={e.id}>
                        {e.name}
                      </option>
                    ))}
                  </select>
                </label>

                <label className="full">
                  Team option
                  <select
                    value={teamMode}
                    onChange={e => setTeamMode(e.target.value)}
                  >
                    <option value="existing">Use an existing team</option>
                    <option value="new">Create a new team</option>
                  </select>
                </label>
              </div>

              {teamMode === "existing" && (
                <div className="form-grid">
                  <label className="full">
                    Select team
                    <select
                      value={selectedTeamId}
                      onChange={e => setSelectedTeamId(e.target.value)}
                      required
                    >
                      <option value="">Choose a team...</option>

                      {[...new Map(
                        playerTeams
                          .filter(t =>
                            t.format === events.find(
                              e => e.id === Number(eventId)
                            )?.format
                          )
                          .map(t => [t.team_id, t])
                      ).values()].map(t => (
                        <option key={t.team_id} value={t.team_id}>
                          Team #{t.team_id} · {t.format}
                        </option>
                      ))}
                    </select>
                  </label>

                  {loadingTeams && (
                    <div className="empty">
                      Loading existing teams...
                    </div>
                  )}
                </div>
              )}

              {teamMode === "new" && (
                <>
                  <div className="subheading-row">
                    <h3 className="subheading">Team roster</h3>
                    <span className="tag">6 SLOTS</span>
                  </div>

                  {loadingPokemon && (
                    <div className="empty">
                      Loading Pokémon catalog...
                    </div>
                  )}

                  {!loadingPokemon && pokemonCatalog.length === 0 && (
                    <div className="empty">
                      No Pokémon could be loaded.
                    </div>
                  )}

                  <div className="pokemon-selects">
                    {team.map((p, i) => (
                      <div className="pokemon-entry" key={i}>
                        <b>Pokémon {i + 1}</b>

                        <label>
                          Species
                          <select
                            value={p.pokemonId}
                            onChange={e =>
                              setTeam(old =>
                                old.map((x, j) =>
                                  j === i
                                    ? { ...x, pokemonId: e.target.value }
                                    : x
                                )
                              )
                            }
                            required
                          >
                            <option value="">Select Pokémon...</option>
                            {pokemonCatalog.map(mon => (
                              <option
                                key={mon.pokemon_id}
                                value={mon.pokemon_id}
                              >
                                {mon.pokemon_name}
                              </option>
                            ))}
                          </select>
                        </label>

                        <label>
                          Ability
                          <input
                            value={p.ability}
                            onChange={e =>
                              setTeam(old =>
                                old.map((x, j) =>
                                  j === i
                                    ? { ...x, ability: e.target.value }
                                    : x
                                )
                              )
                            }
                            required
                          />
                        </label>

                        <label>
                          Held item
                          <input
                            value={p.heldItem}
                            onChange={e =>
                              setTeam(old =>
                                old.map((x, j) =>
                                  j === i
                                    ? { ...x, heldItem: e.target.value }
                                    : x
                                )
                              )
                            }
                          />
                        </label>

                        <label>
                          Tera type
                          <input
                            value={p.teraType}
                            onChange={e =>
                              setTeam(old =>
                                old.map((x, j) =>
                                  j === i
                                    ? { ...x, teraType: e.target.value }
                                    : x
                                )
                              )
                            }
                          />
                        </label>

                        {[1, 2, 3, 4].map(move => (
                          <label key={move}>
                            Move {move}
                            <input
                              value={p[`move${move}`]}
                              onChange={e =>
                                setTeam(old =>
                                  old.map((x, j) =>
                                    j === i
                                      ? {
                                        ...x,
                                        [`move${move}`]: e.target.value
                                      }
                                      : x
                                  )
                                )
                              }
                              required={move === 1}
                            />
                          </label>
                        ))}
                      </div>
                    ))}
                  </div>
                </>
              )}

              {registrationError && (
                <div className="error">{registrationError}</div>
              )}

              <div className="form-foot">
                <small>
                  {teamMode === "existing"
                    ? "Register a previously created team for this tournament."
                    : "Create a new six-Pokémon team and register it."}
                </small>

                <button
                  className="primary"
                  disabled={loadingPokemon || loadingTeams}
                >
                  Register team →
                </button>
              </div>
            </form>
          )}

          {tab === "player" && (
            <form onSubmit={addPlayer}>
              <div className="form-grid">
                <label>
                  Player name
                  <input
                    value={name}
                    onChange={e => setName(e.target.value)}
                    required
                    placeholder="e.g. Alex Smith"
                  />
                </label>
                <label>
                  Country
                  <input
                    value={country}
                    onChange={e => setCountry(e.target.value)}
                    required
                    placeholder="e.g. United States"
                  />
                </label>
              </div>

              <div className="form-foot">
                <small>Player names must be unique.</small>
                <button className="primary">
                  Add player ＋
                </button>
              </div>
            </form>
          )}

          {tab === "event" && (
            <form onSubmit={addEvent}>
              <div className="form-grid">
                <label className="full">
                  Tournament name
                  <input
                    value={newEvent.name}
                    onChange={e =>
                      setNewEvent({
                        ...newEvent,
                        name: e.target.value
                      })
                    }
                    required
                  />
                </label>

                <label>
                  Location
                  <input
                    value={newEvent.location}
                    onChange={e =>
                      setNewEvent({
                        ...newEvent,
                        location: e.target.value
                      })
                    }
                    required
                    placeholder="City, State, Country"
                  />
                </label>

                <label>
                  Division
                  <select
                    value={newEvent.division}
                    onChange={e =>
                      setNewEvent({
                        ...newEvent,
                        division: e.target.value
                      })
                    }
                  >
                    <option>Masters</option>
                    <option>Senior</option>
                    <option>Junior</option>
                  </select>
                </label>

                <label>
                  Start date
                  <input
                    type="date"
                    value={newEvent.startDate}
                    onChange={e =>
                      setNewEvent({
                        ...newEvent,
                        startDate: e.target.value
                      })
                    }
                    required
                  />
                </label>

                <label>
                  End date
                  <input
                    type="date"
                    value={newEvent.endDate}
                    min={newEvent.startDate || undefined}
                    onChange={e =>
                      setNewEvent({
                        ...newEvent,
                        endDate: e.target.value
                      })
                    }
                    required
                  />
                </label>

                <label>
                  Format
                  <select
                    value={newEvent.format}
                    onChange={e =>
                      setNewEvent({
                        ...newEvent,
                        format: e.target.value
                      })
                    }
                  >
                    <option>Regulation G</option>
                    <option>Regulation H</option>
                    <option>Regulation I</option>
                    <option>VGC 2016</option>
                    <option>Other</option>
                  </select>
                </label>

                <label>
                  Game
                  <input
                    value={newEvent.game}
                    onChange={e =>
                      setNewEvent({
                        ...newEvent,
                        game: e.target.value
                      })
                    }
                    required
                  />
                </label>
              </div>

              <div className="form-foot">
                <small>
                  Results and player registrations can be added after creating the event.
                </small>
                <button className="primary">
                  Add tournament ＋
                </button>
              </div>
            </form>
          )}

          {tab === "delete" && (
            <form onSubmit={deleteData}>
              <div className="form-grid">
                <label className="full">
                  Record type
                  <select
                    value={deleteType}
                    onChange={e => {
                      setDeleteType(e.target.value);
                      setMessage("");
                      setDeleteError("");
                      setDeleteRegistrationPlayerId("");
                      setDeleteTeamId("");
                    }}
                  >
                    <option value="player">Player</option>
                    <option value="tournament">Tournament</option>
                    <option value="registration">Tournament registration</option>
                    <option value="team">Team</option>
                  </select>
                </label>

                {(deleteType === "player" || deleteType === "team") && (
                  <label className="full">
                    Select player
                    <select
                      value={deletePlayerId}
                      onChange={e => setDeletePlayerId(e.target.value)}
                      required
                    >
                      <option value="">Choose a player...</option>
                      {players.map(p => (
                        <option key={p.id} value={p.id}>
                          {p.name}
                        </option>
                      ))}
                    </select>
                  </label>
                )}

                {(deleteType === "tournament" ||
                  deleteType === "registration") && (
                  <label className="full">
                    Select tournament
                    <select
                      value={deleteTournamentId}
                      onChange={e => {
                        setDeleteTournamentId(e.target.value);
                        setDeleteRegistrationPlayerId("");
                      }}
                      required
                    >
                      <option value="">Choose a tournament...</option>
                      {events.map(event => (
                        <option key={event.id} value={event.id}>
                          {event.name}
                        </option>
                      ))}
                    </select>
                  </label>
                )}

                {deleteType === "registration" && (
                  <label className="full">
                    Select registered player
                    <select
                      value={deleteRegistrationPlayerId}
                      onChange={e =>
                        setDeleteRegistrationPlayerId(e.target.value)
                      }
                      disabled={!deleteTournamentId || deleteLoading}
                      required
                    >
                      <option value="">Choose a player...</option>
                      {deleteEntries.map(p => (
                        <option key={p.player_id} value={p.player_id}>
                          {p.player_name}
                        </option>
                      ))}
                    </select>
                  </label>
                )}

                {deleteType === "team" && (
                  <label className="full">
                    Select team
                    <select
                      value={deleteTeamId}
                      onChange={e => setDeleteTeamId(e.target.value)}
                      disabled={!deletePlayerId || deleteLoading}
                      required
                    >
                      <option value="">Choose a team...</option>
                      {deleteTeams.map(team => (
                        <option key={team.team_id} value={team.team_id}>
                          Team #{team.team_id} · {team.format}
                        </option>
                      ))}
                    </select>
                  </label>
                )}
              </div>

              {deleteLoading && (
                <div className="empty">Loading records...</div>
              )}

              {deleteError && (
                <div className="error">{deleteError}</div>
              )}

              <div className="form-foot">
                <small>
                  Deletions are permanent and may remove related records.
                </small>

                <button className="primary delete-button">
                  Delete record
                </button>
              </div>
            </form>
          )}
        </Panel>
      </div>
    </>
  );
}

export default function App() {
  const [page, setPage] = useState("home");
  const [players, setPlayers] = useState([]);
  const [events, setEvents] = useState([]);

  useEffect(() => {
    // Fetch players
    fetch("http://localhost:3001/api/players")
      .then(response => {
        if (!response.ok) {
          throw new Error("Failed to fetch players");
        }

        return response.json();
      })
      .then(data => {
        setPlayers(data.map(player => ({
          id: player.player_id,
          name: player.player_name,
          country: player.player_country,
          team: []
        })));
      })
      .catch(error => console.error(error));

    // Fetch tournaments
    fetch("http://localhost:3001/api/tournaments")
      .then(response => {
        if (!response.ok) {
          throw new Error("Failed to fetch tournaments");
        }

        return response.json();
      })
      .then(data => {
        setEvents(data.map(tournament => ({
          id: tournament.tournament_id,
          name: tournament.tournament_name,
          location: tournament.location,
          startDate: tournament.start_date,
          endDate: tournament.end_date,
          division: tournament.division,
          game: tournament.game,
          format: tournament.format
        })));
      })
      .catch(error => console.error(error));
  }, []);

  return (
    <div className="app">
      <Sidebar page={page} setPage={setPage} />

      <main className="main">
        <div className="mobile-title">◈ VGC DATABASE</div>

        {page === "home" && (
          <Dashboard events={events} />
        )}

        {page === "players" && (
          <Players
            players={players}
            setPlayers={setPlayers}
          />
        )}

        {page === "events" && (
          <Tournaments tournaments={events} />
        )}

        {page === "entry" && (
          <DataEntry
            players={players}
            setPlayers={setPlayers}
            events={events}
            setEvents={setEvents}
          />
        )}

        <footer>
          VGC DATABASE <span>·</span> COMPETITIVE DATA
          <small>Pokémon VGC</small>
        </footer>
      </main>
    </div>
  );
}