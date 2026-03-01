#!/bin/bash
# Daily backup of Paperless data volume to external drive
# Uses rsync for fast incremental backups

set -euo pipefail

# Configuration
BACKUP_DEST="/path/to/your/backup/paperless/data"
PAPERLESS_DIR="/path/to/your/docker/paperless"
LOG_FILE="/path/to/your/scripts/logs/paperless-backup.log"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Function to log messages
log() {
    echo "[$TIMESTAMP] $1" | tee -a "$LOG_FILE"
}

log "Starting Paperless data backup..."

# Create backup directory if it doesn't exist
if [ ! -d "$BACKUP_DEST" ]; then
    log "Creating backup directory: $BACKUP_DEST"
    mkdir -p "$BACKUP_DEST"
fi

# Verify external drive is mounted
if ! mountpoint -q /mnt/external_drive; then
    log "ERROR: External drive not mounted at /mnt/external_drive"
    exit 1
fi

# Backup the data volume using rsync via Docker
log "Syncing data volume to external drive..."

docker run --rm \
    -v paperless_data:/source:ro \
    -v "$BACKUP_DEST":/backup \
    alpine \
    sh -c "apk add --no-cache rsync && \
           rsync -av --delete \
           --exclude='*.log' \
           --exclude='*.lock' \
           /source/ /backup/" >> "$LOG_FILE" 2>&1

RSYNC_EXIT=$?

if [ $RSYNC_EXIT -eq 0 ]; then
    log "Backup completed successfully"

    # Create a timestamp file to track last backup
    echo "$TIMESTAMP" > "$BACKUP_DEST/.last_backup"

    # Backup PostgreSQL database too
    log "Backing up PostgreSQL database..."
    cd "$PAPERLESS_DIR"
    docker compose exec -T db pg_dumpall -U paperless | \
        gzip > "$BACKUP_DEST/postgres_backup_$(date +%Y%m%d).sql.gz"

    # Keep only last 7 days of SQL backups
    find "$BACKUP_DEST" -name "postgres_backup_*.sql.gz" -mtime +7 -delete

    log "Database backup completed"
else
    log "ERROR: Backup failed with exit code $RSYNC_EXIT"
    exit 1
fi

# Display backup size
BACKUP_SIZE=$(du -sh "$BACKUP_DEST" | cut -f1)
log "Total backup size: $BACKUP_SIZE"

log "All backups completed successfully"
