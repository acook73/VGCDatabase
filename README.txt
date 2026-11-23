Welcome to VGC Database!

------------------------------------------------------------------------------------------
SETUP
------------------------------------------------------------------------------------------

First, ensure you have the following installed:
  1. Node.js
  2. npm
  3. sqlite3

Next, create the database. Inside of the project's root directory, run:
  sqlite3 database/pokemon.db < database/schema.sql
  sqlite3 database/pokemon.db < database/insert_data.sql

Next, install and start the backend. Inside of the project's root directory, run:
  cd server
  npm install
  npm run dev
The backend should start on http://localhost:3001

Finally, install and start the front end. Inside of the project's root directory, run:
  cd client
  npm install
  npm run dev
Vite should provide an address, usually http://localhost:5173

Now, click on the link, and you are ready to use the website!

------------------------------------------------------------------------------------------
PROJECT INFORMATION
------------------------------------------------------------------------------------------

VGC Database uses a combination of React and Node.js for the website

For the six required operations, I have created the following:

1. Search and Browse Data:
  Under both the Player and Tournaments tabs on the right side of the screen, you are able to search for specific entries
  using different types of data, such as name, country, date, etc.

2. Display Related Data:
  Under the Player tab, you can see player data, team data, and tournament placement and registration data all together.

3. Add Data:
  Under the Data Entry tab, you can add players, tournaments, and register teams.

4. Delete Data:
  Under the Data Entry tab, you can delete players, tournaments, tournament registrations, and teams.

5. Summary or Report:
  Under the Tournaments tab, you can see a list of tournament standings, which uses joines and the vw_tournament_standings
  view to display the results.

6. Additional Meaningful Operation:
  There are several additional operations, including Pokemon usage statistics on both the Overview tab, which displays overall
  Pokemon usage rates, and on the Tournaments tab, which displays Pokemon usage rates for that tournament.