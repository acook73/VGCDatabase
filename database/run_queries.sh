
#!/bin/bash

# Stop if any command fails.
set -e

# Always run from the directory containing this script.
cd "$(dirname "$0")"

DB="pokemon.db"

echo "========================================"
echo "  Pokemon VGC Database Project"
echo "========================================"

# Step 1: Remove the previous database.
echo ""
echo "[1/5] Recreating database..."
rm -f "$DB" "$DB-wal" "$DB-shm"

# Step 2: Create the database schema.
echo "[2/5] Creating tables and views..."
sqlite3 -bail "$DB" < schema.sql

# Step 3: Insert the database contents.
echo "[3/5] Inserting data..."
sqlite3 -bail "$DB" < insert_data.sql

# Step 4: Run the queries.
echo "[4/5] Running queries..."
sqlite3 -bail "$DB" < queries.sql

# Step 5: Run the transaction.
echo "[5/5] Running transaction..."
sqlite3 -bail "$DB" < transaction.sql

echo ""
echo "========================================"
echo "  Database operations completed!"
echo "========================================"
