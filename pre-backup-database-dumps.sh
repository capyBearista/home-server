#!/bin/bash
# ---------------------------------------------------------
# PRE-BACKUP DATABASE DUMP SCRIPT
# Purpose: Export databases to static files before Backrest runs
# ---------------------------------------------------------

# 1. Define Dump Locations
BACKUP_ROOT="/path/to/your/docker/backups/databases"
mkdir -p "$BACKUP_ROOT"

PAPERLESS_DUMP="$BACKUP_ROOT/paperless_dump.sql"
IMMICH_DUMP="$BACKUP_ROOT/immich_dump.sql"
NPM_DUMP="$BACKUP_ROOT/npm_dump.sql"
TANDOOR_DUMP="$BACKUP_ROOT/tandoor_dump.sql"

# ---------------------------------------------------------
# 2. Execution (with Error Handling)
# ---------------------------------------------------------

log_msg() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log_msg "Starting Database Dumps..."

# --- Paperless-ngx ---
if docker ps | grep -q paperless-db-1; then
    log_msg "Dumping Paperless..."
    docker exec paperless-db-1 pg_dump -U paperless paperless > "$PAPERLESS_DUMP" || log_msg "ERROR: Paperless dump failed!"
else
    log_msg "WARNING: Paperless DB container not running."
fi

# --- Immich ---
if docker ps | grep -q immich_postgres; then
    log_msg "Dumping Immich..."
    docker exec immich_postgres pg_dumpall -U postgres > "$IMMICH_DUMP" || log_msg "ERROR: Immich dump failed!"
else
    log_msg "WARNING: Immich DB container not running."
fi

# --- NPMplus ---
if docker ps | grep -q npmplus-db; then
    log_msg "Dumping NPMplus..."
    docker exec npmplus-db mariadb-dump -u root --password='your-root-password' npm > "$NPM_DUMP" || log_msg "ERROR: NPMplus dump failed!"
else
    log_msg "WARNING: NPMplus DB container not running."
fi

# --- Tandoor ---
if docker ps | grep -q tandoor-db_recipes-1; then
    log_msg "Dumping Tandoor..."
    docker exec -e PGPASSWORD="your-db-password" tandoor-db_recipes-1 pg_dump -U your-db-user your-db-name > "$TANDOOR_DUMP" || log_msg "ERROR: Tandoor dump failed!"
else
    log_msg "WARNING: Tandoor DB container not running."
fi

# ---------------------------------------------------------
# 3. Security & Cleanup
# ---------------------------------------------------------

# Set permissions to 600 (Read/Write for owner ONLY)
chmod 600 "$BACKUP_ROOT"/*.sql

log_msg "Database dumps completed."
